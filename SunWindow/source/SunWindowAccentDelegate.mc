import Toybox.Lang;
import Toybox.WatchUi;

// Select in the accent list: store the choice (the item id is the list value settings.xml uses, so no lookup table),
// redraw, close. Logic from DayArc's DayArcAccentDelegate; here the menu is pushed from onMenu, not returned by
// getSettingsView, so popView returns to the app.
class SunWindowAccentDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id instanceof Lang.Number) {
            SunWindowSettings.save(id);
            WatchUi.requestUpdate();
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
