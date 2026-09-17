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
function calibrationProfileRoundTrips(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    store.setCalibrationProfile(:pushups, 140, 90, 25, 600);
    Test.assertEqual(store.getCalibrationArm(:pushups), 140);
    Test.assertEqual(store.getCalibrationRelease(:pushups), 90);
    Test.assertEqual(store.getCalibrationRate(:pushups), 25);
    Test.assertEqual(store.getCalibrationCooldownMs(:pushups), 600);
    return true;
}

// Installs that predate the grouped calibration dictionary only have the flat
// "hero_cal_<exercise>_<field>" keys; renaming them would silently reset
// every such user's calibration.
(:test)
function legacyFlatCalibrationKeysStillRead(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    storage.put("hero_schema", 3);
    storage.put("hero_cal_squats_arm", 150);
    storage.put("hero_cal_squats_release", 95);
    storage.put("hero_cal_squats_rate", 25);
    storage.put("hero_cal_squats_cooldown_ms", 700);
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    Test.assertEqual(store.getCalibrationArm(:squats), 150);
    Test.assertEqual(store.getCalibrationRelease(:squats), 95);
    Test.assertEqual(store.getCalibrationCooldownMs(:squats), 700);
    store.setCalibrationProfile(:situps, 120, 80, 25, 650);
    Test.assertEqual(storage.value("hero_cal_situps_cooldown_ms"), 650);
    return true;
}

// Storage.setValue forbids Symbol as a Dictionary key or value at runtime
// (throws UnexpectedTypeException — confirmed crashing on a physical FR965,
// see ADR-022) but the in-memory test seam doesn't enforce that, so a
// regression here would pass every other test and only crash on a real
// device. Assert the persisted dictionary is String-keyed directly.
(:test)
function calibrationDictionaryUsesStringKeysNotSymbols(logger as Test.Logger) as Lang.Boolean {
    var storage = new HeroSetTestStorage();
    var clock = new HeroSetTestClock();
    clock.day = 20260911;
    var store = new HeroSetStore(storage, clock);
    store.setCalibrationProfile(:pushups, 140, 90, 25, 600);
    var calibration = storage.value("hero_calibration");
    Test.assert(calibration instanceof Dictionary);
    var calibrationDict = calibration as Dictionary;
    Test.assert(calibrationDict["pushups"] instanceof Dictionary);
    // Symbol-key dictionary reads throw UnexpectedTypeException on this SDK
    // (same native restriction as the original device crash), so assert the
    // persisted dictionary is String-keyed via keys() instead of probing a
    // Symbol key.
    var keys = calibrationDict.keys();
    for (var i = 0; i < keys.size(); i++) {
        Test.assert(keys[i] instanceof Lang.String);
    }
    return true;
}

(:test)
function uncalibratedProfileUsesDefaults(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    Test.assertEqual(store.getCalibrationArm(:squats), HeroSetConfig.DEFAULT_ARM_THRESHOLD);
    Test.assertEqual(store.getCalibrationRelease(:squats), HeroSetConfig.DEFAULT_RELEASE_THRESHOLD);
    Test.assertEqual(store.getCalibrationRate(:squats), HeroSetConfig.SENSOR_SAMPLE_RATE);
    Test.assertEqual(store.getCalibrationCooldownMs(:squats), HeroSetConfig.SENSOR_COOLDOWN_MS);
    return true;
}

(:test)
function legacyFlatStateMigratesToGroupedStorage(logger as Test.Logger) as Lang.Boolean {
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
    Test.assertEqual(store.getXp(), 48);
    Test.assert(storage.value("hero_daily") instanceof Dictionary);
    Test.assert(storage.value("hero_profile") instanceof Dictionary);
    return true;
}

(:test)
function clearedSyncSessionDayReadsAsNone(logger as Test.Logger) as Lang.Boolean {
    var store = storeWith(20260911);
    Test.assert(store.getSyncSessionDay() == null);
    store.setSyncSessionDay(20260911);
    Test.assertEqual(store.getSyncSessionDay(), 20260911);
    store.clearSyncSessionDay();
    Test.assert(store.getSyncSessionDay() == null);
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
