import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;
import Toybox.Time;
import Toybox.WatchUi;

function dayArcTestDc() as Graphics.Dc {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap;
    return bitmap.getDc();
}

// Exercises the real data path (Complications/Weather return whatever the simulator fakes, not
// device truth — this catches a crash or a bad cast, not a device-accuracy claim) and the real
// draw path, for every window, at this device's real resolution. FAILED here means a runtime
// exception, since drawing bad data is still worth catching even though the simulator's own
// values are not device proof. Covers ADR-013's arc/icons/divider/date at three progress
// fractions per window, including 0.0 — the boundary Dc.drawArc treats as "draw a full circle"
// unless DayArcDraw's own guard against it holds (see DayArcLayout.arcProgressEndDegrees).
(:test)
function everyWindowRendersWithoutError(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var sources = new DayArcSources();
    var epoch = Time.now().value();
    var windows = [DayArcConfig.WINDOW_MORNING, DayArcConfig.WINDOW_MIDDAY, DayArcConfig.WINDOW_EVENING, DayArcConfig.WINDOW_NIGHT] as Array<Number>;
    var progressFractions = [0.0, 0.5, 1.0] as Array<Float>;
    for (var i = 0; i < windows.size(); i++) {
        var hero = DayArcFields.forWindow(windows[i], sources, epoch);
        for (var p = 0; p < progressFractions.size(); p++) {
            DayArcDraw.renderActive(dc, layout, windows[i], hero, "12:34", progressFractions[p]);
        }
    }
    DayArcDraw.renderIdle(dc, layout, "12:34", 0, 0);
    return true;
}

// Every icon resource loads and reports the exact pixel size it was generated at (proves the SVG
// resource compiler's viewBox scaling did what DayArcLayout's icon-sized geometry assumes) —
// DayArcLayout.GRID_ICON_SIZE must match every grid_*.svg's own width/height.
(:test)
function iconResourcesLoadAtExpectedSize(logger as Test.Logger) as Boolean {
    var weather = WatchUi.loadResource(Rez.Drawables.IconHeroWeather) as WatchUi.BitmapResource;
    if (weather.getWidth() != 56 or weather.getHeight() != 45) {
        return false;
    }
    var stress = WatchUi.loadResource(Rez.Drawables.IconHeroStress) as WatchUi.BitmapResource;
    if (stress.getWidth() != 52 or stress.getHeight() != 52) {
        return false;
    }
    var battery = WatchUi.loadResource(Rez.Drawables.IconHeroBattery) as WatchUi.BitmapResource;
    if (battery.getWidth() != 68 or battery.getHeight() != 48) {
        return false;
    }
    return true;
}

(:test, :pro)
function gridIconResourcesLoadAtExpectedSize(logger as Test.Logger) as Boolean {
    var ids = [
        Rez.Drawables.IconGridCalendar, Rez.Drawables.IconGridHeart, Rez.Drawables.IconGridBolt,
        Rez.Drawables.IconGridStairs, Rez.Drawables.IconGridSteps, Rez.Drawables.IconGridFlame,
        Rez.Drawables.IconGridBell, Rez.Drawables.IconGridThermometer, Rez.Drawables.IconGridRun,
        Rez.Drawables.IconGridBike, Rez.Drawables.IconGridRefresh, Rez.Drawables.IconGridBreath,
        Rez.Drawables.IconGridDroplet, Rez.Drawables.IconGridBars,
    ] as Array<ResourceId>;
    for (var i = 0; i < ids.size(); i++) {
        var icon = WatchUi.loadResource(ids[i]) as WatchUi.BitmapResource;
        if (icon.getWidth() != DayArcLayout.GRID_ICON_SIZE or icon.getHeight() != DayArcLayout.GRID_ICON_SIZE) {
            return false;
        }
    }
    return true;
}

// A gauge fill narrower than its own rounded-corner radius draws as a distorted blob, not a thin
// bar (TwoSuns hit this exact defect at low fill; code review, 2026-09-28, caught DayArc's own
// gauge had the same unclamped radius). Value 1 of 100 forces a fillWidth well under the gauge's
// height, deterministically, without depending on whatever the simulator fakes for a real reading.
(:test)
function lowGaugeFillDoesNotThrow(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var hero = {:label => "Test", :value => "1", :sub => null, :gauge => 1, :gaugeMax => 100, :icon => DayArcIcons.heroFor(DayArcConfig.WINDOW_MIDDAY)} as Dictionary;
    DayArcDraw.renderActive(dc, layout, DayArcConfig.WINDOW_MIDDAY, hero, "12:34", 0.5);
    return true;
}

// The idle/AOD frame at every drift position in the burn-in grid.
(:test)
function idleFrameRendersAtEveryDrift(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var step = layout.driftStep();
    var grid = DayArcConfig.BURN_IN_GRID;
    for (var minute = 0; minute < grid * grid; minute++) {
        var dx = (minute % grid - 1) * step;
        var dy = (minute / grid % grid - 1) * step;
        DayArcDraw.renderIdle(dc, layout, "12:34", dx, dy);
    }
    return true;
}
