import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Delta picker: each Up/Down press steps the delta by 1 (ADR-029 — no
// hold-to-accelerate, long-presses belong to the watch), replacing the old
// discrete +1/+5/+10 menu items entirely.
class HeroSetManualPickerView extends WatchUi.View {

    private var _exercise;
    private var _label;
    private var _saveHint;
    private var _adjustHint;
    private var _delta;
    private var _detectedSeed;
    private var _saved = false;

    // initialDelta seeds the picker with a workout's detected count so it
    // doubles as the post-set correction step (HeroSetWorkoutDelegate);
    // standalone manual entry from the main menu starts at 0. detectedSeed
    // is non-null only for the workout-correction case (equal to
    // initialDelta at construction) — it's what saveEntry logs against the
    // final corrected count for physical accuracy validation (ADR-026);
    // standalone entry has no detector count to compare against.
    function initialize(exercise as Lang.Symbol, initialDelta as Lang.Number, detectedSeed as Lang.Number?) {
        View.initialize();
        _exercise = exercise;
        // Cached: every Up/Down press redraws.
        _label = HeroSetText.exerciseLabel(exercise);
        _saveHint = HeroSetText.load(Rez.Strings.picker_hint_save);
        _adjustHint = HeroSetText.load(Rez.Strings.picker_hint_adjust);
        _delta = initialDelta;
        _detectedSeed = detectedSeed;
    }

    // Clamped against the stored count so pressing Down past zero doesn't
    // build up a phantom negative delta that takes as many Up presses to undo.
    function adjust(amount as Lang.Number) as Void {
        var current = getApp().getStore().getCount(_exercise);
        _delta = HeroSetRules.clampDelta(current, _delta + amount);
        WatchUi.requestUpdate();
    }

    function getDelta() as Lang.Number {
        return _delta;
    }

    function getExercise() as Lang.Symbol {
        return _exercise;
    }

    function saveEntry() as Void {
        if (_saved) {
            return;
        }
        _saved = true;
        if (_delta == 0) {
            return;
        }
        var store = getApp().getStore();
        var countBefore = store.getCount(_exercise);
        var completedBefore = store.isDailyMissionComplete();
        store.add(_exercise, _delta);
        if (_detectedSeed != null) {
            store.logValidationTrial(_exercise, _detectedSeed, _delta);
        }
        HeroSetSaveFeedback.show(_exercise, _delta, countBefore, store.getCount(_exercise), completedBefore, store.isDailyMissionComplete());
    }

    // Rows stack top-down by measured font height (the optional DETECTED
    // subtitle shifts everything below it); hints stack bottom-up from the
    // bezel so neither end collides.
    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var y = layout.bandTop(0);
        HeroSetDraw.text(dc, layout, layout.centerX(), y, Graphics.FONT_SMALL, _label, Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_SMALL);
        if (_detectedSeed != null) {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
            HeroSetDraw.text(dc, layout, layout.centerX(), y, Graphics.FONT_XTINY, HeroSetText.format(Rez.Strings.picker_detected, [_detectedSeed]), Graphics.TEXT_JUSTIFY_CENTER);
            y += dc.getFontHeight(Graphics.FONT_XTINY);
        }
        dc.setColor(deltaColor(), Graphics.COLOR_BLACK);
        HeroSetDraw.text(dc, layout, layout.centerX(), y, Graphics.FONT_LARGE, HeroSetText.signed(_delta), Graphics.TEXT_JUSTIFY_CENTER);
        y += dc.getFontHeight(Graphics.FONT_LARGE);
        drawToday(dc, layout, y);

        var hintTop = y + dc.getFontHeight(Graphics.FONT_SMALL);
        var saveY = HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), hintTop, _saveHint);
        HeroSetDraw.hint(dc, layout, saveY - dc.getFontHeight(Graphics.FONT_XTINY), hintTop, _adjustHint);
    }

    // What today's total becomes if this delta is saved.
    private function drawToday(dc as Dc, layout as HeroSetLayout, y as Lang.Number) as Void {
        var resulting = getApp().getStore().getCount(_exercise) + _delta;
        if (resulting < 0) {
            resulting = 0;
        }
        var text = HeroSetText.todayProgress(resulting);
        var fonts = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        dc.setColor(resulting >= HeroSetConfig.MISSION_GOAL ? Graphics.COLOR_GREEN : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        HeroSetDraw.text(dc, layout, layout.centerX(), y, HeroSetDraw.largestFont(dc, layout, layout.displayRadius(), layout.textMargin(), y, text, fonts), text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Zero is neutral: nothing will change if this is saved.
    private function deltaColor() as Graphics.ColorType {
        if (_delta == 0) {
            return Graphics.COLOR_WHITE;
        }
        return _delta > 0 ? Graphics.COLOR_GREEN : Graphics.COLOR_RED;
    }
}
