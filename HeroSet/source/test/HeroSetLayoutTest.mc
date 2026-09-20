import Toybox.Lang;
import Toybox.Test;

// Layout smoke tests: the geometry the views ask for must stay inside the
// display, with a real chord inset on round devices.

(:test)
function chordIsNarrowerNearRoundTop(logger as Test.Logger) as Lang.Boolean {
    // Forerunner 965: 454 px round, radius 227.
    var radius = 227;
    var center = radius;
    var topHalf = HeroSetLayout.chordHalfWidth(radius, 45 - center); // band 0, dy=-182
    var midHalf = HeroSetLayout.chordHalfWidth(radius, 0);
    Test.assertEqual(midHalf, radius);
    Test.assert(topHalf < midHalf);
    Test.assert(topHalf >= 100); // still wide enough for a label row
    return true;
}

(:test)
function chordIsZeroAtAndBeyondEdge(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetLayout.chordHalfWidth(227, 227), 0);
    Test.assertEqual(HeroSetLayout.chordHalfWidth(227, 300), 0);
    return true;
}

(:test)
function chordIsWidestAtCenter(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetLayout.chordHalfWidth(227, 0), 227);
    var nearCenter = HeroSetLayout.chordHalfWidth(227, 1);
    Test.assert(nearCenter >= 225 && nearCenter < 227);
    return true;
}

(:test)
function round454EveryBandStaysInsideDisplay(logger as Test.Logger) as Lang.Boolean {
    var width = 454;
    var height = 454;
    var short = width < height ? width : height;
    var inset = short / 10;
    var step = inset + inset / 5;
    var radius = short / 2;
    var centerX = width / 2;

    for (var band = 0; band < 7; band++) {
        var y = inset + step * band;
        Test.assert(y >= 0 && y < height);
        var left = centerX - HeroSetLayout.chordHalfWidth(radius, y - radius);
        var right = centerX + HeroSetLayout.chordHalfWidth(radius, y - radius);
        Test.assert(left < right);
        Test.assert(right - left >= 100); // room for the widest label row
    }

    // Footer rows stay inside the bottom safe inset, ordered top-then-bottom.
    Test.assert(height - inset * 2 > inset);
    Test.assert(height - inset * 2 < height - inset - inset / 2);
    return true;
}

// Dashboard XP ring (ADR-031): Dc.drawArc draws a full circle when start and
// end match, so the fill sweep must stay inside (0, RING_SWEEP_DEG].

(:test)
function ringSweepScalesAndNeverClosesTheCircle(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetLayout.ringSweepFor(0, 300), 0);
    Test.assertEqual(HeroSetLayout.ringSweepFor(-10, 300), 0);
    Test.assertEqual(HeroSetLayout.ringSweepFor(10, 0), 0);
    Test.assertEqual(HeroSetLayout.ringSweepFor(1, 4200), 1);
    Test.assertEqual(HeroSetLayout.ringSweepFor(150, 300), HeroSetLayout.RING_SWEEP_DEG / 2);
    Test.assertEqual(HeroSetLayout.ringSweepFor(300, 300), HeroSetLayout.RING_SWEEP_DEG);
    Test.assertEqual(HeroSetLayout.ringSweepFor(900, 300), HeroSetLayout.RING_SWEEP_DEG);
    Test.assert(HeroSetLayout.RING_SWEEP_DEG < 360);
    return true;
}

(:test)
function arcEndDegreeRunsClockwiseAndNormalizes(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetLayout.arcEndDegree(220, 0), 220);
    Test.assertEqual(HeroSetLayout.arcEndDegree(220, 130), 90);
    Test.assertEqual(HeroSetLayout.arcEndDegree(220, 260), 320);
    Test.assertEqual(HeroSetLayout.arcEndDegree(10, 20), 350);
    return true;
}
