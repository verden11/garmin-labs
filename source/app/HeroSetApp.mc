import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetApp extends Application.AppBase {

    private var _store;

    function initialize() {
        AppBase.initialize();
        _store = new HeroSetStore(null, null);
    }

    function onStart(state as Dictionary?) as Void {
        _store.ensureCurrentDay();
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new HeroSetView(), new HeroSetDelegate() ];
    }

    function getStore() as HeroSetStore {
        return _store;
    }

}

function getApp() as HeroSetApp {
    return Application.getApp() as HeroSetApp;
}
