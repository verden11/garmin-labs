import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// "Now" on the wearer's wall clock, read in one go so a midnight rollover can never split the date from
// the time of day. `offsetMinutes` is the local offset from UTC, derived from the clock itself rather
// than from System.getClockTime().timeZoneOffset (docs/spec.md "Local offset").
class TwoSunsLocalTime {
    var year as Number;
    var month as Number;
    var day as Number;
    var minuteOfDay as Number;
    var offsetMinutes as Number;
    var epoch as Number;   // seconds since 1970 (Time.now().value())

    function initialize(year as Number, month as Number, day as Number, minuteOfDay as Number, offsetMinutes as Number, epoch as Number) {
        self.year = year;
        self.month = month;
        self.day = day;
        self.minuteOfDay = minuteOfDay;
        self.offsetMinutes = offsetMinutes;
        self.epoch = epoch;
    }

    static function now() as TwoSunsLocalTime {
        var moment = Time.now();
        var local = Gregorian.info(moment, Time.FORMAT_SHORT);
        var utc = Gregorian.utcInfo(moment, Time.FORMAT_SHORT);
        var localMinute = local.hour * TwoSunsConfig.MINUTES_PER_HOUR + local.min;
        var utcMinute = utc.hour * TwoSunsConfig.MINUTES_PER_HOUR + utc.min;
        var offset = offsetBetween(TwoSunsCalendar.dayNumber(local.year, local.month as Number, local.day), localMinute,
                                   TwoSunsCalendar.dayNumber(utc.year, utc.month as Number, utc.day), utcMinute);
        return new TwoSunsLocalTime(local.year, local.month as Number, local.day, localMinute, offset, moment.value());
    }

    // Local minus UTC, in minutes, from the two readings of the same instant. The day numbers are compared
    // as well as the times of day, so +14:00 and -10:00 (which show the same clock time 24 hours apart) cannot
    // be mixed up, and no offset is ever wrapped into a wrong one.
    static function offsetBetween(localDay as Number, localMinute as Number, utcDay as Number, utcMinute as Number) as Number {
        return (localDay - utcDay) * TwoSunsConfig.MINUTES_PER_DAY + localMinute - utcMinute;
    }

    function dayNumber() as Number {
        return TwoSunsCalendar.dayNumber(year, month, day);
    }

    // The date after this one (for tomorrow's sunrise): [year, month, day].
    function tomorrow() as Array<Number> {
        return TwoSunsCalendar.fromDayNumber(dayNumber() + 1);
    }
}
