import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class DaysToGoApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new DaysToGoView()];
    }

    // The watch's own Customize screen (API 2.3, listed for 94 of the 117
    // products): set the date without the phone. A failure here must never
    // take the face down, so it opens nothing rather than throw.
    function getSettingsView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] or Null {
        try {
            return [new DaysToGoSettingsMenu(), new DaysToGoSettingsDelegate()];
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
