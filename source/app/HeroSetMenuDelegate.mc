import Toybox.Lang;
import Toybox.WatchUi;

// Menu2 (not the legacy Menu) so Garmin Connect Sync can be a ToggleMenuItem
// whose on/off state is visible without selecting it (ADR-027), and Start
// items can carry today's progress as sublabels (ADR-028). Menu2 never
// pops itself on select, so every handler below owns its own navigation.
class HeroSetMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    // Resource menus are static, so the caller stamps live state onto the
    // menu before pushing it: the persisted sync setting, today's progress
    // under each Start item, and focus on the first exercise still short of
    // its goal so starting the next set is usually a single Select.
    static function prepare(menu as WatchUi.Menu2) as Void {
        var store = getApp().getStore();
        // The store build's menu has no sync toggle (ADR-033); getItem(-1)
        // must never run.
        var syncIndex = menu.findItemById(:sync_toggle);
        var sync = syncIndex < 0 ? null : menu.getItem(syncIndex);
        if (sync instanceof WatchUi.ToggleMenuItem) {
            sync.setEnabled(store.isSyncEnabled());
        }
        var ids = [:start_pushups, :start_situps, :start_squats] as Lang.Array<Lang.Symbol>;
        var exercises = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;
        var focus = null;
        for (var i = 0; i < ids.size(); i++) {
            var index = menu.findItemById(ids[i]);
            var item = index < 0 ? null : menu.getItem(index);
            if (item == null) {
                continue;
            }
            var count = store.getCount(exercises[i]);
            item.setSubLabel(progressSubLabel(count));
            if (focus == null && count < HeroSetConfig.MISSION_GOAL) {
                focus = index;
            }
        }
        // All done: leave focus at the top rather than pointing at a
        // finished exercise.
        if (focus != null) {
            menu.setFocus(focus);
        }
    }

    private static function progressSubLabel(count as Lang.Number) as Lang.String {
        if (count >= HeroSetConfig.MISSION_GOAL) {
            return HeroSetText.load(Rez.Strings.menu_sublabel_done);
        }
        return HeroSetText.format(Rez.Strings.menu_sublabel_progress, [count, HeroSetConfig.MISSION_GOAL]);
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :start_pushups) {
            pushWorkout(:pushups);
        } else if (id == :start_situps) {
            pushWorkout(:situps);
        } else if (id == :start_squats) {
            pushWorkout(:squats);
        } else if (id == :manual_pushups) {
            pushManualPicker(:pushups);
        } else if (id == :manual_situps) {
            pushManualPicker(:situps);
        } else if (id == :manual_squats) {
            pushManualPicker(:squats);
        } else if (id == :sync_toggle) {
            applySyncToggle(item);
        } else if (id == :validation_log) {
            pushValidationLog();
        }
        WatchUi.requestUpdate();
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    private function pushWorkout(exercise as Lang.Symbol) as Void {
        var workoutView = new HeroSetWorkoutView(exercise);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(workoutView, new HeroSetWorkoutDelegate(workoutView), WatchUi.SLIDE_UP);
    }

    // Manual entry opens a continuous up/down delta picker starting at 0,
    // directly on the dashboard (menu popped first, same as pushWorkout) so
    // saving is a single deterministic pop back to the dashboard.
    private function pushManualPicker(exercise as Lang.Symbol) as Void {
        var pickerView = new HeroSetManualPickerView(exercise, 0, null, null, null);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(pickerView, new HeroSetManualPickerDelegate(pickerView), WatchUi.SLIDE_UP);
    }

    // Dev-only diagnostic (ADR-026), no menu-popping side effect required
    // beyond the delegate's own Back handling — pushed over the main menu,
    // not popped first.
    private function pushValidationLog() as Void {
        var view = new HeroSetValidationLogView();
        WatchUi.pushView(view, new HeroSetValidationLogDelegate(view), WatchUi.SLIDE_UP);
    }

    // Menu2 has already flipped the toggle by the time onSelect runs, so the
    // item's state is the user's new choice. No confirmation: the state is
    // on screen and one more press undoes it.
    private function applySyncToggle(item as WatchUi.MenuItem) as Void {
        if (item instanceof WatchUi.ToggleMenuItem) {
            getApp().getSync().setEnabled(item.isEnabled());
        }
    }
}
