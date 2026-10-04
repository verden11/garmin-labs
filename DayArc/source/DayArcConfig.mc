import Toybox.Lang;

// Every tunable in one place (house rule: no magic numbers).
class DayArcConfig {
    static const MINUTES_PER_HOUR = 60;
    static const MINUTES_PER_DAY = 1440;

    // Window boundaries, half-open [start, end) in minutes since local midnight.
    // Locked by the owner (docs/decisions.md ADR-004); night is ADR-010, owner-reversible.
    static const MORNING_START = 5 * MINUTES_PER_HOUR;        // 5:00
    static const MIDDAY_START = 9 * MINUTES_PER_HOUR + 30;    // 9:30
    static const EVENING_START = 17 * MINUTES_PER_HOUR;       // 17:00
    static const NIGHT_START = 23 * MINUTES_PER_HOUR;         // 23:00

    static const WINDOW_MORNING = 0;
    static const WINDOW_MIDDAY = 1;
    static const WINDOW_EVENING = 2;
    static const WINDOW_NIGHT = 3;

    // Stress and Body Battery are both a single-hue gauge fill, no threshold tier (ADR-006): an
    // earlier version dimmed stress above 25, which is exactly Garmin's own official "rest"/
    // "draining" band boundary (knowledge/health-science.md) — re-encoding a documented verdict
    // band as a brightness verdict. Caught by watch-design-reviewer, 2026-09-28; removed rather
    // than defended.
    static const STRESS_MAX = 100;
    static const BODY_BATTERY_MAX = 100;

    // Complications refresh: re-read at most this often (subscriptions push updates, but a
    // belt-and-braces poll on every onUpdate is cheap and avoids relying on push timing alone).
    static const REFRESH_SECONDS = 60;

    // AMOLED always-on drift (TwoSunsSleep's proven pattern, reused verbatim): the idle block steps
    // across a 3x3 grid every minute, a step wider than a digit stroke, so no pixel stays lit longer
    // than one minute.
    static const BURN_IN_GRID = 3;
    static const BURN_IN_STEP_PERMILLE = 35;

    // Window-progress arc (ADR-013): how much of the circle's top the arc's track spans, centred on
    // 90 degrees (Dc.drawArc's own "12 o'clock" per the SDK's angle convention: 0=3 o'clock,
    // 90=12 o'clock, counter-clockwise positive). A deliberately different shape from TwoSuns's full
    // 24h ring, so the two listings' signature elements are never confused (DESIGN.md "Layout").
    static const ARC_SPAN_DEGREES = 140;

    // DayArcStack sizes every row against these FIXED worst-case strings, or the live string if it is
    // WIDER (measured in pixels at the largest text font, DayArcSizing), so the chosen tiers don't
    // flicker between readings. A live string wider than the plan it is drawn under can still occur
    // (a cached plan, an unexpected locale): DayArcPlanCache replans when DayArcSizing.covers says so,
    // and the draw path is safe regardless — every row is truncated against its OWN chord, never
    // throws, never draws a bare one-character stub (DayArcText.truncated).
    static const WORST_CLOCK = "88:88";
    static const WORST_DATE = "Wed, Sep 30";       // the simulator's own complication string is "Mon 28"; this leaves headroom for locales
    static const WORST_COUNT = "100";
    static const WORST_TEMPERATURE = "-40°";
    static const WORST_MORNING_SUB = "104/-40  100% rain  UV 11";   // HIGH_LOW_TEMPERATURE is "55/43"-shaped (simulator)
    static const MAX_SUB_LINES = 2;
    // A number font's digits fill about this share of its ascent (the rest is empty headroom above them): measured off
    // simulator screenshots, 0.77 on an FR965 and 0.67 on an epix 2 (2026-10-04). The hero icon is centred on that
    // estimate, not on the font box, so it sits level with the digits (the Dc has no glyph metrics to ask).
    static const DIGIT_HEIGHT_PERMILLE = 720;
    // A hero icon is chosen per screen size and number tier (resources-hero-*, ADR-017) so its height is about the digits'
    // beside it; the render test fails a screen whose sets fall outside this band of the digits' height (too big on a 218 px
    // screen, thin and small on a 454 px one). The battery shell is 7/8 of the others' height, hence the low floor.
    static const HERO_ICON_MIN_PERMILLE = 700;
    static const HERO_ICON_MAX_PERMILLE = 1150;

    // The vertical fit ladder (DESIGN.md "Layout"), one row per rung, first that fits wins. Columns are
    // named by the LEVEL_* indices below. Order = the owner's standing rule "do not shrink unless
    // necessary": gaps first, then the clock, then the small text, then the hero last; the hero font
    // never drops below the clock's. Then fallbacks for a screen where nothing else fits: drop the hero
    // label; (Pro) reserve one grid row instead of two and quarter the gaps; then TRIM — drop every
    // optional row (date, label, grid, the second sub line), then everything but clock + hero + gauge.
    // If even that cannot fit, DayArcStack draws only the rows that lie inside the usable area (never a
    // row that would cross the bottom edge). Which devices reach which rung is logged by DayArcStackTest.
    // Pro: how many icon-only fields may sit in the upper corners beside the date (DayArcCorners).
    static const CORNER_SLOTS = 2;

    static const GRID_ROWS = 2;          // Pro reserves this many grid rows below the hero block...
    static const GRID_ROWS_FALLBACK = 1; // ...or this many on the fallback rungs; the grid then takes whatever is left
    static const TRIM_NONE = 0;
    static const TRIM_OPTIONAL = 1;      // no date, label, grid, second sub line
    static const TRIM_CORE = 2;          // clock + hero + gauge only
    static const LEVEL_CLOCK = 0;
    static const LEVEL_HERO = 1;
    static const LEVEL_TEXT = 2;
    static const LEVEL_GAP_DIVISOR = 3;
    static const LEVEL_DROP_LABEL = 4;
    static const LEVEL_GRID_ROWS = 5;
    static const LEVEL_TRIM = 6;
    // Pro, ADR-016 and ADR-017: the rungs before STACK_FIRST_DROP_LABEL keep the hero label. Pro tries them with the grid, then
    // WITHOUT it (drawn like Simple, at Simple's own tiers), and only then the rungs that drop the label to buy grid room:
    // the label is the hero's name (on a 1-bit Instinct the only thing, besides the icon, that says what the number is),
    // so a grid row never costs it. Those rungs and the TRIM rungs (from STACK_FIRST_TRIM: drop the date, label, grid and
    // second sub line) are the fallbacks for a screen where nothing else fits.
    static const STACK_FIRST_DROP_LABEL = 8;
    static const STACK_FIRST_TRIM = 10;
    static const STACK_LEVELS = [
        [0, 0, 0, 1, 0, GRID_ROWS, TRIM_NONE], [0, 0, 0, 2, 0, GRID_ROWS, TRIM_NONE],
        [1, 0, 0, 2, 0, GRID_ROWS, TRIM_NONE], [1, 0, 1, 2, 0, GRID_ROWS, TRIM_NONE],
        [1, 1, 1, 2, 0, GRID_ROWS, TRIM_NONE], [1, 2, 1, 2, 0, GRID_ROWS, TRIM_NONE],
        [2, 2, 1, 2, 0, GRID_ROWS, TRIM_NONE], [2, 2, 1, 4, 0, GRID_ROWS_FALLBACK, TRIM_NONE],
        [2, 2, 1, 2, 1, GRID_ROWS, TRIM_NONE],
        [2, 2, 1, 4, 1, GRID_ROWS_FALLBACK, TRIM_NONE],
        [2, 2, 1, 4, 1, GRID_ROWS_FALLBACK, TRIM_OPTIONAL], [2, 2, 1, 4, 1, GRID_ROWS_FALLBACK, TRIM_CORE],
    ] as Array<Array<Number>>;

    // Accent colour (ADR-014): 0 = Auto (today's per-window hues), 1..6 = a fixed choice.
    static const ACCENT_AUTO = 0;
    static const ACCENT_CHOICES = 7;
}
