import Toybox.Graphics;
import Toybox.Lang;

// HeroSet's bezel ring: grey track, then the fill clockwise from lower left. On a rectangle it follows the screen's
// edges (ADR-005); on the Instinct it is a gauge in the window (ADR-002).
class HeroFaceRing {

    // Rectangle corners, in drawArc degrees (0 at 3 o'clock, counter-clockwise).
    private static const LEFT_DEG = 180;
    private static const TOP_DEG = 90;
    private static const QUARTER_DEG = 90;

    static function draw(dc as Graphics.Dc, layout as HeroFaceLayout, permille as Number, color as Number) as Void {
        var window = layout.windowRing();
        if (window != null) {
            drawWindow(dc, window, permille, color);
            return;
        }
        dc.setPenWidth(layout.ringWidth());
        var box = layout.frame();
        if (box != null) {
            frame(dc, layout, box, HeroFacePalette.TRACK, box.length());
            var fill = box.fillFor(permille);
            if (fill > 0) {
                frame(dc, layout, box, color, fill);
            }
            dc.setPenWidth(1);
            return;
        }
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

    // The rectangle's form of the ring (ADR-005): the first `length` px of an open-bottom rounded rectangle, up the
    // left side from its lower end, over the top, down the right side, so it fills clockwise like the round ring and
    // leaves the bottom edge to the footer. Straight runs are filled boxes (no pen caps to seam), corners are arcs.
    private static function frame(dc as Graphics.Dc, layout as HeroFaceLayout, box as HeroFaceFrame, color as Number, length as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var b = box.box();
        var w = layout.ringWidth();
        var arcLength = HeroFaceFrame.quarterArc(b[4]);
        var side = b[3] - b[1] - b[4];
        var top = b[2] - b[0] - 2 * b[4];
        var run = length < side ? length : side;
        dc.fillRectangle(b[0] - w / 2, b[3] - run, w, run);
        length -= side;
        if (length > 0) {
            drawCorner(dc, b[0] + b[4], b[1] + b[4], b[4], LEFT_DEG, length, arcLength);
        }
        length -= arcLength;
        if (length > 0) {
            dc.fillRectangle(b[0] + b[4], b[1] - w / 2, length < top ? length : top, w);
        }
        length -= top;
        if (length > 0) {
            drawCorner(dc, b[2] - b[4], b[1] + b[4], b[4], TOP_DEG, length, arcLength);
        }
        length -= arcLength;
        if (length > 0) {
            dc.fillRectangle(b[2] - w / 2, b[1] + b[4], w, length < side ? length : side);
        }
    }

    // A quarter circle clockwise from `start`, cut to `length` px of its `full` length (at least a degree).
    private static function drawCorner(dc as Graphics.Dc, x as Number, y as Number, radius as Number, start as Number, length as Number, full as Number) as Void {
        var sweep = (length < full ? length : full) * QUARTER_DEG / full;
        dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, start, HeroFaceLayout.arcEndDegree(start, sweep < 1 ? 1 : sweep));
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
