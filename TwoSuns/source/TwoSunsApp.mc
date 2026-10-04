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
        if (!offersSettings()) {
            return null;
        }
        try {
            return [new TwoSunsSettingsMenu(), new TwoSunsSettingsDelegate()];
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Free's one setting is Accent, which a 1-bit display cannot show (ADR-024): an Instinct Free has no settings at all.
    // Pro keeps Orientation, Curve, Date, Weather and Battery everywhere.
    (:free)
    private function offersSettings() as Boolean {
        return !TwoSunsPalette.MONO;
    }

    (:pro)
    private function offersSettings() as Boolean {
        return true;
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
