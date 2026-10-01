import Toybox.Lang;

// 64-colour-safe (each channel 0x00/0x55/0xAA/0xFF, MIP-exact) per DESIGN.md. Auto (the default)
// keeps ADR-013's one accent hue per WINDOW; the wearer may instead pick one fixed hue from a
// short list (ADR-014, "Accent colour") for every active window. Either way the hue is keyed to the
// window or to the wearer's own choice, NEVER to the value shown: stress and Body Battery stay one
// constant hue whatever they read, so ADR-006's no-verdict rule holds even if the wearer picks
// green or amber for them (a colour the wearer chose is not the watch judging their reading).
class DayArcPalette {
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;      // secondary labels, "--" empty values
    static const ARC_TRACK = 0x555555;  // faint: the arc's own background track, and the Pro divider

    // The selectable hues, in the order settings.xml offers them after Auto (choice N = index N-1).
    // All >=3:1 against black (WCAG). The hero icon bitmaps are generated per hue in this same
    // order (tools/gen_hero_icons.py) — keep the two in step.
    // Indices into ACCENTS that Auto uses.
    static const HUE_CYAN = 0;
    static const HUE_AMBER = 1;
    static const HUE_ROSE = 2;
    static const ACCENTS = [0x55FFFF, 0xFFAA00, 0xFF55AA, 0x55FF55, 0x55AAFF, 0xAA55FF] as Array<Number>;

    // Auto's hue per window, as an index into ACCENTS: morning amber, midday cyan, evening rose.
    // Night has no accent by design (no hero, no icon, no arc) — callers must not ask for one.
    static function hueIndex(window as Number, choice as Number) as Number {
        if (choice >= 1 && choice <= ACCENTS.size()) {
            return choice - 1;
        }
        if (window == DayArcConfig.WINDOW_MORNING) {
            return HUE_AMBER;
        }
        return window == DayArcConfig.WINDOW_MIDDAY ? HUE_CYAN : HUE_ROSE;
    }

    static function accentFor(window as Number, choice as Number) as Number {
        return ACCENTS[hueIndex(window, choice)];
    }
}
