import Toybox.Lang;
import Toybox.Math;

// Turns the numbers Garmin's weather gave into the words and icon kinds of the row (docs/decisions.md ADR-022,
// Weather row in Pro). Pure: same inputs, same row. While the sun is up: the now cell is the observed condition
// and the feels-like temperature, and up to three conditions ahead sit at even steps from now to sunset. Before
// sunrise the row is today: its condition, high and low, and the hours that the hourly forecast reaches; after
// sunset it is the next day alone, condition, high and low (ROADMAP 13.40). Anything Garmin did not give is left out, never guessed.
(:pro)
class TwoSunsWeatherPlan {

    // `labels` is the weekday of today and of tomorrow, in the watch's language.
    static function build(data as TwoSunsWeatherData, time as TwoSunsLocalTime, sky as TwoSunsSky, is24Hour as Boolean,
                          fahrenheit as Boolean, labels as Array<String>) as TwoSunsWeather or Null {
        var weather = new TwoSunsWeather();
        var used = [] as Array<Number>;
        if (sky.state == TwoSunsConfig.SKY_BEFORE_SUNRISE || sky.state == TwoSunsConfig.SKY_AFTER_SUNSET) {
            var dayOffset = sky.state == TwoSunsConfig.SKY_AFTER_SUNSET ? 1 : 0;
            fillNextDay(weather, used, data, time, dayOffset, is24Hour, fahrenheit, labels[dayOffset]);
        } else {
            fillToday(weather, used, data, time, sky, is24Hour, fahrenheit);
        }
        return weather.isEmpty() ? null : weather;
    }

    private static function fillToday(weather as TwoSunsWeather, used as Array<Number>, data as TwoSunsWeatherData, time as TwoSunsLocalTime,
                                      sky as TwoSunsSky, is24Hour as Boolean, fahrenheit as Boolean) as Void {
        var observed = data.observed;
        if (observed == null || time.epoch - observed <= TwoSunsConfig.WEATHER_OBSERVATION_MAX_SECONDS) {
            weather.leadKind = TwoSunsWeatherKind.kind(data.condition);
            var feels = data.feels;
            weather.leadText = degrees(feels != null ? feels : data.temperature, fahrenheit);
        }
        var left = sky.lightLeft;
        var span = left == null ? TwoSunsConfig.WEATHER_DEFAULT_SPAN_MINUTES : left;
        for (var step = 1; step <= TwoSunsConfig.WEATHER_AHEAD_CELLS; step++) {
            addAhead(weather, used, data, time, span * step / TwoSunsConfig.WEATHER_AHEAD_CELLS, is24Hour);
        }
    }

    // The next daylight day needs Garmin's daily entry for that local day; without it the row is empty.
    private static function fillNextDay(weather as TwoSunsWeather, used as Array<Number>, data as TwoSunsWeatherData, time as TwoSunsLocalTime,
                                        dayOffset as Number, is24Hour as Boolean, fahrenheit as Boolean, label as String) as Void {
        var index = dayIndex(data, time, time.dayNumber() + dayOffset);
        if (index < 0) {
            return;
        }
        weather.nextDay = true;
        weather.dayLabel = dayOffset == 1 ? label : "";   // the chevron and weekday say "next day"; before sunrise it is today, and the date row has the weekday
        weather.leadKind = TwoSunsWeatherKind.kind(data.dayConditions[index]);
        weather.leadText = degrees(data.dayHighs[index], fahrenheit);
        weather.lowText = degrees(data.dayLows[index], fahrenheit);
        if (dayOffset != 0) {
            return;   // after sunset the row is the next day alone: an hour beside its high and low read as a third temperature (ROADMAP 13.40)
        }
        var hours = TwoSunsConfig.WEATHER_NEXT_DAY_HOURS;
        for (var i = 0; i < hours.size(); i++) {
            addAhead(weather, used, data, time, dayOffset * TwoSunsConfig.MINUTES_PER_DAY + hours[i] * TwoSunsConfig.MINUTES_PER_HOUR - time.minuteOfDay, is24Hour);
        }
    }

    // The daily entry for `day` (days since 1970, as TwoSunsLocalTime.dayNumber); -1 when none. A stamp at exactly UTC
    // midnight (what the simulator gives) names its UTC date, whatever the wearer's offset; any other stamp names the
    // local day it falls in (the FR965 gives local midnight: probe photo 2026-10-03).
    static function dayIndex(data as TwoSunsWeatherData, time as TwoSunsLocalTime, day as Number) as Number {
        for (var i = 0; i < data.dayTimes.size(); i++) {
            var at = data.dayTimes[i];
            var stampDay = at % TwoSunsConfig.SECONDS_PER_DAY == 0 ? at / TwoSunsConfig.SECONDS_PER_DAY
                : (at + time.offsetMinutes * TwoSunsConfig.SECONDS_PER_MINUTE) / TwoSunsConfig.SECONDS_PER_DAY;
            if (stampDay == day) {
                return i;
            }
        }
        return -1;
    }

    // The hourly entry nearest `target` minutes from now, when it is within WEATHER_MATCH_MINUTES, is not one already
    // used and has an icon. An entry whose hour has already ended is old and is not used.
    private static function addAhead(weather as TwoSunsWeather, used as Array<Number>, data as TwoSunsWeatherData, time as TwoSunsLocalTime,
                                     target as Number, is24Hour as Boolean) as Void {
        var best = -1;
        var bestGap = TwoSunsConfig.WEATHER_MATCH_MINUTES + 1;
        for (var i = 0; i < data.hourTimes.size(); i++) {
            var at = data.hourTimes[i];
            var gap = ((at - time.epoch) / TwoSunsConfig.SECONDS_PER_MINUTE - target).abs();
            if (at + TwoSunsConfig.SECONDS_PER_HOUR > time.epoch && gap < bestGap) {
                best = i;
                bestGap = gap;
            }
        }
        if (best < 0 || used.indexOf(best) >= 0) {
            return;
        }
        used.add(best);
        var kind = TwoSunsWeatherKind.kind(data.hourConditions[best]);
        if (kind != TwoSunsConfig.WEATHER_NONE) {
            weather.aheadKinds.add(kind);
            weather.aheadLabels.add(hourText(time.minuteOfDay + (data.hourTimes[best] - time.epoch) / TwoSunsConfig.SECONDS_PER_MINUTE, is24Hour));
        }
    }

    // The local hour of a clock minute (it may be negative or past midnight). On a 12 hour clock, no leading zero and
    // "a" or "p", as Garmin's own hourly view does (10a, 3p), so a late hour is not read as a morning one; on a 24 hour
    // clock two digits and ":00" like the face's own clock (09:00, 16:00), so a bare "16" beside the temperature is not
    // read as one (ROADMAP 13.40).
    static function hourText(minute as Number, is24Hour as Boolean) as String {
        var wrapped = ((minute % TwoSunsConfig.MINUTES_PER_DAY) + TwoSunsConfig.MINUTES_PER_DAY) % TwoSunsConfig.MINUTES_PER_DAY;
        var hour = wrapped / TwoSunsConfig.MINUTES_PER_HOUR;
        if (is24Hour) {
            return hour.format("%02d") + ":00";
        }
        var hours = hour % TwoSunsConfig.HOURS_PER_HALF_DAY;
        return (hours == 0 ? TwoSunsConfig.HOURS_PER_HALF_DAY : hours).toString() + (hour < TwoSunsConfig.HOURS_PER_HALF_DAY ? "a" : "p");
    }

    // A whole degree with the degree sign, in the watch's unit (Garmin gives Celsius); empty when there is no number.
    static function degrees(celsius as Numeric or Null, fahrenheit as Boolean) as String {
        if (celsius == null) {
            return "";
        }
        var value = celsius.toFloat();
        if (fahrenheit) {
            value = value * 9.0 / 5.0 + 32.0;
        }
        return Math.round(value).toNumber().toString() + TwoSunsConfig.DEGREE_CODE.toChar().toString();
    }
}
