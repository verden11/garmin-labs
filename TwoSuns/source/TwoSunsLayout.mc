import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Geometry, measured once per display. Everything is a share of D, the shorter screen side, so one
// layout serves every round product. Rows are bands: text is centred in its band, and every text is
// checked against the round chord (TwoSunsDraw). Fonts are chosen first, then the rows are stacked
// from their real heights (Days To Go ADR-012), so a small screen gives rows less room, never overlap.
class TwoSunsLayout {
    // Row height caps in thousandths of D. A row takes the largest font up to its cap (or the smallest
    // font, on a screen too small for the cap).
    static const DATE_MAX_PERMILLE = 60;
    static const TIME_MAX_PERMILLE = 230;
    static const VALUE_MAX_PERMILLE = 80;
    static const LINE_MAX_PERMILLE = 75;
    // The Body Battery band is at least this tall when it carries the curve.
    static const CURVE_BAND_PERMILLE = 110;

    // The stack spans this share of the content radius above and below the centre.
    private static const SPAN_PERMILLE = 800;
    private static const GAP_PERMILLE = 14;

    private static const RING_WIDTH_PERMILLE = 25;
    private static const RING_GAP_PERMILLE = 10;
    private static const TEXT_MARGIN_PERMILLE = 20;

    // Fonts by role, largest first; a row takes the largest whose height fits its cap.
    static const DATE_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const TIME_FONTS = [Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;
    static const VALUE_FONTS = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    static const LINE_FONTS = [Graphics.FONT_TINY, Graphics.FONT_XTINY] as Array<Graphics.FontDefinition>;
    // Always-on time: two sizes smaller than awake, to stay far under the 10% lit-pixel limit.
    static const SLEEP_TIME_FONTS = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Array<Graphics.FontDefinition>;

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
        return _d * permille / TwoSunsConfig.PERMILLE;
    }

    // The height the stack of rows may use: the content circle, less the margin at the top and bottom.
    function spanHeight() as Number {
        return 2 * contentRadius() * SPAN_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    function gap() as Number {
        return _d * GAP_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    // Stacks the rows top to bottom and centres the block on the display: date, time, Body Battery
    // band, sun line. Each argument is that row's height, 0 when the row is absent.
    function rows(dateH as Number, timeH as Number, bandH as Number, lineH as Number) as TwoSunsRows {
        var rows = new TwoSunsRows();
        var top = centerY() - stackHeight(dateH, timeH, bandH, lineH) / 2;
        if (dateH > 0) {
            rows.dateTop = top;
            top += dateH + gap();
        }
        rows.timeTop = top;
        top += timeH + gap();
        rows.bandTop = top;
        top += bandH;
        if (lineH > 0) {
            rows.lineTop = top + gap();
        }
        return rows;
    }

    // The total height of the rows that are present, with a gap between each.
    function stackHeight(dateH as Number, timeH as Number, bandH as Number, lineH as Number) as Number {
        var total = timeH + bandH + gap();
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
        return _d * RING_WIDTH_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    function ringRadius() as Number {
        return _radius - ringWidth() / 2 - _d * RING_GAP_PERMILLE / TwoSunsConfig.PERMILLE;
    }

    // Everything inside the ring fits against this circle, so text never touches the ring.
    function contentRadius() as Number {
        return ringRadius() - ringWidth() / 2 - _d * TEXT_MARGIN_PERMILLE / TwoSunsConfig.PERMILLE;
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
