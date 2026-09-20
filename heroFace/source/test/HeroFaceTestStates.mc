import Toybox.Lang;

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
        state.streakLines = ["12-DAY STREAK", "STREAK 12"] as Array<String>;
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
        state.streakLines = ["0-DAY STREAK", "STREAK 0"] as Array<String>;
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
        state.streakLines = ["RANK 999  STREAK 9999", "RANK 999"] as Array<String>;
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

    // Text rows every state must draw: date, time, seconds, temperature, three
    // values, three labels, battery, heart rate, plus the streak when there is
    // one. Notifications are the one item the footer may drop when the ring's
    // gap is too narrow for three.
    static function collect(name as String, state as HeroFaceState, problems as Array<String>) as Void {
        var boxes = HeroFaceDraw.boxes as Array<Array>;
        var expected = 10 + (state.temperature != null ? 1 : 0) + (state.streakLines.size() > 0 ? 1 : 0) + (state.heartRate != null ? 1 : 0);
        if (boxes.size() < expected) {
            problems.add("state " + name + " drew " + boxes.size() + " text rows, expected " + expected);
        }
        for (var i = 0; i < boxes.size(); i++) {
            for (var j = i + 1; j < boxes.size(); j++) {
                var a = boxes[i];
                var b = boxes[j];
                var apart = a[0] + a[2] <= b[0] || b[0] + b[2] <= a[0] || a[1] + a[3] <= b[1] || b[1] + b[3] <= a[1];
                if (!apart) {
                    problems.add("state " + name + " overlap: '" + a[4] + "' and '" + b[4] + "'");
                }
            }
        }
    }
}
