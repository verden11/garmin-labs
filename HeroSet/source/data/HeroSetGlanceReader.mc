import Toybox.Lang;

// Read-only snapshot of today's progress for the app glance. The glance
// process has no HeroSetStore (its constructor and ensureCurrentDay write
// Storage), so this reads the same flat keys (ADR-003) and never writes: a
// count saved on an earlier day reads as 0, the way ensureCurrentDay would
// have reset it. The key spellings are duplicated from HeroSetStore on
// purpose; HeroSetGlanceReaderTest pins them against the real store.
(:glance)
class HeroSetGlanceReader {

    static function read(storage as HeroSetStorage, today as Lang.Number) as HeroSetDashboardState {
        var savedDay = numberOrNull(storage.getValue("hero_day"));
        var fresh = savedDay != null && savedDay == today;
        var goal = numberOrNull(storage.getValue("hero_goal"));
        // Unset or a corrupt 0 both mean "never chosen", as in HeroSetStore.getGoal.
        var shownGoal = goal == null || goal <= 0 ? HeroSetConfig.DEFAULT_MISSION_GOAL : HeroSetRules.clampGoal(goal);
        var lastDay = numberOrNull(storage.getValue("hero_last_completion"));
        var streak = HeroSetRules.activeStreak(lastDay, today, number(storage.getValue("hero_streak")));
        // XP, rank and the save-failure flag (not persisted) are not shown by
        // the glance.
        return new HeroSetDashboardState(
            fresh ? number(storage.getValue("hero_pushups")) : 0,
            fresh ? number(storage.getValue("hero_situps")) : 0,
            fresh ? number(storage.getValue("hero_squats")) : 0,
            0, 0, streak, false, shownGoal);
    }

    // Number or Float depending on how the value was first written, exactly
    // the narrowing HeroSetStore applies to every read.
    private static function numberOrNull(value as Lang.Object?) as Lang.Number? {
        if (value instanceof Lang.Number) {
            return value;
        }
        if (value instanceof Lang.Float) {
            return value.toNumber();
        }
        return null;
    }

    private static function number(value as Lang.Object?) as Lang.Number {
        var parsed = numberOrNull(value);
        return parsed == null ? 0 : parsed;
    }
}
