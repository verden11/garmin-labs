import Toybox.Lang;
import Toybox.WatchUi;

// Goal picker input: one step is MISSION_GOAL_STEP (HeroSetPickerDelegate).
class HeroSetGoalPickerDelegate extends HeroSetPickerDelegate {

    private var _view as HeroSetGoalPickerView;

    function initialize(view as HeroSetGoalPickerView) {
        HeroSetPickerDelegate.initialize();
        _view = view;
    }

    function adjust(steps as Lang.Number) as Void {
        _view.adjust(steps);
    }

    function commit() as Void {
        _view.saveEntry();
    }

    // Back with an unsaved change asks rather than dropping it silently,
    // exactly like the delta picker.
    function onBack() as Lang.Boolean {
        if (!_view.isChanged()) {
            return false;
        }
        var menu = new Rez.Menus.ManualExitMenu();
        menu.setTitle(HeroSetText.format(Rez.Strings.toast_goal_saved, [_view.getGoal()]));
        WatchUi.pushView(menu, new HeroSetGoalExitMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
    }
}
