import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// The accent table: shared by Free (ids 0 to 5) and Pro, append-only, drawn on black. The helper is a class
// because the runner treats every (:test) function as a test case.
(:test)
class DaysToGoAccentCheck {
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
    static const RED_SHIFT = 16;
    static const GREEN_SHIFT = 8;
    static const BLUE_SHIFT = 0;
    static const SHIFT_STEP = 8;
    static const FIRST_FREE_ACCENT = 0;
    static const LAST_FREE_ACCENT = 5;
    static const SHIPPED = [0x55FFAA, 0xFFAA00, 0x55AAFF, 0xFF55AA, 0xAA55FF, 0xFFFFFF] as Array<Number>;

    static function channelOf(rgb as Number, shift as Number) as Number {
        return (rgb >> shift) & (BYTE - 1);
    }

    static function linear(channel as Number) as Float {
        var c = channel / CHANNEL_MAX;
        return c <= LINEAR_BELOW ? c / LINEAR_DIVISOR : Math.pow((c + GAMMA_OFFSET) / GAMMA_DIVISOR, GAMMA).toFloat();
    }

    static function contrastOnBlack(rgb as Number) as Float {
        var luminance = LUMA_R * linear(channelOf(rgb, RED_SHIFT)) + LUMA_G * linear(channelOf(rgb, GREEN_SHIFT)) + LUMA_B * linear(channelOf(rgb, BLUE_SHIFT));
        return (luminance + LUMA_BLACK_OFFSET) / LUMA_BLACK_OFFSET;
    }
}

(:test)
function everyAccentChannelIsInThe64ColourPalette(logger as Test.Logger) as Boolean {
    var channels = DaysToGoAccentCheck.CHANNELS;
    for (var i = 0; i < DaysToGoPalette.ACCENTS.size(); i++) {
        for (var shift = DaysToGoAccentCheck.BLUE_SHIFT; shift <= DaysToGoAccentCheck.RED_SHIFT; shift += DaysToGoAccentCheck.SHIFT_STEP) {
            var value = DaysToGoAccentCheck.channelOf(DaysToGoPalette.ACCENTS[i], shift);
            Test.assertMessage(channels.indexOf(value) >= 0, "accent " + i + " channel " + value.format("%02X") + " is off the palette");
        }
    }
    return true;
}

(:test)
function everyAccentReadsOnBlack(logger as Test.Logger) as Boolean {
    for (var i = 0; i < DaysToGoPalette.ACCENTS.size(); i++) {
        var ratio = DaysToGoAccentCheck.contrastOnBlack(DaysToGoPalette.ACCENTS[i]);
        Test.assertMessage(ratio >= DaysToGoAccentCheck.MIN_CONTRAST, "accent " + i + " contrast " + ratio.format("%.2f") + ":1 on black");
    }
    return true;
}

// Append-only: a shipped id never changes its colour (the phone and the watch store the id). Ids 6 and up
// are deferred; when they land they are appended and this list grows.
(:test :color)
function shippedAccentIdsKeepTheirColours(logger as Test.Logger) as Boolean {
    var shipped = DaysToGoAccentCheck.SHIPPED;
    Test.assert(DaysToGoPalette.ACCENTS.size() >= shipped.size());
    for (var i = 0; i < shipped.size(); i++) {
        Test.assertEqual(DaysToGoPalette.ACCENTS[i], shipped[i]);
    }
    Test.assertEqual(DaysToGoConfig.ACCENT_COUNT, DaysToGoPalette.ACCENTS.size());
    return true;
}

(:test :color)
function outOfRangeAccentIsTheDefault(logger as Test.Logger) as Boolean {
    var fallback = DaysToGoPalette.ACCENTS[0];
    Test.assertEqual(DaysToGoPalette.accent(-1), fallback);
    Test.assertEqual(DaysToGoPalette.accent(DaysToGoPalette.ACCENTS.size()), fallback);
    Test.assertEqual(DaysToGoPalette.accent(99), fallback);
    Test.assertEqual(new DaysToGoSettings({"Accent" => -1} as Dictionary).accent, 0);
    Test.assertEqual(new DaysToGoSettings({"Accent" => DaysToGoConfig.ACCENT_COUNT} as Dictionary).accent, 0);
    return true;
}

// Both tiers offer ids 0 to 5 (the Free list), and the settings reader accepts each.
(:test :color)
function freeAccentIdsAreAccepted(logger as Test.Logger) as Boolean {
    for (var id = DaysToGoAccentCheck.FIRST_FREE_ACCENT; id <= DaysToGoAccentCheck.LAST_FREE_ACCENT; id++) {
        Test.assertEqual(new DaysToGoSettings({"Accent" => id} as Dictionary).accent, id);
        Test.assertEqual(DaysToGoPalette.accent(id), DaysToGoAccentCheck.SHIPPED[id]);
    }
    return true;
}

// The Instinct palette (ADR-015): whatever the setting says, the accent is white and every role is white on black.
(:test :mono)
function accentIsWhiteOnTheMonoPalette(logger as Test.Logger) as Boolean {
    Test.assert(DaysToGoPalette.MONO);
    for (var i = -1; i <= DaysToGoPalette.ACCENTS.size(); i++) {
        Test.assertEqual(DaysToGoPalette.accent(i), DaysToGoPalette.TEXT);
    }
    Test.assertEqual(DaysToGoPalette.MUTED, DaysToGoPalette.TEXT);
    Test.assertEqual(DaysToGoPalette.TRACK, DaysToGoPalette.TEXT);
    return true;
}
