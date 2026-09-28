import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Renders one active-window frame or one idle/low-power frame. Which fields a Dictionary carries
// (:cells present or not) is the only branch here — Simple vs Pro is a compile-time source
// difference (DayArcFields), never a runtime one, so this class doesn't need to know which build
// it's in.
class DayArcDraw {
    // Thin orchestrator (watch-design-reviewer, 2026-09-28: this used to run ~55 lines against the
    // project's own ≲30-line function rule) — each named piece below does one row or one block.
    static function renderActive(dc as Graphics.Dc, layout as DayArcLayout, window as Number, hero as Dictionary, clockText as String, windowProgress as Float) as Void {
        dc.setColor(DayArcPalette.TEXT, DayArcPalette.BACKGROUND);
        dc.clear();

        if (window != DayArcConfig.WINDOW_NIGHT) {
            drawArc(dc, layout, window, windowProgress);
        }

        var y = drawHeader(dc, layout, hero, clockText);
        if (window == DayArcConfig.WINDOW_NIGHT) {
            return;
        }

        y = drawHeroBlock(dc, layout, y, window, hero);

        if (hero.hasKey(:cells)) {
            y += layout.rowGap();
            y = drawDivider(dc, layout, y);
            DayArcGrid.draw(dc, layout, layout.gridTop(dc, y), hero.get(:cells) as Array<Dictionary>);
        }
    }

    // Clock, then the date line — every window, both densities (ADR-013: date used to be night-only).
    private static function drawHeader(dc as Graphics.Dc, layout as DayArcLayout, hero as Dictionary, clockText as String) as Number {
        var y = layout.topMargin();
        var clockHeight = dc.getFontHeight(DayArcLayout.CLOCK_FONTS[0]);
        // Muted, not full white (DESIGN.md): the clock stays present but never competes with the
        // hero read for the first glance — watch-design-reviewer, 2026-09-28.
        y = DayArcText.centered(dc, layout.centerX(), y, DayArcLayout.CLOCK_FONTS, clockText, layout.rowMaxWidth(y, clockHeight), DayArcPalette.MUTED);
        y += layout.rowGap();

        var date = hero.hasKey(:dateText) ? (hero.get(:dateText) as String or Null) : null;
        if (date != null) {
            var dateHeight = dc.getFontHeight(DayArcLayout.LABEL_FONTS[0]);
            y = DayArcText.centered(dc, layout.centerX(), y, DayArcLayout.LABEL_FONTS, date, layout.rowMaxWidth(y, dateHeight), DayArcPalette.MUTED);
        }
        return y;
    }

    // Hero label (if any), hero icon+value, gauge (if any), sub line (if any) — every window but
    // night, both densities.
    private static function drawHeroBlock(dc as Graphics.Dc, layout as DayArcLayout, yIn as Number, window as Number, hero as Dictionary) as Number {
        var y = yIn + layout.rowGap();

        var label = hero.get(:label) as String or Null;
        if (label != null) {
            var labelHeight = dc.getFontHeight(DayArcLayout.LABEL_FONTS[0]);
            y = DayArcText.centered(dc, layout.centerX(), y, DayArcLayout.LABEL_FONTS, label, layout.rowMaxWidth(y, labelHeight), DayArcPalette.MUTED);
            y += layout.rowGap();
        }

        var accent = DayArcPalette.accentFor(window);
        y = drawHeroGroup(dc, layout, y, hero, accent);
        y += layout.rowGap();

        var gauge = hero.hasKey(:gauge) ? hero.get(:gauge) as Number or Null : null;
        if (gauge != null) {
            y = drawGauge(dc, layout, y, gauge, hero.get(:gaugeMax) as Number, accent);
            y += layout.rowGap();
        }

        var sub = hero.hasKey(:sub) ? hero.get(:sub) as String or Null : null;
        if (sub != null) {
            var subHeight = dc.getFontHeight(DayArcLayout.SUB_FONTS[0]);
            y = DayArcText.centered(dc, layout.centerX(), y, DayArcLayout.SUB_FONTS, sub, layout.rowMaxWidth(y, subHeight), DayArcPalette.MUTED);
        }
        return y;
    }

    // Window-progress arc (ADR-013): a thin arc across the top of the circle in the window's own
    // accent, showing progress through the CURRENT window only — a deliberately different shape
    // from TwoSuns's full 24h ring. A dim track is always drawn first so the accent segment reads
    // as "progress," not an ambiguous growing sliver.
    private static function drawArc(dc as Graphics.Dc, layout as DayArcLayout, window as Number, fraction as Float) as Void {
        var cx = layout.centerX();
        var cy = layout.centerY();
        var r = layout.arcRadius();
        var start = layout.arcTrackStartDegrees();
        var end = layout.arcTrackEndDegrees();
        dc.setPenWidth(layout.arcPenWidth());
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, r, Graphics.ARC_CLOCKWISE, start, end);

        var progressEnd = layout.arcProgressEndDegrees(fraction);
        // Dc.drawArc treats equal start/end degrees as a full circle (SDK docs) — skip at fraction
        // 0 rather than draw a full accent ring instead of "no progress yet."
        if (progressEnd != start) {
            dc.setColor(DayArcPalette.accentFor(window), Graphics.COLOR_TRANSPARENT);
            dc.drawArc(cx, cy, r, Graphics.ARC_CLOCKWISE, start, progressEnd);
        }
        dc.setPenWidth(1);
    }

    // Icon beside the hero value, both the window's accent, centred together as one group
    // (ADR-013) — the icon is a companion glyph, it never gets its own competing line.
    private static function drawHeroGroup(dc as Graphics.Dc, layout as DayArcLayout, y as Number, hero as Dictionary, accent as Number) as Number {
        var valueStr = hero.get(:value) as String;
        var iconId = hero.hasKey(:icon) ? hero.get(:icon) as ResourceId or Null : null;
        var heroHeight = dc.getFontHeight(DayArcLayout.HERO_FONTS[0]);
        if (iconId == null) {
            return DayArcText.centered(dc, layout.centerX(), y, DayArcLayout.HERO_FONTS, valueStr, layout.rowMaxWidth(y, heroHeight), accent);
        }

        var icon = WatchUi.loadResource(iconId) as WatchUi.BitmapResource;
        var gap = layout.heroIconGap();
        var available = layout.rowMaxWidth(y, heroHeight) - icon.getWidth() - gap;
        var font = DayArcText.fittingFont(dc, DayArcLayout.HERO_FONTS, valueStr, available);
        var fitted = DayArcText.truncated(dc, valueStr, font, available);
        var textWidth = dc.getTextWidthInPixels(fitted, font);
        var fontHeight = dc.getFontHeight(font);
        var totalWidth = icon.getWidth() + gap + textWidth;
        var left = layout.centerX() - totalWidth / 2;

        var rowHeight = fontHeight > icon.getHeight() ? fontHeight : icon.getHeight();
        dc.drawBitmap(left, y + (rowHeight - icon.getHeight()) / 2, icon);
        dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
        dc.drawText(left + icon.getWidth() + gap, y + (rowHeight - fontHeight) / 2, font, fitted, Graphics.TEXT_JUSTIFY_LEFT);
        return y + rowHeight;
    }

    // A single-hue fill, never a colour or brightness verdict (docs/decisions.md ADR-006): no
    // threshold tier. An earlier version dimmed above a threshold that, for stress, landed exactly
    // on Garmin's own official "rest"/"draining" band boundary — re-encoding a documented verdict
    // band as a brightness verdict, caught by watch-design-reviewer, 2026-09-28. `value` is clamped
    // to `[0, max]`: the SDK documents 0-100 but nothing enforces it at runtime, and this project's
    // own docs already flag several complication fields as unconfirmed on real devices.
    private static function drawGauge(dc as Graphics.Dc, layout as DayArcLayout, top as Number, value as Number, max as Number, accent as Number) as Number {
        var height = layout.permille(30);
        // The deliberate visual side padding (wider than plain round-safety), capped by the real
        // chord width so it never clips a bezel on a small round product — code review, 2026-09-28.
        var padded = layout.width() - layout.permille(160);
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
        return top + height;
    }

    // Pro only: a faint hairline marking where "glance here first" (clock, date, hero) ends and
    // "look after" (the grid) begins (ADR-013).
    private static function drawDivider(dc as Graphics.Dc, layout as DayArcLayout, y as Number) as Number {
        var width = layout.dividerWidth(y);
        var left = layout.centerX() - width / 2;
        dc.setPenWidth(1);
        dc.setColor(DayArcPalette.ARC_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(left, y, left + width, y);
        return y + layout.rowGap();
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
