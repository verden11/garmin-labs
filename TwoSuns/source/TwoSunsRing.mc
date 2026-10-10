import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// The sky ring around the bezel: a dim night track all round, twilight, daylight (still to come bright,
// already gone dimmer), the golden hour, ticks at sunrise and sunset, and the sun at the current time
// (solid while it is up, an outline while it is not: the state is never colour alone). On a rectangle every layer
// lies on the rounded-rectangle track instead of the circle (TwoSunsTrack, docs/decisions.md ADR-028, the rectangle track).
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
        drawNight(dc, layout, cx, cy, radius);
        for (var i = 0; i < plan.arcs.size(); i++) {
            var arc = plan.arcs[i];
            dc.setPenWidth(TwoSunsPalette.MONO && (arc.kind == TwoSunsConfig.RING_TWILIGHT || arc.kind == TwoSunsConfig.RING_DAY_GONE) ? 1 : layout.ringWidth());
            dc.setColor(colorFor(arc.kind, state.accent), Graphics.COLOR_TRANSPARENT);
            drawStretchOrArc(dc, layout, cx, cy, radius, arc, state.orientation);
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

    // How far the sun marker and its black halo reach from the ring's centreline, for a ring `width` px wide.
    static function markerReach(width as Number) as Number {
        return width * MARKER_PERMILLE / TwoSunsConfig.PERMILLE + OUTLINE_PEN;
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

    // The night track, all round: the circle, or on a rectangle the whole track.
    (:rect)
    private static function drawNight(dc as Graphics.Dc, layout as TwoSunsLayout, cx as Number, cy as Number, radius as Number) as Void {
        var track = layout.track();
        if (track != null) {
            track.drawSpan(dc, 0.0, track.length(), layout.ringWidth());
        } else {
            dc.drawCircle(cx, cy, radius);
        }
    }

    (:norect)
    private static function drawNight(dc as Graphics.Dc, layout as TwoSunsLayout, cx as Number, cy as Number, radius as Number) as Void {
        dc.drawCircle(cx, cy, radius);
    }

    (:rect)
    private static function drawStretchOrArc(dc as Graphics.Dc, layout as TwoSunsLayout, cx as Number, cy as Number, radius as Number,
                                             arc as TwoSunsRingArc, orientation as Number) as Void {
        var track = layout.track();
        if (track != null) {
            drawStretch(dc, track, layout.ringWidth(), arc, orientation);
        } else {
            drawArc(dc, cx, cy, radius, arc, orientation);
        }
    }

    (:norect)
    private static function drawStretchOrArc(dc as Graphics.Dc, layout as TwoSunsLayout, cx as Number, cy as Number, radius as Number,
                                             arc as TwoSunsRingArc, orientation as Number) as Void {
        drawArc(dc, cx, cy, radius, arc, orientation);
    }

    // A stretch of the day on the rectangle's track: the same share of its length as of the day (ADR-028).
    (:rect)
    private static function drawStretch(dc as Graphics.Dc, track as TwoSunsTrack, pen as Number, arc as TwoSunsRingArc, orientation as Number) as Void {
        var from = track.distanceFor(arc.from, orientation);
        var span = (arc.to - arc.from) * track.length() / TwoSunsConfig.MINUTES_PER_DAY;
        track.drawSpan(dc, from, from + (span < 1.0 ? 1.0 : span), pen);   // a stretch under a pixel still shows
    }

    // The point at a minute of the ring, `offset` px outward from the ring's centreline (negative: inward): on the
    // circle of the ring, or across the rectangle's track.
    (:rect)
    private static function pointAt(layout as TwoSunsLayout, offset as Number, minute as Number, orientation as Number) as Array<Number> {
        var track = layout.track();
        if (track != null) {
            var at = track.pointAt(track.distanceFor(minute, orientation), offset.toFloat());
            return [Math.round(at[0]).toNumber(), Math.round(at[1]).toNumber()] as Array<Number>;
        }
        return circlePointAt(layout, offset, minute, orientation);
    }

    (:norect)
    private static function pointAt(layout as TwoSunsLayout, offset as Number, minute as Number, orientation as Number) as Array<Number> {
        return circlePointAt(layout, offset, minute, orientation);
    }

    private static function circlePointAt(layout as TwoSunsLayout, offset as Number, minute as Number, orientation as Number) as Array<Number> {
        var radius = layout.ringRadius() + offset;
        var angle = TwoSunsRingPlan.angleFor(minute, orientation) * Math.PI / TwoSunsConfig.DEGREES_PER_HALF_TURN;
        return [layout.ringCenterX() + (radius * Math.cos(angle)).toNumber(), layout.ringCenterY() - (radius * Math.sin(angle)).toNumber()] as Array<Number>;
    }

    private static function drawTick(dc as Graphics.Dc, layout as TwoSunsLayout, minute as Number, orientation as Number) as Void {
        var half = layout.ringWidth() / 2;
        var inner = pointAt(layout, -half - layout.ringWidth() * TICK_INSET_PERMILLE / TwoSunsConfig.PERMILLE, minute, orientation);
        var outer = pointAt(layout, half, minute, orientation);
        dc.drawLine(inner[0], inner[1], outer[0], outer[1]);
    }

    private static function drawMarker(dc as Graphics.Dc, layout as TwoSunsLayout, minute as Number, sunUp as Boolean, orientation as Number) as Void {
        var at = pointAt(layout, 0, minute, orientation);
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
