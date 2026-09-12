import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetWorkoutMenuDelegate extends WatchUi.MenuInputDelegate {

    private var _view;

    function initialize(view as HeroSetWorkoutView) {
        MenuInputDelegate.initialize();
        _view = view;
    }

    function onMenuItem(item as Lang.Symbol) as Void {
        if (item == :workout_plus_one) {
            _view.adjust(1);
        } else if (item == :workout_plus_five) {
            _view.adjust(5);
        } else if (item == :workout_minus_one) {
            _view.adjust(-1);
        } else if (item == :workout_finish) {
            _view.saveSet();
            // Finish is only reachable from the workout menu, so exactly two
            // views (menu + workout) sit above the dashboard; two pops are
            // deterministic by construction.
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.requestUpdate();
            return;
        }

        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
    }
}
