import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TwoSunsApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new TwoSunsView()];
    }

    // The watch's own "Customize" screen next to Apply in the watch-face picker (CIQ 4.2+). A
    // failure here must never take the face down, so it opens nothing rather than throw.
    function getSettingsView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] or Null {
        try {
            return [new TwoSunsSettingsMenu(), new TwoSunsSettingsDelegate()];
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
