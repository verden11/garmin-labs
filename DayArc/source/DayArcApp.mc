import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class DayArcApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    // No settings surface, either density (docs/decisions.md ADR-011): every choice here is a
    // build-time one (ADR-003), which sidesteps this platform's #1 complaint category — settings
    // not saving — entirely rather than partially.
    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new DayArcView()];
    }
}
