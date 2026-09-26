import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// "Now" on the wearer's wall clock, read in one go so a midnight rollover
// can never split the date from the time of day.
class DaysToGoLocalTime {
    var year as Number;
    var month as Number;
    var day as Number;
    var secondOfDay as Number;

    function initialize(year as Number, month as Number, day as Number, secondOfDay as Number) {
        self.year = year;
        self.month = month;
        self.day = day;
        self.secondOfDay = secondOfDay;
    }

    static function now() as DaysToGoLocalTime {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var seconds = info.hour * DaysToGoConfig.SECONDS_PER_HOUR + info.min * 60 + info.sec;
        return new DaysToGoLocalTime(info.year, info.month as Number, info.day, seconds);
    }

    function dayNumber() as Number {
        return DaysToGoCalendar.dayNumber(year, month, day);
    }
}
