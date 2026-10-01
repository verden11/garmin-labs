import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Select in the Customize list: store the choice (item id = the list value settings.xml uses, so
// no lookup table), redraw, close. Pattern from TwoSuns's TwoSunsListDelegate — with one difference
// that matters: THIS menu is the ROOT settings view (getSettingsView returns it directly), so popView
// leaves Customize altogether, whereas TwoSuns pops a sub-list pushed on top of its root menu. Days To
// Go's FR965 verification of the Customize route does not cover this select-then-exit path.
class DayArcAccentDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var value = item.getId();
        if (value instanceof Lang.Number) {
            try {
                Application.Properties.setValue(DayArcSettings.KEY_ACCENT, DayArcSettings.clampAccent(value));
            } catch (e instanceof Lang.Exception) {
                // A store that refuses the write must not take the Customize screen down with it.
            }
            WatchUi.requestUpdate();
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
