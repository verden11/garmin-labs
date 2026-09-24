import Toybox.Graphics;
import Toybox.Lang;

// HeroSet's bezel ring: grey track, then the fill clockwise from lower left.
class HeroFaceRing {

    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, permille as Number, color as Number) as Void {
        dc.setPenWidth(layout.ringWidth());
        arc(dc, layout, HeroFacePalette.TRACK, HeroFaceLayout.RING_SWEEP_DEG);
        var sweep = HeroFaceLayout.ringSweepFor(permille);
        if (sweep > 0) {
            arc(dc, layout, color, sweep);
        }
        dc.setPenWidth(1);
    }

    private static function arc(dc as Graphics.Dc, layout as HeroFaceLayout, color as Number, sweep as Number) as Void {
        var start = HeroFaceLayout.RING_START_DEG;
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(layout.centerX(), layout.centerY(), layout.ringRadius(), Graphics.ARC_CLOCKWISE, start, HeroFaceLayout.arcEndDegree(start, sweep));
    }
}
