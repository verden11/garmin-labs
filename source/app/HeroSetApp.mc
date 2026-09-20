import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetApp extends Application.AppBase {

    private var _store;
    private var _sync;

    function initialize() {
        AppBase.initialize();
        _store = new HeroSetStore(null, null);
        _sync = new HeroSetSyncCoordinator(_store);
    }

    function onStart(state as Dictionary?) as Void {
        _store.ensureCurrentDay();
        HeroSetComplicationPublisher.publish(_store);
    }

    function onStop(state as Dictionary?) as Void {
        _sync.stop();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new HeroSetView(), new HeroSetDelegate() ];
    }

    function getStore() as HeroSetStore {
        return _store;
    }

    function getSync() as HeroSetSyncCoordinator {
        return _sync;
    }

    // Screen-fit tests draw real views against a seeded in-memory store
    // instead of the simulator's persistent one. Returns the store it replaced.
    // (:debug), not (:test): the runner would call a (:test) method as a test
    // case; release (-r) builds strip it.
    (:debug)
    function swapStoreForTest(store as HeroSetStore) as HeroSetStore {
        var previous = _store;
        _store = store;
        return previous;
    }

}

function getApp() as HeroSetApp {
    return Application.getApp() as HeroSetApp;
}
