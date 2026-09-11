import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetApp extends Application.AppBase {

    private var _store;

    function initialize() {
        AppBase.initialize();
        _store = new HeroSetStore();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        _store.ensureCurrentDay();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
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
