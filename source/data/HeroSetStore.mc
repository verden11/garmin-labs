import Toybox.Lang;

// Persistence contract for HeroSet. All daily values reset on the LOCAL
// calendar day (HeroSetCalendar.todayKey), XP is awarded only for net stored
// progress toward each mission goal (never for raw `amount` arguments), and
// streaks are computed from calendar-day keys so DST can never break them.
class HeroSetStore {

    const SCHEMA_VERSION = 3;
    const SCHEMA_KEY = "hero_schema";
    const DAY_KEY = "hero_day";
    const CALIBRATION_KEY = "hero_calibration";
    // Thresholds only mean something to the detector that fitted them.
    // Profiles without this model number came from the magnitude detector
    // (ADR-032) and read as uncalibrated. Bump it whenever the detector's
    // signal changes.
    const CALIBRATION_MODEL_FIELD = "model";
    const CALIBRATION_MODEL = 2;

    const XP_KEY = "hero_xp";
    const STREAK_KEY = "hero_streak";
    const LAST_COMPLETION_KEY = "hero_last_completion";
    const SYNC_ENABLED_KEY = "hero_sync_enabled";
    const SYNC_DAY_KEY = "hero_sync_day";
    // Real day keys are yyyymmdd, so 0 can never collide with one.
    const NO_SYNC_DAY = 0;
    const VALIDATION_LOG_KEY = "hero_validation_log";


    private var _storage;
    private var _clock;
    private var _writeFailed = false;

    function initialize(storage as HeroSetStorage?, clock as HeroSetClock?) {
        _storage = storage == null ? new HeroSetPersistentStorage() : storage;
        _clock = clock == null ? new HeroSetClock() : clock;
        // Stamped so a future format change has a version to migrate from;
        // every schema so far has read the same flat keys (ADR-003).
        _set(SCHEMA_KEY, SCHEMA_VERSION);
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
        var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
        for (var i = 0; i < exercises.size(); i++) {
            _set(keyFor(exercises[i]), 0);
            _set(creditKeyFor(exercises[i]), 0);
        }
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
    // XP and streaks
    // ------------------------------------------------------------------

    function getXp() as Lang.Number {
        return readNumber(XP_KEY);
    }

    function getRank() as Lang.Number {
        return HeroSetRules.rankForXp(getXp());
    }

    // What the user can still extend: 0 once a day was missed, even though
    // the stored run is only overwritten at the next completion.
    function getStreak() as Lang.Number {
        var lastDay = asNumberOrNull(_storage.getValue(LAST_COMPLETION_KEY));
        return HeroSetRules.activeStreak(lastDay, _clock.todayKey(), readNumber(STREAK_KEY));
    }

    function getDashboardState() as HeroSetDashboardState {
        ensureCurrentDay();
        return new HeroSetDashboardState(
            getCount(:pushups),
            getCount(:situps),
            getCount(:squats),
            getXp(),
            getRank(),
            getStreak(),
            hasWriteFailure()
        );
    }

    function isDailyMissionComplete() as Lang.Boolean {
        return HeroSetRules.missionComplete(getCount(:pushups), getCount(:situps), getCount(:squats));
    }

    // ------------------------------------------------------------------
    // Garmin Connect/Strava sync (opt-in — ADR-025)
    // ------------------------------------------------------------------

    function isSyncEnabled() as Lang.Boolean {
        return _storage.getValue(SYNC_ENABLED_KEY) == true;
    }

    function setSyncEnabled(enabled as Lang.Boolean) as Void {
        _set(SYNC_ENABLED_KEY, enabled);
    }

    // Which calendar day (HeroSetCalendar.todayKey) the currently-open
    // HeroSetActivitySync session belongs to, or null if none is open.
    // HeroSetSyncCoordinator compares this to today to decide whether a
    // stale prior day's session needs closing out first.
    function getSyncSessionDay() as Lang.Number? {
        var day = asNumberOrNull(_storage.getValue(SYNC_DAY_KEY));
        return day == NO_SYNC_DAY ? null : day;
    }

    function setSyncSessionDay(day as Lang.Number) as Void {
        _set(SYNC_DAY_KEY, day);
    }

    // After sync is turned off and the session saved. Left set, a later
    // day's beginSet would see a stale day and save a fresh, empty session.
    // Written as a sentinel because the storage seam has no delete.
    function clearSyncSessionDay() as Void {
        _set(SYNC_DAY_KEY, NO_SYNC_DAY);
    }

    private function updateCompletion() as Void {
        if (getCount(:pushups) < HeroSetConfig.MISSION_GOAL || getCount(:situps) < HeroSetConfig.MISSION_GOAL || getCount(:squats) < HeroSetConfig.MISSION_GOAL) {
            return;
        }

        var today = _clock.todayKey();
        var lastDay = asNumberOrNull(_storage.getValue(LAST_COMPLETION_KEY));
        if (lastDay == today) {
            return;
        }

        var streak = HeroSetRules.nextStreak(lastDay, today, readNumber(STREAK_KEY));
        _set(STREAK_KEY, streak);
        _set(LAST_COMPLETION_KEY, today);
    }

    // ------------------------------------------------------------------
    // Validation log (dev diagnostics — ADR-026)
    // ------------------------------------------------------------------

    // Appends one detected-vs-corrected trial from a real workout set.
    // `detected` is the auto-counter's raw count at Finish; `savedCount` is
    // what actually got saved after any manual correction. Never called for
    // standalone manual entry (no detector count to compare against).
    function logValidationTrial(exercise as Lang.Symbol, detected as Lang.Number, savedCount as Lang.Number) as Void {
        logDiagnostic(validationLogLine(exercise, detected, savedCount));
    }

    // Any preformatted dev-diagnostic line (e.g. sync lines, ADR-030) shares
    // the same capped log, so one on-watch viewer shows everything in order.
    function logDiagnostic(line as Lang.String) as Void {
        var log = getValidationLog();
        log.add(line);
        while (log.size() > HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES) {
            log.remove(log[0]);
        }
        _set(VALIDATION_LOG_KEY, log);
    }

    function getValidationLog() as Lang.Array<Lang.String> {
        var stored = _storage.getValue(VALIDATION_LOG_KEY);
        return stored instanceof Array ? stored : [];
    }

    // Compact "mmdd LABEL det->fin err" line, sized for the on-device log
    // viewer (HeroSetValidationLogView) at FONT_XTINY rather than a full
    // timestamp — this is a dev diagnostic, not user-facing copy.
    private function validationLogLine(exercise as Lang.Symbol, detected as Lang.Number, savedCount as Lang.Number) as Lang.String {
        var label = exercise == :pushups ? "PU" : (exercise == :situps ? "SU" : "SQ");
        var error = savedCount - detected;
        var errorText = error > 0 ? ("+" + error) : error.toString();
        var monthDay = _clock.todayKey() % 10000;
        return monthDay + " " + label + " " + detected + "->" + savedCount + " " + errorText;
    }

    // ------------------------------------------------------------------
    // Calibration profiles (per exercise: arm, release, rate, cooldown)
    // ------------------------------------------------------------------

    function getCalibrationArm(exercise as Lang.Symbol) as Lang.Number {
        return asNumber(calibrationValue(exercise, "arm"), HeroSetConfig.DEFAULT_ARM_THRESHOLD);
    }

    function getCalibrationRelease(exercise as Lang.Symbol) as Lang.Number {
        return asNumber(calibrationValue(exercise, "release"), HeroSetConfig.DEFAULT_RELEASE_THRESHOLD);
    }

    function getCalibrationRate(exercise as Lang.Symbol) as Lang.Number {
        return asNumber(calibrationValue(exercise, "rate"), HeroSetConfig.SENSOR_SAMPLE_RATE);
    }

    function getCalibrationCooldownMs(exercise as Lang.Symbol) as Lang.Number {
        return asNumber(calibrationValue(exercise, "cooldown"), HeroSetConfig.SENSOR_COOLDOWN_MS);
    }

    function setCalibrationProfile(exercise as Lang.Symbol, armThreshold as Lang.Number, releaseThreshold as Lang.Number, rate as Lang.Number, cooldownMs as Lang.Number) as Void {
        var calibration = _storage.getValue(CALIBRATION_KEY);
        if (!(calibration instanceof Dictionary)) {
            calibration = {};
        }
        var profile = {};
        profile["arm"] = armThreshold;
        profile["release"] = releaseThreshold;
        profile["rate"] = rate;
        profile["cooldown"] = cooldownMs;
        profile[CALIBRATION_MODEL_FIELD] = CALIBRATION_MODEL;
        calibration[exerciseKeyString(exercise)] = profile;
        _set(CALIBRATION_KEY, calibration);
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
            _writeFailed = false;
        } catch (ex) {
            _writeFailed = true;
        }
    }

    private function readNumber(key as Lang.String) as Lang.Number {
        return asNumber(_storage.getValue(key), 0);
    }

    // Stored values come back as Object (Number or Float depending on how
    // they were originally written); `toNumber()` isn't declared on the base
    // Object type, so every read narrows through here instead of casting
    // blind.
    private function asNumber(value as Lang.Object?, fallback as Lang.Number) as Lang.Number {
        var number = asNumberOrNull(value);
        return number == null ? fallback : number;
    }

    private function asNumberOrNull(value as Lang.Object?) as Lang.Number? {
        if (value instanceof Lang.Number) {
            return value;
        }
        if (value instanceof Lang.Float) {
            return value.toNumber();
        }
        return null;
    }

    private function calibrationValue(exercise as Lang.Symbol, field as Lang.String) as Lang.Object? {
        var calibration = _storage.getValue(CALIBRATION_KEY);
        if (!(calibration instanceof Dictionary)) {
            return null;
        }
        var profile = calibration[exerciseKeyString(exercise)];
        if (!(profile instanceof Dictionary) || asNumber(profile[CALIBRATION_MODEL_FIELD], 0) != CALIBRATION_MODEL) {
            return null;
        }
        return profile[field];
    }

    // Storage.setValue forbids Symbol as a Dictionary key or value ("Symbols
    // can change from build to build") and throws UnexpectedTypeException —
    // confirmed crashing on a physical FR965. The CALIBRATION_KEY dictionary
    // must be keyed by this String, never the exercise Symbol directly.
    private function exerciseKeyString(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return "pushups";
        }
        if (exercise == :situps) {
            return "situps";
        }
        if (exercise == :squats) {
            return "squats";
        }
        throw new Toybox.Lang.UnexpectedTypeException("Unknown exercise", null, null);
    }

    // "hero_pushups" / "hero_situps" / "hero_squats" — spelling fixed by
    // ADR-003, and exerciseKeyString is the one place an unknown exercise
    // fails loudly instead of silently mutating SQUATS state.
    private function keyFor(exercise as Lang.Symbol) as Lang.String {
        return "hero_" + exerciseKeyString(exercise);
    }

    // Per-goal "credit ratchet" ("hero_credit_pushups", ...): the highest
    // min(count, goal) seen today. XP only ever pays the positive difference
    // against the ratchet, so add(+10)/add(-10) farming earns XP once.
    private function creditKeyFor(exercise as Lang.Symbol) as Lang.String {
        return "hero_credit_" + exerciseKeyString(exercise);
    }
}

