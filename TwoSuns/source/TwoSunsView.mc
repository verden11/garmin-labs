import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// The face: gather one TwoSunsState, then draw it. Awake it is the full face; asleep on AMOLED it is
// only a dim, drifting time, Body Battery number and sun sentence (burn-in rules); asleep on MIP it
// stays the full face.
class TwoSunsView extends WatchUi.WatchFace {

    private var _sources as TwoSunsSources = new TwoSunsSources();
    private var _layout as TwoSunsLayout or Null = null;
    private var _sleeping as Boolean = false;
    private var _burnIn as Boolean;

    function initialize() {
        WatchFace.initialize();
        var device = System.getDeviceSettings();
        _burnIn = (device has :requiresBurnInProtection) && device.requiresBurnInProtection;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _layout = new TwoSunsLayout(dc);
    }

    // Settings are read fresh every update: a handful of lookups, and no cache to go stale.
    function onUpdate(dc as Graphics.Dc) as Void {
        var layout = _layout;
        if (layout == null) {
            return;
        }
        var state = null;
        try {
            state = _sources.read(TwoSunsSettings.load());
        } catch (e instanceof Lang.Exception) {
            state = null;
        }
        if (state == null) {
            drawFallback(dc, layout);
        } else if (_sleeping && _burnIn) {
            TwoSunsSleep.draw(dc, layout, state, System.getClockTime().min);
        } else {
            drawState(dc, layout, state);
        }
    }

    // Pure drawing, shared with the screen-fit test.
    function drawState(dc as Graphics.Dc, layout as TwoSunsLayout, state as TwoSunsState) as Void {
        dc.setColor(TwoSunsPalette.TEXT, TwoSunsPalette.BACKGROUND);
        dc.clear();
        TwoSunsRing.draw(dc, layout, state);
        var frame = new TwoSunsFrame(dc, layout, state, false);
        var rows = frame.rows;
        var radius = layout.contentRadius();
        if (frame.showDate) {
            drawRow(dc, layout, radius, rows.dateTop, dc.getFontHeight(frame.dateFont), frame.dateFonts, state.dateLines, TwoSunsPalette.MUTED);
        }
        drawRow(dc, layout, radius, rows.timeTop, dc.getFontHeight(frame.timeFont), frame.timeFonts, [state.time] as Array<String>, TwoSunsPalette.TEXT);
        drawBand(dc, layout, frame, state);
        if (frame.showLine) {
            drawRow(dc, layout, radius, rows.lineTop, dc.getFontHeight(frame.lineFont), frame.lineFonts, state.skyLines, TwoSunsPalette.TEXT);
        }
    }

    // The Body Battery band: a level pill, the value and, when there is room, the energy curve.
    private function drawBand(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        var band = frame.band;
        TwoSunsCurve.drawGlyph(dc, layout, band, state.batteryLevel, state.batteryStale, state.batteryAccent);
        TwoSunsDraw.box(layout, band.glyphLeft, band.glyphTop, band.glyphWidth, band.glyphHeight, "glyph");
        dc.setColor(state.batteryStale ? TwoSunsPalette.MUTED : state.batteryAccent, Graphics.COLOR_TRANSPARENT);
        var top = frame.rows.bandTop + (frame.bandHeight - dc.getFontHeight(frame.valueFont)) / 2;
        TwoSunsDraw.text(dc, layout, band.valueCenterX, top, frame.valueFont, state.batteryText, Graphics.TEXT_JUSTIFY_CENTER);
        var curve = state.curve;
        if (frame.showCurve && curve != null) {
            TwoSunsCurve.draw(dc, layout, band, curve, state.batteryStale, state.batteryAccent);
            TwoSunsDraw.box(layout, band.curveLeft, band.curveTop, band.curveWidth, band.curveHeight, "curve");
        }
    }

    // One row: the longest wording that fits the chord in the largest font that fits.
    private function drawRow(dc as Graphics.Dc, layout as TwoSunsLayout, radius as Number, top as Number, bandHeight as Number,
                             fonts as Array<Graphics.FontDefinition>, candidates as Array<String>, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        TwoSunsDraw.line(dc, layout, radius, top, bandHeight, fonts, candidates, 0);
    }

    // Never leave a blank screen: a question mark says "something went wrong", not "no data".
    private function drawFallback(dc as Graphics.Dc, layout as TwoSunsLayout) as Void {
        dc.setColor(TwoSunsPalette.TEXT, TwoSunsPalette.BACKGROUND);
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
