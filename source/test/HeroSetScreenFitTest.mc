import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

// Renders every app screen at this device's real resolution and fonts, and
// fails if any text box pokes outside the round display or overlaps another
// text box on the same screen (ADR-034). Run the suite once per supported
// product: `monkeydo … <device> -t`. States are the widest each screen can
// show: RANK 999, 9999-day streak, 100/100 counts, storage warning, 3-digit
// workout and picker values, a full validation log page.
// (:debug) too: it needs the (:debug) test hooks, which store.jungle strips,
// so the store-build test run skips this test (the dev run covers it).
(:test :debug)
function everyScreenFitsThisDisplay(logger as Test.Logger) as Lang.Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    // createBufferedBitmap is Connect IQ 4.0+; 3.4 products (ADR-038) only have the constructor.
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var dc = bitmap.getDc();
    var problems = [] as Lang.Array<Lang.String>;
    var appStore = getApp().swapStoreForTest(HeroSetScreenFitHarness.seededStore());
    HeroSetDraw.misfits = [] as Lang.Array<Lang.String>;
    try {
        var dashboard = new HeroSetView();
        var states = [
            new HeroSetDashboardState(0, 0, 0, 0, 1, 0, false),
            new HeroSetDashboardState(42, 100, 7, 4200, 61, 12, false),
            new HeroSetDashboardState(100, 100, 100, 999999, 999, 9999, false),
            new HeroSetDashboardState(100, 55, 100, 999999, 999, 9999, true)
        ] as Lang.Array<HeroSetDashboardState>;
        for (var i = 0; i < states.size(); i++) {
            HeroSetScreenFitHarness.startScreen();
            dashboard.drawState(dc, states[i]);
            // RANK, XP to next, 3 labels, 3 counts, streak, footer.
            HeroSetScreenFitHarness.collectOverlaps("dashboard", 10, problems);
        }
        var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
        for (var e = 0; e < exercises.size(); e++) {
            var workout = new HeroSetWorkoutView(exercises[e]);
            workout.setCountsForTest(888, 99);
            HeroSetScreenFitHarness.renderScreen(workout, dc, "workout", 5, problems);
            HeroSetScreenFitHarness.renderScreen(new HeroSetManualPickerView(exercises[e], -99, 888, 889, null), dc, "picker", 6, problems);
            HeroSetScreenFitHarness.renderScreen(new HeroSetManualPickerView(exercises[e], 100, null, null, null), dc, "picker", 5, problems);
        }
        HeroSetScreenFitHarness.renderScreen(new HeroSetValidationLogView(), dc, "validation log", 5, problems);
    } finally {
        getApp().swapStoreForTest(appStore);
        problems.addAll(HeroSetDraw.misfits as Lang.Array<Lang.String>);
        HeroSetDraw.misfits = null;
        HeroSetDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(settings.screenWidth + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}
