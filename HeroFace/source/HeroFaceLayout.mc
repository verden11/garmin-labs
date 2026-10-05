import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Geometry for the face, measured once per display in onLayout. Proportions
// follow HeroSetLayout (inset = a tenth of the screen) so the ring, bars and
// labels match HeroSet's dashboard. Rows are stacked from the bottom up and
// the time gets whatever height is left, so it is always the largest thing.
class HeroFaceLayout {

    // Same arc as HeroSet's XP ring: from lower left clockwise over the top,
    // leaving a 100-degree gap at the bottom for the footer.
    static const RING_START_DEG = 220;
    static const RING_SWEEP_DEG = 260;
    static const FULL_CIRCLE_DEG = 360;
    // The Instinct window gauge starts at 12 o'clock and can close (the other ring never does).
    static const WINDOW_START_DEG = 90;
    private static const TIME_SAMPLE = "00:00";
    private static const WINDOW_FILL_DIVISOR = 4;
    private static const TIME_BAND_MAX_PERMILLE = 250;
    // A quarter circle is pi/2 of its radius long.
    private static const QUARTER_ARC_PERMILLE = 1571;
    // The bezel hides the corners of a semi-octagon display: what shows is the square cut by a circle about 98 px in radius
    // (measured off the alpha mask of the SDK's device images, 96 to 100 px on all seven Instinct products).
    static const VISIBLE_RADIUS_PX = 96;

    private var _width as Number;
    private var _height as Number;
    private var _radius as Number;
    private var _round as Boolean;
    private var _subscreen as Graphics.BoundingBox?;
    // The Instinct window's box as plain numbers (BoundingBox fields are nullable); unused elsewhere.
    private var _windowX as Number = 0;
    private var _windowY as Number = 0;
    private var _windowW as Number = 0;
    private var _windowH as Number = 0;

    // Date, in the narrow row inside the ring's top.
    var topRowTop as Number = 0;
    var timeTop as Number = 0;
    var timeFont as Graphics.FontDefinition = Graphics.FONT_NUMBER_MILD;
    // Streak and temperature, on the wide row under the time.
    var underTimeTop as Number = 0;
    var missionTop as Number = 0;
    var footerTop as Number = 0;
    var columnLeft as Number = 0;
    var columnWidth as Number = 0;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _radius = (_width < _height ? _width : _height) / 2;
        var shape = System.getDeviceSettings().screenShape;
        _round = shape == System.SCREEN_SHAPE_ROUND;
        // Asked of semi-octagon screens only (the Instinct's round window, ADR-002), so no round product's
        // geometry can depend on it.
        _subscreen = shape == System.SCREEN_SHAPE_SEMI_OCTAGON && (WatchUi has :getSubscreen) ? WatchUi.getSubscreen() : null;
        var window = _subscreen;
        if (window != null) {
            _windowX = window.x as Number;
            _windowY = window.y as Number;
            _windowW = window.width as Number;
            _windowH = window.height as Number;
        }
        stackRows(dc);
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
        var clear = _windowY + _windowH + windowClearance();
        return y > clear ? y : clear;
    }

    // [center x, center y, outer radius, fill width] of the gauge that fills the window (the bezel ring's Instinct
    // form), one pixel inside the window's edge; null on every other product.
    function windowRing() as [Number, Number, Number, Number]? {
        if (_subscreen == null) {
            return null;
        }
        var radius = (_windowW < _windowH ? _windowW : _windowH) / 2 - 1;
        return [_windowX + _windowW / 2, _windowY + _windowH / 2, radius, radius / WINDOW_FILL_DIVISOR];
    }

    // The window sits in a bezel ring wider than itself (about 10 px at 176).
    private function windowClearance() as Number {
        return shortInset() * 2 / 3;
    }

    // Rows that start above the window's lower edge (plus its ring) share their line with it.
    private function besideWindow(y as Number) as Boolean {
        return _subscreen != null && y < belowWindow(0);
    }

    // A mission icon's height as a share of the label font's ascent (HeroFaceIcon): about its capitals' height.
    static const ICON_SIZE_PERMILLE = 1000;

    // x that centres text in the usable band of this row: the screen's centre, except beside the window.
    function rowCenterX(y as Number, height as Number) as Number {
        return besideWindow(y) ? (leftInset(y, height) + rightInset(y, height)) / 2 : centerX();
    }


    // Bottom up: footer in the ring's gap, mission columns, then the streak
    // and temperature row. The date takes the narrow row inside the ring's top
    // (measured: "WED 30 SEP" needs 172 px of the 208 there on fr965, though a
    // temperature beside it would not fit, which is why it moved down); the
    // time fills the band between, so it is always the largest thing here.
    private function stackRows(dc as Graphics.Dc) as Void {
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        var gap = stackGap();
        if (_subscreen != null) {
            stackBesideWindow(dc, line, gap);
            return;
        }
        // A rectangle's top and bottom need no room for a circle's chord, and its footer sits in the frame's open
        // bottom, so they keep half the inset: on a Venu Sq 2 the time's box (81 px at its smallest font) needs it (ADR-005).
        var margin = rectangle() ? shortInset() / 2 : shortInset();
        footerTop = _height - margin - line;
        missionTop = footerTop - gap * 2 - missionHeight(dc);
        underTimeTop = missionTop - gap - line;
        topRowTop = margin + ringWidth();
        var bandTop = topRowTop + line;
        timeFont = pickTimeFont(dc, bandTop, underTimeTop);
        timeTop = bandTop + (underTimeTop - bandTop - dc.getFontHeight(timeFont)) / 2;
        var left = leftInsetWithin(contentRadius(), missionTop, missionHeight(dc));
        var right = rightInsetWithin(contentRadius(), missionTop, missionHeight(dc));
        columnWidth = (right - left - columnGap() * 2) / 3;
        columnLeft = left;
    }

    // The Instinct (ADR-002): the time and the date share the band left of the window, the streak sits just below the
    // window, the mission columns end above the bottom corners (the bezel leaves the last row about 100 px). The footer
    // and the temperature have no room (the watch's smallest font is 23 px tall on a 176 px screen) and are not drawn.
    private function stackBesideWindow(dc as Graphics.Dc, line as Number, gap as Number) as Void {
        timeTop = sideInset();
        timeFont = pickBandTimeFont(dc, timeTop);
        topRowTop = timeTop + dc.getFontHeight(timeFont) + gap;
        underTimeTop = belowWindow(topRowTop + line) + gap;
        footerTop = _height;
        missionTop = underTimeTop + line + gap * 2;
        columnLeft = leftInset(missionTop, missionHeight(dc));
        columnWidth = (rightInset(missionTop, missionHeight(dc)) - columnLeft - columnGap() * 2) / 3;
    }

    // The largest number font whose box is at most a quarter of the screen tall and whose widest time fits the band
    // beside the window.
    private function pickBandTimeFont(dc as Graphics.Dc, top as Number) as Graphics.FontDefinition {
        var fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM] as Array<Graphics.FontDefinition>;
        var cap = (_width < _height ? _width : _height) * TIME_BAND_MAX_PERMILLE / 1000;
        for (var i = 0; i < fonts.size(); i++) {
            var height = dc.getFontHeight(fonts[i]);
            var room = rightInset(top, height) - leftInset(top, height);
            if (height <= cap && dc.getTextWidthInPixels(TIME_SAMPLE, fonts[i]) <= room) {
                return fonts[i];
            }
        }
        return Graphics.FONT_NUMBER_MILD;
    }

    // Value, bar, label.
    function missionHeight(dc as Graphics.Dc) as Number {
        return dc.getFontHeight(Graphics.FONT_XTINY) * 2 + stackGap() * 2 + barHeight();
    }

    // Largest number font whose box fits the band and whose widest time fits
    // the ring's inner circle at that height.
    private function pickTimeFont(dc as Graphics.Dc, top as Number, bottom as Number) as Graphics.FontDefinition {
        var fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM] as Array<Graphics.FontDefinition>;
        // A rectangle's band is wide enough for the largest font with nothing beside it, which would leave Pro's seconds
        // no room on a Venu X1: there the time also keeps room for the seconds on both sides (it stays centred, ADR-005).
        var eights = dc.getTextWidthInPixels("88", Graphics.FONT_XTINY);
        var zeros = dc.getTextWidthInPixels("00", Graphics.FONT_XTINY);
        var seconds = rectangle() ? 2 * (stackGap() * 2 + (eights > zeros ? eights : zeros)) : 0;
        for (var i = 0; i < fonts.size(); i++) {
            var height = dc.getFontHeight(fonts[i]);
            var y = top + (bottom - top - height) / 2;
            var room = rightInsetWithin(contentRadius(), y, height) - leftInsetWithin(contentRadius(), y, height) - seconds;
            if (height <= bottom - top && dc.getTextWidthInPixels(TIME_SAMPLE, fonts[i]) <= room) {
                return fonts[i];
            }
        }
        return Graphics.FONT_NUMBER_MILD;
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

    function shortInset() as Number {
        return (_width < _height ? _width : _height) / 10;
    }

    private function sideInset() as Number {
        return shortInset() / 2;
    }

    function textMargin() as Number {
        return shortInset() / 2;
    }

    function stackGap() as Number {
        return shortInset() / 9;
    }

    function columnGap() as Number {
        return shortInset() / 5;
    }

    // Side padding of a finished goal's reversed label on the 1-bit Instinct (HeroFaceMissions.drawLabel).
    function doneLabelPad() as Number {
        return shortInset() / 8;
    }

    function barHeight() as Number {
        return shortInset() / 3;
    }

    function ringRadius() as Number {
        return _radius - shortInset() / 5;
    }

    function ringWidth() as Number {
        return shortInset() / 6;
    }

    // Venu Sq / Sq 2 / X1 (ADR-005): the ring is a rounded rectangle along the screen's edges instead of a circle, and
    // rows use the whole width inside it (the full-width-rows idea is DayArc's, credited, not linked).
    function rectangle() as Boolean {
        return !_round && _subscreen == null;
    }

    // A rectangle's rows fit inside the frame the way round rows fit inside the ring: half the ring width plus half the
    // text margin in from its centreline, and inside its rounded corners (all four, because the Venu X1's glass is
    // rounded at the bottom too, where the frame is open).
    private function rectangleInset(y as Number, height as Number) as Number {
        var b = frameBox();
        var pad = ringWidth() / 2 + textMargin() / 2;
        var edge = b[0] + pad;
        var radius = b[4] - pad;
        var dyTop = edge + radius - y;
        var dyBottom = y + height - (_height - edge - radius);
        var dy = dyTop > dyBottom ? dyTop : dyBottom;
        return dy > 0 ? edge + radius - chordHalfWidth(radius, dy) : edge;
    }

    // The rectangle ring's centreline: [left x, top y, right x, y where the sides' straight runs end, corner radius].
    // Inset like the round ring (a fifth of the inset); the corner radius clears the Venu X1's rounded glass (about
    // 53 px at 448) with room to spare, and stays one proportion on every size. The bottom edge is the open gap.
    function frameBox() as [Number, Number, Number, Number, Number] {
        var edge = shortInset() / 5;
        var corner = shortInset() * 3 / 2;
        return [edge, edge, _width - edge, _height - edge - corner, corner];
    }

    // Length in px of the rectangle ring: two sides, two top corners (a quarter circle each), the top.
    function frameLength() as Number {
        var b = frameBox();
        return 2 * (b[3] - b[1] - b[4]) + 2 * quarterArc(b[4]) + (b[2] - b[0] - 2 * b[4]);
    }

    static function quarterArc(radius as Number) as Number {
        return radius * QUARTER_ARC_PERMILLE / 1000;
    }

    // Px of the rectangle ring to fill for a 0-1000 share: any progress shows a pixel, a full share the whole path.
    function frameFillFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        var length = frameLength();
        if (permille >= 1000) {
            return length;
        }
        var fill = length * permille / 1000;
        return fill < 1 ? 1 : fill;
    }

    // Everything inside the ring fits against this circle, so text never
    // touches the ring.
    function contentRadius() as Number {
        return ringRadius() - ringWidth() / 2 - textMargin() / 2;
    }

    // Degrees of the ring to fill for a 0-1000 share. Any progress shows at
    // least a degree, and a fill never closes into a full circle.
    static function ringSweepFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        if (permille >= 1000) {
            return RING_SWEEP_DEG;
        }
        var sweep = RING_SWEEP_DEG * permille / 1000;
        return sweep < 1 ? 1 : sweep;
    }

    // Degrees of the window gauge for a 0-1000 share; any progress shows a degree, a full share closes the circle.
    static function windowSweepFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        if (permille >= 1000) {
            return FULL_CIRCLE_DEG;
        }
        var sweep = FULL_CIRCLE_DEG * permille / 1000;
        return sweep < 1 ? 1 : sweep;
    }

    static function arcEndDegree(startDeg as Number, sweepDeg as Number) as Number {
        var end = (startDeg - sweepDeg) % FULL_CIRCLE_DEG;
        return end < 0 ? end + FULL_CIRCLE_DEG : end;
    }

    function leftInset(y as Number, height as Number) as Number {
        return leftInsetWithin(_radius, y, height);
    }

    function rightInset(y as Number, height as Number) as Number {
        return rightInsetWithin(_radius, y, height);
    }

    // Round: the chord of a circle of `radius` at whichever edge of the row is
    // farther from the centre. Rectangle: inside the frame and its rounded corners (`rectangleInset`).
    function leftInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (_subscreen != null) {
            var visible = centerX() - chordHalfWidth(VISIBLE_RADIUS_PX, farthestDy(y, height));
            return visible > sideInset() ? visible : sideInset();
        }
        if (!_round) {
            return rectangleInset(y, height);
        }
        return centerX() - chordHalfWidth(radius, farthestDy(y, height));
    }

    // On the Instinct a row is a box, not a chord: a side margin each side, and beside the window the right edge is
    // the window's left edge less its ring.
    function rightInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (_subscreen != null) {
            var visible = centerX() + chordHalfWidth(VISIBLE_RADIUS_PX, farthestDy(y, height));
            var edge = besideWindow(y) ? _windowX - windowClearance() : _width - sideInset();
            return visible < edge ? visible : edge;
        }
        if (!_round) {
            return _width - rectangleInset(y, height);
        }
        return centerX() + chordHalfWidth(radius, farthestDy(y, height));
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
