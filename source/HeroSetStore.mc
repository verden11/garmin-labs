import Toybox.Lang;
using Toybox.Application.Storage;
using Toybox.Time;

class HeroSetStore {

    const DAY_KEY = "hero_day";
    const PUSHUPS_KEY = "hero_pushups";
    const SITUPS_KEY = "hero_situps";
    const SQUATS_KEY = "hero_squats";
    const XP_KEY = "hero_xp";
    const STREAK_KEY = "hero_streak";
    const LAST_COMPLETION_KEY = "hero_last_completion";
    const RUN_DISTANCE_KEY = "hero_run_distance";

    function initialize() {
        ensureCurrentDay();
    }

    function ensureCurrentDay() as Void {
        var today = Time.today().value();
        var savedDay = Storage.getValue(DAY_KEY);

        if (savedDay == null || savedDay != today) {
            Storage.setValue(DAY_KEY, today);
            Storage.setValue(PUSHUPS_KEY, 0);
            Storage.setValue(SITUPS_KEY, 0);
            Storage.setValue(SQUATS_KEY, 0);
            Storage.setValue(RUN_DISTANCE_KEY, 0.0);
        }
    }

    function getCount(exercise as Lang.Symbol) as Lang.Number {
        ensureCurrentDay();
        var value = Storage.getValue(keyFor(exercise));
        return value == null ? 0 : value;
    }

    function add(exercise as Lang.Symbol, amount as Lang.Number) as Void {
        ensureCurrentDay();
        var next = getCount(exercise) + amount;
        var safeAmount = next < 0 ? 0 : next;
        Storage.setValue(keyFor(exercise), safeAmount);
        awardXp(amount > 0 ? amount : 0);
        updateCompletion();
    }

    function getXp() as Lang.Number {
        var value = Storage.getValue(XP_KEY);
        return value == null ? 0 : value;
    }

    function getRank() as Lang.Number {
        return (getXp() / 100) + 1;
    }

    function getStreak() as Lang.Number {
        var value = Storage.getValue(STREAK_KEY);
        return value == null ? 0 : value;
    }

    function addRunDistance(meters as Lang.Float) as Void {
        ensureCurrentDay();
        var current = Storage.getValue(RUN_DISTANCE_KEY);
        Storage.setValue(RUN_DISTANCE_KEY, (current == null ? 0.0 : current) + meters);
    }

    function getRunDistance() as Lang.Float {
        ensureCurrentDay();
        var value = Storage.getValue(RUN_DISTANCE_KEY);
        return value == null ? 0.0 : value;
    }

    private function awardXp(amount as Lang.Number) as Void {
        if (amount <= 0) {
            return;
        }
        Storage.setValue(XP_KEY, getXp() + amount * 2);
    }

    private function updateCompletion() as Void {
        if (getCount(:pushups) < 100 || getCount(:situps) < 100 || getCount(:squats) < 100) {
            return;
        }

        var today = Time.today().value();
        var lastCompletion = Storage.getValue(LAST_COMPLETION_KEY);
        if (lastCompletion == today) {
            return;
        }

        var streak = getStreak();
        var oneDay = 24 * 60 * 60;
        Storage.setValue(STREAK_KEY, lastCompletion == today - oneDay ? streak + 1 : 1);
        Storage.setValue(LAST_COMPLETION_KEY, today);
    }

    private function keyFor(exercise as Lang.Symbol) as Lang.String {
        if (exercise == :pushups) {
            return PUSHUPS_KEY;
        }
        if (exercise == :situps) {
            return SITUPS_KEY;
        }
        return SQUATS_KEY;
    }
}
