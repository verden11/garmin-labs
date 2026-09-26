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

// The always-on frame at each of the nine drift positions, for the widest heroes.
(:test)
function alwaysOnFrameFitsAtEveryDrift(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new DaysToGoLayout(dc);
    var problems = [] as Array<String>;
    DaysToGoDraw.misfits = [] as Array<String>;
    try {
        var states = DaysToGoTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            for (var minute = 0; minute < DaysToGoConfig.BURN_IN_GRID * DaysToGoConfig.BURN_IN_GRID; minute++) {
                DaysToGoDraw.boxes = [] as Array<Array>;
                DaysToGoSleep.draw(dc, layout, states[i], minute);
                DaysToGoTestStates.collect("sleep " + i + "/" + minute, states[i], problems);
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
    var states = [live, DaysToGoTestStates.upcoming(365, 0, "Race"), DaysToGoTestStates.upcoming(12775, 0, "WWWWWWWWWWWWWWWW")] as Array<DaysToGoState>;
    for (var s = 0; s < states.size(); s++) {
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
