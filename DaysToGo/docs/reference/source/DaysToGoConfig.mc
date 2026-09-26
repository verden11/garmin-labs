import Toybox.Lang;

// Every tunable and identifier in one place (house rule: no magic numbers).
// Setting values here must match resources/settings.
class DaysToGoConfig {
    // Event kinds (the "Event" setting).
    static const EVENT_NEW_YEAR = 0;
    static const EVENT_CHRISTMAS = 1;
    static const EVENT_CUSTOM = 2;

    // "Year" setting: 0 means the event repeats every year.
    static const EVERY_YEAR = 0;
    // Internally NO_HOUR (-1) means the whole day (the event is midnight). The
    // "Time of day" setting never stores a negative: 0 = all day, 1..24 = 00:00..23:00.
    static const NO_HOUR = -1;
    static const HOUR_SETTING_ALL_DAY = 0;
    static const HOUR_SETTING_LAST = 24;

    // Calendar bounds the day arithmetic is valid for.
    static const FIRST_YEAR = 1970;
    static const LAST_YEAR = 2200;

    // 29 Feb in a common year is counted to this day of February.
    static const LEAP_DAY = 29;
    static const LEAP_DAY_FALLBACK = 28;

    // Any leap year: an every-year event is valid when it exists in this one
    // (29 Feb passes, 30 Feb and 31 Apr do not).
    static const LEAP_SAMPLE_YEAR = 2000;

    // The on-watch date picker's columns. Keep in step with FIRST_YEAR/LAST_YEAR
    // in tools/gen_settings.py (the phone's Year list) whenever either changes.
    static const MONTHS_PER_YEAR = 12;
    static const MAX_DAY_OF_MONTH = 31;
    static const PICKER_FIRST_YEAR = 2026;
    static const PICKER_LAST_YEAR = 2060;

    static const SECONDS_PER_HOUR = 3600;
    static const SECONDS_PER_DAY = 86400;
    static const DAYS_PER_WEEK = 7;

    // What a countdown says about "now" (DaysToGoResult.phase).
    static const PHASE_INVALID = 0;   // the saved date does not exist (30 Feb)
    static const PHASE_UPCOMING = 1;  // days > 0 left
    static const PHASE_HOURS = 2;     // timed event, under 24 h left
    static const PHASE_TODAY = 3;     // the event's day, or its time has arrived
    static const PHASE_PAST = 4;      // days since, > 0

    // Property keys. Spellings never change once shipped.
    static const KEY_EVENT = "Event";
    static const KEY_MONTH = "Month";
    static const KEY_DAY = "Day";
    static const KEY_YEAR = "Year";
    static const KEY_HOUR = "Hour";
}
