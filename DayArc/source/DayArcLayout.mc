import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Geometry, measured once per display, off the shorter screen side (TwoSuns's own proven pattern,
// reused: `contentRadius`/chord-inset math validated across all 69 products in that project's fit
// sweep). A ROUND product is chord-fitted against the inscribed circle. A rectangular one (Venu Sq 2/
// Sq 2 Music, Venu X1) has its own square design since ADR-019: rows fit the box inside a rounded-
// rectangle track (DayArcRect), the gauge is straight, the grid rows sit level.
// (2026-09-28: the inscribed circle on a rectangle left Venu Sq 2 a 204px chord and no tier that fit.)
class DayArcLayout {
    private static const PERMILLE = 1000;
    static const CLOCK_MAX_PERMILLE = 200;
    private static const TOP_MARGIN_PERMILLE = 60;
    private static const BOTTOM_MARGIN_PERMILLE = 60;
    private static const ROW_GAP_PERMILLE = 18;
    private static const SIDE_MARGIN_PERMILLE = 20;
    // The Instinct's window sits in a bezel ring wider than itself; its gauge fill is a quarter of the window radius.
    private static const WINDOW_CLEARANCE_PERMILLE = 60;
    private static const WINDOW_FILL_DIVISOR = 4;
    // The bezel hides the corners of a semi-octagon display: what shows is the square cut by a circle about 98 px in
    // radius (measured off the alpha mask of the SDK's device images, 96 to 100 px on all seven Instinct products).
    static const VISIBLE_RADIUS_PX = 96;
    static const GRID_COLUMNS = 2;

    private static const GAUGE_HEIGHT_PERMILLE = 30;
    // The curve (owner-approved mock "E1", 2026-10-01): the gauge is a shallow smile this deep, grid rows
    // lift onto the same curve, and every grid field sits in a rounded pill.
    private static const GAUGE_SAG_PERMILLE = 44;
    private static const PILL_PAD_H_PERMILLE = 16;
    private static const PILL_PEN_PERMILLE = 4;
    private static const PILL_PAD_H_MIN_PX = 4;   // on 166 px the permille pad was 2 px: "12:00a" touched the outline
    private static const GAUGE_SIDE_PADDING_PERMILLE = 160;

    // Icon bitmaps (ADR-013) are fixed-pixel resources, not runtime-scaled (DESIGN.md
    // "Implementation note" — plain dc.drawBitmap, no :tintColor/drawBitmap2, sidesteps the
    // FR165/165m tint bug by not tinting at all). GRID_ICON_SIZE must match the pixel size baked
    // into resources-pro/drawables/icons/grid_*.svg at generation time.
    static const GRID_ICON_SIZE = 24;
    private static const HERO_ICON_GAP_PERMILLE = 20;
    private static const GRID_ICON_GAP_PERMILLE = 10;

    // Grid cell layout (DESIGN.md "Layout": a label shows whole or not at all, never cut).
    private static const GRID_COLUMN_GAP_PERMILLE = 40; // gutter between the two columns; before it, one column's value butted into the next column's icon
    private static const GRID_VALUE_GAP_PERMILLE = 9; // ~4px on fr965's 454px display
    private static const GRID_VALUE_GAP_MIN_PX = 3;    // on an Instinct's 166 px a permille gap was 1 px: "Rec5h"

    static const CLOCK_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD, Graphics.FONT_LARGE] as Array<Graphics.FontDefinition>;
    static const HERO_FONTS = [Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static const LABEL_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const CELL_FONT = Graphics.FONT_XTINY;

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;
    private var _round as Boolean;
    private var _rect as Boolean;
    private var _subscreen as Graphics.BoundingBox?;
    // The Instinct window's box as plain numbers (BoundingBox fields are nullable); unused elsewhere.
    private var _windowX as Number = 0;
    private var _windowY as Number = 0;
    private var _windowW as Number = 0;
    private var _windowH as Number = 0;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _d = _width < _height ? _width : _height;
        _radius = _d / 2;
        var shape = System.getDeviceSettings().screenShape;
        _round = shape == System.SCREEN_SHAPE_ROUND;
        _rect = shape == System.SCREEN_SHAPE_RECTANGLE;
        // Asked of semi-octagon screens only (the Instinct's round window, ADR-015), so no round or rectangular
        // product's geometry can depend on it.
        _subscreen = shape == System.SCREEN_SHAPE_SEMI_OCTAGON && (WatchUi has :getSubscreen) ? WatchUi.getSubscreen() : null;
        var window = _subscreen;
        if (window != null) {
            _windowX = window.x as Number;
            _windowY = window.y as Number;
            _windowW = window.width as Number;
            _windowH = window.height as Number;
        }
    }

    // The Instinct's physical window in display coordinates; null on every other product.
    function subscreen() as Graphics.BoundingBox? {
        return _subscreen;
    }

    // [center x, center y, outer radius, fill width] of the gauge that fills the window (the arc's Instinct form), one
    // pixel inside the window's edge; null on every other product.
    function windowRing() as [Number, Number, Number, Number]? {
        if (_subscreen == null) {
            return null;
        }
        var radius = (_windowW < _windowH ? _windowW : _windowH) / 2 - 1;
        return [_windowX + _windowW / 2, _windowY + _windowH / 2, radius, radius / WINDOW_FILL_DIVISOR];
    }

    // First y at or below `y` that clears the window and the bezel ring around it.
    function belowWindow(y as Number) as Number {
        if (_subscreen == null) {
            return y;
        }
        var clear = _windowY + _windowH + permille(WINDOW_CLEARANCE_PERMILLE);
        return y > clear ? y : clear;
    }

    // Rows that start above the window's lower edge (plus its ring) share their line with it.
    private function besideWindow(y as Number) as Boolean {
        return _subscreen != null && y < belowWindow(0);
    }

    // The usable span [left, right] of a row on the Instinct: a side margin each side, clipped to the circle the
    // bezel leaves visible, and (beside the window) ending left of it.
    private function instinctSpan(y as Number, boxHeight as Number) as [Number, Number] {
        var dy = farthestDy(y, boxHeight);
        var left = centerX() - chordHalfWidth(VISIBLE_RADIUS_PX, dy);
        var right = centerX() + chordHalfWidth(VISIBLE_RADIUS_PX, dy);
        var side = permille(SIDE_MARGIN_PERMILLE);
        left = left > side ? left : side;
        var edge = besideWindow(y) ? _windowX - permille(WINDOW_CLEARANCE_PERMILLE) : _width - side;
        right = right < edge ? right : edge;
        return [left, right];
    }

    // x that centres a row in its usable band: the screen's centre, except beside the window.
    function rowCenterX(y as Number, boxHeight as Number) as Number {
        if (!besideWindow(y)) {
            return centerX();
        }
        var span = instinctSpan(y, boxHeight);
        return (span[0] + span[1]) / 2;
    }

    // Venu Sq 2 / Sq 2 Music / Venu X1: the square design (DayArcRect, ADR-019).
    function isRectangle() as Boolean {
        return _rect;
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
        return DayArcText.max(PILL_PAD_H_MIN_PX, permille(PILL_PAD_H_PERMILLE));
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
        if (_subscreen != null) {
            var span = instinctSpan(y, boxHeight);
            return span[1] - span[0];
        }
        if (_rect) {
            return DayArcRect.rowWidth(self, y, boxHeight);
        }
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
        if (_rect) {
            return DayArcRect.innerInset(self);
        }
        return circleTop() + permille(TOP_MARGIN_PERMILLE);
    }

    function rowGap() as Number {
        return permille(ROW_GAP_PERMILLE);
    }

    function gridBottom() as Number {
        return _rect ? _height - DayArcRect.innerInset(self) : _height - permille(BOTTOM_MARGIN_PERMILLE);
    }

    // One grid row's column width, from THIS row's own chord (not the narrowest row's): rows near
    // the vertical centre are wider than rows near the bezel. DayArcGrid decides how many rows fit.
    function gridRowColumnWidth(rowTop as Number, rowHeight as Number) as Number {
        return rowMaxWidth(rowTop, rowHeight) / GRID_COLUMNS;
    }

    // The gutter between the two columns, split evenly: each cell is this much narrower than its half of the row.
    function gridColumnGap() as Number {
        return permille(GRID_COLUMN_GAP_PERMILLE);
    }

    function gridValueGap() as Number {
        return DayArcText.max(GRID_VALUE_GAP_MIN_PX, permille(GRID_VALUE_GAP_PERMILLE));
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

    // How far a point `dx` from the centre line sits ABOVE the curve's lowest point (0 on a rectangle: no curve).
    function curveLift(dx as Number) as Number {
        if (_rect) {
            return 0;
        }
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
