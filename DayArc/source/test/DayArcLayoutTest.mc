import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

// The clock row's rowMaxWidth going negative on Venu Sq 2 (320x360) is deterministic from the
// device's documented resolution, not something `everyWindowRendersWithoutError` can catch (a
// negative maxWidth fed to DayArcText.truncated doesn't throw, it just renders one truncated
// character with no ellipsis) — watch-design-reviewer, 2026-09-28. Constructs synthetic Dcs at
// known real product resolutions (not whichever device happens to run this test) so the check
// holds across the device range regardless of simulator target.
(:test)
function clockRowNeverGoesNegativeAcrossDeviceShapes(logger as Test.Logger) as Boolean {
    var resolutions = [
        [454, 454], // fr965: round, width == height
        [390, 390], // approachs50: smallest round in the set, width == height
        [320, 360], // venusq2 / venusq2m: rectangular, height > width
        [448, 486], // venux1: rectangular, height > width
    ] as Array<Array<Number>>;
    for (var i = 0; i < resolutions.size(); i++) {
        var width = resolutions[i][0];
        var height = resolutions[i][1];
        var bitmap = Graphics.createBufferedBitmap({:width => width, :height => height}).get() as Graphics.BufferedBitmap;
        var dc = bitmap.getDc();
        var layout = new DayArcLayout(dc);
        var clockHeight = dc.getFontHeight(DayArcLayout.CLOCK_FONTS[0]);
        var maxWidth = layout.rowMaxWidth(layout.topMargin(), clockHeight);
        Test.assertMessage(maxWidth > 0, width + "x" + height + ": clock rowMaxWidth=" + maxWidth);
    }
    return true;
}

// Pro's grid sizes each row from its own chord and drops a row when a cell's value would not fit
// whole (cloud review, 2026-09-28: the old single narrowest-row column width + label-blind floor let
// icon + label + value cells degrade to an ellipsis and one digit). Per real product shape: a
// zero-width column never fits, a centre-row column always fits an icon-only cell, and column width
// never grows toward the bezel. The logged per-row fit is the numeric evidence for docs, not an assertion.
(:test, :pro)
function gridRowsFitByTheirOwnChordAcrossDeviceShapes(logger as Test.Logger) as Boolean {
    var resolutions = [[454, 454], [390, 390], [320, 360], [448, 486]] as Array<Array<Number>>;
    var worst = {:label => "Next event", :value => "2:30 PM", :icon => DayArcIcons.GRID_CALENDAR} as Dictionary;
    var iconOnly = {:label => null, :value => "1,180", :icon => DayArcIcons.GRID_FLAME} as Dictionary;
    for (var i = 0; i < resolutions.size(); i++) {
        var width = resolutions[i][0];
        var height = resolutions[i][1];
        var dc = (Graphics.createBufferedBitmap({:width => width, :height => height}).get() as Graphics.BufferedBitmap).getDc();
        var layout = new DayArcLayout(dc);
        var rowHeight = layout.gridRowHeight(dc);
        var previous = width;
        var fitted = 0;
        for (var y = layout.centerY(); y + rowHeight <= layout.gridBottom(); y += rowHeight) {
            var columnWidth = layout.gridRowColumnWidth(y, rowHeight);
            Test.assertMessage(columnWidth <= previous, width + "x" + height + ": column grew toward the bezel at y=" + y);
            previous = columnWidth;
            var worstFits = DayArcGrid.cellFits(dc, layout, worst, columnWidth);
            fitted += worstFits ? 1 : 0;
            logger.debug(width + "x" + height + " y=" + y + " column=" + columnWidth + " worstCellFits=" + worstFits + " iconOnlyFits=" + DayArcGrid.cellFits(dc, layout, iconOnly, columnWidth));
        }
        Test.assertMessage(!DayArcGrid.cellFits(dc, layout, worst, 0), width + "x" + height + ": zero-width column claimed to fit");
        var centreColumn = layout.gridRowColumnWidth(layout.centerY(), rowHeight);
        Test.assertMessage(DayArcGrid.cellFits(dc, layout, iconOnly, centreColumn), width + "x" + height + ": icon-only cell does not fit the centre row, column=" + centreColumn);
    }
    return true;
}
