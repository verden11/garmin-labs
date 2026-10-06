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
        _adjustHint = HeroSetInput.adjustHint();
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
        HeroSetSaveFeedback.saveGoal(getApp().getStore(), _goal);
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
        if (layout.track() != null) {
            // A rectangle's hints stay on their rows: the number takes the
            // height down to them, like the review picker's (ADR-057).
            var bottom = layout.footerRowBottom() - dc.getFontHeight(Graphics.FONT_XTINY);
            fonts = [Graphics.FONT_NUMBER_THAI_HOT, Graphics.FONT_NUMBER_HOT, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_MILD] as Lang.Array<Graphics.FontDefinition>;
            font = HeroSetDraw.largestFontInBand(dc, layout, y, bottom, text, fonts);
        }
        HeroSetDraw.centered(dc, layout, y, font, text);

        var hintTop = y + dc.getFontHeight(font);
        var saveY = HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), hintTop, _saveHint);
        HeroSetDraw.hint(dc, layout, saveY - dc.getFontHeight(Graphics.FONT_XTINY), hintTop, _adjustHint);
    }
}
