import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetCalibrationDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetCalibrationView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Lang.Boolean {
        _view.toggleCalibration();
        return true;
    }

    function onMenu() as Lang.Boolean {
        return onSelect();
    }
}
