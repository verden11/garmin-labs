import Toybox.Lang;

// Every value is in Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP
// screens render it exactly. State is never colour alone: a word carries it too.
(:color)
class DaysToGoPalette {
    // True where tracks must be outlines and nothing may lean on grey or hue (the 1-bit Instinct, ADR-015).
    static const MONO = false;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;
    static const TRACK = 0x555555;
    // Always-on: dimmer than TEXT so an AMOLED spends less light.
    static const SLEEP_TEXT = 0x555555;

    // The "Accent colour" setting, by index: mint (default), amber, sky, pink, violet, white.
    static const ACCENTS = [0x55FFAA, 0xFFAA00, 0x55AAFF, 0xFF55AA, 0xAA55FF, 0xFFFFFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return index >= 0 && index < ACCENTS.size() ? ACCENTS[index] : ACCENTS[0];
    }
}

// The Instinct's twin (ADR-015): a 1-bit display shows black and white only and how it would round any other value is
// unspecified, so every role is white on black and state is carried by shape and words (outlined track under a solid
// fill, the word TODAY). Same class name and roles; the jungles pick one by the `color`/`mono` annotations. The Accent
// setting has no effect here: accent() is always white (and the setting is not offered on these products).
(:mono)
class DaysToGoPalette {
    static const MONO = true;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xFFFFFF;
    static const TRACK = 0xFFFFFF;
    static const SLEEP_TEXT = 0xFFFFFF;
    static const ACCENTS = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return TEXT;
    }
}
