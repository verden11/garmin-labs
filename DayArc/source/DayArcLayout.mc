import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

// Geometry, measured once per display, off the shorter screen side (TwoSuns's own proven pattern,
// reused: `contentRadius`/chord-inset math validated across all 69 products in that project's fit
// sweep). A ROUND product (66 of the 69) is chord-fitted against the inscribed circle. A
// rectangular one (Venu Sq 2/Sq 2 Music, Venu X1) has no bezel to clip against, so its rows get the
// full screen width and the screen's own bottom edge; only the window-progress arc stays on the
// inscribed circle. (Corrected 2026-09-28: the earlier "same round-centred content on rectangles"
// convention left Venu Sq 2 a 204px chord and no font tier that fit — DayArcStackTest.)
class DayArcLayout {
    private static const PERMILLE = 1000;
    static const CLOCK_MAX_PERMILLE = 200;
    private static const TOP_MARGIN_PERMILLE = 60;
    private static const BOTTOM_MARGIN_PERMILLE = 60;
    private static const ROW_GAP_PERMILLE = 18;
    private static const SIDE_MARGIN_PERMILLE = 20;
    static const GRID_COLUMNS = 2;

    private static const GAUGE_HEIGHT_PERMILLE = 30;
    // The curve (owner-approved mock "E1", 2026-10-01): the gauge is a shallow smile this deep, grid rows
    // lift onto the same curve, and every grid field sits in a rounded pill.
    private static const GAUGE_SAG_PERMILLE = 44;
    private static const PILL_PAD_H_PERMILLE = 16;
    private static const PILL_PEN_PERMILLE = 4;
    private static const GAUGE_SIDE_PADDING_PERMILLE = 160;

    // Icon bitmaps (ADR-013) are fixed-pixel resources, not runtime-scaled (DESIGN.md
    // "Implementation note" — plain dc.drawBitmap, no :tintColor/drawBitmap2, sidesteps the
    // FR165/165m tint bug by not tinting at all). GRID_ICON_SIZE must match the pixel size baked
    // into resources-pro/drawables/icons/grid_*.svg at generation time.
    static const GRID_ICON_SIZE = 22;
    private static const HERO_ICON_GAP_PERMILLE = 20;
    private static const GRID_ICON_GAP_PERMILLE = 10;

    // Grid cell layout (DESIGN.md "Layout": "each cell reserves a measured share for its label,
    // capped at 55% of the column"; watch-design-reviewer, 2026-09-28: this ratio and the value/
    // label gap were bare literals in DayArcDraw, against this file's own "no magic numbers" rule).
    private static const GRID_LABEL_MAX_PERMILLE = 550;
    private static const GRID_COLUMN_GAP_PERMILLE = 40; // gutter between the two columns; before it, one column's value butted into the next column's icon
    private static const GRID_VALUE_GAP_PERMILLE = 9; // ~4px on fr965's 454px display

    static const CLOCK_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD, Graphics.FONT_LARGE] as Array<Graphics.FontDefinition>;
    static const HERO_FONTS = [Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static const LABEL_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const CELL_FONT = Graphics.FONT_XTINY;

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;
    private var _round as Boolean;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _d = _width < _height ? _width : _height;
        _radius = _d / 2;
        _round = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND;
    }

    function centerX() as Number {
        return _width / 2;
    }

    function centerY() as Number {
        return _height / 2;
    }

    // Radius of the inscribed circle: what a round product's rows are chord-fitted against, and the
    // circle the arc is drawn just inside of on every product.
    function radius() as Number {
        return _radius;
    }

    // How far the inscribed circle's own top edge sits below the screen's actual top (0 for a
    // round/square display; positive slack for a taller-than-wide rectangle like Venu Sq 2/X1, where
    // _d is the WIDTH but centerY is half the taller HEIGHT). topMargin() measures from it, not from
    // y=0, so the stack starts below the arc that lives on that circle — measuring from y=0 once let
    // the clock row start above the circle entirely on Venu Sq 2 (watch-design-reviewer, 2026-09-28).
    private function circleTop() as Number {
        return centerY() - _radius;
    }

    function heroIconGap() as Number {
        return permille(HERO_ICON_GAP_PERMILLE);
    }

    function gridIconGap() as Number {
        return permille(GRID_ICON_GAP_PERMILLE);
    }

    // One grid row: a pill exactly as tall as the cell font's box (its ascent and descent are the pill's
    // own breathing room) or a grid icon, whichever is taller (the fixed-pixel icon can be taller than
    // FONT_XTINY on a small screen where permille shrinks everything else but not the icon); a row adds
    // half a row gap to the next pill row.
    function pillHeight(dc as Graphics.Dc) as Number {
        var fontHeight = dc.getFontHeight(CELL_FONT);
        return fontHeight > GRID_ICON_SIZE ? fontHeight : GRID_ICON_SIZE;
    }

    function gridRowHeight(dc as Graphics.Dc) as Number {
        return pillHeight(dc) + rowGap() / 2;
    }

    function pillPadH() as Number {
        return permille(PILL_PAD_H_PERMILLE);
    }

    function pillPen() as Number {
        return DayArcText.max(1, permille(PILL_PEN_PERMILLE));
    }

    // The real chord width at this row, minus a small side margin — for every centred text row,
    // not just the grid (watch-design-reviewer, 2026-09-28: the active/idle frames used to fall
    // back to a flat width-minus-margin for everything but the grid, contradicting DESIGN.md's own
    // "width-fit against the round chord" claim and understating the true clip risk near the top of
    // a round display).
    function rowMaxWidth(y as Number, boxHeight as Number) as Number {
        if (!_round) {
            return _width - 2 * permille(SIDE_MARGIN_PERMILLE);
        }
        return rowMaxWidthIn(_radius, y, boxHeight);
    }

    // The same chord, against a smaller circle: DayArcArc uses this for rows that sit up inside the
    // window-progress arc's own band, so "fits the chord" also means "clears the arc".
    function rowMaxWidthIn(radius as Number, y as Number, boxHeight as Number) as Number {
        return 2 * chordHalfWidth(radius, farthestDy(y, boxHeight)) - 2 * permille(SIDE_MARGIN_PERMILLE);
    }

    private function farthestDy(y as Number, boxHeight as Number) as Number {
        var dyTop = y - centerY();
        var dyBottom = y + boxHeight - centerY();
        return dyTop.abs() > dyBottom.abs() ? dyTop : dyBottom;
    }

    static function chordHalfWidth(radius as Number, dy as Number) as Number {
        var inside = radius * radius - dy * dy;
        if (inside <= 0) {
            return 0;
        }
        return Math.sqrt(inside).toNumber();
    }

    function permille(value as Number) as Number {
        return _d * value / PERMILLE;
    }

    function driftStep() as Number {
        return permille(DayArcConfig.BURN_IN_STEP_PERMILLE);
    }

    function topMargin() as Number {
        return circleTop() + permille(TOP_MARGIN_PERMILLE);
    }

    function rowGap() as Number {
        return permille(ROW_GAP_PERMILLE);
    }

    function gridBottom() as Number {
        return _height - permille(BOTTOM_MARGIN_PERMILLE);
    }

    // One grid row's column width, from THIS row's own chord (not the narrowest row's): rows near
    // the vertical centre are wider than rows near the bezel. DayArcGrid decides how many rows fit.
    function gridRowColumnWidth(rowTop as Number, rowHeight as Number) as Number {
        return rowMaxWidth(rowTop, rowHeight) / GRID_COLUMNS;
    }

    // DESIGN.md "Layout": a cell's label is capped at this share of its remaining column width
    // (after any icon reservation), so the value always keeps a legible minimum.
    function gridLabelMaxWidth(remainingColumnWidth as Number) as Number {
        return remainingColumnWidth * GRID_LABEL_MAX_PERMILLE / PERMILLE;
    }

    // The gutter between the two columns, split evenly: each cell is this much narrower than its half of the row.
    function gridColumnGap() as Number {
        return permille(GRID_COLUMN_GAP_PERMILLE);
    }

    function gridValueGap() as Number {
        return permille(GRID_VALUE_GAP_PERMILLE);
    }

    function gaugeHeight() as Number {
        return permille(GAUGE_HEIGHT_PERMILLE);
    }

    // The smile's depth: the gauge's row is this much taller than a straight gauge, and the planner
    // budgets that fixed height (not the drawn width's), so the dry run and the draw agree.
    function gaugeSag() as Number {
        return DayArcText.max(1, permille(GAUGE_SAG_PERMILLE));
    }

    function gaugeBoxHeight() as Number {
        return gaugeHeight() + gaugeSag();
    }

    // The deliberate visual side padding (a bit narrower than the plain chord, never wider).
    function gaugeMaxWidth() as Number {
        return _width - permille(GAUGE_SIDE_PADDING_PERMILLE);
    }

    // Radius of the circle the smile lies on: the arc through the gauge's two ends (gaugeMaxWidth apart)
    // that dips gaugeSag() in the middle. Layout-only, so the grid rows can lift onto the same curve.
    function gaugeRadius() as Number {
        var half = gaugeMaxWidth() / 2;
        var sag = gaugeSag();
        return (half * half + sag * sag) / (2 * sag);
    }

    // How far a point `dx` from the centre line sits ABOVE the curve's lowest point.
    function curveLift(dx as Number) as Number {
        var radius = gaugeRadius();
        var across = dx.abs();
        if (across >= radius) {
            return radius;
        }
        return radius - Math.sqrt(radius * radius - across * across).toNumber();
    }

    // The lift reserved above the grid rows: that of a pill centred a third of a column out (a typical
    // compact pill is far narrower than its column). Reserved once, so the planner's height does not
    // depend on the live cell widths; gridLift clamps anything wider to it, so a pill can never rise
    // into the row above.
    function gridLiftBudget() as Number {
        return curveLift(rowMaxWidth(centerY(), 1) / GRID_COLUMNS / 3);
    }

    function gridLift(dx as Number) as Number {
        var budget = gridLiftBudget();
        var lift = curveLift(dx);
        return lift > budget ? budget : lift;
    }

    // The width a cell's content (icon, label, value) may use inside its pill, from its column's width.
    function gridCellInnerWidth(columnWidth as Number) as Number {
        return columnWidth - gridColumnGap() / 2 - 2 * pillPadH();
    }

    // Pro: `rows` grid rows plus the lift budget — the grid block the hero stack must leave itself
    // (DayArcStack). No divider since E1: the pills separate the grid from the hero themselves.
    function gridReserve(dc as Graphics.Dc, rows as Number) as Number {
        return rows * gridRowHeight(dc) + gridLiftBudget();
    }
}
