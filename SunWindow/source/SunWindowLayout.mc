import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Where things go, from the approved mockup (DESIGN.md, ADR-011), measured not guessed: fractions of the screen,
// text widths from the real fonts. Round, rectangular and the Instinct's semi-octagon (a ~98 px visible circle with a
// round sub-window) share the same numbers; only the room for a row differs (halfWidth).
class SunWindowLayout {
    // The picture, as percent of the screen height / width.
    static const HORIZON_PERCENT = 49;
    static const HORIZON_PERCENT_MONO = 52;
    static const DEGREES_TALL_PERCENT = 40;        // 90 degrees of sky is this tall
    static const DEGREES_TALL_PERCENT_MONO = 30;
    static const PATH_LEFT_PERCENT = 11;
    static const PATH_RIGHT_PERCENT = 89;
    static const PATH_LEFT_PERCENT_MONO = 12;      // left of the Instinct's sub-window
    static const PATH_RIGHT_PERCENT_MONO = 62;
    static const HORIZON_OVERHANG_PERCENT = 4;     // the horizon line runs this far past the path's ends
    static const ROWS_BELOW_HORIZON_PERCENT = 2;
    static const ROWS_TOP_NO_PICTURE_PERCENT = 40; // the empty states have no picture: their rows sit here
    static const BIG_SCREEN_PX = 300;              // wider than this the state word starts at FONT_LARGE, else FONT_MEDIUM
    static const LINE_DIVISOR = 110;               // line width: screen width / this, at least MIN_LINE
    static const MIN_LINE = 2;
    static const DOT_PERCENT = 38;                 // the sun dot's radius, tenths of a percent of the width
    static const MIN_DOT = 5;
    static const SKY_DEGREES = 90.0;               // horizon to zenith
    static const PERCENT_FLOAT = 100.0;
    // Room for a row. The Instinct shows a circle of this radius (permille of its width, ~98 px of 176); a rectangle
    // keeps RECT_MARGIN off each side; every row keeps MARGIN off the visible edge.
    static const VISIBLE_RADIUS_PERMILLE = 557;
    static const RECT_MARGIN = 8;
    static const MARGIN = 4;

    var width as Number;
    var height as Number;
    var mono as Boolean;
    var rectangle as Boolean;
    var semiOctagon as Boolean;

    function initialize(dc as Dc) {
        width = dc.getWidth();
        height = dc.getHeight();
        mono = SunWindowPalette.MONO;
        var shape = System.getDeviceSettings().screenShape;
        rectangle = shape == System.SCREEN_SHAPE_RECTANGLE;
        semiOctagon = shape == System.SCREEN_SHAPE_SEMI_OCTAGON;
    }

    function centerX() as Number {
        return width / 2;
    }

    function horizonY() as Number {
        return height * (mono ? HORIZON_PERCENT_MONO : HORIZON_PERCENT) / SunWindowConfig.PERCENT;
    }

    // Pixels per degree of the sun's height.
    function pxPerDegree() as Float {
        return height.toFloat() * (mono ? DEGREES_TALL_PERCENT_MONO : DEGREES_TALL_PERCENT) / PERCENT_FLOAT / SKY_DEGREES;
    }

    function pathLeft() as Number {
        return width * (mono ? PATH_LEFT_PERCENT_MONO : PATH_LEFT_PERCENT) / SunWindowConfig.PERCENT;
    }

    function pathRight() as Number {
        return width * (mono ? PATH_RIGHT_PERCENT_MONO : PATH_RIGHT_PERCENT) / SunWindowConfig.PERCENT;
    }

    function overhang() as Number {
        return width * HORIZON_OVERHANG_PERCENT / SunWindowConfig.PERCENT;
    }

    function lineWidth() as Number {
        var w = width / LINE_DIVISOR;
        return w < MIN_LINE ? MIN_LINE : w;
    }

    function dotRadius() as Number {
        var r = width * DOT_PERCENT / 1000;
        return r < MIN_DOT ? MIN_DOT : r;
    }

    function rowsTop(withPicture as Boolean) as Number {
        return withPicture ? horizonY() + height * ROWS_BELOW_HORIZON_PERCENT / SunWindowConfig.PERCENT : height * ROWS_TOP_NO_PICTURE_PERCENT / SunWindowConfig.PERCENT;
    }

    function startsLarge() as Boolean {
        return width >= BIG_SCREEN_PX;
    }

    // Half the width a row may take between screen rows y0 and y1: the chord of the visible circle at the row's
    // farthest edge from the centre, or the rectangle's own width.
    function halfWidth(y0 as Number, y1 as Number) as Number {
        if (rectangle) {
            return width / 2 - RECT_MARGIN;
        }
        var radius = semiOctagon ? width * VISIBLE_RADIUS_PERMILLE / 1000 : width / 2;
        var cy = height / 2;
        var dy = (y0 - cy).abs() > (y1 - cy).abs() ? (y0 - cy).abs() : (y1 - cy).abs();
        if (dy >= radius) {
            return 0;
        }
        var half = Math.sqrt((radius * radius - dy * dy).toFloat()).toNumber() - MARGIN;
        return semiOctagon && half > width / 2 - MARGIN ? width / 2 - MARGIN : half;
    }

    // The round sub-window of the Instinct as a box [x, y, width, height], else null.
    function subscreen() as Array<Number> or Null {
        if (!semiOctagon || !(WatchUi has :getSubscreen)) {
            return null;
        }
        var box = WatchUi.getSubscreen();
        return box == null ? null : [box.x, box.y, box.width, box.height] as Array<Number>;
    }
}
