import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TwoSunsListDelegate extends WatchUi.Menu2InputDelegate {
    private var _key as String;

    function initialize(key as String) {
        Menu2InputDelegate.initialize();
        _key = key;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var value = item.getId();
        if (value instanceof Lang.Number) {
            Application.Properties.setValue(_key, value);
            WatchUi.requestUpdate();
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
