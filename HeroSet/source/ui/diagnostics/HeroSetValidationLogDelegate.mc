import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetValidationLogDelegate extends WatchUi.BehaviorDelegate {

    private var _view as HeroSetValidationLogView;

    function initialize(view as HeroSetValidationLogView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Page behaviors, not raw keys: UP/DOWN on a five-button watch, swipes
    // on a touch-first one (ADR-048).
    function onPreviousPage() as Lang.Boolean {
        _view.previousPage();
        return true;
    }

    function onNextPage() as Lang.Boolean {
        _view.nextPage();
        return true;
    }

    function onBack() as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
