import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;

// Renders one active-window frame or one idle/low-power frame. Which fields a Dictionary carries
// (:cells present or not) is the only branch here — Simple vs Pro is a compile-time source
// difference (DayArcFields), never a runtime one, so this class doesn't need to know which build
// it's in. WHERE every row sits, and in which font, is DayArcStack's plan (a measured dry run of the
// whole stack); this class only draws what was planned.
class DayArcDraw {
    private static const GAUGE_BOTTOM_DEGREES = 270; // Dc.drawArc: the bottom of a circle

    static function renderActive(dc as Graphics.Dc, layout as DayArcLayout, window as Number, hero as Dictionary,
                                  clockText as String, windowProgress as Float, plan as DayArcStack) as Void {
        dc.setColor(DayArcPalette.TEXT, DayArcPalette.BACKGROUND);
        dc.clear();
        var night = window == DayArcConfig.WINDOW_NIGHT;
        var accent = night ? DayArcPalette.MUTED : DayArcPalette.accentFor(window, DayArcSettings.accentChoice());
        if (!night) {
            DayArcArc.draw(dc, layout, accent, windowProgress);
        }
        drawHeader(dc, layout, plan, hero, clockText);
        if (night) {
            return;
        }
        drawHeroBlock(dc, layout, plan, hero, accent);
        var cells = hero.get(:cells);
        if (cells instanceof Array && plan.ys[DayArcStack.ROW_GRID] >= 0) {
            var date = hero.get(:dateText);
            var rest = DayArcCorners.draw(dc, layout, plan, date instanceof String ? date : null, cells as Array<Dictionary>);
            DayArcGrid.draw(dc, layout, plan.gridTop(), rest);
        }
    }

    // Clock, then the date line — every window, both densities (ADR-013: date used to be night-only).
    // The clock is muted, not full white (DESIGN.md): present, but never competing with the hero
    // read for the first glance — watch-design-reviewer, 2026-09-28.
    private static function drawHeader(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, clockText as String) as Void {
        var y = plan.ys[DayArcStack.ROW_CLOCK];
        DayArcText.drawCentered(dc, layout.rowCenterX(y, plan.hs[DayArcStack.ROW_CLOCK]), y, plan.clockFont, clockText, plan.rowWidth(y, plan.hs[DayArcStack.ROW_CLOCK]), DayArcPalette.MUTED);
        // Every live string is null-guarded: a cached plan may still have a row for a string that has
        // gone null (the date complication for one update, say), and that must never throw.
        var dateY = plan.ys[DayArcStack.ROW_DATE];
        var date = hero.get(:dateText);
        if (dateY >= 0 && date instanceof String) {
            var width = plan.rowWidth(dateY, plan.hs[DayArcStack.ROW_DATE]);
            DayArcText.drawCentered(dc, layout.rowCenterX(dateY, plan.hs[DayArcStack.ROW_DATE]), dateY, plan.textFont, date, width, DayArcPalette.MUTED);
        }
    }

    // Hero label (if any), hero icon+value, gauge (if any), sub line(s) (if any) — every window but
    // night, both densities.
    private static function drawHeroBlock(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, accent as Number) as Void {
        var labelY = plan.ys[DayArcStack.ROW_LABEL];
        var label = hero.get(:label);
        if (labelY >= 0 && label instanceof String) {
            var width = plan.rowWidth(labelY, plan.hs[DayArcStack.ROW_LABEL]);
            // The label names the hero, so it is the brighter small line (the date is muted) and sits closer to its number than
            // to the date: drawn down into the empty headroom above the digits (reviewer pass seven).
            DayArcText.drawCentered(dc, layout.rowCenterX(labelY, plan.hs[DayArcStack.ROW_LABEL]), labelY + labelNudge(dc, plan), plan.textFont, label, width, DayArcPalette.TEXT);
        }
        if (plan.ys[DayArcStack.ROW_HERO] >= 0) {
            drawHeroGroup(dc, layout, plan, hero, accent);
        }
        var gaugeY = plan.ys[DayArcStack.ROW_GAUGE];
        var gauge = hero.get(:gauge);
        var gaugeMax = hero.get(:gaugeMax);
        if (gaugeY >= 0 && gauge instanceof Number && gaugeMax instanceof Number) {
            drawGauge(dc, layout, gaugeY, gauge, gaugeMax, accent);
        }
        var subY = plan.ys[DayArcStack.ROW_SUB];
        var sub = hero.get(:sub);
        if (subY >= 0 && sub instanceof String) {
            var lineHeight = dc.getFontHeight(plan.textFont);
            var lines = plan.subLines(dc, sub);
            // With no hero value (no weather) the sentence IS the read: white, the role of the label it replaces.
            var colour = hero.get(:value) == null ? DayArcPalette.TEXT : DayArcPalette.MUTED;
            for (var i = 0; i < lines.size(); i++) {
                var y = subY + i * lineHeight;
                DayArcText.drawCentered(dc, layout.rowCenterX(y, lineHeight), y, plan.textFont, lines[i], plan.rowWidth(y, lineHeight), colour);
            }
        }
    }

    // Half the empty headroom above the hero's digits (a number font's box carries about a quarter of its height above them,
    // DIGIT_HEIGHT_PERMILLE); 0 on a 1-bit watch, where the box is tested tight against the bezel circle.
    private static function labelNudge(dc as Graphics.Dc, plan as DayArcStack) as Number {
        if (DayArcPalette.MONO || plan.ys[DayArcStack.ROW_HERO] < 0) {
            return 0;
        }
        var ink = DayArcText.inkHeight(dc, plan.heroFont);
        var headroom = (plan.hs[DayArcStack.ROW_HERO] + ink) / 2 - ink * DayArcConfig.DIGIT_HEIGHT_PERMILLE / 1000;
        return headroom > 0 ? headroom / 2 : 0;
    }

    // Icon beside the hero value, both the window's accent, centred together as one group
    // (ADR-013) — the icon is a companion glyph, it never gets its own competing line.
    private static function drawHeroGroup(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, accent as Number) as Void {
        var y = plan.ys[DayArcStack.ROW_HERO];
        var rowHeight = plan.hs[DayArcStack.ROW_HERO];
        // The size the plan was made for: the small icon beside MEDIUM and MILD digits, the large one beside HOT (ADR-017).
        var iconKey = plan.smallIcon && hero.hasKey(:iconSmall) ? :iconSmall : :icon;
        var iconId = hero.hasKey(iconKey) ? hero.get(iconKey) as ResourceId or Null : null;
        var icon = iconId != null ? WatchUi.loadResource(iconId) as WatchUi.BitmapResource : null;
        var iconWidth = icon != null ? icon.getWidth() + layout.heroIconGap() : 0;
        var available = plan.rowWidth(y, rowHeight) - iconWidth;
        var value = hero.get(:value);
        var fitted = DayArcText.truncated(dc, value instanceof String ? value : "", plan.heroFont, available);
        var left = layout.rowCenterX(y, rowHeight) - (iconWidth + dc.getTextWidthInPixels(fitted, plan.heroFont)) / 2;
        var inkHeight = DayArcText.inkHeight(dc, plan.heroFont);
        if (icon != null) {
            // Level with the digits' middle (the row's top is empty headroom), kept inside the row.
            var digitMiddle = y + (rowHeight + inkHeight) / 2 - inkHeight * DayArcConfig.DIGIT_HEIGHT_PERMILLE / 2000;
            var iconTop = DayArcText.min(DayArcText.max(digitMiddle - icon.getHeight() / 2, y), y + rowHeight - icon.getHeight());
            dc.drawBitmap(left, iconTop, icon);
        }
        dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
        dc.drawText(left + iconWidth, y + (rowHeight - inkHeight) / 2, plan.heroFont, fitted, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // A single-hue fill, never a colour or brightness verdict (docs/decisions.md ADR-006): no
    // threshold tier. An earlier version dimmed above a threshold that, for stress, landed exactly
    // on Garmin's own official "rest"/"draining" band boundary — re-encoding a documented verdict
    // band as a brightness verdict, caught by watch-design-reviewer, 2026-09-28. `value` is clamped
    // to `[0, max]`: the SDK documents 0-100 but nothing enforces it at runtime, and this project's
    // own docs already flag several complication fields as unconfirmed on real devices.
    // Since E1 (2026-10-01) the gauge is a shallow smile: an arc of the layout's gauge circle (the
    // same curve the grid rows lift onto), round-capped with filled circles (drawArc ends are butt).
    private static function drawGauge(dc as Graphics.Dc, layout as DayArcLayout, top as Number, value as Number, max as Number, accent as Number) as Void {
        if (layout.isRectangle()) {
            DayArcRect.drawGauge(dc, layout, top, value, max, accent);   // a straight pill bar on a square (ADR-019)
            return;
        }
        var pen = layout.gaugeHeight();
        var radius = layout.gaugeRadius();
        // The visual side padding, capped by the real chord so it never clips a bezel on a small round
        // product; the caps stick out pen/2 past each end, so the arc itself is one pen shorter.
        var chord = layout.rowMaxWidth(top, layout.gaugeBoxHeight());
        var padded = layout.gaugeMaxWidth();
        var half = ((padded < chord ? padded : chord) - pen) / 2;
        if (half < 1 || half >= radius) {
            return;
        }
        var centreX = layout.rowCenterX(top, layout.gaugeBoxHeight());
        var low = top + layout.gaugeSag() + pen / 2;
        var centreY = low - radius;
        var span = Math.toDegrees(Math.asin(half.toFloat() / radius)).toNumber();
        var startDeg = GAUGE_BOTTOM_DEGREES - span;
        // 1-bit: the track is a hairline (every role is white there, so a full-pen track hid the fill share).
        dc.setPenWidth(DayArcPalette.MONO ? 1 : pen);
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);   // the same track grey as the arc and the pills
        dc.drawArc(centreX, centreY, radius, Graphics.ARC_COUNTER_CLOCKWISE, startDeg, GAUGE_BOTTOM_DEGREES + span);
        dc.setPenWidth(1);
        if (!DayArcPalette.MONO) {
            fillCap(dc, centreX, centreY, radius, startDeg, pen);
            fillCap(dc, centreX, centreY, radius, GAUGE_BOTTOM_DEGREES + span, pen);
        }
        var clamped = value < 0 ? 0 : (value > max ? max : value);
        var endDeg = startDeg + 2 * span * clamped / max;
        if (clamped > 0) {
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            if (endDeg > startDeg) { // equal start/end would draw a full circle (SDK), so a tiny fill is just its caps
                dc.setPenWidth(pen);
                dc.drawArc(centreX, centreY, radius, Graphics.ARC_COUNTER_CLOCKWISE, startDeg, endDeg);
                dc.setPenWidth(1);
            }
            fillCap(dc, centreX, centreY, radius, startDeg, pen);
            fillCap(dc, centreX, centreY, radius, endDeg, pen);
        }
    }

    // A round cap: a filled circle of pen/2 on the arc's centre line at `degrees` (Dc convention: 0 = 3
    // o'clock, counter-clockwise, so 270 is the bottom of the circle).
    private static function fillCap(dc as Graphics.Dc, centreX as Number, centreY as Number, radius as Number, degrees as Number, pen as Number) as Void {
        var rad = Math.toRadians(degrees.toFloat());
        dc.fillCircle(centreX + (radius * Math.cos(rad)).toNumber(), centreY - (radius * Math.sin(rad)).toNumber(), pen / 2);
    }

    // AMOLED always-on sleep: time only, dim, stepping across a 3x3 grid every minute so no pixel
    // stays lit more than a minute (TwoSunsSleep's proven pattern). `dx`/`dy` are the drift offset
    // for this minute; the view computes them from BURN_IN_GRID. No arc, no icon, no date — the
    // fewest lit pixels, deliberately not a dimmed copy of the active frame (DESIGN.md "Night/idle";
    // an idle date line was considered for ADR-013 and rejected for exactly this reason).
    static function renderIdle(dc as Graphics.Dc, layout as DayArcLayout, clockText as String, dx as Number, dy as Number) as Void {
        dc.setColor(DayArcPalette.BACKGROUND, DayArcPalette.BACKGROUND);
        dc.clear();
        var step = layout.driftStep();
        var y = layout.centerY() - layout.permille(DayArcLayout.CLOCK_MAX_PERMILLE) / 2 + dy;
        var clockHeight = dc.getFontHeight(DayArcLayout.CLOCK_FONTS[0]);
        // Real chord width at this row, same convention as renderActive, minus twice the drift step
        // so a horizontally-drifted frame stays inside it in either direction — watch-design-
        // reviewer's second pass, 2026-09-28: the first fix only reached renderActive, not this.
        var maxWidth = layout.rowMaxWidth(y, clockHeight) - 2 * step;
        DayArcText.centered(dc, layout.centerX() + dx, y, DayArcLayout.CLOCK_FONTS, clockText, maxWidth, DayArcPalette.SLEEP_TEXT);
    }
}
