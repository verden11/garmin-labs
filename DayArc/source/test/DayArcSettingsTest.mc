import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

// The accent setting's validation and palette mapping (ADR-014). Pure functions only: real
// Application.Properties would persist in the simulator's app storage and recolour later render
// tests, so nothing here writes a property.
(:test)
function garbageAccentValuesFallBackToAuto(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcSettings.clampAccent(null), DayArcConfig.ACCENT_AUTO);
    Test.assertEqual(DayArcSettings.clampAccent("3"), DayArcConfig.ACCENT_AUTO);
    Test.assertEqual(DayArcSettings.clampAccent(2.0), DayArcConfig.ACCENT_AUTO);
    Test.assertEqual(DayArcSettings.clampAccent(true), DayArcConfig.ACCENT_AUTO);
    Test.assertEqual(DayArcSettings.clampAccent(-1), DayArcConfig.ACCENT_AUTO);
    Test.assertEqual(DayArcSettings.clampAccent(DayArcConfig.ACCENT_CHOICES), DayArcConfig.ACCENT_AUTO);
    Test.assertEqual(DayArcSettings.clampAccent(99), DayArcConfig.ACCENT_AUTO);
    for (var i = 0; i < DayArcConfig.ACCENT_CHOICES; i++) {
        Test.assertEqual(DayArcSettings.clampAccent(i), i);
    }
    return true;
}

// Every choice maps to a 64-colour-safe hue (each channel 0x00/0x55/0xAA/0xFF); Auto is exactly
// ADR-013's per-window hues; a fixed choice is the same hue in every active window.
(:test :color)
function accentChoicesMapToSafeHues(logger as Test.Logger) as Boolean {
    var windows = [DayArcConfig.WINDOW_MORNING, DayArcConfig.WINDOW_MIDDAY, DayArcConfig.WINDOW_EVENING] as Array<Number>;
    Test.assertEqual(DayArcPalette.accentFor(DayArcConfig.WINDOW_MORNING, DayArcConfig.ACCENT_AUTO), 0xFFAA00);
    Test.assertEqual(DayArcPalette.accentFor(DayArcConfig.WINDOW_MIDDAY, DayArcConfig.ACCENT_AUTO), 0x55FFFF);
    Test.assertEqual(DayArcPalette.accentFor(DayArcConfig.WINDOW_EVENING, DayArcConfig.ACCENT_AUTO), 0xFF55AA);
    for (var choice = 0; choice < DayArcConfig.ACCENT_CHOICES; choice++) {
        for (var w = 0; w < windows.size(); w++) {
            var hue = DayArcPalette.accentFor(windows[w], choice);
            var channels = [(hue >> 16) & 0xFF, (hue >> 8) & 0xFF, hue & 0xFF] as Array<Number>;
            for (var c = 0; c < channels.size(); c++) {
                var safe = channels[c] == 0x00 or channels[c] == 0x55 or channels[c] == 0xAA or channels[c] == 0xFF;
                Test.assertMessage(safe, "choice " + choice + " window " + windows[w] + " has unsafe channel " + channels[c]);
            }
            if (choice >= 1) {
                Test.assertEqual(hue, DayArcPalette.accentFor(DayArcConfig.WINDOW_MIDDAY, choice));
            }
        }
    }
    return true;
}

// The Instinct palette (ADR-015): whatever the Accent choice, every accent is white and every role is white on black.
(:test :mono)
function accentIsWhiteOnTheMonoPalette(logger as Test.Logger) as Boolean {
    Test.assert(DayArcPalette.MONO);
    for (var choice = 0; choice < DayArcConfig.ACCENT_CHOICES; choice++) {
        Test.assertEqual(DayArcPalette.accentFor(DayArcConfig.WINDOW_MIDDAY, choice), DayArcPalette.TEXT);
        Test.assertEqual(DayArcPalette.hueIndex(DayArcConfig.WINDOW_MORNING, choice), DayArcPalette.HUE_CYAN);
    }
    Test.assertEqual(DayArcPalette.MUTED, DayArcPalette.TEXT);
    Test.assertEqual(DayArcPalette.ARC_TRACK, DayArcPalette.TEXT);
    Test.assertEqual(DayArcPalette.SLEEP_TEXT, DayArcPalette.TEXT);
    return true;
}

// The always-on grey (ADR-020, the studio's one always-on grey): at least 3:1 against black, the bar for a persistent colour.
// WCAG contrast against black is (L + 0.05) / 0.05, L from the sRGB channels. #5C5C5C is 3.14:1; #555555 would fail at 2.82.
// On colour screens it must also stay well under MUTED's 9.0:1 (below 4.5:1), so setting SLEEP_TEXT back to #AAAAAA fails here
// (pointing renderIdle at MUTED itself would not: only a code review catches that).
(:test)
function alwaysOnGreyReadsOnBlack(logger as Test.Logger) as Boolean {
    var color = DayArcPalette.SLEEP_TEXT;
    var weights = [0.2126, 0.7152, 0.0722] as Array<Float>;
    var luminance = 0.0;
    for (var i = 0; i < 3; i++) {
        var channel = ((color >> (16 - 8 * i)) & 0xFF) / 255.0;
        luminance += weights[i] * (channel <= 0.04045 ? channel / 12.92 : Math.pow((channel + 0.055) / 1.055, 2.4).toFloat());
    }
    var ratio = (luminance + 0.05) / 0.05;
    Test.assertMessage(ratio >= 3.0, "always-on grey contrast " + ratio.format("%.2f") + ":1 on black");
    // On a colour screen it is dimmer than the awake MUTED grey (#AAAAAA, 9.0:1), the colour ADR-020 moved away from.
    Test.assertMessage(DayArcPalette.MONO || ratio < 4.5, "always-on grey is not dimmer than MUTED: " + ratio.format("%.2f") + ":1");
    return true;
}
