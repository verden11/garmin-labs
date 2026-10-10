import Toybox.Graphics;
import Toybox.Lang;

// The state as a shape, drawn from primitives (no bitmap: the 32 KB Instinct glance has no budget for one). A sill bar and
// a disc: filled above the bar = OPEN, outline above = CLOSED, outline below = NONE TODAY. White, never the accent: on the
// glance it sits on the system's themed card, and on the Instinct it is the only colour there is.
(:glance)
class SunWindowMark {
    // Pen width as a fraction of the mark's size, and the disc radius likewise (percent).
    static const PEN_DIVISOR = 12;
    static const MIN_PEN = 2;
    static const DISC_PERCENT = 28;
    static const GAP_PEN_MULTIPLE = 3;   // the disc floats this many half-pens off the bar

    // Whether a state draws a mark at all: the empty states do not.
    static function isDrawn(kind as Number) as Boolean {
        return kind <= SunWindowConfig.STATE_NONE_TODAY;
    }

    // Centred on (cx, cy), the bar's line; `size` is the bar's length.
    static function draw(dc as Dc, cx as Number, cy as Number, size as Number, kind as Number) as Void {
        var pen = size / PEN_DIVISOR < MIN_PEN ? MIN_PEN : size / PEN_DIVISOR;
        var radius = size * DISC_PERCENT / SunWindowConfig.PERCENT;
        var offset = radius + pen * GAP_PEN_MULTIPLE / 2;
        dc.setColor(SunWindowPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen);
        dc.drawLine(cx - size / 2, cy, cx + size / 2, cy);
        if (kind == SunWindowConfig.STATE_OPEN) {
            dc.fillCircle(cx, cy - offset, radius);
        } else if (kind == SunWindowConfig.STATE_NONE_TODAY) {
            dc.drawCircle(cx, cy + offset, radius - pen / 2);
        } else {
            dc.drawCircle(cx, cy - offset, radius - pen / 2);
        }
        dc.setPenWidth(1);
    }
}
