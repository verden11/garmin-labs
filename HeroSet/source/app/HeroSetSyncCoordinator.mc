import Toybox.Lang;
import Toybox.System;

// Opt-in Connect sync (ADR-043): each HeroSet visit with saved workout reps
// becomes one Garmin Connect activity, one lap per set. A session can't
// outlive the app (ADR-030), so the visit is the unit and stop() always
// saves or discards it before HeroSet exits. Only workout-seeded saves count
// (same boundary as learning, ADR-040); main-menu manual entries have no
// real time or HR behind them. Every outcome lands in the on-watch
// Validation Log, the only way to check this on a real watch:
//   SYNC NEW          first set of the visit opened a recording
//   SYNC SAVED m:ss   visit saved for Garmin Connect
//   SYNC EMPTY        no saved reps, recording discarded
//   SYNC OFF          sync turned off mid-visit, recording discarded
//   SYNC FAIL         the watch wouldn't start, save or discard recording
// Dev build only until the device acceptance in connect-sync-plan.md passes;
// the store build compiles the (:nosync) twin.
(:sync)
class HeroSetSyncCoordinator {

    private var _store as HeroSetStore;
    private var _activity as HeroSetActivitySync;
    private var _lapExercise as Lang.Symbol = :pushups;
    private var _lapReps as Lang.Number = 0;
    private var _totals as Lang.Array<Lang.Number> = [0, 0, 0];

    function initialize(store as HeroSetStore) {
        _store = store;
        _activity = new HeroSetActivitySync();
    }

    // Tests drive the lap/save sequence against a fake recording.
    (:debug)
    function useActivityForTest(activity as HeroSetActivitySync) as Void {
        _activity = activity;
    }

    // A new set screen's first onShow. A later set closes the previous
    // set's lap where this one begins.
    function beginSet(exercise as Lang.Symbol) as Void {
        if (_activity.isOpen()) {
            _activity.resume();
            _activity.closeLap(fitLabel(_lapExercise), _lapReps);
        } else if (!_store.isSyncEnabled() || !(Toybox has :ActivityRecording)) {
            return;
        } else if (_activity.open()) {
            log(Rez.Strings.sync_log_new, []);
        } else {
            log(Rez.Strings.sync_log_fail, []);
            return;
        }
        _lapExercise = exercise;
        _lapReps = 0;
    }

    // Same set shown again (Resume, notification dismissed): no new lap.
    function resumeSet() as Void {
        _activity.resume();
    }

    function pauseSet() as Void {
        _activity.pause();
    }

    // The running set's reps as saved (picker or Back → Save). A negative
    // correction fixes an earlier over-count, so it lowers the visit total
    // too; the set's own lap can't go below 0.
    function setSaved(reps as Lang.Number) as Void {
        if (!_activity.isOpen()) {
            return;
        }
        _lapReps = lapReps(reps);
        var index = HeroSetRules.EXERCISES.indexOf(_lapExercise);
        _totals[index] = lapReps(_totals[index] + reps);
    }

    // AppBase.onStop: the recording must not outlive HeroSet (ADR-030).
    function stop() as Void {
        if (!_activity.isOpen()) {
            return;
        }
        if (_totals[0] + _totals[1] + _totals[2] > 0) {
            var recorded = _activity.recordedMs();
            if (_activity.finish(fitLabel(_lapExercise), _lapReps, _totals)) {
                log(Rez.Strings.sync_log_saved, [HeroSetText.duration(recorded)]);
            } else {
                log(Rez.Strings.sync_log_fail, []);
            }
        } else {
            drop(Rez.Strings.sync_log_empty);
        }
    }

    // Turning sync off drops the visit's recording: the user just said
    // they don't want it in Connect.
    function setEnabled(enabled as Lang.Boolean) as Void {
        _store.setSyncEnabled(enabled);
        if (!enabled && _activity.isOpen()) {
            drop(Rez.Strings.sync_log_off);
            _totals = [0, 0, 0];
        }
    }

    private function drop(logLine as Lang.ResourceId) as Void {
        log(_activity.abandon() ? logLine : Rez.Strings.sync_log_fail, []);
    }

    // Connect never shows a negative count.
    static function lapReps(saved as Lang.Number) as Lang.Number {
        return saved > 0 ? saved : 0;
    }

    private static function fitLabel(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return HeroSetText.load(Rez.Strings.fit_label_pushups);
        }
        if (exercise == :situps) {
            return HeroSetText.load(Rez.Strings.fit_label_situps);
        }
        return HeroSetText.load(Rez.Strings.fit_label_squats);
    }

    // Time of day first, so a line can be matched to when HeroSet was used.
    private function log(id as Lang.ResourceId, args as Lang.Array) as Void {
        var time = System.getClockTime();
        var clock = time.hour.format("%02d") + ":" + time.min.format("%02d");
        _store.logDiagnostic(HeroSetText.format(id, [clock].addAll(args)));
    }
}
