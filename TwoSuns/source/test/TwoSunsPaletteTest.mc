import Toybox.Lang;
import Toybox.Test;

// Regression for the winter-accent/MUTED collision watch-design-reviewer caught 2026-09-27: dim()
// must never return MUTED, or a low reading and no reading become indistinguishable by colour.
(:test)
function dimNeverEqualsMuted(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        var dimmed = TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[i]);
        Test.assertNotEqual(dimmed, TwoSunsPalette.MUTED);
    }
    return true;
}

(:test)
function dimWinterStaysDistinct(logger as Test.Logger) as Boolean {
    // Winter (index 5, 0xFFFFFF) is the one accent made only of AA/FF channels once dimmed naively.
    var dimmed = TwoSunsPalette.dim(TwoSunsPalette.ACCENTS[5]);
    Test.assertEqual(dimmed, 0x55AAAA);
    Test.assertNotEqual(dimmed, TwoSunsPalette.NIGHT);
    return true;
}
