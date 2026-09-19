import Toybox.Lang;
import Toybox.WatchUi;

class HeroSetWorkoutDelegate extends WatchUi.BehaviorDelegate {

    private var _view;

    function initialize(view as HeroSetWorkoutView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    // Finish is the only way a set ends deliberately — no pause/resume,
    // counting just runs until this is pressed. Rather than bank the
    // detected count directly, hand it to the manual delta picker (seeded
    // with the detected count) so a miscounted set can be corrected before
    // it's saved.
    function onSelect() as Boolean {
        var pickerView = new HeroSetManualPickerView(_view.getExercise(), _view.getCount(), _view.getCount(), _view.getDetectedCount(), _view.getTrace());
        // Pop the workout view first so the picker sits directly on the
        // dashboard (depth 1) — the same depth every other picker caller
        // maintains, which is what lets HeroSetManualPickerDelegate use a
        // single deterministic pop count back to the dashboard on save.
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(pickerView, new HeroSetManualPickerDelegate(pickerView), WatchUi.SLIDE_UP);
        return true;
    }

    // Back never silently drops counted reps: with reps on the board, offer
    // Garmin's native activity-end choice (Resume/Save/Discard) instead of
    // leaving. With nothing counted there is nothing to lose.
    // Gated on the live count, not the saved one: a lone rep learned to be
    // getting up (ADR-040) is still movement the user may want to keep.
    function onBack() as Boolean {
        if (_view.getDetectedCount() <= 0) {
            return false;
        }
        var menu = new Rez.Menus.WorkoutEndMenu();
        menu.setTitle(HeroSetText.reps(_view.getCount(), false));
        WatchUi.pushView(menu, new HeroSetWorkoutEndMenuDelegate(_view), WatchUi.SLIDE_UP);
        return true;
    }
}
