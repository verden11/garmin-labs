import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetRunDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetRunView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Lang.Boolean {
        _view.finishRun();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
    }

    function onMenu() as Lang.Boolean {
        return onSelect();
    }
}
