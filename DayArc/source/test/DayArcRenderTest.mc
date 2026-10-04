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
// unless DayArcArc.draw's own guard against it holds. Logs memory after the renders (ADR-014 added
// 18 hero icon bitmaps): a simulator number, not a device one, and a test build is larger than a
// release build.
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
        var plan = DayArcStack.plan(dc, layout, windows[i], hero);
        for (var p = 0; p < progressFractions.size(); p++) {
            DayArcDraw.renderActive(dc, layout, windows[i], hero, "12:34", progressFractions[p], plan);
        }
    }
    DayArcDraw.renderIdle(dc, layout, "12:34", 0, 0);
    var stats = System.getSystemStats();
    logger.debug("MEMORY " + dc.getWidth() + "x" + dc.getHeight() + " used=" + stats.usedMemory + " free=" + stats.freeMemory + " total=" + stats.totalMemory);
    return true;
}

// Every hero icon resource, both sizes (ADR-017), 3 icons x 6 hues, reached through every window x every accent choice, Auto
// included, loads. Round and rectangular screens: the sets follow the screen, so the test asserts the RELATION, not a size
// table (ROADMAP 1.12: a fixed 48 px was too big on a 218 px screen and thin and small on a 454 px one). The LARGE icon sits
// beside the HOT number tier and is about as tall as its digits; the SMALL one sits beside MEDIUM and MILD, so it may not be
// taller than the MEDIUM digits (by more than a share) nor shorter than the MILD ones. A digit's height is the font box's
// estimate (DayArcConfig.DIGIT_HEIGHT_PERMILLE). The Instinct has its own half-size set (resources-instinct, ADR-016).
(:test)
function everyHeroIconLoadsAtExpectedSize(logger as Test.Logger) as Boolean {
    var windows = [DayArcConfig.WINDOW_MORNING, DayArcConfig.WINDOW_MIDDAY, DayArcConfig.WINDOW_EVENING] as Array<Number>;
    var instinct = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON;
    var dc = dayArcTestDc();
    var digits = [] as Array<Number>;
    for (var f = 0; f < DayArcLayout.HERO_FONTS.size(); f++) {
        digits.add(DayArcText.inkHeight(dc, DayArcLayout.HERO_FONTS[f]) * DayArcConfig.DIGIT_HEIGHT_PERMILLE / 1000);
    }
    for (var w = 0; w < windows.size(); w++) {
        for (var choice = 0; choice < DayArcConfig.ACCENT_CHOICES; choice++) {
            for (var slot = 0; slot < 2; slot++) {
                var id = slot == 0 ? DayArcIcons.heroFor(windows[w], choice) : DayArcIcons.heroSmallFor(windows[w], choice);
                Test.assertMessage(id != null, "no hero icon for window " + windows[w] + " choice " + choice);
                var icon = WatchUi.loadResource(id as ResourceId) as WatchUi.BitmapResource;
                var size = icon.getWidth() + "x" + icon.getHeight();
                if (instinct) {
                    var widths = [30, 24, 36] as Array<Number>;
                    Test.assertMessage(icon.getWidth() == widths[w] and icon.getHeight() == 24, "window " + windows[w] + " is " + size);
                } else if (choice == 0) {
                    dayArcCheckHeroIconSize(logger, windows[w], slot, size, icon.getHeight(), digits);
                }
            }
        }
    }
    Test.assertMessage(DayArcIcons.heroFor(DayArcConfig.WINDOW_NIGHT, 0) == null, "night must have no hero icon");
    Test.assertMessage(DayArcIcons.heroSmallFor(DayArcConfig.WINDOW_NIGHT, 0) == null, "night must have no small hero icon");
    return true;
}

(:debug)
function dayArcCheckHeroIconSize(logger as Test.Logger, window as Number, slot as Number, size as String, height as Number, digits as Array<Number>) as Void {
    var hot = height * 1000 / digits[0];
    var medium = height * 1000 / digits[1];
    var mild = height * 1000 / digits[2];
    logger.debug("HEROICON window " + window + (slot == 0 ? " large " : " small ") + size + " digits(hot/medium/mild)=" + digits[0] + "/" + digits[1] + "/" + digits[2]
        + " share=" + hot + "/" + medium + "/" + mild);
    if (slot == 0) {
        Test.assertMessage(hot >= DayArcConfig.HERO_ICON_MIN_PERMILLE and hot <= DayArcConfig.HERO_ICON_MAX_PERMILLE,
            "window " + window + " large icon " + size + " is " + hot + " per mille of the HOT digits' " + digits[0] + " px");
    } else {
        Test.assertMessage(medium <= DayArcConfig.HERO_ICON_MAX_PERMILLE and mild >= DayArcConfig.HERO_ICON_MIN_PERMILLE,
            "window " + window + " small icon " + size + " is " + medium + " per mille of the MEDIUM and " + mild + " of the MILD digits");
    }
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
    var hero = {:label => "Test", :value => "1", :sub => null, :gauge => 1, :gaugeMax => 100, :icon => DayArcIcons.heroFor(DayArcConfig.WINDOW_MIDDAY, 0)} as Dictionary;
    DayArcDraw.renderActive(dc, layout, DayArcConfig.WINDOW_MIDDAY, hero, "12:34", 0.5, DayArcStack.plan(dc, layout, DayArcConfig.WINDOW_MIDDAY, hero));
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
