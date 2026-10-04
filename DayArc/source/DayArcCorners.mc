import Toybox.Graphics;
import Toybox.Lang;

// Pro's upper-corner fields (owner-approved mock, 2026-10-01): the first icon-only grid fields sit
// either side of the date, in the room the clock rows leave free beside it, so the grid below needs
// fewer rows. A field is placed only if it fits the arc-aware chord at the date row beside the date's
// own width; one that does not fit simply stays in the grid. Both halves draw the same arithmetic.
// Simple never has cells (DayArcFields' (:simple) forWindow builds none): same-signature stub, so
// DayArcDraw stays one shared function (ADR-003).
class DayArcCorners {
    (:simple)
    static function draw(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, date as String or Null, cells as Array<Dictionary>) as Array<Dictionary> {
        return cells;
    }

    (:simple)
    static function rest(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, date as String or Null, cells as Array<Dictionary>) as Array<Dictionary> {
        return cells;
    }

    // Draws the corner fields and returns the cells that still belong in the grid, in order.
    (:pro)
    static function draw(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, date as String or Null, cells as Array<Dictionary>) as Array<Dictionary> {
        return place(dc, layout, plan, date, cells, true);
    }

    // The same answer without drawing: DayArcStackFit checks the grid rows against the cells the grid will really get, not
    // against every cell (the corner fields leave it), or a row the plan reserved fails at draw time and leaves a gap.
    (:pro)
    static function rest(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, date as String or Null, cells as Array<Dictionary>) as Array<Dictionary> {
        return place(dc, layout, plan, date, cells, false);
    }

    // The room is computed from the date as given: the live string when the planner asks (DayArcStackFit, :liveDate) and when
    // drawing. The date only changes in the night window, where there are no corner fields, so the answer is stable inside a window.
    (:pro)
    private static function place(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, date as String or Null, cells as Array<Dictionary>, paint as Boolean) as Array<Dictionary> {
        var y = plan.ys[DayArcStack.ROW_DATE];
        if (y < 0 || date == null || layout.subscreen() != null) {
            return cells;   // no corner pills beside the Instinct's window: the date row is a narrow band (ADR-015)
        }
        var height = plan.hs[DayArcStack.ROW_DATE];
        if (layout.pillHeight(dc) > height) {
            return cells; // a pill taller than the date row would touch the clock or the label
        }
        var half = plan.rowWidth(y, height) / 2;
        var room = half - dc.getTextWidthInPixels(date, plan.textFont) / 2 - layout.pillPadH();
        var pad2 = 2 * layout.pillPadH();
        var rest = [] as Array<Dictionary>;
        var placed = 0;
        for (var i = 0; i < cells.size(); i++) {
            var cell = cells[i];
            var width = placed < DayArcConfig.CORNER_SLOTS && DayArcGrid.isIconOnly(cell) ? DayArcGrid.naturalWidth(dc, layout, cell) + pad2 : -1;
            if (width < 0 || width > room) {
                rest.add(cell);
                continue;
            }
            var x = placed == 0 ? layout.centerX() - half : layout.centerX() + half - width;
            if (paint) {
                DayArcGrid.drawNatural(dc, layout, cell, x, y, height);
            }
            placed++;
        }
        return rest;
    }
}
