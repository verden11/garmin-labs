import Toybox.Lang;
import Toybox.WatchUi;

// Response handler for the workout back-confirmation ("Save N reps?").
// CONFIRM: bank the set and leave. CANCEL: return to the workout, still
// counting (onShow re-enables the sensor listener).
class HeroSetWorkoutConfirmDelegate extends WatchUi.ConfirmationDelegate {

    private var _view;

    function initialize(view as HeroSetWorkoutView) {
        ConfirmationDelegate.initialize();
        _view = view;
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            _view.saveSet();
            // Pop the confirmation, then the workout below it (the
            // confirmation is only ever pushed over the workout).
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else {
            // Back into the workout; onShow re-enables the sensor listener.
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        WatchUi.requestUpdate();
        return true;
    }
}
