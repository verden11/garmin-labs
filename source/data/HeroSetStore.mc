import Toybox.Lang;

// Persistence contract for HeroSet. All daily values reset on the LOCAL
// calendar day (HeroSetCalendar.todayKey), XP is awarded only for net stored
// progress toward each mission goal (never for raw `amount` arguments), and
// streaks are computed from calendar-day keys so DST can never break them.
class HeroSetStore {

    const SCHEMA_VERSION = 3;
    const SCHEMA_KEY = "hero_schema";
    const DAY_KEY = "hero_day";
    const DAILY_KEY = "hero_daily";
    const PROFILE_KEY = "hero_profile";
    const CALIBRATION_KEY = "hero_calibration";

    const PUSHUPS_KEY = "hero_pushups";
    const SITUPS_KEY = "hero_situps";
    const SQUATS_KEY = "hero_squats";
    const XP_KEY = "hero_xp";
    const STREAK_KEY = "hero_streak";
    const LAST_COMPLETION_KEY = "hero_last_completion";
    const RUN_DISTANCE_KEY = "hero_run_distance";

    // Per-goal "credit ratchet": the highest min(count, goal) seen today.
    // XP only ever pays the positive difference against the ratchet, so
    // add(+10)/add(-10) farming earns XP exactly once.
    const PUSHUPS_CREDIT_KEY = "hero_credit_pushups";
    const SITUPS_CREDIT_KEY = "hero_credit_situps";
    const SQUATS_CREDIT_KEY = "hero_credit_squats";
    const RUN_CREDIT_KEY = "hero_credit_run";

    const CAL_PUSHUPS_ARM_KEY = "hero_cal_pushups_arm";
    const CAL_PUSHUPS_RELEASE_KEY = "hero_cal_pushups_release";
    const CAL_PUSHUPS_RATE_KEY = "hero_cal_pushups_rate";
    const CAL_PUSHUPS_COOLDOWN_KEY = "hero_cal_pushups_cooldown_ms";
    const CAL_SITUPS_ARM_KEY = "hero_cal_situps_arm";
    const CAL_SITUPS_RELEASE_KEY = "hero_cal_situps_release";
    const CAL_SITUPS_RATE_KEY = "hero_cal_situps_rate";
    const CAL_SITUPS_COOLDOWN_KEY = "hero_cal_situps_cooldown_ms";
    const CAL_SQUATS_ARM_KEY = "hero_cal_squats_arm";
    const CAL_SQUATS_RELEASE_KEY = "hero_cal_squats_release";
    const CAL_SQUATS_RATE_KEY = "hero_cal_squats_rate";
    const CAL_SQUATS_COOLDOWN_KEY = "hero_cal_squats_cooldown_ms";

    private var _storage;
    private var _clock;
    private var _writeFailed = false;

    function initialize(storage, clock) {
        _storage = storage == null ? new HeroSetPersistentStorage() : storage;
        _clock = clock == null ? new HeroSetClock() : clock;
        migrateSchema();
        ensureCurrentDay();
    }

    // ------------------------------------------------------------------
    // Daily reset
    // ------------------------------------------------------------------

    function ensureCurrentDay() as Void {
        var today = _clock.todayKey();
        var savedDay = _storage.getValue(DAY_KEY);
        if (savedDay == null || savedDay != today) {
            _set(DAY_KEY, today);
            resetDailyState();
        }
    }

    private function resetDailyState() as Void {
        _set(PUSHUPS_KEY, 0);
        _set(SITUPS_KEY, 0);
        _set(SQUATS_KEY, 0);
        _set(RUN_DISTANCE_KEY, 0.0);
        _set(PUSHUPS_CREDIT_KEY, 0);
        _set(SITUPS_CREDIT_KEY, 0);
        _set(SQUATS_CREDIT_KEY, 0);
        _set(RUN_CREDIT_KEY, 0.0);
    }

    // ------------------------------------------------------------------
    // Rep missions
    // ------------------------------------------------------------------

    function getCount(exercise as Lang.Symbol) as Lang.Number {
        ensureCurrentDay();
        return readNumber(keyFor(exercise));
    }

    function add(exercise as Lang.Symbol, amount as Lang.Number) as Void {
        ensureCurrentDay();
        var key = keyFor(exercise);
        var previous = readNumber(key);
        var next = previous + amount;
        if (next < 0) {
            next = 0;
        }
        _set(key, next);
        awardXpFor(exercise, previous, next);
        updateCompletion();
    }

    // XP on the NET gain in stored progress, capped at the mission goal so
    // over-goal volume cannot print ranks, and ratcheted so add/subtract
    // cycles pay at most once per credited day.
    private function awardXpFor(exercise as Lang.Symbol, previous as Lang.Number, next as Lang.Number) as Void {
        if (next <= previous) {
            return;
        }
        var newCredit = next > HeroSetConfig.MISSION_GOAL ? HeroSetConfig.MISSION_GOAL : next;
        var credited = readNumber(creditKeyFor(exercise));
        var added = newCredit - credited;
        if (added <= 0) {
            return;
        }
        _set(creditKeyFor(exercise), newCredit);
        _set(XP_KEY, getXp() + HeroSetRules.xpForReps(added));
    }

    // ------------------------------------------------------------------
    // Run mission
    // ------------------------------------------------------------------

    // `km` is kilometres. The mission goal is 10.0 km.
    function addRunDistanceKm(km as Lang.Float) as Void {
        ensureCurrentDay();
        if (km <= 0.0) {
            return;
        }
        var current = getRunDistance();
        var next = current + km;
        _set(RUN_DISTANCE_KEY, next);
        awardRunXp(current, next);
    }

    function getRunDistance() as Lang.Float {
        ensureCurrentDay();
        var value = _storage.getValue(RUN_DISTANCE_KEY);
        return value == null ? 0.0 : value.toFloat();
    }

    private function awardRunXp(previousKm as Lang.Float, nextKm as Lang.Float) as Void {
        if (nextKm <= previousKm) {
            return;
        }
        var newCredit = nextKm > HeroSetConfig.RUN_GOAL_KM ? HeroSetConfig.RUN_GOAL_KM : nextKm;
        var credited = _storage.getValue(RUN_CREDIT_KEY);
        var creditedKm = credited == null ? 0.0 : credited.toFloat();
        var added = newCredit - creditedKm;
        if (added <= 0.0) {
            return;
        }
        _set(RUN_CREDIT_KEY, newCredit);
        _set(XP_KEY, getXp() + HeroSetRules.xpForReps(added.toNumber()));
    }

    // ------------------------------------------------------------------
    // XP and streaks
    // ------------------------------------------------------------------

    function getXp() as Lang.Number {
        return readNumber(XP_KEY);
    }

    function getRank() as Lang.Number {
        return HeroSetRules.rankForXp(getXp());
    }

    function getStreak() as Lang.Number {
        return readNumber(STREAK_KEY);
    }

    function getDashboardState() as HeroSetDashboardState {
        ensureCurrentDay();
        return new HeroSetDashboardState(
            getCount(:pushups),
            getCount(:situps),
            getCount(:squats),
            getRunDistance(),
            getRank(),
            getStreak(),
            hasWriteFailure()
        );
    }

    private function updateCompletion() as Void {
        if (getCount(:pushups) < HeroSetConfig.MISSION_GOAL || getCount(:situps) < HeroSetConfig.MISSION_GOAL || getCount(:squats) < HeroSetConfig.MISSION_GOAL) {
            return;
        }

        var today = _clock.todayKey();
        var lastValue = _storage.getValue(LAST_COMPLETION_KEY);
        var lastDay = lastValue == null ? null : lastValue.toNumber();
        if (lastDay == today) {
            return;
        }

        var streak = HeroSetRules.nextStreak(lastDay, today, getStreak());
        _set(STREAK_KEY, streak);
        _set(LAST_COMPLETION_KEY, today);
    }

    // ------------------------------------------------------------------
    // Calibration profiles (per exercise: arm, release, rate, cooldown)
    // ------------------------------------------------------------------

    function getCalibrationArm(exercise as Lang.Symbol) as Lang.Number {
        var value = calibrationValue(exercise, "arm");
        return value == null ? HeroSetConfig.DEFAULT_ARM_THRESHOLD : value.toNumber();
    }

    function getCalibrationRelease(exercise as Lang.Symbol) as Lang.Number {
        var value = calibrationValue(exercise, "release");
        return value == null ? HeroSetConfig.DEFAULT_RELEASE_THRESHOLD : value.toNumber();
    }

    function getCalibrationRate(exercise as Lang.Symbol) as Lang.Number {
        var value = calibrationValue(exercise, "rate");
        return value == null ? HeroSetConfig.SENSOR_SAMPLE_RATE : value.toNumber();
    }

    function getCalibrationCooldownMs(exercise as Lang.Symbol) as Lang.Number {
        var value = calibrationValue(exercise, "cooldown");
        return value == null ? HeroSetConfig.SENSOR_COOLDOWN_MS : value.toNumber();
    }

    function setCalibrationProfile(exercise as Lang.Symbol, armThreshold as Lang.Number, releaseThreshold as Lang.Number, rate as Lang.Number, cooldownMs as Lang.Number) as Void {
        _set(calibrationArmKey(exercise), armThreshold);
        _set(calibrationReleaseKey(exercise), releaseThreshold);
        _set(calibrationRateKey(exercise), rate);
        _set(calibrationCooldownKey(exercise), cooldownMs);
        var calibration = _storage.getValue(CALIBRATION_KEY);
        if (!(calibration instanceof Dictionary)) {
            calibration = {};
        }
        var profile = {};
        profile["arm"] = armThreshold;
        profile["release"] = releaseThreshold;
        profile["rate"] = rate;
        profile["cooldown"] = cooldownMs;
        calibration[exercise] = profile;
        _storage.setValue(CALIBRATION_KEY, calibration);
    }

    // ------------------------------------------------------------------
    // Schema migration
    // ------------------------------------------------------------------

    private function migrateSchema() as Void {
        var version = _storage.getValue(SCHEMA_KEY);
        var current = version == null ? 0 : version.toNumber();
        if (current == SCHEMA_VERSION) {
            return;
        }

        // v1 -> v2: day keys became local calendar integers and the detector
        // moved from jerk-delta thresholds to gravity-removed cycle
        // thresholds. Old delta thresholds would be meaningless for the new
        // detector, so calibration profiles and transient daily state are
        // reset; XP, streaks, and completion history are preserved.
        _set(SCHEMA_KEY, SCHEMA_VERSION);
        migrateFlatStateToDictionaries();
    }

    private function migrateFlatStateToDictionaries() as Void {
        var daily = {};
        daily[DAY_KEY] = readFlatNumber(DAY_KEY);
        daily[PUSHUPS_KEY] = readFlatNumber(PUSHUPS_KEY);
        daily[SITUPS_KEY] = readFlatNumber(SITUPS_KEY);
        daily[SQUATS_KEY] = readFlatNumber(SQUATS_KEY);
        daily[RUN_DISTANCE_KEY] = readFlatFloat(RUN_DISTANCE_KEY);
        daily[PUSHUPS_CREDIT_KEY] = readFlatNumber(PUSHUPS_CREDIT_KEY);
        daily[SITUPS_CREDIT_KEY] = readFlatNumber(SITUPS_CREDIT_KEY);
        daily[SQUATS_CREDIT_KEY] = readFlatNumber(SQUATS_CREDIT_KEY);
        daily[RUN_CREDIT_KEY] = readFlatFloat(RUN_CREDIT_KEY);
        _storage.setValue(DAILY_KEY, daily);

        var profile = {};
        profile[XP_KEY] = readFlatNumber(XP_KEY);
        profile[STREAK_KEY] = readFlatNumber(STREAK_KEY);
        profile[LAST_COMPLETION_KEY] = _storage.getValue(LAST_COMPLETION_KEY);
        _storage.setValue(PROFILE_KEY, profile);

        var calibration = {};
        calibration[:pushups] = calibrationDictionary(:pushups);
        calibration[:situps] = calibrationDictionary(:situps);
        calibration[:squats] = calibrationDictionary(:squats);
        _storage.setValue(CALIBRATION_KEY, calibration);
    }

    private function resetCalibration() as Void {
        setCalibrationProfile(:pushups, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS);
        setCalibrationProfile(:situps, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS);
        setCalibrationProfile(:squats, HeroSetConfig.DEFAULT_ARM_THRESHOLD, HeroSetConfig.DEFAULT_RELEASE_THRESHOLD, HeroSetConfig.SENSOR_SAMPLE_RATE, HeroSetConfig.SENSOR_COOLDOWN_MS);
    }

    // ------------------------------------------------------------------
    // Storage helpers
    // ------------------------------------------------------------------

    function hasWriteFailure() as Lang.Boolean {
        return _writeFailed;
    }

    private function _set(key as Lang.String, value as Lang.Object) as Void {
        try {
            _storage.setValue(key, value);
            writeDictionaryValue(key, value);
            _writeFailed = false;
        } catch (ex) {
            _writeFailed = true;
        }
    }

    private function readNumber(key as Lang.String) as Lang.Number {
        var value = readDictionaryValue(key);
        if (value == null) {
            value = _storage.getValue(key);
        }
        return value == null ? 0 : value.toNumber();
    }

    private function readFlatNumber(key as Lang.String) as Lang.Number {
        var value = _storage.getValue(key);
        return value == null ? 0 : value.toNumber();
    }

    private function readFlatFloat(key as Lang.String) as Lang.Float {
        var value = _storage.getValue(key);
        return value == null ? 0.0 : value.toFloat();
    }

    private function readDictionaryValue(key as Lang.String) {
        var groupKey = groupKeyFor(key);
        if (groupKey == null) {
            return null;
        }
        var group = _storage.getValue(groupKey);
        if (!(group instanceof Dictionary)) {
            return null;
        }
        return group[key];
    }

    private function writeDictionaryValue(key as Lang.String, value as Lang.Object) as Void {
        var groupKey = groupKeyFor(key);
        if (groupKey == null || key == DAY_KEY && groupKey != DAILY_KEY) {
            return;
        }
        var group = _storage.getValue(groupKey);
        if (!(group instanceof Dictionary)) {
            group = {};
        }
        group[key] = value;
        _storage.setValue(groupKey, group);
    }

    private function groupKeyFor(key as Lang.String) as Lang.String? {
        if (key == DAY_KEY || key == PUSHUPS_KEY || key == SITUPS_KEY || key == SQUATS_KEY || key == RUN_DISTANCE_KEY || key == PUSHUPS_CREDIT_KEY || key == SITUPS_CREDIT_KEY || key == SQUATS_CREDIT_KEY || key == RUN_CREDIT_KEY) {
            return DAILY_KEY;
        }
        if (key == XP_KEY || key == STREAK_KEY || key == LAST_COMPLETION_KEY) {
            return PROFILE_KEY;
        }
        return null;
    }

    private function calibrationDictionary(exercise as Lang.Symbol) as Dictionary {
        var dictionary = {};
        dictionary["arm"] = calibrationFlatValue(calibrationArmKey(exercise));
        dictionary["release"] = calibrationFlatValue(calibrationReleaseKey(exercise));
        dictionary["rate"] = calibrationFlatValue(calibrationRateKey(exercise));
        dictionary["cooldown"] = calibrationFlatValue(calibrationCooldownKey(exercise));
        return dictionary;
    }

    private function calibrationFlatValue(key as Lang.String) {
        return _storage.getValue(key);
    }

    private function calibrationValue(exercise as Lang.Symbol, field as Lang.String) {
        var calibration = _storage.getValue(CALIBRATION_KEY);
        if (calibration instanceof Dictionary) {
            var profile = calibration[exercise];
            if (profile instanceof Dictionary && profile[field] != null) {
                return profile[field];
            }
        }
        return _storage.getValue(calibrationKeyForField(exercise, field));
    }

    private function calibrationKeyForField(exercise as Lang.Symbol, field as Lang.String) as Lang.String {
        if (field == "arm") {
            return calibrationArmKey(exercise);
        }
        if (field == "release") {
            return calibrationReleaseKey(exercise);
        }
        if (field == "rate") {
            return calibrationRateKey(exercise);
        }
        return calibrationCooldownKey(exercise);
    }

    // Exhaustive key mapping. Unknown exercises must fail loudly instead of
    // silently mutating SQUATS state.
    private function keyFor(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return PUSHUPS_KEY;
        }
        if (exercise == :situps) {
            return SITUPS_KEY;
        }
        if (exercise == :squats) {
            return SQUATS_KEY;
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }

    private function creditKeyFor(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return PUSHUPS_CREDIT_KEY;
        }
        if (exercise == :situps) {
            return SITUPS_CREDIT_KEY;
        }
        if (exercise == :squats) {
            return SQUATS_CREDIT_KEY;
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }

    private function calibrationArmKey(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return CAL_PUSHUPS_ARM_KEY;
        }
        if (exercise == :situps) {
            return CAL_SITUPS_ARM_KEY;
        }
        if (exercise == :squats) {
            return CAL_SQUATS_ARM_KEY;
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }

    private function calibrationReleaseKey(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return CAL_PUSHUPS_RELEASE_KEY;
        }
        if (exercise == :situps) {
            return CAL_SITUPS_RELEASE_KEY;
        }
        if (exercise == :squats) {
            return CAL_SQUATS_RELEASE_KEY;
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }

    private function calibrationRateKey(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return CAL_PUSHUPS_RATE_KEY;
        }
        if (exercise == :situps) {
            return CAL_SITUPS_RATE_KEY;
        }
        if (exercise == :squats) {
            return CAL_SQUATS_RATE_KEY;
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }

    private function calibrationCooldownKey(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return CAL_PUSHUPS_COOLDOWN_KEY;
        }
        if (exercise == :situps) {
            return CAL_SITUPS_COOLDOWN_KEY;
        }
        if (exercise == :squats) {
            return CAL_SQUATS_COOLDOWN_KEY;
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }
}

// Clock seam so store tests can advance days deterministically. The real
// clock reads the local calendar day.
class HeroSetClock {
    function initialize() {
    }

    function todayKey() as Lang.Number {
        return HeroSetCalendar.todayKey();
    }
}
