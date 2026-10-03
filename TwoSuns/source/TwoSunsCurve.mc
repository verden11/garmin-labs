import Toybox.Graphics;
import Toybox.Lang;

// Draws the energy curve and the level pill from their plans. Fresh: a white line over a fill, the
// newest point a solid dot in the accent. Stale (newest sample over an hour old): everything muted and the
// dot an outline, so staleness is a shape as well as a colour.
class TwoSunsCurve {

    // The curve is Pro only (docs/decisions.md ADR-020, Free + Pro ladder); the level pill below is in both tiers.
    (:pro)
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
    (:pro)
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

    // The Body Battery glyph: a bolt gauge (docs/decisions.md ADR-023, replacing the level pill of ADR-017, which beside
    // the watch battery row read as a second battery). A dim bolt, filled from the bottom to the level in the accent
    // (a clip over the lower part of the box, so the fill follows the bolt's own edges). Hollow (a muted outline, no fill)
    // when there is no number or it is stale. Its points are thousandths of the glyph height; the box is 0.6 as wide as tall.
    private static const BOLT = [[470, 0], [10, 580], [270, 580], [90, 1000], [590, 380], [330, 380]] as Array<Array<Number>>;

    static function drawGlyph(dc as Graphics.Dc, layout as TwoSunsLayout, band as TwoSunsBand, level as Number or Null,
                              stale as Boolean, accent as Number) as Void {
        var points = [] as Array<[Numeric, Numeric]>;
        for (var i = 0; i < BOLT.size(); i++) {
            points.add([band.glyphLeft + band.glyphHeight * BOLT[i][0] / TwoSunsConfig.PERMILLE,
                        band.glyphTop + band.glyphHeight * BOLT[i][1] / TwoSunsConfig.PERMILLE] as [Numeric, Numeric]);
        }
        if (level == null || stale) {
            dc.setPenWidth(layout.pen());
            dc.setColor(TwoSunsPalette.MUTED, Graphics.COLOR_TRANSPARENT);
            for (var i = 0; i < points.size(); i++) {
                var next = points[(i + 1) % points.size()];
                dc.drawLine(points[i][0], points[i][1], next[0], next[1]);
            }
            dc.setPenWidth(1);
            return;
        }
        dc.setColor(TwoSunsPalette.TRACK, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(points);
        var filled = band.glyphHeight * level / TwoSunsConfig.BATTERY_MAX;
        if (filled > 0) {
            dc.setClip(band.glyphLeft, band.glyphTop + band.glyphHeight - filled, band.glyphWidth, filled);
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            dc.fillPolygon(points);
            dc.clearClip();
        }
    }
}
