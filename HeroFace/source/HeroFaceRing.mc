import Toybox.Graphics;
import Toybox.Lang;

// HeroSet's bezel ring: grey track, then the fill clockwise from lower left.
class HeroFaceRing {

    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, permille as Number, color as Number) as Void {
        var window = layout.windowRing();
        if (window != null) {
            drawWindow(dc, window, permille, color);
            return;
        }
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

    // The Instinct's form of the ring (ADR-002): a hairline circle in the window with a thick fill inside it, from
    // 12 o'clock clockwise, closed when everything is done. White both: the outline under a solid fill tells them apart.
    private static function drawWindow(dc as Graphics.Dc, window as [Number, Number, Number, Number], permille as Number, color as Number) as Void {
        dc.setColor(HeroFacePalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawCircle(window[0], window[1], window[2]);
        var sweep = HeroFaceLayout.windowSweepFor(permille);
        if (sweep <= 0) {
            return;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(window[3]);
        if (sweep >= HeroFaceLayout.FULL_CIRCLE_DEG) {
            dc.drawCircle(window[0], window[1], window[2] - window[3] / 2);
        } else {
            dc.drawArc(window[0], window[1], window[2] - window[3] / 2, Graphics.ARC_CLOCKWISE, HeroFaceLayout.WINDOW_START_DEG, HeroFaceLayout.arcEndDegree(HeroFaceLayout.WINDOW_START_DEG, sweep));
        }
        dc.setPenWidth(1);
    }
}
