import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

// Awake (any screen) or asleep on MIP: the full active window. Asleep on AMOLED
// (requiresBurnInProtection): time only, dim, drifting — TwoSunsView's proven split, reused.
class DayArcView extends WatchUi.WatchFace {
    private var _sources as DayArcSources = new DayArcSources();
    private var _layout as DayArcLayout or Null = null;
    private var _plans as DayArcPlanCache = new DayArcPlanCache();
    private var _sleeping as Boolean = false;
    private var _burnIn as Boolean;

    function initialize() {
        WatchFace.initialize();
        var device = System.getDeviceSettings();
        _burnIn = (device has :requiresBurnInProtection) && device.requiresBurnInProtection;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _layout = new DayArcLayout(dc);
        _plans.reset();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var layout = _layout;
        if (layout == null) {
            return;
        }
        var clock = System.getClockTime();
        var clockText = DayArcFormat.clockTime(clock.hour, clock.min, System.getDeviceSettings().is24Hour);

        if (_sleeping && _burnIn) {
            var grid = DayArcConfig.BURN_IN_GRID;
            var step = layout.driftStep();
            var dx = (clock.min % grid - 1) * step;
            var dy = (clock.min / grid % grid - 1) * step;
            DayArcDraw.renderIdle(dc, layout, clockText, dx, dy);
            return;
        }

        var window = DayArcWindow.windowFor(clock.hour, clock.min);
        var progress = DayArcWindow.progressFor(clock.hour, clock.min);
        var epoch = Time.now().value();
        var hero = DayArcFields.forWindow(window, _sources, epoch);
        var plan = _plans.get(dc, layout, window, hero);
        DayArcDraw.renderActive(dc, layout, window, hero, clockText, progress, plan);
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
