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
            dc.setColor(state.accent, Graphics.COLOR_TRANSPARENT);
            DaysToGoDraw.line(dc, layout, radius, rows.nameTop, dc.getFontHeight(frame.nameFont), frame.nameFonts, [state.name] as Array<String>, 0);
        }
        dc.setColor(state.phase == DaysToGoConfig.PHASE_TODAY ? state.accent : DaysToGoPalette.TEXT, Graphics.COLOR_TRANSPARENT);
        drawHero(dc, layout, radius, rows.heroTop, rows.heroHeight, state, false, 0);
        if (state.captionLines.size() > 0) {
            drawRow(dc, layout, radius, rows.captionTop, frame.captionFont, state.captionLines, DaysToGoPalette.MUTED);
        }
        if (frame.showDate) {
            drawRow(dc, layout, radius, rows.dateTop, frame.smallFont, dateCandidates(state, frame), DaysToGoPalette.MUTED);
        }
        var footer = state.footer;
        if (frame.showFooter && !frame.footerWithDate && footer != null) {
            drawRow(dc, layout, radius, rows.footerTop, frame.smallFont, [footer] as Array<String>, DaysToGoPalette.MUTED);
        }
    }

    // Shared with DaysToGoSleep: the hours hero carries its unit letters, every other hero is one string.
    static function drawHero(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number, height as Number,
                             state as DaysToGoState, sleeping as Boolean, dx as Number) as Void {
        var fonts = DaysToGoLayout.heroFonts(state.heroIsWord, sleeping);
        if (state.heroIsHours) {
            DaysToGoHoursHero.draw(dc, layout, radius, top, height, fonts, state.hero, dx);
        } else {
            DaysToGoDraw.line(dc, layout, radius, top, height, fonts, [state.hero] as Array<String>, dx);
        }
    }

    // The date's wordings. With the bottom line sharing the row, each one also with the footer first, then the date
    // alone, so a chord too narrow for both still keeps the date.
    private function dateCandidates(state as DaysToGoState, frame as DaysToGoFrame) as Array<String> {
        var footer = state.footer;
        if (!frame.footerWithDate || footer == null) {
            return state.dateLines;
        }
        var result = [] as Array<String>;
        for (var i = 0; i < state.dateLines.size(); i++) {
            result.add(state.dateLines[i] + DaysToGoConfig.FOOTER_JOIN + footer);
        }
        result.addAll(state.dateLines);
        return result;
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
