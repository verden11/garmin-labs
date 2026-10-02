import Toybox.Lang;
import Toybox.Test;

// The recoverable workout draft (ADR-052): a checkpoint, not a save, so
// these never touch getCount/getXp/getStreak — only the three draft keys.

(:test)
function draftReadsBackForTheSameExerciseAndDay(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    store.saveWorkoutDraft(:situps, 7);
    Test.assertEqual(store.getWorkoutDraft(:situps), 7);
    return true;
}

(:test)
function draftIgnoresADifferentExercise(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    store.saveWorkoutDraft(:pushups, 12);
    Test.assert(store.getWorkoutDraft(:situps) == null);
    // The other exercise's draft is untouched by the miss.
    Test.assertEqual(store.getWorkoutDraft(:pushups), 12);
    return true;
}

(:test)
function draftIsStaleOnceTheDayChanges(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260927;
    var store = new HeroSetStore(storage, clock);
    store.saveWorkoutDraft(:squats, 5);
    clock.day = 20260928;
    Test.assert(store.getWorkoutDraft(:squats) == null);
    return true;
}

(:test)
function draftIsGoneAfterClearing(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    store.saveWorkoutDraft(:pushups, 40);
    store.clearWorkoutDraft();
    Test.assert(store.getWorkoutDraft(:pushups) == null);
    return true;
}

(:test)
function draftUpdatesInPlaceAsCountingContinues(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    store.saveWorkoutDraft(:squats, 3);
    store.saveWorkoutDraft(:squats, 9);
    Test.assertEqual(store.getWorkoutDraft(:squats), 9);
    return true;
}

(:test)
function noDraftEverWrittenReadsAsNone(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    Test.assert(store.getWorkoutDraft(:pushups) == null);
    return true;
}

// Regression, found on a watch 2026-10-02: Finish / quick-Save / Discard clear the draft and then the view
// hides, and the hide-time flush wrote the just-saved count back, so the next set of that exercise
// started from it. A set that ended must stay cleared; a set merely hidden (Resume/Save/Discard menu)
// must still be flushed.
(:test :debug)
function aSetThatEndedLeavesNoDraftWhenItsViewHides(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    var appStore = getApp().swapStoreForTest(store);
    try {
        var workout = new HeroSetWorkoutView(:pushups);
        workout.setCountsForTest(4, 0);
        workout.discardDraft();
        workout.onHide();
        Test.assert(store.getWorkoutDraft(:pushups) == null);
    } finally {
        getApp().swapStoreForTest(appStore);
    }
    return true;
}

(:test :debug)
function aSetMerelyHiddenStillFlushesItsDraft(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260927);
    var appStore = getApp().swapStoreForTest(store);
    try {
        var workout = new HeroSetWorkoutView(:pushups);
        workout.setCountsForTest(4, 0);
        workout.onHide();
        Test.assertEqual(store.getWorkoutDraft(:pushups), 4);
    } finally {
        getApp().swapStoreForTest(appStore);
    }
    return true;
}
