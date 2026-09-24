import Toybox.Lang;
import Toybox.Test;

// A no-op base `save()` would mean Save silently discards a set, and the
// compiler cannot tell the difference (ADR-036). Call through a base-typed
// reference, the way HeroSetExitMenuDelegate.onSelect does, and assert the
// subclass override is what actually ran.
// (:debug) too: it seeds the app store through the (:debug) test hooks.
(:test :debug)
function exitMenusDispatchSaveToTheirView(logger as Test.Logger) as Lang.Boolean {
    var store = new HeroSetStore(new HeroSetTestStorage(), new HeroSetTestClock());
    var appStore = getApp().swapStoreForTest(store);
    try {
        var workout = new HeroSetWorkoutView(:pushups);
        workout.setCountsForTest(7, 0);
        var workoutMenu = new HeroSetWorkoutEndMenuDelegate(workout) as HeroSetExitMenuDelegate;
        workoutMenu.save();
        Test.assertEqual(store.getCount(:pushups), 7);

        var picker = new HeroSetManualPickerView(:situps, 4, null, null, null);
        var pickerMenu = new HeroSetManualExitMenuDelegate(picker) as HeroSetExitMenuDelegate;
        pickerMenu.save();
        Test.assertEqual(store.getCount(:situps), 4);

        var goalPicker = new HeroSetGoalPickerView();
        goalPicker.adjust(1);
        var goalMenu = new HeroSetGoalExitMenuDelegate(goalPicker) as HeroSetExitMenuDelegate;
        goalMenu.save();
        Test.assertEqual(store.getGoal(), HeroSetConfig.DEFAULT_MISSION_GOAL + HeroSetConfig.MISSION_GOAL_STEP);
    } finally {
        getApp().swapStoreForTest(appStore);
    }
    return true;
}

// Same risk on the picker's START path: HeroSetPickerDelegate.onKey calls a
// no-op base commit(), so assert through the base type that each picker's
// override is what runs (ADR-036/048).
(:test :debug)
function pickersDispatchCommitToTheirView(logger as Test.Logger) as Lang.Boolean {
    var store = new HeroSetStore(new HeroSetTestStorage(), new HeroSetTestClock());
    var appStore = getApp().swapStoreForTest(store);
    try {
        var picker = new HeroSetManualPickerDelegate(new HeroSetManualPickerView(:squats, 0, null, null, null)) as HeroSetPickerDelegate;
        picker.adjust(3);
        picker.commit();
        Test.assertEqual(store.getCount(:squats), 3);

        var goal = new HeroSetGoalPickerDelegate(new HeroSetGoalPickerView()) as HeroSetPickerDelegate;
        goal.adjust(-1);
        goal.commit();
        Test.assertEqual(store.getGoal(), HeroSetConfig.DEFAULT_MISSION_GOAL - HeroSetConfig.MISSION_GOAL_STEP);
    } finally {
        getApp().swapStoreForTest(appStore);
    }
    return true;
}
