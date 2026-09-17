import Toybox.Lang;
import Toybox.WatchUi;

// Back-menu for a set with counted reps. The menu sits on the workout, which
// sits directly on the dashboard (ADR-024), so leaving the set is always
// exactly two pops; Resume is one. Menu2 never pops itself on select.
class HeroSetWorkoutEndMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _view as HeroSetWorkoutView;

    function initialize(view as HeroSetWorkoutView) {
        Menu2InputDelegate.initialize();
        _view = view;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :save) {
            _view.saveSet();
            leaveSet();
        } else if (id == :discard) {
            HeroSetSaveFeedback.showDiscarded();
            leaveSet();
        } else {
            resume();
        }
    }

    function onBack() as Void {
        resume();
    }

    // onShow re-enables the sensor listener, so counting picks up where it
    // left off.
    private function resume() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function leaveSet() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
    }
}
