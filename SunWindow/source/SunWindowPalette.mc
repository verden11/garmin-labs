import Toybox.Lang;

// Every value is in Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP screens render it exactly. State is never
// colour: a word and a shape carry it, and the accent marks nothing (DESIGN.md "Colour rule"). The glance uses TEXT only,
// so no accent is ever drawn on the system's themed card.
(:glance, :color)
class SunWindowPalette {
    // True where nothing may lean on grey or hue (the 1-bit Instinct, ADR-012).
    static const MONO = false;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;
    static const TRACK = 0x555555;

    // The "Accent" setting by id, append-only (ADR-013): sky (default), mint, amber, pink, violet, white. Sky is the
    // default because blue carries no status meaning (TwoSuns, 2026-09-27: amber read as a warning on a normal value).
    static const ACCENTS = [0x55AAFF, 0x55FFAA, 0xFFAA00, 0xFF55AA, 0xAA55FF, 0xFFFFFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return index >= 0 && index < ACCENTS.size() ? ACCENTS[index] : ACCENTS[SunWindowConfig.ACCENT_DEFAULT];
    }
}

// The Instinct's twin (ADR-012): a 1-bit display shows black and white only, and how it would round any other value is
// unspecified, so every role is white on black. What colour says elsewhere, shape says here. Same class name and roles;
// the jungle picks one by the `color`/`mono` annotations. The Accent setting has no effect there and is not offered.
(:glance, :mono)
class SunWindowPalette {
    static const MONO = true;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xFFFFFF;
    static const TRACK = 0xFFFFFF;
    static const ACCENTS = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return TEXT;
    }
}
