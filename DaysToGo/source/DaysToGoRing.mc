import Toybox.Graphics;
import Toybox.Lang;

// The bezel ring: a grey track all round, and the accent arc clockwise from
// the top for the share of the wait still to go.
class DaysToGoRing {

    static function draw(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState) as Void {
        if (!state.ringTrack) {
            return;
        }
        var window = layout.windowRing();
        if (window != null) {
            drawWindow(dc, window, state);
            return;
        }
        dc.setPenWidth(layout.ringWidth());
        dc.setColor(DaysToGoPalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(layout.centerX(), layout.centerY(), layout.ringRadius());
        var sweep = DaysToGoLayout.ringSweepFor(state.ringPermille);
        if (sweep > 0) {
            dc.setColor(state.accent, Graphics.COLOR_TRANSPARENT);
            var start = DaysToGoLayout.RING_START_DEG;
            if (sweep >= DaysToGoLayout.FULL_CIRCLE_DEG) {
                dc.drawCircle(layout.centerX(), layout.centerY(), layout.ringRadius());
            } else {
                dc.drawArc(layout.centerX(), layout.centerY(), layout.ringRadius(), Graphics.ARC_CLOCKWISE, start, DaysToGoLayout.arcEndDegree(start, sweep));
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
        var sweep = DaysToGoLayout.ringSweepFor(state.ringPermille);
        if (sweep <= 0) {
            return;
        }
        dc.setColor(state.accent, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(window[3]);
        if (sweep >= DaysToGoLayout.FULL_CIRCLE_DEG) {
            dc.drawCircle(window[0], window[1], window[2] - window[3] / 2);
        } else {
            var start = DaysToGoLayout.RING_START_DEG;
            dc.drawArc(window[0], window[1], window[2] - window[3] / 2, Graphics.ARC_CLOCKWISE, start, DaysToGoLayout.arcEndDegree(start, sweep));
        }
        dc.setPenWidth(1);
    }
}
