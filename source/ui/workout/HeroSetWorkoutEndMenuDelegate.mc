import Toybox.Lang;
import Toybox.WatchUi;

// Back-menu for a set with counted reps: Garmin's native activity-end
// choice (Resume/Save/Discard). Navigation lives in HeroSetExitMenuDelegate.
class HeroSetWorkoutEndMenuDelegate extends HeroSetExitMenuDelegate {

    private var _view as HeroSetWorkoutView;

    function initialize(view as HeroSetWorkoutView) {
        HeroSetExitMenuDelegate.initialize();
        _view = view;
    }

    function save() as Void {
        _view.saveSet();
    }
}
