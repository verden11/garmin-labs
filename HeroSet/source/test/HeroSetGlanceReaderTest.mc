import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.Test;

// Counts writes so a test can prove the glance path makes none. (:test) keeps
// it out of release builds.
(:test)
class HeroSetCountingStorage extends HeroSetTestStorage {
    var writes as Lang.Number = 0;
    function initialize() {
        HeroSetTestStorage.initialize();
    }
    function setValue(key as Lang.String, value as Storage.ValueType) as Void {
        writes += 1;
        HeroSetTestStorage.setValue(key, value);
    }
}

// The numbers the glance shows; XP and rank are not read by it.
function sameState(a as HeroSetDashboardState, b as HeroSetDashboardState) as Lang.Boolean {
    return a.pushups == b.pushups && a.situps == b.situps && a.squats == b.squats && a.streak == b.streak && a.goal == b.goal;
}

(:test)
function glanceReaderMatchesTheStoreOnTheSameDay(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetCountingStorage();
    var clock = new HeroSetTestClock();
    var store = new HeroSetStore(storage, clock);
    store.setGoal(30);
    store.add(:pushups, 30);
    store.add(:situps, 12);
    Test.assert(sameState(HeroSetGlanceReader.read(storage, clock.day), store.getDashboardState()));
    completeAll(store);
    Test.assert(sameState(HeroSetGlanceReader.read(storage, clock.day), store.getDashboardState()));
    return true;
}

// The point of the read-only path: the next day's glance shows 0 without any
// write, and the streak is alive until the day after that.
(:test)
function glanceReaderNeverWritesAndReadsStaleDaysAsZero(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetCountingStorage();
    var clock = new HeroSetTestClock();
    var store = new HeroSetStore(storage, clock);
    completeAll(store);
    var writes = storage.writes;
    var tomorrow = clock.day + 1;
    var s = HeroSetGlanceReader.read(storage, tomorrow);
    Test.assertEqual(s.pushups, 0);
    Test.assertEqual(s.squats, 0);
    Test.assertEqual(s.streak, 1);
    Test.assertEqual(HeroSetGlanceReader.read(storage, tomorrow + 1).streak, 0);
    Test.assertEqual(storage.writes, writes);
    // The store would have reset on this day; same numbers, but it writes.
    clock.day = tomorrow;
    Test.assert(sameState(s, store.getDashboardState()));
    return true;
}

(:test)
function glanceReaderCopesWithMissingCorruptAndFloatValues(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var s = HeroSetGlanceReader.read(storage, 20260911);
    Test.assertEqual(s.goal, HeroSetConfig.DEFAULT_MISSION_GOAL);
    Test.assertEqual(s.pushups, 0);
    storage.setValue("hero_day", 20260911);
    storage.setValue("hero_goal", 0);
    storage.setValue("hero_pushups", 42.0f);
    s = HeroSetGlanceReader.read(storage, 20260911);
    Test.assertEqual(s.goal, HeroSetConfig.DEFAULT_MISSION_GOAL);
    Test.assertEqual(s.pushups, 42);
    return true;
}

// Off-step, out-of-range, negative and non-numeric goals resolve the way the
// store resolves them, so a glance and the dashboard never disagree on the
// bar length.
(:test)
function glanceReaderGoalMatchesTheStoreForOddValues(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    var store = new HeroSetStore(storage, clock);
    var values = [-5, 0, 45, 999, "x", 30.0f] as Lang.Array<Storage.ValueType>;
    for (var i = 0; i < values.size(); i++) {
        storage.setValue("hero_goal", values[i]);
        Test.assertEqual(HeroSetGlanceReader.read(storage, clock.day).goal, store.getGoal());
    }
    return true;
}
