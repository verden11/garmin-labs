import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

// Reads Garmin's cached weather (Toybox.Weather: no permission) and hands it to the plan (docs/decisions.md ADR-022,
// Weather row in Pro). Re-read at most every 5 minutes. Weather is named in full and not imported; Free has no weather
// and none of this is compiled into it.
(:pro)
class TwoSunsWeatherSource {
    private var _data as TwoSunsWeatherData or Null = null;
    private var _at as Number = 0;

    // The row for now, or null when this watch has no weather or Garmin gave nothing usable.
    function row(time as TwoSunsLocalTime, sky as TwoSunsSky) as TwoSunsWeather or Null {
        var data = cached(time.epoch);
        if (data == null) {
            return null;
        }
        var device = System.getDeviceSettings();
        return TwoSunsWeatherPlan.build(data, time, sky, device.is24Hour, device.temperatureUnits == System.UNIT_STATUTE,
                                        [weekdayAt(time, 0), weekdayAt(time, 1)] as Array<String>);
    }

    // The weekday, in the watch's language, of local noon `dayOffset` days from now (noon, so no clock change can move it).
    private static function weekdayAt(time as TwoSunsLocalTime, dayOffset as Number) as String {
        var noon = time.epoch + (TwoSunsConfig.NOON_MINUTE + dayOffset * TwoSunsConfig.MINUTES_PER_DAY - time.minuteOfDay) * TwoSunsConfig.SECONDS_PER_MINUTE;
        return Gregorian.info(new Time.Moment(noon), Time.FORMAT_MEDIUM).day_of_week as String;
    }

    private function cached(epoch as Number) as TwoSunsWeatherData or Null {
        if (_data != null && epoch - _at < TwoSunsConfig.WEATHER_REFRESH_SECONDS && epoch >= _at) {
            return _data;
        }
        var fresh = readWeather();
        if (fresh != null) {
            _data = fresh;   // a failed or empty read keeps the last good data; the plan's own age rules drop what has aged out
        }
        _at = epoch;
        return _data;
    }

    private function readWeather() as TwoSunsWeatherData or Null {
        if (!(Toybox has :Weather)) {
            return null;
        }
        try {
            var data = new TwoSunsWeatherData();
            readCurrent(data);
            readHourly(data);
            readDaily(data);
            return data.isEmpty() ? null : data;
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    private static function readCurrent(data as TwoSunsWeatherData) as Void {
        var now = Toybox.Weather.getCurrentConditions();
        if (now != null) {
            data.condition = now.condition;
            data.feels = now.feelsLikeTemperature;
            data.temperature = now.temperature;
            var observed = now.observationTime;
            data.observed = observed == null ? null : observed.value();
        }
    }

    private static function readHourly(data as TwoSunsWeatherData) as Void {
        var hours = Toybox.Weather.getHourlyForecast();
        for (var i = 0; hours != null && i < hours.size(); i++) {
            var at = hours[i].forecastTime;
            if (at != null) {
                data.hourTimes.add(at.value());
                data.hourConditions.add(hours[i].condition);
            }
        }
    }

    private static function readDaily(data as TwoSunsWeatherData) as Void {
        var days = Toybox.Weather.getDailyForecast();
        for (var i = 0; days != null && i < days.size(); i++) {
            var at = days[i].forecastTime;
            if (at != null) {
                data.dayTimes.add(at.value());
                data.dayConditions.add(days[i].condition);
                data.dayHighs.add(days[i].highTemperature);
                data.dayLows.add(days[i].lowTemperature);
            }
        }
    }
}
