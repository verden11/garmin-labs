import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// The stock Picker never clears its background: on a colour MIP watch the white text can land on white. Clear to
// black first, as the SDK's own Picker sample does (samples/Picker/source/pickers/DatePicker.mc).
class DaysToGoDatePicker extends WatchUi.Picker {

    function initialize(title as WatchUi.Drawable, pattern as Array<WatchUi.Drawable or WatchUi.PickerFactory>, defaults as Array<Number>) {
        Picker.initialize({:title => title, :pattern => pattern, :defaults => defaults});
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}
