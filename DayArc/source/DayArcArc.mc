import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// The window-progress arc (ADR-013): a thin arc across the top of the circle in the window's
// accent, progress through the CURRENT window only — deliberately not TwoSuns's full 24h ring.
// It hugs the bezel at a FIXED radius, and everything else clears it: rows that sit up in the arc's
// own band are chord-fitted against the arc's inner edge (rowMaxWidth below) instead of the full
// circle, so "fits its row" also means "clears the arc" for every row, not just the clock's centre.
// (Owner's first wrist photo, 2026-09-28: the arc crowded the clock digits' top corners — the arc
// curves DOWN toward the sides, so the corners, not the apex, are where the two collide.)
class DayArcArc {
    private static const WIDTH_PERMILLE = 18;
    private static const BEZEL_MARGIN_PERMILLE = 20;
    private static const CLEARANCE_PERMILLE = 15;

    static function penWidth(layout as DayArcLayout) as Number {
        var width = layout.permille(WIDTH_PERMILLE);
        return width < 1 ? 1 : width; // setPenWidth(0) throws; only a degenerate tiny Dc gets here
    }

    // Centre line of the stroke, just inside the bezel.
    static function radius(layout as DayArcLayout) as Number {
        return layout.radius() - layout.permille(BEZEL_MARGIN_PERMILLE) - penWidth(layout) / 2;
    }

    // The circle every row up in the arc's band must stay inside: the stroke's inner edge minus a
    // visible gap.
    static function clearRadius(layout as DayArcLayout) as Number {
        return radius(layout) - penWidth(layout) / 2 - layout.permille(CLEARANCE_PERMILLE);
    }

    // Dc.drawArc's convention: 0=3 o'clock, 90=12 o'clock, counter-clockwise positive. The track
    // spans ARC_SPAN_DEGREES centred on 90; the fill runs from the start edge toward the end edge.
    static function startDegrees() as Number {
        return 90 + DayArcConfig.ARC_SPAN_DEGREES / 2;
    }

    static function endDegrees() as Number {
        return 90 - DayArcConfig.ARC_SPAN_DEGREES / 2;
    }

    // Rounds toward startDegrees() at fraction 0 — Dc.drawArc treats equal start/end as a full
    // circle (SDK docs), so draw() skips the fill when this equals startDegrees().
    static function progressEndDegrees(fraction as Float) as Number {
        var clamped = fraction < 0.0 ? 0.0 : (fraction > 1.0 ? 1.0 : fraction);
        return startDegrees() - (DayArcConfig.ARC_SPAN_DEGREES * clamped).toNumber();
    }

    // The lowest y the arc's stroke reaches (its two tips). Below this, nothing can collide with it.
    static function lowestY(layout as DayArcLayout) as Number {
        var tip = radius(layout) * Math.sin(endDegrees() * Math.PI / 180.0);
        return layout.centerY() - tip.toNumber() + penWidth(layout) / 2;
    }

    // rowMaxWidth for an ACTIVE-window row (night and the idle frame have no arc and use the plain
    // layout.rowMaxWidth): a row whose top is above the arc's tips is fitted against clearRadius().
    static function rowMaxWidth(layout as DayArcLayout, y as Number, boxHeight as Number) as Number {
        if (y >= lowestY(layout)) {
            return layout.rowMaxWidth(y, boxHeight);
        }
        return layout.rowMaxWidthIn(clearRadius(layout), y, boxHeight);
    }

    static function draw(dc as Graphics.Dc, layout as DayArcLayout, accent as Number, fraction as Float) as Void {
        var start = startDegrees();
        dc.setPenWidth(penWidth(layout));
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(layout.centerX(), layout.centerY(), radius(layout), Graphics.ARC_CLOCKWISE, start, endDegrees());
        var progressEnd = progressEndDegrees(fraction);
        if (progressEnd != start) {
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(layout.centerX(), layout.centerY(), radius(layout), Graphics.ARC_CLOCKWISE, start, progressEnd);
        }
        dc.setPenWidth(1);
    }
}
