import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// Local-calendar-day math. A "day key" is yyyy*10000 + mm*100 + dd from the
// LOCAL clock, so consecutive calendar days are consecutive integers and DST
// (which shifts epochs by 23h/25h) can never break a streak. Never subtract
// 86400 from epochs here.
class HeroSetCalendar {

    // Local calendar day of the watch, as an integer day key.
    static function todayKey() as Lang.Number {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return fieldKey(info.year, info.month, info.day);
    }

    static function fieldKey(year as Lang.Number, month as Lang.Number, day as Lang.Number) as Lang.Number {
        return year * 10000 + month * 100 + day;
    }

    // True when `today` is the calendar day immediately after `last`.
    // Month rollover, year rollover, and leap days are handled here; epoch
    // arithmetic is never used, so DST boundaries cannot break streaks.
    static function isConsecutiveDate(last as Lang.Number, today as Lang.Number) as Lang.Boolean {
        if (today == last + 1) {
            return true;
        }

        var lastYear = last / 10000;
        var lastMonth = (last % 10000) / 100;
        var lastDay = last % 100;

        // Same-month consecutive days are covered by `today == last + 1`.
        // Only a month-end (or year-end) rollover reaches this code.
        if (lastDay != daysInMonth(lastYear, lastMonth)) {
            return false;
        }

        if (lastMonth == 12) {
            return today == (lastYear + 1) * 10000 + 101;
        }
        return today == lastYear * 10000 + (lastMonth + 1) * 100 + 1;
    }

    static function daysInMonth(year as Lang.Number, month as Lang.Number) as Lang.Number {
        if (month == 2) {
            var leap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
            return leap ? 29 : 28;
        }
        if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        }
        return 31;
    }
}
