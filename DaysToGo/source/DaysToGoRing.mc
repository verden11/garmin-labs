import Toybox.Graphics;
import Toybox.Lang;

// The bezel ring: a grey track all round, and the accent arc clockwise from
// the top for the share of the wait still to go.
class DaysToGoRing {

    static function draw(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState) as Void {
        if (!state.ringTrack) {
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
}
