import Toybox.Graphics;
import Toybox.Lang;

// Draws the energy curve and the Body Battery glyph from their plans. Fresh: a white line with no fill (the fill was
// the night ring's #5555AA and read as part of the sky; design critique 2026-10-05, ROADMAP 13.15), the newest point a
// solid dot in the accent. Stale (newest sample over an hour old): everything muted and the
// dot an outline, so staleness is a shape as well as a colour.
class TwoSunsCurve {

    // The curve is Pro only (docs/decisions.md ADR-020, Free + Pro ladder); the level pill below is in both tiers.
    (:pro)
    static function draw(dc as Graphics.Dc, layout as TwoSunsLayout, band as TwoSunsBand, curve as TwoSunsBatteryCurve,
                         stale as Boolean, accent as Number) as Void {
        var dot = layout.dotRadius();
        var plan = TwoSunsCurvePlan.build(curve, band.curveLeft + dot, band.curveTop + dot,
                                          band.curveWidth - 2 * dot, band.curveHeight - 2 * dot);
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

    // The Body Battery glyph: a bolt (docs/decisions.md ADR-023, replacing the level pill of ADR-017, which beside the
    // watch battery row read as a second battery). Solid in the current battery colour since 2026-10-05 (ROADMAP 13.16:
    // the half-grey gauge read as "broken", and the number beside it already says the level). Hollow (a muted outline,
    // no fill) when there is no number or it is stale. Its points are thousandths of the glyph height; the box is 0.6 as wide as tall.
    private static const OUTLINE_PEN_DIVISOR = 20;   // a rectangle's hollow bolt stroke, a share of the bolt's height
    private static const BOLT = [[470, 0], [10, 580], [270, 580], [90, 1000], [590, 380], [330, 380]] as Array<Array<Number>>;

    static function drawGlyph(dc as Graphics.Dc, layout as TwoSunsLayout, band as TwoSunsBand, level as Number or Null,
                              stale as Boolean, accent as Number) as Void {
        var points = [] as Array<[Numeric, Numeric]>;
        for (var i = 0; i < BOLT.size(); i++) {
            points.add([band.glyphLeft + band.glyphHeight * BOLT[i][0] / TwoSunsConfig.PERMILLE,
                        band.glyphTop + band.glyphHeight * BOLT[i][1] / TwoSunsConfig.PERMILLE] as [Numeric, Numeric]);
        }
        if (level == null || stale) {
            dc.setPenWidth(outlinePen(layout, band));
            dc.setColor(TwoSunsPalette.MUTED, Graphics.COLOR_TRANSPARENT);
            for (var i = 0; i < points.size(); i++) {
                var next = points[(i + 1) % points.size()];
                dc.drawLine(points[i][0], points[i][1], next[0], next[1]);
            }
            dc.setPenWidth(1);
            return;
        }
        dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(points);
    }

    // The hollow bolt's stroke: the round pen; on a rectangle, where the bolt grows with the time, a twentieth of its height
    // when that is more, so a large hollow bolt is not a hairline (docs/decisions.md ADR-028).
    private static function outlinePen(layout as TwoSunsLayout, band as TwoSunsBand) as Number {
        var scaled = band.glyphHeight / OUTLINE_PEN_DIVISOR;
        return layout.track() != null && scaled > layout.pen() ? scaled : layout.pen();
    }
}
