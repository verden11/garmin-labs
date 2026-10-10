import Toybox.Lang;

// The rectangle's ring (Venu Sq, Sq 2, X1; ADR-019): a closed rounded rectangle along the screen's edges, inset from
// the glass as the round ring is inset from the bezel. Its centreline, its length, the fill for a share, and the
// rounded box at any depth that rows fit inside. Part of the layout's geometry (split out of DaysToGoLayout).
class DaysToGoTrack {
    // Corner radius of the centreline, a share of D (the studio's 1.5-inset proportion): 67 px at 448 clears the Venu X1's
    // rounded glass (60 to 68 px off the SDK device image's alpha mask) with room; the Sq and Sq 2 glass is nearly square.
    private static const CORNER_PERMILLE = 150;
    // A quarter circle is its radius times pi / 2.
    private static const QUARTER_ARC_PERMILLE = 1571;

    private var _width as Number;
    private var _height as Number;
    // How far the centreline is from the screen's edge, its corner radius, and the shortest fill (a square of the ring's width).
    private var _inset as Number;
    private var _corner as Number;
    private var _minFill as Number;

    function initialize(width as Number, height as Number, d as Number, inset as Number, ringWidth as Number) {
        _width = width;
        _height = height;
        _inset = inset;
        _corner = d * CORNER_PERMILLE / DaysToGoConfig.PERMILLE;
        _minFill = ringWidth;
    }

    // The centreline: [left x, top y, right x, bottom y, corner radius].
    function box() as [Number, Number, Number, Number, Number] {
        return [_inset, _inset, _width - _inset, _height - _inset, _corner];
    }

    // Length in px: the four straight runs and four quarter circles.
    function length() as Number {
        var b = box();
        return 2 * (b[2] - b[0] - 2 * b[4]) + 2 * (b[3] - b[1] - 2 * b[4]) + 4 * quarterArc(b[4]);
    }

    static function quarterArc(radius as Number) as Number {
        return radius * QUARTER_ARC_PERMILLE / DaysToGoConfig.PERMILLE;
    }

    // Px of the track to fill for a 0 to 1000 share: the same share of its length. Any progress shows at least a square
    // of the ring's width; a full share is the whole closed track.
    function fillFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        var length = length();
        if (permille >= DaysToGoConfig.PERMILLE) {
            return length;
        }
        var fill = length * permille / DaysToGoConfig.PERMILLE;
        return fill < _minFill ? _minFill : fill;
    }

    // Left inset of the row [y, y + height) inside the box `depth` px in from the screen's edges, whose rounded corners
    // share the track's corner centres (the round layout's circles of smaller radius, as boxes). Right is the mirror.
    function insetAt(depth as Number, y as Number, height as Number) as Number {
        var radius = _inset + _corner - depth;
        radius = radius > 0 ? radius : 0;
        var dyTop = depth + radius - y;
        var dyBottom = y + height - (_height - depth - radius);
        var dy = dyTop > dyBottom ? dyTop : dyBottom;
        return dy > 0 ? depth + radius - DaysToGoLayout.chordHalfWidth(radius, dy) : depth;
    }
}
