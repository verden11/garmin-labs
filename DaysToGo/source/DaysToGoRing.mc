import Toybox.Graphics;
import Toybox.Lang;

// The bezel band (ADR-021): a hairline grey track all round, and the accent band clockwise from
// the top for the share of the wait still to go. On a rectangle the ring is a
// rounded-rectangle track along the screen's edges (DaysToGoTrack, ADR-019).
class DaysToGoRing {
    static const RING_START_DEG = 90;
    static const FULL_CIRCLE_DEG = 360;
    private static const MIN_SWEEP_DEG = 1;
    // The rectangle's corners start at these drawArc angles (0 at 3 o'clock, counter-clockwise), a quarter circle each.
    private static const RIGHT_DEG = 0;
    private static const LEFT_DEG = 180;
    private static const BOTTOM_DEG = 270;
    private static const QUARTER_DEG = 90;

    // Degrees of the ring to draw for a 0 to 1000 share. Any progress shows at
    // least a degree; a full share is a full circle.
    static function ringSweepFor(permille as Number) as Number {
        if (permille <= 0) {
            return 0;
        }
        if (permille >= DaysToGoConfig.PERMILLE) {
            return FULL_CIRCLE_DEG;
        }
        var sweep = FULL_CIRCLE_DEG * permille / DaysToGoConfig.PERMILLE;
        return sweep < MIN_SWEEP_DEG ? MIN_SWEEP_DEG : sweep;
    }

    static function arcEndDegree(startDeg as Number, sweepDeg as Number) as Number {
        var end = (startDeg - sweepDeg) % FULL_CIRCLE_DEG;
        return end < 0 ? end + FULL_CIRCLE_DEG : end;
    }

    static function draw(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState) as Void {
        if (!state.ringTrack) {
            return;
        }
        var window = layout.windowRing();
        if (window != null) {
            drawWindow(dc, window, state);
            return;
        }
        var track = layout.track();
        if (track != null) {
            dc.setPenWidth(layout.trackWidth());
            trace(dc, track, DaysToGoPalette.TRACK, track.length(), layout.trackWidth());
            var fill = track.fillFor(state.ringPermille);
            if (fill > 0) {
                dc.setPenWidth(layout.bandWidth());
                trace(dc, track, state.accent, fill, layout.bandWidth());
            }
            dc.setPenWidth(1);
            return;
        }
        // A hairline all round, and the band over it for the share still to go, butt ends (ADR-021).
        dc.setPenWidth(layout.trackWidth());
        dc.setColor(DaysToGoPalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(layout.centerX(), layout.centerY(), layout.ringRadius());
        var sweep = ringSweepFor(state.ringPermille);
        if (sweep > 0) {
            dc.setPenWidth(layout.bandWidth());
            dc.setColor(state.accent, Graphics.COLOR_TRANSPARENT);
            var start = RING_START_DEG;
            if (sweep >= FULL_CIRCLE_DEG) {
                dc.drawCircle(layout.centerX(), layout.centerY(), layout.ringRadius());
            } else {
                dc.drawArc(layout.centerX(), layout.centerY(), layout.ringRadius(), Graphics.ARC_CLOCKWISE, start, arcEndDegree(start, sweep));
            }
        }
        dc.setPenWidth(1);
    }

    // The Instinct's form of the ring: a hairline circle (the track) with a thick fill inside it, same share and
    // direction, in the window (ADR-015). White both, so the outline under a solid fill is what tells them apart.
    private static function drawWindow(dc as Graphics.Dc, window as [Number, Number, Number, Number], state as DaysToGoState) as Void {
        dc.setColor(DaysToGoPalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawCircle(window[0], window[1], window[2]);
        var sweep = ringSweepFor(state.ringPermille);
        if (sweep <= 0) {
            return;
        }
        dc.setColor(state.accent, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(window[3]);
        if (sweep >= FULL_CIRCLE_DEG) {
            dc.drawCircle(window[0], window[1], window[2] - window[3] / 2);
        } else {
            var start = RING_START_DEG;
            dc.drawArc(window[0], window[1], window[2] - window[3] / 2, Graphics.ARC_CLOCKWISE, start, arcEndDegree(start, sweep));
        }
        dc.setPenWidth(1);
    }

    // The first `length` px of the rectangle's track, clockwise from top centre: four legs (a straight run, then the
    // corner after it), then the top's left half back to the centre. Runs are filled boxes (no pen caps to seam),
    // corners arcs. Returns the px drawn, which the test checks against the length asked.
    static function trace(dc as Graphics.Dc, track as DaysToGoTrack, color as Number, length as Number, width as Number) as Number {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var b = track.box();
        var r = b[4];
        var cx = (b[0] + b[2]) / 2;
        var across = b[2] - b[0] - 2 * r;
        var down = b[3] - b[1] - 2 * r;
        // [run start x, y, direction x, y, run length, corner centre x, y, corner start in drawArc degrees]
        var legs = [[cx, b[1], 1, 0, b[2] - r - cx, b[2] - r, b[1] + r, RING_START_DEG],
                    [b[2], b[1] + r, 0, 1, down, b[2] - r, b[3] - r, RIGHT_DEG],
                    [b[2] - r, b[3], -1, 0, across, b[0] + r, b[3] - r, BOTTOM_DEG],
                    [b[0], b[3] - r, 0, -1, down, b[0] + r, b[1] + r, LEFT_DEG]] as Array<Array<Number>>;
        var left = length;
        for (var i = 0; i < legs.size() && left > 0; i++) {
            var leg = legs[i];
            left -= run(dc, leg[0], leg[1], leg[2], leg[3], leg[4], left, width);
            if (left > 0) {
                left -= corner(dc, leg[5], leg[6], r, leg[7], left);
            }
        }
        left -= run(dc, b[0] + r, b[1], 1, 0, cx - b[0] - r, left, width);
        return length - left;
    }

    // Up to `left` px of a straight run of `full` px from (x, y) in direction (dx, dy), centred on the line. Returns px drawn.
    private static function run(dc as Graphics.Dc, x as Number, y as Number, dx as Number, dy as Number, full as Number,
                                left as Number, width as Number) as Number {
        var px = left < full ? left : full;
        if (px <= 0) {
            return 0;
        }
        var boxX = dx == 0 ? x - width / 2 : (dx > 0 ? x : x - px);
        var boxY = dy == 0 ? y - width / 2 : (dy > 0 ? y : y - px);
        dc.fillRectangle(boxX, boxY, dx == 0 ? width : px, dy == 0 ? width : px);
        return px;
    }

    // Up to `left` px of a quarter circle clockwise from `start` (at least a degree). Returns px drawn. The arc runs a degree
    // into the straight run before it (and after it, when whole): its anti-aliased ends drew a dark seam at the joins.
    private static function corner(dc as Graphics.Dc, x as Number, y as Number, radius as Number, start as Number, left as Number) as Number {
        var full = DaysToGoTrack.quarterArc(radius);
        var px = left < full ? left : full;
        var sweep = px * QUARTER_DEG / full;
        sweep = (sweep < MIN_SWEEP_DEG ? MIN_SWEEP_DEG : sweep) + MIN_SWEEP_DEG + (px >= full ? MIN_SWEEP_DEG : 0);
        var from = (start + MIN_SWEEP_DEG) % FULL_CIRCLE_DEG;
        dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, from, arcEndDegree(from, sweep));
        return px;
    }
}
