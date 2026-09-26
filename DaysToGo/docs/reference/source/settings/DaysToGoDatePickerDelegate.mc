import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Saves the picked date to the very Properties the phone settings use, and
// switches the Event to "My own date" so the pick is visible at once.
class DaysToGoDatePickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onAccept(values as Array) as Boolean {
        var month = values[0];
        var day = values[1];
        var year = values[2];
        if (month instanceof Number && day instanceof Number && year instanceof Number) {
            Application.Properties.setValue(DaysToGoConfig.KEY_MONTH, month);
            Application.Properties.setValue(DaysToGoConfig.KEY_DAY, day);
            Application.Properties.setValue(DaysToGoConfig.KEY_YEAR, year);
            Application.Properties.setValue(DaysToGoConfig.KEY_EVENT, DaysToGoConfig.EVENT_CUSTOM);
        }
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
