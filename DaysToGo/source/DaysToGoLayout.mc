import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Geometry, measured once per display. Everything is a share of D, the shorter
// screen side, so one layout serves every round product. Rows are bands: text
// is centred in its band, and every text is checked against the round chord.
class DaysToGoLayout {
    // Row height caps in thousandths of D. A row takes the largest font up to
    // its cap (or the smallest font, on a screen too small for the cap), and
    // the hero gets whatever height the other rows leave.
    static const TIME_MAX_PERMILLE = 130;
    // Beside the Instinct window the time may be taller: it has the band left of the window to itself (ADR-015).
    static const TIME_BESIDE_WINDOW_MAX_PERMILLE = 200;
    static const NAME_MAX_PERMILLE = 90;
    static const CAPTION_MAX_PERMILLE = 90;
    static const SMALL_MAX_PERMILLE = 80;

    // The stack spans this share of the content radius above and below the centre.
    private static const SPAN_PERMILLE = 800;
    // A rectangle's rows are as tall as a round watch's (320 px: 39 px smallest font) but its circle is no bigger, so the stack
    // runs closer to the ring's inside edge there. Every text is still measured against the chord, so none touches the ring (ADR-016).
    private static const RECTANGLE_SPAN_PERMILLE = 900;
    private static const GAP_PERMILLE = 12;

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
    static const RING_START_DEG = 90;
    static const FULL_CIRCLE_DEG = 360;
    private static const MIN_SWEEP_DEG = 1;

    // Fonts by role, largest first; DaysToGoDraw.line takes the first that fits.
    static const TIME_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const HERO_NUMBER_FONTS = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    // Number fonts have no letters, so TODAY and SET A DATE use these.
    static const HERO_WORD_FONTS = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    // Always-on hero: two sizes smaller than awake, to stay far under the 10% lit-pixel limit.
    static const SLEEP_HERO_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static function heroFonts(word as Boolean, sleeping as Boolean) as Array<Graphics.FontDefinition> {
        if (word) {
            return HERO_WORD_FONTS;
        }
        return sleeping ? SLEEP_HERO_FONTS : HERO_NUMBER_FONTS;
    }

    // Pro's "8h 06m" (DaysToGoHoursHero): the letters are at most this share of the digits' font height, and
    // their box is lifted by this share of it so they sit on the digits' baseline (tuned on screenshots, 2026-10-05).
    static const HOURS_UNIT_MAX_PERMILLE = 450;
    static const HOURS_UNIT_LIFT_PERMILLE = 130;

    // Marks before a row's words (DaysToGoMark): height as a share of the row's font, centred this far down the
    // font's box (where its capitals sit), a gap after it, and the stroke as a share of the height (tuned on screenshots).
    static const MARK_SIZE_PERMILLE = 450;
    static const MARK_CENTER_PERMILLE = 560;
    static const MARK_GAP_PERMILLE = 400;
    static const MARK_PEN_DIVISOR = 5;
    static const MARK_MIN_PX = 6;

    static const NAME_FONTS = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const CAPTION_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const SMALL_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;
    private var _subscreen as Graphics.BoundingBox?;
    private var _rectangle as Boolean;
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
        _rectangle = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE;
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
    function rows(timeH as Number, nameH as Number, captionH as Number, dateH as Number, footerH as Number) as DaysToGoRows {
        var span = contentRadius() * (_rectangle ? RECTANGLE_SPAN_PERMILLE : SPAN_PERMILLE) / DaysToGoConfig.PERMILLE;
        var gap = _d * GAP_PERMILLE / DaysToGoConfig.PERMILLE;
        var rows = new DaysToGoRows();
        // Beside the Instinct window the stack runs the screen's height, top to a bottom margin, and the hero starts
        // below the window; everywhere else it is the span inside the ring.
        var top = _subscreen == null ? centerY() - span : sideMargin();
        var bottom = _subscreen == null ? centerY() + span : _height - _d * BOTTOM_MARGIN_PERMILLE / DaysToGoConfig.PERMILLE;
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

    // How far the always-on block moves between grid spots.
    function driftStep() as Number {
        return _d * DaysToGoConfig.BURN_IN_STEP_PERMILLE / DaysToGoConfig.PERMILLE;
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

    // Degrees of the ring to draw for a 0 to 1000 share. Any progress shows at
    // least a degree; a full share is a full circle.
    static function ringSweepFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        if (permille >= DaysToGoConfig.PERMILLE) {
            return FULL_CIRCLE_DEG;
        }
        var sweep = FULL_CIRCLE_DEG * permille / DaysToGoConfig.PERMILLE;
        return sweep < MIN_SWEEP_DEG ? MIN_SWEEP_DEG : sweep;
    }

    static function arcEndDegree(startDeg as Number, sweepDeg as Number) as Number {
        var end = (startDeg - sweepDeg) % FULL_CIRCLE_DEG;
        return end < 0 ? end + FULL_CIRCLE_DEG : end;
    }

    // On the Instinct a row is a box, not a chord: a side margin each side, and beside the window the right edge is the
    // window's left edge less its ring.
    function leftInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (_subscreen != null) {
            var visible = centerX() - chordHalfWidth(VISIBLE_RADIUS_PX, farthestDy(y, height));
            var box = sideMargin();
            return visible > box ? visible : box;
        }
        return centerX() - chordHalfWidth(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Number, y as Number, height as Number) as Number {
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
