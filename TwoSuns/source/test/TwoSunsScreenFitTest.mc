import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

function testDc() as Graphics.Dc {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap;
    return bitmap.getDc();
}

// Renders the face at this device's real resolution and fonts in its widest states, and fails if any
// text leaves the display or two texts overlap. Run per product: `tools/run_tests.sh <device> everyStateFitsThisDisplay`.
(:test)
function everyStateFitsThisDisplay(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var view = new TwoSunsView();
    var problems = [] as Array<String>;
    TwoSunsDraw.misfits = [] as Array<String>;
    try {
        var states = TwoSunsTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            TwoSunsDraw.boxes = [] as Array<Array>;
            view.drawState(dc, layout, states[i]);
            var frame = new TwoSunsFrame(dc, layout, states[i], false);
            TwoSunsTestStates.collect(i.toString(), states[i], frame, TwoSunsTestStates.rowCount(frame, false), problems);
            if (layout.stackHeight(frame.showDate ? dc.getFontHeight(frame.dateFont) : 0, dc.getFontHeight(frame.timeFont),
                                   frame.bandHeight, frame.showLine ? dc.getFontHeight(frame.lineFont) : 0) > layout.spanHeight()) {
                problems.add("state " + i + " stack is taller than the span even with rows dropped");
            }
        }
    } finally {
        problems.addAll(TwoSunsDraw.misfits as Array<String>);
        TwoSunsDraw.misfits = null;
        TwoSunsDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(dc.getWidth() + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// The always-on frame at each of the nine drift positions, for every state.
(:test)
function alwaysOnFrameFitsAtEveryDrift(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var problems = [] as Array<String>;
    TwoSunsDraw.misfits = [] as Array<String>;
    try {
        var states = TwoSunsTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            for (var minute = 0; minute < TwoSunsConfig.BURN_IN_GRID * TwoSunsConfig.BURN_IN_GRID; minute++) {
                TwoSunsDraw.boxes = [] as Array<Array>;
                TwoSunsSleep.draw(dc, layout, states[i], minute);
                var frame = new TwoSunsFrame(dc, layout, states[i], true);
                TwoSunsTestStates.collect("sleep " + i + "/" + minute, states[i], frame, TwoSunsTestStates.rowCount(frame, true), problems);
            }
        }
    } finally {
        problems.addAll(TwoSunsDraw.misfits as Array<String>);
        TwoSunsDraw.misfits = null;
        TwoSunsDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(dc.getWidth() + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// Prints every row's box on this device, so layout can be checked without a screenshot:
// `tools/run_tests.sh <device> twoSunsLayoutReport`, then read bin/t-<device>.log.
(:test)
function twoSunsLayoutReport(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var view = new TwoSunsView();
    var live = new TwoSunsSources().read(TwoSunsSettings.load());
    logger.debug(dc.getWidth() + "x" + dc.getHeight() + " ring r=" + layout.ringRadius() + " w=" + layout.ringWidth()
        + " content r=" + layout.contentRadius() + " span=" + layout.spanHeight() + " live time=" + live.time + " line=" + live.skyLine);
    var states = [live, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(100, 3), true)] as Array<TwoSunsState>;
    for (var s = 0; s < states.size(); s++) {
        TwoSunsDraw.boxes = [] as Array<Array>;
        view.drawState(dc, layout, states[s]);
        var boxes = TwoSunsDraw.boxes as Array<Array>;
        for (var i = 0; i < boxes.size(); i++) {
            var b = boxes[i] as Array;
            logger.debug("  [" + s + "] '" + (b[4] as String) + "' x=" + (b[0] as Number) + " y=" + (b[1] as Number) + " w=" + (b[2] as Number) + " h=" + (b[3] as Number));
        }
    }
    TwoSunsDraw.boxes = null;
    return true;
}

// A cut text always ends in "..." and fits; an uncut one comes back unchanged.
(:test)
function truncatedKeepsTheMarker(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var font = Graphics.FONT_XTINY;
    var text = "WWWWWWWWWWWWWWWW";
    var width = dc.getTextWidthInPixels(text, font) / 2;
    var cut = TwoSunsDraw.truncated(dc, text, font, width);
    Test.assert(cut.length() > 3);
    Test.assertEqual(cut.substring(cut.length() - 3, cut.length()) as String, "...");
    Test.assert(dc.getTextWidthInPixels(cut, font) <= width);
    Test.assertEqual(TwoSunsDraw.truncated(dc, "Race", font, width), "Race");
    return true;
}

// A big screen has room for every row: nothing may be dropped on the 390 px and larger round products.
(:test)
function bigScreensKeepEveryRow(logger as Test.Logger) as Boolean {
    var dc = testDc();
    if (dc.getWidth() < 390) {
        return true;
    }
    var layout = new TwoSunsLayout(dc);
    var frame = new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), false);
    Test.assert(frame.showDate);
    Test.assert(frame.showLine);
    return true;
}

// The frame keeps the time and the value on every product, and drops date, curve, line in that order.
(:test)
function frameDropsRowsInOrder(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var full = new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), false);
    if (full.showDate) {
        Test.assert(full.showLine);      // the date only survives while everything else does
    }
    if (full.showCurve) {
        Test.assert(full.showLine);      // a kept curve implies a kept line
    }
    Test.assert(full.rows.timeTop > 0);
    Test.assert(full.rows.bandTop > full.rows.timeTop);
    var asleep = new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), true);
    Test.assert(!asleep.showDate && !asleep.showCurve);
    return true;
}

// Rows drop date first, then the curve, then the sun line, and the time and value never drop. Real device
// fonts on a tiny drawing surface force the drops on any product, so the order is exercised everywhere.
(:test)
function framesDropRowsInOrderWhenTheScreenIsTiny(logger as Test.Logger) as Boolean {
    var state = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true);
    var sawADrop = false;
    for (var size = 100; size <= 260; size += 20) {
        var bitmap = Graphics.createBufferedBitmap({:width => size, :height => size}).get() as Graphics.BufferedBitmap;
        var dc = bitmap.getDc();
        var frame = new TwoSunsFrame(dc, new TwoSunsLayout(dc), state, false);
        Test.assertMessage(frame.showCurve || !frame.showDate, "date kept after the curve was dropped at " + size);
        Test.assertMessage(frame.showLine || !frame.showCurve, "curve kept after the line was dropped at " + size);
        sawADrop = sawADrop || !frame.showDate;
    }
    Test.assert(sawADrop);
    return true;
}
