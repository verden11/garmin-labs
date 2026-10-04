import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// "Now" on the wearer's wall clock, read in one go so a midnight rollover
// can never split the date from the time of day. offset is the wall clock minus
// UTC at that same instant (seconds, east positive, DST included), read from the
// same Moment so the date, the time and the offset cannot straddle a change.
class DaysToGoLocalTime {
    var year as Number;
    var month as Number;
    var day as Number;
    var secondOfDay as Number;
    var offset as Number;

    function initialize(year as Number, month as Number, day as Number, secondOfDay as Number, offset as Number) {
        self.year = year;
        self.month = month;
        self.day = day;
        self.secondOfDay = secondOfDay;
        self.offset = offset;
    }

    static function now() as DaysToGoLocalTime {
        var moment = Time.now();
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        var utc = Gregorian.utcInfo(moment, Time.FORMAT_SHORT);
        var seconds = secondsOf(info);
        var days = DaysToGoCalendar.dayNumber(info.year, info.month as Number, info.day)
            - DaysToGoCalendar.dayNumber(utc.year, utc.month as Number, utc.day);
        return new DaysToGoLocalTime(info.year, info.month as Number, info.day, seconds,
                                     days * DaysToGoConfig.SECONDS_PER_DAY + seconds - secondsOf(utc));
    }

    private static function secondsOf(info as Gregorian.Info) as Number {
        return info.hour * DaysToGoConfig.SECONDS_PER_HOUR + info.min * DaysToGoConfig.SECONDS_PER_MINUTE + info.sec;
    }

    function dayNumber() as Number {
        return DaysToGoCalendar.dayNumber(year, month, day);
    }
}
