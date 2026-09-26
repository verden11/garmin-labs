import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// The face: gather one DaysToGoState, then draw it. Awake it is the full face;
// asleep on AMOLED it is only a dim, drifting hero and time (burn-in rules);
// asleep on MIP it stays the full face.
class DaysToGoView extends WatchUi.WatchFace {

    private var _layout as DaysToGoLayout?;
    private var _sleeping as Boolean = false;
    private var _burnIn as Boolean;

    function initialize() {
        WatchFace.initialize();
        var device = System.getDeviceSettings();
        _burnIn = (device has :requiresBurnInProtection) && device.requiresBurnInProtection;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _layout = new DaysToGoLayout(dc);
    }

    // Settings are read fresh every update: the on-watch date picker writes
    // Properties with no callback, and the read is a handful of lookups.
    function onUpdate(dc as Graphics.Dc) as Void {
        var layout = _layout;
        if (layout == null) {
            return;
        }
        var state = null;
        try {
            state = DaysToGoReadings.take(DaysToGoSettings.load());
        } catch (e instanceof Lang.Exception) {
            state = null;
        }
        if (state == null) {
            drawFallback(dc, layout);
        } else if (_sleeping && _burnIn) {
            DaysToGoSleep.draw(dc, layout, state, System.getClockTime().min);
        } else {
            drawState(dc, layout, state);
        }
    }

    // Pure drawing, shared with the screen-fit test.
    function drawState(dc as Graphics.Dc, layout as DaysToGoLayout, state as DaysToGoState) as Void {
        dc.setColor(DaysToGoPalette.TEXT, DaysToGoPalette.BACKGROUND);
        dc.clear();
        DaysToGoRing.draw(dc, layout, state);
        var frame = new DaysToGoFrame(dc, layout, state, false);
        var rows = frame.rows;
        var radius = layout.contentRadius();
        drawRow(dc, layout, radius, rows.timeTop, frame.timeFont, [state.time] as Array<String>, DaysToGoPalette.TEXT);
        if (frame.showName) {
            drawRow(dc, layout, radius, rows.nameTop, frame.nameFont, [state.name] as Array<String>, state.accent);
        }
        dc.setColor(state.phase == DaysToGoConfig.PHASE_TODAY ? state.accent : DaysToGoPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        DaysToGoDraw.line(dc, layout, radius, rows.heroTop, rows.heroHeight,
                          DaysToGoLayout.heroFonts(state.heroIsWord, false), [state.hero] as Array<String>, 0);
        if (state.captionLines.size() > 0) {
            drawRow(dc, layout, radius, rows.captionTop, frame.captionFont, state.captionLines, DaysToGoPalette.MUTED);
        }
        if (frame.showDate) {
            drawRow(dc, layout, radius, rows.dateTop, frame.smallFont, state.dateLines, DaysToGoPalette.MUTED);
        }
        var footer = state.footer;
        if (frame.showFooter && footer != null) {
            drawRow(dc, layout, radius, rows.footerTop, frame.smallFont, [footer] as Array<String>, DaysToGoPalette.MUTED);
        }
    }

    // One row: the longest wording that fits the chord in the row's font.
    private function drawRow(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number,
                             font as Graphics.FontDefinition, candidates as Array<String>, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        DaysToGoDraw.line(dc, layout, radius, top, dc.getFontHeight(font), [font] as Array<Graphics.FontDefinition>, candidates, 0);
    }

    // Never leave a blank screen: a question mark says "something went wrong", not "no event".
    private function drawFallback(dc as Graphics.Dc, layout as DaysToGoLayout) as Void {
        dc.setColor(DaysToGoPalette.TEXT, DaysToGoPalette.BACKGROUND);
        dc.clear();
        dc.drawText(layout.centerX(), layout.centerY(), Graphics.FONT_MEDIUM, "?", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onEnterSleep() as Void {
        _sleeping = true;
        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        _sleeping = false;
        WatchUi.requestUpdate();
    }
}
