import Toybox.Lang;

// One event as the settings describe it. Presets are just events with fixed
// fields, so the countdown has a single code path.
class DaysToGoEvent {
    var month as Number;
    var day as Number;
    var year as Number;   // EVERY_YEAR or a calendar year
    var hour as Number;   // NO_HOUR or 0..23

    function initialize(month as Number, day as Number, year as Number, hour as Number) {
        self.month = month;
        self.day = day;
        self.year = year;
        self.hour = hour;
    }

    // The "Time of day" setting to an hour: 0 (or anything out of range) is all day.
    static function hourFromSetting(raw as Number) as Number {
        var timed = raw > DaysToGoConfig.HOUR_SETTING_ALL_DAY && raw <= DaysToGoConfig.HOUR_SETTING_LAST;
        return timed ? raw - 1 : DaysToGoConfig.NO_HOUR;
    }

    // hourSetting is the raw "Time of day" property (0 = all day, 1..24 = 00:00..23:00).
    static function fromSettings(kind as Number, month as Number, day as Number, year as Number, hourSetting as Number) as DaysToGoEvent {
        if (kind == DaysToGoConfig.EVENT_NEW_YEAR) {
            return new DaysToGoEvent(1, 1, DaysToGoConfig.EVERY_YEAR, DaysToGoConfig.NO_HOUR);
        }
        if (kind == DaysToGoConfig.EVENT_CHRISTMAS) {
            return new DaysToGoEvent(12, 25, DaysToGoConfig.EVERY_YEAR, DaysToGoConfig.NO_HOUR);
        }
        return new DaysToGoEvent(month, day, year, hourFromSetting(hourSetting));
    }
}
