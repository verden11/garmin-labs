import Toybox.Lang;

// HeroSet's colour roles (HeroSet ADR-031), so the face reads as the same
// product: gold is what the user keeps (streak, rank), the accent is today's
// effort still under way, green is a finished goal. Every value is in
// Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP renders it exactly.
class HeroFacePalette {
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;
    static const TRACK = 0x555555;
    static const GOLD = 0xFFAA00;
    static const DONE = 0x00FF00;
    // Attention, inherited from HeroSet's palette: a low battery, or a move bar
    // that has been sitting too long. Always paired with a word, never alone.
    static const ALERT = 0xFF0000;
    // AOD time: dimmer than TEXT so an always-on AMOLED spends less light.
    static const SLEEP_TEXT = 0x555555;

    // Accent setting, by index. Each clears 3:1 against TRACK so a part-filled
    // bar still reads. None is gold or green (those carry meaning) and none is
    // white, which is the time's own colour: a bar must never read as clock.
    static const ACCENTS = [0x55AAFF, 0x00FFFF, 0xFF55FF] as Array<Number>;

    static function accent(index as Number) as Number {
        return index >= 0 && index < ACCENTS.size() ? ACCENTS[index] : ACCENTS[0];
    }
}
