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
        var pickerView = new HeroSetManualPickerView(_view.getExercise(), _view.getCount());
        // Pop the workout view first so the picker sits directly on the
        // dashboard (depth 1) — the same depth every other picker caller
        // maintains, which is what lets HeroSetManualPickerDelegate use a
        // single deterministic pop count back to the dashboard on save.
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(pickerView, new HeroSetManualPickerDelegate(pickerView), WatchUi.SLIDE_UP);
        return true;
    }

    // Back never silently drops counted reps: with reps on the board, pop a
    // "Save N reps?" confirmation instead of leaving.
    function onBack() as Boolean {
        if (_view.getCount() > 0) {
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
