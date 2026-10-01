import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TwoSunsSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == TwoSunsSettingsMenu.ITEM_ACCENT) {
            pushList(WatchUi.loadResource(Rez.Strings.setting_accent) as String, TwoSunsConfig.KEY_ACCENT, accentLabels(), TwoSunsSettings.load().accent);
        } else {
            selectPro(item);
        }
    }

    // The four Pro items. Free has none, and Free must never write a Pro key (setValue of a key the properties
    // file lacks throws), so this does nothing there.
    (:pro)
    private function selectPro(item as WatchUi.MenuItem) as Void {
        if (item.getId() == TwoSunsSettingsMenu.ITEM_ORIENTATION) {
            pushList(WatchUi.loadResource(Rez.Strings.setting_orientation) as String, TwoSunsConfig.KEY_ORIENTATION, orientationLabels(), TwoSunsSettings.load().orientation);
        } else if (item instanceof WatchUi.ToggleMenuItem) {
            applyToggle(item);
        }
    }

    (:free)
    private function selectPro(item as WatchUi.MenuItem) as Void {
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    // Menu2 has already flipped the toggle by the time onSelect runs, so the item's state is the
    // wearer's new choice. No confirmation: the state is on screen and one more press undoes it.
    (:pro)
    private function applyToggle(item as WatchUi.ToggleMenuItem) as Void {
        var key = TwoSunsConfig.KEY_DATE;
        if (item.getId() == TwoSunsSettingsMenu.ITEM_GOLDEN) {
            key = TwoSunsConfig.KEY_GOLDEN;
        } else if (item.getId() == TwoSunsSettingsMenu.ITEM_CURVE) {
            key = TwoSunsConfig.KEY_CURVE;
        }
        Application.Properties.setValue(key, item.isEnabled() ? TwoSunsConfig.ON : TwoSunsConfig.OFF);
        WatchUi.requestUpdate();
    }

    private function pushList(title as String, key as String, labels as Array<String>, current as Number) as Void {
        WatchUi.pushView(new TwoSunsListMenu(title, labels, current), new TwoSunsListDelegate(key), WatchUi.SLIDE_UP);
    }

    private function accentLabels() as Array<String> {
        return [
            WatchUi.loadResource(Rez.Strings.accent_sky) as String,
            WatchUi.loadResource(Rez.Strings.accent_mint) as String,
            WatchUi.loadResource(Rez.Strings.accent_autumn) as String,
            WatchUi.loadResource(Rez.Strings.accent_violet) as String,
            WatchUi.loadResource(Rez.Strings.accent_pink) as String,
            WatchUi.loadResource(Rez.Strings.accent_winter) as String,
        ];
    }

    (:pro)
    private function orientationLabels() as Array<String> {
        return [
            WatchUi.loadResource(Rez.Strings.orientation_noon) as String,
            WatchUi.loadResource(Rez.Strings.orientation_midnight) as String,
        ];
    }
}
