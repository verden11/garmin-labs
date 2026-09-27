import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// The glance process loads this whole class, so nothing reachable from
// initialize/onStart/onStop may touch the store (its constructor writes
// Storage) or the complication. Both are built on the first foreground use.
(:glance)
class HeroSetApp extends Application.AppBase {

    private var _store as HeroSetStore?;
    private var _sync as HeroSetSyncCoordinator?;

    function initialize() {
        AppBase.initialize();
    }

    // Empty on purpose: onStart also runs for the glance. The day rollover and
    // the ADR-044 publish moved to getInitialView.
    function onStart(state as Dictionary?) as Void {
    }

    (:typecheck(disableGlanceCheck))
    function onStop(state as Dictionary?) as Void {
        var sync = _sync;
        if (sync != null) {
            sync.stop();
        }
    }

    function getGlanceView() as [WatchUi.GlanceView] or [WatchUi.GlanceView, WatchUi.GlanceViewDelegate] or Null {
        return [ new HeroSetGlanceView() ];
    }

    (:typecheck(disableGlanceCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var store = getStore();
        store.ensureCurrentDay();
        HeroSetComplicationPublisher.publish(store);
        return [ new HeroSetView(), new HeroSetDelegate() ];
    }

    (:typecheck(disableGlanceCheck))
    function getStore() as HeroSetStore {
        var store = _store;
        if (store == null) {
            store = new HeroSetStore(null, null);
            _store = store;
        }
        return store;
    }

    (:typecheck(disableGlanceCheck))
    function getSync() as HeroSetSyncCoordinator {
        var sync = _sync;
        if (sync == null) {
            sync = new HeroSetSyncCoordinator(getStore());
            _sync = sync;
        }
        return sync;
    }

    // Screen-fit tests draw real views against a seeded in-memory store
    // instead of the simulator's persistent one. Returns the store it replaced.
    // (:debug), not (:test): the runner would call a (:test) method as a test
    // case; release (-r) builds strip it.
    (:debug)
    function swapStoreForTest(store as HeroSetStore) as HeroSetStore {
        var previous = getStore();
        _store = store;
        return previous;
    }

}

(:glance)
function getApp() as HeroSetApp {
    return Application.getApp() as HeroSetApp;
}
