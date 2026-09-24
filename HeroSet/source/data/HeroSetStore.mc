import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

// Persistence contract for HeroSet. All daily values reset on the LOCAL
// calendar day (HeroSetCalendar.todayKey), XP is awarded only for net stored
// progress, capped at HeroSetConfig.XP_DAILY_CAP_REPS per exercise per day
// and never at the user's goal (ADR-045), and streaks are computed from
// calendar-day keys so DST can never break them.
class HeroSetStore {

    const SCHEMA_VERSION = 3;
    const SCHEMA_KEY = "hero_schema";
    const DAY_KEY = "hero_day";
    // Learned threshold beliefs, one per exercise (ADR-040). The old
    // "hero_calibration" profiles are no longer read. Beliefs only mean
    // something to the detector signal they were learned on: bump the model
    // whenever that signal changes, and older beliefs read as fresh.
    const LEARNING_KEY = "hero_learning";
    const LEARNING_MODEL_FIELD = "model";
    const LEARNING_MODEL = 1;

    const XP_KEY = "hero_xp";
    const STREAK_KEY = "hero_streak";
    const LAST_COMPLETION_KEY = "hero_last_completion";
    const SYNC_ENABLED_KEY = "hero_sync_enabled";
    // Shared by all three exercises (ADR-045). A later per-exercise split
    // adds "hero_goal_pushups" etc. and keeps this as the fallback, so the
    // spelling never has to change (ADR-003).
    const GOAL_KEY = "hero_goal";
    // Retired with the one-activity-per-day design (ADR-043): watches that
    // ran a dev build may still hold "hero_sync_day". Never reuse the name.
    const VALIDATION_LOG_KEY = "hero_validation_log";


    private var _storage as HeroSetStorage;
    private var _clock as HeroSetClock;
    // Sticky until the next user save starts: a later successful write in
    // the same save must not hide an earlier failed one (ADR-010).
    private var _writeFailed as Lang.Boolean = false;

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
        var savedDay = asNumberOrNull(_storage.getValue(DAY_KEY));
        if (savedDay == null || savedDay != today) {
            _set(DAY_KEY, today);
            resetDailyState();
        }
    }

    private function resetDailyState() as Void {
        var exercises = HeroSetRules.EXERCISES;
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
        _writeFailed = false;
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

    // XP on the NET gain in stored progress, capped at a fixed number of
    // reps (never the user's goal, ADR-045) so sheer volume cannot print
    // ranks, and ratcheted so add/subtract cycles pay at most once per
    // credited day.
    private function awardXpFor(exercise as Lang.Symbol, previous as Lang.Number, next as Lang.Number) as Void {
        if (next <= previous) {
            return;
        }
        var cap = HeroSetConfig.XP_DAILY_CAP_REPS;
        var newCredit = next > cap ? cap : next;
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

    // The day the daily mission was last completed, for subscribers that have
    // to decide whether the streak is still alive (ADR-044). Null until the
    // first completion.
    function getLastCompletionDay() as Lang.Number? {
        return asNumberOrNull(_storage.getValue(LAST_COMPLETION_KEY));
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
            hasWriteFailure(),
            getGoal()
        );
    }

    function isDailyMissionComplete() as Lang.Boolean {
        return HeroSetRules.missionComplete(getCount(:pushups), getCount(:situps), getCount(:squats), getGoal());
    }

    // ------------------------------------------------------------------
    // Garmin Connect sync (opt-in — ADR-043)
    // ------------------------------------------------------------------

    // ------------------------------------------------------------------
    // Daily goal (ADR-045)
    // ------------------------------------------------------------------

    function getGoal() as Lang.Number {
        var stored = asNumberOrNull(_storage.getValue(GOAL_KEY));
        // Unset or a corrupt 0 both mean "never chosen": fall back to the
        // default, not to the bottom of the range.
        return stored == null || stored <= 0 ? HeroSetConfig.DEFAULT_MISSION_GOAL : HeroSetRules.clampGoal(stored);
    }

    // Lowering the goal below today's counts has to finish the day right
    // away, so the streak doesn't wait for the next rep to be logged.
    function setGoal(goal as Lang.Number) as Void {
        _writeFailed = false;
        _set(GOAL_KEY, HeroSetRules.clampGoal(goal));
        updateCompletion();
    }

    function isSyncEnabled() as Lang.Boolean {
        return _storage.getValue(SYNC_ENABLED_KEY) == true;
    }

    function setSyncEnabled(enabled as Lang.Boolean) as Void {
        _set(SYNC_ENABLED_KEY, enabled);
    }

    private function updateCompletion() as Void {
        if (!isDailyMissionComplete()) {
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
        _set(VALIDATION_LOG_KEY, log.slice(-HeroSetConfig.VALIDATION_LOG_MAX_ENTRIES, null));
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
        var monthDay = (_clock.todayKey() % 10000).format("%04d");
        return monthDay + " " + label + " " + detected + "->" + savedCount + " " + errorText;
    }

    // ------------------------------------------------------------------
    // Learned thresholds (ADR-040)
    // ------------------------------------------------------------------

    function getLearningState(exercise as Lang.Symbol) as Lang.Array<Lang.Float> {
        var learning = _storage.getValue(LEARNING_KEY);
        if (learning instanceof Dictionary && asNumber(learning[LEARNING_MODEL_FIELD], 0) == LEARNING_MODEL) {
            var state = learning[exerciseKeyString(exercise)];
            if (state instanceof Array && state.size() == 2 * HeroSetConfig.LEARN_BINS) {
                return state as Lang.Array<Lang.Float>;
            }
        }
        return HeroSetThresholdLearner.initialState();
    }

    function setLearningState(exercise as Lang.Symbol, state as Lang.Array<Lang.Float>) as Void {
        var learning = _storage.getValue(LEARNING_KEY);
        if (!(learning instanceof Dictionary) || asNumber(learning[LEARNING_MODEL_FIELD], 0) != LEARNING_MODEL) {
            learning = {LEARNING_MODEL_FIELD => LEARNING_MODEL};
        }
        learning[exerciseKeyString(exercise)] = state;
        _set(LEARNING_KEY, learning);
    }

    // ------------------------------------------------------------------
    // Storage helpers
    // ------------------------------------------------------------------

    function hasWriteFailure() as Lang.Boolean {
        return _writeFailed;
    }

    // Broad catch on purpose: StorageFullException is the expected case, but
    // any failed write means the numbers on screen may not survive a restart,
    // which is exactly what the footer warning says.
    private function _set(key as Lang.String, value as Storage.ValueType) as Void {
        try {
            _storage.setValue(key, value);
        } catch (ex) {
            _writeFailed = true;
            System.println("[HeroSet] write " + key + ": " + ex.getErrorMessage());
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

    // Storage.setValue forbids Symbol as a Dictionary key or value ("Symbols
    // can change from build to build") and throws UnexpectedTypeException —
    // confirmed crashing on a physical FR965. The LEARNING_KEY dictionary
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

    // Per-exercise "credit ratchet" ("hero_credit_pushups", ...): the
    // highest min(count, XP_DAILY_CAP_REPS) seen today. XP only ever pays the positive difference
    // against the ratchet, so add(+10)/add(-10) farming earns XP once.
    private function creditKeyFor(exercise as Lang.Symbol) as Lang.String {
        return "hero_credit_" + exerciseKeyString(exercise);
    }
}

