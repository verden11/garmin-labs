import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Test;

// The rectangle's square design (ADR-019), on the device running the test (venusq2, venusq2m, venux1; every other shape
// passes trivially). Independent geometry, not the drawing code's own: the track stays on the glass, its window is the round
// arc's share of the path, every planned row and the gauge bar sit inside the inner box and its rounded corners.

// The glass corner, as a circle radius in px fitted to the SDK skin's alpha (2026-10-05: the Venu X1's superellipse matches a
// 66 px circle from row 8 down, the Venu Sq 2's is about 8 px). A test constant: the face never knows the glass.
(:debug)
function dayArcGlassCorner(width as Number) as Number {
    return width >= 448 ? 66 : 8;
}

(:debug)
function dayArcIsRect() as Boolean {
    return System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE;
}

// True when (x, y) is inside a box inset `edge` from the screen with corners of radius `r`, by at least `margin` px.
(:debug)
function dayArcInsideRounded(w as Number, h as Number, edge as Number, r as Number, x as Float, y as Float, margin as Number) as Boolean {
    var left = edge + margin;
    var top = edge + margin;
    if (x < left || y < top || x > w - left || y > h - top) {
        return false;
    }
    var cx = x < w / 2 ? edge + r : w - edge - r;
    var cy = y < h / 2 ? edge + r : h - edge - r;
    var inCornerX = x < w / 2 ? x < cx : x > cx;
    var inCornerY = y < h / 2 ? y < cy : y > cy;
    if (!(inCornerX && inCornerY)) {
        return true;
    }
    var dx = x - cx;
    var dy = y - cy;
    return Math.sqrt(dx * dx + dy * dy) <= r - margin;
}

(:test)
function rectangleTrackStaysOnTheGlass(logger as Test.Logger) as Boolean {
    if (!dayArcIsRect()) {
        return true;
    }
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var w = dc.getWidth();
    var h = dc.getHeight();
    var pen = DayArcArc.penWidth(layout);
    var c = DayArcRect.inset(layout);
    var r = DayArcRect.corner(layout);
    var outer = r + pen / 2 + 1;
    var glass = dayArcGlassCorner(w);
    // The outer edge of the stroke along both top corners, every 5 degrees, at least 2 px inside the glass.
    for (var deg = 0; deg <= 90; deg += 5) {
        var rad = Math.toRadians(deg);
        var x = ((c + r) - outer * Math.cos(rad)).toFloat();
        var y = ((c + r) - outer * Math.sin(rad)).toFloat();
        Test.assertMessage(dayArcInsideRounded(w, h, 0, glass, x, y, 2), "track corner at " + deg + " deg leaves the glass: " + x + "," + y);
        Test.assertMessage(dayArcInsideRounded(w, h, 0, glass, w - x, y, 2), "right track corner at " + deg + " deg leaves the glass");
    }
    Test.assertMessage(c - pen / 2 >= 1, "the straight runs touch the screen edge");
    var s = DayArcRect.segments(layout);
    var perimeter = 2 * (w - 2 * c + h - 2 * c) - 8 * r + 2 * Math.PI * r;
    var share = DayArcRect.length(layout) / perimeter;
    var expected = DayArcConfig.ARC_SPAN_DEGREES / 360.0;
    logger.debug("RECT " + w + "x" + h + " inset=" + c + " pen=" + pen + " corner=" + r + " segments=" + s + " share=" + share.format("%.3f")
        + " tipsY=" + DayArcRect.lowestY(layout) + " innerInset=" + DayArcRect.innerInset(layout) + " innerCorner=" + DayArcRect.innerCorner(layout));
    Test.assertMessage((share - expected).abs() < 0.01, "the window is " + share + " of the track, the round arc spans " + expected);
    Test.assertMessage(s[0] > 0 && s[0] == s[4], "the window does not reach equally down both sides");
    Test.assertMessage(DayArcRect.lowestY(layout) < h / 2, "the window's tips reach past the screen's middle");
    return true;
}

// Every planned row of every window (worst-case strings, DayArcStackTest's heroes) and the gauge bar sit inside the inner box,
// corners included, with the clock's box clear of the track's inner edge.
(:test)
function rectangleRowsAndBarStayInTheInnerBox(logger as Test.Logger) as Boolean {
    if (!dayArcIsRect()) {
        return true;
    }
    var dc = dayArcTestDc();
    var layout = new DayArcLayout(dc);
    var failures = "";
    for (var v = 0; v < 7; v++) {
        var window = v == 6 ? DayArcConfig.WINDOW_NIGHT : (v < 2 ? DayArcConfig.WINDOW_MORNING : (v < 4 ? DayArcConfig.WINDOW_MIDDAY : DayArcConfig.WINDOW_EVENING));
        var hero = dayArcWorstHero(v, window);
        var plan = DayArcStack.plan(dc, layout, window, hero);
        failures += dayArcRectRowProblems(dc, layout, plan, hero, "variant " + v);
        var gaugeY = plan.ys[DayArcStack.ROW_GAUGE];
        if (gaugeY >= 0) {
            var barTop = DayArcRect.gaugeTop(layout, gaugeY);
            var box = DayArcRect.gaugeBox(layout, barTop);
            var bottom = (barTop + layout.gaugeHeight()).toFloat();
            var inside = dayArcInsideRounded(dc.getWidth(), dc.getHeight(), DayArcRect.innerInset(layout), DayArcRect.innerCorner(layout), box[0].toFloat(), bottom, 0)
                && dayArcInsideRounded(dc.getWidth(), dc.getHeight(), DayArcRect.innerInset(layout), DayArcRect.innerCorner(layout), (box[0] + box[1]).toFloat(), bottom, 0);
            failures += inside && box[1] > layout.gaugeHeight() ? "" : "variant " + v + ": gauge bar " + box + " at y=" + gaugeY + " leaves the inner box. ";
        }
    }
    Test.assertMessage(failures.length() == 0, failures);
    return true;
}

(:debug)
function dayArcRectRowProblems(dc as Graphics.Dc, layout as DayArcLayout, plan as DayArcStack, hero as Dictionary, name as String) as String {
    var problems = "";
    var checks = dayArcRowChecks(dc, layout, plan, hero);
    var edge = DayArcRect.innerInset(layout);
    var r = DayArcRect.innerCorner(layout);
    for (var i = 0; i < checks.size(); i++) {
        var y = plan.ys[checks[i][0]];
        if (y < 0) {
            continue;
        }
        var left = (layout.centerX() - checks[i][1] / 2).toFloat();
        var right = (layout.centerX() + checks[i][1] / 2).toFloat();
        var bottom = (y + plan.hs[checks[i][0]]).toFloat();
        var corners = [[left, y.toFloat()], [right, y.toFloat()], [left, bottom], [right, bottom]] as Array<Array<Float>>;
        for (var k = 0; k < corners.size(); k++) {
            if (!dayArcInsideRounded(dc.getWidth(), dc.getHeight(), edge, r, corners[k][0], corners[k][1], 0)) {
                problems += name + ": row " + checks[i][0] + " corner " + k + " leaves the inner box. ";
                break;
            }
        }
    }
    return problems;
}
