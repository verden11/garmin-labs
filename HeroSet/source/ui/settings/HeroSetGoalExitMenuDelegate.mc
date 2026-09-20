import Toybox.Lang;
import Toybox.WatchUi;

// Back-menu for the goal picker with an unsaved value: Save / Discard /
// Keep Editing. Navigation lives in HeroSetExitMenuDelegate.
class HeroSetGoalExitMenuDelegate extends HeroSetExitMenuDelegate {

    private var _view as HeroSetGoalPickerView;

    function initialize(view as HeroSetGoalPickerView) {
        HeroSetExitMenuDelegate.initialize();
        _view = view;
    }

    function save() as Void {
        _view.saveEntry();
    }
}
