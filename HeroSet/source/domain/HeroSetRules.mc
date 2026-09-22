import Toybox.Lang;

// Pure game rules (XP, rank curve, streaks, goal transitions): no Storage,
// no UI, so every rule is unit-tested without a simulator.
class HeroSetRules {
    // The three exercises, in the fixed order the store reset, the menu, the
    // mission bars and the complication field list all walk. A static const
    // Array is one shared object, so every caller only ever reads it.
    static const EXERCISES = [:pushups, :situps, :squats] as Lang.Array<Lang.Symbol>;

    static function xpForReps(reps as Lang.Number) as Lang.Number {
        return reps <= 0 ? 0 : reps * HeroSetConfig.XP_PER_REP;
    }

    // XP to climb from `rank` to `rank + 1`. Rank is always derived from
    // stored XP, never stored itself, so this curve can change without a
    // migration (ADR-031).
    static function rankCost(rank as Lang.Number) as Lang.Number {
        var cap = HeroSetConfig.RANK_COST_CAP_RANK;
        var steps = rank < 1 ? 1 : (rank > cap ? cap : rank);
        return HeroSetConfig.RANK_XP_STEP * steps;
    }

    // Total XP at which `rank` begins (closed form of summing rankCost).
    static function rankThreshold(rank as Lang.Number) as Lang.Number {
        if (rank <= 1) {
            return 0;
        }
        var step = HeroSetConfig.RANK_XP_STEP;
        var cap = HeroSetConfig.RANK_COST_CAP_RANK;
        var climbed = rank - 1;
        if (climbed <= cap) {
            return step * climbed * (climbed + 1) / 2;
        }
        return step * cap * (cap + 1) / 2 + (climbed - cap) * step * cap;
    }

    // Walks only the growing part of the curve (at most cap - 1 steps);
    // past the cap every rank costs the same, so plain division finishes it.
    static function rankForXp(xp as Lang.Number) as Lang.Number {
        var cap = HeroSetConfig.RANK_COST_CAP_RANK;
        var remaining = xp < 0 ? 0 : xp;
        var rank = 1;
        while (rank < cap && remaining >= rankCost(rank)) {
            remaining -= rankCost(rank);
            rank++;
        }
        if (rank == cap) {
            rank += remaining / rankCost(cap);
        }
        return rank;
    }

    static function xpIntoRank(xp as Lang.Number) as Lang.Number {
        var clamped = xp < 0 ? 0 : xp;
        return clamped - rankThreshold(rankForXp(clamped));
    }

    static function xpToNextRank(xp as Lang.Number) as Lang.Number {
        var clamped = xp < 0 ? 0 : xp;
        return rankThreshold(rankForXp(clamped) + 1) - clamped;
    }

    // The store already floors a stored count at 0, but a picker delta that
    // keeps falling past -current would need as many Up presses to undo
    // before it changes the saved result again.
    static function clampDelta(current as Lang.Number, delta as Lang.Number) as Lang.Number {
        var floor = current > 0 ? -current : 0;
        return delta < floor ? floor : delta;
    }

    // True only on the transition, so goal milestone feedback fires once
    // instead of on every rep/save past the goal.
    // The goal is user-set and stored, so it arrives as an argument: the
    // domain never reads Storage (layer rule) and a mutable static would
    // leak between tests.
    static function crossedGoal(before as Lang.Number, after as Lang.Number, goal as Lang.Number) as Lang.Boolean {
        return before < goal && after >= goal;
    }

    static function missionComplete(pushups as Lang.Number, situps as Lang.Number, squats as Lang.Number, goal as Lang.Number) as Lang.Boolean {
        return pushups >= goal && situps >= goal && squats >= goal;
    }

    // Snapped to the picker's step and clamped, so a value read back from
    // Storage (any build, any age) is always one the picker can show.
    static function clampGoal(goal as Lang.Number) as Lang.Number {
        var step = HeroSetConfig.MISSION_GOAL_STEP;
        var snapped = (goal + step / 2) / step * step;
        if (snapped < HeroSetConfig.MIN_MISSION_GOAL) {
            return HeroSetConfig.MIN_MISSION_GOAL;
        }
        return snapped > HeroSetConfig.MAX_MISSION_GOAL ? HeroSetConfig.MAX_MISSION_GOAL : snapped;
    }

    static function nextStreak(lastDay, todayDay as Lang.Number, currentStreak as Lang.Number) as Lang.Number {
        if (lastDay == null) {
            return 1;
        }
        if (lastDay == todayDay) {
            return currentStreak;
        }
        if (HeroSetCalendar.isConsecutiveDate(lastDay, todayDay)) {
            return currentStreak + 1;
        }
        return 1;
    }

    // The stored streak only changes when a mission completes, so after a
    // missed day it still holds the old run. Alive means the last completion
    // was today or yesterday; anything older is already broken.
    static function activeStreak(lastDay as Lang.Number?, todayDay as Lang.Number, storedStreak as Lang.Number) as Lang.Number {
        if (lastDay == null) {
            return 0;
        }
        if (lastDay == todayDay || HeroSetCalendar.isConsecutiveDate(lastDay, todayDay)) {
            return storedStreak;
        }
        return 0;
    }
}
