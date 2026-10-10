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
            drawFallback(dc, layout, _sleeping && _burnIn);
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
        drawTime(dc, layout, frame, state);
        drawBattery(dc, layout, frame, state);
        drawWeather(dc, layout, frame, state);
        drawBand(dc, layout, frame, state);
        if (frame.showLine) {
            drawRow(dc, layout, radius, rows.lineTop, dc.getFontHeight(frame.lineFont), frame.lineFonts, state.skyLines, TwoSunsPalette.TEXT);
        }
    }

    // A rectangle's spread time is placed and fitted by its digits (TwoSunsRectSpread, TwoSunsRectFit); every other time is a row.
    (:rect)
    private function drawTime(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        if (frame.timeByInk) {
            dc.setColor(TwoSunsPalette.TEXT, Graphics.COLOR_TRANSPARENT);
            TwoSunsDraw.inkText(dc, layout, layout.centerX(), frame.rows.timeTop, frame.timeFont, state.time,
                                TwoSunsRectSpread.timePad(frame.timeFont, dc.getFontHeight(frame.timeFont)));
        } else {
            drawTimeRow(dc, layout, frame, state);
        }
    }

    (:norect)
    private function drawTime(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        drawTimeRow(dc, layout, frame, state);
    }

    private function drawTimeRow(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        drawRow(dc, layout, layout.contentRadius(), frame.rows.timeTop, dc.getFontHeight(frame.timeFont), frame.timeFonts, [state.time] as Array<String>, TwoSunsPalette.TEXT);
    }

    // The watch battery row is Pro only: Free has no such row.
    (:pro)
    private function drawBattery(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        var percent = state.watchBattery;
        if (frame.showBattery && percent != null) {
            TwoSunsBatteryRow.draw(dc, layout, frame.batteryTop, percent);
        }
    }

    (:free)
    private function drawBattery(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
    }

    // The weather row is Pro only: Free has no weather, so no state ever carries one.
    (:pro)
    private function drawWeather(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        var weather = state.weather;
        if (frame.weatherMode != TwoSunsConfig.WEATHER_ROW_NONE && weather != null) {
            TwoSunsWeatherRow.draw(dc, layout, weather, frame.weatherMode, frame.rows.weatherTop, frame.weatherAhead);
        }
    }

    (:free)
    private function drawWeather(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
    }

    // The Body Battery band: the bolt, the value and, when there is room, the energy curve's room (its line once it has one).
    private function drawBand(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        var band = frame.band;
        TwoSunsCurve.drawGlyph(dc, layout, band, state.batteryLevel, state.batteryStale, state.accent);
        TwoSunsDraw.box(layout, band.glyphLeft, band.glyphTop, band.glyphWidth, band.glyphHeight, "glyph");
        // One colour whatever the level; "--" and a stale number are muted like the hollow bolt beside them (ADR-008, ADR-028).
        dc.setColor(TwoSunsReadings.batteryColor(state), Graphics.COLOR_TRANSPARENT);
        var top = frame.rows.bandTop + (frame.bandHeight - dc.getFontHeight(frame.valueFont)) / 2;
        TwoSunsDraw.text(dc, layout, band.valueCenterX, top, frame.valueFont, state.batteryText, Graphics.TEXT_JUSTIFY_CENTER);
        drawCurve(dc, layout, frame, state);
    }

    // The energy curve is Pro only: Free has no history, so no state ever carries one.
    (:pro)
    private function drawCurve(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
        if (!frame.showCurve) {
            return;
        }
        var band = frame.band;
        var curve = state.curve;
        // A curve with no line (a lone dot) floats at the band's far end and reads as noise: its room stays empty until two
        // neighbouring samples exist (ADR-028, the rectangle track; round too since 2026-10-08).
        if (curve != null && curve.hasALine()) {
            TwoSunsCurve.draw(dc, layout, band, curve, state.batteryStale, state.accent);
        }
        TwoSunsDraw.box(layout, band.curveLeft, band.curveTop, band.curveWidth, band.curveHeight, "curve");
    }

    (:free)
    private function drawCurve(dc as Graphics.Dc, layout as TwoSunsLayout, frame as TwoSunsFrame, state as TwoSunsState) as Void {
    }

    // One row: the longest wording that fits the chord in the largest font that fits.
    private function drawRow(dc as Graphics.Dc, layout as TwoSunsLayout, radius as Number, top as Number, bandHeight as Number,
                             fonts as Array<Graphics.FontDefinition>, candidates as Array<String>, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        TwoSunsDraw.line(dc, layout, radius, top, bandHeight, fonts, candidates, 0);
    }

    // Never leave a blank screen: a question mark says "something went wrong", not "no data". Asleep
    // on a burn-in-protection watch it follows the same dim, drifting rule as TwoSunsSleep.draw, so a
    // stuck fallback (a read failure that persists across updates) never burns in either.
    private function drawFallback(dc as Graphics.Dc, layout as TwoSunsLayout, dim as Boolean) as Void {
        var color = dim ? TwoSunsPalette.SLEEP_TEXT : TwoSunsPalette.TEXT;
        dc.setColor(color, TwoSunsPalette.BACKGROUND);
        dc.clear();
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var x = layout.centerX();
        var y = layout.centerY();
        if (dim) {
            var grid = TwoSunsConfig.BURN_IN_GRID;
            var minute = System.getClockTime().min;
            var step = layout.driftStep();
            x += (minute % grid - 1) * step;
            y += (minute / grid % grid - 1) * step;
        }
        dc.drawText(x, y, Graphics.FONT_MEDIUM, "?", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
