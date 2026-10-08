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
            drawFallback(dc, layout, _sleeping && _burnIn, System.getClockTime().min);
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
            drawMarked(dc, layout, radius, rows.dateTop, frame.smallFont, dateCandidates(state, frame));
        }
        var footer = state.footer;
        if (frame.showFooter && !frame.footerWithDate && footer != null) {
            drawMarked(dc, layout, radius, rows.footerTop, frame.smallFont, [marked(state.footerMark, footer)] as Array<Array<Object>>);
        }
    }

    // Shared with DaysToGoSleep: the hours hero carries its unit letters, every other hero is one string.
    static function drawHero(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number, height as Number,
                             state as DaysToGoState, sleeping as Boolean, dx as Number) as Void {
        var fonts = DaysToGoType.heroFonts(state.heroIsWord, sleeping);
        if (state.heroIsHours) {
            DaysToGoHoursHero.draw(dc, layout, radius, top, height, fonts, state.hero, dx);
        } else {
            DaysToGoDraw.line(dc, layout, radius, top, height, fonts, [state.hero] as Array<String>, dx);
        }
    }

    // The date's wordings. With the bottom line sharing the row, each one also with the footer first, then the date
    // alone, so a chord too narrow for both still keeps the date.
    // Each wording is a row of parts (DaysToGoMark): the arrow, the date, then the footer's mark and value.
    private function dateCandidates(state as DaysToGoState, frame as DaysToGoFrame) as Array<Array<Object>> {
        var footer = state.footer;
        var result = [] as Array<Array<Object>>;
        if (frame.footerWithDate && footer != null) {
            // The footer is kept before the arrow: a narrow chord first drops the arrow, then the footer.
            var dateMarks = state.dateMark == DaysToGoConfig.MARK_NONE ? [DaysToGoConfig.MARK_NONE] : [state.dateMark, DaysToGoConfig.MARK_NONE];
            for (var m = 0; m < dateMarks.size(); m++) {
                for (var i = 0; i < state.dateLines.size(); i++) {
                    var parts = marked(dateMarks[m] as Number, state.dateLines[i]);
                    parts.add(DaysToGoConfig.FOOTER_JOIN);
                    parts.addAll(marked(state.footerMark, footer));
                    result.add(parts);
                }
            }
        }
        for (var i = 0; i < state.dateLines.size(); i++) {
            result.add(marked(state.dateMark, state.dateLines[i]));
        }
        return result;
    }

    private function marked(mark as Number, words as String) as Array<Object> {
        return (mark == DaysToGoConfig.MARK_NONE ? [words] : [mark, words]) as Array<Object>;
    }

    private function drawMarked(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number,
                                font as Graphics.FontDefinition, candidates as Array<Array<Object>>) as Void {
        dc.setColor(DaysToGoPalette.MUTED, Graphics.COLOR_TRANSPARENT);
        DaysToGoMark.line(dc, layout, radius, top, dc.getFontHeight(font), [font] as Array<Graphics.FontDefinition>, candidates);
    }

    // One row: the longest wording that fits the chord in the row's font.
    private function drawRow(dc as Graphics.Dc, layout as DaysToGoLayout, radius as Number, top as Number,
                             font as Graphics.FontDefinition, candidates as Array<String>, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        DaysToGoDraw.line(dc, layout, radius, top, dc.getFontHeight(font), [font] as Array<Graphics.FontDefinition>, candidates, 0);
    }

    // Never leave a blank screen: a question mark says "something went wrong", not "no event". Asleep on a burn-in
    // protected watch it follows the always-on rule (ADR-007): the dim grey, drifting with the sleep frame's grid, so a
    // read failure that persists across updates never burns in. Static and given the minute, so a test can draw it.
    static function drawFallback(dc as Graphics.Dc, layout as DaysToGoLayout, dim as Boolean, minute as Number) as Void {
        var color = fallbackColor(dim);
        dc.setColor(color, DaysToGoPalette.BACKGROUND);
        dc.clear();
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var shift = dim ? DaysToGoSleep.drift(layout, minute) : [0, 0] as Array<Number>;
        dc.drawText(layout.centerX() + shift[0], layout.centerY() + shift[1], Graphics.FONT_MEDIUM, "?",
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    static function fallbackColor(dim as Boolean) as Number {
        return dim ? DaysToGoPalette.SLEEP_TEXT : DaysToGoPalette.TEXT;
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
