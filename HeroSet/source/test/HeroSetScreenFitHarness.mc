import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.WatchUi;

// Shared steps for HeroSetScreenFitTest. A class, because the test runner
// treats every (:test) function as a test case.
(:test :debug)
class HeroSetScreenFitHarness {

    // 99 of each exercise already saved today, the widest goal the picker
    // allows, and a full log of the widest lines.
    static function seededStore() as HeroSetStore {
        var store = new HeroSetStore(new HeroSetTestStorage(), new HeroSetTestClock());
        store.setGoal(HeroSetConfig.MAX_MISSION_GOAL);
        var exercises = HeroSetRules.EXERCISES;
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
        collectCorners(name, boxes, problems);
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

    // The bezel hides a semi-octagon display's corners: no text box may reach outside the circle that shows (ADR-055). Boxes
    // include font padding, so this is stricter than the ink; a screenshot of the simulator decides a disputed case.
    static function collectCorners(name as Lang.String, boxes as Lang.Array<Lang.Array>, problems as Lang.Array<Lang.String>) as Void {
        var settings = System.getDeviceSettings();
        if (settings.screenShape != System.SCREEN_SHAPE_SEMI_OCTAGON) {
            return;
        }
        var radius = HeroSetLayout.SEMI_OCTAGON_VISIBLE_RADIUS;
        for (var i = 0; i < boxes.size(); i++) {
            var box = boxes[i] as Lang.Array;
            for (var k = 0; k < 4; k++) {
                var dx = (box[0] as Lang.Number) + (k % 2 == 0 ? 0 : box[2] as Lang.Number) - settings.screenWidth / 2;
                var dy = (box[1] as Lang.Number) + (k < 2 ? 0 : box[3] as Lang.Number) - settings.screenHeight / 2;
                if (dx * dx + dy * dy > radius * radius) {
                    problems.add(name + " corner: '" + box[4] + "' y=" + box[1]);
                    break;
                }
            }
        }
    }
}
