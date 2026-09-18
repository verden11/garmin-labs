import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Shared steps for HeroSetScreenFitTest. A class, because the test runner
// treats every (:test) function as a test case.
(:test :debug)
class HeroSetScreenFitHarness {

    // 99 of each exercise already saved today, and a full log of the widest lines.
    static function seededStore() as HeroSetStore {
        var store = new HeroSetStore(new HeroSetTestStorage(), new HeroSetTestClock());
        var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
        for (var e = 0; e < exercises.size(); e++) {
            store.add(exercises[e], 99);
        }
        for (var i = 0; i < HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES; i++) {
            store.logValidationTrial(exercises[i % 3], 888, 100);
        }
        return store;
    }

    static function startScreen() as Void {
        HeroSetDraw.boxes = [] as Lang.Array<Lang.Array>;
    }

    static function renderScreen(view as WatchUi.View, dc as Graphics.Dc, name as Lang.String, expectedRows as Lang.Number, problems as Lang.Array<Lang.String>) as Void {
        startScreen();
        view.onUpdate(dc);
        collectOverlaps(name, expectedRows, problems);
    }

    // A screen that drew nothing can't clip or overlap, so every screen also
    // has to produce the text rows it promises.
    static function collectOverlaps(name as Lang.String, expectedRows as Lang.Number, problems as Lang.Array<Lang.String>) as Void {
        var boxes = HeroSetDraw.boxes as Lang.Array<Lang.Array>;
        if (boxes.size() < expectedRows) {
            problems.add(name + " drew " + boxes.size() + " text rows, expected " + expectedRows);
        }
        for (var i = 0; i < boxes.size(); i++) {
            for (var j = i + 1; j < boxes.size(); j++) {
                var a = boxes[i];
                var b = boxes[j];
                var apart = a[0] + a[2] <= b[0] || b[0] + b[2] <= a[0] || a[1] + a[3] <= b[1] || b[1] + b[3] <= a[1];
                if (!apart) {
                    problems.add(name + " overlap: '" + a[4] + "' and '" + b[4] + "'");
                }
            }
        }
    }
}
