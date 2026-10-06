import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Geometry, measured once per display. Everything is a share of D, the shorter screen side, so one
// layout serves every round product. Rows are bands: text is centred in its band, and every text is
// checked against the round chord (TwoSunsDraw). Fonts are chosen first, then the rows are stacked
// from their real heights (Days To Go ADR-012), so a small screen gives rows less room, never overlap.
class TwoSunsLayout {
    // Row height caps in thousandths of D. A row takes the largest font up to its cap (or the smallest
    // font, on a screen too small for the cap).
    static const DATE_MAX_PERMILLE = 60;
    // Raised from 230 on the owner's own FR965 feedback (2026-09-27: "plenty of space" at the old cap).
    // Proportional to D like every cap here, so it scales the same way across all 69 products; a screen
    // too small for the new cap already falls back through TIME_FONTS via fontUpTo, same as before.
    // Not yet re-confirmed by a fit sweep or a new device photo — do before the submit gate closes.
    static const TIME_MAX_PERMILLE = 260;
    static const VALUE_MAX_PERMILLE = 80;
    static const LINE_MAX_PERMILLE = 75;
    // The Body Battery band is at least this tall when it carries the curve.
    static const CURVE_BAND_PERMILLE = 110;

    // The stack spans this share of the content radius above and below the centre.
    private static const SPAN_PERMILLE = 800;
    private static const GAP_PERMILLE = 14;
    // The Instinct: the window sits in a bezel ring wider than itself (about 10 px at 176), its dial's thickness is a
    // quarter of its radius, and the stack keeps a margin from the top and bottom edges.
    private static const WINDOW_CLEARANCE_PERMILLE = 60;
    private static const WINDOW_RING_DIVISOR = 4;
    private static const EDGE_MARGIN_PERMILLE = 40;
    // The bezel hides the corners of a semi-octagon display: what shows is the square cut by a circle about 98 px in radius
    // (measured off the alpha mask of the SDK's device images, 96 to 100 px on all seven Instinct products). Rows are cut
    // against the ink of capitals, a quarter of the short inset in from each end of the font box.
    static const VISIBLE_RADIUS_PX = 97;
    private static const INK_TRIM_DIVISOR = 40;

    private static const RING_WIDTH_PERMILLE = 25;
    private static const RING_GAP_PERMILLE = 10;
    private static const TEXT_MARGIN_PERMILLE = 20;

    // Fonts by role, largest first; a row takes the largest whose height fits its cap.
    static const DATE_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const TIME_FONTS = [Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    // A rectangle's time may grow past its cap into what the inner box leaves (TwoSunsFrame.growTime, ADR-028).
    static const RECT_TIME_FONTS = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static const VALUE_FONTS = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    // Free has no date, weather, battery or curve row to share the stack with, so the Body Battery number, the face's
    // second question after the time, may be a size up (awake only; the always-on frame keeps VALUE_FONTS).
    static const VALUE_FREE_MAX_PERMILLE = 130;
    static const VALUE_FREE_FONTS = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const LINE_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    // Always-on time is derived from TIME_FONTS at draw time (TwoSunsFrame, TwoSunsDraw.fontsBelow), two
    // steps below whatever font awake actually picked — not a second, independent list. The old
    // independent list started at MEDIUM regardless of what awake chose, so it matched awake exactly
    // whenever awake had already fallen back to MEDIUM, contradicting the "two sizes smaller" it
    // documented (caught by watch-design-reviewer, 2026-09-27).

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;
    private var _subscreen as Graphics.BoundingBox?;
    // The Instinct window's box as plain numbers (BoundingBox fields are nullable); unused elsewhere.
    private var _windowX as Number = 0;
    private var _windowY as Number = 0;
    private var _windowW as Number = 0;
    private var _windowH as Number = 0;
    // Rectangular screens only (Venu Sq 2, Sq 2 Music, Venu X1): the sky ring is a rounded-rectangle track and the rows fit
    // the rounded box inside it (ADR-028, the rectangle track). Null on round and Instinct screens, whose paths never read it.
    private var _track as TwoSunsTrack?;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _d = _width < _height ? _width : _height;
        _radius = _d / 2;
        // Asked of semi-octagon screens only (the Instinct's round window, ADR-024), so no round or rectangular
        // product's geometry can depend on it.
        _subscreen = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON && (WatchUi has :getSubscreen)
            ? WatchUi.getSubscreen() : null;
        var window = _subscreen;
        if (window != null) {
            _windowX = window.x as Number;
            _windowY = window.y as Number;
            _windowW = window.width as Number;
            _windowH = window.height as Number;
        }
        if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE) {
            _track = new TwoSunsTrack(_width, _height, _radius - ringRadius(), _d * TwoSunsTrack.CORNER_PERMILLE / TwoSunsConfig.PERMILLE);
        }
    }

    // The rectangle's track (ADR-028); null on round and Instinct screens.
    function track() as TwoSunsTrack? {
        return _track;
    }

    // The Instinct's physical window in display coordinates; null on every other product.
    function subscreen() as Graphics.BoundingBox? {
        return _subscreen;
    }

    // First y at or below `y` that clears the window and the bezel ring around it.
    function belowWindow(y as Number) as Number {
        if (_subscreen == null) {
            return y;
        }
        var clear = _windowY + _windowH + _d * WINDOW_CLEARANCE_PERMILLE / TwoSunsConfig.PERMILLE;
        return y > clear ? y : clear;
    }

    // Rows that start above the window's lower edge (plus its ring) share their line with it.
    private function besideWindow(y as Number) as Boolean {
        return _subscreen != null && y < belowWindow(0);
    }

    // x that centres a row in its usable band: the screen's centre, except beside the window.
    function rowCenterX(y as Number, height as Number) as Number {
        return besideWindow(y) ? (leftInset(y, height) + rightInset(y, height)) / 2 : centerX();
    }

    // The sky ring's centre: the screen's, or the window's (the 24 hour dial in miniature, ADR-024).
    function ringCenterX() as Number {
        return _subscreen == null ? centerX() : _windowX + _windowW / 2;
    }

    function ringCenterY() as Number {
        return _subscreen == null ? centerY() : _windowY + _windowH / 2;
    }

    function height() as Number {
        return _height;
    }

    function centerX() as Number {
        return _width / 2;
    }

    function centerY() as Number {
        return _height / 2;
    }

    // The largest height a row of this cap may take on this display.
    function capFor(permille as Number) as Number {
        return _d * permille / TwoSunsConfig.PERMILLE;
    }

    // The height the stack of rows may use: the content circle, less the margin at the top and bottom.
    function spanHeight() as Number {
        if (_subscreen != null) {
            return _height - 2 * edgeMargin();   // top margin to bottom margin (the stack starts at the top, beside the window)
        }
        if (_track != null) {
            return _height - 2 * (_radius - contentRadius());   // the whole inner box: a rectangle has no chord to keep clear of
        }
        return 2 * contentRadius() * SPAN_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    private function edgeMargin() as Number {
        return _d * EDGE_MARGIN_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    function gap() as Number {
        return _d * GAP_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    // Stacks the rows top to bottom and centres the block on the display: date, time, weather, Body Battery
    // band, sun line. Each argument is that row's height, 0 when the row is absent.
    function rows(dateH as Number, timeH as Number, weatherH as Number, bandH as Number, lineH as Number) as TwoSunsRows {
        var rows = new TwoSunsRows();
        if (_subscreen != null) {
            return rowsBesideWindow(rows, dateH, timeH, weatherH, bandH, lineH);
        }
        var top = centerY() - stackHeight(dateH, timeH, weatherH, bandH, lineH) / 2;
        if (dateH > 0) {
            rows.dateTop = top;
            top += dateH + gap();
        }
        rows.timeTop = top;
        top += timeH + gap();
        if (weatherH > 0) {
            rows.weatherTop = top;
            top += weatherH + gap();
        }
        rows.bandTop = top;
        top += bandH;
        if (lineH > 0) {
            rows.lineTop = top + gap();
        }
        return rows;
    }

    // The Instinct (ADR-024): the time and the date share the band left of the window (time first), the weather row, the
    // Body Battery band and the sun line start below it. Stacked from the top margin, not centred.
    private function rowsBesideWindow(rows as TwoSunsRows, dateH as Number, timeH as Number, weatherH as Number, bandH as Number, lineH as Number) as TwoSunsRows {
        var top = edgeMargin();
        rows.timeTop = top;
        top += timeH + gap();
        if (dateH > 0) {
            rows.dateTop = top;
            top += dateH + gap();
        }
        top = belowWindow(top);
        if (weatherH > 0) {
            rows.weatherTop = top;
            top += weatherH + gap();
        }
        rows.bandTop = top;
        top += bandH;
        if (lineH > 0) {
            rows.lineTop = top + gap();
        }
        return rows;
    }

    // The total height of the rows that are present, with a gap between each.
    function stackHeight(dateH as Number, timeH as Number, weatherH as Number, bandH as Number, lineH as Number) as Number {
        if (_subscreen != null) {
            var rows = rowsBesideWindow(new TwoSunsRows(), dateH, timeH, weatherH, bandH, lineH);
            return (lineH > 0 ? rows.lineTop + lineH : rows.bandTop + bandH) - edgeMargin();
        }
        var total = timeH + bandH + gap();
        if (weatherH > 0) {
            total += weatherH + gap();
        }
        if (dateH > 0) {
            total += dateH + gap();
        }
        if (lineH > 0) {
            total += lineH + gap();
        }
        return total;
    }

    function bandGap() as Number {
        return _d * TwoSunsConfig.BAND_GAP_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    // Radius of the current-point dot on the curve, and the pen for the curve line and the glyph outline.
    function dotRadius() as Number {
        var radius = _d * TwoSunsConfig.DOT_PERMILLE / TwoSunsConfig.PERMILLE;
        return radius < TwoSunsConfig.MIN_DOT_RADIUS ? TwoSunsConfig.MIN_DOT_RADIUS : radius;
    }

    function pen() as Number {
        var pen = _d * TwoSunsConfig.PEN_PERMILLE / TwoSunsConfig.PERMILLE;
        return pen < 1 ? 1 : pen;
    }

    // How far the always-on block moves between grid spots.
    function driftStep() as Number {
        return _d * TwoSunsConfig.BURN_IN_STEP_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    function ringWidth() as Number {
        if (_subscreen != null) {
            return ringRadius() / WINDOW_RING_DIVISOR;
        }
        return _d * RING_WIDTH_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    function ringRadius() as Number {
        if (_subscreen != null) {
            // the window's outer radius less its fill, so the thick arc and the marker stay inside it
            var outer = (_windowW < _windowH ? _windowW : _windowH) / 2 - 1;
            return outer - outer / WINDOW_RING_DIVISOR / 2;
        }
        return _radius - ringWidth() / 2 - _d * RING_GAP_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    // Everything inside the ring fits against this circle, so text never touches the ring.
    function contentRadius() as Number {
        return ringRadius() - ringWidth() / 2 - _d * TEXT_MARGIN_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    // On the Instinct a row is a box, not a chord: a side margin each side, clipped to the circle the bezel leaves visible
    // (against the row's ink), and beside the window the right edge is the window's left edge less its ring.
    function leftInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (_subscreen != null) {
            var visible = centerX() - chordHalfWidth(VISIBLE_RADIUS_PX, farthestInkDy(y, height));
            return visible > edgeMargin() ? visible : edgeMargin();
        }
        return centerX() - halfWidthWithin(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (_subscreen != null) {
            var visible = centerX() + chordHalfWidth(VISIBLE_RADIUS_PX, farthestInkDy(y, height));
            var edge = besideWindow(y) ? _windowX - _d * WINDOW_CLEARANCE_PERMILLE / TwoSunsConfig.PERMILLE : _width - edgeMargin();
            return visible < edge ? visible : edge;
        }
        return centerX() + halfWidthWithin(radius, farthestDy(y, height));
    }

    // Round: the chord of the circle of `radius`. Rectangle: the rounded box inset by what `radius` is short of half of D.
    private function halfWidthWithin(radius as Number, dy as Number) as Number {
        var track = _track;
        return track == null ? chordHalfWidth(radius, dy) : track.halfWidthAt(_radius - radius, dy);
    }

    // The whole display, for the screen-fit test.
    function leftInset(y as Number, height as Number) as Number {
        return leftInsetWithin(_radius, y, height);
    }

    function rightInset(y as Number, height as Number) as Number {
        return rightInsetWithin(_radius, y, height);
    }

    private function farthestInkDy(y as Number, height as Number) as Number {
        var trim = _d / INK_TRIM_DIVISOR;
        return farthestDy(y + trim, height - 2 * trim);
    }

    private function farthestDy(y as Number, height as Number) as Number {
        var dyTop = y - centerY();
        var dyBottom = y + height - centerY();
        return dyTop.abs() > dyBottom.abs() ? dyTop : dyBottom;
    }

    static function chordHalfWidth(radius as Number, dy as Number) as Number {
        var inside = radius * radius - dy * dy;
        if (inside <= 0) {
            return 0;
        }
        return Math.sqrt(inside).toNumber();
    }
}
