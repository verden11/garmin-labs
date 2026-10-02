import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Pro's secondary field grid (ADR-009, ADR-013): two columns, one row at a time, each row sized to
// its OWN chord width — rows near the vertical centre are wider than rows near the bezel, so a
// single "narrowest row" column width (the earlier design) starved every row to fit the last one.
// A row is drawn only when both its cells leave the value at least three digits of room (cloud
// review, 2026-09-28: the old capacity floor ignored the icon + label + value shape); rows drop
// from the end, never the middle. Rows are centred pairs of compact cells (see draw).
class DayArcGrid {
    (:pro)
    private static const MIN_VALUE_SAMPLE = "100";

    // Simple never puts :cells in a hero dict (DayArcFields' (:simple) forWindow builds none), so
    // this is unreachable there — a same-signature stub so DayArcDraw stays one shared function
    // (ADR-003). The real body is (:pro) because it reaches DayArcIcons.gridFor.
    // Both draw() variants return how many rows were drawn, so DayArcStackTest can log it per device.
    (:simple)
    static function draw(dc as Graphics.Dc, layout as DayArcLayout, top as Number, cells as Array<Dictionary>) as Number {
        return 0;
    }

    // DayArcStack's question, asked before anything is drawn: would the first `rows` rows fit from
    // `top` (each by its own chord, above the grid bottom)? Simple has no grid, so always true.
    (:simple)
    static function rowsFit(dc as Graphics.Dc, layout as DayArcLayout, cells as Array<Dictionary>, top as Number, rows as Number) as Boolean {
        return true;
    }

    // Each row is a CENTRED PAIR (2026-10-01, owner-approved mock): the left cell ends at the gutter, the
    // right one starts after it, and a lone cell is centred — so the ragged edges are symmetric like every
    // other centred line on the face. Cells are compact: icon, label (if any), value.
    // Each row is a CENTRED PAIR of compact cells, each in a rounded pill, riding the same curve as the
    // gauge (owner-approved mock "E1", 2026-10-01): the left pill ends at the gutter, the right one starts
    // after it, and a lone cell is centred. A cell's centre lifts by DayArcLayout.curveLift; the lift
    // budget is reserved above the rows (gridReserve), so the centre-most pill sits lowest.
    (:pro)
    static function draw(dc as Graphics.Dc, layout as DayArcLayout, top as Number, cells as Array<Dictionary>) as Number {
        var bottom = layout.gridBottom();
        var rowHeight = layout.gridRowHeight(dc);
        var budget = layout.gridLiftBudget();
        var rows = (cells.size() + DayArcLayout.GRID_COLUMNS - 1) / DayArcLayout.GRID_COLUMNS;
        for (var row = 0; row < rows; row++) {
            var y = top + row * rowHeight;
            if (y + budget + rowHeight > bottom) {
                return row;
            }
            var columnWidth = layout.gridRowColumnWidth(y, budget + rowHeight);
            var first = row * DayArcLayout.GRID_COLUMNS;
            if (!rowFits(dc, layout, cells, first, columnWidth)) {
                return row;
            }
            drawRow(dc, layout, cells, first, y + budget, layout.gridCellInnerWidth(columnWidth));
        }
        return rows;
    }

    // `lowY` is where the centre-most pill's top sits; a pill further out is lifted by the curve.
    (:pro)
    private static function drawRow(dc as Graphics.Dc, layout as DayArcLayout, cells as Array<Dictionary>, first as Number, lowY as Number, inner as Number) as Void {
        var left = fitted(dc, layout, cells[first], inner);
        var leftWidth = left.get(:width) as Number;
        var centre = layout.centerX();
        if (first + 1 >= cells.size()) {
            drawCell(dc, layout, cells[first], left, centre - leftWidth / 2, lowY);
            return;
        }
        var right = fitted(dc, layout, cells[first + 1], inner);
        var rightWidth = right.get(:width) as Number;
        var offset = layout.gridColumnGap() / 2 + layout.pillPadH();
        var leftX = centre - offset - leftWidth;
        var rightX = centre + offset;
        drawCell(dc, layout, cells[first], left, leftX, lowY - layout.gridLift(centre - leftX - leftWidth / 2));
        drawCell(dc, layout, cells[first + 1], right, rightX, lowY - layout.gridLift(rightX + rightWidth / 2 - centre));
    }

    (:pro)
    static function rowsFit(dc as Graphics.Dc, layout as DayArcLayout, cells as Array<Dictionary>, top as Number, rows as Number) as Boolean {
        var rowHeight = layout.gridRowHeight(dc);
        var budget = layout.gridLiftBudget();
        for (var row = 0; row < rows; row++) {
            var y = top + row * rowHeight;
            if (y + budget + rowHeight > layout.gridBottom()) {
                return false;
            }
            if (!rowFits(dc, layout, cells, row * DayArcLayout.GRID_COLUMNS, layout.gridRowColumnWidth(y, budget + rowHeight))) {
                return false;
            }
        }
        return true;
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
        var cellWidth = layout.gridCellInnerWidth(columnWidth);
        var textLeft = textOffset(layout, cell);
        var value = cell.get(:value) as String;
        var label = cell.get(:label) as String or Null;
        var labelWidth = 0;
        if (label != null) {
            var natural = dc.getTextWidthInPixels(label, DayArcLayout.CELL_FONT);
            var labelCap = labelMaxWidth(dc, layout, value, cellWidth - textLeft);
            labelWidth = natural < labelCap ? natural : labelCap;
        }
        var valueBudget = cellWidth - textLeft - labelWidth - layout.gridValueGap();
        var natural = dc.getTextWidthInPixels(value, DayArcLayout.CELL_FONT);
        var floor = dc.getTextWidthInPixels(MIN_VALUE_SAMPLE, DayArcLayout.CELL_FONT);
        return valueBudget >= (natural < floor ? natural : floor);
    }

    // The label's share of what is left after the icon: whatever the value does not need, so a short
    // value ("50%") is shown WHOLE and the label gives way — "Batt 8..." on an FR965 (2026-10-02 wrist
    // photo) was the value cut 3 px short — but never below half the DESIGN.md share, so a long value
    // (a calendar title) cannot erase its label. Same call in cellFits and fitted.
    (:pro)
    private static function labelMaxWidth(dc as Graphics.Dc, layout as DayArcLayout, value as String, available as Number) as Number {
        var floor = layout.gridLabelMaxWidth(available) / 2;
        var rest = available - dc.getTextWidthInPixels(value, DayArcLayout.CELL_FONT) - layout.gridValueGap();
        return rest > floor ? rest : floor;
    }

    (:pro)
    private static function textOffset(layout as DayArcLayout, cell as Dictionary) as Number {
        var hasIcon = cell.hasKey(:icon) && cell.get(:icon) != null;
        return hasIcon ? DayArcLayout.GRID_ICON_SIZE + layout.gridIconGap() : 0;
    }

    // A cell's content at the widths it was given: the label truncated to its budget, then the value to
    // what is left, plus the compact total width. Same arithmetic as cellFits.
    (:pro)
    private static function fitted(dc as Graphics.Dc, layout as DayArcLayout, cell as Dictionary, cellWidth as Number) as Dictionary {
        var offset = textOffset(layout, cell);
        var rawValue = cell.get(:value) as String;
        var label = cell.get(:label) as String or Null;
        var labelText = null as String or Null;
        var labelWidth = 0;
        if (label != null) {
            labelText = DayArcText.truncated(dc, label, DayArcLayout.CELL_FONT, labelMaxWidth(dc, layout, rawValue, cellWidth - offset));
            labelWidth = dc.getTextWidthInPixels(labelText, DayArcLayout.CELL_FONT) + layout.gridValueGap();
        }
        var value = DayArcText.truncated(dc, rawValue, DayArcLayout.CELL_FONT, cellWidth - offset - labelWidth);
        return {:label => labelText, :value => value,
                :width => offset + labelWidth + dc.getTextWidthInPixels(value, DayArcLayout.CELL_FONT)} as Dictionary;
    }

    // Icon-only fields (no label) may sit in the upper corners beside the date (DayArcCorners).
    (:pro)
    static function isIconOnly(cell as Dictionary) as Boolean {
        return cell.get(:label) == null && cell.hasKey(:icon) && cell.get(:icon) != null;
    }

    // An icon-only cell's width: icon, gap, value. Public for DayArcCorners.
    (:pro)
    static function naturalWidth(dc as Graphics.Dc, layout as DayArcLayout, cell as Dictionary) as Number {
        return textOffset(layout, cell) + dc.getTextWidthInPixels(cell.get(:value) as String, DayArcLayout.CELL_FONT);
    }

    // A cell drawn at its natural width, its pill's left edge at x, the pill vertically centred in the
    // row. Public for DayArcCorners.
    (:pro)
    static function drawNatural(dc as Graphics.Dc, layout as DayArcLayout, cell as Dictionary, x as Number, y as Number, rowHeight as Number) as Void {
        var content = {:label => null, :value => cell.get(:value), :width => naturalWidth(dc, layout, cell)} as Dictionary;
        drawCell(dc, layout, cell, content, x + layout.pillPadH(), y + (rowHeight - layout.pillHeight(dc)) / 2);
    }

    // The pill outline in the track grey (the one documented sub-3:1 hairline, DESIGN.md), then the icon
    // and text centred in it. `x` is the CONTENT's left edge; `top` the pill's top.
    (:pro)
    private static function drawCell(dc as Graphics.Dc, layout as DayArcLayout, cell as Dictionary, content as Dictionary, x as Number, top as Number) as Void {
        var pad = layout.pillPadH();
        var height = layout.pillHeight(dc);
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(layout.pillPen());
        dc.drawRoundedRectangle(x - pad, top, (content.get(:width) as Number) + 2 * pad, height, height / 2);
        dc.setPenWidth(1);
        var textLeft = x;
        var iconId = cell.hasKey(:icon) ? cell.get(:icon) as Number or Null : null;
        if (iconId != null) {
            var icon = WatchUi.loadResource(DayArcIcons.gridFor(iconId)) as WatchUi.BitmapResource;
            dc.drawBitmap(x, top + (height - icon.getHeight()) / 2, icon);
            textLeft = x + icon.getWidth() + layout.gridIconGap();
        }
        var textY = top + (height - dc.getFontHeight(DayArcLayout.CELL_FONT)) / 2;
        var label = content.get(:label) as String or Null;
        if (label != null) {
            dc.setColor(DayArcPalette.MUTED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(textLeft, textY, DayArcLayout.CELL_FONT, label, Graphics.TEXT_JUSTIFY_LEFT);
            textLeft += dc.getTextWidthInPixels(label, DayArcLayout.CELL_FONT) + layout.gridValueGap();
        }
        dc.setColor(DayArcPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(textLeft, textY, DayArcLayout.CELL_FONT, content.get(:value) as String, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
