import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// The dashboard's XP ring on a rectangle (ADR-057): a closed rounded-rectangle
// track that follows the screen, inset from the glass as the round ring is from
// the bezel, with the same stroke. It starts at top centre and runs clockwise;
// a share of XP is the same share of the track's length (straight runs plus
// quarter-circle corners). Its inner box is where the dashboard's rows go.
class HeroSetRectTrack {

    // drawArc degrees (0 = 3 o'clock, counterclockwise) where each corner's
    // clockwise quarter starts: top right, bottom right, bottom left, top left.
    private static const CORNER_START_DEG = [90, 0, 270, 180] as Lang.Array<Lang.Number>;
    private static const QUARTER_DEG = 90;

    private var _width as Lang.Number;
    private var _height as Lang.Number;
    private var _edge as Lang.Number;
    private var _stroke as Lang.Number;
    private var _corner as Lang.Number;
    private var _pad as Lang.Number;

    // `inset` is the layout's short inset: the centreline sits a fifth of it in
    // from the glass, like the round ring (HeroSetLayout.ringRadius). The corner
    // radius is one and a half insets (48 px on 320, 67 on 448): it clears the
    // Venu X1's rounded glass (about 60 px, measured off the simulator skin) and
    // keeps one proportion on every size, as HeroFace's frame does.
    function initialize(width as Lang.Number, height as Lang.Number, inset as Lang.Number, stroke as Lang.Number, textMargin as Lang.Number) {
        _width = width;
        _height = height;
        _edge = inset / 5;
        _stroke = stroke;
        _corner = inset * 3 / 2;
        // Rows keep half the stroke plus half the text margin off the
        // centreline, as round rows do off the ring (contentRadius).
        _pad = stroke / 2 + textMargin / 2;
    }

    function stroke() as Lang.Number {
        return _stroke;
    }

    // [left, top, right, bottom, corner radius] of the centreline.
    function box() as [Lang.Number, Lang.Number, Lang.Number, Lang.Number, Lang.Number] {
        return [_edge, _edge, _width - _edge, _height - _edge, _corner];
    }

    function contentTop() as Lang.Number {
        return _edge + _pad;
    }

    function contentBottom() as Lang.Number {
        return _height - _edge - _pad;
    }

    // Left edge of the inner box for a row `height` px tall at y: the constant
    // edge, or further in where the row reaches into a rounded corner (top and
    // bottom: the track is closed, and the X1's glass is rounded at the bottom).
    function inset(y as Lang.Number, height as Lang.Number) as Lang.Number {
        var edge = contentTop();
        var radius = _corner - _pad;
        var dyTop = edge + radius - y;
        var dyBottom = y + height - (_height - edge - radius);
        var dy = dyTop > dyBottom ? dyTop : dyBottom;
        return dy > 0 ? edge + radius - HeroSetLayout.chordHalfWidth(radius, dy) : edge;
    }

    function quarterArc() as Lang.Number {
        return (Math.PI * _corner / 2).toNumber();
    }

    // The straight runs, in path order from top centre: the right half of the
    // top, right side, bottom, left side, left half of the top.
    private function runs() as Lang.Array<Lang.Number> {
        var b = box();
        var center = _width / 2;
        var side = b[3] - b[1] - 2 * _corner;
        return [b[2] - _corner - center, side, b[2] - b[0] - 2 * _corner, side, center - b[0] - _corner] as Lang.Array<Lang.Number>;
    }

    // Px of the whole path: the five straight runs and four quarter circles.
    function length() as Lang.Number {
        var total = 4 * quarterArc();
        var straight = runs();
        for (var i = 0; i < straight.size(); i++) {
            total += straight[i];
        }
        return total;
    }

    // Px of the track to fill for `part` of `whole`: any positive part shows
    // at least a pixel, so the first XP of a rank is visible.
    function fillFor(part as Lang.Number, whole as Lang.Number) as Lang.Number {
        if (whole <= 0 || part <= 0) {
            return 0;
        }
        if (part >= whole) {
            return length();
        }
        var fill = (length().toLong() * part / whole).toNumber();
        return fill < 1 ? 1 : fill;
    }

    // The first `length` px of the path, clockwise from top centre. Straight
    // runs are filled boxes (no pen caps to seam), corners are arcs.
    function draw(dc as Graphics.Dc, length as Lang.Number) as Void {
        var b = box();
        var c = _corner;
        var starts = [[_width / 2, b[1]], [b[2], b[1] + c], [b[2] - c, b[3]], [b[0], b[3] - c], [b[0] + c, b[1]]];
        var directions = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 0]];
        var centers = [[b[2] - c, b[1] + c], [b[2] - c, b[3] - c], [b[0] + c, b[3] - c], [b[0] + c, b[1] + c]];
        var straight = runs();
        var arc = quarterArc();
        dc.setPenWidth(_stroke);
        for (var k = 0; k < straight.size() && length > 0; k++) {
            strip(dc, starts[k] as [Lang.Number, Lang.Number], directions[k] as [Lang.Number, Lang.Number], length < straight[k] ? length : straight[k]);
            length -= straight[k];
            if (length > 0 && k < centers.size()) {
                var center = centers[k] as [Lang.Number, Lang.Number];
                var sweep = (length < arc ? length : arc) * QUARTER_DEG / arc;
                var start = CORNER_START_DEG[k];
                dc.drawArc(center[0], center[1], c, Graphics.ARC_CLOCKWISE, start, HeroSetLayout.arcEndDegree(start, sweep < 1 ? 1 : sweep));
                length -= arc;
            }
        }
        dc.setPenWidth(1);
    }

    // A straight run `length` px long from `from` along `direction`, the
    // stroke's width centred on the centreline.
    private function strip(dc as Graphics.Dc, from as [Lang.Number, Lang.Number], direction as [Lang.Number, Lang.Number], length as Lang.Number) as Void {
        if (length <= 0) {
            return;
        }
        var horizontal = direction[1] == 0;
        var x = horizontal ? (direction[0] < 0 ? from[0] - length : from[0]) : from[0] - _stroke / 2;
        var y = horizontal ? from[1] - _stroke / 2 : (direction[1] < 0 ? from[1] - length : from[1]);
        dc.fillRectangle(x, y, horizontal ? length : _stroke, horizontal ? _stroke : length);
    }
}
