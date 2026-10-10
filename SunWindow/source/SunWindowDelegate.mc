import Toybox.Lang;
import Toybox.WatchUi;

// START asks for a fresh place; the menu button opens the accent list (ADR-009: getSettingsView only serves watch faces
// and data fields, so an app builds its own). On a 1-bit Instinct there is no accent to choose: onMenu does nothing there.
class SunWindowDelegate extends WatchUi.BehaviorDelegate {
    private var _view as SunWindowView;

    function initialize(view as SunWindowView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        _view.ask();
        return true;
    }

    function onMenu() as Boolean {
        if (SunWindowPalette.MONO) {
            return false;
        }
        var menu = new WatchUi.Menu2({:title => SunWindowText.load(Rez.Strings.setting_accent)});
        var labels = [Rez.Strings.accent_sky, Rez.Strings.accent_mint, Rez.Strings.accent_amber, Rez.Strings.accent_pink,
                      Rez.Strings.accent_violet, Rez.Strings.accent_white] as Array<ResourceId>;
        for (var i = 0; i < labels.size(); i++) {
            menu.addItem(new WatchUi.MenuItem(SunWindowText.load(labels[i]), null, i, null));
        }
        menu.setFocus(SunWindowSettings.accent());
        WatchUi.pushView(menu, new SunWindowAccentDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}
