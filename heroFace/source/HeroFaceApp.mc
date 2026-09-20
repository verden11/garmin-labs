import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class HeroFaceApp extends Application.AppBase {

    private var _link as HeroFaceLink;
    private var _view as HeroFaceView?;

    function initialize() {
        AppBase.initialize();
        _link = new HeroFaceLink();
    }

    // Subscribing needs the system's complication list, so it waits for start
    // rather than running in the constructor.
    function onStart(state as Dictionary?) as Void {
        _link.start();
    }

    // The delegate exists only to open HeroSet on a hold; watches without the
    // class take the view alone, and on those with it, a hold is a no-op until
    // the face is actually linked.
    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        var view = new HeroFaceView(_link);
        _view = view;
        if (WatchUi has :WatchFaceDelegate) {
            return [view, new HeroFaceDelegate(_link)];
        }
        return [view];
    }

    function view() as HeroFaceView? {
        return _view;
    }

    function onSettingsChanged() as Void {
        var view = _view;
        if (view != null) {
            view.reloadSettings();
        }
        WatchUi.requestUpdate();
    }
}

function getApp() as HeroFaceApp {
    return Application.getApp() as HeroFaceApp;
}
