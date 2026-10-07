import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

function testDc() as Graphics.Dc {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    // createBufferedBitmap is CIQ 4.0+; 3.x products only have the constructor.
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    return bitmap.getDc();
}

// Renders the face at this device's real resolution and fonts in its widest
// states, and fails if any text leaves the display or two texts overlap.
// Run per product: `tools/run_tests.sh <device> everyStateFitsThisDisplay`.
(:test)
function everyStateFitsThisDisplay(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new DaysToGoLayout(dc);
    var view = new DaysToGoView();
    var problems = [] as Array<String>;
    DaysToGoDraw.misfits = [] as Array<String>;
    try {
        var states = DaysToGoTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            DaysToGoDraw.boxes = [] as Array<Array>;
            view.drawState(dc, layout, states[i]);
            DaysToGoTestStates.collect(i.toString(), states[i], problems);
        }
    } finally {
        problems.addAll(DaysToGoDraw.misfits as Array<String>);
        DaysToGoDraw.misfits = null;
        DaysToGoDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(dc.getWidth() + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// A bottom line the owner switched on is drawn, on its own row or sharing the date's, with a named event too (the
// busiest stack: it used to vanish on a 454 px display). Asked of round displays of 218 px and up and of the rectangles,
// whose square stack (ADR-019) has room for it on every size: the Instinct has no bottom line (ADR-015).
(:test)
function bottomLineIsDrawnNotSilentlyDropped(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new DaysToGoLayout(dc);
    var view = new DaysToGoView();
    if (layout.track() == null && (System.getDeviceSettings().screenShape != System.SCREEN_SHAPE_ROUND || dc.getHeight() < 218)) {
        return true;
    }
    var states = [DaysToGoTestStates.withFooter(DaysToGoTestStates.upcoming(76, 0, "Anna and Tom"), "50%"),
                  DaysToGoTestStates.withFooter(DaysToGoTestStates.upcoming(365, 0, "Race"), "100%")] as Array<DaysToGoState>;
    for (var i = 0; i < states.size(); i++) {
        DaysToGoDraw.boxes = [] as Array<Array>;
        view.drawState(dc, layout, states[i]);
        var found = false;
        var boxes = DaysToGoDraw.boxes as Array<Array>;
        for (var b = 0; b < boxes.size(); b++) {
            found = found || (boxes[b][4] as String).find(states[i].footer as String) != null;
        }
        DaysToGoDraw.boxes = null;
        Test.assert(found);
    }
    return true;
}

// The always-on frame at each of the nine drift positions, for the widest heroes.
(:test)
function alwaysOnFrameFitsAtEveryDrift(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new DaysToGoLayout(dc);
    if (layout.subscreen() != null) {
        return true;   // the always-on frame is drawn on burn-in (AMOLED) screens only; an Instinct is MIP (ADR-015)
    }
    var problems = [] as Array<String>;
    DaysToGoDraw.misfits = [] as Array<String>;
    try {
        var states = DaysToGoTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            for (var minute = 0; minute < DaysToGoConfig.BURN_IN_GRID * DaysToGoConfig.BURN_IN_GRID; minute++) {
                DaysToGoDraw.boxes = [] as Array<Array>;
                DaysToGoSleep.draw(dc, layout, states[i], minute);
                DaysToGoTestStates.collect("sleep " + i + "/" + minute, states[i], problems);
                // The time is drawn whole, never cut to fit (it was cut to "1" on a 240 px rectangle, 2026-10-05).
                var whole = false;
                var boxes = DaysToGoDraw.boxes as Array<Array>;
                for (var b = 0; b < boxes.size(); b++) {
                    whole = whole || (boxes[b][4] as String).equals(states[i].time);
                }
                if (!whole) {
                    problems.add("sleep " + i + "/" + minute + ": time '" + states[i].time + "' not drawn whole");
                }
            }
        }
    } finally {
        problems.addAll(DaysToGoDraw.misfits as Array<String>);
        DaysToGoDraw.misfits = null;
        DaysToGoDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(dc.getWidth() + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// Prints every row's box on this device, so layout can be checked without a
// screenshot: `tools/run_tests.sh <device> daysToGoLayoutReport`.
(:test)
function daysToGoLayoutReport(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new DaysToGoLayout(dc);
    var view = new DaysToGoView();
    var live = DaysToGoReadings.take(DaysToGoSettings.load());
    logger.debug(dc.getWidth() + "x" + dc.getHeight() + " ring r=" + layout.ringRadius() + " w=" + layout.ringWidth()
        + " content r=" + layout.contentRadius() + " live hero=" + live.hero + " time=" + live.time);
    var fonts = DaysToGoType.heroFonts(false, false);
    for (var f = 0; f < fonts.size() && (Graphics has :getFontAscent); f++) {
        logger.debug("  number font " + f + ": height " + dc.getFontHeight(fonts[f]) + " ascent " + Graphics.getFontAscent(fonts[f]));
    }
    var states = [live, DaysToGoTestStates.upcoming(365, 0, "Race"), DaysToGoTestStates.upcoming(12775, 0, "WWWWWWWWWWWWWWWW")] as Array<DaysToGoState>;
    for (var s = 0; s < states.size(); s++) {
        var frame = new DaysToGoFrame(dc, layout, states[s], false);
        logger.debug("  [" + s + "] hero band before settle " + frame.heroBand + ", after: top " + frame.rows.heroTop + " height " + frame.rows.heroHeight + " caption " + frame.rows.captionTop + " date " + frame.rows.dateTop);
        DaysToGoDraw.boxes = [] as Array<Array>;
        view.drawState(dc, layout, states[s]);
        var boxes = DaysToGoDraw.boxes as Array<Array>;
        for (var i = 0; i < boxes.size(); i++) {
            var b = boxes[i] as Array;
            logger.debug("  [" + s + "] '" + (b[4] as String) + "' x=" + (b[0] as Number) + " y=" + (b[1] as Number) + " w=" + (b[2] as Number) + " h=" + (b[3] as Number));
        }
    }
    DaysToGoDraw.boxes = null;
    return true;
}

// A cut name always ends in "..." and fits; an uncut one comes back unchanged.
(:test)
function truncatedKeepsTheMarker(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var font = Graphics.FONT_XTINY;
    var name = "WWWWWWWWWWWWWWWW";
    var width = dc.getTextWidthInPixels(name, font) / 2;
    var cut = DaysToGoDraw.truncated(dc, name, font, width);
    Test.assert(cut.length() > 3);
    Test.assertEqual(cut.substring(cut.length() - 3, cut.length()) as String, "...");
    Test.assert(dc.getTextWidthInPixels(cut, font) <= width);
    Test.assertEqual(DaysToGoDraw.truncated(dc, "Race", font, width), "Race");
    return true;
}

// Beside the Instinct's window a row ends left of it (and is centred in what is left); below it, or on any other
// product, rows keep the whole display and the screen's centre (ADR-015).
(:test)
function rowsBesideAWindowStayClearOfIt(logger as Test.Logger) as Boolean {
    var layout = new DaysToGoLayout(testDc());
    var window = layout.subscreen();
    var rowHeight = 18;
    for (var y = 0; y + rowHeight < layout.height(); y += 4) {
        var center = layout.rowCenterX(y, rowHeight);
        if (window == null) {
            Test.assertEqual(center, layout.centerX());
        } else {
            Test.assert(center >= layout.leftInset(y, rowHeight) && center <= layout.rightInset(y, rowHeight));
            if (y < (window.y as Number) + (window.height as Number)) {
                Test.assert(layout.rightInset(y, rowHeight) <= (window.x as Number));
            }
        }
    }
    Test.assert(layout.belowWindow(0) >= (window == null ? 0 : (window.y as Number) + (window.height as Number)));
    return true;
}

// The rectangle's track (ADR-019) stays on the display (its corners leave straight runs), and a share of the ring is the same share
// of its length, drawn: what the walker draws equals the fill asked for, the day is the whole closed track, and the 95%
// cap leaves a gap. Rectangles only.
(:test)
function rectangleTrackFillMatchesItsShare(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new DaysToGoLayout(dc);
    var track = layout.track();
    if (track == null) {
        return true;
    }
    var b = track.box();
    var half = layout.ringWidth() / 2 + 1;
    Test.assert(b[0] - half >= 0 && b[1] - half >= 0 && b[2] + half <= dc.getWidth() && b[3] + half <= dc.getHeight());
    Test.assert(b[4] * 2 < b[2] - b[0] && b[4] * 2 < b[3] - b[1]);
    var length = track.length();
    Test.assertEqual(track.fillFor(DaysToGoConfig.PERMILLE), length);
    Test.assert((track.fillFor(500) - length / 2).abs() <= 1);
    Test.assert(track.fillFor(950) < length && track.fillFor(950) > length * 9 / 10);
    Test.assertEqual(track.fillFor(0), 0);
    Test.assert(track.fillFor(1) >= layout.ringWidth());
    var shares = [1, 125, 250, 500, 750, 950, 1000] as Array<Number>;
    for (var i = 0; i < shares.size(); i++) {
        var fill = track.fillFor(shares[i]);
        Test.assertEqual(DaysToGoRing.trace(dc, track, DaysToGoPalette.TRACK, fill, layout.ringWidth()), fill);
    }
    logger.debug(dc.getWidth() + "x" + dc.getHeight() + " track " + b + " length " + length);
    return true;
}
