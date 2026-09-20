import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

// Single place that answers every view's geometry questions: band positions,
// footer rows, and per-row side insets. On round displays the usable width at
// a row is the inscribed-circle chord at that y, so top/bottom rows get more
// inset than the center row; square displays degrade to a constant inset.
class HeroSetLayout {

    // Dashboard XP ring (ADR-031), in Dc.drawArc degrees (0 = 3 o'clock,
    // counterclockwise). It starts at lower left and runs clockwise over the
    // top, leaving a 100-degree gap at the bottom for the footer text.
    static const RING_START_DEG = 220;
    static const RING_SWEEP_DEG = 260;
    private static const FULL_CIRCLE_DEG = 360;

    private var _width;
    private var _height;
    private var _centerX;
    private var _radius;
    private var _round;

    function initialize(dc as Graphics.Dc) {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _centerX = _width / 2;
        _radius = (_width < _height ? _width : _height) / 2;
        _round = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND;
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
        return shortInset() / 2;
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

    // Same chord as leftInset/rightInset, against a smaller concentric circle
    // (e.g. contentRadius inside the dashboard ring).
    function leftInsetWithin(radius as Lang.Number, y as Lang.Number, height as Lang.Number) as Lang.Number {
        if (!_round) {
            return shortInset();
        }
        return _centerX - HeroSetLayout.chordHalfWidth(radius, farthestDy(y, height));
    }

    function rightInsetWithin(radius as Lang.Number, y as Lang.Number, height as Lang.Number) as Lang.Number {
        if (!_round) {
            return _width - shortInset();
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
    private function farthestDy(y as Lang.Number, height as Lang.Number) as Lang.Number {
        var dyTop = y - _radius;
        var dyBottom = y + height - _radius;
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
