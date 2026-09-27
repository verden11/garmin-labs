import Toybox.Lang;

// Calendar arithmetic on whole days. Nothing here touches Time.Moment, time
// zones or DST: a date is (year, month, day) and a day count is an integer,
// so a date can only be wrong if its inputs are.
class TwoSunsCalendar {

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
        return year >= TwoSunsConfig.FIRST_YEAR && year <= TwoSunsConfig.LAST_YEAR
            && month >= 1 && month <= 12
            && day >= 1 && day <= daysInMonth(year, month);
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

    // The inverse of dayNumber: [year, month, day] for a day count (valid from 1970-01-01 on).
    static function fromDayNumber(number as Number) as Array<Number> {
        var z = number + 719468;
        var era = z / 146097;
        var dayOfEra = z - era * 146097;
        var yoe = (dayOfEra - dayOfEra / 1460 + dayOfEra / 36524 - dayOfEra / 146096) / 365;
        var dayOfYear = dayOfEra - (365 * yoe + yoe / 4 - yoe / 100);
        var monthFromMarch = (5 * dayOfYear + 2) / 153;
        var day = dayOfYear - (153 * monthFromMarch + 2) / 5 + 1;
        var month = monthFromMarch < 10 ? monthFromMarch + 3 : monthFromMarch - 9;
        var year = yoe + era * 400 + (month <= 2 ? 1 : 0);
        return [year, month, day] as Array<Number>;
    }
}
