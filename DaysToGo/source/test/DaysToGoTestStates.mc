import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// The widest states the face can show, shared by the screen-fit test and the
// layout report. A class, because the runner treats every (:test) function as
// a test case.
(:test)
class DaysToGoTestStates {

    // Every state that can be widest or tallest somewhere on the face.
    static function all() as Array<DaysToGoState> {
        var states = [] as Array<DaysToGoState>;
        var heroes = [1, 9, 99, 999, 9999, 12775, 99999] as Array<Number>;
        for (var i = 0; i < heroes.size(); i++) {
            states.add(upcoming(heroes[i], 0, "WWWWWWWWWWWWWWWW"));
        }
        states.add(upcoming(76, 0, "Anna and Tom"));
        states.add(upcoming(45, 1, "70.3"));
        states.add(upcoming(41, 1, "WWWWWWWWWWWWWWWW"));
        states.add(upcoming(91, 0, ""));
        states.add(withFooter(upcoming(365, 0, "Race"), "100%"));
        states.add(withFooter(upcoming(12775, 0, "WWWWWWWWWWWWWWWW"), "99.9K"));
        states.add(other(DaysToGoConfig.PHASE_HOURS, 0, 86399, "WWWWWWWWWWWWWWWW"));
        states.add(withFooter(other(DaysToGoConfig.PHASE_HOURS, 0, 86399, "WWWWWWWWWWWWWWWW"), "99.9K"));
        states.add(other(DaysToGoConfig.PHASE_TODAY, 0, 0, "WWWWWWWWWWWWWWWW"));
        states.add(other(DaysToGoConfig.PHASE_PAST, 99999, 0, "WWWWWWWWWWWWWWWW"));
        states.add(withFooter(other(DaysToGoConfig.PHASE_PAST, 99999, 0, "WWWWWWWWWWWWWWWW"), "100%"));
        states.add(other(DaysToGoConfig.PHASE_INVALID, 0, 0, "WWWWWWWWWWWWWWWW"));
        return states;
    }

    static function upcoming(days as Number, unit as Number, name as String) as DaysToGoState {
        var settings = new DaysToGoSettings({"Unit" => unit, "Name" => name, "DateStyle" => 2} as Dictionary);
        return finish(DaysToGoReadings.build(settings, new DaysToGoResult(DaysToGoConfig.PHASE_UPCOMING, days, 0, 2060, 9, 30), 2026, true));
    }

    static function other(phase as Number, days as Number, seconds as Number, name as String) as DaysToGoState {
        var settings = new DaysToGoSettings({"Name" => name, "DateStyle" => 2} as Dictionary);
        return finish(DaysToGoReadings.build(settings, new DaysToGoResult(phase, days, seconds, 2060, 9, 30), 2026, true));
    }

    static function withFooter(state as DaysToGoState, footer as String) as DaysToGoState {
        state.footer = footer;
        state.footerMark = footer.find("%") != null ? DaysToGoConfig.MARK_BATTERY : DaysToGoConfig.MARK_STEPS;
        return state;
    }

    // The widest clock, and (one state's worth) accent white.
    private static function finish(state as DaysToGoState) as DaysToGoState {
        state.time = "12:59";
        return state;
    }

    // The Instinct's window as [x, y, width, height]; null on every other product.
    static function windowBox() as Array<Number>? {
        var window = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON && (WatchUi has :getSubscreen) ? WatchUi.getSubscreen() : null;
        return window == null ? null : [window.x as Number, window.y as Number, window.width as Number, window.height as Number];
    }

    // Two texts must not overlap, and the hero must have been drawn.
    static function collect(name as String, state as DaysToGoState, problems as Array<String>) as Void {
        var boxes = DaysToGoDraw.boxes as Array<Array>;
        if (boxes.size() < 2) {
            problems.add("state " + name + " drew " + boxes.size() + " text rows, expected at least the time and the hero");
        }
        var window = windowBox();
        for (var i = 0; i < boxes.size() && window != null; i++) {
            // Text must not sit under the Instinct's window (the round chord check cannot see it).
            var t = boxes[i];
            var clear = t[0] + t[2] <= window[0] || window[0] + window[2] <= t[0] || t[1] + t[3] <= window[1] || window[1] + window[3] <= t[1];
            if (!clear) {
                problems.add("state " + name + " window overlap: '" + (t[4] as String) + "'");
            }
        }
        collectCorners(name, boxes, problems);
        for (var i = 0; i < boxes.size(); i++) {
            for (var j = i + 1; j < boxes.size(); j++) {
                var a = boxes[i];
                var b = boxes[j];
                var apart = a[0] + a[2] <= b[0] || b[0] + b[2] <= a[0] || a[1] + a[3] <= b[1] || b[1] + b[3] <= a[1];
                if (!apart) {
                    problems.add("state " + name + " overlap: '" + (a[4] as String) + "' and '" + (b[4] as String) + "'");
                }
            }
        }
    }

    // The bezel hides a semi-octagon display's corners: no text box may reach outside the circle that shows (ADR-015).
    // Boxes include font padding, so this is stricter than the ink; a simulator screenshot decides a disputed case.
    static function collectCorners(name as String, boxes as Array<Array>, problems as Array<String>) as Void {
        var settings = System.getDeviceSettings();
        if (settings.screenShape != System.SCREEN_SHAPE_SEMI_OCTAGON) {
            return;
        }
        var radius = DaysToGoLayout.VISIBLE_RADIUS_PX;
        for (var i = 0; i < boxes.size(); i++) {
            var box = boxes[i] as Array;
            for (var k = 0; k < 4; k++) {
                var dx = (box[0] as Number) + (k % 2 == 0 ? 0 : box[2] as Number) - settings.screenWidth / 2;
                var dy = (box[1] as Number) + (k < 2 ? 0 : box[3] as Number) - settings.screenHeight / 2;
                if (dx * dx + dy * dy > radius * radius) {
                    problems.add("state " + name + " corner: '" + (box[4] as String) + "'");
                    break;
                }
            }
        }
    }
}
