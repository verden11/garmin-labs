import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
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

// Subscreen window (Instinct, ADR-055): a row that shares its line with the
// window must end left of it, and its text must be centered inside what is
// left. Everywhere else (round products, no window) the center never moves.

(:test)
function rowsBesideASubscreenWindowStayClearOfIt(logger as Test.Logger) as Lang.Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var layout = new HeroSetLayout(bitmap.getDc());
    var window = layout.subscreen();
    var rowHeight = 18;
    for (var y = 0; y + rowHeight < layout.height(); y += 4) {
        var center = layout.rowCenterX(y, rowHeight);
        Test.assert(center >= layout.leftInset(y, rowHeight) && center <= layout.rightInset(y, rowHeight));
        if (window == null) {
            Test.assertEqual(center, layout.centerX());
        } else if (y < window.y + window.height) {
            Test.assert(layout.rightInset(y, rowHeight) <= window.x);
        }
    }
    return true;
}

// Rectangle XP track (ADR-057): a closed rounded rectangle from top centre,
// clockwise. On a 320x360 display (Venu Sq 2: inset 32, stroke 5, margin 16)
// the path is five straight runs (106 + 252 + 212 + 252 + 106) and four
// quarter circles of radius 48 (75 px each), and a share of XP fills the same
// share of that length.
(:test)
function rectTrackFillIsTheShareOfItsLength(logger as Test.Logger) as Lang.Boolean {
    var track = new HeroSetRectTrack(320, 360, 32, 5, 16);
    Test.assertEqual(track.quarterArc(), 75);
    Test.assertEqual(track.length(), 928 + 4 * 75);
    Test.assertEqual(track.fillFor(0, 300), 0);
    Test.assertEqual(track.fillFor(5, 0), 0);
    Test.assertEqual(track.fillFor(1, 999999), 1);
    Test.assertEqual(track.fillFor(150, 300), track.length() / 2);
    Test.assertEqual(track.fillFor(75, 300), track.length() / 4);
    Test.assertEqual(track.fillFor(300, 300), track.length());
    Test.assertEqual(track.fillFor(900, 300), track.length());
    // Rows inside: the full inner width mid-screen, narrower in a corner.
    Test.assertEqual(track.inset(150, 30), track.contentTop());
    Test.assert(track.inset(track.contentTop(), 30) > track.contentTop());
    return true;
}

// On this device: the track (stroke included) stays on the display and its
// inner box inside the display's own insets; every other shape has no track.
(:test)
function rectTrackStaysOnThisDisplay(logger as Test.Logger) as Lang.Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var layout = new HeroSetLayout(bitmap.getDc());
    var track = layout.track();
    if (settings.screenShape != System.SCREEN_SHAPE_RECTANGLE) {
        Test.assert(track == null);
        return true;
    }
    Test.assert(track != null);
    var t = track as HeroSetRectTrack;    var b = t.box();
    var half = t.stroke() / 2;
    Test.assert(b[0] - half >= 0 && b[1] - half >= 0);
    Test.assert(b[2] - half + t.stroke() <= settings.screenWidth && b[3] - half + t.stroke() <= settings.screenHeight);
    Test.assert(2 * b[4] < b[2] - b[0] && 2 * b[4] < b[3] - b[1]);
    Test.assert(t.contentTop() >= layout.leftInset(layout.centerY(), 0));
    Test.assert(t.contentBottom() > t.contentTop());
    Test.assert(t.fillFor(1, 2) * 2 - t.length() <= 1);
    return true;
}
