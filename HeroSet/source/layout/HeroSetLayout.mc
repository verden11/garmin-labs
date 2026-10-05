import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Single place that answers every view's geometry questions: band positions,
// footer rows, and per-row side insets. On round displays the usable width at
// a row is the inscribed-circle chord at that y, so top/bottom rows get more
// inset than the center row; square displays degrade to a constant inset.
// Semi-octagon displays (Instinct, ADR-055) take the square path plus a window
// they must stay clear of: a round subscreen cut into the top-right corner.
// Rectangles (Venu Sq 2, Venu X1, ADR-058) have no bezel: rows fitted against
// the display take the full width less the safe inset. Their one circle is the
// dashboard's XP ring, on the inscribed circle about the screen's center, so
// content fitted inside the ring (a radius below the display's) takes its chord.
class HeroSetLayout {

    // Dashboard XP ring (ADR-031), in Dc.drawArc degrees (0 = 3 o'clock,
    // counterclockwise). It starts at lower left and runs clockwise over the
    // top, leaving a 100-degree gap at the bottom for the footer text.
    static const RING_START_DEG = 220;
    static const RING_SWEEP_DEG = 260;
    private static const FULL_CIRCLE_DEG = 360;
    // The bezel hides the corners of a semi-octagon display: what shows is the square cut by a circle about 98 px
    // in radius (measured off the alpha mask of the SDK's device images, 96 to 100 px on all seven Instinct
    // products), so a row near a corner is narrower than the display (ADR-055).
    static const SEMI_OCTAGON_VISIBLE_RADIUS = 98;
    // A font's box carries padding above the capitals and below the baseline (our text is capitals and digits), so the
    // ink of a row is the box less about a quarter of the short inset at each end (4 px on 176 px); the circle is cut
    // against the ink, or the 105 px "START: MENU" would be shortened on a bottom row about 100 px wide although it
    // shows whole.
    private static const INK_TRIM_DIVISOR = 4;

    private var _width;
    private var _height;
    private var _centerX;
    private var _radius;
    private var _round;
    private var _semiOctagon;
    private var _rectangle;
    private var _subscreen as Graphics.BoundingBox?;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _centerX = _width / 2;
        _radius = (_width < _height ? _width : _height) / 2;
        var shape = System.getDeviceSettings().screenShape;
        _round = shape == System.SCREEN_SHAPE_ROUND;
        _semiOctagon = shape == System.SCREEN_SHAPE_SEMI_OCTAGON;
        _rectangle = shape == System.SCREEN_SHAPE_RECTANGLE;
        // Asked of semi-octagon screens only, so no round product's geometry
        // can depend on it.
        _subscreen = _semiOctagon && (WatchUi has :getSubscreen) ? WatchUi.getSubscreen() : null;
    }

    // The Instinct's physical window, in display coordinates; null elsewhere.
    function subscreen() as Graphics.BoundingBox? {
        return _subscreen;
    }

    // A rectangle's rows are as wide at the top as in the middle (ADR-058).
    function rectangle() as Lang.Boolean {
        return _rectangle;
    }

    // Square screens keep a full safe inset on both sides. A semi-octagon's
    // chamfers only reach the corners, which no row occupies (bands start one
    // inset down and the footer ends above the bottom chamfer), so it gets
    // half an inset on each side, and no further text margin (textMargin is 0
    // there, so that room is not taken twice). A rectangle has no bezel at all,
    // only rounded corners, so half an inset too (textMargin stays, for
    // breathing room): a full one cut "MISSION COMPLETE" on 320 px (ADR-058).
    private function sideInset() as Lang.Number {
        return _semiOctagon || _rectangle ? shortInset() / 2 : shortInset();
    }

    // First y at or below `y` that clears the window and its ring, for rows
    // too wide for the band beside it.
    function belowWindow(y as Lang.Number) as Lang.Number {
        var window = _subscreen;
        if (window == null) {
            return y;
        }
        var clear = window.y + window.height + windowClearance();
        return y > clear ? y : clear;
    }

    // The XP gauge that fills the window (ADR-055): [center x, center y,
    // outer radius, fill width], one pixel inside the window's edge.
    function windowRing() as [Lang.Number, Lang.Number, Lang.Number, Lang.Number]? {
        var window = _subscreen;
        if (window == null) {
            return null;
        }
        var radius = (window.width < window.height ? window.width : window.height) / 2 - 1;
        return [window.x + window.width / 2, window.y + window.height / 2, radius, radius / 4];
    }

    // The window sits in a bezel ring wider than the window itself (measured
    // off the Instinct 2 simulator image: about 10 px at 176 px), and the
    // display cannot show anything under it.
    private function windowClearance() as Lang.Number {
        return shortInset() * 2 / 3;
    }

    // Rows that start above the window's lower edge (plus its ring) share
    // their line with it; rows below run the full width.
    private function besideWindow(y as Lang.Number) as Lang.Boolean {
        var window = _subscreen;
        return window != null && y < window.y + window.height + windowClearance();
    }

    // x that centers text in the usable band of this row: the screen's center
    // everywhere, except beside the window, where the band is what is left of it.
    function rowCenterX(y as Lang.Number, height as Lang.Number) as Lang.Number {
        if (!besideWindow(y)) {
            return _centerX;
        }
        return (leftInset(y, height) + rightInset(y, height)) / 2;
    }

    function height() as Lang.Number {
        return _height;
    }

    function centerX() as Lang.Number {
        return _centerX;
    }

    function centerY() as Lang.Number {
        return _height / 2;
    }

    // The inscribed circle of the whole display, for text fitted against the
    // bezel rather than against a smaller concentric circle.
    function displayRadius() as Lang.Number {
        return _radius;
    }

    function shortInset() as Lang.Number {
        return (_width < _height ? _width : _height) / 10;
    }

    // Top-left y of a centered content band (band 0 = first row under the
    // top inset); bands step by one inset plus a fifth.
    function bandTop(band as Lang.Number) as Lang.Number {
        return shortInset() + (shortInset() + shortInset() / 5) * band;
    }

    // Total horizontal breathing room kept between centered text and the
    // chord edges: near mid-screen the chord is the full display width, so
    // text that merely "fits" would touch the bezel.
    function textMargin() as Lang.Number {
        return _semiOctagon ? 0 : shortInset() / 2;
    }

    // Spacing between stacked dashboard blocks, and between a mission label
    // and its bar.
    function stackGap() as Lang.Number {
        return shortInset() / 9;
    }

    function barHeight() as Lang.Number {
        return shortInset() / 3;
    }

    // The ring hugs the bezel (Garmin's own gauge placement) so it costs no
    // content row.
    function ringRadius() as Lang.Number {
        return _radius - shortInset() / 5;
    }

    function ringWidth() as Lang.Number {
        return shortInset() / 6;
    }

    // Everything inside the ring fits against this circle instead of the
    // display edge, so text never touches the ring.
    function contentRadius() as Lang.Number {
        return ringRadius() - ringWidth() / 2 - textMargin() / 2;
    }

    // Degrees of the ring to fill for `part` of `whole`. Any positive part
    // shows at least 1 degree so the first XP of a rank is visible; the result
    // never exceeds RING_SWEEP_DEG, so a fill can never close into a circle.
    static function ringSweepFor(part as Lang.Number, whole as Lang.Number) as Lang.Number {
        if (whole <= 0 || part <= 0) {
            return 0;
        }
        if (part >= whole) {
            return RING_SWEEP_DEG;
        }
        var sweep = RING_SWEEP_DEG * part / whole;
        return sweep < 1 ? 1 : sweep;
    }

    // End angle of a clockwise arc, normalized into [0, 360).
    static function arcEndDegree(startDeg as Lang.Number, sweepDeg as Lang.Number) as Lang.Number {
        var end = (startDeg - sweepDeg) % FULL_CIRCLE_DEG;
        return end < 0 ? end + FULL_CIRCLE_DEG : end;
    }

    // Footer baseline kept inside the bottom safe inset.
    function footerRowBottom() as Lang.Number {
        return _height - shortInset() - shortInset() / 2;
    }

    // Left edge of the usable band at row y, for content `height` px tall
    // (0 for a point/bar with no vertical extent). Round: the inscribed-
    // circle chord at whichever of the row's top/bottom edges sits farther
    // from the vertical center — the binding constraint — so text/bars
    // near the top or bottom of the screen aren't clipped by the bezel.
    // Square: the constant safe inset.
    function leftInset(y as Lang.Number, height as Lang.Number) as Lang.Number {
        return leftInsetWithin(_radius, y, height);
    }

    function rightInset(y as Lang.Number, height as Lang.Number) as Lang.Number {
        return rightInsetWithin(_radius, y, height);
    }

    // Round screens fit every row to a circle; a rectangle only the rows inside
    // the dashboard ring (ADR-058).
    private function chordFitted(radius as Lang.Number) as Lang.Boolean {
        return _round || (_rectangle && radius < _radius);
    }

    // How far the ring's circle starts below the top edge: 0 except on a
    // rectangle taller than wide, so the header can start under the ring.
    function circleTop() as Lang.Number {
        return centerY() - _radius;
    }

    // Same chord as leftInset/rightInset, against a smaller concentric circle
    // (e.g. contentRadius inside the dashboard ring).
    function leftInsetWithin(radius as Lang.Number, y as Lang.Number, height as Lang.Number) as Lang.Number {
        if (!chordFitted(radius)) {
            var visible = _semiOctagon ? _centerX - HeroSetLayout.chordHalfWidth(SEMI_OCTAGON_VISIBLE_RADIUS, farthestInkDy(y, height)) : 0;
            return visible > sideInset() ? visible : sideInset();
        }
        return _centerX - HeroSetLayout.chordHalfWidth(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Lang.Number, y as Lang.Number, height as Lang.Number) as Lang.Number {
        if (!chordFitted(radius)) {
            var window = _subscreen;
            var edge = window != null && besideWindow(y) ? window.x - windowClearance() : _width - sideInset();
            var visible = _semiOctagon ? _centerX + HeroSetLayout.chordHalfWidth(SEMI_OCTAGON_VISIBLE_RADIUS, farthestInkDy(y, height)) : _width;
            return visible < edge ? visible : edge;
        }
        return _centerX + HeroSetLayout.chordHalfWidth(radius, farthestDy(y, height));
    }

    // The largest y no greater than `maxY` (and no less than `minY`) at which
    // centered content `textWidth` px wide, `textHeight` px tall, fits inside
    // the round chord — walking up from the bezel toward the center in small
    // steps and reusing the same left/rightInset the rest of the layout
    // trusts, rather than guessing a safe string length up front. Square:
    // always returns maxY (no chord constraint).
    function fitCenteredY(maxY as Lang.Number, minY as Lang.Number, textWidth as Lang.Number, textHeight as Lang.Number) as Lang.Number {
        if (!_round) {
            return maxY;
        }
        var y = maxY;
        while (y > minY) {
            var available = rightInset(y, textHeight) - leftInset(y, textHeight);
            if (available >= textWidth) {
                return y;
            }
            y -= 2;
        }
        return minY;
    }

    // Of the row's top edge (y) and bottom edge (y + height), the one
    // farther from the circle's vertical center gives the narrower chord.
    static function inkTrim(width as Lang.Number, height as Lang.Number) as Lang.Number {
        return (width < height ? width : height) / 10 / INK_TRIM_DIVISOR;
    }

    // The same, for the ink of the row rather than its font box (see INK_TRIM_DIVISOR).
    private function farthestInkDy(y as Lang.Number, height as Lang.Number) as Lang.Number {
        var trim = inkTrim(_width, _height);
        return farthestDy(y + trim, height - 2 * trim);
    }

    // A rectangle's ring circle is centered on the taller side: dy is taken from
    // the screen's center (equal to the radius on round and square screens).
    private function farthestDy(y as Lang.Number, height as Lang.Number) as Lang.Number {
        var dyTop = y - centerY();
        var dyBottom = y + height - centerY();
        return dyTop.abs() > dyBottom.abs() ? dyTop : dyBottom;
    }

    // Half-width of the inscribed circle at vertical offset `dy` from its
    // center. Returns 0 at or beyond the top/bottom edge.
    static function chordHalfWidth(radius as Lang.Number, dy as Lang.Number) as Lang.Number {
        var inside = radius * radius - dy * dy;
        if (inside <= 0) {
            return 0;
        }
        return Math.sqrt(inside).toNumber();
    }
}
