import Toybox.Lang;
import Toybox.WatchUi;

// The watch's own "Customize" screen (AppBase.getSettingsView, CIQ 4.2+): the same 5 settings as
// settings.xml (the phone app's page), reachable without a phone. Both write the same Properties
// keys, so whichever was used last wins (Days To Go ADR-005, same rule). Free has the Accent item only; Pro adds
// the other four (docs/decisions.md ADR-020, Free + Pro ladder): the Free menu names no Pro item and no locked row.
class TwoSunsSettingsMenu extends WatchUi.Menu2 {
    static const ITEM_ACCENT = :accent;
    (:pro)
    static const ITEM_ORIENTATION = :orientation;
    (:pro)
    static const ITEM_GOLDEN = :golden;
    (:pro)
    static const ITEM_CURVE = :curve;
    (:pro)
    static const ITEM_DATE = :date;

    function initialize() {
        Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.AppName) as String});
        addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.setting_accent) as String, null, ITEM_ACCENT, null));
        addProItems();
    }

    (:pro)
    private function addProItems() as Void {
        var settings = TwoSunsSettings.load();
        addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.setting_orientation) as String, null, ITEM_ORIENTATION, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.setting_golden) as String, null, ITEM_GOLDEN, settings.golden, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.setting_curve) as String, null, ITEM_CURVE, settings.curve, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.setting_date) as String, null, ITEM_DATE, settings.date, null));
    }

    (:free)
    private function addProItems() as Void {
    }
}
