import Toybox.Lang;
import Toybox.Test;

// The weather row's pure parts (docs/decisions.md ADR-022, Weather row in Pro): the condition icons, the row
// the plan builds from Garmin's numbers, and the rules that keep it honest. Pro only: Free has no weather.
// Times: 2026-09-30 in UTC+1, `now(minute)` the matching epoch seconds; hourly entries start at the current local hour.
(:test)
class TwoSunsWeatherCase {
    static const MINUTE = 14 * 60 + 20;
    static const OFFSET = 60;

    // The epoch of 2026-09-30 at this local minute in UTC+1, so the date and the epoch agree.
    (:pro)
    static function now(minuteOfDay as Number) as Number {
        return TwoSunsCalendar.dayNumber(2026, 9, 30) * TwoSunsConfig.SECONDS_PER_DAY
            + (minuteOfDay - OFFSET) * TwoSunsConfig.SECONDS_PER_MINUTE;
    }

    (:pro)
    static function time(minuteOfDay as Number) as TwoSunsLocalTime {
        return new TwoSunsLocalTime(2026, 9, 30, minuteOfDay, OFFSET, now(minuteOfDay));
    }

    (:pro)
    static function sameStrings(a as Array<String>, b as Array<String>) as Boolean {
        if (a.size() != b.size()) {
            return false;
        }
        for (var i = 0; i < a.size(); i++) {
            if (!a[i].equals(b[i])) {
                return false;
            }
        }
        return true;
    }

    (:pro)
    static function sameNumbers(a as Array<Number>, b as Array<Number>) as Boolean {
        if (a.size() != b.size()) {
            return false;
        }
        for (var i = 0; i < a.size(); i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    // Twelve hourly entries from the start of the current local hour; conditions rotate through three.
    (:pro)
    static function data(minuteOfDay as Number) as TwoSunsWeatherData {
        var data = new TwoSunsWeatherData();
        data.condition = Toybox.Weather.CONDITION_PARTLY_CLOUDY;
        data.feels = 14.6;
        data.temperature = 17;
        data.observed = now(minuteOfDay) - 600;
        var conditions = [Toybox.Weather.CONDITION_PARTLY_CLOUDY, Toybox.Weather.CONDITION_CLOUDY, Toybox.Weather.CONDITION_RAIN] as Array<Number>;
        var first = now(minuteOfDay) - (minuteOfDay % TwoSunsConfig.MINUTES_PER_HOUR) * TwoSunsConfig.SECONDS_PER_MINUTE;
        for (var i = 0; i < 12; i++) {
            data.hourTimes.add(first + i * TwoSunsConfig.SECONDS_PER_HOUR);
            data.hourConditions.add(conditions[i % conditions.size()]);
        }
        return data;
    }

    // Local noon of today and tomorrow, as daily entries (high, low, condition).
    (:pro)
    static function addDays(data as TwoSunsWeatherData, minuteOfDay as Number) as Void {
        var noon = now(minuteOfDay) + (TwoSunsConfig.NOON_MINUTE - minuteOfDay) * TwoSunsConfig.SECONDS_PER_MINUTE;
        data.dayTimes = [noon, noon + TwoSunsConfig.SECONDS_PER_DAY] as Array<Number>;
        data.dayConditions = [Toybox.Weather.CONDITION_RAIN, Toybox.Weather.CONDITION_CLEAR] as Array<Number or Null>;
        data.dayHighs = [18, 21.4f] as Array<Numeric or Null>;
        data.dayLows = [11, 12.6f] as Array<Numeric or Null>;
    }

    (:pro)
    static function sky(state as Number, lightLeft as Number or Null) as TwoSunsSky {
        var sky = new TwoSunsSky();
        sky.state = state;
        sky.lightLeft = lightLeft;
        return sky;
    }

    (:pro)
    static function build(data as TwoSunsWeatherData, minuteOfDay as Number, state as Number, lightLeft as Number or Null) as TwoSunsWeather or Null {
        return TwoSunsWeatherPlan.build(data, time(minuteOfDay), sky(state, lightLeft), true, false, ["Wed", "Thu"] as Array<String>);
    }
}

(:test, :pro)
function weatherKindFoldsConditions(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_CLEAR), TwoSunsConfig.WEATHER_CLEAR);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_MOSTLY_CLEAR), TwoSunsConfig.WEATHER_CLEAR);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_PARTLY_CLEAR), TwoSunsConfig.WEATHER_PARTLY);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_MOSTLY_CLOUDY), TwoSunsConfig.WEATHER_CLOUDY);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_DRIZZLE), TwoSunsConfig.WEATHER_RAIN);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_THUNDERSTORMS), TwoSunsConfig.WEATHER_STORM);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_HAIL), TwoSunsConfig.WEATHER_SNOW);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_MIST), TwoSunsConfig.WEATHER_FOG);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_FAIR), TwoSunsConfig.WEATHER_CLEAR);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_THIN_CLOUDS), TwoSunsConfig.WEATHER_PARTLY);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN), TwoSunsConfig.WEATHER_RAIN);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_FREEZING_RAIN), TwoSunsConfig.WEATHER_RAIN);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_HURRICANE), TwoSunsConfig.WEATHER_STORM);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_FLURRIES), TwoSunsConfig.WEATHER_SNOW);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_SLEET), TwoSunsConfig.WEATHER_SNOW);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_HAZE), TwoSunsConfig.WEATHER_FOG);
    return true;
}

// A condition with no icon (windy), an unknown number and null are never guessed.
(:test, :pro)
function weatherKindNeverGuesses(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_WINDY), TwoSunsConfig.WEATHER_NONE);
    Test.assertEqual(TwoSunsWeatherKind.kind(Toybox.Weather.CONDITION_UNKNOWN), TwoSunsConfig.WEATHER_NONE);
    Test.assertEqual(TwoSunsWeatherKind.kind(9999), TwoSunsConfig.WEATHER_NONE);
    Test.assertEqual(TwoSunsWeatherKind.kind(null), TwoSunsConfig.WEATHER_NONE);
    return true;
}

// The lead cell is the feels-like number (rounded), three ahead cells sit at even steps to sunset: at 14:20 with
// 4:52 of light left the steps are 97, 194 and 292 minutes, which are the 16:00, 18:00 and 19:00 entries.
(:test, :pro)
function weatherDayRowIsFeelsLikeAndThreeAheadCells(logger as Test.Logger) as Boolean {
    var weather = TwoSunsWeatherCase.build(TwoSunsWeatherCase.data(TwoSunsWeatherCase.MINUTE), TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 292) as TwoSunsWeather;
    Test.assert(!weather.nextDay);
    Test.assertEqual(weather.leadKind, TwoSunsConfig.WEATHER_PARTLY);
    Test.assertEqual(weather.leadText, "15" + TwoSunsConfig.DEGREE_CODE.toChar().toString());
    Test.assert(TwoSunsWeatherCase.sameStrings(weather.aheadLabels, ["16:00", "18:00", "19:00"] as Array<String>));
    Test.assert(TwoSunsWeatherCase.sameNumbers(weather.aheadKinds, [TwoSunsConfig.WEATHER_RAIN, TwoSunsConfig.WEATHER_CLOUDY, TwoSunsConfig.WEATHER_RAIN] as Array<Number>));
    return true;
}

// No feels-like number: the temperature stands in. Neither: no number, the icon still shows.
(:test, :pro)
function weatherLeadFallsBackToTheTemperature(logger as Test.Logger) as Boolean {
    var data = TwoSunsWeatherCase.data(TwoSunsWeatherCase.MINUTE);
    data.feels = null;
    var weather = TwoSunsWeatherCase.build(data, TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 292) as TwoSunsWeather;
    Test.assertEqual(weather.leadText, "17" + TwoSunsConfig.DEGREE_CODE.toChar().toString());
    data.temperature = null;
    weather = TwoSunsWeatherCase.build(data, TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 292) as TwoSunsWeather;
    Test.assertEqual(weather.leadText, "");
    Test.assertEqual(weather.leadKind, TwoSunsConfig.WEATHER_PARTLY);
    return true;
}

// A reading older than 3 hours is not shown; the ahead cells stay. Nothing at all is null, not an empty row.
(:test, :pro)
function weatherStaleObservationHidesTheLeadOnly(logger as Test.Logger) as Boolean {
    var data = TwoSunsWeatherCase.data(TwoSunsWeatherCase.MINUTE);
    data.observed = TwoSunsWeatherCase.now(TwoSunsWeatherCase.MINUTE) - TwoSunsConfig.WEATHER_OBSERVATION_MAX_SECONDS - 1;
    var weather = TwoSunsWeatherCase.build(data, TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 292) as TwoSunsWeather;
    Test.assert(!weather.hasLead());
    Test.assertEqual(weather.aheadKinds.size(), 3);
    Test.assert(TwoSunsWeatherCase.build(new TwoSunsWeatherData(), TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 292) == null);
    return true;
}

// An hourly entry whose hour ended before now is old and is not used.
(:test, :pro)
function weatherOldHourlyEntriesAreNotUsed(logger as Test.Logger) as Boolean {
    var data = TwoSunsWeatherCase.data(TwoSunsWeatherCase.MINUTE);
    for (var i = 0; i < data.hourTimes.size(); i++) {
        data.hourTimes[i] = data.hourTimes[i] - 12 * TwoSunsConfig.SECONDS_PER_HOUR;   // all twelve are in the past
    }
    var weather = TwoSunsWeatherCase.build(data, TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 292) as TwoSunsWeather;
    Test.assertEqual(weather.aheadKinds.size(), 0);
    return true;
}

// The light left unknown ("Sun is up") spaces the steps over six hours; a short evening collapses steps that land on the same entry.
(:test, :pro)
function weatherStepsNeverRepeatAnEntry(logger as Test.Logger) as Boolean {
    var data = TwoSunsWeatherCase.data(TwoSunsWeatherCase.MINUTE);
    var short = TwoSunsWeatherCase.build(data, TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, 30) as TwoSunsWeather;
    Test.assert(TwoSunsWeatherCase.sameStrings(short.aheadLabels, ["14:00", "15:00"] as Array<String>));   // three steps, two distinct entries
    var unknown = TwoSunsWeatherCase.build(data, TwoSunsWeatherCase.MINUTE, TwoSunsConfig.SKY_DAY, null) as TwoSunsWeather;
    Test.assert(TwoSunsWeatherCase.sameStrings(unknown.aheadLabels, ["16:00", "18:00", "20:00"] as Array<String>));
    return true;
}

// After sunset the row is tomorrow: the daily entry for the next local day, its high and low, and only the hours
// the hourly list reaches (it reaches about 12 hours, so none of 10, 13 and 16 o'clock at 21:40).
(:test, :pro)
function weatherAfterSunsetIsTomorrow(logger as Test.Logger) as Boolean {
    var minute = 21 * 60 + 40;
    var data = TwoSunsWeatherCase.data(minute);
    TwoSunsWeatherCase.addDays(data, minute);
    var weather = TwoSunsWeatherCase.build(data, minute, TwoSunsConfig.SKY_AFTER_SUNSET, null) as TwoSunsWeather;
    var degree = TwoSunsConfig.DEGREE_CODE.toChar().toString();
    Test.assert(weather.nextDay);
    Test.assertEqual(weather.dayLabel, "Thu");
    Test.assertEqual(weather.leadKind, TwoSunsConfig.WEATHER_CLEAR);
    Test.assertEqual(weather.leadText, "21" + degree);
    Test.assertEqual(weather.lowText, "13" + degree);
    Test.assertEqual(weather.aheadKinds.size(), 0);
    return true;
}

// Before sunrise the row is today: its label is today's weekday and the hourly list reaches 10, 13 and 16 o'clock.
(:test, :pro)
function weatherBeforeSunriseIsTodayWithItsHours(logger as Test.Logger) as Boolean {
    var minute = 5 * 60 + 10;
    var data = TwoSunsWeatherCase.data(minute);
    TwoSunsWeatherCase.addDays(data, minute);
    var weather = TwoSunsWeatherCase.build(data, minute, TwoSunsConfig.SKY_BEFORE_SUNRISE, null) as TwoSunsWeather;
    Test.assert(weather.nextDay);
    Test.assertEqual(weather.dayLabel, "");   // before sunrise it is today: no chevron, the date row has the weekday
    Test.assertEqual(weather.leadKind, TwoSunsConfig.WEATHER_RAIN);
    Test.assert(TwoSunsWeatherCase.sameStrings(weather.aheadLabels, ["10:00", "13:00", "16:00"] as Array<String>));
    return true;
}

// After sunset the next day stands alone even when the hourly list reaches its hours: at 23:50 the list runs to
// about 11:50, past 10:00, and still no hour cell is added (an hour beside the high and low read as a temperature).
(:test, :pro)
function weatherAfterSunsetHasNoHourCells(logger as Test.Logger) as Boolean {
    var minute = 23 * 60 + 50;
    var data = TwoSunsWeatherCase.data(minute);
    TwoSunsWeatherCase.addDays(data, minute);
    var weather = TwoSunsWeatherCase.build(data, minute, TwoSunsConfig.SKY_AFTER_SUNSET, null) as TwoSunsWeather;
    Test.assert(weather.nextDay);
    Test.assertEqual(weather.aheadKinds.size(), 0);
    Test.assertEqual(weather.aheadLabels.size(), 0);
    return true;
}

// Without Garmin's daily entry for that day the next-day row is not drawn at all.
(:test, :pro)
function weatherNextDayNeedsADailyEntry(logger as Test.Logger) as Boolean {
    var minute = 21 * 60 + 40;
    Test.assert(TwoSunsWeatherCase.build(TwoSunsWeatherCase.data(minute), minute, TwoSunsConfig.SKY_AFTER_SUNSET, null) == null);
    return true;
}

// Whole degrees in the watch's unit; a value that rounds to zero never reads "-0".
(:test, :pro)
function weatherDegreesRoundAndConvert(logger as Test.Logger) as Boolean {
    var sign = TwoSunsConfig.DEGREE_CODE.toChar().toString();
    Test.assertEqual(TwoSunsWeatherPlan.degrees(14.5, false), "15" + sign);
    Test.assertEqual(TwoSunsWeatherPlan.degrees(-0.3, false), "0" + sign);
    Test.assertEqual(TwoSunsWeatherPlan.degrees(-12, false), "-12" + sign);
    Test.assertEqual(TwoSunsWeatherPlan.degrees(0, true), "32" + sign);
    Test.assertEqual(TwoSunsWeatherPlan.degrees(40, true), "104" + sign);
    Test.assertEqual(TwoSunsWeatherPlan.degrees(null, true), "");
    return true;
}

// The hour label: 24-hour clocks two digits and ":00" (09:00); 12-hour clocks no leading zero, "a" or "p", 12 for midnight and noon.
(:test, :pro)
function weatherHourLabels(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsWeatherPlan.hourText(9 * 60 + 30, true), "09:00");
    Test.assertEqual(TwoSunsWeatherPlan.hourText(16 * 60, false), "4p");
    Test.assertEqual(TwoSunsWeatherPlan.hourText(0, false), "12a");
    Test.assertEqual(TwoSunsWeatherPlan.hourText(12 * 60, false), "12p");
    Test.assertEqual(TwoSunsWeatherPlan.hourText(25 * 60, true), "01:00");   // past midnight wraps
    Test.assertEqual(TwoSunsWeatherPlan.hourText(9 * 60 + 30, false), "9a");
    Test.assertEqual(TwoSunsWeatherPlan.hourText(23 * 60, false), "11p");
    return true;
}

// No accent may be, or dim to, a weather hue: the weather icons must never read as the accent.
(:test, :color, :pro)
function noAccentIsAWeatherHue(logger as Test.Logger) as Boolean {
    var hues = [TwoSunsPalette.WEATHER_SUN, TwoSunsPalette.WEATHER_RAIN] as Array<Number>;
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        for (var j = 0; j < hues.size(); j++) {
            Test.assertNotEqual(TwoSunsPalette.ACCENTS[i], hues[j]);
            Test.assertNotEqual(TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[i]), hues[j]);
        }
    }
    for (var j = 0; j < hues.size(); j++) {
        for (var shift = 0; shift <= 16; shift += 8) {
            var channel = (hues[j] >> shift) & 0xFF;
            Test.assert(channel == 0x00 || channel == 0x55 || channel == 0xAA || channel == 0xFF);   // 64-colour safe
        }
    }
    Test.assertEqual(TwoSunsPalette.WEATHER_NUMBER, TwoSunsPalette.WEATHER_SUN);   // one hue for the number, whatever the condition
    return true;
}

// Nothing back from Garmin is not a reading: an empty data set says so, so the source keeps the last good one.
(:test, :pro)
function weatherEmptyDataIsNotAReading(logger as Test.Logger) as Boolean {
    Test.assert(new TwoSunsWeatherData().isEmpty());
    var data = new TwoSunsWeatherData();
    data.temperature = 3;
    Test.assert(!data.isEmpty());
    return true;
}

// Daily stamps at UTC midnight (the simulator's form) name their UTC date, so a wearer west of Greenwich still gets the
// right day: at 21:00 on 30 September in UTC-5 it is already 1 October in UTC, and tomorrow is the 1 October entry.
(:test, :pro)
function weatherUtcMidnightStampsMatchTheirOwnDate(logger as Test.Logger) as Boolean {
    var today = TwoSunsCalendar.dayNumber(2026, 9, 30);
    var time = new TwoSunsLocalTime(2026, 9, 30, 21 * 60, -300, today * TwoSunsConfig.SECONDS_PER_DAY + 26 * TwoSunsConfig.SECONDS_PER_HOUR);
    var data = new TwoSunsWeatherData();
    data.dayTimes = [today * TwoSunsConfig.SECONDS_PER_DAY, (today + 1) * TwoSunsConfig.SECONDS_PER_DAY, (today + 2) * TwoSunsConfig.SECONDS_PER_DAY] as Array<Number>;
    Test.assertEqual(TwoSunsWeatherPlan.dayIndex(data, time, today), 0);
    Test.assertEqual(TwoSunsWeatherPlan.dayIndex(data, time, today + 1), 1);
    Test.assertEqual(TwoSunsWeatherPlan.dayIndex(data, time, today + 9), -1);
    return true;
}
