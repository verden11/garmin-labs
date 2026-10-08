import Toybox.Lang;

// 64-colour-safe (each channel 0x00/0x55/0xAA/0xFF, MIP-exact) per DESIGN.md, except the AMOLED-only
// SLEEP_TEXT. Auto (the default) keeps ADR-013's one accent hue per WINDOW; the wearer may instead pick one fixed hue from a
// short list (ADR-014, "Accent colour") for every active window. Either way the hue is keyed to the
// window or to the wearer's own choice, NEVER to the value shown: stress and Body Battery stay one
// constant hue whatever they read, so ADR-006's no-verdict rule holds even if the wearer picks
// green or amber for them (a colour the wearer chose is not the watch judging their reading).
(:color)
class DayArcPalette {
    // True where nothing may lean on grey or hue (the 1-bit Instinct, ADR-015).
    static const MONO = false;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;      // secondary labels, "--" empty values
    static const ARC_TRACK = 0x555555;  // faint: the arc's own background track, and the Pro divider
    // Always-on (AMOLED only, so it need not be 64-colour safe): the studio's one always-on grey (ADR-020; Two Suns
    // ADR-027). 3.14:1 against black, above the >=3:1 bar for a persistent colour, at about a quarter of MUTED's
    // luminance (MUTED, 9.0:1, was the always-on colour before). Only DayArcDraw.renderIdle draws it, and only when the
    // watch requires burn-in protection (DayArcView), so a MIP watch never meets a value off its palette.
    static const SLEEP_TEXT = 0x5C5C5C;

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

// The Instinct's twin (ADR-015): a 1-bit display shows black and white only, and how it would round any other value is
// unspecified, so every role is white on black. The hero is told apart by its icon and label, never by hue; the arc's
// track is an outline under a solid fill. Same class name and roles; the jungles pick one by the `color`/`mono`
// annotations. The Accent setting has no effect and is not offered (accentFor is always white); hueIndex always returns
// the cyan bitmaps, the brightest of the six, so an icon cannot round to black.
(:mono)
class DayArcPalette {
    static const MONO = true;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xFFFFFF;
    static const ARC_TRACK = 0xFFFFFF;
    static const SLEEP_TEXT = 0xFFFFFF;
    static const HUE_CYAN = 0;
    static const HUE_AMBER = 1;
    static const HUE_ROSE = 2;
    static const ACCENTS = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF] as Array<Number>;

    static function hueIndex(window as Number, choice as Number) as Number {
        return HUE_CYAN;
    }

    static function accentFor(window as Number, choice as Number) as Number {
        return TEXT;
    }
}
