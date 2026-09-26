import Toybox.Lang;
import Toybox.WatchUi;

// The watch's own "Customize" screen for the face (CIQ 3.0+, AppBase.getSettingsView).
// One item for now: set the date on the watch, no phone needed.
class DaysToGoSettingsMenu extends WatchUi.Menu2 {
    static const ITEM_DATE = :date;

    function initialize() {
        Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.settings_title) as String});
        addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_set_date) as String, null, ITEM_DATE, null));
    }
}
