import Toybox.Lang;
import Toybox.WatchUi;

// Shared "what did that save achieve" feedback for every path that can bank
// a count: the workout quick-save (Save in the workout's Back menu), the
// manual delta picker (standalone from the main menu and as the post-workout
// correction step) and the daily-goal picker. One place keeps the toast tiers consistent regardless of
// entry point.
class HeroSetSaveFeedback {

    // Banks the delta and reports it. The before/after snapshots live here so
    // no caller can forget one and silently lose a tier.
    static function save(store as HeroSetStore, exercise as Lang.Symbol, delta as Lang.Number) as Void {
        var countBefore = store.getCount(exercise);
        var completedBefore = store.isDailyMissionComplete();
        var rankBefore = store.getRank();
        store.add(exercise, delta);
        var tier = tierFor(delta, countBefore, store.getCount(exercise), completedBefore, store.isDailyMissionComplete(), rankBefore, store.getRank(), store.getGoal());
        HeroSetComplicationPublisher.publish(store);
        show(tier, exercise, delta, store.getRank());
    }

    // Most significant wins, and a second toast would only replace the
    // first: the whole daily mission newly complete (once a day, so it keeps
    // its peak even when the same save crosses a rank), then a new rank, then
    // this exercise newly at its goal, then a plain save or removal.
    static function tierFor(delta as Lang.Number, countBefore as Lang.Number, countAfter as Lang.Number, completedBefore as Lang.Boolean, completedAfter as Lang.Boolean, rankBefore as Lang.Number, rankAfter as Lang.Number, goal as Lang.Number) as Lang.Symbol {
        if (!completedBefore && completedAfter) {
            return :mission;
        }
        if (rankAfter > rankBefore) {
            return :rank;
        }
        if (HeroSetRules.crossedGoal(countBefore, countAfter, goal)) {
            return :exercise;
        }
        return delta < 0 ? :removed : :saved;
    }

    // A plain save doesn't vibrate — the per-rep taps already happened live.
    // A negative delta is a correction, so it reads as removed reps rather
    // than a "-5 SAVED" that sounds like an error.
    private static function show(tier as Lang.Symbol, exercise as Lang.Symbol, delta as Lang.Number, rank as Lang.Number) as Void {
        if (tier == :mission) {
            WatchUi.showToast(Rez.Strings.toast_mission_complete, null);
            HeroSetHaptics.missionComplete();
        } else if (tier == :rank) {
            WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_rank_up, [rank]), null);
            HeroSetHaptics.rankUp();
        } else if (tier == :exercise) {
            WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_exercise_done, [HeroSetText.exerciseLabel(exercise)]), null);
            HeroSetHaptics.goalReached();
        } else if (tier == :removed) {
            WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_removed, [delta.abs()]), null);
        } else {
            WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_saved, [HeroSetText.signed(delta)]), null);
        }
    }

    // A goal lowered under today's counts finishes the day here, and the
    // mission outranks the plain confirmation (ADR-041). Published at once:
    // the publisher only runs while the app runs, so otherwise the watch
    // face draws against the old goal until the next set is saved.
    static function saveGoal(store as HeroSetStore, goal as Lang.Number) as Void {
        var completedBefore = store.isDailyMissionComplete();
        store.setGoal(goal);
        HeroSetComplicationPublisher.publish(store);
        if (!completedBefore && store.isDailyMissionComplete()) {
            WatchUi.showToast(Rez.Strings.toast_mission_complete, null);
            HeroSetHaptics.missionComplete();
            return;
        }
        WatchUi.showToast(HeroSetText.format(Rez.Strings.toast_goal_saved, [goal]), null);
    }

    static function showDiscarded() as Void {
        WatchUi.showToast(Rez.Strings.toast_discarded, null);
    }
}
