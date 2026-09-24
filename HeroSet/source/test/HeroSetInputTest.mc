import Toybox.Lang;
import Toybox.Test;
import Toybox.WatchUi;

// A tap is also the select behavior, so the commit screens must not act on
// onSelect: Finish and Save live in onKey on the START key (ADR-048). The
// dispatch itself (tap → onTap, START → onKey) is only provable by hand in
// the simulator or on a watch; this pins the half that code can check.
(:test)
function commitScreensIgnoreTheSelectBehavior(logger as Test.Logger) as Lang.Boolean {
    var workout = new HeroSetWorkoutView(:pushups);
    Test.assert(!(new HeroSetWorkoutDelegate(workout)).onSelect());
    var picker = new HeroSetManualPickerView(:pushups, 5, null, null, null);
    Test.assert(!(new HeroSetManualPickerDelegate(picker)).onSelect());
    Test.assertEqual(picker.getDelta(), 5);
    Test.assert(!(new HeroSetGoalPickerDelegate(new HeroSetGoalPickerView())).onSelect());
    return true;
}

// A lone rep the learner drops as getting up leaves nothing to save, so Back
// leaves the set instead of offering a "0 reps" Save that banks nothing.
(:test :debug)
function backLeavesWhenTheOnlyRepIsDropped(logger as Test.Logger) as Lang.Boolean {
    var store = new HeroSetStore(new HeroSetTestStorage(), new HeroSetTestClock());
    var bins = HeroSetConfig.LEARN_BINS;
    var dropping = [] as Lang.Array<Lang.Float>;
    for (var i = 0; i < 2 * bins; i++) {
        dropping.add(i < bins ? -10.0 : 0.0);
    }
    store.setLearningState(:pushups, dropping);
    var appStore = getApp().swapStoreForTest(store);
    try {
        var workout = new HeroSetWorkoutView(:pushups);
        workout.setCountsForTest(1, 0);
        Test.assertEqual(workout.getCount(), 0);
        Test.assert(!(new HeroSetWorkoutDelegate(workout)).onBack());
    } finally {
        getApp().swapStoreForTest(appStore);
    }
    return true;
}
