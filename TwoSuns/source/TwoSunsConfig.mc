import Toybox.Lang;

// Every tunable and identifier in one place (house rule: no magic numbers).
class TwoSunsConfig {
    // Calendar bounds the day arithmetic is valid for (every division is on a non-negative number).
    static const FIRST_YEAR = 1970;
    static const LAST_YEAR = 2200;

    static const MINUTES_PER_HOUR = 60;
    static const MINUTES_PER_DAY = 1440;
    static const SECONDS_PER_MINUTE = 60;
    static const SECONDS_PER_HOUR = 3600;
    static const SECONDS_PER_DAY = 86400;

    // What TwoSunsSunDay.kind says about the sun on a day.
    static const SUN_NORMAL = 0;       // it rises and sets
    static const SUN_UP_ALL_DAY = 1;   // midnight sun
    static const SUN_DOWN_ALL_DAY = 2; // polar night

    // Sun geometry (NOAA sunrise equation, docs/spec.md "Data rules").
    // Day number 10957 is 2000-01-01 00:00 UT; J2000.0 is 12 hours later.
    static const J2000_DAY_NUMBER = 10957;
    static const DAYS_PER_JULIAN_CENTURY = 36525.0;
    static const DEGREES_PER_HALF_TURN = 180.0;
    static const DEGREES_PER_TURN = 360.0;
    static const MINUTES_PER_DEGREE = 4.0;   // the sun moves 1 degree in 4 minutes
    static const MINUTES_AT_LONGITUDE_ZERO_NOON = 720.0;
    // Zenith angles: the sun's upper limb at the horizon with refraction, civil twilight, golden hour (6 degrees up).
    static const ZENITH_HORIZON = 90.833;
    static const ZENITH_CIVIL = 96.0;
    static const ZENITH_GOLDEN = 84.0;

    // What TwoSunsSky.state says about the sky right now (docs/spec.md "What the face shows").
    static const SKY_DAY = 0;
    static const SKY_BEFORE_SUNRISE = 1;
    static const SKY_AFTER_SUNSET = 2;
    static const SKY_MIDNIGHT_SUN = 3;
    static const SKY_POLAR_NIGHT = 4;
    static const SKY_NO_PLACE = 5;
    static const SKY_NO_DATA = 6;
    static const SKY_WORDING_LEVELS = 2;   // sentences come in up to three wordings: full, shorter, shortest

    // Body Battery history: the last 24 hours in 96 buckets of 15 minutes (docs/spec.md "Data rules").
    static const BATTERY_WINDOW_SECONDS = 86400;
    static const BATTERY_BUCKET_SECONDS = 900;
    static const BATTERY_BUCKETS = 96;
    static const BATTERY_MAX = 100;               // Garmin uses 127 for "not worn"; anything above 100 is dropped
    static const BATTERY_STALE_SECONDS = 3600;    // a newest sample older than this is shown muted
    // Our own UI threshold, not Garmin's: below this the value, pill and dot dim (TwoSunsPalette.dim),
    // same colour the ring uses for daylight already gone, so "dim" means the same thing everywhere on
    // the face. Not a verdict: no word, no red, just less light for less left (owner, 2026-09-27).
    static const BATTERY_LOW_THRESHOLD = 30;
    static const BATTERY_FUTURE_SLACK_SECONDS = 300;   // a sample stamped up to 5 minutes ahead is clock skew, later is dropped

    // The remembered place: rounded to 0.1 degree (about 11 km), replaced only when a source is further away.
    static const PLACE_TENTHS = 10.0;
    static const PLACE_REPLACE_DEGREES = 0.1;
    static const PLACE_EPSILON = 0.001;
    static const LATITUDE_LIMIT = 90.0;
    static const LONGITUDE_LIMIT = 180.0;
    static const NULL_ISLAND_DEGREES = 0.000001;  // a fix of exactly 0,0 is a "no fix" placeholder, not a place

    // Storage key. Spellings never change once shipped.
    static const KEY_PLACE = "place";

    // Settings (docs/spec.md "Settings"). Values match resources/settings; list values are never negative.
    static const ACCENT_COUNT = 6;
    static const ORIENTATION_NOON_TOP = 0;
    static const ORIENTATION_MIDNIGHT_TOP = 1;
    static const OFF = 0;
    static const ON = 1;

    // Property keys. Spellings never change once shipped.
    static const KEY_ACCENT = "Accent";
    static const KEY_ORIENTATION = "Orientation";
    static const KEY_GOLDEN = "Golden";
    static const KEY_CURVE = "Curve";
    static const KEY_DATE = "Date";

    static const HOURS_PER_HALF_DAY = 12;

    static const BATTERY_REFRESH_SECONDS = 300;   // the history is re-read at most every 5 minutes

    static const PERMILLE = 1000;

    // Always-on drift: the block steps across a grid of BURN_IN_GRID squared spots, a step wider than a
    // digit stroke (Days To Go ADR-007: at most 10% of pixels lit, a pixel on for at most 3 updates).
    static const BURN_IN_GRID = 3;
    static const BURN_IN_STEP_PERMILLE = 35;

    // What a ring arc shows (TwoSunsRingArc.kind). The night track under everything is not an arc.
    static const RING_TWILIGHT = 1;
    static const RING_DAY_GONE = 2;    // daylight already past
    static const RING_DAY_LEFT = 3;    // daylight still to come
    static const RING_GOLDEN = 4;
    // The 24 hour ring: noon at the top by default (docs/spec.md D1).
    static const NOON_MINUTE = 720;
    static const DEGREES_TOP = 90;           // Garmin arcs: 0 is 3 o'clock, counter-clockwise, so the top is 90
    static const DEGREES_FULL_TURN = 360;
    static const MINUTES_PER_DEGREE_RING = 4;   // 1440 minutes round 360 degrees

    // The Body Battery band: a level pill, the value and the curve (TwoSunsBand, TwoSunsCurvePlan).
    static const CURVE_MAX_WIDTH_PERMILLE = 520;   // of D
    static const CURVE_MIN_WIDTH_PERMILLE = 180;   // narrower than this and the curve is dropped, the value stays
    static const BAND_GAP_PERMILLE = 25;
    static const GLYPH_HEIGHT_PERCENT = 55;        // of the value font's height
    static const GLYPH_ASPECT_PERMILLE = 1800;     // glyph width as a share of its height
    static const DOT_PERMILLE = 16;                // the curve's current-point radius, of D
    static const MIN_DOT_RADIUS = 3;
    static const PEN_PERMILLE = 5;                 // line width of the curve and the glyph outline, of D
    static const PERCENT = 100;
}
