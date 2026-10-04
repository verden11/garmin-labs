import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// HeroSet's entry in the glance list: today's three missions as pill bars
// under one status row (the streak, or a check when the mission is complete).
// Read-only (HeroSetGlanceReader) and self-contained: the glance process only
// has the (:glance) classes, so text is measured and drawn here rather than
// through HeroSetDraw/HeroSetText, which assume the round display (ADR-051).
// No background fill: the system draws the themed card behind a glance, and an
// opaque fill would paint over it.
(:glance)
class HeroSetGlanceView extends WatchUi.GlanceView {

    private static const FONT = Graphics.FONT_GLANCE;
    private static const PERCENT = 100;
    // The check is a drawn shape, so "done" never relies on color or a
    // translatable word alone (ADR-049): 3/5 of the text height.
    private static const CHECK_NUMERATOR = 3;
    private static const CHECK_DENOMINATOR = 5;
    private static const CHECK_PEN_DIVISOR = 5;
    private static const CHECK_MIN_PEN = 2;
    // Corner of the tick, as a percent of the check's box.
    private static const CHECK_FOOT_X_PERCENT = 40;
    private static const CHECK_START_Y_PERCENT = 55;
    // The row's own gap between the check and the words.
    private static const CHECK_GAP_DIVISOR = 3;

    function initialize() {
        GlanceView.initialize();
    }

    // Read on every draw, not once: a live glance can outlive midnight or a
    // goal change made in the app.
    function onUpdate(dc as Dc) as Void {
        var state = HeroSetGlanceReader.read(new HeroSetPersistentStorage(), HeroSetCalendar.todayKey());
        drawState(dc, dc.getWidth(), dc.getHeight(), state);
    }

    // The Instinct's round window as [left, bottom] in screen coordinates
    // (ADR-055); null on every other product, so no other glance's geometry can
    // depend on it.
    static function window() as [Lang.Number, Lang.Number]? {
        if (System.getDeviceSettings().screenShape != System.SCREEN_SHAPE_SEMI_OCTAGON || !(WatchUi has :getSubscreen)) {
            return null;
        }
        var box = WatchUi.getSubscreen();
        return box == null ? null : [box.x, box.y + box.height];
    }

    // Split from onUpdate so tests can draw a state into a bitmap at any
    // product's glance size.
    function drawState(dc as Dc, width as Lang.Number, height as Lang.Number, state as HeroSetDashboardState) as Void {
        var layout = new HeroSetGlanceLayout(width, height, dc.getFontHeight(FONT), window());
        var done = HeroSetRules.missionComplete(state.pushups, state.situps, state.squats, state.goal);
        drawStatus(dc, layout, state, done);
        drawPills(dc, layout, state);
    }

    // The words that fit beside the check, longest first; "" when none does,
    // leaving the check (done) or nothing (open) rather than clipped text.
    function statusLine(dc as Dc, available as Lang.Number, state as HeroSetDashboardState, done as Lang.Boolean) as Lang.String {
        var candidates = candidatesFor(state.streak, done);
        for (var i = 0; i < candidates.size(); i++) {
            if (dc.getTextWidthInPixels(candidates[i], FONT) <= available) {
                return candidates[i];
            }
        }
        return "";
    }

    private function candidatesFor(streak as Lang.Number, done as Lang.Boolean) as Lang.Array<Lang.String> {
        var candidates = [] as Lang.Array<Lang.String>;
        if (done) {
            candidates.add(load(Rez.Strings.dashboard_mission_complete));
        }
        if (streak > 0) {
            candidates.add(Lang.format(load(Rez.Strings.dashboard_streak), [streak]));
            candidates.add(Lang.format(load(Rez.Strings.dashboard_streak_short), [streak]));
        } else if (!done) {
            // Beside a check "NO STREAK YET" would contradict it; the row
            // drops to the check alone instead.
            candidates.add(load(Rez.Strings.dashboard_streak_none));
            // Left of the Instinct's window "NO STREAK YET" has no room; the
            // dashboard falls back to this too (ADR-055).
            candidates.add(Lang.format(load(Rez.Strings.dashboard_streak_short), [streak]));
        }
        return candidates;
    }

    // Where the status row's pieces go: [words, x of the words, check size]
    // (0 without a check). Shared by drawing and by the fit tests.
    function statusPlan(dc as Dc, layout as HeroSetGlanceLayout, state as HeroSetDashboardState, done as Lang.Boolean) as [Lang.String, Lang.Number, Lang.Number] {
        var textHeight = dc.getFontHeight(FONT);
        var checkSize = done ? textHeight * CHECK_NUMERATOR / CHECK_DENOMINATOR : 0;
        var indent = done ? checkSize + textHeight / CHECK_GAP_DIVISOR : 0;
        return [statusLine(dc, layout.contentWidth() - indent, state, done), layout.pad() + indent, checkSize];
    }

    private function drawStatus(dc as Dc, layout as HeroSetGlanceLayout, state as HeroSetDashboardState, done as Lang.Boolean) as Void {
        var plan = statusPlan(dc, layout, state, done);
        if (done) {
            var textHeight = dc.getFontHeight(FONT);
            drawCheck(dc, layout.pad(), layout.textTop() + (textHeight - plan[2]) / 2, plan[2]);
        }
        if (plan[0].length() > 0) {
            // The streak is what the user keeps: muted while today is open,
            // gold once it is banked (ADR-031).
            dc.setColor(done ? HeroSetPalette.GOLD : HeroSetPalette.MUTED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(plan[1], layout.textTop(), FONT, plan[0], Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    private function drawCheck(dc as Dc, x as Lang.Number, y as Lang.Number, size as Lang.Number) as Void {
        var pen = size / CHECK_PEN_DIVISOR;
        dc.setColor(HeroSetPalette.DONE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen < CHECK_MIN_PEN ? CHECK_MIN_PEN : pen);
        var footX = x + size * CHECK_FOOT_X_PERCENT / PERCENT;
        var footY = y + size;
        dc.drawLine(x, y + size * CHECK_START_Y_PERCENT / PERCENT, footX, footY);
        dc.drawLine(footX, footY, x + size, y);
        dc.setPenWidth(HeroSetGlanceLayout.DEFAULT_PEN);
    }

    private function drawPills(dc as Dc, layout as HeroSetGlanceLayout, state as HeroSetDashboardState) as Void {
        var counts = [state.pushups, state.situps, state.squats] as Lang.Array<Lang.Number>;
        var width = layout.pillWidth(counts.size());
        for (var i = 0; i < counts.size(); i++) {
            drawPill(dc, layout.pillLeft(i, counts.size()), layout.pillTop(), width, layout.pillHeight(), counts[i], state.goal);
        }
    }

    // The outline sits outside the bar so it doesn't eat the few pixels a bar
    // has, and keeps the empty track visible on a light glance card.
    private function drawPill(dc as Dc, x as Lang.Number, y as Lang.Number, width as Lang.Number, height as Lang.Number, count as Lang.Number, goal as Lang.Number) as Void {
        dc.setColor(HeroSetPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        var o = HeroSetGlanceLayout.OUTLINE;
        dc.drawRectangle(x - o, y - o, width + 2 * o, height + 2 * o);
        if (!HeroSetPalette.MONO) {
            // A 1-bit display has no dim: the track stays the outline above, or every bar would read as full.
            dc.setColor(HeroSetPalette.TRACK, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(x, y, width, height);
        }
        var done = count >= goal;
        dc.setColor(done ? HeroSetPalette.DONE : HeroSetPalette.EFFORT, Graphics.COLOR_TRANSPARENT);
        // count <= 0 also covers a corrupt negative count; goal is at least
        // MIN_MISSION_GOAL from the reader, but drawState is public.
        dc.fillRectangle(x, y, done ? width : (count <= 0 || goal <= 0 ? 0 : width * count / goal), height);
    }

    // loadResource is typed as a union of every resource kind; anything but a
    // String renders blank rather than crashing mid-draw.
    private static function load(id as Lang.ResourceId) as Lang.String {
        var value = WatchUi.loadResource(id);
        return value instanceof Lang.String ? value : "";
    }
}
