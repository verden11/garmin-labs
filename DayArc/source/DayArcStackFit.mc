import Toybox.Graphics;
import Toybox.Lang;

// The width checks of one DayArcStack attempt: does every planned text row fit the chord at its own
// y and height (arc-aware in an active window, DayArcStack.rowWidth)? Split out of DayArcStack (file
// size); reads only the plan's public fields.
class DayArcStackFit {
    static function topRowsFit(plan as DayArcStack, dc as Graphics.Dc) as Boolean {
        return rowFits(plan, dc, DayArcStack.ROW_CLOCK) && rowFits(plan, dc, DayArcStack.ROW_DATE) && rowFits(plan, dc, DayArcStack.ROW_LABEL);
    }

    static function allRowsFit(plan as DayArcStack, dc as Graphics.Dc) as Boolean {
        for (var i = 0; i < DayArcStack.ROW_COUNT; i++) {
            if (!rowFits(plan, dc, i)) {
                return false;
            }
        }
        return true;
    }

    static function rowFits(plan as DayArcStack, dc as Graphics.Dc, row as Number) as Boolean {
        var y = plan.ys[row];
        if (y < 0) {
            return true;
        }
        if (row == DayArcStack.ROW_SUB) {
            return subFits(plan, dc);
        }
        return neededWidth(plan, dc, row) <= plan.rowWidth(y, plan.hs[row]);
    }

    static function subFits(plan as DayArcStack, dc as Graphics.Dc) as Boolean {
        var y = plan.ys[DayArcStack.ROW_SUB];
        var lineHeight = dc.getFontHeight(plan.textFont);
        for (var i = 0; i < plan.plannedSub.size(); i++) {
            if (dc.getTextWidthInPixels(plan.plannedSub[i], plan.textFont) > plan.rowWidth(y + i * lineHeight, lineHeight)) {
                return false;
            }
        }
        return true;
    }

    // Pro: the grid block must still be able to draw the rows this rung reserved, each by its own
    // chord. A rung that trimmed the grid away has nothing to check.
    static function gridFits(plan as DayArcStack, dc as Graphics.Dc) as Boolean {
        return !plan.pro || plan.gridTop() < 0 || DayArcGrid.rowsFit(dc, plan.layout, plan.cells, plan.gridTop(), plan.gridRows);
    }

    private static function neededWidth(plan as DayArcStack, dc as Graphics.Dc, row as Number) as Number {
        if (row == DayArcStack.ROW_CLOCK) {
            return dc.getTextWidthInPixels(DayArcConfig.WORST_CLOCK, plan.clockFont);
        }
        if (row == DayArcStack.ROW_DATE) {
            return dc.getTextWidthInPixels(plan.strings.get(:date) as String, plan.textFont);
        }
        if (row == DayArcStack.ROW_LABEL) {
            return dc.getTextWidthInPixels(plan.strings.get(:label) as String, plan.textFont);
        }
        if (row == DayArcStack.ROW_HERO) {
            var icon = plan.iconWidth > 0 ? plan.iconWidth + plan.layout.heroIconGap() : 0;
            return icon + dc.getTextWidthInPixels(plan.strings.get(:value) as String, plan.heroFont);
        }
        return 0;
    }
}
