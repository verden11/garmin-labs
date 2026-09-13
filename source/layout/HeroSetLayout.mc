import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

// Single place that answers every view's geometry questions: band positions,
// footer rows, and per-row side insets. On round displays the usable width at
// a row is the inscribed-circle chord at that y, so top/bottom rows get more
// inset than the center row; square displays degrade to a constant inset.
class HeroSetLayout {

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

    function width() as Lang.Number {
        return _width;
    }

    function height() as Lang.Number {
        return _height;
    }

    function centerX() as Lang.Number {
        return _centerX;
    }

    function isRound() as Lang.Boolean {
        return _round;
    }

    function shortInset() as Lang.Number {
        return (_width < _height ? _width : _height) / 10;
    }

    // Vertical step between stacked content bands.
    function bandStep() as Lang.Number {
        return shortInset() + shortInset() / 5;
    }

    // Top-left y of a centered content band (band 0 = first row under the
    // top inset).
    function bandTop(band as Lang.Number) as Lang.Number {
        return shortInset() + bandStep() * band;
    }

    // Footer rows: two stacked lines kept inside the bottom safe inset.
    // The upper line is footerRowTop(), the lower line footerRowBottom().
    function footerRowTop() as Lang.Number {
        return _height - shortInset() * 2;
    }

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
        if (!_round) {
            return shortInset();
        }
        return _centerX - HeroSetLayout.chordHalfWidth(_radius, farthestDy(y, height));
    }

    function rightInset(y as Lang.Number, height as Lang.Number) as Lang.Number {
        if (!_round) {
            return _width - shortInset();
        }
        return _centerX + HeroSetLayout.chordHalfWidth(_radius, farthestDy(y, height));
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
