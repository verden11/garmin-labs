import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetValidationLogDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetValidationLogView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onKeyPressed(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_UP) {
            _view.previousPage();
            return true;
        }
        if (key == WatchUi.KEY_DOWN) {
            _view.nextPage();
            return true;
        }
        return false;
    }

    function onBack() as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
