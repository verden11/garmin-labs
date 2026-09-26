import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// One picker column: parallel arrays of values (what gets saved) and labels.
class DaysToGoColumnFactory extends WatchUi.PickerFactory {
    private var _values as Array<Number>;
    private var _labels as Array<String>;

    function initialize(values as Array<Number>, labels as Array<String>) {
        PickerFactory.initialize();
        _values = values;
        _labels = labels;
    }

    function getSize() as Number {
        return _values.size();
    }

    function getValue(index as Number) as Object? {
        return _values[index];
    }

    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => _labels[index],
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_MEDIUM,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    // Where to start the column: the saved value, or the first entry.
    function indexOf(value as Number) as Number {
        for (var i = 0; i < _values.size(); i++) {
            if (_values[i] == value) {
                return i;
            }
        }
        return 0;
    }
}
