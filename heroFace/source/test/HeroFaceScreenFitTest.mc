import Toybox.ActivityMonitor;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;
import Toybox.WatchUi;

// Renders the face at this device's real resolution and fonts in its widest
// states, and fails if any text leaves the display or two texts overlap
// (HeroSet ADR-034). Run per product: `monkeydo … <device> -t`.
(:test)
function everyStateFitsThisDisplay(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    // createBufferedBitmap is CIQ 4.0+; 3.x products only have the constructor.
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var dc = bitmap.getDc();
    var layout = new HeroFaceLayout(dc);
    var view = new HeroFaceView(new HeroFaceLink());
    var problems = [] as Array<String>;
    HeroFaceDraw.misfits = [] as Array<String>;
    try {
        var states = HeroFaceTestStates.all();
        for (var i = 0; i < states.size(); i++) {
            HeroFaceDraw.boxes = [] as Array<Array>;
            view.drawState(dc, layout, states[i]);
            HeroFaceTestStates.collect(i.toString(), states[i], problems);
        }
    } finally {
        problems.addAll(HeroFaceDraw.misfits as Array<String>);
        HeroFaceDraw.misfits = null;
        HeroFaceDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(settings.screenWidth + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// Prints every row's box on this device, so layout can be checked without a
// screenshot: `monkeydo … -t heroFaceLayoutReport`.
(:test)
function heroFaceLayoutReport(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var dc = bitmap.getDc();
    var layout = new HeroFaceLayout(dc);
    var view = new HeroFaceView(new HeroFaceLink());
    HeroFaceDraw.boxes = [] as Array<Array>;
    view.drawState(dc, layout, HeroFaceTestStates.everyday());
    // Which capability decides whether the face can ship a WatchFaceDelegate,
    // and whether reading the real watch throws on this device.
    logger.debug("WatchFaceDelegate=" + (WatchUi has :WatchFaceDelegate)
        + " Complications=" + (Toybox has :Complications)
        + " Weather=" + (Toybox has :Weather)
        + " hrHistory=" + (ActivityMonitor has :getHeartRateHistory));
    var kinds = HeroFaceMetrics.resolve([0, 0, 0] as Array<Number>, ActivityMonitor.getInfo());
    logger.debug("slots resolved to kinds " + kinds[0] + "/" + kinds[1] + "/" + kinds[2]
        + " (1 steps, 2 kcal, 3 intensity, 4 distance, 5 floors, 6 move)");
    var live = HeroFaceReadings.take(new HeroFaceSettings(), kinds, new HeroFaceStreak(), new HeroFaceLink(), true);
    logger.debug("live time=" + live.time + " date=" + live.dateLines[0] + " temp=" + live.temperature + " streak=" + (live.streakLines.size() > 0 ? live.streakLines[0] : "-")
        + " ring=" + live.ringPermille + " battery=" + live.battery + " hr=" + live.heartRate + " notifications=" + live.notifications);
    view.drawState(dc, layout, live);
    HeroFaceDraw.boxes = [] as Array<Array>;
    logger.debug(settings.screenWidth + "x" + settings.screenHeight
        + " ring r=" + layout.ringRadius() + " w=" + layout.ringWidth()
        + " date=" + layout.topRowTop + " time=" + layout.timeTop
        + " underTime=" + layout.underTimeTop + " missions=" + layout.missionTop
        + " footer=" + layout.footerTop + " column=" + layout.columnWidth);
    var top = layout.topRowTop;
    var line = dc.getFontHeight(Graphics.FONT_XTINY);
    var room = layout.rightInsetWithin(layout.contentRadius(), top, line) - layout.leftInsetWithin(layout.contentRadius(), top, line);
    var samples = ["WED 30 SEP", "WED 30 SEP  -20°", "WED 30", "STREAK 12", "RANK 999  STREAK 9999", "12-DAY STREAK"] as Array<String>;
    var widths = "";
    for (var i = 0; i < samples.size(); i++) {
        widths += "'" + samples[i] + "'=" + dc.getTextWidthInPixels(samples[i], Graphics.FONT_XTINY) + " ";
    }
    logger.debug("top row room=" + room + "  " + widths);
    var boxes = HeroFaceDraw.boxes as Array<Array>;
    for (var i = 0; i < boxes.size(); i++) {
        var b = boxes[i];
        logger.debug("  '" + b[4] + "' x=" + b[0] + " y=" + b[1] + " w=" + b[2] + " h=" + b[3]);
    }
    HeroFaceDraw.boxes = null;
    return true;
}

// Renders the labels of the language the simulator is currently set to, for
// every metric the face can show. Translations are the usual source of text
// that no longer fits, and the English states above cannot catch them: set the
// simulator's language, then run this per language (docs/development.md).
(:test)
function everyLabelFitsThisLanguage(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var dc = bitmap.getDc();
    var layout = new HeroFaceLayout(dc);
    var view = new HeroFaceView(new HeroFaceLink());
    var kinds = [
        HeroFaceConfig.STEPS, HeroFaceConfig.CALORIES, HeroFaceConfig.INTENSITY,
        HeroFaceConfig.DISTANCE, HeroFaceConfig.FLOORS, HeroFaceConfig.MOVE,
        HeroFaceConfig.PUSHUPS, HeroFaceConfig.SITUPS, HeroFaceConfig.SQUATS
    ] as Array<Number>;
    var problems = [] as Array<String>;
    HeroFaceDraw.misfits = [] as Array<String>;
    try {
        // Three at a time, in the widest state each kind can reach.
        for (var i = 0; i < kinds.size(); i += 3) {
            var state = HeroFaceTestStates.everyday();
            var metrics = [] as Array<HeroFaceMetric>;
            for (var j = 0; j < 3; j++) {
                var kind = kinds[(i + j) % kinds.size()];
                var goal = kind == HeroFaceConfig.MOVE ? 5 : 100;
                metrics.add(new HeroFaceMetric(kind, goal, goal));
            }
            state.metrics = metrics;
            // Real streak and rank wordings in this language, at their widest.
            state.streakLines = [
                HeroFaceText.format(Rez.Strings.streak_long, [9999]),
                HeroFaceText.format(Rez.Strings.streak_short, [9999])
            ] as Array<String>;
            HeroFaceDraw.boxes = [] as Array<Array>;
            view.drawState(dc, layout, state);
            HeroFaceTestStates.collect("labels " + i, state, problems);
        }
    } finally {
        problems.addAll(HeroFaceDraw.misfits as Array<String>);
        HeroFaceDraw.misfits = null;
        HeroFaceDraw.boxes = null;
    }
    for (var i = 0; i < problems.size(); i++) {
        logger.debug(settings.screenWidth + "px: " + problems[i]);
    }
    Test.assertEqual(problems.size(), 0);
    return true;
}

// The watch stops granting the partial-update budget and calls
// onPowerBudgetExceeded, which routes to HeroFaceView.disableSeconds(). No
// device can be made to exceed the budget on demand, so this drives the
// fallback directly: with seconds on the face draws a seconds box, and after
// disableSeconds() that box is gone — which is what makes onPartialUpdate
// return early instead of leaving a frozen number beside the time.
(:test)
function disabledSecondsDrawNoSecondsBox(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    // createBufferedBitmap is CIQ 4.0+; 3.x products only have the constructor.
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var dc = bitmap.getDc();
    var layout = new HeroFaceLayout(dc);
    var kinds = HeroFaceMetrics.resolve([0, 0, 0] as Array<Number>, ActivityMonitor.getInfo());

    // A narrow screen skips seconds even when they are on, so ask this device
    // whether a seconds box exists at all before expecting one to disappear.
    var probe = HeroFaceReadings.take(new HeroFaceSettings(), kinds, new HeroFaceStreak(), new HeroFaceLink(), true);
    Test.assert(probe.seconds != null);
    var secondsFit = HeroFaceClock.draw(dc, layout, probe) != null;

    var before = 0;
    var after = 0;
    try {
        Application.Properties.setValue("Seconds", true);
        var view = new HeroFaceView(new HeroFaceLink());
        view.onLayout(dc);
        HeroFaceDraw.boxes = [] as Array<Array>;
        view.onUpdate(dc);
        before = (HeroFaceDraw.boxes as Array<Array>).size();

        view.disableSeconds();
        HeroFaceDraw.boxes = [] as Array<Array>;
        view.onUpdate(dc);
        after = (HeroFaceDraw.boxes as Array<Array>).size();
        // Nothing left to redraw, and the partial update must survive it.
        view.onPartialUpdate(dc);
    } finally {
        HeroFaceDraw.boxes = null;
        Application.Properties.setValue("Seconds", false);
    }
    logger.debug("seconds fit=" + secondsFit + " rows before=" + before + " after=" + after);
    if (secondsFit) {
        Test.assertEqual(after, before - 1);
    } else {
        Test.assertEqual(after, before);
    }
    return true;
}
