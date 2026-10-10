import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// The accent table: append-only (the phone and the watch store the id), drawn on black. The helper is a class because
// the runner treats every (:test) function as a test case. Rules from research_notes/Free and Pro ladder/accent_roster.md.
(:test)
class SunWindowAccentCheck {
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
    static const SHIFT_RED = 16;
    static const SHIFT_GREEN = 8;
    // sky, mint, amber, pink, violet, white: never reordered or recoloured once shipped (ADR-013).
    static const SHIPPED = [0x55AAFF, 0x55FFAA, 0xFFAA00, 0xFF55AA, 0xAA55FF, 0xFFFFFF] as Array<Number>;

    static function channelOf(rgb as Number, shift as Number) as Number {
        return (rgb >> shift) & (BYTE - 1);
    }

    static function linear(channel as Number) as Float {
        var c = channel / CHANNEL_MAX;
        return c <= LINEAR_BELOW ? c / LINEAR_DIVISOR : Math.pow((c + GAMMA_OFFSET) / GAMMA_DIVISOR, GAMMA).toFloat();
    }

    static function contrastOnBlack(rgb as Number) as Float {
        var luminance = LUMA_R * linear(channelOf(rgb, SHIFT_RED)) + LUMA_G * linear(channelOf(rgb, SHIFT_GREEN)) + LUMA_B * linear(channelOf(rgb, 0));
        return (luminance + LUMA_BLACK_OFFSET) / LUMA_BLACK_OFFSET;
    }
}

(:test, :color)
function everyAccentChannelIsInThe64ColourPalette(logger as Test.Logger) as Boolean {
    var channels = SunWindowAccentCheck.CHANNELS;
    for (var i = 0; i < SunWindowPalette.ACCENTS.size(); i++) {
        for (var shift = 0; shift <= SunWindowAccentCheck.SHIFT_RED; shift += SunWindowAccentCheck.SHIFT_GREEN) {
            var value = SunWindowAccentCheck.channelOf(SunWindowPalette.ACCENTS[i], shift);
            Test.assertMessage(channels.indexOf(value) >= 0, "accent " + i + " channel " + value.format("%02X") + " is off the palette");
        }
    }
    return true;
}

// Each accent reads on black, and none is the muted grey or the path's track grey (the window must stand out from both).
// White is allowed to equal the state text: the window is the thick segment, told apart by weight and by the words.
(:test, :color)
function everyAccentReadsOnBlackAndIsNotAGreyRole(logger as Test.Logger) as Boolean {
    for (var i = 0; i < SunWindowPalette.ACCENTS.size(); i++) {
        var ratio = SunWindowAccentCheck.contrastOnBlack(SunWindowPalette.ACCENTS[i]);
        Test.assertMessage(ratio >= SunWindowAccentCheck.MIN_CONTRAST, "accent " + i + " contrast " + ratio.format("%.2f") + ":1 on black");
        Test.assertNotEqual(SunWindowPalette.ACCENTS[i], SunWindowPalette.MUTED);
        Test.assertNotEqual(SunWindowPalette.ACCENTS[i], SunWindowPalette.TRACK);
    }
    return true;
}

// Append-only: a shipped id never changes its colour; the list has exactly the count the settings file offers.
(:test, :color)
function shippedAccentIdsKeepTheirColours(logger as Test.Logger) as Boolean {
    var shipped = SunWindowAccentCheck.SHIPPED;
    Test.assert(SunWindowPalette.ACCENTS.size() >= shipped.size());
    for (var i = 0; i < shipped.size(); i++) {
        Test.assertEqual(SunWindowPalette.ACCENTS[i], shipped[i]);
        Test.assertEqual(SunWindowPalette.accent(i), shipped[i]);
    }
    Test.assertEqual(SunWindowConfig.ACCENT_COUNT, SunWindowPalette.ACCENTS.size());
    return true;
}

// A missing key, a wrong type or an id nobody offers gives the default (sky), never a crash.
(:test)
function badAccentValuesGiveTheDefault(logger as Test.Logger) as Boolean {
    var fallback = SunWindowConfig.ACCENT_DEFAULT;
    Test.assertEqual(SunWindowSettings.clamp(null), fallback);
    Test.assertEqual(SunWindowSettings.clamp("3"), fallback);
    Test.assertEqual(SunWindowSettings.clamp(2.5), fallback);
    Test.assertEqual(SunWindowSettings.clamp(-1), fallback);
    Test.assertEqual(SunWindowSettings.clamp(SunWindowConfig.ACCENT_COUNT), fallback);
    Test.assertEqual(SunWindowSettings.clamp(99), fallback);
    for (var id = 0; id < SunWindowConfig.ACCENT_COUNT; id++) {
        Test.assertEqual(SunWindowSettings.clamp(id), id);
    }
    Test.assertEqual(SunWindowPalette.accent(-1), SunWindowPalette.accent(fallback));
    Test.assertEqual(SunWindowPalette.accent(99), SunWindowPalette.accent(fallback));
    return true;
}
