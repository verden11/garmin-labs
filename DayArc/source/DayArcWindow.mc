import Toybox.Lang;

// Which of the four windows a clock time falls in, and how far through it. Pure functions, no
// watch calls, so both are fully covered by DayArcWindowTest without a device or simulator data
// source.
class DayArcWindow {
    static function windowFor(hour as Number, minute as Number) as Number {
        var minuteOfDay = hour * DayArcConfig.MINUTES_PER_HOUR + minute;
        if (minuteOfDay >= DayArcConfig.MORNING_START && minuteOfDay < DayArcConfig.MIDDAY_START) {
            return DayArcConfig.WINDOW_MORNING;
        }
        if (minuteOfDay >= DayArcConfig.MIDDAY_START && minuteOfDay < DayArcConfig.EVENING_START) {
            return DayArcConfig.WINDOW_MIDDAY;
        }
        if (minuteOfDay >= DayArcConfig.EVENING_START && minuteOfDay < DayArcConfig.NIGHT_START) {
            return DayArcConfig.WINDOW_EVENING;
        }
        return DayArcConfig.WINDOW_NIGHT;
    }

    // Fraction elapsed through the CURRENT window only (ADR-013's arc, not TwoSuns's 24h ring).
    // Undefined/0.0 for night — callers must not draw an arc for night in the first place.
    static function progressFor(hour as Number, minute as Number) as Float {
        var minuteOfDay = hour * DayArcConfig.MINUTES_PER_HOUR + minute;
        var window = windowFor(hour, minute);
        var start = DayArcConfig.MORNING_START;
        var end = DayArcConfig.MIDDAY_START;
        if (window == DayArcConfig.WINDOW_MIDDAY) {
            start = DayArcConfig.MIDDAY_START;
            end = DayArcConfig.EVENING_START;
        } else if (window == DayArcConfig.WINDOW_EVENING) {
            start = DayArcConfig.EVENING_START;
            end = DayArcConfig.NIGHT_START;
        } else if (window == DayArcConfig.WINDOW_NIGHT) {
            return 0.0;
        }
        return (minuteOfDay - start).toFloat() / (end - start);
    }
}
