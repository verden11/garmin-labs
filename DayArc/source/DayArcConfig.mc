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
}
