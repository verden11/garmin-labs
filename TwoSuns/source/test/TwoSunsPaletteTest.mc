import Toybox.Lang;
import Toybox.Test;

// Regression for the winter-accent/MUTED collision watch-design-reviewer caught 2026-09-27: dim()
// must never return MUTED, or a low reading and no reading become indistinguishable by colour.
(:test, :color)
function dimNeverEqualsMuted(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        var dimmed = TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[i]);
        Test.assertNotEqual(dimmed, TwoSunsPalette.MUTED);
    }
    return true;
}

(:test, :color)
function dimWinterStaysDistinct(logger as Test.Logger) as Boolean {
    // Winter (index 5, 0xFFFFFF) is the one accent made only of AA/FF channels once dimmed naively.
    var dimmed = TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[5]);
    Test.assertEqual(dimmed, 0x55AAAA);
    Test.assertNotEqual(dimmed, TwoSunsPalette.NIGHT);
    return true;
}

// The Instinct palette (ADR-024): every role is white on black, whatever the Accent setting says.
(:test, :mono)
function everyRoleIsWhiteOnTheMonoPalette(logger as Test.Logger) as Boolean {
    Test.assert(TwoSunsPalette.MONO);
    for (var i = -1; i <= TwoSunsPalette.ACCENTS.size(); i++) {
        Test.assertEqual(TwoSunsPalette.accent(i), TwoSunsPalette.TEXT);
    }
    Test.assertEqual(TwoSunsPalette.dim(0x55AAFF), TwoSunsPalette.TEXT);
    Test.assertEqual(TwoSunsPalette.MUTED, TwoSunsPalette.TEXT);
    Test.assertEqual(TwoSunsPalette.NIGHT, TwoSunsPalette.TEXT);
    return true;
}
