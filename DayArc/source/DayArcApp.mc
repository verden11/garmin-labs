import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class DayArcApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    // One wearer setting only — Accent colour (ADR-014, which reverses ADR-011's "no settings
    // surface" for this ONE setting; density stays compile-time, ADR-003). Everything else here is
    // still a build-time choice.
    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new DayArcView()];
    }

    // The watch's own "Customize" screen next to Apply in the watch-face picker (CIQ 4.2+), so the
    // one setting is reachable without a phone. A plain list, focus on the current choice, writing
    // the same Properties key the phone's Connect page does (last change wins) — TwoSuns's
    // list-menu pattern, whose route Days To Go ADR-005 verified on an FR965 (the route, not the
    // phone/watch overwrite question). A failure here must never take the face down, so it opens
    // nothing rather than throw.
    function getSettingsView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] or Null {
        if (DayArcPalette.MONO) {
            return null;   // the one setting is Accent, which a 1-bit display cannot show (ADR-015)
        }
        try {
            var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.setting_accent) as String});
            var labels = [Rez.Strings.accent_auto, Rez.Strings.accent_cyan, Rez.Strings.accent_amber, Rez.Strings.accent_rose,
                          Rez.Strings.accent_green, Rez.Strings.accent_blue, Rez.Strings.accent_purple] as Array<ResourceId>;
            for (var i = 0; i < labels.size(); i++) {
                var hint = i == DayArcConfig.ACCENT_AUTO ? WatchUi.loadResource(Rez.Strings.accent_auto_hint) as String : null;
                menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(labels[i]) as String, hint, i, null));
            }
            menu.setFocus(DayArcSettings.accentChoice());
            return [menu, new DayArcAccentDelegate()];
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // A change from the phone applies on the next update, no restart.
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
