import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// The sky ring around the bezel: a dim night track all round, twilight, daylight (still to come bright,
// already gone dimmer), the golden hour, ticks at sunrise and sunset, and the sun at the current time
// (solid while it is up, an outline while it is not: the state is never colour alone).
class TwoSunsRing {
    private static const TICK_INSET_PERMILLE = 600;   // a tick reaches this share of the ring width inside the ring
    private static const MARKER_PERMILLE = 900;       // the marker's radius as a share of the ring width
    private static const TICK_PEN = 2;
    private static const OUTLINE_PEN = 2;
    private static const MIN_SWEEP_DEG = 1;

    static function draw(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Void {
        var plan = TwoSunsRingPlan.build(state.sky, state.nowMinute, state.goldenArc);
        var cx = layout.ringCenterX();
        var cy = layout.ringCenterY();
        var radius = layout.ringRadius();
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }
        // On a 1-bit display there is no dim: the night track is a hairline, the daylight still to come is the thick arc,
        // and what is gone or twilight is a hairline over it (ADR-024).
        dc.setPenWidth(TwoSunsPalette.MONO ? 1 : layout.ringWidth());
        dc.setColor(TwoSunsPalette.NIGHT, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, radius);
        for (var i = 0; i < plan.arcs.size(); i++) {
            var arc = plan.arcs[i];
            dc.setPenWidth(TwoSunsPalette.MONO && (arc.kind == TwoSunsConfig.RING_TWILIGHT || arc.kind == TwoSunsConfig.RING_DAY_GONE) ? 1 : layout.ringWidth());
            dc.setColor(colorFor(arc.kind, state.accent), Graphics.COLOR_TRANSPARENT);
            drawArc(dc, cx, cy, radius, arc, state.orientation);
        }
        dc.setPenWidth(TICK_PEN);
        dc.setColor(TwoSunsPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < plan.ticks.size(); i++) {
            drawTick(dc, layout, plan.ticks[i], state.orientation);
        }
        var marker = plan.marker;
        if (marker != null) {
            drawMarker(dc, layout, marker, plan.sunUp, state.orientation);
        }
        dc.setPenWidth(1);
    }

    static function colorFor(kind as Number, accent as Number) as Number {
        if (kind == TwoSunsConfig.RING_TWILIGHT) {
            return TwoSunsPalette.TWILIGHT;
        }
        if (kind == TwoSunsConfig.RING_DAY_GONE) {
            return TwoSunsPalette.dim(accent);
        }
        if (kind == TwoSunsConfig.RING_GOLDEN) {
            return TwoSunsPalette.GOLDEN;
        }
        return accent;
    }

    private static function drawArc(dc as Graphics.Dc, cx as Number, cy as Number, radius as Number, arc as TwoSunsRingArc, orientation as Number) as Void {
        if (arc.to - arc.from >= TwoSunsConfig.MINUTES_PER_DAY) {
            dc.drawCircle(cx, cy, radius);
            return;
        }
        var start = TwoSunsRingPlan.angleFor(arc.from, orientation);
        var end = TwoSunsRingPlan.angleFor(arc.to, orientation);
        if (start == end) {
            end = (start - MIN_SWEEP_DEG + TwoSunsConfig.DEGREES_FULL_TURN) % TwoSunsConfig.DEGREES_FULL_TURN;   // a stretch under a degree still shows
        }
        dc.drawArc(cx, cy, radius, Graphics.ARC_CLOCKWISE, start, end);
    }

    // The point on a circle of `radius` at a minute of the ring.
    private static function pointAt(layout as TwoSunsLayout, radius as Number, minute as Number, orientation as Number) as Array<Number> {
        var angle = TwoSunsRingPlan.angleFor(minute, orientation) * Math.PI / TwoSunsConfig.DEGREES_PER_HALF_TURN;
        return [layout.ringCenterX() + (radius * Math.cos(angle)).toNumber(), layout.ringCenterY() - (radius * Math.sin(angle)).toNumber()] as Array<Number>;
    }

    private static function drawTick(dc as Graphics.Dc, layout as TwoSunsLayout, minute as Number, orientation as Number) as Void {
        var half = layout.ringWidth() / 2;
        var inner = pointAt(layout, layout.ringRadius() - half - layout.ringWidth() * TICK_INSET_PERMILLE / TwoSunsConfig.PERMILLE, minute, orientation);
        var outer = pointAt(layout, layout.ringRadius() + half, minute, orientation);
        dc.drawLine(inner[0], inner[1], outer[0], outer[1]);
    }

    private static function drawMarker(dc as Graphics.Dc, layout as TwoSunsLayout, minute as Number, sunUp as Boolean, orientation as Number) as Void {
        var at = pointAt(layout, layout.ringRadius(), minute, orientation);
        var size = layout.ringWidth() * MARKER_PERMILLE / TwoSunsConfig.PERMILLE;
        dc.setColor(TwoSunsPalette.BACKGROUND, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(at[0], at[1], size + OUTLINE_PEN);
        dc.setColor(TwoSunsPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        if (sunUp) {
            dc.fillCircle(at[0], at[1], size);
        } else {
            dc.setPenWidth(OUTLINE_PEN);
            dc.drawCircle(at[0], at[1], size);
        }
    }
}
