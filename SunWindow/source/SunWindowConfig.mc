import Toybox.Lang;

// Every tunable and identifier in one place (house rule: no magic numbers). Glance code reads it too.
(:glance)
class SunWindowConfig {
    // Calendar bounds the day arithmetic is valid for (every division is on a non-negative number).
    static const FIRST_YEAR = 1970;
    static const LAST_YEAR = 2200;
    static const MINUTES_PER_HOUR = 60;
    static const MINUTES_PER_DAY = 1440;
    static const HOURS_PER_HALF_DAY = 12;
    static const PERCENT = 100;

    // The window rule (docs/spec.md, ADR-004): the sun at or above 45 degrees. The sunrise equation takes a zenith
    // angle, so the code names it: ZENITH_WINDOW = 90 - ELEVATION_DEG (45 only equals it because 90 - 45 = 45).
    static const ELEVATION_DEG = 45.0d;
    static const ZENITH_WINDOW = 45.0d;   // 90 - ELEVATION_DEG

    // Sun geometry: NOAA's formulas (Meeus), in Double, geometric, no refraction. Day number 10957 is 2000-01-01 00:00 UT;
    // J2000.0 is 12 hours later. Float32 cannot hold a Julian date, so the maths runs on days since J2000.
    static const J2000_DAY_NUMBER = 10957;
    static const J2000_HALF_DAY = 0.5d;
    static const DAYS_PER_JULIAN_CENTURY = 36525.0d;
    static const PI = 3.141592653589793d;
    static const DEGREES_PER_HALF_TURN = 180.0d;
    static const DEGREES_PER_TURN = 360.0d;
    static const MINUTES_PER_DEGREE = 4.0d;   // the sun moves 1 degree in 4 minutes
    static const NOON_MINUTE_AT_LONGITUDE_ZERO = 720.0d;
    static const EDGE_ITERATIONS = 3;         // declination and equation of time are re-read at each edge this many times
    static const EDGE_ROUNDING_SLACK = 0.000001d;   // minutes: ceil/floor of an edge that lands exactly on a minute

    // Weather (ADR-004): OPEN is demoted to CLOSED when the watch's own UV index is under this. Cloud cover is the D2
    // fallback only (device check), off until a wrist shows uvIndex null or not following the sky. Starting values, not
    // sourced numbers; final ones come from the wear data.
    static const UV_DEMOTE = 3.0;
    static const CLOUD_DEMOTE = 90;
    static const USE_CLOUD_FALLBACK = false;
    static const WEATHER_MAX_AGE_SECONDS = 10800;   // a reading older than 3 hours is no reading (ADR-004)
    // Whether the glance also reads the sky, so glance and full view always agree (ADR-010, OD-6). Plan P6.3 measures
    // glance memory with this on and off; it goes off only if the 32 KB Instinct glance cannot afford it.
    static const GLANCE_READS_WEATHER = true;

    // The remembered place: [latitude, longitude] rounded to 0.1 degree (about 11 km), replaced only when a fix is further away.
    static const PLACE_TENTHS = 10.0;
    static const PLACE_REPLACE_DEGREES = 0.1;
    static const PLACE_EPSILON = 0.001;
    static const LATITUDE_LIMIT = 90.0;
    static const LONGITUDE_LIMIT = 180.0;
    static const NULL_ISLAND_DEGREES = 0.000001;   // a fix of exactly 0,0 is a "no fix" placeholder, not a place
    static const KEY_PLACE = "place";               // Storage key. The spelling never changes once shipped.
    static const KEY_ACCENT = "Accent";             // Properties key. Same rule.
    static const ACCENT_COUNT = 6;
    static const ACCENT_DEFAULT = 0;

    // What a fix may be before it is trusted (Position.QUALITY_LAST_KNOWN is 1). D6 decides the final value on a wrist.
    static const MIN_FIX_QUALITY = 1;
    static const LOCATE_SECONDS = 60;   // how long the full view says "Finding your place" before "No place yet"
    static const TICK_MILLISECONDS = 60000;   // the full view redraws once a minute

    // The 1-bit Instinct glance (154x61 / 164x61): the round sub-window covers the glance's top right, from x 104 in the
    // simulator (113 on the screen, 9 in from the glance's own left) and down to y 33 (E 40 mm) or 43 (E 45 mm, 3 Solar).
    // So the name and the state row stay left of x 100 and the mark is dropped when the word does not fit beside it. The
    // simulator's numbers; a wrist has not confirmed them (DESIGN.md).
    static const GLANCE_MONO_TITLE_TOP = 2;
    static const GLANCE_MONO_ROOM = 100;

    // The Instinct's round sub-window carries the state mark: its size and vertical centre, as percent of the window.
    static const SUB_MARK_PERCENT = 70;
    static const SUB_MARK_CENTRE_PERCENT = 55;

    // What SunWindowState.kind says.
    static const STATE_OPEN = 0;
    static const STATE_CLOSED_BEFORE = 1;   // today's window is still to come
    static const STATE_CLOSED_AFTER = 2;    // today's window has gone
    static const STATE_CLOSED_SKY = 3;      // inside the window, but the watch's weather says the sky is low on UV
    static const STATE_NONE_TODAY = 4;      // today's highest sun stays under the line
    static const STATE_ONCE = 5;            // no stored place: the app has to be opened once
    static const STATE_LOCATING = 6;        // the full view is asking for a place
    static const STATE_NO_FIX = 7;          // it asked and got nothing usable
}
