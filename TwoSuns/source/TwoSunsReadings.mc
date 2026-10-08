import Toybox.Lang;

// Turns already-read inputs into a TwoSunsState, all in words. Pure: same inputs, same words. The part
// that touches the watch (clock, Complications, Body Battery history, location) is TwoSunsSources.
class TwoSunsReadings {

    static function build(settings as TwoSunsSettings, time as TwoSunsLocalTime, is24Hour as Boolean, sky as TwoSunsSky,
                          curve as TwoSunsBatteryCurve or Null, complicationBattery as Number or Null,
                          dateLines as Array<String>) as TwoSunsState {
        var state = new TwoSunsState();
        state.time = clockText(time.minuteOfDay, is24Hour);
        state.dateLines = dateLines;
        state.showDate = settings.date;
        state.sky = sky;
        state.skyLine = skyLine(sky, is24Hour);
        state.skyLines = skyLines(sky, is24Hour);
        state.nowMinute = time.minuteOfDay;
        state.accent = TwoSunsPalette.accent(settings.accent);
        state.goldenArc = settings.golden;
        state.weatherOn = settings.weather;
        state.orientation = settings.orientation;
        fillBattery(state, curve, complicationBattery, settings.curve);
        return state;
    }

    // Body Battery: the history when the watch has it, Garmin's single number when it does not, "--" when neither.
    // A history with no valid sample (not worn) is "--" too: the number is never invented.
    static function fillBattery(state as TwoSunsState, curve as TwoSunsBatteryCurve or Null, complication as Number or Null,
                                showCurve as Boolean) as Void {
        state.batteryText = TwoSunsText.get(Rez.Strings.value_none);
        state.batteryAccent = state.accent;
        if (curve == null) {
            if (complication != null && TwoSunsBattery.isValidValue(complication)) {
                state.batteryText = complication.toString();
                state.batteryLevel = complication;
                state.batteryAccent = batteryAccentFor(complication, state.accent);
            }
            return;
        }
        var current = curve.current;
        if (current != null) {
            state.batteryText = current.toString();
            state.batteryLevel = current;
            state.batteryStale = curve.stale;
            state.batteryAccent = batteryAccentFor(current, state.accent);
            state.curve = showCurve ? curve : null;
        }
    }

    // dim(accent) below the low threshold, the accent itself at or above it. The same dim the ring uses
    // for daylight already gone, so "dim" carries one meaning across the whole face.
    static function batteryAccentFor(level as Number, accent as Number) as Number {
        return level < TwoSunsConfig.BATTERY_LOW_THRESHOLD ? TwoSunsPalette.dim(accent) : accent;
    }

    // 24 h keeps the leading zero (07:05); 12 h drops it (7:05), like Garmin's own faces. `minuteOfDay` may
    // exceed 1439 (a sunset after midnight); it wraps.
    static function clockText(minuteOfDay as Number, is24Hour as Boolean) as String {
        var wrapped = ((minuteOfDay % TwoSunsConfig.MINUTES_PER_DAY) + TwoSunsConfig.MINUTES_PER_DAY) % TwoSunsConfig.MINUTES_PER_DAY;
        var hour = wrapped / TwoSunsConfig.MINUTES_PER_HOUR;
        var minute = (wrapped % TwoSunsConfig.MINUTES_PER_HOUR).format("%02d");
        if (is24Hour) {
            return hour.format("%02d") + ":" + minute;
        }
        var hours = hour % TwoSunsConfig.HOURS_PER_HALF_DAY;
        return (hours == 0 ? TwoSunsConfig.HOURS_PER_HALF_DAY : hours) + ":" + minute;
    }

    // Minutes of daylight as "3h 42m", or "41m" under an hour: "3:42" read as a clock time (design critique
    // 2026-10-05, ROADMAP 13.17). The letters are resources/strings/units.xml, English for now (ROADMAP 13.7).
    static function durationText(minutes as Number) as String {
        var hours = minutes / TwoSunsConfig.MINUTES_PER_HOUR;
        var rest = minutes % TwoSunsConfig.MINUTES_PER_HOUR;
        var m = TwoSunsText.get(Rez.Strings.unit_minutes);
        if (hours == 0) {
            return rest + m;
        }
        return hours + TwoSunsText.get(Rez.Strings.unit_hours) + " " + rest.format("%02d") + m;
    }

    // The one sentence at the bottom (docs/spec.md "What the face shows"). Every failure has words, not a blank.
    static function skyLine(sky as TwoSunsSky, is24Hour as Boolean) as String {
        return skyText(sky, is24Hour, 0);
    }

    // The sentence in up to three wordings, longest first, for a row whose chord is too narrow for the
    // full one (the sun line sits low on the round screen). Wordings that repeat are listed once.
    static function skyLines(sky as TwoSunsSky, is24Hour as Boolean) as Array<String> {
        var lines = [skyText(sky, is24Hour, 0)] as Array<String>;
        for (var level = 1; level <= TwoSunsConfig.SKY_WORDING_LEVELS; level++) {
            var text = skyText(sky, is24Hour, level);
            if (!text.equals(lines[lines.size() - 1])) {
                lines.add(text);
            }
        }
        return lines;
    }

    // Level 0 is the full sentence, 1 a shorter wording, 2 the shortest. A sentence with no shorter form
    // comes back unchanged.
    static function skyText(sky as TwoSunsSky, is24Hour as Boolean, level as Number) as String {
        var state = sky.state;
        if (state == TwoSunsConfig.SKY_DAY) {
            var left = sky.lightLeft;
            return left == null ? TwoSunsText.get(Rez.Strings.sky_sun_up)
                : TwoSunsText.format(level == 0 ? Rez.Strings.sky_daylight_left : Rez.Strings.sky_daylight_left_short, [durationText(left)]);
        }
        if (state == TwoSunsConfig.SKY_BEFORE_SUNRISE || state == TwoSunsConfig.SKY_AFTER_SUNSET) {
            return sunriseLine(sky, is24Hour, level);
        }
        if (state == TwoSunsConfig.SKY_MIDNIGHT_SUN) {
            return TwoSunsText.get(level == 0 ? Rez.Strings.sky_midnight_sun : (level == 1 ? Rez.Strings.sky_midnight_sun_short : Rez.Strings.sky_midnight_sun_min));
        }
        if (state == TwoSunsConfig.SKY_POLAR_NIGHT) {
            return TwoSunsText.get(level == 0 ? Rez.Strings.sky_polar_night : (level == 1 ? Rez.Strings.sky_polar_night_short : Rez.Strings.sky_polar_night_min));
        }
        return TwoSunsText.get(state == TwoSunsConfig.SKY_NO_PLACE ? Rez.Strings.sky_no_place : Rez.Strings.sky_no_data);
    }

    // Before sunrise or after sunset: the sunrise to expect; when it is unknown, say what is known.
    private static function sunriseLine(sky as TwoSunsSky, is24Hour as Boolean, level as Number) as String {
        var next = sky.nextRise;
        if (next != null) {
            var estimate = sky.nextRiseIsToday;
            var id = estimate ? (level > 0 ? Rez.Strings.sky_sunrise_estimate_short : Rez.Strings.sky_sunrise_estimate)
                : (level > 0 ? Rez.Strings.sky_sunrise_short : Rez.Strings.sky_sunrise);
            return TwoSunsText.format(id, [clockText(next, is24Hour)]);
        }
        if (sky.noNextRise) {
            return TwoSunsText.get(level > 0 ? Rez.Strings.sky_no_sunrise_short : Rez.Strings.sky_no_sunrise);
        }
        var set = sky.set;
        return set == null ? TwoSunsText.get(Rez.Strings.sky_no_data)
            : TwoSunsText.format(level > 0 ? Rez.Strings.sky_sunset_short : Rez.Strings.sky_sunset, [clockText(set, is24Hour)]);
    }
}
