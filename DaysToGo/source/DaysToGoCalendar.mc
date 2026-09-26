import Toybox.Lang;

// Calendar arithmetic on whole days. Nothing here touches Time.Moment, time
// zones or DST: a date is (year, month, day) and a day count is an integer,
// so a countdown can only be wrong if its inputs are.
class DaysToGoCalendar {

    static function isLeap(year as Number) as Boolean {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
    }

    static function daysInMonth(year as Number, month as Number) as Number {
        if (month == 2) {
            return isLeap(year) ? 29 : 28;
        }
        return (month == 4 || month == 6 || month == 9 || month == 11) ? 30 : 31;
    }

    static function isValid(year as Number, month as Number, day as Number) as Boolean {
        return year >= DaysToGoConfig.FIRST_YEAR && year <= DaysToGoConfig.LAST_YEAR
            && month >= 1 && month <= 12
            && day >= 1 && day <= daysInMonth(year, month);
    }

    // 0 = Sunday .. 6 = Saturday. 1970-01-01 was a Thursday.
    static function weekday(year as Number, month as Number, day as Number) as Number {
        return (dayNumber(year, month, day) + DaysToGoConfig.EPOCH_WEEKDAY) % DaysToGoConfig.DAYS_PER_WEEK;
    }

    // Days since 1970-01-01 (proleptic Gregorian). Valid from FIRST_YEAR on,
    // where every division below is on a non-negative number.
    static function dayNumber(year as Number, month as Number, day as Number) as Number {
        var y = month <= 2 ? year - 1 : year;
        var era = y / 400;
        var yoe = y - era * 400;
        var monthFromMarch = month > 2 ? month - 3 : month + 9;
        var dayOfYear = (153 * monthFromMarch + 2) / 5 + day - 1;
        var dayOfEra = yoe * 365 + yoe / 4 - yoe / 100 + dayOfYear;
        return era * 146097 + dayOfEra - 719468;
    }
}
