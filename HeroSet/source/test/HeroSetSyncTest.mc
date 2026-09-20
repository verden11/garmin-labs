import Toybox.Lang;
import Toybox.Test;

// Connect sync sequencing (ADR-043) against a fake recording: which laps
// close with what, and whether a visit is saved or discarded. Whether the
// watch really writes and shows these is device-only (connect-sync-plan.md).
// (:sync) because the store build has no recording; (:debug) for the
// coordinator's test hook.
(:test :sync :debug)
class HeroSetTestActivity extends HeroSetActivitySync {

    var calls as Lang.Array<Lang.String> = [];
    var opens as Lang.Boolean = true;
    private var _open as Lang.Boolean = false;

    function initialize() {
        HeroSetActivitySync.initialize();
    }

    // A coordinator recording into a fresh fake. Lives here, not as a free
    // function: the runner would run any (:test) function as a test case.
    static function coordinator(enabled as Lang.Boolean, activity as HeroSetTestActivity) as HeroSetSyncCoordinator {
        var store = storeWith(20260919);
        store.setSyncEnabled(enabled);
        var sync = new HeroSetSyncCoordinator(store);
        sync.useActivityForTest(activity);
        return sync;
    }

    function isOpen() as Lang.Boolean {
        return _open;
    }

    function open() as Lang.Boolean {
        calls.add("open");
        _open = opens;
        return opens;
    }

    function resume() as Void {
        if (_open) {
            calls.add("resume");
        }
    }

    function pause() as Void {
        if (_open) {
            calls.add("pause");
        }
    }

    function closeLap(exerciseName as Lang.String, reps as Lang.Number) as Void {
        calls.add("lap " + exerciseName + " " + reps);
    }

    function recordedMs() as Lang.Number {
        return 0;
    }

    function finish(exerciseName as Lang.String, reps as Lang.Number, totals as Lang.Array<Lang.Number>) as Lang.Boolean {
        calls.add("save " + exerciseName + " " + reps + " " + totals[0] + "/" + totals[1] + "/" + totals[2]);
        _open = false;
        return true;
    }

    function abandon() as Lang.Boolean {
        calls.add("discard");
        _open = false;
        return true;
    }
}

(:test :sync :debug)
function syncWorkoutIsOneActivityWithALapPerSet(logger as Test.Logger) as Lang.Boolean {
    var activity = new HeroSetTestActivity();
    var sync = HeroSetTestActivity.coordinator(true, activity);
    sync.beginSet(:pushups);
    sync.pauseSet();
    sync.setSaved(20);
    sync.beginSet(:squats);
    sync.pauseSet();
    sync.setSaved(15);
    sync.stop();
    var push = HeroSetText.load(Rez.Strings.fit_label_pushups);
    var squat = HeroSetText.load(Rez.Strings.fit_label_squats);
    Test.assertEqual(activity.calls.toString(), ["open", "pause", "resume", "lap " + push + " 20", "pause", "save " + squat + " 15 20/0/15"].toString());
    return true;
}

(:test :sync :debug)
function syncResumedSetKeepsItsLap(logger as Test.Logger) as Lang.Boolean {
    var activity = new HeroSetTestActivity();
    var sync = HeroSetTestActivity.coordinator(true, activity);
    sync.beginSet(:situps);
    sync.pauseSet();
    sync.resumeSet();
    sync.pauseSet();
    sync.setSaved(12);
    sync.stop();
    var sit = HeroSetText.load(Rez.Strings.fit_label_situps);
    Test.assertEqual(activity.calls.toString(), ["open", "pause", "resume", "pause", "save " + sit + " 12 0/12/0"].toString());
    return true;
}

(:test :sync :debug)
function syncDiscardedSetLapsAtZero(logger as Test.Logger) as Lang.Boolean {
    var activity = new HeroSetTestActivity();
    var sync = HeroSetTestActivity.coordinator(true, activity);
    sync.beginSet(:pushups);
    sync.pauseSet();
    sync.beginSet(:pushups);
    sync.pauseSet();
    sync.setSaved(-3);
    sync.stop();
    Test.assert(activity.calls.indexOf("lap " + HeroSetText.load(Rez.Strings.fit_label_pushups) + " 0") >= 0);
    Test.assertEqual(activity.calls[activity.calls.size() - 1], "discard");
    return true;
}

(:test :sync :debug)
function syncNegativeCorrectionLowersTheTotal(logger as Test.Logger) as Lang.Boolean {
    var activity = new HeroSetTestActivity();
    var sync = HeroSetTestActivity.coordinator(true, activity);
    sync.beginSet(:squats);
    sync.pauseSet();
    sync.setSaved(20);
    sync.beginSet(:squats);
    sync.pauseSet();
    sync.setSaved(-5);
    sync.stop();
    var squat = HeroSetText.load(Rez.Strings.fit_label_squats);
    Test.assertEqual(activity.calls[activity.calls.size() - 1], "save " + squat + " 0 0/0/15");
    return true;
}

(:test :sync :debug)
function syncOffOrRefusedRecordsNothing(logger as Test.Logger) as Lang.Boolean {
    var off = new HeroSetTestActivity();
    var sync = HeroSetTestActivity.coordinator(false, off);
    sync.beginSet(:squats);
    sync.setSaved(10);
    sync.stop();
    Test.assertEqual(off.calls.size(), 0);
    var refused = new HeroSetTestActivity();
    refused.opens = false;
    sync = HeroSetTestActivity.coordinator(true, refused);
    sync.beginSet(:squats);
    sync.setSaved(10);
    sync.stop();
    Test.assertEqual(refused.calls.toString(), ["open"].toString());
    return true;
}

(:test :sync :debug)
function syncTurnedOffDropsTheVisit(logger as Test.Logger) as Lang.Boolean {
    var activity = new HeroSetTestActivity();
    var sync = HeroSetTestActivity.coordinator(true, activity);
    sync.beginSet(:pushups);
    sync.pauseSet();
    sync.setSaved(10);
    sync.setEnabled(false);
    sync.stop();
    Test.assertEqual(activity.calls[activity.calls.size() - 1], "discard");
    Test.assertEqual(activity.calls.indexOf("discard"), activity.calls.size() - 1);
    return true;
}

// The real recording in the simulator: catches field-creation and setData
// type errors (a string too long for its field, wrong data type) that the
// fake can't. Saves a FIT file into the simulator only.
(:test :sync)
function syncRealRecordingOpensLapsAndSaves(logger as Test.Logger) as Lang.Boolean {
    var activity = new HeroSetActivitySync();
    Test.assert(activity.open());
    activity.pause();
    activity.resume();
    activity.closeLap("A name far longer than the thirty-one bytes a lap string can hold", 20);
    activity.pause();
    Test.assert(activity.finish("Squats", 15, [20, 0, 15]));
    Test.assert(!activity.isOpen());
    return true;
}
