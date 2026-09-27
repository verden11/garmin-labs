import Toybox.Graphics;
import Toybox.Lang;

// Draws the energy curve and the level pill from their plans. Fresh: a white line over a fill, the
// newest point a solid dot in the accent. Stale (newest sample over an hour old): everything muted and the
// dot an outline, so staleness is a shape as well as a colour.
class TwoSunsCurve {

    static function draw(dc as Graphics.Dc, layout as TwoSunsLayout, band as TwoSunsBand, curve as TwoSunsBatteryCurve,
                         stale as Boolean, accent as Number) as Void {
        var dot = layout.dotRadius();
        var plan = TwoSunsCurvePlan.build(curve, band.curveLeft + dot, band.curveTop + dot,
                                          band.curveWidth - 2 * dot, band.curveHeight - 2 * dot);
        dc.setColor(stale ? TwoSunsPalette.CURVE_FILL_STALE : TwoSunsPalette.CURVE_FILL, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < plan.xs.size(); i++) {
            var y = plan.ys[i];
            if (y != null) {
                dc.fillRectangle(plan.xs[i], y, plan.cellWidth(i), plan.bottom - y + 1);
            }
        }
        dc.setPenWidth(layout.pen());
        dc.setColor(stale ? TwoSunsPalette.MUTED : TwoSunsPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < plan.xs.size() - 1; i++) {
            var from = plan.ys[i];
            var to = plan.ys[i + 1];
            if (from != null && to != null) {
                dc.drawLine(plan.xs[i], from, plan.xs[i + 1], to);
            }
        }
        drawDot(dc, plan, stale, accent, dot);
        dc.setPenWidth(1);
    }

    private static function drawDot(dc as Graphics.Dc, plan as TwoSunsCurvePlan, stale as Boolean, accent as Number, dot as Number) as Void {
        var y = plan.lastIndex < 0 ? null : plan.ys[plan.lastIndex];
        if (y == null) {
            return;
        }
        var x = plan.xs[plan.lastIndex];
        dc.setColor(TwoSunsPalette.BACKGROUND, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, dot);
        dc.setColor(stale ? TwoSunsPalette.MUTED : accent, Graphics.COLOR_TRANSPARENT);
        if (stale) {
            dc.drawCircle(x, y, dot);
        } else {
            dc.fillCircle(x, y, dot);
        }
    }

    // A level pill, not a battery: a plain rounded bar, no nub (the nub is what reads as "device battery"
    // on a Garmin face, so it is deliberately left off). Filled left to right to the level in the accent.
    // Hollow (outline only) when there is no number or it is stale.
    static function drawGlyph(dc as Graphics.Dc, layout as TwoSunsLayout, band as TwoSunsBand, level as Number or Null,
                              stale as Boolean, accent as Number) as Void {
        var pen = layout.pen();
        var radius = band.glyphHeight / 2;
        dc.setPenWidth(pen);
        dc.setColor(stale ? TwoSunsPalette.MUTED : TwoSunsPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(band.glyphLeft, band.glyphTop, band.glyphWidth, band.glyphHeight, radius);
        if (level != null && !stale) {
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            var inner = band.glyphWidth - 2 * (pen + 1);
            var filled = inner * level / TwoSunsConfig.BATTERY_MAX;
            // A fill narrower than the radius would draw a rounded rectangle wider than it is tall, which
            // some firmware clamps oddly; a plain rectangle below that width reads the same at this size.
            if (filled >= radius) {
                dc.fillRoundedRectangle(band.glyphLeft + pen + 1, band.glyphTop + pen + 1, filled,
                                        band.glyphHeight - 2 * (pen + 1), radius - pen - 1);
            } else if (filled > 0) {
                dc.fillRectangle(band.glyphLeft + pen + 1, band.glyphTop + pen + 1, filled, band.glyphHeight - 2 * (pen + 1));
            }
        }
        dc.setPenWidth(1);
    }
}
