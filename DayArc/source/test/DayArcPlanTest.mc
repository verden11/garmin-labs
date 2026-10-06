import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Test;
import Toybox.WatchUi;

// Tests of the parts the 2026-09-28 third review found unsafe: a cached plan meeting live strings it
// wasn't sized for, a plan that fits nowhere, a truncation stub, and the real draw path with LIVE
// strings. All use the running device's own Dc and fonts (run per device, tools/run_tests.sh).

// truncated() never returns a bare stub: for every max width the result is the whole string, or at
// least one character plus "..." that fits, or "" (nothing drawn).
(:test)
function truncatedNeverReturnsABareStub(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var font = DayArcLayout.LABEL_FONTS[1];
    var samples = ["44 of 100", "Stress unavailable right now", "4"] as Array<String>;
    for (var s = 0; s < samples.size(); s++) {
        var full = dc.getTextWidthInPixels(samples[s], font);
        for (var max = -5; max <= full + 5; max++) {
            var result = DayArcText.truncated(dc, samples[s], font, max);
            var whole = result.equals(samples[s]);
            var ellipsised = result.length() >= 4 && dc.getTextWidthInPixels(result, font) <= max;
            Test.assertMessage(result.length() == 0 || whole || ellipsised, "'" + samples[s] + "' at max " + max + " gave stub '" + result + "'");
            Test.assertMessage(result.length() == 0 || dc.getTextWidthInPixels(result, font) <= max, "'" + result + "' overflows " + max);
        }
    }
    return true;
}

// A cached plan drawn against live strings it was not built for must never throw: the date null for
// one update, and strings far wider than the sizing strings.
(:test)
function stalePlanNeverThrows(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var window = DayArcConfig.WINDOW_EVENING;
    var plan = DayArcStack.plan(dc, layout, window, dayArcLiveHero(window, "Mon 28", "44 of 100"));
    var noDate = dayArcLiveHero(window, null, "44 of 100");
    DayArcDraw.renderActive(dc, layout, window, noDate, "12:34", 0.5, plan);
    var long = "an unexpectedly long string that no plan was sized for at all";
    var wide = dayArcLiveHero(window, long, long);
    DayArcDraw.renderActive(dc, layout, window, wide, "12:34", 0.5, plan);
    Test.assertMessage(!DayArcSizing.covers(dc, plan.strings, wide), "a much wider live hero must not be 'covered'");
    return true;
}

// The cache rebuilds when a live string flips null <-> present or turns out wider, and reuses the
// plan otherwise.
(:test)
function planCacheRebuildsOnLiveChanges(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var cache = new DayArcPlanCache();
    var window = DayArcConfig.WINDOW_EVENING;
    var first = cache.get(dc, layout, window, dayArcLiveHero(window, "Mon 28", "44 of 100"));
    Test.assertMessage(cache.get(dc, layout, window, dayArcLiveHero(window, "Tue 29", "44 of 100")) == first, "same rows, same plan");
    var undated = cache.get(dc, layout, window, dayArcLiveHero(window, null, "44 of 100"));
    Test.assertMessage(undated != first && undated.ys[DayArcStack.ROW_DATE] < 0, "date gone -> plan without a date row");
    var redated = cache.get(dc, layout, window, dayArcLiveHero(window, "Mon 28", "44 of 100"));
    Test.assertMessage(redated.ys[DayArcStack.ROW_DATE] >= 0, "date back -> the date row must return");
    var long = "an unexpectedly long string that no plan was sized for at all";
    var wider = cache.get(dc, layout, window, dayArcLiveHero(window, long, long));
    Test.assertMessage(wider != redated, "a wider live string must replan");
    return true;
}

// Pro's grid values are part of the plan too (1.17): a value that grows wider (steps 999 -> 1000) replans, a narrower one or a
// wider calendar title (:flex) keeps the plan.
(:test)
function planCacheReplansWhenAGridValueGetsWider(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var cache = new DayArcPlanCache();
    var window = DayArcConfig.WINDOW_EVENING;
    var first = cache.get(dc, layout, window, dayArcCellsHero(window, "99", "x"));
    Test.assertMessage(cache.get(dc, layout, window, dayArcCellsHero(window, "9", "x")) == first, "a narrower grid value keeps the plan");
    Test.assertMessage(cache.get(dc, layout, window, dayArcCellsHero(window, "99", "a much longer calendar title")) == first, "a calendar title never replans");
    Test.assertMessage(cache.get(dc, layout, window, dayArcCellsHero(window, "99999", "x")) != first, "a wider grid value must replan");
    return true;
}

// The grid is planned for four digits (WORST_CELL_VALUE); a fifth (steps 10000) rebuilds the plan. Whether the rung moves when it
// does is LOGGED per device (FIVEDIGITS lines, every cell at five digits: harsher than a real day, where only steps get there),
// not asserted: on the smaller screens it does (ADR-017, reviewer pass nine); the assertion is that the plan still fits.
(:test)
function planAtFiveDigitsStillFits(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var windows = [DayArcConfig.WINDOW_MORNING, DayArcConfig.WINDOW_MIDDAY, DayArcConfig.WINDOW_EVENING] as Array<Number>;
    var moved = "";
    for (var w = 0; w < windows.size(); w++) {
        var four = dayArcWorstHero(2 * w, windows[w]);
        if (!four.hasKey(:cells)) {
            continue;   // Simple has no grid
        }
        var five = dayArcWorstHero(2 * w, windows[w]);
        dayArcSetCellValues(four, DayArcConfig.WORST_CELL_VALUE);
        dayArcSetCellValues(five, DayArcConfig.WORST_CELL_VALUE + "8");
        var planFour = DayArcStack.plan(dc, layout, windows[w], four);
        var planFive = DayArcStack.plan(dc, layout, windows[w], five);
        logger.debug("FIVEDIGITS " + dc.getWidth() + "x" + dc.getHeight() + " window " + w + " level " + planFour.level + " -> " + planFive.level
            + " gridRows " + planFour.gridRows + " -> " + planFive.gridRows);
        if (!planFive.fits) {
            moved += "window " + w + " does not fit at five digits (rung " + planFive.level + "). ";
        }
    }
    Test.assertMessage(moved.length() == 0, moved);
    return true;
}

(:debug)
function dayArcSetCellValues(hero as Dictionary, value as String) as Void {
    var cells = hero.get(:cells) as Array<Dictionary>;
    for (var i = 0; i < cells.size(); i++) {
        if (!cells[i].hasKey(:flex)) {
            cells[i].put(:value, value);
        }
    }
}

(:debug)
function dayArcCellsHero(window as Number, steps as String, title as String) as Dictionary {
    var hero = dayArcLiveHero(window, "Mon 28", "44 of 100");
    hero.put(:cells, [{:label => null, :value => steps}, {:label => null, :value => title, :flex => true}] as Array<Dictionary>);
    return hero;
}

// A plan that fits nowhere (a 40x40 Dc, far too small for any font tier) is still safe to draw: no
// row whose bottom crosses the usable bottom survives, and drawing throws nothing.
(:test)
function planThatFitsNowhereDrawsOnlyInsideTheLimit(logger as Test.Logger) as Boolean {
    var tiny = Graphics.createBufferedBitmap({:width => 40, :height => 40}).get() as Graphics.BufferedBitmap;
    var dc = tiny.getDc();
    var layout = new DayArcLayout(dc);
    var window = DayArcConfig.WINDOW_EVENING;
    var hero = dayArcLiveHero(window, "Mon 28", "44 of 100");
    var plan = DayArcStack.plan(dc, layout, window, hero);
    Test.assertMessage(!plan.fits, "a 40px display cannot really fit the stack");
    for (var i = 0; i < DayArcStack.ROW_COUNT; i++) {
        Test.assertMessage(plan.ys[i] < 0 || plan.ys[i] + plan.hs[i] <= layout.gridBottom(), "row " + i + " crosses the usable bottom");
    }
    DayArcDraw.renderActive(dc, layout, window, hero, "12:34", 0.5, plan);
    return true;
}

// The owner's exact case and every other window's live strings, through the REAL draw path: nothing
// may be shortened or dropped (DayArcText.truncatedCount, a debug hook, counts every truncation).
(:test)
function liveStringsRenderWithoutTruncation(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var cache = new DayArcPlanCache();
    var cases = dayArcLiveCases();
    for (var i = 0; i < cases.size(); i++) {
        var hero = cases[i][1] as Dictionary;
        var window = cases[i][0] as Number;
        DayArcText.truncatedCount = 0;
        DayArcDraw.renderActive(dc, layout, window, hero, "22:35", 0.5, cache.get(dc, layout, window, hero));
        logger.debug("LIVE " + dc.getWidth() + "x" + dc.getHeight() + " case " + i + " window " + window + " truncations=" + DayArcText.truncatedCount);
        Test.assertMessage(DayArcText.truncatedCount == 0, "case " + i + " (window " + window + ") had " + DayArcText.truncatedCount + " truncated string(s)");
    }
    return true;
}

// A two-line sub plan must not split a live string that fits one line ("Weather unavailable").
(:test)
function subWrapsOnlyWhenTheLiveStringDoesNotFit(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var window = DayArcConfig.WINDOW_MORNING;
    var plan = DayArcStack.plan(dc, layout, window, dayArcLiveHero(window, "Mon 28", DayArcConfig.WORST_MORNING_SUB));
    var short = WatchUi.loadResource(Rez.Strings.morning_weather_unavailable) as String;
    var y = plan.ys[DayArcStack.ROW_SUB];
    var fitsOne = plan.subLineCount == 1 || dc.getTextWidthInPixels(short, plan.textFont) <= plan.rowWidth(y, dc.getFontHeight(plan.textFont));
    Test.assertMessage(!fitsOne || plan.subLines(dc, short).size() == 1, "'" + short + "' fits one line but was split");
    return true;
}

(:debug)
function dayArcLiveHero(window as Number, date as String or Null, sub as String) as Dictionary {
    var hero = {:label => window == DayArcConfig.WINDOW_MORNING ? null : "Label", :value => "44", :sub => sub, :dateText => date,
                :icon => DayArcIcons.heroFor(window, DayArcConfig.ACCENT_AUTO)} as Dictionary;
    if (window != DayArcConfig.WINDOW_MORNING) {
        hero.put(:gauge, 44);
        hero.put(:gaugeMax, 100);
    }
    return hero;
}

// [window, hero] pairs of realistic LIVE strings — no :cells, so only the hero block is asserted.
(:debug)
function dayArcLiveCases() as Array<Array<Object>> {
    var morning = DayArcConfig.WINDOW_MORNING;
    var midday = DayArcConfig.WINDOW_MIDDAY;
    var evening = DayArcConfig.WINDOW_EVENING;
    var battery = Lang.format(WatchUi.loadResource(Rez.Strings.evening_battery_of_100) as String, [44]);
    return [
        [evening, dayArcLiveHero(evening, "Mon 28", battery)],
        [evening, {:label => "Body Battery", :value => "--", :sub => WatchUi.loadResource(Rez.Strings.evening_battery_unavailable) as String,
                   :dateText => "Mon 28", :icon => DayArcIcons.heroFor(evening, 0)} as Dictionary],
        [midday, {:label => "Stress", :value => "37", :gauge => 37, :gaugeMax => 100, :dateText => "Mon 28", :icon => DayArcIcons.heroFor(midday, 0)} as Dictionary],
        [midday, {:label => "Stress", :value => "--", :sub => WatchUi.loadResource(Rez.Strings.midday_stress_unavailable) as String,
                  :dateText => "Mon 28", :icon => DayArcIcons.heroFor(midday, 0)} as Dictionary],
        [morning, {:label => WatchUi.loadResource(Rez.Strings.morning_feels_label) as String, :value => "-12°", :sub => "55/43  30% rain  UV 4", :dateText => "Mon 28", :icon => DayArcIcons.heroFor(morning, 0)} as Dictionary],
        [morning, {:label => null, :value => null, :sub => WatchUi.loadResource(Rez.Strings.morning_weather_unavailable) as String,
                   :dateText => "Mon 28", :icon => DayArcIcons.heroFor(morning, 0)} as Dictionary],
        [DayArcConfig.WINDOW_NIGHT, {:dateText => "Mon 28"} as Dictionary],
    ] as Array<Array<Object>>;
}
