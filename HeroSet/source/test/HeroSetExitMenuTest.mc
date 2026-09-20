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
    } finally {
        getApp().swapStoreForTest(appStore);
    }
    return true;
}
