import Toybox.Lang;

// Clock times as text: 24 h keeps the leading zero (07:05); 12 h drops it (7:05), like Garmin's own screens. A single time
// ("Opens 7:05") carries no am/pm: the sun is above the line only by day, so it cannot be read the wrong way. A range does
// ("7:05a-4:16p"): without them "7:05-4:16" reads as a window that runs backwards.
class SunWindowClock {
    static const NOON_HOUR = 12;

    // "10:26-16:15" in 24 h, "10:26a-4:15p" in 12 h.
    static function range(open as Number, close as Number, is24Hour as Boolean) as String {
        if (is24Hour) {
            return text(open, true) + "-" + text(close, true);
        }
        return text(open, false) + meridiem(open) + "-" + text(close, false) + meridiem(close);
    }

    static function meridiem(minuteOfDay as Number) as String {
        var wrapped = ((minuteOfDay % SunWindowConfig.MINUTES_PER_DAY) + SunWindowConfig.MINUTES_PER_DAY) % SunWindowConfig.MINUTES_PER_DAY;
        return wrapped / SunWindowConfig.MINUTES_PER_HOUR < NOON_HOUR ? "a" : "p";
    }


    // `minuteOfDay` may fall outside 0..1439 (an edge near midnight at an odd offset); it wraps.
    static function text(minuteOfDay as Number, is24Hour as Boolean) as String {
        var wrapped = ((minuteOfDay % SunWindowConfig.MINUTES_PER_DAY) + SunWindowConfig.MINUTES_PER_DAY) % SunWindowConfig.MINUTES_PER_DAY;
        var hour = wrapped / SunWindowConfig.MINUTES_PER_HOUR;
        var minute = (wrapped % SunWindowConfig.MINUTES_PER_HOUR).format("%02d");
        if (is24Hour) {
            return hour.format("%02d") + ":" + minute;
        }
        var hours = hour % SunWindowConfig.HOURS_PER_HALF_DAY;
        return (hours == 0 ? SunWindowConfig.HOURS_PER_HALF_DAY : hours) + ":" + minute;
    }
}
