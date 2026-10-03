import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

// Round screens at least this wide (px) have room for every row.
(:debug)
const BIG_ROUND_SCREEN_PX = 390;

(:debug)
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
                                   frame.weatherHeight, frame.bandHeight, frame.showLine ? dc.getFontHeight(frame.lineFont) : 0) > layout.spanHeight()) {
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
    var states = [live, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curveOrNull(100, 3), true)] as Array<TwoSunsState>;
    TwoSunsTestStates.addWeatherStates(states, TwoSunsTestStates.skies());   // Pro: [2] day and [3] [4] [5] next-day forms of the weather row
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
    var stats = System.getSystemStats();   // the test harness's own memory is in it, so compare Pro with Free on one device, not with a limit
    logger.debug("memory used=" + stats.usedMemory + " free=" + stats.freeMemory + " total=" + stats.totalMemory);
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
// Pro only (the date and curve rows); Free's version is freeBigScreensKeepEveryRow.
(:test, :pro)
function bigScreensKeepEveryRow(logger as Test.Logger) as Boolean {
    var dc = testDc();
    if (dc.getWidth() < BIG_ROUND_SCREEN_PX) {
        return true;
    }
    var layout = new TwoSunsLayout(dc);
    var frame = new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), false);
    Test.assert(frame.showDate);
    Test.assert(frame.showLine);
    return true;
}

// The frame keeps the time and the value on every product, and drops date, curve, line in that order. Pro only.
(:test, :pro)
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
// fonts on a tiny drawing surface force the drops on any product, so the order is exercised everywhere. Pro only.
(:test, :pro)
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

// Free has no date row and no curve: the frame is the time, the pill with the value, and the sun line, on every
// product and asleep too; the line only drops when the stack cannot fit (never on a 390 px or larger round screen).
(:test, :free)
function freeBigScreensKeepEveryRow(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var state = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true);
    var frame = new TwoSunsFrame(dc, layout, state, false);
    Test.assert(!frame.showDate);
    Test.assert(!frame.showCurve);
    Test.assert(frame.rows.timeTop > 0);
    Test.assert(frame.rows.bandTop > frame.rows.timeTop);
    Test.assertEqual(frame.bandHeight, dc.getFontHeight(frame.valueFont));   // no curve, so the band is only the value tall
    if (dc.getWidth() >= BIG_ROUND_SCREEN_PX) {
        Test.assert(frame.showLine);
    }
    var asleep = new TwoSunsFrame(dc, layout, state, true);
    Test.assert(!asleep.showDate && !asleep.showCurve);
    return true;
}

// The weather row steps down to its one-line form before the date drops, and goes before the sun line does;
// the time and the value never drop. A tiny drawing surface with the real fonts forces every step. Pro only
// (docs/decisions.md ADR-022, Weather row in Pro).
(:test, :pro)
function weatherRowStepsDownBeforeTheDateDrops(logger as Test.Logger) as Boolean {
    var state = TwoSunsTestStates.withWeather(TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), TwoSunsTestStates.widestDay());
    for (var size = 100; size <= 260; size += 20) {
        var bitmap = Graphics.createBufferedBitmap({:width => size, :height => size}).get() as Graphics.BufferedBitmap;
        var dc = bitmap.getDc();
        var frame = new TwoSunsFrame(dc, new TwoSunsLayout(dc), state, false);
        var mode = frame.weatherMode;
        Test.assertMessage(frame.showDate || mode != TwoSunsConfig.WEATHER_ROW_FULL, "date dropped while the weather row was still full at " + size);
        Test.assertMessage(frame.showLine || mode == TwoSunsConfig.WEATHER_ROW_NONE, "sun line dropped while the weather row stayed at " + size);
        Test.assertMessage(frame.weatherBoxCount == 0 || mode != TwoSunsConfig.WEATHER_ROW_NONE, "boxes counted for a dropped weather row at " + size);
    }
    return true;
}

// On the real products (the layout table in ADR-022): the 218 px screen cannot hold the two-line row beside the date,
// so it keeps the date and takes the one-line row; 240 px and larger keep the two-line row with every other row.
(:test, :pro)
function weatherRowFormFollowsTheScreen(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var state = TwoSunsTestStates.withWeather(TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), TwoSunsTestStates.widestDay());
    var frame = new TwoSunsFrame(dc, new TwoSunsLayout(dc), state, false);
    if (dc.getWidth() <= 218) {
        Test.assertEqual(frame.weatherMode, TwoSunsConfig.WEATHER_ROW_COMPACT);
        Test.assert(frame.showDate);
    } else if (dc.getWidth() >= 240 && dc.getWidth() == dc.getHeight()) {
        Test.assertEqual(frame.weatherMode, TwoSunsConfig.WEATHER_ROW_FULL);
        Test.assert(frame.showDate);
    }
    return true;
}

// Always-on draws no weather, and Free never has any.
(:test, :pro)
function alwaysOnFrameHasNoWeatherRow(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var state = TwoSunsTestStates.withWeather(TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true), TwoSunsTestStates.widestDay());
    var asleep = new TwoSunsFrame(dc, new TwoSunsLayout(dc), state, true);
    Test.assertEqual(asleep.weatherMode, TwoSunsConfig.WEATHER_ROW_NONE);
    Test.assertEqual(asleep.weatherHeight, 0);
    Test.assertEqual(asleep.weatherBoxCount, 0);
    return true;
}

// The next day's low goes first when the row is wide: on the 454 px screen the widest next-day row (weekday, icon,
// high, low and three hours) is over 75% of the chord, so the low is dropped and the ahead cells stay. Pro only.
(:test, :pro)
function weatherNextDayDropsTheLowWhenTheRowIsWide(logger as Test.Logger) as Boolean {
    var dc = testDc();
    if (dc.getWidth() != 454) {
        return true;
    }
    var state = TwoSunsTestStates.withWeather(TwoSunsTestStates.make(TwoSunsTestStates.skies()[2], null, false), TwoSunsTestStates.widestNextDay());
    var layout = new TwoSunsLayout(dc);
    var frame = new TwoSunsFrame(dc, layout, state, false);
    var weather = state.weather as TwoSunsWeather;
    Test.assertEqual(frame.weatherAhead, weather.aheadKinds.size());
    Test.assert(!TwoSunsWeatherRow.lowKept(dc, layout, weather, frame.weatherMode, frame.rows.weatherTop, frame.weatherAhead));
    return true;
}
