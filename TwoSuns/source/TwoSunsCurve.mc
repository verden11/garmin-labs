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
        drawDot(dc, layout, plan, stale, accent, dot);
        dc.setPenWidth(1);
    }

    // The dot's background "halo" needs to be wider than the dot itself, or it draws exactly the same
    // circle the accent fill draws next and leaves no visible margin — with the winter accent (white)
    // over the fresh-state line (also TEXT/white), that made the dot invisible: caught by
    // watch-design-reviewer, 2026-09-27.
    private static function drawDot(dc as Graphics.Dc, layout as TwoSunsLayout, plan as TwoSunsCurvePlan, stale as Boolean, accent as Number, dot as Number) as Void {
        var y = plan.lastIndex < 0 ? null : plan.ys[plan.lastIndex];
        if (y == null) {
            return;
        }
        var x = plan.xs[plan.lastIndex];
        dc.setColor(TwoSunsPalette.BACKGROUND, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, dot + layout.pen());
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
            // A square-edged fill inside the rounded outline reads as a level, the standard battery/
            // progress idiom. Rounding the fill's own leading edge (the old behaviour, matching the
            // outline's corners once the fill was wide enough) made a mid-level reading look like a
            // toggle-switch thumb floating in a track — caught from a real screenshot, owner, 2026-09-27.
            if (filled > 0) {
                dc.fillRectangle(band.glyphLeft + pen + 1, band.glyphTop + pen + 1, filled, band.glyphHeight - 2 * (pen + 1));
            }
        }
        dc.setPenWidth(1);
    }
}
