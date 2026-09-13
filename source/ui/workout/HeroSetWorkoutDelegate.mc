import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetWorkoutDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetWorkoutView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        _view.toggleRunning();
        return true;
    }

    function onMenu() as Boolean {
        _view.beginChildOverlay();
        WatchUi.pushView(new Rez.Menus.WorkoutMenu(), new HeroSetWorkoutMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
    }

    // Back never silently drops counted reps: with reps on the board, pop a
    // "Save N reps?" confirmation instead of leaving.
    function onBack() as Boolean {
        if (_view.getCount() > 0) {
            _view.beginChildOverlay();
            WatchUi.pushView(
                new WatchUi.Confirmation(saveLabel()),
                new HeroSetWorkoutConfirmDelegate(_view),
                WatchUi.SLIDE_UP
            );
            return true;
        }
        return false;
    }

    private function saveLabel() as Lang.String {
        var count = _view.getCount();
        return "Save " + count + (count == 1 ? " rep?" : " reps?");
    }
}
