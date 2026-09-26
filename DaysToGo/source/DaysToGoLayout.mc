import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

// Geometry, measured once per display. Everything is a share of D, the shorter
// screen side, so one layout serves every round product. Rows are bands: text
// is centred in its band, and every text is checked against the round chord.
class DaysToGoLayout {
    // Row height caps in thousandths of D. A row takes the largest font up to
    // its cap (or the smallest font, on a screen too small for the cap), and
    // the hero gets whatever height the other rows leave.
    static const TIME_MAX_PERMILLE = 130;
    static const NAME_MAX_PERMILLE = 90;
    static const CAPTION_MAX_PERMILLE = 90;
    static const SMALL_MAX_PERMILLE = 80;

    // The stack spans this share of the content radius above and below the centre.
    private static const SPAN_PERMILLE = 800;
    private static const GAP_PERMILLE = 12;

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

    static const NAME_FONTS = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const CAPTION_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const SMALL_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;

    private var _width as Number;
    private var _height as Number;
    private var _d as Number;
    private var _radius as Number;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _d = _width < _height ? _width : _height;
        _radius = _d / 2;
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
        var span = contentRadius() * SPAN_PERMILLE / DaysToGoConfig.PERMILLE;
        var gap = _d * GAP_PERMILLE / DaysToGoConfig.PERMILLE;
        var rows = new DaysToGoRows();
        var top = centerY() - span;
        var bottom = centerY() + span;
        rows.timeTop = top;
        top += timeH + gap;
        if (nameH > 0) {
            rows.nameTop = top;
            top += nameH + gap;
        }
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

    function leftInsetWithin(radius as Number, y as Number, height as Number) as Number {
        return centerX() - chordHalfWidth(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Number, y as Number, height as Number) as Number {
        return centerX() + chordHalfWidth(radius, farthestDy(y, height));
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
