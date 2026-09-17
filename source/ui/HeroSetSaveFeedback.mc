import Toybox.Lang;
import Toybox.WatchUi;

// Shared "what did that save achieve" feedback for every path that can bank
// a count: the workout quick-save (Save in the workout's Back menu) and the
// manual delta picker (standalone from the main menu and as the post-workout
// correction step). One place keeps the toast tiers consistent regardless of
// entry point.
class HeroSetSaveFeedback {

    // Tiers, most significant wins: the whole daily mission newly complete,
    // then this exercise newly at its goal, then a plain save. A plain save
    // doesn't vibrate — the per-rep taps already happened live.
    static function show(exercise as Lang.Symbol, delta as Lang.Number, countBefore as Lang.Number, countAfter as Lang.Number, completedBefore as Lang.Boolean, completedAfter as Lang.Boolean) as Void {
        if (!completedBefore && completedAfter) {
            WatchUi.showToast(Rez.Strings.toast_mission_complete, null);
            HeroSetHaptics.missionComplete();
        } else if (HeroSetRules.crossedGoal(countBefore, countAfter)) {
            WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_exercise_done, [HeroSetText.exerciseLabel(exercise)]), null);
            HeroSetHaptics.goalReached();
        } else {
            WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_saved, [HeroSetText.signed(delta)]), null);
        }
    }

    static function showDiscarded() as Void {
        WatchUi.showToast(Rez.Strings.toast_discarded, null);
    }
}
