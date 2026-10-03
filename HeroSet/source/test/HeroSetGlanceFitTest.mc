import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

// Glance content areas of the 66 products that can show one (simulator.json
// `glance.contentArea`, SDK 9.2.0), as [screen width, area width, area height].
// The simulator can't be asked for a glance's size at run time, so each run
// checks the rows for the screen width it runs on, with that product's own
// fonts. Every product's own (font, area) pair is therefore covered by running
// the suite on the product itself; one product per width covers the rest with
// a neighbour's font. A class, because the runner treats every (:test)
// function as a test case.
(:test)
class HeroSetGlanceAreas {
    static const ROWS = [
        [166, 154, 61],
        [176, 164, 61],
        [218, 140, 79],
        [240, 151, 63],
        [260, 171, 63],
        [260, 176, 93],
        [260, 198, 81],
        [260, 199, 81],
        [280, 191, 63],
        [280, 216, 88],
        [280, 217, 88],
        [360, 240, 104],
        [360, 249, 115],
        [390, 248, 103],
        [390, 257, 113],
        [390, 257, 125],
        [390, 260, 141],
        [390, 261, 124],
        [390, 274, 128],
        [390, 274, 146],
        [416, 274, 103],
        [416, 275, 120],
        [416, 288, 133],
        [416, 320, 120],
        [416, 320, 130],
        [416, 325, 122],
        [454, 274, 103],
        [454, 299, 130],
        [454, 299, 148],
        [454, 303, 164],
        [454, 312, 103],
        [454, 318, 150],
        [454, 349, 130],
        [466, 359, 130]
    ] as Lang.Array<Lang.Array<Lang.Number>>;

    // The widest states the glance ever draws: goal 500 and a streak the
    // dashboard also has to fit.
    static const WIDEST_STREAK = 9999;
    static const TYPICAL_STREAK = 99;
    // Pills narrower than this can't show progress.
    static const MIN_PILL_WIDTH = 8;
    // Only the row for the running screen width is checked.
    static const MAX_AREA_WIDTH = 360;
    static const MAX_AREA_HEIGHT = 170;

    private static var _bitmap as Graphics.BufferedBitmap?;

    // One bitmap for every draw: one per case exhausted the simulator's
    // graphics memory. Null on the CIQ 3.4 products, which have no glance and
    // no createBufferedBitmap.
    static function dc() as Graphics.Dc? {
        if (!(Graphics has :createBufferedBitmap)) {
            return null;
        }
        if (_bitmap == null) {
            _bitmap = Graphics.createBufferedBitmap({:width => MAX_AREA_WIDTH, :height => MAX_AREA_HEIGHT}).get() as Graphics.BufferedBitmap;
        }
        return (_bitmap as Graphics.BufferedBitmap).getDc();
    }

    static function rowsForThisScreen() as Lang.Array<Lang.Array<Lang.Number>> {
        var screen = System.getDeviceSettings().screenWidth;
        var rows = [] as Lang.Array<Lang.Array<Lang.Number>>;
        for (var i = 0; i < ROWS.size(); i++) {
            if (ROWS[i][0] == screen) {
                rows.add(ROWS[i]);
            }
        }
        return rows;
    }

    static function state(counts as Lang.Number, streak as Lang.Number, goal as Lang.Number) as HeroSetDashboardState {
        return new HeroSetDashboardState(counts, counts, counts, 0, 1, streak, false, goal);
    }

    static function layoutProblems(w as Lang.Number, h as Lang.Number, textHeight as Lang.Number, problems as Lang.Array<Lang.String>) as Void {
        var layout = new HeroSetGlanceLayout(w, h, textHeight);
        var name = w + "x" + h + " font " + textHeight + ": ";
        var o = HeroSetGlanceLayout.OUTLINE;
        if (!layout.fitsHeight()) {
            problems.add(name + "text row + pills taller than the area");
        }
        if (layout.pillTop() + layout.pillHeight() + o > h) {
            problems.add(name + "pills below the area");
        }
        if (layout.pillLeft(2, 3) + layout.pillWidth(3) + o > w) {
            problems.add(name + "pills past the right edge");
        }
        if (layout.pillLeft(0, 3) - o < 0) {
            problems.add(name + "pills past the left edge");
        }
        if (layout.pillWidth(3) < MIN_PILL_WIDTH) {
            problems.add(name + "pills too narrow");
        }
    }

    static function noProblems(logger as Test.Logger, problems as Lang.Array<Lang.String>) as Lang.Boolean {
        for (var i = 0; i < problems.size(); i++) {
            logger.debug("RESULT problem " + problems[i]);
        }
        Test.assertEqual(problems.size(), 0);
        return true;
    }
}

// The layout's rectangles sit inside the area, outline pixel included.
(:test)
function glanceLayoutFitsEveryAreaOnThisScreen(logger as Test.Logger) as Lang.Boolean {
    var dc = HeroSetGlanceAreas.dc();
    if (dc == null) {
        return true;
    }
    var textHeight = dc.getFontHeight(Graphics.FONT_GLANCE);
    var rows = HeroSetGlanceAreas.rowsForThisScreen();
    var problems = [] as Lang.Array<Lang.String>;
    for (var i = 0; i < rows.size(); i++) {
        HeroSetGlanceAreas.layoutProblems(rows[i][1], rows[i][2], textHeight, problems);
    }
    logger.debug("RESULT screen " + System.getDeviceSettings().screenWidth + " areas " + rows.size() + " font height " + textHeight);
    return HeroSetGlanceAreas.noProblems(logger, problems);
}

// The status row's words and check stay inside the padded area in every
// state, at every area on this screen. A typical streak always gets words when
// the mission is open; the widest may fall back to nothing (a 27-year streak),
// which the log records rather than failing.
(:test)
function glanceStatusRowStaysInsideTheAreaOnThisScreen(logger as Test.Logger) as Lang.Boolean {
    var dc = HeroSetGlanceAreas.dc();
    if (dc == null) {
        return true;
    }
    var view = new HeroSetGlanceView();
    var goal = HeroSetConfig.MAX_MISSION_GOAL;
    var textHeight = dc.getFontHeight(Graphics.FONT_GLANCE);
    var rows = HeroSetGlanceAreas.rowsForThisScreen();
    var problems = [] as Lang.Array<Lang.String>;
    for (var i = 0; i < rows.size(); i++) {
        var w = rows[i][1];
        var h = rows[i][2];
        var layout = new HeroSetGlanceLayout(w, h, textHeight);
        var states = [
            HeroSetGlanceAreas.state(0, HeroSetGlanceAreas.TYPICAL_STREAK, goal),
            HeroSetGlanceAreas.state(0, 0, goal),
            HeroSetGlanceAreas.state(goal, HeroSetGlanceAreas.TYPICAL_STREAK, goal),
            HeroSetGlanceAreas.state(goal, HeroSetGlanceAreas.WIDEST_STREAK, goal),
            HeroSetGlanceAreas.state(goal, 0, goal)
        ] as Lang.Array<HeroSetDashboardState>;
        var summary = w + "x" + h;
        for (var s = 0; s < states.size(); s++) {
            var done = s >= 2;
            var plan = view.statusPlan(dc, layout, states[s], done);
            var right = plan[1] + dc.getTextWidthInPixels(plan[0], Graphics.FONT_GLANCE);
            if (plan[0].length() > 0 && right > w - layout.pad()) {
                problems.add(summary + " state " + s + ": words end at " + right + ", past " + (w - layout.pad()));
            }
            if (s == 0 && plan[0].length() == 0) {
                problems.add(summary + ": no words fit for a " + HeroSetGlanceAreas.TYPICAL_STREAK + " day streak");
            }
            if (done && layout.pad() + plan[2] > w - layout.pad()) {
                problems.add(summary + " state " + s + ": check past the right edge");
            }
            summary += " '" + plan[0] + "'";
        }
        logger.debug("RESULT " + summary);
    }
    return HeroSetGlanceAreas.noProblems(logger, problems);
}

// Every state draws without throwing at every area: fonts, resources, math,
// including a count above the goal, a corrupt negative count and the
// smallest goal.
(:test)
function glanceDrawsEveryStateAtEveryAreaOnThisScreen(logger as Test.Logger) as Lang.Boolean {
    var dc = HeroSetGlanceAreas.dc();
    if (dc == null) {
        return true;
    }
    var view = new HeroSetGlanceView();
    var goal = HeroSetConfig.MAX_MISSION_GOAL;
    var states = [
        HeroSetGlanceAreas.state(0, 0, HeroSetConfig.DEFAULT_MISSION_GOAL),
        HeroSetGlanceAreas.state(goal / 2, HeroSetGlanceAreas.TYPICAL_STREAK, goal),
        HeroSetGlanceAreas.state(goal, HeroSetGlanceAreas.WIDEST_STREAK, goal),
        HeroSetGlanceAreas.state(goal + 1, 0, goal),
        HeroSetGlanceAreas.state(-1, 1, goal),
        HeroSetGlanceAreas.state(HeroSetConfig.MIN_MISSION_GOAL - 1, 1, HeroSetConfig.MIN_MISSION_GOAL)
    ] as Lang.Array<HeroSetDashboardState>;
    var rows = HeroSetGlanceAreas.rowsForThisScreen();
    for (var i = 0; i < rows.size(); i++) {
        for (var s = 0; s < states.size(); s++) {
            view.drawState(dc, rows[i][1], rows[i][2], states[s]);
        }
    }
    logger.debug("RESULT drew " + rows.size() * states.size() + " glances on screen " + System.getDeviceSettings().screenWidth);
    return true;
}
