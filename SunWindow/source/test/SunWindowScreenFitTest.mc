import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

// Renders the full view at this device's real resolution and fonts in every state and fails if any row leaves the
// display (the round chord, the rectangle, the Instinct's ~98 px circle) or sits under the Instinct's round window.
// Run per product: `tools/run_tests.sh <device> everyStateFitsThisDisplay`. Simulator only: a wrist has not confirmed any bezel.
(:test)
function everyStateFitsThisDisplay(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new SunWindowLayout(dc);
    var problems = [] as Array<String>;
    for (var clock = 0; clock < 2; clock++) {
        var states = SunWindowTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            var rows = SunWindowRows.plan(dc, layout, states[i], clock == 0);
            collect("state " + i + (clock == 0 ? " 24h" : " 12h"), dc, layout, rows, problems);
        }
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(dc.getWidth() + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

(:debug)
function collect(label as String, dc as Graphics.Dc, layout as SunWindowLayout, rows as Array<Array>, problems as Array<String>) as Void {
    var box = layout.subscreen();
    for (var r = 0; r < rows.size(); r++) {
        var row = rows[r];
        var font = row[SunWindowRows.FONT] as Graphics.FontDefinition;
        var top = row[SunWindowRows.TOP] as Number;
        var text = row[SunWindowRows.TEXT] as String;
        var height = dc.getFontHeight(font);
        var width = dc.getTextWidthInPixels(text, font);
        if (top < 0 || top + height > dc.getHeight()) {
            problems.add(label + " row '" + text + "' leaves the display vertically (" + top + "+" + height + ")");
        }
        if (width > 2 * layout.halfWidth(top, top + height)) {
            problems.add(label + " row '" + text + "' is " + width + " px, room " + 2 * layout.halfWidth(top, top + height));
        }
        if (box != null) {
            var left = layout.centerX() - width / 2;
            if (left < box[0] + box[2] && left + width > box[0] && top < box[1] + box[3] && top + height > box[1]) {
                problems.add(label + " row '" + text + "' is under the round window");
            }
        }
        if (r > 0) {
            var above = rows[r - 1];
            var aboveBottom = (above[SunWindowRows.TOP] as Number) + dc.getFontHeight(above[SunWindowRows.FONT] as Graphics.FontDefinition);
            if (top < aboveBottom) {
                problems.add(label + " row '" + text + "' overlaps the row above");
            }
        }
    }
}

// The full view draws every state (the picture included) without a crash, in every accent.
(:test)
function everyStateDraws(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var view = new SunWindowView();
    var states = SunWindowTestStates.all();
    for (var i = 0; i < states.size(); i++) {
        for (var accent = 0; accent < SunWindowConfig.ACCENT_COUNT; accent++) {
            view.drawState(dc, states[i], accent);
        }
    }
    return true;
}

// The glance states at every glance content area that belongs to this screen size (SunWindowGlanceAreas, the simulator's
// numbers), with this product's own fonts: the title and the word row fit the height, and the mark plus the word fit the
// width (or the word drops to the small font). A screen size with no row in the table passes (regenerate the table).
(:test)
function glanceFitsEveryContentArea(logger as Test.Logger) as Boolean {
    var view = new SunWindowGlanceView();
    var states = SunWindowTestStates.all();
    var problems = [] as Array<String>;
    var screen = System.getDeviceSettings();
    var areas = [] as Array<Array<Number>>;
    for (var i = 0; i < SunWindowGlanceAreas.ALL.size(); i++) {
        var row = SunWindowGlanceAreas.ALL[i];
        if (row[0] == screen.screenWidth && row[1] == screen.screenHeight) {
            areas.add([row[2], row[3]] as Array<Number>);
        }
    }
    for (var a = 0; a < areas.size(); a++) {
        var size = {:width => areas[a][0], :height => areas[a][1]};
        var dc = (Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap).getDc();
        for (var s = 0; s < states.size(); s++) {
            view.drawState(dc, states[s]);
            var p = SunWindowGlanceView.plan(dc, states[s].kind);
            var wordFont = p[SunWindowGlanceView.WORD_FONT] as Graphics.FontDefinition;
            var bottom = (p[SunWindowGlanceView.WORD_TOP] as Number) + dc.getFontHeight(wordFont);
            var word = SunWindowMark.isDrawn(states[s].kind) ? SunWindowText.word(states[s].kind) : SunWindowText.once();
            var right = (p[SunWindowGlanceView.WORD_LEFT] as Number) + dc.getTextWidthInPixels(word, wordFont);
            if (bottom > dc.getHeight()) {
                problems.add(areas[a][0] + "x" + areas[a][1] + " state " + s + " word row ends at " + bottom);
            }
            var room = SunWindowPalette.MONO && SunWindowConfig.GLANCE_MONO_ROOM < dc.getWidth() ? SunWindowConfig.GLANCE_MONO_ROOM : dc.getWidth();
            if (dc.getTextWidthInPixels(SunWindowText.load(Rez.Strings.AppName), Graphics.FONT_XTINY) > room) {
                problems.add(areas[a][0] + "x" + areas[a][1] + " the title is wider than " + room);
            }
            if (right > room) {
                problems.add(areas[a][0] + "x" + areas[a][1] + " state " + s + " word ends at " + right);
            }
        }
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// Prints every row's box and the font heights on this device, so layout can be checked without a screenshot:
// `tools/run_tests.sh <device> sunWindowLayoutReport`, then read bin/t-<device>.log.
(:test)
function sunWindowLayoutReport(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new SunWindowLayout(dc);
    logger.debug(dc.getWidth() + "x" + dc.getHeight() + " horizon=" + layout.horizonY() + " px/deg=" + layout.pxPerDegree());
    var states = SunWindowTestStates.all();
    for (var s = 0; s < states.size(); s++) {
        var rows = SunWindowRows.plan(dc, layout, states[s], true);
        for (var r = 0; r < rows.size(); r++) {
            var font = rows[r][SunWindowRows.FONT] as Graphics.FontDefinition;
            var text = rows[r][SunWindowRows.TEXT] as String;
            logger.debug("  [" + s + "] '" + text + "' y=" + (rows[r][SunWindowRows.TOP] as Number) + " h=" + dc.getFontHeight(font)
                + " w=" + dc.getTextWidthInPixels(text, font));
        }
    }
    var stats = System.getSystemStats();
    logger.debug("memory used=" + stats.usedMemory + " free=" + stats.freeMemory + " total=" + stats.totalMemory);
    return true;
}
