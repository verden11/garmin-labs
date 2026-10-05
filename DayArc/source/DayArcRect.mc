import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// The rectangle's own shapes (ADR-019; Venu Sq 2, Sq 2 Music, Venu X1): a square watch gets a square design, not the round
// one dropped in. The window-progress arc becomes the upper part of a rounded-rectangle TRACK that follows the glass, inset
// from the edge as the round arc is from the bezel (same stroke, same inset: DayArcArc.radius), spanning the same share of
// its path as the round arc spans of its circle (ARC_SPAN_DEGREES of 360), filled clockwise from the left side. Every row
// fits the INNER box (the track's inner edge minus the arc's clearance, its corners rounded concentrically), and the hero
// gauge is a straight pill bar. Round and Instinct products never reach this class (DayArcLayout.isRectangle).
// The corner radius idea is HeroFace's frame (copied, not linked): large enough to clear the glass, one proportion per size.
class DayArcRect {
    // The track's centreline corner radius, 0.12 of the short side: 53 px on the Venu X1, whose glass corner measures about
    // 60 px off the SDK skin's alpha (a superellipse, so a concentric circle keeps ~10 px of black outside the stroke all
    // round the corner); 38 px on the Venu Sq 2 (its skin's glass corner is ~8 px), the same proportion.
    private static const CORNER_PERMILLE = 120;
    private static const SEGMENTS = 5;   // left side, top-left corner, top, top-right corner, right side
    private static const DEGREES_PER_QUARTER = 90;
    private static const FULL_CIRCLE_DEGREES = 360;
    // Extra room between a row and the track's SIDES (on top of the arc's own clearance): Pro's corner pills sit beside the
    // side runs, and a grey pill outline 6 px from the grey track read as touching it (Venu X1 screenshot, 2026-10-05).
    private static const SIDE_CLEARANCE_PERMILLE = 15;

    // The track's centreline inset from the screen edge: what the round arc's centreline is in from the bezel.
    static function inset(layout as DayArcLayout) as Number {
        return layout.radius() - DayArcArc.radius(layout);
    }

    static function corner(layout as DayArcLayout) as Number {
        return layout.permille(CORNER_PERMILLE);
    }

    // The inner box every row stays inside: the stroke's inner edge plus the arc's own clearance (DayArcArc.clearRadius).
    static function innerInset(layout as DayArcLayout) as Number {
        return layout.radius() - DayArcArc.clearRadius(layout);
    }

    // The inner box's corner radius, concentric with the track's.
    static function innerCorner(layout as DayArcLayout) as Number {
        return DayArcText.max(0, corner(layout) - (innerInset(layout) - inset(layout)));
    }

    // The width a centred row [y, y + height] has inside the inner box and its four rounded corners, kept the side clearance
    // off the track's straight sides; 0 if it pokes out at the top or bottom.
    static function rowWidth(layout as DayArcLayout, y as Number, height as Number) as Number {
        var edge = innerInset(layout);
        var bottom = layout.centerY() * 2 - edge;
        if (y < edge || y + height > bottom) {
            return 0;
        }
        var r = innerCorner(layout);
        var side = edge + layout.permille(SIDE_CLEARANCE_PERMILLE);
        var dyTop = edge + r - y;
        var dyBottom = y + height - (bottom - r);
        var dy = dyTop > dyBottom ? dyTop : dyBottom;
        var intrusion = dy > 0 ? r - DayArcLayout.chordHalfWidth(r, dy) : 0;
        return DayArcText.max(0, layout.centerX() * 2 - 2 * DayArcText.max(side, edge + intrusion));
    }

    // [left side, top-left corner, top, top-right corner, right side] lengths in px along the centreline. The two sides take
    // what is left of the window's length once the top and both corners are counted (0 if the top alone is longer).
    static function segments(layout as DayArcLayout) as Array<Number> {
        var c = inset(layout);
        var r = corner(layout);
        var w = layout.centerX() * 2 - 2 * c;
        var h = layout.centerY() * 2 - 2 * c;
        var quarter = (Math.PI * r / 2).toNumber();
        var perimeter = 2 * (w + h) - 8 * r + 4 * quarter;
        var top = w - 2 * r;
        var side = DayArcText.max(0, (perimeter * DayArcConfig.ARC_SPAN_DEGREES / FULL_CIRCLE_DEGREES - top - 2 * quarter) / 2);
        return [side, quarter, top, quarter, side] as Array<Number>;
    }

    static function length(layout as DayArcLayout) as Number {
        var s = segments(layout);
        return s[0] + s[1] + s[2] + s[3] + s[4];
    }

    // The y where the window's two tips end, the stroke included: the lowest pixel of the track.
    static function lowestY(layout as DayArcLayout) as Number {
        return inset(layout) + corner(layout) + segments(layout)[0];
    }

    // Track in the arc's grey, then the accent over the first `fraction` of it: a share of the window is the same share of
    // the path's length (DayArcArc.draw on a round product).
    static function drawArc(dc as Graphics.Dc, layout as DayArcLayout, accent as Number, fraction as Float) as Void {
        var total = length(layout);
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        drawSpan(dc, layout, 0, total);
        var clamped = fraction < 0.0 ? 0.0 : (fraction > 1.0 ? 1.0 : fraction);
        var fill = (total * clamped).toNumber();
        if (fill > 0) {
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            drawSpan(dc, layout, 0, fill);
        }
        dc.setPenWidth(1);
    }

    // The path from `from` to `to` px along the window, segment by segment.
    private static function drawSpan(dc as Graphics.Dc, layout as DayArcLayout, from as Number, to as Number) as Void {
        var s = segments(layout);
        var start = 0;
        for (var i = 0; i < SEGMENTS; i++) {
            var a = DayArcText.max(from, start) - start;
            var b = DayArcText.min(to, start + s[i]) - start;
            if (b > a) {
                drawPiece(dc, layout, i, a, b, s[0]);
            }
            start += s[i];
        }
    }

    // Px a..b of segment `index`: the straight runs are filled rectangles one pen wide on the centreline, the corners arcs
    // of the same pen (drawArc's butt ends meet the rectangles' square ends at the tangent points).
    private static function drawPiece(dc as Graphics.Dc, layout as DayArcLayout, index as Number, a as Number, b as Number, side as Number) as Void {
        var pen = DayArcArc.penWidth(layout);
        var c = inset(layout);
        var r = corner(layout);
        var right = layout.centerX() * 2 - c;
        var low = c - pen / 2;
        if (index == 0) {
            dc.fillRectangle(low, c + r + side - b, pen, b - a);
        } else if (index == 2) {
            dc.fillRectangle(c + r + a, low, b - a, pen);
        } else if (index == 4) {
            dc.fillRectangle(right - pen / 2, c + r + a, pen, b - a);
        } else {
            var startDeg = (index == 1 ? 2 : 1) * DEGREES_PER_QUARTER - degrees(a, r);
            var endDeg = (index == 1 ? 2 : 1) * DEGREES_PER_QUARTER - degrees(b, r);
            if (endDeg != startDeg) {   // equal start/end draws a whole circle (SDK)
                dc.setPenWidth(pen);
                dc.drawArc(index == 1 ? c + r : right - r, c + r, r, Graphics.ARC_CLOCKWISE, startDeg, endDeg);
                dc.setPenWidth(1);
            }
        }
    }

    private static function degrees(px as Number, r as Number) as Number {
        return Math.round(Math.toDegrees(px.toFloat() / r)).toNumber();
    }

    // The straight bar's top in a gauge row: the row keeps the round gauge's height (the smile's depth included, so a plan
    // budgets the same row on every shape) and the bar sits in its middle, as much air above it as below.
    static function gaugeTop(layout as DayArcLayout, rowTop as Number) as Number {
        return rowTop + layout.gaugeSag() / 2;
    }

    // The straight gauge bar's [left, width]: the round gauge's width (DayArcLayout.gaugeMaxWidth), capped by the inner box.
    static function gaugeBox(layout as DayArcLayout, top as Number) as [Number, Number] {
        var padded = layout.gaugeMaxWidth();
        var room = rowWidth(layout, top, layout.gaugeHeight());
        var width = padded < room ? padded : room;
        return [layout.centerX() - width / 2, width];
    }

    // A straight pill bar: the track in the arc's grey, the fill from the left in the accent, round ends. Single hue, no
    // threshold (ADR-006); `value` clamped to [0, max] as on the round gauge.
    static function drawGauge(dc as Graphics.Dc, layout as DayArcLayout, top as Number, value as Number, max as Number, accent as Number) as Void {
        var pen = layout.gaugeHeight();
        top = gaugeTop(layout, top);
        var box = gaugeBox(layout, top);
        if (box[1] < pen) {
            return;
        }
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(box[0], top, box[1], pen, pen / 2);
        var clamped = value < 0 ? 0 : (value > max ? max : value);
        if (clamped > 0) {
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(box[0], top, pen + (box[1] - pen) * clamped / max, pen, pen / 2);
        }
    }
}
