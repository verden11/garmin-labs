import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Lang;

// Wraps one combined Garmin Connect/Strava FIT activity per calendar day
// (opt-in, HeroSetStore.isSyncEnabled — ADR-025). One Session spans every
// set done that day: start()/stop() bracket each set's actual counting time
// so the synced activity's duration reflects real exercise time, not idle
// time between sets. No Storage access of its own (mirrors
// HeroSetSensorManager) — HeroSetSyncCoordinator decides when a stale
// day's session is closed and records what happened (ADR-030).
// Dev build only (ADR-033); the store build has no Fit permission.
(:sync)
class HeroSetActivitySync {
    private var _session;

    // Opens today's session, or gets back the one still open if the watch
    // kept it, and starts timing this set. Returns the timer time (ms) the
    // session already held: > 0 means an earlier set's recording carried
    // over; 0 means this is a fresh recording.
    function beginSet() as Lang.Number {
        if (!(Toybox has :ActivityRecording)) {
            return 0;
        }
        _session = ActivityRecording.createSession(sessionOptions());
        var carried = recordedMs();
        if (!_session.isRecording()) {
            _session.start();
        }
        return carried;
    }

    // Pause between sets — elapsed/timer time only accumulates while a set
    // is actually in progress.
    function endSet() as Void {
        if (_session != null && _session.isRecording()) {
            _session.stop();
        }
    }

    // Saves the open session only if it recorded time, discarding it
    // otherwise: createSession() hands back a fresh, empty session whenever
    // the earlier one didn't survive, and saving that would put a blank
    // activity in Garmin Connect. Returns the recorded timer time (ms);
    // 0 means nothing was saved.
    function closeOpenSession() as Lang.Number {
        if (!(Toybox has :ActivityRecording)) {
            return 0;
        }
        _session = ActivityRecording.createSession(sessionOptions());
        if (_session.isRecording()) {
            _session.stop();
        }
        var recorded = recordedMs();
        if (recorded > 0) {
            _session.save();
        } else {
            _session.discard();
        }
        _session = null;
        return recorded;
    }

    // Activity.Info describes the recording this app holds; no info yet
    // counts as nothing recorded.
    private function recordedMs() as Lang.Number {
        var info = Activity.getActivityInfo();
        var ms = info == null ? null : info.timerTime;
        return ms == null ? 0 : ms;
    }

    private function sessionOptions() as Lang.Dictionary {
        return {
            :name => "HeroSet",
            :sport => Activity.SPORT_TRAINING,
            :subSport => Activity.SUB_SPORT_STRENGTH_TRAINING
        };
    }
}
