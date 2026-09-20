import Toybox.Lang;
import Toybox.WatchUi;

// Same input contract as the manual delta picker: one press per step, no
// hold-to-accelerate (ADR-029), one deterministic pop back to the dashboard.
class HeroSetGoalPickerDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetGoalPickerView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onPreviousPage() as Lang.Boolean {
        _view.adjust(1);
        return true;
    }

    function onNextPage() as Lang.Boolean {
        _view.adjust(-1);
        return true;
    }

    function onSelect() as Lang.Boolean {
        _view.saveEntry();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
        return true;
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
