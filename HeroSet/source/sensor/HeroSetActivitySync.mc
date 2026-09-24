import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.FitContributor;
import Toybox.Lang;

// One Garmin Connect activity per HeroSet visit (ADR-043): one lap per set,
// carrying that set's exercise and saved reps, plus visit totals on the
// session. Field ids match resources/fitcontributions and are baked into
// users' saved FIT files, so they never change (like storage keys, ADR-003).
// No Storage access of its own (mirrors HeroSetSensorManager);
// HeroSetSyncCoordinator decides what happens when.
// Dev build only until the device acceptance in connect-sync-plan.md passes;
// the store build has no Fit permission (ADR-033).
(:sync)
class HeroSetActivitySync {

    private const FIELD_LAP_EXERCISE = 0;
    private const FIELD_LAP_REPS = 1;
    private const FIELD_TOTAL_PUSHUPS = 2;
    private const FIELD_TOTAL_SITUPS = 3;
    private const FIELD_TOTAL_SQUATS = 4;
    // FIT strings have a fixed size, null terminator included.
    private const EXERCISE_BYTES = 32;

    private var _session as ActivityRecording.Session?;
    private var _lapExercise as FitContributor.Field?;
    private var _lapReps as FitContributor.Field?;
    private var _totals as Lang.Array<FitContributor.Field> = [];

    function initialize() {
    }

    function isOpen() as Lang.Boolean {
        return _session != null;
    }

    // Creates the session and its fields, then starts timing the first set.
    // False when the watch refused to start recording (e.g. another
    // activity is already recording); nothing is left open then. The
    // activity name and unit come from the caller: this layer doesn't load
    // UI text.
    function open(name as Lang.String, reps as Lang.String) as Lang.Boolean {
        var session = ActivityRecording.createSession({
            :name => name,
            :sport => Activity.SPORT_TRAINING,
            :subSport => Activity.SUB_SPORT_STRENGTH_TRAINING
        });
        _lapExercise = session.createField("exercise", FIELD_LAP_EXERCISE, FitContributor.DATA_TYPE_STRING, { :mesgType => FitContributor.MESG_TYPE_LAP, :count => EXERCISE_BYTES });
        _lapReps = session.createField("reps", FIELD_LAP_REPS, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_LAP, :units => reps });
        _totals = [
            session.createField("pushups", FIELD_TOTAL_PUSHUPS, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_SESSION, :units => reps }),
            session.createField("situps", FIELD_TOTAL_SITUPS, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_SESSION, :units => reps }),
            session.createField("squats", FIELD_TOTAL_SQUATS, FitContributor.DATA_TYPE_UINT16, { :mesgType => FitContributor.MESG_TYPE_SESSION, :units => reps })
        ];
        _session = session;
        if (!session.isRecording() && !session.start()) {
            abandon();
            return false;
        }
        return true;
    }

    // Timer runs only while a set screen is up, so rest, menu and picker
    // time stay out of the activity.
    function resume() as Void {
        var session = _session;
        if (session != null && !session.isRecording()) {
            session.start();
        }
    }

    function pause() as Void {
        var session = _session;
        if (session != null && session.isRecording()) {
            session.stop();
        }
    }

    // Closes the running lap with these values. Called right after resume()
    // for the next set, so the lap boundary sits where that set begins.
    function closeLap(exerciseName as Lang.String, reps as Lang.Number) as Void {
        var session = _session;
        if (session == null) {
            return;
        }
        writeLap(exerciseName, reps);
        session.addLap();
    }

    // Saves with the last lap and visit totals ([push-ups, sit-ups, squats]).
    // False when the watch refused to save; the session is then discarded
    // rather than left for the watch to save on its own (ADR-030).
    function finish(exerciseName as Lang.String, reps as Lang.Number, totals as Lang.Array<Lang.Number>) as Lang.Boolean {
        var session = _session;
        if (session == null) {
            return false;
        }
        writeLap(exerciseName, reps);
        for (var i = 0; i < _totals.size(); i++) {
            _totals[i].setData(totals[i]);
        }
        pause();
        var saved = session.save();
        if (!saved) {
            session.discard();
        }
        clear();
        return saved;
    }

    // False when the watch refused to discard.
    function abandon() as Lang.Boolean {
        var session = _session;
        if (session == null) {
            return true;
        }
        pause();
        var discarded = session.discard();
        clear();
        return discarded;
    }

    private function writeLap(exerciseName as Lang.String, reps as Lang.Number) as Void {
        var exercise = _lapExercise;
        var count = _lapReps;
        if (exercise != null && count != null) {
            exercise.setData(fitted(exerciseName));
            count.setData(reps);
        }
    }

    // Drops trailing characters until the UTF-8 bytes plus terminator fit.
    private function fitted(text as Lang.String) as Lang.String {
        while (text.length() > 0 && text.toUtf8Array().size() >= EXERCISE_BYTES) {
            text = text.substring(0, text.length() - 1) as Lang.String;
        }
        return text;
    }

    // Activity.Info describes the recording this app holds; read before
    // finish() for the log.
    function recordedMs() as Lang.Number {
        var info = Activity.getActivityInfo();
        var ms = info == null ? null : info.timerTime;
        return ms == null ? 0 : ms;
    }

    private function clear() as Void {
        _session = null;
        _lapExercise = null;
        _lapReps = null;
        _totals = [];
    }
}
