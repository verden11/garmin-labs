import Toybox.Lang;

// Every tunable and identifier in one place (house rule: no magic numbers).
// Setting values here must match resources/settings.
class DaysToGoConfig {
    // Event kinds (the "Event" setting).
    static const EVENT_NEW_YEAR = 0;
    static const EVENT_CHRISTMAS = 1;
    static const EVENT_CUSTOM = 2;

    static const NEW_YEAR_MONTH = 1;
    static const NEW_YEAR_DAY = 1;
    static const CHRISTMAS_MONTH = 12;
    static const CHRISTMAS_DAY = 25;

    // "Year" setting: 0 means the event repeats every year.
    static const EVERY_YEAR = 0;
    // Internally NO_HOUR (-1) means the whole day (the event is midnight). The
    // "Time of day" setting never stores a negative: 0 = all day, 1..24 = 00:00..23:00.
    static const NO_HOUR = -1;
    static const HOUR_SETTING_ALL_DAY = 0;
    static const HOUR_SETTING_LAST = 24;

    // Calendar bounds the day arithmetic is valid for. Saved years are held to the
    // narrower PICKER range below, which also keeps `days * 86400` inside 32 bits.
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
    static const FIRST_DAY_OF_MONTH = 1;
    static const MAX_DAY_OF_MONTH = 31;
    // The picker always has three columns; the year is the last.
    static const PICKER_YEAR_COLUMN = 2;
    static const PICKER_FIRST_YEAR = 2026;
    static const PICKER_LAST_YEAR = 2060;

    static const SECONDS_PER_HOUR = 3600;
    static const SECONDS_PER_DAY = 86400;
    static const DAYS_PER_WEEK = 7;
    static const EPOCH_WEEKDAY = 4;   // 1970-01-01 was a Thursday (0 = Sunday)

    // Weekday and month words come from a Moment in this year, never the event's:
    // a Moment holds seconds in a 32-bit Number, which ends in January 2038, and
    // the year lists run to 2060. 4 January 2026 is a Sunday.
    static const WORD_YEAR = 2026;
    static const WORD_SUNDAY_DAY = 4;
    static const WORD_MONTH_DAY = 1;

    // What a countdown says about "now" (DaysToGoResult.phase).
    static const PHASE_INVALID = 0;   // the saved date does not exist (30 Feb)
    static const PHASE_UPCOMING = 1;  // days > 0 left
    static const PHASE_HOURS = 2;     // timed event, under 24 h left
    static const PHASE_TODAY = 3;     // the event's day, or its time has arrived
    static const PHASE_PAST = 4;      // days since, > 0

    // "Count in" setting.
    static const UNIT_DAYS = 0;
    static const UNIT_WEEKS = 1;

    // "Date style" setting: which of day and month comes first in the date line.
    static const STYLE_AUTO = 0;
    static const STYLE_DAY_FIRST = 1;
    static const STYLE_MONTH_FIRST = 2;

    // "Bottom line" setting.
    static const FOOTER_NONE = 0;
    static const FOOTER_BATTERY = 1;
    static const FOOTER_STEPS = 2;

    static const NAME_MAX_LENGTH = 16;
    static const ACCENT_COUNT = 6;
    static const DAYS_PER_YEAR = 365;
    static const HOURS_PER_HALF_DAY = 12;
    static const SECONDS_PER_MINUTE = 60;
    static const PERMILLE = 1000;
    static const STEPS_SHORT_FROM = 1000;
    static const STEPS_ROUND = 500;
    static const STEPS_PER_THOUSAND = 1000.0;
    static const STEPS_TENTHS_BELOW = 99.95;   // in thousands: below this, one decimal fits in 4 characters

    // Always-on drift: the block steps across a grid of BURN_IN_GRID squared spots.
    static const BURN_IN_GRID = 3;
    // Step in thousandths of the shorter screen side (about 16 px on 454). Garmin: a pixel may be
    // on for at most 3 once-a-minute updates. The block sits still for 3 minutes per row, so a stroke
    // must clear its own thickness when the row changes: the step has to exceed a digit stroke.
    static const BURN_IN_STEP_PERMILLE = 35;

    // Property keys. Spellings never change once shipped.
    static const KEY_EVENT = "Event";
    static const KEY_MONTH = "Month";
    static const KEY_DAY = "Day";
    static const KEY_YEAR = "Year";
    static const KEY_HOUR = "Hour";
    static const KEY_NAME = "Name";
    static const KEY_UNIT = "Unit";
    static const KEY_DATE_STYLE = "DateStyle";
    static const KEY_FOOTER = "Footer";
    static const KEY_ACCENT = "Accent";
}
