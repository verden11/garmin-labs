import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Renders one active-window frame or one idle/low-power frame. Which fields a Dictionary carries
// (:cells present or not) is the only branch here — Simple vs Pro is a compile-time source
// difference (DayArcFields), never a runtime one, so this class doesn't need to know which build
// it's in. WHERE every row sits, and in which font, is DayArcStack's plan (a measured dry run of the
// whole stack); this class only draws what was planned.
class DayArcDraw {
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
            drawDivider(dc, layout, plan.ys[DayArcStack.ROW_GRID]);
            DayArcGrid.draw(dc, layout, plan.gridTop(), cells as Array<Dictionary>);
        }
    }

    // Clock, then the date line — every window, both densities (ADR-013: date used to be night-only).
    // The clock is muted, not full white (DESIGN.md): present, but never competing with the hero
    // read for the first glance — watch-design-reviewer, 2026-09-28.
    private static function drawHeader(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, clockText as String) as Void {
        var y = plan.ys[DayArcStack.ROW_CLOCK];
        DayArcText.drawCentered(dc, layout.centerX(), y, plan.clockFont, clockText, plan.rowWidth(y, plan.hs[DayArcStack.ROW_CLOCK]), DayArcPalette.MUTED);
        // Every live string is null-guarded: a cached plan may still have a row for a string that has
        // gone null (the date complication for one update, say), and that must never throw.
        var dateY = plan.ys[DayArcStack.ROW_DATE];
        var date = hero.get(:dateText);
        if (dateY >= 0 && date instanceof String) {
            var width = plan.rowWidth(dateY, plan.hs[DayArcStack.ROW_DATE]);
            DayArcText.drawCentered(dc, layout.centerX(), dateY, plan.textFont, date, width, DayArcPalette.MUTED);
        }
    }

    // Hero label (if any), hero icon+value, gauge (if any), sub line(s) (if any) — every window but
    // night, both densities.
    private static function drawHeroBlock(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, accent as Number) as Void {
        var labelY = plan.ys[DayArcStack.ROW_LABEL];
        var label = hero.get(:label);
        if (labelY >= 0 && label instanceof String) {
            var width = plan.rowWidth(labelY, plan.hs[DayArcStack.ROW_LABEL]);
            DayArcText.drawCentered(dc, layout.centerX(), labelY, plan.textFont, label, width, DayArcPalette.MUTED);
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
            for (var i = 0; i < lines.size(); i++) {
                var y = subY + i * lineHeight;
                DayArcText.drawCentered(dc, layout.centerX(), y, plan.textFont, lines[i], plan.rowWidth(y, lineHeight), DayArcPalette.MUTED);
            }
        }
    }

    // Icon beside the hero value, both the window's accent, centred together as one group
    // (ADR-013) — the icon is a companion glyph, it never gets its own competing line.
    private static function drawHeroGroup(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, accent as Number) as Void {
        var y = plan.ys[DayArcStack.ROW_HERO];
        var rowHeight = plan.hs[DayArcStack.ROW_HERO];
        var iconId = hero.hasKey(:icon) ? hero.get(:icon) as ResourceId or Null : null;
        var icon = iconId != null ? WatchUi.loadResource(iconId) as WatchUi.BitmapResource : null;
        var iconWidth = icon != null ? icon.getWidth() + layout.heroIconGap() : 0;
        var available = plan.rowWidth(y, rowHeight) - iconWidth;
        var value = hero.get(:value);
        var fitted = DayArcText.truncated(dc, value instanceof String ? value : "", plan.heroFont, available);
        var left = layout.centerX() - (iconWidth + dc.getTextWidthInPixels(fitted, plan.heroFont)) / 2;
        if (icon != null) {
            dc.drawBitmap(left, y + (rowHeight - icon.getHeight()) / 2, icon);
        }
        var inkHeight = DayArcText.inkHeight(dc, plan.heroFont);
        dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
        dc.drawText(left + iconWidth, y + (rowHeight - inkHeight) / 2, plan.heroFont, fitted, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // A single-hue fill, never a colour or brightness verdict (docs/decisions.md ADR-006): no
    // threshold tier. An earlier version dimmed above a threshold that, for stress, landed exactly
    // on Garmin's own official "rest"/"draining" band boundary — re-encoding a documented verdict
    // band as a brightness verdict, caught by watch-design-reviewer, 2026-09-28. `value` is clamped
    // to `[0, max]`: the SDK documents 0-100 but nothing enforces it at runtime, and this project's
    // own docs already flag several complication fields as unconfirmed on real devices.
    private static function drawGauge(dc as Graphics.Dc, layout as DayArcLayout, top as Number, value as Number, max as Number, accent as Number) as Void {
        var height = layout.gaugeHeight();
        // The deliberate visual side padding, capped by the real chord width so it never clips a
        // bezel on a small round product — code review, 2026-09-28.
        var padded = layout.gaugeMaxWidth();
        var chord = layout.rowMaxWidth(top, height);
        var width = padded < chord ? padded : chord;
        var left = layout.centerX() - width / 2;
        dc.setColor(DayArcPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(left, top, width, height, height / 2);
        var clamped = value < 0 ? 0 : (value > max ? max : value);
        var fillWidth = width * clamped / max;
        if (fillWidth > 0) {
            // A rounded-rectangle radius wider than half of what it's filling draws as a distorted
            // blob, not a thin bar — the exact defect TwoSuns hit at low fill (code review,
            // 2026-09-28). Radius never exceeds half the fill itself.
            var radius = height / 2;
            if (fillWidth < height) {
                radius = fillWidth / 2;
            }
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(left, top, fillWidth, height, radius);
        }
    }

    // Pro only: a faint hairline marking where "glance here first" (clock, date, hero) ends and
    // "look after" (the grid) begins (ADR-013).
    private static function drawDivider(dc as Graphics.Dc, layout as DayArcLayout, y as Number) as Void {
        var width = layout.dividerWidth(y);
        var left = layout.centerX() - width / 2;
        dc.setPenWidth(1);
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(left, y, left + width, y);
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
        DayArcText.centered(dc, layout.centerX() + dx, y, DayArcLayout.CLOCK_FONTS, clockText, maxWidth, DayArcPalette.MUTED);
    }
}
