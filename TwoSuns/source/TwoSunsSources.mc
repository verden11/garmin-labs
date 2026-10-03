import Toybox.Application;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

// The one class that touches the watch: the clock, Garmin's sunrise, sunset and Body Battery
// (Complications), the Body Battery history, and the location sources. Everything it hands on is
// decided by pure, tested classes. Each source is guarded, so a watch without it just gives null
// and the face says so in words (never a blank, never a crash).
//
// Free build (docs/decisions.md ADR-020, Free + Pro ladder): the manifest has ComplicationSubscriber only, so
// the history, the location sources, the remembered place and the date words are all `(:pro)` here and the
// `(:free)` twins return null or an empty list. The compiler enforces it: a call site that needs Positioning or
// SensorHistory does not compile without the permission. Position, SensorHistory, Weather and Activity are not imported
// (an import cannot be annotated, so it would sit in the Free build): their calls, all `(:pro)`, name them in full.
class TwoSunsSources {
    (:pro)
    private var _place as Array<Float> or Null;
    (:pro)
    private var _curve as TwoSunsBatteryCurve or Null = null;
    (:pro)
    private var _curveAt as Number = 0;
    (:pro)
    private var _sunDay as Number = -1;
    (:pro)
    private var _sunPlace as Array<Float> or Null = null;
    (:pro)
    private var _sunOffset as Number = 0;
    (:pro)
    private var _sun as Array<TwoSunsSunDay> = [] as Array<TwoSunsSunDay>;
    (:pro)
    private var _weatherSource as TwoSunsWeatherSource = new TwoSunsWeatherSource();

    (:pro)
    function initialize() {
        _place = TwoSunsPlace.fromStorage(Application.Storage.getValue(TwoSunsConfig.KEY_PLACE));
    }

    // One state for one redraw.
    function read(settings as TwoSunsSettings) as TwoSunsState {
        var time = TwoSunsLocalTime.now();
        var days = sunDays(time);
        var hasComplications = Toybox has :Complications;
        var sky = TwoSunsSky.resolve(time.minuteOfDay, complicationNumber(Complications.COMPLICATION_TYPE_SUNRISE),
                                     complicationNumber(Complications.COMPLICATION_TYPE_SUNSET), hasComplications,
                                     days.size() == 2 ? days[0] : null, days.size() == 2 ? days[1] : null);
        var state = TwoSunsReadings.build(settings, time, System.getDeviceSettings().is24Hour, sky, batteryCurve(time.epoch),
                                          complicationNumber(Complications.COMPLICATION_TYPE_BODY_BATTERY), dateLines(time.epoch));
        state.weather = weatherRow(settings, time, sky);
        state.watchBattery = watchBattery(settings);
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

    // Free has no history (no SensorHistory permission): the Body Battery is Garmin's own number only.
    (:free)
    function batteryCurve(epoch as Number) as TwoSunsBatteryCurve or Null {
        return null;
    }

    // Body Battery history, rebuilt at most every 5 minutes. Null when this watch has no history.
    (:pro)
    function batteryCurve(epoch as Number) as TwoSunsBatteryCurve or Null {
        if (_curve != null && epoch - _curveAt < TwoSunsConfig.BATTERY_REFRESH_SECONDS && epoch >= _curveAt) {
            return _curve;
        }
        _curve = readCurve(epoch);
        _curveAt = epoch;
        return _curve;
    }

    (:pro)
    private function readCurve(epoch as Number) as TwoSunsBatteryCurve or Null {
        if (!(Toybox has :SensorHistory) || !(Toybox.SensorHistory has :getBodyBatteryHistory)) {
            return null;
        }
        try {
            var iterator = Toybox.SensorHistory.getBodyBatteryHistory({:period => new Time.Duration(TwoSunsConfig.BATTERY_WINDOW_SECONDS)});
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

    // Free has no place, so no own calculation: Garmin's sunrise and sunset are the whole sun.
    (:free)
    private function sunDays(time as TwoSunsLocalTime) as Array<TwoSunsSunDay> {
        return [] as Array<TwoSunsSunDay>;
    }

    // Today's and tomorrow's own sun calculation, recomputed only when the local date, the place or the
    // offset changes. Empty when there is no place.
    (:pro)
    private function sunDays(time as TwoSunsLocalTime) as Array<TwoSunsSunDay> {
        var place = updatePlace();
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
    (:pro)
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

    (:pro)
    private static function degrees(location as Toybox.Position.Location or Null) as Array<Float> or Null {
        if (location == null) {
            return null;
        }
        var pair = location.toDegrees();
        return [pair[0].toFloat(), pair[1].toFloat()] as Array<Float>;
    }

    (:pro)
    private static function activityLocation() as Array<Float> or Null {
        try {
            // The SDK types getActivityInfo() as never null (a null check is a compiler warning); if a watch
            // returns null anyway, the call throws and the catch turns it into "no location".
            return degrees(Toybox.Activity.getActivityInfo().currentLocation);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    (:pro)
    private static function weatherLocation() as Array<Float> or Null {
        if (!(Toybox has :Weather)) {
            return null;
        }
        try {
            var conditions = Toybox.Weather.getCurrentConditions();
            return conditions == null ? null : degrees(conditions.observationLocationPosition);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Needs the Positioning permission (manifest, spec D7: provisional). If that permission is dropped,
    // delete this function and its entry in updatePlace(): calling Position.getInfo() without it kills the app.
    (:pro)
    private static function positionLocation() as Array<Float> or Null {
        try {
            return degrees(Toybox.Position.getInfo().position);
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Free has no date row.
    (:free)
    private static function dateLines(epoch as Number) as Array<String> {
        return [] as Array<String>;
    }

    // The words come from the system in the watch's language, for the same instant as the clock read (so a
    // midnight rollover cannot pair one day's date with another's time).
    (:pro)
    private static function dateLines(epoch as Number) as Array<String> {
        var info = Gregorian.info(new Time.Moment(epoch), Time.FORMAT_MEDIUM);
        return TwoSunsDateText.lines(info.day_of_week as String, info.day, info.month as String, TwoSunsDateText.monthFirstNow());
    }

    // Free has no weather.
    (:free)
    private function weatherRow(settings as TwoSunsSettings, time as TwoSunsLocalTime, sky as TwoSunsSky) as TwoSunsWeather or Null {
        return null;
    }

    // The weather row (docs/decisions.md ADR-022, Weather row in Pro): null when the setting is off or Garmin gave nothing.
    (:pro)
    private function weatherRow(settings as TwoSunsSettings, time as TwoSunsLocalTime, sky as TwoSunsSky) as TwoSunsWeather or Null {
        return settings.weather ? _weatherSource.row(time, sky) : null;
    }

    // Free has no watch battery row.
    (:free)
    private function watchBattery(settings as TwoSunsSettings) as Number or Null {
        return null;
    }

    // The watch's own charge, whole percent, when the Battery setting is on.
    (:pro)
    private function watchBattery(settings as TwoSunsSettings) as Number or Null {
        if (!settings.battery) {
            return null;
        }
        var percent = Math.round(System.getSystemStats().battery).toNumber();
        return percent < 0 ? 0 : (percent > TwoSunsConfig.BATTERY_MAX ? TwoSunsConfig.BATTERY_MAX : percent);
    }
}
