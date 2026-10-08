import Toybox.Lang;

// Every value is in Garmin's 64-colour palette (channels 00/55/AA/FF), so MIP
// screens render it exactly. State is never colour alone: a word carries it too.
(:color)
class TwoSunsPalette {
    // True where nothing may lean on grey or hue (the 1-bit Instinct, ADR-024).
    static const MONO = false;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xAAAAAA;
    static const TRACK = 0x555555;
    // Always-on (AMOLED only, so it need not be 64-colour safe): a dim neutral grey, per Garmin's "avoid much white or blue,
    // consider light gray" (ADR-027). 3.14:1 against black, so above the project's >=3:1 bar for a persistent colour (0x555555
    // alone is 2.8:1), and a touch less luminous than the 0x5555AA it replaces (0.107 against 0.113 relative luminance).
    static const SLEEP_TEXT = 0x5C5C5C;

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
    // (winter, 0xFFFFFF) and dims to exactly MUTED — the "no data" grey — which would make daylight already
    // gone read as the same grey as a missing or stale reading.
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

    // The weather row (docs/decisions.md ADR-022, Weather row in Pro). Icon hues are fixed per icon type, never per value:
    // sun and bolt yellow, cloud and snow white, rain blue; ahead icons are MUTED. The lead number is ONE hue whatever the
    // condition (the sun's yellow), so no colour follows the reading. No accent may equal a weather hue
    // (noAccentIsAWeatherHue). Contrast on black, computed: yellow 19.7, blue 8.2.
    static const WEATHER_SUN = 0xFFFF55;
    static const WEATHER_RAIN = 0x00AAFF;
    static const WEATHER_NUMBER = WEATHER_SUN;

}

// The Instinct's twin (ADR-024): a 1-bit display shows black and white only, and how it would round any other value is
// unspecified, so every role is white on black. What colour says elsewhere, shape says here: the daylight still to come is
// a thick arc, the part gone and twilight are hairlines, the sun is a solid dot while it is up and an outline when it is
// not, the Body Battery bolt is an outline filled to its level. Same class name and roles; the jungles pick one by the
// `color`/`mono` annotations. The Accent and Golden-hour settings have no effect and are not offered.
(:mono)
class TwoSunsPalette {
    static const MONO = true;
    static const BACKGROUND = 0x000000;
    static const TEXT = 0xFFFFFF;
    static const MUTED = 0xFFFFFF;
    static const TRACK = 0xFFFFFF;
    static const SLEEP_TEXT = 0xFFFFFF;
    static const ACCENTS = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF] as Array<Number>;
    static const NIGHT = 0xFFFFFF;
    static const TWILIGHT = 0xFFFFFF;
    static const GOLDEN = 0xFFFFFF;
    static const WEATHER_SUN = 0xFFFFFF;
    static const WEATHER_RAIN = 0xFFFFFF;
    static const WEATHER_NUMBER = 0xFFFFFF;

    static function accent(index as Number) as Number {
        return TEXT;
    }

    static function dim(color as Number) as Number {
        return TEXT;
    }
}
