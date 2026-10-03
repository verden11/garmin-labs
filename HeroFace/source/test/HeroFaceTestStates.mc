import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// The widest states the face can show, shared by the screen-fit test and the
// layout report. A class, because the runner treats every (:test) function as
// a test case.
(:test)
class HeroFaceTestStates {

    static function all() as Array<HeroFaceState> {
        return [everyday(), fresh(), heroSet(), heroSetDone()] as Array<HeroFaceState>;
    }

    // A normal day, part way through every goal.
    static function everyday() as HeroFaceState {
        var state = base();
        state.metrics = [
            new HeroFaceMetric(HeroFaceConfig.STEPS, 8420, 10000),
            new HeroFaceMetric(HeroFaceConfig.INTENSITY, 18, 22),
            new HeroFaceMetric(HeroFaceConfig.FLOORS, 7, 10)
        ] as Array<HeroFaceMetric>;
        state.ringPermille = HeroFaceReadings.dayScore(state.metrics);
        state.streakLines = [HeroFaceText.format(Rez.Strings.streak_long, [9999]), HeroFaceText.format(Rez.Strings.streak_short, [9999])] as Array<String>;
        state.streakKept = true;
        return state;
    }

    // Nothing done yet, no streak, no heart rate, wide unit-less values.
    static function fresh() as HeroFaceState {
        var state = base();
        state.heartRate = null;
        state.notifications = 0;
        state.battery = 100;
        state.metrics = [
            new HeroFaceMetric(HeroFaceConfig.STEPS, 0, 10000),
            new HeroFaceMetric(HeroFaceConfig.CALORIES, 2480, 0),
            new HeroFaceMetric(HeroFaceConfig.MOVE, 5, 5)
        ] as Array<HeroFaceMetric>;
        // No streak yet: production shows no streak line at all.
        state.streakLines = [] as Array<String>;
        return state;
    }

    // HeroSet linked, mid-day, with the widest rank and streak it can print.
    static function heroSet() as HeroFaceState {
        var state = base();
        state.metrics = [
            new HeroFaceMetric(HeroFaceConfig.PUSHUPS, 37, HeroFaceConfig.HEROSET_GOAL),
            new HeroFaceMetric(HeroFaceConfig.SITUPS, 52, HeroFaceConfig.HEROSET_GOAL),
            new HeroFaceMetric(HeroFaceConfig.SQUATS, 8, HeroFaceConfig.HEROSET_GOAL)
        ] as Array<HeroFaceMetric>;
        state.ringPermille = 630;
        state.ringColor = HeroFacePalette.GOLD;
        state.streakLines = [HeroFaceText.format(Rez.Strings.rank_streak, [999, 9999]), HeroFaceText.format(Rez.Strings.rank_only, [999])] as Array<String>;
        state.streakKept = true;
        return state;
    }

    // Every mission finished, at HeroSet's largest goal: three check marks,
    // three full bars and the widest counts the bars can print.
    static function heroSetDone() as HeroFaceState {
        var state = heroSet();
        var goal = HeroFaceConfig.HEROSET_MAX_GOAL;
        state.metrics = [
            new HeroFaceMetric(HeroFaceConfig.PUSHUPS, goal, goal),
            new HeroFaceMetric(HeroFaceConfig.SITUPS, goal, goal),
            new HeroFaceMetric(HeroFaceConfig.SQUATS, goal, goal)
        ] as Array<HeroFaceMetric>;
        state.ringPermille = 1000;
        return state;
    }

    private static function base() as HeroFaceState {
        var state = new HeroFaceState();
        // Widest clock, widest date, and a below-zero temperature beside the
        // streak on the row under the time.
        state.time = "00:00";
        state.seconds = "59";
        state.dateLines = ["WED 30 SEP", "WED 30"] as Array<String>;
        state.temperature = "-20°";
        state.battery = 100;
        state.heartRate = 188;
        state.notifications = 99;
        return state;
    }

    // The Instinct's window as [x, y, width, height]; null on every other product.
    static function windowBox() as Array<Number>? {
        var window = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_OCTAGON && (WatchUi has :getSubscreen) ? WatchUi.getSubscreen() : null;
        return window == null ? null : [window.x as Number, window.y as Number, window.width as Number, window.height as Number];
    }

    // Text rows every state must draw: date, time, seconds, temperature, three
    // values, three labels, battery, heart rate, plus the streak when there is
    // one. Notifications are the one item the footer may drop when the ring's
    // gap is too narrow for three.
    static function collect(name as String, state as HeroFaceState, problems as Array<String>) as Void {
        var boxes = HeroFaceDraw.boxes as Array<Array>;
        var window = windowBox();
        // The Instinct has no footer, no temperature and no seconds (ADR-002; the band beside the window is too narrow
        // for the seconds): date, time, three values, three labels.
        var expected = window != null
            ? 8 + (state.streakLines.size() > 0 ? 1 : 0)
            : 10 + (state.temperature != null ? 1 : 0) + (state.streakLines.size() > 0 ? 1 : 0) + (state.heartRate != null ? 1 : 0);
        if (boxes.size() < expected) {
            problems.add("state " + name + " drew " + boxes.size() + " text rows, expected " + expected);
        }
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

    // The bezel hides a semi-octagon display's corners: no text box may reach outside the circle that shows (ADR-002).
    // Boxes include font padding, so this is stricter than the ink; a simulator screenshot decides a disputed case.
    static function collectCorners(name as String, boxes as Array<Array>, problems as Array<String>) as Void {
        var settings = System.getDeviceSettings();
        if (settings.screenShape != System.SCREEN_SHAPE_SEMI_OCTAGON) {
            return;
        }
        var radius = HeroFaceLayout.VISIBLE_RADIUS_PX;
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
