import Toybox.Lang;
import Toybox.WatchUi;

// A plain list of named choices for one setting (Accent colour, 6; Ring orientation, 2). Item id
// is the value to store, 0-based, the same values settings.xml's listEntry uses, so the delegate
// needs no lookup table.
class TwoSunsListMenu extends WatchUi.Menu2 {
    function initialize(title as String, labels as Array<String>, current as Number) {
        Menu2.initialize({:title => title});
        for (var i = 0; i < labels.size(); i++) {
            addItem(new WatchUi.MenuItem(labels[i], null, i, null));
        }
        if (current >= 0 && current < labels.size()) {
            setFocus(current);
        }
    }
}
