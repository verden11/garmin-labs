import Toybox.Lang;

// HeroSet's colour roles (HeroSet ADR-031), so the face reads as the same
// product: gold is what the user keeps (streak, rank), the accent is today's
// effort still under way, green is a finished goal. Every value but SLEEP_TEXT
// is in Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP renders it exactly.
(:color)
class HeroFacePalette {
    // True where tracks must be outlines and nothing may lean on grey or hue (the 1-bit Instinct, ADR-002).
    static const MONO = false;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;
    static const TRACK = 0x555555;
    static const GOLD = 0xFFAA00;
    static const DONE = 0x00FF00;
    // Attention, inherited from HeroSet's palette: a low battery, or a move bar
    // that has been sitting too long. Always paired with a word, never alone.
    static const ALERT = 0xFF0000;
    // Always-on time (AMOLED only, so it need not be 64-colour safe): the studio's one always-on grey (ADR-006,
    // ROADMAP 13.25; Two Suns ADR-027). 3.14:1 against black, above the >=3:1 bar for a persistent colour (0x555555,
    // the 64-colour grey it replaces, is 2.82:1). Only HeroFaceSleep draws it, and only when the watch requires
    // burn-in protection (HeroFaceView), so a MIP watch never meets a value off its palette.
    static const SLEEP_TEXT = 0x5C5C5C;

    // Accent setting, by index; ids are append-only and both the Free and the Pro build offer all three
    // (docs/decisions.md ADR-001, the Free + Pro ladder). The rule is 3:1 against TRACK so a part-filled
    // bar still reads: Blue measures 3.05, Cyan 5.95 and Magenta 4.42. Magenta (id 2) was #FF55FF at 2.84 and
    // the owner had it recoloured to #FFAAFF on 2026-10-04 (ADR-003): the id and the name stay, and 64-colour
    // Garmin has no more saturated magenta that clears 3:1. None is gold or green (those carry meaning) and
    // none is white, which is the time's own colour: a bar must never read as clock.
    static const ACCENTS = [0x55AAFF, 0x00FFFF, 0xFFAAFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return index >= 0 && index < ACCENTS.size() ? ACCENTS[index] : ACCENTS[0];
    }
}

// The Instinct's twin (ADR-002): a 1-bit display shows black and white only and how it would round any other value is
// unspecified, so every role is white on black. What colour says on the other products, shape and words say here:
// an outlined track under a solid fill, a drawn check and a full bar for done, the number beside every icon.
// Same class name and roles; the jungles pick one by the `color`/`mono` annotations. The Accent setting has no effect
// (accent() is always white) and is not offered on these products.
(:mono)
class HeroFacePalette {
    static const MONO = true;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xFFFFFF;
    static const TRACK = 0xFFFFFF;
    static const GOLD = 0xFFFFFF;
    static const DONE = 0xFFFFFF;
    static const ALERT = 0xFFFFFF;
    static const SLEEP_TEXT = 0xFFFFFF;
    static const ACCENTS = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return TEXT;
    }
}
