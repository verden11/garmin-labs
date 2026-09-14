import Toybox.Attention;
import Toybox.Lang;
import Toybox.WatchUi;

// Shared "reps were kept" reward feedback for every path that can bank a
// count: the workout quick-save (Back-confirm) and the manual delta picker
// (used both standalone from the main menu and as the post-workout
// adjustment step). One place keeps the toast text and the mission-complete
// callout consistent regardless of entry point.
class HeroSetSaveFeedback {
    static function show(delta as Lang.Number, completedBefore as Lang.Boolean, completedAfter as Lang.Boolean) as Void {
        if (!completedBefore && completedAfter) {
            WatchUi.showToast("DAILY MISSION COMPLETE!", null);
            vibrateMissionComplete();
        } else {
            WatchUi.showToast(deltaLabel(delta) + " SAVED", null);
        }
    }

    private static function deltaLabel(delta as Lang.Number) as Lang.String {
        return delta > 0 ? ("+" + delta) : delta.toString();
    }

    // Distinct triple-buzz for the rarer, bigger moment — a plain save
    // relies on the toast alone (the per-rep single tap already happened
    // live during counting; buzzing again on save would be redundant).
    private static function vibrateMissionComplete() as Void {
        if (!(Attention has :vibrate)) {
            return;
        }
        Attention.vibrate([
            new Attention.VibeProfile(HeroSetConfig.REP_VIBE_DUTY_CYCLE, HeroSetConfig.REP_VIBE_DURATION_MS),
            new Attention.VibeProfile(0, HeroSetConfig.REP_VIBE_DURATION_MS),
            new Attention.VibeProfile(HeroSetConfig.REP_VIBE_DUTY_CYCLE, HeroSetConfig.REP_VIBE_DURATION_MS),
            new Attention.VibeProfile(0, HeroSetConfig.REP_VIBE_DURATION_MS),
            new Attention.VibeProfile(HeroSetConfig.REP_VIBE_DUTY_CYCLE, HeroSetConfig.REP_VIBE_DURATION_MS)
        ]);
    }
}
