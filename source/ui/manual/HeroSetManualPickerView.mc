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
    private var _detectedText;
    private var _trace;
    private var _saved = false;

    // initialDelta seeds the picker with a workout's detected count so it
    // doubles as the post-set correction step (HeroSetWorkoutDelegate);
    // standalone manual entry from the main menu starts at 0. detectedSeed
    // is non-null only for the workout-correction case (equal to
    // initialDelta at construction) — it's what saveEntry logs against the
    // final corrected count for physical accuracy validation (ADR-026);
    // standalone entry has no detector count to compare against. trace is
    // the finished set's swings, so the saved count can teach the detector
    // (ADR-040); null for standalone entry. detectedLive is what the workout
    // screen showed, which is one more than the seed when the last rep has
    // been learned to be getting up.
    function initialize(exercise as Lang.Symbol, initialDelta as Lang.Number, detectedSeed as Lang.Number?, detectedLive as Lang.Number?, trace as HeroSetSwingTrace?) {
        View.initialize();
        _exercise = exercise;
        // Cached: every Up/Down press redraws.
        _label = HeroSetText.exerciseLabel(exercise);
        _saveHint = HeroSetText.load(Rez.Strings.picker_hint_save);
        _adjustHint = HeroSetText.load(Rez.Strings.picker_hint_adjust);
        _delta = initialDelta;
        _detectedSeed = detectedSeed;
        _detectedText = detectedText(detectedSeed, detectedLive);
        _trace = trace;
    }

    // "DETECTED 24 (-1)" rather than a bare 23 right after the workout screen
    // showed 24, so the dropped rep reads as arithmetic, not a lost rep.
    private static function detectedText(seed as Lang.Number?, live as Lang.Number?) as Lang.String? {
        if (seed == null) {
            return null;
        }
        var shown = (live != null && live > seed) ? live.toString() + " (-" + (live - seed) + ")" : seed.toString();
        return HeroSetText.format(Rez.Strings.picker_detected, [shown]);
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
        HeroSetSaveFeedback.save(store, _exercise, _delta);
        if (_detectedSeed != null) {
            store.logValidationTrial(_exercise, _detectedSeed, _delta);
            getApp().getSync().setSaved(_delta);
        }
        learnFromSet(store);
    }

    private function learnFromSet(store as HeroSetStore) as Void {
        var trace = _trace;
        if (trace == null) {
            return;
        }
        var learned = HeroSetThresholdLearner.updated(store.getLearningState(_exercise), trace, _delta);
        if (learned != null) {
            store.setLearningState(_exercise, learned);
        }
    }

    // Rows stack top-down by measured font height (the optional DETECTED
    // subtitle shifts everything below it); hints stack bottom-up from the
    // bezel so neither end collides.
    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        dc.setColor(HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        dc.clear();
        var y = HeroSetDraw.title(dc, layout, _label);
        var detected = _detectedText;
        if (detected != null) {
            dc.setColor(HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
            HeroSetDraw.text(dc, layout, layout.centerX(), y, Graphics.FONT_XTINY, detected, Graphics.TEXT_JUSTIFY_CENTER);
            y += dc.getFontHeight(Graphics.FONT_XTINY);
        }
        dc.setColor(deltaColor(), HeroSetPalette.BACKGROUND);
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
        dc.setColor(resulting >= HeroSetConfig.MISSION_GOAL ? HeroSetPalette.DONE : HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        HeroSetDraw.text(dc, layout, layout.centerX(), y, HeroSetDraw.largestFont(dc, layout, layout.displayRadius(), layout.textMargin(), y, text, fonts), text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Zero is neutral: nothing will change if this is saved. Adding reps is
    // effort like the live count, not green, which only means a goal is met.
    private function deltaColor() as Graphics.ColorType {
        if (_delta == 0) {
            return HeroSetPalette.TEXT;
        }
        return _delta > 0 ? HeroSetPalette.EFFORT : HeroSetPalette.ALERT;
    }
}
