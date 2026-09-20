import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

// Geometry for the face, measured once per display in onLayout. Proportions
// follow HeroSetLayout (inset = a tenth of the screen) so the ring, bars and
// labels match HeroSet's dashboard. Rows are stacked from the bottom up and
// the time gets whatever height is left, so it is always the largest thing.
class HeroFaceLayout {

    // Same arc as HeroSet's XP ring: from lower left clockwise over the top,
    // leaving a 100-degree gap at the bottom for the footer.
    static const RING_START_DEG = 220;
    static const RING_SWEEP_DEG = 260;
    private static const FULL_CIRCLE_DEG = 360;
    private static const TIME_SAMPLE = "00:00";

    private var _width as Number;
    private var _height as Number;
    private var _radius as Number;
    private var _round as Boolean;

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
        _round = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND;
        stackRows(dc);
    }

    // Bottom up: footer in the ring's gap, mission columns, then the streak
    // and temperature row. The date takes the narrow row inside the ring's top
    // (measured: "WED 30 SEP" needs 172 px of the 208 there on fr965, though a
    // temperature beside it would not fit, which is why it moved down); the
    // time fills the band between, so it is always the largest thing here.
    private function stackRows(dc as Graphics.Dc) as Void {
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        var gap = stackGap();
        footerTop = _height - shortInset() - line;
        missionTop = footerTop - gap * 2 - missionHeight(dc);
        underTimeTop = missionTop - gap - line;
        topRowTop = shortInset() + ringWidth();
        var bandTop = topRowTop + line;
        timeFont = pickTimeFont(dc, bandTop, underTimeTop);
        timeTop = bandTop + (underTimeTop - bandTop - dc.getFontHeight(timeFont)) / 2;
        var left = leftInsetWithin(contentRadius(), missionTop, missionHeight(dc));
        var right = rightInsetWithin(contentRadius(), missionTop, missionHeight(dc));
        columnWidth = (right - left - columnGap() * 2) / 3;
        columnLeft = left;
    }

    // Value, bar, label.
    function missionHeight(dc as Graphics.Dc) as Number {
        return dc.getFontHeight(Graphics.FONT_XTINY) * 2 + stackGap() * 2 + barHeight();
    }

    // Largest number font whose box fits the band and whose widest time fits
    // the ring's inner circle at that height.
    private function pickTimeFont(dc as Graphics.Dc, top as Number, bottom as Number) as Graphics.FontDefinition {
        var fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM] as Array<Graphics.FontDefinition>;
        for (var i = 0; i < fonts.size(); i++) {
            var height = dc.getFontHeight(fonts[i]);
            var y = top + (bottom - top - height) / 2;
            var room = rightInsetWithin(contentRadius(), y, height) - leftInsetWithin(contentRadius(), y, height);
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

    function displayRadius() as Number {
        return _radius;
    }

    function shortInset() as Number {
        return (_width < _height ? _width : _height) / 10;
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

    function barHeight() as Number {
        return shortInset() / 3;
    }

    function ringRadius() as Number {
        return _radius - shortInset() / 5;
    }

    function ringWidth() as Number {
        return shortInset() / 6;
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
    // farther from the centre. Square: a constant safe inset.
    function leftInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (!_round) {
            return shortInset();
        }
        return centerX() - chordHalfWidth(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Number, y as Number, height as Number) as Number {
        if (!_round) {
            return _width - shortInset();
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
