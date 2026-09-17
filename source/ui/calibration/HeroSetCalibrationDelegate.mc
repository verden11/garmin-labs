import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetCalibrationDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetCalibrationView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // START only — Menu is a long-press of Up on the FR965, and long-presses
    // aren't in-app gestures (ADR-029).
    function onSelect() as Lang.Boolean {
        _view.toggleCalibration();
        return true;
    }
}
