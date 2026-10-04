import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// The accent table: shared by Free (ids 0 to 5, all six) and Pro, append-only, drawn on black. The helper is a class
// because the runner treats every (:test) function as a test case. Ids 6 and up are deferred (docs/decisions.md ADR-020,
// Free + Pro ladder): when they land they are appended, Pro only, and SHIPPED below grows.
(:test)
class TwoSunsAccentCheck {
    static const CHANNELS = [0x00, 0x55, 0xAA, 0xFF] as Array<Number>;   // Garmin's 64-colour palette
    static const MIN_CONTRAST = 3.0;          // WCAG non-text contrast, accent on the black background
    static const CHANNEL_MAX = 255.0;
    static const LINEAR_BELOW = 0.04045;
    static const LINEAR_DIVISOR = 12.92;
    static const GAMMA_OFFSET = 0.055;
    static const GAMMA_DIVISOR = 1.055;
    static const GAMMA = 2.4;
    static const LUMA_R = 0.2126;
    static const LUMA_G = 0.7152;
    static const LUMA_B = 0.0722;
    static const LUMA_BLACK_OFFSET = 0.05;    // (L + 0.05) / (0 + 0.05)
    static const BYTE = 256;
    static const FIRST_FREE_ACCENT = 0;
    static const LAST_FREE_ACCENT = 5;
    static const SHIFT_RED = 16;
    static const SHIFT_GREEN = 8;
    static const SHIFT_BLUE = 0;
    static const SHIPPED = [0x55AAFF, 0x55FFAA, 0xFFAA00, 0xAA55FF, 0xFF55AA, 0xFFFFFF] as Array<Number>;   // sky, mint, autumn, violet, pink, winter

    static function channelOf(rgb as Number, shift as Number) as Number {
        return (rgb >> shift) & (BYTE - 1);
    }

    static function linear(channel as Number) as Float {
        var c = channel / CHANNEL_MAX;
        return c <= LINEAR_BELOW ? c / LINEAR_DIVISOR : Math.pow((c + GAMMA_OFFSET) / GAMMA_DIVISOR, GAMMA).toFloat();
    }

    static function contrastOnBlack(rgb as Number) as Float {
        var luminance = LUMA_R * linear(channelOf(rgb, SHIFT_RED)) + LUMA_G * linear(channelOf(rgb, SHIFT_GREEN)) + LUMA_B * linear(channelOf(rgb, SHIFT_BLUE));
        return (luminance + LUMA_BLACK_OFFSET) / LUMA_BLACK_OFFSET;
    }
}

(:test)
function everyAccentChannelIsInThe64ColourPalette(logger as Test.Logger) as Boolean {
    var channels = TwoSunsAccentCheck.CHANNELS;
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        for (var shift = 0; shift <= TwoSunsAccentCheck.SHIFT_RED; shift += TwoSunsAccentCheck.SHIFT_GREEN) {
            var value = TwoSunsAccentCheck.channelOf(TwoSunsPalette.ACCENTS[i], shift);
            Test.assertMessage(channels.indexOf(value) >= 0, "accent " + i + " channel " + value.format("%02X") + " is off the palette");
        }
    }
    return true;
}

// The accent and its dimmed form (daylight already gone, a low Body Battery) both read on black.
(:test)
function everyAccentAndItsDimReadOnBlack(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        var ratio = TwoSunsAccentCheck.contrastOnBlack(TwoSunsPalette.ACCENTS[i]);
        Test.assertMessage(ratio >= TwoSunsAccentCheck.MIN_CONTRAST, "accent " + i + " contrast " + ratio.format("%.2f") + ":1 on black");
        var dimmed = TwoSunsAccentCheck.contrastOnBlack(TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[i]));
        Test.assertMessage(dimmed >= TwoSunsAccentCheck.MIN_CONTRAST, "dimmed accent " + i + " contrast " + dimmed.format("%.2f") + ":1 on black");
    }
    return true;
}

// The ring's golden hour keeps its own colour: no accent, and no dimmed accent, may be it.
(:test, :color)
function noAccentIsTheGoldenHourColour(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        Test.assertNotEqual(TwoSunsPalette.ACCENTS[i], TwoSunsPalette.GOLDEN);
        Test.assertNotEqual(TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[i]), TwoSunsPalette.GOLDEN);
    }
    return true;
}

// Append-only: a shipped id never changes its colour (the phone and the watch store the id). Ids 6 and up
// are deferred; when they land they are appended and this list grows.
(:test, :color)
function shippedAccentIdsKeepTheirColours(logger as Test.Logger) as Boolean {
    var shipped = TwoSunsAccentCheck.SHIPPED;
    Test.assert(TwoSunsPalette.ACCENTS.size() >= shipped.size());
    for (var i = 0; i < shipped.size(); i++) {
        Test.assertEqual(TwoSunsPalette.ACCENTS[i], shipped[i]);
    }
    Test.assertEqual(TwoSunsConfig.ACCENT_COUNT, TwoSunsPalette.ACCENTS.size());
    return true;
}

(:test)
function outOfRangeAccentIsTheDefault(logger as Test.Logger) as Boolean {
    var fallback = TwoSunsPalette.ACCENTS[0];
    Test.assertEqual(TwoSunsPalette.accent(-1), fallback);
    Test.assertEqual(TwoSunsPalette.accent(TwoSunsPalette.ACCENTS.size()), fallback);
    Test.assertEqual(TwoSunsPalette.accent(99), fallback);
    Test.assertEqual(new TwoSunsSettings({"Accent" => -1} as Dictionary).accent, 0);
    Test.assertEqual(new TwoSunsSettings({"Accent" => TwoSunsConfig.ACCENT_COUNT} as Dictionary).accent, 0);
    return true;
}

// Both tiers offer ids 0 to 5 (the Free list is the shipped list), and the settings reader accepts each.
(:test, :color)
function freeAccentIdsAreAccepted(logger as Test.Logger) as Boolean {
    for (var id = TwoSunsAccentCheck.FIRST_FREE_ACCENT; id <= TwoSunsAccentCheck.LAST_FREE_ACCENT; id++) {
        Test.assertEqual(new TwoSunsSettings({"Accent" => id} as Dictionary).accent, id);
        Test.assertEqual(TwoSunsPalette.accent(id), TwoSunsAccentCheck.SHIPPED[id]);
    }
    return true;
}
