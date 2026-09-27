import Toybox.Activity;
import Toybox.Application;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.Position;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;

// The one class that touches the watch: the clock, Garmin's sunrise, sunset and Body Battery
// (Complications), the Body Battery history, and the location sources. Everything it hands on is
// decided by pure, tested classes. Each source is guarded, so a watch without it just gives null
// and the face says so in words (never a blank, never a crash).
class TwoSunsSources {
    private var _place as Array<Float> or Null;
    private var _curve as TwoSunsBatteryCurve or Null = null;
    private var _curveAt as Number = 0;
    private var _sunDay as Number = -1;
    private var _sunPlace as Array<Float> or Null = null;
    private var _sunOffset as Number = 0;
    private var _sun as Array<TwoSunsSunDay> = [] as Array<TwoSunsSunDay>;

    function initialize() {
        _place = TwoSunsPlace.fromStorage(Application.Storage.getValue(TwoSunsConfig.KEY_PLACE));
    }

    // One state for one redraw.
    function read(settings as TwoSunsSettings) as TwoSunsState {
        var time = TwoSunsLocalTime.now();
        var place = updatePlace();
        var days = sunDays(time, place);
        var hasComplications = Toybox has :Complications;
        var sky = TwoSunsSky.resolve(time.minuteOfDay, complicationNumber(Complications.COMPLICATION_TYPE_SUNRISE),
                                     complicationNumber(Complications.COMPLICATION_TYPE_SUNSET), hasComplications,
                                     days.size() == 2 ? days[0] : null, days.size() == 2 ? days[1] : null);
        var state = TwoSunsReadings.build(settings, time, System.getDeviceSettings().is24Hour, sky, batteryCurve(time.epoch),
                                          complicationNumber(Complications.COMPLICATION_TYPE_BODY_BATTERY), dateLines(time.epoch));
        return state;
    }

    // A Complication's value when it is a number; null when unavailable, unpublished or not a number.
    static function complicationNumber(type as Complications.Type) as Number or Null {
        if (!(Toybox has :Complications)) {
            return null;
        }
        try {
            var complication = Complications.getComplication(new Complications.Id(type));
            var value = complication == null ? null : complication.value;
            return value instanceof Number ? value : null;
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Body Battery history, rebuilt at most every 5 minutes. Null when this watch has no history.
    function batteryCurve(epoch as Number) as TwoSunsBatteryCurve or Null {
        if (_curve != null && epoch - _curveAt < TwoSunsConfig.BATTERY_REFRESH_SECONDS && epoch >= _curveAt) {
            return _curve;
        }
        _curve = readCurve(epoch);
        _curveAt = epoch;
        return _curve;
    }

    private function readCurve(epoch as Number) as TwoSunsBatteryCurve or Null {
        if (!(Toybox has :SensorHistory) || !(SensorHistory has :getBodyBatteryHistory)) {
            return null;
        }
        try {
            var iterator = SensorHistory.getBodyBatteryHistory({:period => new Time.Duration(TwoSunsConfig.BATTERY_WINDOW_SECONDS)});
            var values = [] as Array<Numeric or Null>;
            var whens = [] as Array<Number or Null>;
            var sample = iterator.next();
            while (sample != null) {
                values.add(sample.data);
                whens.add(sample.when.value());
                sample = iterator.next();
            }
            return TwoSunsBattery.build(values, whens, epoch);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Today's and tomorrow's own sun calculation, recomputed only when the local date, the place or the
    // offset changes. Empty when there is no place.
    private function sunDays(time as TwoSunsLocalTime, place as Array<Float> or Null) as Array<TwoSunsSunDay> {
        if (place == null) {
            return [] as Array<TwoSunsSunDay>;
        }
        var day = time.dayNumber();
        var samePlace = _sunPlace != null && _sunPlace[0] == place[0] && _sunPlace[1] == place[1];
        if (day != _sunDay || !samePlace || time.offsetMinutes != _sunOffset || _sun.size() != 2) {
            var next = time.tomorrow();
            _sun = [TwoSunsSun.compute(time.year, time.month, time.day, place[0], place[1], time.offsetMinutes),
                    TwoSunsSun.compute(next[0], next[1], next[2], place[0], place[1], time.offsetMinutes)] as Array<TwoSunsSunDay>;
            _sunDay = day;
            _sunPlace = place;
            _sunOffset = time.offsetMinutes;
        }
        return _sun;
    }

    // The remembered place, refreshed from the location sources in order (docs/spec.md D7) and saved
    // only when it moved. The saved place is the last resort.
    private function updatePlace() as Array<Float> or Null {
        var fresh = TwoSunsPlace.pick([activityLocation(), weatherLocation(), positionLocation()] as Array<Array<Float> or Null>);
        if (fresh != null && TwoSunsPlace.shouldReplace(_place, fresh)) {
            _place = fresh;
            try {
                Application.Storage.setValue(TwoSunsConfig.KEY_PLACE, [fresh[0], fresh[1]] as Array<Application.Storage.ValueType>);
            } catch (e instanceof Lang.Exception) {
                // A full or failing store only loses the memory; the place still works for this run.
            }
        }
        return _place;
    }

    private static function degrees(location as Position.Location or Null) as Array<Float> or Null {
        if (location == null) {
            return null;
        }
        var pair = location.toDegrees();
        return [pair[0].toFloat(), pair[1].toFloat()] as Array<Float>;
    }

    private static function activityLocation() as Array<Float> or Null {
        try {
            // The SDK types getActivityInfo() as never null (a null check is a compiler warning); if a watch
            // returns null anyway, the call throws and the catch turns it into "no location".
            return degrees(Activity.getActivityInfo().currentLocation);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    private static function weatherLocation() as Array<Float> or Null {
        if (!(Toybox has :Weather)) {
            return null;
        }
        try {
            var conditions = Weather.getCurrentConditions();
            return conditions == null ? null : degrees(conditions.observationLocationPosition);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Needs the Positioning permission (manifest, spec D7: provisional). If that permission is dropped,
    // delete this function and its entry in updatePlace(): calling Position.getInfo() without it kills the app.
    private static function positionLocation() as Array<Float> or Null {
        try {
            return degrees(Position.getInfo().position);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // The words come from the system in the watch's language, for the same instant as the clock read (so a
    // midnight rollover cannot pair one day's date with another's time).
    private static function dateLines(epoch as Number) as Array<String> {
        var info = Gregorian.info(new Time.Moment(epoch), Time.FORMAT_MEDIUM);
        return TwoSunsDateText.lines(info.day_of_week as String, info.day, info.month as String, TwoSunsDateText.monthFirstNow());
    }
}
