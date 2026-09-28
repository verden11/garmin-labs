import Toybox.Lang;

// 64-colour-safe (each channel 0x00/0x55/0xAA/0xFF, MIP-exact) per DESIGN.md. One accent hue per
// WINDOW (ADR-013; was one hue for every window before) — colour marks "the hero read" / "which
// window this is," nothing else (watch-design-lead craft bar: one consistent accent-application
// rule). Still keyed to window/icon TYPE, never to the VALUE shown: never red/amber/green, no value
// here is ever "good" or "bad" (ADR-006, extends TwoSuns ADR-008's no-verdict rule to every metric
// this face shows; ADR-013 extends the same rule one level down to icon colour).
class DayArcPalette {
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;      // secondary labels, "--" empty values
    static const ARC_TRACK = 0x555555;  // faint: the arc's own background track, and the Pro divider

    // >=3:1 against black (WCAG) for all three.
    static const ACCENT_MORNING = 0xFFAA00;
    static const ACCENT_MIDDAY = 0x55FFFF;  // unchanged from the pre-ADR-013 single ACCENT
    static const ACCENT_EVENING = 0xFF55AA;
    // Night has no accent by design (no hero, no icon, no arc) — callers must not call accentFor
    // for WINDOW_NIGHT.

    static function accentFor(window as Number) as Number {
        if (window == DayArcConfig.WINDOW_MORNING) {
            return ACCENT_MORNING;
        }
        if (window == DayArcConfig.WINDOW_MIDDAY) {
            return ACCENT_MIDDAY;
        }
        return ACCENT_EVENING;
    }
}
