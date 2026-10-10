import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// The glance process loads this whole class, so nothing reachable from initialize/onStart/onStop may touch the
// foreground-only classes (Position, the view). Both are built on the first foreground use (HeroSet ADR-051's lesson;
// tools/glance-scope-check.sh catches what a default build does not).
(:glance)
class SunWindowApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // Empty on purpose: onStart also runs for the glance.
    function onStart(state as Dictionary?) as Void {
    }

    function getGlanceView() as [WatchUi.GlanceView] or [WatchUi.GlanceView, WatchUi.GlanceViewDelegate] or Null {
        return [new SunWindowGlanceView()];
    }

    (:typecheck(disableGlanceCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new SunWindowView();
        return [view, new SunWindowDelegate(view)];
    }

    // A change from Garmin Connect applies on the next draw.
    (:typecheck(disableGlanceCheck))
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}
