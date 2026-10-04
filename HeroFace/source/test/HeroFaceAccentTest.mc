import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// The accent table: the same three ids in the Free and the Pro build, append-only, drawn on black and on the
// bar's TRACK grey (docs/decisions.md ADR-001, the Free + Pro ladder). The helper is a class because the
// runner treats every (:test) function as a test case.
(:test)
class HeroFaceAccentCheck {
    static const CHANNELS = [0x00, 0x55, 0xAA, 0xFF] as Array<Number>;   // Garmin's 64-colour palette
    static const MIN_CONTRAST = 3.0;          // WCAG non-text contrast: accent on black, and accent on TRACK
    static const CHANNEL_MAX = 255.0;
    static const LINEAR_BELOW = 0.04045;
    static const LINEAR_DIVISOR = 12.92;
    static const GAMMA_OFFSET = 0.055;
    static const GAMMA_DIVISOR = 1.055;
    static const GAMMA = 2.4;
    static const LUMA_R = 0.2126;
    static const LUMA_G = 0.7152;
    static const LUMA_B = 0.0722;
    static const LUMA_OFFSET = 0.05;          // (L1 + 0.05) / (L2 + 0.05)
    static const BYTE = 256;
    static const SHIFT_RED = 16;              // channel positions in 0xRRGGBB
    static const SHIFT_GREEN = 8;
    static const SHIFT_BLUE = 0;
    static const SHIPPED = [0x55AAFF, 0x00FFFF, 0xFFAAFF] as Array<Number>;
    static const MAGENTA = 2;
    // What the TRACK rule measures for Magenta since the owner's recolour (2026-10-04, ADR-003): 4.418, up from 2.838.
    static const MAGENTA_MEASURED = 4.42;
    static const MEASURED_TOLERANCE = 0.01;

    static function channelOf(rgb as Number, shift as Number) as Number {
        return (rgb >> shift) & (BYTE - 1);
    }

    static function linear(channel as Number) as Float {
        var c = channel / CHANNEL_MAX;
        return c <= LINEAR_BELOW ? c / LINEAR_DIVISOR : Math.pow((c + GAMMA_OFFSET) / GAMMA_DIVISOR, GAMMA).toFloat();
    }

    static function luminance(rgb as Number) as Float {
        return LUMA_R * linear(channelOf(rgb, SHIFT_RED)) + LUMA_G * linear(channelOf(rgb, SHIFT_GREEN)) + LUMA_B * linear(channelOf(rgb, SHIFT_BLUE));
    }

    // Contrast ratio of two colours, lighter over darker.
    static function contrast(a as Number, b as Number) as Float {
        var la = luminance(a);
        var lb = luminance(b);
        return la > lb ? (la + LUMA_OFFSET) / (lb + LUMA_OFFSET) : (lb + LUMA_OFFSET) / (la + LUMA_OFFSET);
    }
}

(:test)
function everyAccentChannelIsInThe64ColourPalette(logger as Test.Logger) as Boolean {
    var channels = HeroFaceAccentCheck.CHANNELS;
    for (var i = 0; i < HeroFacePalette.ACCENTS.size(); i++) {
        for (var shift = HeroFaceAccentCheck.SHIFT_BLUE; shift <= HeroFaceAccentCheck.SHIFT_RED; shift += HeroFaceAccentCheck.SHIFT_GREEN) {
            var value = HeroFaceAccentCheck.channelOf(HeroFacePalette.ACCENTS[i], shift);
            Test.assertMessage(channels.indexOf(value) >= 0, "accent " + i + " channel " + value.format("%02X") + " is off the palette");
        }
    }
    return true;
}

(:test)
function everyAccentReadsOnBlack(logger as Test.Logger) as Boolean {
    for (var i = 0; i < HeroFacePalette.ACCENTS.size(); i++) {
        var ratio = HeroFaceAccentCheck.contrast(HeroFacePalette.ACCENTS[i], HeroFacePalette.BACKGROUND);
        Test.assertMessage(ratio >= HeroFaceAccentCheck.MIN_CONTRAST, "accent " + i + " contrast " + ratio.format("%.2f") + ":1 on black");
    }
    return true;
}

// The face's own rule (HeroFacePalette): an accent clears 3:1 against TRACK so a part-filled bar reads. All three do
// (Magenta was 2.84 until the owner's recolour, ADR-003).
(:test :color)
function everyAccentClearsTheTrackRule(logger as Test.Logger) as Boolean {
    for (var i = 0; i < HeroFacePalette.ACCENTS.size(); i++) {
        var ratio = HeroFaceAccentCheck.contrast(HeroFacePalette.ACCENTS[i], HeroFacePalette.TRACK);
        Test.assertMessage(ratio >= HeroFaceAccentCheck.MIN_CONTRAST, "accent " + i + " contrast " + ratio.format("%.2f") + ":1 on the track");
    }
    return true;
}

// The owner's recolour (2026-10-04): id 2 keeps its id and its name "Magenta" and is now the pale magenta #FFAAFF. The figure is
// pinned so moving the colour or the track records the new number instead of drifting.
(:test :color)
function magentaWasRecolouredToClearTheTrackRule(logger as Test.Logger) as Boolean {
    var ratio = HeroFaceAccentCheck.contrast(HeroFacePalette.ACCENTS[HeroFaceAccentCheck.MAGENTA], HeroFacePalette.TRACK);
    logger.debug("Magenta on TRACK: " + ratio.format("%.3f") + ":1 (the rule is 3:1)");
    Test.assertMessage((ratio - HeroFaceAccentCheck.MAGENTA_MEASURED).abs() < HeroFaceAccentCheck.MEASURED_TOLERANCE, "Magenta's track contrast moved to " + ratio.format("%.3f") + ":1: record the new figure");
    return true;
}

// Gold, green and alert red carry meaning; white is the time's own colour; MUTED and TRACK are the greys.
(:test :color)
function noAccentIsAReservedRoleColour(logger as Test.Logger) as Boolean {
    var reserved = [HeroFacePalette.GOLD, HeroFacePalette.DONE, HeroFacePalette.ALERT, HeroFacePalette.TEXT, HeroFacePalette.MUTED, HeroFacePalette.TRACK] as Array<Number>;
    for (var i = 0; i < HeroFacePalette.ACCENTS.size(); i++) {
        Test.assertMessage(reserved.indexOf(HeroFacePalette.ACCENTS[i]) < 0, "accent " + i + " is a reserved role colour");
    }
    return true;
}

// Append-only: ids never move, and Blue and Cyan never changed; only Magenta (id 2) was recoloured, by the owner's decision (ADR-003). HeroFace stays at its
// shipped three in both tiers, so the Free list (Mode, Accent 0-2) and the Pro list are the same three entries.
(:test :color)
function shippedAccentIdsKeepTheirColours(logger as Test.Logger) as Boolean {
    var shipped = HeroFaceAccentCheck.SHIPPED;
    Test.assert(HeroFacePalette.ACCENTS.size() >= shipped.size());
    for (var i = 0; i < shipped.size(); i++) {
        Test.assertEqual(HeroFacePalette.ACCENTS[i], shipped[i]);
        Test.assertEqual(HeroFacePalette.accent(i), shipped[i]);
    }
    return true;
}

(:test :color)
function outOfRangeAccentIsTheDefault(logger as Test.Logger) as Boolean {
    var fallback = HeroFacePalette.ACCENTS[0];
    Test.assertEqual(HeroFacePalette.accent(-1), fallback);
    Test.assertEqual(HeroFacePalette.accent(HeroFacePalette.ACCENTS.size()), fallback);
    Test.assertEqual(HeroFacePalette.accent(99), fallback);
    return true;
}

// The Instinct palette (ADR-002): whatever the setting says, the accent is white and every role is white on black.
(:test :mono)
function accentIsWhiteOnTheMonoPalette(logger as Test.Logger) as Boolean {
    Test.assert(HeroFacePalette.MONO);
    for (var i = -1; i <= HeroFacePalette.ACCENTS.size(); i++) {
        Test.assertEqual(HeroFacePalette.accent(i), HeroFacePalette.TEXT);
    }
    Test.assertEqual(HeroFacePalette.MUTED, HeroFacePalette.TEXT);
    Test.assertEqual(HeroFacePalette.TRACK, HeroFacePalette.TEXT);
    return true;
}
