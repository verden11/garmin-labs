import Toybox.Lang;

// Every value is in Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP
// screens render it exactly. State is never colour alone: a word carries it too.
class TwoSunsPalette {
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;
    static const TRACK = 0x555555;
    // Always-on: dimmer than TEXT so an AMOLED spends less light. Same value as NIGHT (below), reused
    // deliberately for its contrast (2.8:1 for 0x555555 alone fails the project's own >=3:1 rule for a
    // persistent/always-on colour; NIGHT is 3.27:1); safe to share because the ring never draws during
    // sleep (TwoSunsSleep.draw), so the two never appear together (watch-design-reviewer, 2026-09-27).
    static const SLEEP_TEXT = 0x5555AA;

    // The "Accent" setting, by index: sky (default), mint, autumn, violet, pink, winter. Sky is the
    // default because blue carries no "status" meaning (unlike amber, which reads as a warning colour
    // even on a value that is not low: 2026-09-27, owner feedback on a real-device photo). Autumn and
    // Winter are the old amber and white, renamed and reordered, not recoloured: naming them as a mood
    // rather than a raw colour makes clear they are a deliberate choice, not a status indicator.
    static const ACCENTS = [0x55AAFF, 0x55FFAA, 0xFFAA00, 0xAA55FF, 0xFF55AA, 0xFFFFFF] as Array<Number>;

    static function accent(index as Number) as Number {
        return index >= 0 && index < ACCENTS.size() ? ACCENTS[index] : ACCENTS[0];
    }

    // The sky ring. Night is dim but still 3:1 against black (bright sun washes a dimmer track out).
    static const NIGHT = 0x5555AA;
    static const TWILIGHT = 0xAAAAFF;
    static const GOLDEN = 0xFF5500;

    // The accent dimmed for daylight already gone: each full channel (FF) drops to AA, the others stay, so
    // the result is still 3:1 against black for every accent (a channel dropped to 00 would fall below it
    // for blue and violet) and is never the night track colour. One accent is made only of AA/FF channels
    // (winter, 0xFFFFFF) and dims to exactly MUTED — the "no data" grey — which would make a low reading
    // and no reading indistinguishable, the exact collision ADR-008 rejected a third dim tier to avoid.
    // Caught by watch-design-reviewer, 2026-09-27: nudge the red channel one step further in that one
    // case so it never lands on MUTED, still 64-colour-safe, still darker than the source.
    static function dim(color as Number) as Number {
        var dimmed = (dimChannel(color >> 16) << 16) | (dimChannel(color >> 8) << 8) | dimChannel(color);
        return dimmed == MUTED ? 0x55AAAA : dimmed;
    }

    private static function dimChannel(value as Number) as Number {
        var channel = value & 0xFF;
        return channel == 0xFF ? 0xAA : channel;
    }

    // The energy curve. Fresh: a white line over a fill that is 3:1 against black. Stale: both muted.
    static const CURVE_FILL = 0x5555AA;
    static const CURVE_FILL_STALE = 0x555555;
}
