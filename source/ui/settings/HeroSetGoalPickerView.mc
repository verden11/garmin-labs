import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Daily goal picker (ADR-045): one Up/Down press steps by
// MISSION_GOAL_STEP, START saves. Deliberately not the manual delta picker
// parameterised — that one is bound to an exercise, its detected count and
// the threshold learner, none of which a setting has.
class HeroSetGoalPickerView extends WatchUi.View {

    private var _title;
    private var _saveHint;
    private var _adjustHint;
    private var _goal;
    private var _initialGoal;
    private var _saved = false;

    function initialize() {
        View.initialize();
        _title = HeroSetText.load(Rez.Strings.goal_title);
        _saveHint = HeroSetText.load(Rez.Strings.picker_hint_save);
        _adjustHint = HeroSetText.load(Rez.Strings.picker_hint_adjust);
        _goal = getApp().getStore().getGoal();
        _initialGoal = _goal;
    }

    function adjust(steps as Lang.Number) as Void {
        _goal = HeroSetRules.clampGoal(_goal + steps * HeroSetConfig.MISSION_GOAL_STEP);
        WatchUi.requestUpdate();
    }

    function getGoal() as Lang.Number {
        return _goal;
    }

    function isChanged() as Lang.Boolean {
        return _goal != _initialGoal;
    }

    function saveEntry() as Void {
        if (_saved || !isChanged()) {
            return;
        }
        _saved = true;
        var store = getApp().getStore();
        var completedBefore = store.isDailyMissionComplete();
        store.setGoal(_goal);
        // The publisher only runs while the app runs, so without this the
        // watch face draws against the old goal until the next set is saved.
        HeroSetComplicationPublisher.publish(store);
        // A goal lowered under today's counts finishes the day here, and
        // the mission outranks the plain confirmation (ADR-041) — the save
        // paths' feedback never reaches this screen.
        if (!completedBefore && store.isDailyMissionComplete()) {
            WatchUi.showToast(Rez.Strings.toast_mission_complete, null);
            HeroSetHaptics.missionComplete();
            return;
        }
        WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_goal_saved, [_goal]), null);
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        dc.setColor(HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        dc.clear();
        var y = HeroSetDraw.title(dc, layout, _title);
        var text = _goal.toString();
        var fonts = [Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD, Graphics.FONT_LARGE] as Lang.Array<Graphics.FontDefinition>;
        dc.setColor(HeroSetPalette.EFFORT, HeroSetPalette.BACKGROUND);
        var font = HeroSetDraw.largestFont(dc, layout, layout.displayRadius(), layout.textMargin(), y, text, fonts);
        HeroSetDraw.text(dc, layout, layout.centerX(), y, font, text, Graphics.TEXT_JUSTIFY_CENTER);

        var hintTop = y + dc.getFontHeight(font);
        var saveY = HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), hintTop, _saveHint);
        HeroSetDraw.hint(dc, layout, saveY - dc.getFontHeight(Graphics.FONT_XTINY), hintTop, _adjustHint);
    }
}
