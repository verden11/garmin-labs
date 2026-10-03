import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Test;
import Toybox.Time;
import Toybox.WatchUi;

// Helpers below are (:debug), not (:test): the runner executes every (:test) function as a test,
// and (:debug) code is stripped from release builds, so none of it ships.
//
// The owner's first wrist photo (2026-09-28) showed the evening sub line as "4...": rows stacked
// past the circle's bottom with a negative chord. Font metrics come from the device actually
// running the simulator, NOT from a synthetic bitmap's size, so this test uses the device's own Dc
// and MUST be run once per device (tools/run_tests.sh <device> <jungle>) — a synthetic 320x360 Dc
// under fr965's fonts would produce numbers that are simply wrong. For every window, at each
// window's worst-case strings (fixed 100 / "100 of 100" / the longest empty-state sentence / the
// longest morning sub / the longest date), it asserts: the plan fits; no row is wider than the plain
// chord at its planned y (i.e. nothing renders truncated); the last row ends inside the usable
// area; and the clock box's corners sit inside the arc's inner edge. It LOGS the chosen tier and
// every row's y per device, and, in Pro, how many grid rows fit.
(:test)
function stackFitsWorstCaseOnThisDevice(logger as Test.Logger) as Boolean {
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var failures = "";
    var variants = ["morning-data", "morning-empty", "midday-data", "midday-empty", "evening-data", "evening-empty", "night"] as Array<String>;
    for (var v = 0; v < variants.size(); v++) {
        failures += dayArcCheckVariant(logger, dc, layout, variants[v], v);
    }
    Test.assertMessage(failures.length() == 0, failures);
    return true;
}

(:debug)
function dayArcWorstHero(variant as Number, window as Number) as Dictionary {
    var hero = DayArcFields.forWindow(window, new DayArcSources(), Time.now().value());
    hero.put(:dateText, DayArcConfig.WORST_DATE);
    var empty = variant == 1 || variant == 3 || variant == 5;
    if (window == DayArcConfig.WINDOW_MORNING) {
        hero.put(:label, null);
        hero.put(:value, empty ? "--" : DayArcConfig.WORST_TEMPERATURE);
        hero.put(:sub, empty ? WatchUi.loadResource(Rez.Strings.morning_weather_unavailable) as String : DayArcConfig.WORST_MORNING_SUB);
    } else if (window == DayArcConfig.WINDOW_MIDDAY) {
        hero.put(:value, empty ? "--" : DayArcConfig.WORST_COUNT);
        hero.put(:gauge, empty ? null : 100);
        hero.put(:sub, empty ? WatchUi.loadResource(Rez.Strings.midday_stress_unavailable) as String : null);
    } else if (window == DayArcConfig.WINDOW_EVENING) {
        hero.put(:value, empty ? "--" : DayArcConfig.WORST_COUNT);
        hero.put(:gauge, empty ? null : 100);
        // Pro shows no "N of 100" under the gauge (DayArcFields.batterySub); Simple does.
        hero.put(:sub, empty ? WatchUi.loadResource(Rez.Strings.evening_battery_unavailable) as String
                             : (hero.hasKey(:cells) ? null : Lang.format(WatchUi.loadResource(Rez.Strings.evening_battery_of_100) as String, [100])));
    }
    return hero;
}

(:debug)
function dayArcCheckVariant(logger as Test.Logger, dc as Graphics.Dc, layout as DayArcLayout, name as String, variant as Number) as String {
    var windows = [DayArcConfig.WINDOW_MORNING, DayArcConfig.WINDOW_MORNING, DayArcConfig.WINDOW_MIDDAY, DayArcConfig.WINDOW_MIDDAY,
                   DayArcConfig.WINDOW_EVENING, DayArcConfig.WINDOW_EVENING, DayArcConfig.WINDOW_NIGHT] as Array<Number>;
    var window = windows[variant];
    var hero = dayArcWorstHero(variant, window);
    var plan = DayArcStack.plan(dc, layout, window, hero);
    dayArcLogPlan(logger, dc, layout, name, plan, hero);
    var problems = plan.fits ? "" : name + ": plan does not fit even at the last rung (level " + plan.level + "). ";
    problems += dayArcBottomProblem(dc, plan, layout, name);
    problems += dayArcRowProblems(dc, layout, plan, hero, name);
    if (layout.subscreen() != null) {
        problems += dayArcInstinctProblems(dc, layout, plan, hero, name);
    } else if (window != DayArcConfig.WINDOW_NIGHT) {
        problems += dayArcArcProblem(logger, dc, layout, plan, name);
    }
    return problems;
}

(:debug)
function dayArcLogPlan(logger as Test.Logger, dc as Graphics.Dc, layout as DayArcLayout, name as String, plan as DayArcStack, hero as Dictionary) as Void {
    var rows = "";
    for (var i = 0; i < DayArcStack.ROW_COUNT; i++) {
        rows += " " + i + ":" + plan.ys[i] + "/" + plan.hs[i];
    }
    var gridRows = 0;
    if (hero.hasKey(:cells) && plan.gridTop() >= 0) {
        gridRows = DayArcGrid.draw(dc, layout, plan.gridTop(), hero.get(:cells) as Array<Dictionary>);
    }
    logger.debug("STACK " + dc.getWidth() + "x" + dc.getHeight() + " " + name + " level=" + plan.level + " fits=" + plan.fits
        + " gap=" + plan.gap + " sublines=" + plan.subLineCount + " reservedGridRows=" + plan.gridRows + " rows(y/h)" + rows
        + " bottom=" + dayArcPlanBottom(plan) + " gridTop=" + plan.gridTop() + " gridRows=" + gridRows);
}

// The last row must end inside the display. The limit here is the screen itself (the inscribed
// circle's bottom on a round product), NOT DayArcLayout.gridBottom() — that is the planner's own
// margin, and checking against it would only re-derive the planner's arithmetic.
(:debug)
function dayArcBottomProblem(dc as Graphics.Dc, plan as DayArcStack, layout as DayArcLayout, name as String) as String {
    var round = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND;
    var limit = round ? layout.centerY() + layout.radius() : dc.getHeight();
    var bottom = dayArcPlanBottom(plan);
    return bottom > limit ? name + ": last row ends at " + bottom + " past the display limit " + limit + ". " : "";
}

// The clock box's top corners must sit inside the arc's clear radius (geometry independent of how the
// planner searched for a y).
(:debug)
function dayArcArcProblem(logger as Test.Logger, dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, name as String) as String {
    var half = dc.getTextWidthInPixels(DayArcConfig.WORST_CLOCK, plan.clockFont) / 2.0;
    var dy = layout.centerY() - plan.ys[DayArcStack.ROW_CLOCK];
    var corner = Math.sqrt(half * half + dy * dy);
    logger.debug("ARC " + name + " clock corner distance=" + corner.format("%.1f") + " clearRadius=" + DayArcArc.clearRadius(layout)
        + " arc inner edge=" + (DayArcArc.radius(layout) - DayArcArc.penWidth(layout) / 2));
    if (corner > DayArcArc.clearRadius(layout)) {
        return name + ": clock corner at " + corner.format("%.1f") + " is outside the arc's clear radius " + DayArcArc.clearRadius(layout) + ". ";
    }
    return "";
}

// No planned text row may be wider than the plain chord at its own y/height — the "renders truncated
// to a stub" failure — with the fonts and ys the plan chose (the planner itself used the stricter,
// arc-aware chord; the draw-path test in DayArcPlanTest is the check that does not share its code).
(:debug)
function dayArcRowProblems(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, name as String) as String {
    var problems = "";
    var checks = dayArcRowChecks(dc, layout, plan, hero);
    for (var i = 0; i < checks.size(); i++) {
        var row = checks[i][0];
        var allowed = layout.rowMaxWidth(plan.ys[row], plan.hs[row]);
        if (plan.ys[row] >= 0 && checks[i][1] > allowed) {
            problems += name + ": row " + row + " needs " + checks[i][1] + " but chord allows " + allowed + ". ";
        }
    }
    return problems + dayArcSubProblems(dc, layout, plan, hero, name);
}

(:debug)
function dayArcRowChecks(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary) as Array<Array<Number>> {
    var checks = [
        [DayArcStack.ROW_CLOCK, dc.getTextWidthInPixels(DayArcConfig.WORST_CLOCK, plan.clockFont)],
        [DayArcStack.ROW_DATE, dc.getTextWidthInPixels(DayArcConfig.WORST_DATE, plan.textFont)],
    ] as Array<Array<Number>>;
    var label = hero.get(:label) as String or Null;
    if (label != null && plan.ys[DayArcStack.ROW_LABEL] >= 0) {
        checks.add([DayArcStack.ROW_LABEL, dc.getTextWidthInPixels(label, plan.textFont)]);
    }
    if (plan.ys[DayArcStack.ROW_HERO] >= 0) {
        var icon = WatchUi.loadResource(hero.get(:icon) as ResourceId) as WatchUi.BitmapResource;
        checks.add([DayArcStack.ROW_HERO, icon.getWidth() + layout.heroIconGap() + dc.getTextWidthInPixels(hero.get(:value) as String, plan.heroFont)]);
    }
    return checks;
}

(:debug)
function dayArcSubProblems(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, name as String) as String {
    var sub = hero.get(:sub) as String or Null;
    var subY = plan.ys[DayArcStack.ROW_SUB];
    if (sub == null || subY < 0) {
        return "";
    }
    var problems = "";
    var lines = plan.subLines(dc, sub);
    var lineHeight = dc.getFontHeight(plan.textFont);
    for (var l = 0; l < lines.size(); l++) {
        var allowed = layout.rowMaxWidth(subY + l * lineHeight, lineHeight);
        if (dc.getTextWidthInPixels(lines[l], plan.textFont) > allowed) {
            problems += name + ": sub line " + l + " '" + lines[l] + "' is wider than the chord (" + allowed + "). ";
        }
    }
    return problems;
}

(:debug)
function dayArcPlanBottom(plan as DayArcStack) as Number {
    var last = 0;
    for (var i = 0; i < DayArcStack.ROW_COUNT; i++) {
        if (plan.ys[i] >= 0 && plan.ys[i] + plan.hs[i] > last) {
            last = plan.ys[i] + plan.hs[i];
        }
    }
    return last;
}

// The Instinct (ADR-015): a drawn row must not sit under the window, and no text box may reach outside the circle the
// bezel leaves visible. Boxes include font padding, so the circle check is stricter than the ink; a simulator screenshot
// decides a disputed case. Each planned row is checked at the x range it will be drawn in.
(:debug)
function dayArcInstinctProblems(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, name as String) as String {
    var window = layout.subscreen();
    if (window == null) {
        return "";
    }
    var problems = "";
    var checks = dayArcRowChecks(dc, layout, plan, hero);
    for (var i = 0; i < checks.size(); i++) {
        var row = checks[i][0];
        var y = plan.ys[row];
        if (y < 0) {
            continue;
        }
        var width = checks[i][1];
        var height = plan.hs[row];
        var left = layout.rowCenterX(y, height) - width / 2;
        var right = left + width;
        var clearOfWindow = right <= (window.x as Number) || y >= (window.y as Number) + (window.height as Number) || y + height <= (window.y as Number);
        if (!clearOfWindow) {
            problems += name + ": row " + row + " sits under the window. ";
        }
        var corners = [[left, y], [right, y], [left, y + height], [right, y + height]] as Array<Array<Number>>;
        for (var k = 0; k < corners.size(); k++) {
            var dx = corners[k][0] - dc.getWidth() / 2;
            var dy = corners[k][1] - dc.getHeight() / 2;
            if (dx * dx + dy * dy > DayArcLayout.VISIBLE_RADIUS_PX * DayArcLayout.VISIBLE_RADIUS_PX) {
                problems += name + ": row " + row + " reaches outside the visible circle. ";
                break;
            }
        }
    }
    return problems;
}
