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
        + " date=" + layout.topRowTop + " time=" + layout.timeTop + " timeWithSeconds=" + layout.secondsTimeTop
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
    // The number fonts as this device has them (box height, ascent, descent, widest time), for picking the time's size.
    var numbers = [Graphics.FONT_NUMBER_MILD, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_THAI_HOT] as Array<Graphics.FontDefinition>;
    for (var i = 0; i < numbers.size(); i++) {
        logger.debug("number font " + i + " h=" + dc.getFontHeight(numbers[i]) + " ascent=" + Graphics.getFontAscent(numbers[i])
            + " descent=" + Graphics.getFontDescent(numbers[i]) + " '00:00'=" + dc.getTextWidthInPixels("00:00", numbers[i]));
    }
    var boxes = HeroFaceDraw.boxes as Array<Array>;
    for (var i = 0; i < boxes.size(); i++) {
        var b = boxes[i];
        logger.debug("  '" + (b[4] as String) + "' x=" + (b[0] as Number) + " y=" + (b[1] as Number) + " w=" + (b[2] as Number) + " h=" + (b[3] as Number));
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
// return early instead of leaving a frozen number beside the time. Pro only: Free
// has no Seconds key (setValue would throw), no disableSeconds and no onPartialUpdate
// (docs/decisions.md ADR-001, the Free + Pro ladder).
(:test, :pro)
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

// Beside the Instinct's window a row ends left of it (and is centred in what is left); below it, or on any other
// product, rows keep the whole display and the screen's centre (ADR-002).
(:test)
function rowsBesideAWindowStayClearOfIt(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var layout = new HeroFaceLayout(bitmap.getDc());
    var window = layout.subscreen();
    var rowHeight = 18;
    for (var y = 0; y + rowHeight < layout.height(); y += 4) {
        var center = layout.rowCenterX(y, rowHeight);
        if (window == null) {
            Test.assertEqual(center, layout.centerX());
        } else {
            Test.assert(center >= layout.leftInset(y, rowHeight) && center <= layout.rightInset(y, rowHeight));
            if (y < (window.y as Number) + (window.height as Number)) {
                Test.assert(layout.rightInset(y, rowHeight) <= (window.x as Number));
            }
        }
    }
    Test.assert(layout.belowWindow(0) >= (window == null ? 0 : (window.y as Number) + (window.height as Number)));
    return true;
}

// On a rectangle the ring is an open-bottom rounded rectangle (ADR-005): its band stays on the display, an empty share
// fills nothing, any progress fills a pixel, a full share fills the whole path and more progress never fills less.
// Its corners clear the glass evenly, and the time keeps its largest size while no seconds are drawn.
// Every other product keeps its circle or its window gauge.
(:test)
function rectangleRingStaysOnTheDisplay(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var layout = new HeroFaceLayout(bitmap.getDc());
    var frame = layout.frame();
    if (frame == null) {
        Test.assert(settings.screenShape != System.SCREEN_SHAPE_RECTANGLE);
        return true;
    }
    var b = frame.box();
    var half = layout.ringWidth() / 2 + 1;
    Test.assert(b[0] - half >= 0 && b[1] - half >= 0 && b[2] + half <= settings.screenWidth && b[3] + b[4] + half <= settings.screenHeight);
    Test.assert(b[3] > b[1] + b[4] && b[2] - b[0] > 2 * b[4]);
    Test.assertEqual(frame.fillFor(0), 0);
    Test.assert(frame.fillFor(1) >= 1);
    Test.assertEqual(frame.fillFor(1000), frame.length());
    Test.assertEqual(frame.fillFor(1500), frame.length());
    var last = 0;
    for (var p = 0; p <= 1000; p += 50) {
        Test.assert(frame.fillFor(p) >= last);
        last = frame.fillFor(p);
    }
    // Each corner is centred 1.5 insets in (near-concentric with the Venu X1's glass), and the time is never smaller
    // with seconds off than with them on.
    Test.assertEqual(b[0] + b[4], layout.shortInset() * 3 / 2);
    Test.assert(HeroFaceFrame.inkHeight(layout.timeFont) >= HeroFaceFrame.inkHeight(layout.secondsTimeFont));
    logger.debug("frame " + b + " length=" + frame.length() + " time ink=" + HeroFaceFrame.inkHeight(layout.timeFont)
        + " with seconds=" + HeroFaceFrame.inkHeight(layout.secondsTimeFont));
    return true;
}

// Two row rules (2026-10-06, ADR-005 amendment). The gold streak outranks the temperature: a HeroSet row whose streak
// wording fits alone but not beside the temperature keeps the streak and drops the temperature, never the reverse
// (rank-only beside it). And on a rectangle a done label that cannot fit beside its check makes the row drop the check
// (`checkCrowds`); a short one does not, and round and Instinct products never do.
(:test)
function streakOutranksTemperatureAndDoneRowsMatch(logger as Test.Logger) as Boolean {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    var bitmap = (Graphics has :createBufferedBitmap)
        ? Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap
        : new Graphics.BufferedBitmap(size);
    var dc = bitmap.getDc();
    var layout = new HeroFaceLayout(dc);
    var y = layout.underTimeTop;
    var line = dc.getFontHeight(Graphics.FONT_XTINY);
    var room = layout.rightInsetWithin(layout.contentRadius(), y, line) - layout.leftInsetWithin(layout.contentRadius(), y, line);
    var temperature = "-20";
    // A streak wording just too wide to share the row with the temperature, but narrow enough to fit alone.
    var streak = "RANK 9  STREAK 9";
    while (dc.getTextWidthInPixels(streak + "9", Graphics.FONT_XTINY) <= room
            && dc.getTextWidthInPixels(streak, Graphics.FONT_XTINY) + layout.columnGap() + dc.getTextWidthInPixels(temperature, Graphics.FONT_XTINY) <= room) {
        streak += "9";
    }
    var state = HeroFaceTestStates.everyday();
    state.streakLines = [streak, "RANK 9"] as Array<String>;
    state.streakLastDropsStreak = true;
    state.streakKept = true;
    state.temperature = temperature;
    HeroFaceDraw.boxes = [] as Array<Array>;
    var drawn = [] as Array<String>;
    try {
        new HeroFaceView(new HeroFaceLink()).drawState(dc, layout, state);
        var boxes = HeroFaceDraw.boxes as Array<Array>;
        for (var i = 0; i < boxes.size(); i++) {
            drawn.add(boxes[i][4] as String);
        }
    } finally {
        HeroFaceDraw.boxes = null;
    }
    logger.debug("row room=" + room + " drew " + drawn);
    if (layout.subscreen() == null) {
        Test.assert(drawn.indexOf(streak) >= 0);
        Test.assert(drawn.indexOf(temperature) < 0);
        Test.assert(drawn.indexOf("RANK 9") < 0);
    }
    Test.assertEqual(HeroFaceMissions.checkCrowds(dc, layout, ["ATSISPAUDIMAIATSISPAUDIMAI", "ATSISPAUDIMAIATSIS"] as Array<String>), layout.rectangle());
    Test.assert(!HeroFaceMissions.checkCrowds(dc, layout, ["SQT"] as Array<String>));
    return true;
}
