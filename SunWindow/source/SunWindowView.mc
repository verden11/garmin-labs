import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

// The full view: the picture, then the state word, one reason line and today's times (DESIGN.md). Renders only in
// onUpdate from one SunWindowState; the place comes from SunWindowSources, the rest from SunWindowReader (the same read
// the glance does). One timer redraws it each minute while it is shown, and stops when it is not.
class SunWindowView extends WatchUi.View {
    private var _sources as SunWindowSources = new SunWindowSources();
    private var _timer as Timer.Timer or Null = null;

    function initialize() {
        View.initialize();
    }

    function onShow() as Void {
        _sources.refresh();
        var timer = new Timer.Timer();
        timer.start(method(:tick), SunWindowConfig.TICK_MILLISECONDS, true);
        _timer = timer;
    }

    function onHide() as Void {
        var timer = _timer;
        if (timer != null) {
            timer.stop();
            _timer = null;
        }
        _sources.stop();
    }

    function tick() as Void {
        _sources.takeCachedFix();
        WatchUi.requestUpdate();
    }

    // START: a fresh fix (the no-place states offer it; with a place it is harmless).
    function ask() as Void {
        _sources.ask();
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        drawState(dc, SunWindowReader.read(_sources.locating(), _sources.failed(), true), SunWindowSettings.accent());
    }

    // Split from onUpdate so tests and screenshots can draw any state at any product's size.
    function drawState(dc as Dc, state as SunWindowState, accentId as Number) as Void {
        dc.setColor(SunWindowPalette.TEXT, SunWindowPalette.BACKGROUND);
        dc.clear();
        var layout = new SunWindowLayout(dc);
        SunWindowDiagram.draw(dc, layout, state, SunWindowPalette.accent(accentId));
        drawWindowMark(dc, layout, state);
        var rows = SunWindowRows.plan(dc, layout, state, System.getDeviceSettings().is24Hour);
        SunWindowRows.draw(dc, layout, rows);
    }

    // The Instinct's round sub-window cannot show the picture's disc, so it carries the state mark, large.
    private function drawWindowMark(dc as Dc, layout as SunWindowLayout, state as SunWindowState) as Void {
        var box = layout.subscreen();
        if (box == null || !SunWindowMark.isDrawn(state.kind)) {
            return;
        }
        var size = box[2] * SunWindowConfig.SUB_MARK_PERCENT / SunWindowConfig.PERCENT;
        SunWindowMark.draw(dc, box[0] + box[2] / 2, box[1] + box[3] * SunWindowConfig.SUB_MARK_CENTRE_PERCENT / SunWindowConfig.PERCENT, size, state.kind);
    }
}
