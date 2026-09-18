import Toybox.Lang;
import Toybox.WatchUi;

// Back-menu shared by the workout and the delta picker: Save / Discard /
// stay put. Both screens sit directly on the dashboard (every caller pops
// its own predecessor first, ADR-024), so leaving through this menu is
// always exactly two pops and staying is one. Menu2 never pops itself on
// select, so both are explicit.
//
// Subclasses override `save` with their own typed view's save call —
// inheritance rather than a stored Lang.Method, because indirect binding has
// failed silently on device before (ADR-023) and this is the save path. Public,
// not `hidden`: public override dispatch is the pattern already proven on
// device here (HeroSetStorage, HeroSetClock), and
// `exitMenusDispatchSaveToTheirView` asserts it rather than trusting a build.
class HeroSetExitMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function save() as Void {
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :save) {
            save();
            leave();
        } else if (id == :discard) {
            // Nothing banked means nothing to validate either — saving is
            // the only place a validation trial is logged (ADR-026).
            HeroSetSaveFeedback.showDiscarded();
            leave();
        } else {
            stay();
        }
    }

    function onBack() as Void {
        stay();
    }

    // Resume/Keep Editing: the screen underneath is still live, and the
    // workout's onShow re-enables its sensor listener, so counting picks up
    // where it left off.
    private function stay() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function leave() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.requestUpdate();
    }
}
