import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// "Now" on the wearer's wall clock, read in one go so a midnight rollover can never split the date from the time
// of day. `offsetMinutes` is the local offset from UTC, derived from the clock itself rather than from
// System.getClockTime().timeZoneOffset (TwoSuns ADR-012: exact across DST and the +14/-10 hour ambiguity).
(:glance)
class SunWindowLocalTime {
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

    static function now() as SunWindowLocalTime {
        var moment = Time.now();
        var local = Gregorian.info(moment, Time.FORMAT_SHORT);
        var utc = Gregorian.utcInfo(moment, Time.FORMAT_SHORT);
        var localMinute = local.hour * SunWindowConfig.MINUTES_PER_HOUR + local.min;
        var utcMinute = utc.hour * SunWindowConfig.MINUTES_PER_HOUR + utc.min;
        var offset = offsetBetween(SunWindowCalendar.dayNumber(local.year, local.month as Number, local.day), localMinute,
                                   SunWindowCalendar.dayNumber(utc.year, utc.month as Number, utc.day), utcMinute);
        return new SunWindowLocalTime(local.year, local.month as Number, local.day, localMinute, offset, moment.value());
    }

    // Local minus UTC, in minutes, from the two readings of the same instant. The day numbers are compared as well as
    // the times of day, so no offset is ever wrapped into a wrong one.
    static function offsetBetween(localDay as Number, localMinute as Number, utcDay as Number, utcMinute as Number) as Number {
        return (localDay - utcDay) * SunWindowConfig.MINUTES_PER_DAY + localMinute - utcMinute;
    }

    function dayNumber() as Number {
        return SunWindowCalendar.dayNumber(year, month, day);
    }
}
