import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Pro's secondary field grid (ADR-009, ADR-013): two columns, one row at a time, each row sized to
// its OWN chord width — rows near the vertical centre are wider than rows near the bezel, so a
// single "narrowest row" column width (the earlier design) starved every row to fit the last one.
// A row is drawn only when both its cells leave the value at least three digits of room (cloud
// review, 2026-09-28: the old capacity floor ignored the icon + label + value shape); rows drop
// from the end, never the middle.
class DayArcGrid {
    private static const MIN_VALUE_SAMPLE = "100";

    // Simple never puts :cells in a hero dict (DayArcFields' (:simple) forWindow builds none), so
    // this is unreachable there — a same-signature stub so DayArcDraw stays one shared function
    // (ADR-003). The real body is (:pro) because it reaches DayArcIcons.gridFor.
    (:simple)
    static function draw(dc as Graphics.Dc, layout as DayArcLayout, top as Number, cells as Array<Dictionary>) as Void {
    }

    (:pro)
    static function draw(dc as Graphics.Dc, layout as DayArcLayout, top as Number, cells as Array<Dictionary>) as Void {
        var bottom = layout.gridBottom();
        var rowHeight = layout.gridRowHeight(dc);
        var rows = (cells.size() + DayArcLayout.GRID_COLUMNS - 1) / DayArcLayout.GRID_COLUMNS;
        for (var row = 0; row < rows; row++) {
            var y = top + row * rowHeight;
            if (y + rowHeight > bottom) {
                return;
            }
            var columnWidth = layout.gridRowColumnWidth(y, rowHeight);
            var first = row * DayArcLayout.GRID_COLUMNS;
            if (!rowFits(dc, layout, cells, first, columnWidth)) {
                return;
            }
            var leftColumnX = layout.centerX() - columnWidth;
            for (var column = 0; column < DayArcLayout.GRID_COLUMNS && first + column < cells.size(); column++) {
                drawCell(dc, layout, cells[first + column], leftColumnX + column * columnWidth, y, columnWidth, rowHeight);
            }
        }
    }

    (:pro)
    private static function rowFits(dc as Graphics.Dc, layout as DayArcLayout, cells as Array<Dictionary>, first as Number, columnWidth as Number) as Boolean {
        for (var column = 0; column < DayArcLayout.GRID_COLUMNS && first + column < cells.size(); column++) {
            if (!cellFits(dc, layout, cells[first + column], columnWidth)) {
                return false;
            }
        }
        return true;
    }

    // Same budget arithmetic as drawCell: the label is fitted to its capped share, the value gets
    // what is left and must keep room for its own text or three digits, whichever is smaller (a
    // long value such as a calendar title may still truncate, but never to one character). Public
    // for DayArcLayoutTest.
    (:pro)
    static function cellFits(dc as Graphics.Dc, layout as DayArcLayout, cell as Dictionary, columnWidth as Number) as Boolean {
        var textLeft = textOffset(layout, cell);
        var label = cell.get(:label) as String or Null;
        var labelWidth = 0;
        if (label != null) {
            var labelCap = layout.gridLabelMaxWidth(columnWidth - textLeft);
            var natural = dc.getTextWidthInPixels(label, DayArcLayout.CELL_FONT);
            labelWidth = natural < labelCap ? natural : labelCap;
        }
        var valueBudget = columnWidth - textLeft - labelWidth - layout.gridValueGap();
        var natural = dc.getTextWidthInPixels(cell.get(:value) as String, DayArcLayout.CELL_FONT);
        var floor = dc.getTextWidthInPixels(MIN_VALUE_SAMPLE, DayArcLayout.CELL_FONT);
        return valueBudget >= (natural < floor ? natural : floor);
    }

    (:pro)
    private static function textOffset(layout as DayArcLayout, cell as Dictionary) as Number {
        var hasIcon = cell.hasKey(:icon) && cell.get(:icon) != null;
        return hasIcon ? DayArcLayout.GRID_ICON_SIZE + layout.gridIconGap() : 0;
    }

    // Label and value each get a real, measured share of the column: the label is capped at 55% of
    // what remains after the icon (truncated to fit, e.g. a calendar event title), and the value gets
    // what's left — not both independently truncated against the whole column, which could collide
    // (watch-design-reviewer, 2026-09-28). Midday/evening cells may carry a fixed-hue icon
    // (ADR-013); 9 of those 17 fields drop the text label since the icon alone already reads.
    (:pro)
    private static function drawCell(dc as Graphics.Dc, layout as DayArcLayout, cell as Dictionary, x as Number, y as Number, columnWidth as Number, rowHeight as Number) as Void {
        var gap = layout.gridValueGap();
        var textLeft = x;
        var iconId = cell.hasKey(:icon) ? cell.get(:icon) as Number or Null : null;
        if (iconId != null) {
            var icon = WatchUi.loadResource(DayArcIcons.gridFor(iconId)) as WatchUi.BitmapResource;
            dc.drawBitmap(x, y + (rowHeight - icon.getHeight()) / 2, icon);
            textLeft = x + icon.getWidth() + layout.gridIconGap();
        }
        var label = cell.get(:label) as String or Null;
        var labelWidth = 0;
        if (label != null) {
            var labelMaxWidth = layout.gridLabelMaxWidth(columnWidth - (textLeft - x));
            var fitted = DayArcText.truncated(dc, label, DayArcLayout.CELL_FONT, labelMaxWidth);
            labelWidth = dc.getTextWidthInPixels(fitted, DayArcLayout.CELL_FONT);
            dc.setColor(DayArcPalette.MUTED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(textLeft, y, DayArcLayout.CELL_FONT, fitted, Graphics.TEXT_JUSTIFY_LEFT);
        }
        dc.setColor(DayArcPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        var valueMaxWidth = x + columnWidth - textLeft - labelWidth - gap;
        var value = DayArcText.truncated(dc, cell.get(:value) as String, DayArcLayout.CELL_FONT, valueMaxWidth);
        dc.drawText(x + columnWidth - gap, y, DayArcLayout.CELL_FONT, value, Graphics.TEXT_JUSTIFY_RIGHT);
    }
}
