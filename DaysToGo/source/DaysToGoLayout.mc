import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Geometry, measured once per display. Everything is a share of D, the shorter
// screen side, so one layout serves every round product. Rows are bands: text
// is centred in its band, and every text is checked against the round chord;
// on a rectangle against the rounded box inside the track (DaysToGoTrack, ADR-019).
class DaysToGoLayout {
    // The stack spans this share of the content radius above and below the centre.
    private static const SPAN_PERMILLE = 800;
    private static const GAP_PERMILLE = 12;
    private static const RECTANGLE_MIN_DRIFT_PX = 24;

    // The Instinct window sits in a bezel ring wider than itself (about 10 px at 176); the gauge's fill is a quarter of its radius.
    private static const WINDOW_CLEARANCE_PERMILLE = 60;
    private static const WINDOW_FILL_DIVISOR = 4;
    private static const SIDE_MARGIN_PERMILLE = 40;
    // The bezel hides the corners of a semi-octagon display: what shows is the square cut by a circle about 98 px in
    // radius (measured off the alpha mask of the SDK's device images: 96 to 100 px on all seven Instinct products).
    static const VISIBLE_RADIUS_PX = 96;
    private static const BOTTOM_MARGIN_PERMILLE = 60;
    private static const RING_WIDTH_PERMILLE = 25;
    private static const RING_GAP_PERMILLE = 10;
    private static const TEXT_MARGIN_PERMILLE = 20;

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;
    private var _subscreen as Graphics.BoundingBox?;
    // The rectangle's track (ADR-019); null on round and Instinct products.
    private var _track as DaysToGoTrack?;
    // The window's box as plain numbers (BoundingBox fields are nullable); all 0 and unused off the Instinct.
    private var _windowX as Number = 0;
    private var _windowY as Number = 0;
    private var _windowW as Number = 0;
    private var _windowH as Number = 0;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _d = _width < _height ? _width : _height;
        _radius = _d / 2;
        _track = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE
            ? new DaysToGoTrack(_width, _height, _d, _radius - ringRadius(), ringWidth()) : null;
        // Asked of semi-octagon screens only (the Instinct's round window, ADR-015), so no round
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
    }

    function track() as DaysToGoTrack? {
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
        var clear = _windowY + _windowH + _d * WINDOW_CLEARANCE_PERMILLE / DaysToGoConfig.PERMILLE;
        return y > clear ? y : clear;
    }

    // [center x, center y, outer radius, fill width] of the gauge that fills the window (the bezel ring's
    // Instinct form), one pixel inside the window's edge; null on every other product.
    function windowRing() as [Number, Number, Number, Number]? {
        if (_subscreen == null) {
            return null;
        }
        var radius = (_windowW < _windowH ? _windowW : _windowH) / 2 - 1;
        return [_windowX + _windowW / 2, _windowY + _windowH / 2, radius, radius / WINDOW_FILL_DIVISOR];
    }

    // Width of the band the first row (the time) has: the whole usable width, or what the window leaves.
    function topBandWidth(height as Number) as Number {
        return rightInsetWithin(_radius, sideMargin(), height) - leftInsetWithin(_radius, sideMargin(), height);
    }

    // Rows that start above the window's lower edge (plus its ring) share their line with it.
    private function besideWindow(y as Number) as Boolean {
        return _subscreen != null && y < belowWindow(0);
    }

    // x that centres text in the usable band of this row: the screen's centre, except beside the window.
    function rowCenterX(y as Number, height as Number) as Number {
        return besideWindow(y) ? (leftInsetWithin(_radius, y, height) + rightInsetWithin(_radius, y, height)) / 2 : centerX();
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
        return _d * permille / DaysToGoConfig.PERMILLE;
    }

    // Stacks the rows top to bottom inside the ring: time, name, hero, caption,
    // date, footer. Each argument is that row's height, 0 when the row is
    // absent. The hero takes everything between the name and the caption.
    // Asleep (time and hero only, fitted inside a smaller outline by the drift step) a rectangle's stack is that much shorter.
    function rows(timeH as Number, nameH as Number, captionH as Number, dateH as Number, footerH as Number,
                  sleeping as Boolean) as DaysToGoRows {
        var span = contentRadius() * SPAN_PERMILLE / DaysToGoConfig.PERMILLE;
        var gap = _d * GAP_PERMILLE / DaysToGoConfig.PERMILLE;
        var rows = new DaysToGoRows();
        // Beside the Instinct window the stack runs the screen's height, top to a bottom margin, and the hero starts
        // below the window; on a rectangle it runs the box inside the track, top to bottom; on a round watch it is
        // the span inside the ring.
        var top = _subscreen == null ? centerY() - span : sideMargin();
        var bottom = _subscreen == null ? centerY() + span : _height - _d * BOTTOM_MARGIN_PERMILLE / DaysToGoConfig.PERMILLE;
        if (_track != null) {
            top = _radius - contentRadius() + (sleeping ? driftStep() : 0);
            bottom = _height - top;
        }
        rows.timeTop = top;
        top += timeH + gap;
        if (nameH > 0) {
            rows.nameTop = top;
            top += nameH + gap;
        }
        top = belowWindow(top);
        if (footerH > 0) {
            bottom -= footerH;
            rows.footerTop = bottom;
            bottom -= gap;
        }
        if (dateH > 0) {
            bottom -= dateH;
            rows.dateTop = bottom;
            bottom -= gap;
        }
        if (captionH > 0) {
            bottom -= captionH;
            rows.captionTop = bottom;
            bottom -= gap;
        }
        rows.heroTop = top;
        rows.heroHeight = bottom - top;
        return rows;
    }

    // How far the always-on block moves between grid spots. A rectangle moves at least RECTANGLE_MIN_DRIFT_PX: on the
    // 240 px Venu Sq 3.5 % is 8 px and the simulator's heat map shut the screen off for pixels lit three minutes; 16 px
    // lasted 7 minutes, 24 px passed the 24-hour run (ADR-019).
    function driftStep() as Number {
        var step = _d * DaysToGoConfig.BURN_IN_STEP_PERMILLE / DaysToGoConfig.PERMILLE;
        return _track != null && step < RECTANGLE_MIN_DRIFT_PX ? RECTANGLE_MIN_DRIFT_PX : step;
    }

    function ringWidth() as Number {
        return _d * RING_WIDTH_PERMILLE / DaysToGoConfig.PERMILLE;
    }

    function ringRadius() as Number {
        return _radius - ringWidth() / 2 - _d * RING_GAP_PERMILLE / DaysToGoConfig.PERMILLE;
    }

    // Everything inside the ring fits against this circle, so text never touches the ring.
    function contentRadius() as Number {
        return ringRadius() - ringWidth() / 2 - _d * TEXT_MARGIN_PERMILLE / DaysToGoConfig.PERMILLE;
    }

    // On the Instinct a row is a box, not a chord: a side margin each side, and beside the window the right edge is the
    // window's left edge less its ring.
    // On a rectangle a radius stands for its depth in from the edge (the round ring's inset), as a rounded box.
    function leftInsetWithin(radius as Number, y as Number, height as Number) as Number {
        var track = _track;
        if (track != null) {
            return track.insetAt(_radius - radius, y, height);
        }
        if (_subscreen != null) {
            var visible = centerX() - chordHalfWidth(VISIBLE_RADIUS_PX, farthestDy(y, height));
            var box = sideMargin();
            return visible > box ? visible : box;
        }
        return centerX() - chordHalfWidth(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Number, y as Number, height as Number) as Number {
        var track = _track;
        if (track != null) {
            return _width - track.insetAt(_radius - radius, y, height);
        }
        if (_subscreen != null) {
            var visible = centerX() + chordHalfWidth(VISIBLE_RADIUS_PX, farthestDy(y, height));
            var box = (besideWindow(y) ? _windowX - _d * WINDOW_CLEARANCE_PERMILLE / DaysToGoConfig.PERMILLE : _width - sideMargin());
            return visible < box ? visible : box;
        }
        return centerX() + chordHalfWidth(radius, farthestDy(y, height));
    }

    private function sideMargin() as Number {
        return _d * SIDE_MARGIN_PERMILLE / DaysToGoConfig.PERMILLE;
    }

    // The whole display, for the screen-fit test.
    function leftInset(y as Number, height as Number) as Number {
        return leftInsetWithin(_radius, y, height);
    }

    function rightInset(y as Number, height as Number) as Number {
        return rightInsetWithin(_radius, y, height);
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
