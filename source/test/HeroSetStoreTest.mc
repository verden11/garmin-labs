import Toybox.Lang;
import Toybox.Test;

// Store tests run against the in-memory storage seam and a controllable
// clock, so the production XP/streak/rollover paths are exercised exactly as
// the watch runs them (no fakes of the counting helpers).
class HeroSetTestStorage extends HeroSetStorage {

    private var _data = {} as Dictionary<String, Lang.Object>;

    function initialize() {
        HeroSetStorage.initialize();
    }

    function getValue(key as Lang.String) as Lang.Object? {
        return _data.get(key);
    }

    function setValue(key as Lang.String, value as Lang.Object) as Void {
        _data.put(key, value);
    }

    function put(key as Lang.String, value as Lang.Object) as Void {
        _data.put(key, value);
    }

    function value(key as Lang.String) as Lang.Object? {
        return _data.get(key);
    }
}

class HeroSetTestClock extends HeroSetClock {

    var day = 20260911;

    function initialize() {
        HeroSetClock.initialize();
    }

    function todayKey() as Lang.Number {
        return day;
    }
}

function storeWith(day as Lang.Number) as HeroSetStore {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = day;
    return new HeroSetStore(storage, clock);
}

function completeAll(store as HeroSetStore) as Void {
    store.add(:pushups, HeroSetConfig.MISSION_GOAL);
    store.add(:situps, HeroSetConfig.MISSION_GOAL);
    store.add(:squats, HeroSetConfig.MISSION_GOAL);
}

(:test)
function addAwardsXpOnNetStoredDelta(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.add(:pushups, 10);
    Test.assertEqual(store.getCount(:pushups), 10);
    Test.assertEqual(store.getXp(), 20);
    return true;
}

(:test)
function negativeCorrectionRefundsNoXp(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.add(:pushups, 10);
    store.add(:pushups, -3);
    Test.assertEqual(store.getCount(:pushups), 7);
    Test.assertEqual(store.getXp(), 20);
    return true;
}

(:test)
function farmLoopCannotInflateXp(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    for (var i = 0; i < 20; i++) {
        store.add(:pushups, 10);
        store.add(:pushups, -10);
    }
    Test.assertEqual(store.getCount(:pushups), 0);
    Test.assertEqual(store.getXp(), 20);
    return true;
}

(:test)
function overGoalVolumeDoesNotPrintRanks(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.add(:pushups, 150);
    Test.assertEqual(store.getCount(:pushups), 150);
    Test.assertEqual(store.getXp(), 200);
    store.add(:pushups, 100);
    Test.assertEqual(store.getXp(), 200);
    Test.assertEqual(store.getRank(), 1);
    return true;
}

(:test)
function dashboardStateCarriesXpAndRank(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.add(:pushups, 70);
    var state = store.getDashboardState();
    Test.assertEqual(state.pushups, 70);
    Test.assertEqual(state.xp, 140);
    Test.assertEqual(state.rank, 1);
    Test.assertEqual(HeroSetRules.xpIntoRank(state.xp), 140);
    return true;
}

(:test)
function correctionCannotDriveCountNegative(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.add(:pushups, -999);
    Test.assertEqual(store.getCount(:pushups), 0);
    Test.assertEqual(store.getXp(), 0);
    return true;
}

(:test)
function firstCompletionStartsStreakAtOne(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    completeAll(store);
    Test.assertEqual(store.getStreak(), 1);
    return true;
}

(:test)
function sameDayCompletionDoesNotDoubleStreak(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    completeAll(store);
    store.add(:pushups, 10);
    Test.assertEqual(store.getStreak(), 1);
    return true;
}

(:test)
function consecutiveDayExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    completeAll(store);
    Test.assertEqual(store.getStreak(), 1);

    clock.day = 20260912;
    completeAll(store);
    Test.assertEqual(store.getStreak(), 2);
    return true;
}

(:test)
function dstBoundaryDaysExtendStreak(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260307;
    var store = new HeroSetStore(storage, clock);
    completeAll(store);

    // US DST begins 2026-03-08: 23h between local midnights, calendar
    // keys still consecutive, streak must survive.
    clock.day = 20260308;
    completeAll(store);
    Test.assertEqual(store.getStreak(), 2);
    return true;
}

(:test)
function storeMissedDayResetsStreak(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    completeAll(store);

    clock.day = 20260913;
    completeAll(store);
    Test.assertEqual(store.getStreak(), 1);
    return true;
}

(:test)
function missedDayShowsNoStreakUntilTheNextCompletion(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    completeAll(store);

    clock.day = 20260912;
    Test.assertEqual(store.getStreak(), 1);
    clock.day = 20260914;
    Test.assertEqual(store.getStreak(), 0);
    Test.assertEqual(store.getDashboardState().streak, 0);
    completeAll(store);
    Test.assertEqual(store.getStreak(), 1);
    return true;
}

(:test)
function dayRolloverResetsCountsButKeepsXpAndStreak(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    completeAll(store);
    var xpBefore = store.getXp();
    var streakBefore = store.getStreak();

    clock.day = 20260912;
    Test.assertEqual(store.getCount(:pushups), 0);
    Test.assertEqual(store.getXp(), xpBefore);
    Test.assertEqual(store.getStreak(), streakBefore);
    return true;
}

(:test)
function unknownExerciseThrowsInsteadOfSquatMutation(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    var threw = false;
    try {
        store.add(:planks, 10);
    } catch (ex) {
        threw = true;
    }
    Test.assert(threw);
    Test.assertEqual(store.getCount(:squats), 0);
    return true;
}

(:test)
function learnedStateRoundTripsPerExercise(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    var state = HeroSetThresholdLearner.initialState();
    state[3] = 1.5;
    store.setLearningState(:pushups, state);
    Test.assertEqual(store.getLearningState(:pushups)[3], 1.5);
    Test.assertEqual(store.getLearningState(:squats)[3], HeroSetThresholdLearner.initialState()[3]);
    return true;
}

// Beliefs learned on another detector signal, or cut short, mean nothing
// to this one: they read as a fresh start, and old calibration profiles
// (ADR-032/040) are ignored altogether.
(:test)
function staleOrMalformedLearningReadsAsFresh(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    storage.put("hero_calibration", {"pushups" => {"arm" => 150, "release" => 95, "rate" => 25, "cooldown" => 700, "model" => 2}});
    storage.put("hero_learning", {"model" => 0, "pushups" => [9.0] as Lang.Array<Lang.Float>});
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    var fresh = HeroSetThresholdLearner.threshold(HeroSetThresholdLearner.initialState());
    Test.assertEqual(HeroSetThresholdLearner.threshold(store.getLearningState(:pushups)), fresh);
    return true;
}

// Storage.setValue forbids Symbol as a Dictionary key or value at runtime
// (throws UnexpectedTypeException — confirmed crashing on a physical FR965,
// see ADR-022) but the in-memory test seam doesn't enforce that, so a
// regression here would pass every other test and only crash on a real
// device. Assert the persisted dictionary is String-keyed directly.
(:test)
function learningDictionaryUsesStringKeysNotSymbols(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    store.setLearningState(:pushups, HeroSetThresholdLearner.initialState());
    var learning = storage.value("hero_learning");
    Test.assert(learning instanceof Dictionary);
    var learningDict = learning as Dictionary;
    Test.assert(learningDict["pushups"] instanceof Array);
    // Symbol-key dictionary reads throw UnexpectedTypeException on this SDK
    // (same native restriction as the original device crash), so assert the
    // persisted dictionary is String-keyed via keys() instead of probing a
    // Symbol key.
    var keys = learningDict.keys();
    for (var i = 0; i < keys.size(); i++) {
        Test.assert(keys[i] instanceof Lang.String);
    }
    return true;
}

// Counts, XP and streaks have always lived under the same flat keys
// (ADR-003), so an install written by any earlier schema is read as-is and
// only the schema stamp is rewritten.
(:test)
function stateFromAnEarlierSchemaStillReads(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    storage.put("hero_schema", 2);
    storage.put("hero_day", 20260911);
    storage.put("hero_pushups", 12);
    storage.put("hero_situps", 8);
    storage.put("hero_squats", 4);
    storage.put("hero_xp", 48);
    storage.put("hero_streak", 3);
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    Test.assertEqual(store.getCount(:pushups), 12);
    Test.assertEqual(store.getCount(:situps), 8);
    Test.assertEqual(store.getXp(), 48);
    Test.assertEqual(storage.value("hero_schema"), store.SCHEMA_VERSION);
    return true;
}

(:test)
function diagnosticLinesShareTheCappedLogInOrder(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.logValidationTrial(:pushups, 10, 12);
    for (var i = 0; i < HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES; i++) {
        store.logDiagnostic("SYNC " + i);
    }
    var log = store.getValidationLog();
    Test.assertEqual(log.size(), HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES);
    Test.assertEqual(log[0], "SYNC 0");
    Test.assertEqual(log[log.size() - 1], "SYNC " + (HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES - 1));
    return true;
}
