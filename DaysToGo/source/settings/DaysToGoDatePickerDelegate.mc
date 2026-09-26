import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Saves the picked date to the very Properties the phone settings use, and
// switches the Event to "My own date" so the pick is visible at once.
class DaysToGoDatePickerDelegate extends WatchUi.PickerDelegate {
    private var _monthFirst as Boolean;

    // monthFirst says which of the first two columns is the month.
    function initialize(monthFirst as Boolean) {
        PickerDelegate.initialize();
        _monthFirst = monthFirst;
    }

    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onAccept(values as Array) as Boolean {
        var month = values[_monthFirst ? 0 : 1];
        var day = values[_monthFirst ? 1 : 0];
        var year = values[DaysToGoConfig.PICKER_YEAR_COLUMN];
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
