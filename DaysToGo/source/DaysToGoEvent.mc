import Toybox.Lang;

// One event as the settings describe it. Presets are just events with fixed
// fields, so the countdown has a single code path.
class DaysToGoEvent {
    var month as Number;
    var day as Number;
    var year as Number;   // EVERY_YEAR or a calendar year
    var hour as Number;   // NO_HOUR or 0..23
    var minute as Number; // 0..59; read only when hour is set
    var zone as Number;   // the raw "Event time zone" setting: ZONE_WATCH or 1..ZONE_SETTING_LAST

    function initialize(month as Number, day as Number, year as Number, hour as Number, minute as Number, zone as Number) {
        self.month = month;
        self.day = day;
        self.year = year;
        self.hour = hour;
        self.minute = minute;
        self.zone = zone;
    }

    // The "Time of day" setting to an hour: 0 (or anything out of range) is all day.
    static function hourFromSetting(raw as Number) as Number {
        var timed = raw > DaysToGoConfig.HOUR_SETTING_ALL_DAY && raw <= DaysToGoConfig.HOUR_SETTING_LAST;
        return timed ? raw - 1 : DaysToGoConfig.NO_HOUR;
    }

    // The event's UTC offset in seconds (east positive) for a zone setting, or null for the watch's own zone.
    static function zoneOffset(zone as Number) as Number? {
        var chosen = zone > DaysToGoConfig.ZONE_WATCH && zone <= DaysToGoConfig.ZONE_SETTING_LAST;
        return chosen ? (zone - DaysToGoConfig.ZONE_UTC_INDEX) * DaysToGoConfig.ZONE_STEP_SECONDS : null;
    }

    // hourSetting is the raw "Time of day" property (0 = all day, 1..24 = 00:00..23:00); minute and zone are the raw
    // Pro settings (Free passes 0 and ZONE_WATCH). An all-day event ignores both (ADR-018).
    static function fromSettings(kind as Number, month as Number, day as Number, year as Number, hourSetting as Number,
                                 minute as Number, zone as Number) as DaysToGoEvent {
        if (kind == DaysToGoConfig.EVENT_NEW_YEAR) {
            return new DaysToGoEvent(DaysToGoConfig.NEW_YEAR_MONTH, DaysToGoConfig.NEW_YEAR_DAY, DaysToGoConfig.EVERY_YEAR, DaysToGoConfig.NO_HOUR, 0, DaysToGoConfig.ZONE_WATCH);
        }
        if (kind == DaysToGoConfig.EVENT_CHRISTMAS) {
            return new DaysToGoEvent(DaysToGoConfig.CHRISTMAS_MONTH, DaysToGoConfig.CHRISTMAS_DAY, DaysToGoConfig.EVERY_YEAR, DaysToGoConfig.NO_HOUR, 0, DaysToGoConfig.ZONE_WATCH);
        }
        return new DaysToGoEvent(month, day, year, hourFromSetting(hourSetting), minute, zone);
    }
}
