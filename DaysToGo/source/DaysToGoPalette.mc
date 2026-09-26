import Toybox.Lang;

// Every value is in Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP
// screens render it exactly. State is never colour alone: a word carries it too.
class DaysToGoPalette {
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
