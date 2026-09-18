import Toybox.Lang;
import Toybox.System;

// Ties opt-in Connect sync (ADR-025) together: the store knows which day the
// open recording belongs to, HeroSetActivitySync owns the recording itself.
// Every step also lands in the on-watch Validation Log (ADR-030) because
// whether an unsaved recording survives HeroSet closing is undocumented and
// can only be observed on the watch. Those lines are the test:
//   SYNC NEW          first set of the day, fresh recording (expected)
//   SYNC KEPT m:ss    a later set picked up today's recording (it survived)
//   SYNC LOST         a later set found no recording left (it didn't)
//   SYNC SAVED m:ss   a finished recording was saved for Garmin Connect
//   SYNC EMPTY        nothing to save, so it was discarded
// Dev build only: v1 ships without Connect sync (ADR-033), and the store
// build compiles HeroSetSyncOff instead.
(:sync)
class HeroSetSyncCoordinator {

    static function beginSet(sync as HeroSetActivitySync) as Void {
        var store = getApp().getStore();
        if (!store.isSyncEnabled()) {
            return;
        }
        var today = HeroSetCalendar.todayKey();
        var sessionDay = store.getSyncSessionDay();
        if (sessionDay != null && sessionDay != today) {
            logClose(store, sync.closeOpenSession());
        }
        var carried = sync.beginSet();
        store.setSyncSessionDay(today);
        if (sessionDay != today) {
            store.logDiagnostic(HeroSetText.format(Rez.Strings.sync_log_new, [clockText()]));
        } else if (carried > 0) {
            store.logDiagnostic(HeroSetText.format(Rez.Strings.sync_log_kept, [clockText(), HeroSetText.duration(carried)]));
        } else {
            store.logDiagnostic(HeroSetText.format(Rez.Strings.sync_log_lost, [clockText()]));
        }
    }

    // Turning sync off saves the day's recording now; nothing touches the
    // recording while sync is off, so otherwise it would never be saved.
    static function setEnabled(enabled as Lang.Boolean) as Void {
        var store = getApp().getStore();
        store.setSyncEnabled(enabled);
        if (enabled || store.getSyncSessionDay() == null) {
            return;
        }
        logClose(store, new HeroSetActivitySync().closeOpenSession());
        store.clearSyncSessionDay();
    }

    private static function logClose(store as HeroSetStore, recordedMs as Lang.Number) as Void {
        if (recordedMs > 0) {
            store.logDiagnostic(HeroSetText.format(Rez.Strings.sync_log_saved, [clockText(), HeroSetText.duration(recordedMs)]));
        } else {
            store.logDiagnostic(HeroSetText.format(Rez.Strings.sync_log_empty, [clockText()]));
        }
    }

    // Time of day, so a log line can be matched to when HeroSet was reopened.
    private static function clockText() as Lang.String {
        var time = System.getClockTime();
        return time.hour.format("%02d") + ":" + time.min.format("%02d");
    }
}
