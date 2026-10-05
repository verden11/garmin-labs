import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// The sky ring on a rectangular screen (Venu Sq 2, Sq 2 Music, Venu X1; docs/decisions.md ADR-028, the rectangle track):
// a rounded rectangle inset from the glass the way the round ring is inset from the bezel. It starts at top centre and
// runs clockwise; a stretch of the day is the same share of the track's length (straight runs plus quarter-circle
// corners), so the 24 hours are equal time per pixel of length. Also the rounded inner box the rows fit in.
// Pure geometry plus the drawing of one stretch; TwoSunsRing decides what to draw.
class TwoSunsTrack {
    // How round the track's corners are, of D. It clears the Venu X1's rounded glass (68 px radius at 448, measured off
    // the alpha mask of the SDK's device image) and is one proportion on every size (48 px on the 320 px Venu Sq 2,
    // whose glass corner is about 10 px), so the track reads as the round ring's sibling.
    static const CORNER_PERMILLE = 150;
    private static const STRAIGHT = 0;
    private static const CORNER = 1;
    private static const HALF_PI = Math.PI / 2;
    private static const JOIN_PX = 1.0;

    private var _width as Number;
    private var _height as Number;
    private var _inset as Number;     // the centreline's distance from each screen edge
    private var _corner as Number;    // the centreline's corner radius
    // Nine pieces from top centre, clockwise: [kind, length, x, y, a, b]. Straight: start (x, y), direction (a, b).
    // Corner: centre (x, y), start angle a (radians, 0 at 3 o'clock, counter-clockwise; the walk goes clockwise).
    private var _pieces as Array<Array<Float or Number>>;
    private var _length as Float = 0.0;

    function initialize(width as Number, height as Number, inset as Number, corner as Number) {
        _width = width;
        _height = height;
        _inset = inset;
        var most = (width < height ? width : height) / 2 - inset;
        _corner = corner < 1 ? 1 : (corner > most ? most : corner);
        var t = inset.toFloat();
        var r = _corner.toFloat();
        var w = width.toFloat();
        var h = height.toFloat();
        var q = HALF_PI * r;
        _pieces = [
            [STRAIGHT, w / 2 - t - r, w / 2, t, 1, 0],
            [CORNER, q, w - t - r, t + r, HALF_PI, 0],
            [STRAIGHT, h - 2 * t - 2 * r, w - t, t + r, 0, 1],
            [CORNER, q, w - t - r, h - t - r, 0.0, 0],
            [STRAIGHT, w - 2 * t - 2 * r, w - t - r, h - t, -1, 0],
            [CORNER, q, t + r, h - t - r, -HALF_PI, 0],
            [STRAIGHT, h - 2 * t - 2 * r, t, h - t - r, 0, -1],
            [CORNER, q, t + r, t + r, -Math.PI, 0],
            [STRAIGHT, w / 2 - t - r, t + r, t, 1, 0]
        ] as Array<Array<Float or Number>>;
        for (var i = 0; i < _pieces.size(); i++) {
            _length += _pieces[i][1].toFloat();
        }
    }

    function length() as Float {
        return _length;
    }

    function corner() as Number {
        return _corner;
    }

    // Distance along the track of a minute of the day: noon (or midnight, by the Orientation setting) at top centre.
    function distanceFor(minute as Number, orientation as Number) as Float {
        var top = orientation == TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP ? 0 : TwoSunsConfig.NOON_MINUTE;
        var day = TwoSunsConfig.MINUTES_PER_DAY;
        return ((minute - top) % day + day) % day * _length / day;
    }

    // The point at `distance` along the centreline, moved `offset` px outward (negative: inward), across the track.
    function pointAt(distance as Float, offset as Float) as [Float, Float] {
        var s = distance;
        for (var i = 0; i < _pieces.size(); i++) {
            var p = _pieces[i];
            var len = p[1].toFloat();
            if (s <= len || i == _pieces.size() - 1) {
                return pointOn(p, s, offset);
            }
            s -= len;
        }
        return [0.0, 0.0];
    }

    private function pointOn(p as Array<Float or Number>, u as Float, offset as Float) as [Float, Float] {
        var x = p[2].toFloat();
        var y = p[3].toFloat();
        if (p[0] == STRAIGHT) {
            var dx = p[4].toFloat();
            var dy = p[5].toFloat();
            return [x + dx * u + dy * offset, y + dy * u - dx * offset];   // outward is the direction turned left (y down)
        }
        var angle = p[4].toFloat() - u / _corner;
        var radius = _corner + offset;
        return [x + radius * Math.cos(angle).toFloat(), y - radius * Math.sin(angle).toFloat()];
    }

    // Draws the stretch of the centreline from `from` (0 to the length) to `to` px (it may pass the end: it wraps), `pen` px wide.
    function drawSpan(dc as Graphics.Dc, from as Float, to as Float, pen as Number) as Void {
        if (to - from >= _length) {
            drawRange(dc, 0.0, _length, pen);
            return;
        }
        var end = to;
        drawRange(dc, from, end < _length ? end : _length, pen);
        if (end > _length) {
            drawRange(dc, 0.0, end - _length, pen);
        }
    }

    private function drawRange(dc as Graphics.Dc, from as Float, to as Float, pen as Number) as Void {
        var at = 0.0;
        for (var i = 0; i < _pieces.size(); i++) {
            var p = _pieces[i];
            var len = p[1].toFloat();
            var u0 = from - at;
            var u1 = to - at;
            at += len;
            if (u1 <= 0 || u0 >= len || len <= 0) {
                continue;
            }
            // a straight run reaches a pixel into the corner it meets, so no seam shows where the two strokes join
            var join = p[0] == STRAIGHT ? JOIN_PX : 0.0;
            drawPiece(dc, p, u0 <= 0 ? -join : u0, u1 >= len ? len + join : u1, pen);
        }
    }

    private function drawPiece(dc as Graphics.Dc, p as Array<Float or Number>, u0 as Float, u1 as Float, pen as Number) as Void {
        if (p[0] == STRAIGHT) {
            var a = pointOn(p, u0, 0.0);
            var b = pointOn(p, u1, 0.0);
            var left = (a[0] < b[0] ? a[0] : b[0]) - (p[5] == 0 ? 0 : pen / 2.0);
            var top = (a[1] < b[1] ? a[1] : b[1]) - (p[4] == 0 ? 0 : pen / 2.0);
            var right = (a[0] > b[0] ? a[0] : b[0]) + (p[5] == 0 ? 0 : pen / 2.0);
            var bottom = (a[1] > b[1] ? a[1] : b[1]) + (p[4] == 0 ? 0 : pen / 2.0);
            var x = Math.round(left).toNumber();
            var y = Math.round(top).toNumber();
            var w = Math.round(right).toNumber() - x;
            var h = Math.round(bottom).toNumber() - y;
            dc.fillRectangle(x, y, w < 1 ? 1 : w, h < 1 ? 1 : h);
            return;
        }
        var start = Math.round(Math.toDegrees(p[4].toFloat() - u0 / _corner)).toNumber();
        var end = Math.round(Math.toDegrees(p[4].toFloat() - u1 / _corner)).toNumber();
        if (end >= start) {
            end = start - 1;   // a stretch under a degree still shows, and never closes into a full circle
        }
        dc.setPenWidth(pen);
        dc.drawArc(p[2].toFloat(), p[3].toFloat(), _corner, Graphics.ARC_CLOCKWISE, start, end);
    }

    // Half the width of the rounded box `inset` px in from every screen edge, at `dy` px above or below the centre.
    // The box's corners are concentric with the track's, so the rows follow its curve. 0 above or below the box.
    function halfWidthAt(inset as Number, dy as Number) as Number {
        var halfW = _width / 2 - inset;
        var halfH = _height / 2 - inset;
        var corner = _corner + _inset - inset;
        corner = corner < 0 ? 0 : (corner > halfW ? halfW : corner);
        var ady = dy.abs();
        if (ady > halfH) {
            return 0;
        }
        var into = ady - (halfH - corner);
        if (into <= 0) {
            return halfW;
        }
        return halfW - corner + Math.sqrt(corner * corner - into * into).toNumber();
    }
}
