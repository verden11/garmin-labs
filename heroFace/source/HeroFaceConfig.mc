import Toybox.Lang;

// Every tunable and identifier in one place (HeroSet house rule: no magic
// numbers). Setting values here must match resources/settings.
class HeroFaceConfig {
    // A third value, 2 ("HeroSet"), shipped in 1.0 and behaved exactly like
    // Auto; it was dropped from the list, and a stored 2 still reads as Auto.
    static const MODE_AUTO = 0;
    static const MODE_EVERYDAY = 1;

    // Mission metrics. 0 in a slot setting means "first one this watch has".
    static const METRIC_AUTO = 0;
    static const STEPS = 1;
    static const CALORIES = 2;
    static const INTENSITY = 3;
    static const DISTANCE = 4;
    static const FLOORS = 5;
    static const MOVE = 6;
    static const PUSHUPS = 7;
    static const SITUPS = 8;
    static const SQUATS = 9;

    // Default chain per slot: the first metric this watch supports wins, so no
    // bar is ever empty (floors need a barometer, intensity minutes CIQ 2.1).
    static const SLOT_CHAINS = [
        [STEPS, CALORIES],
        [INTENSITY, DISTANCE, CALORIES],
        [FLOORS, MOVE, CALORIES]
    ] as Array<Array<Number>>;

    // Fallback only: HeroSet publishes the user's own daily goal, and older
    // versions that don't are read as this (HeroSet ADR-045).
    static const HEROSET_GOAL = 100;
    // The largest goal HeroSet's picker can set (its MAX_MISSION_GOAL), so the
    // screen-fit test draws the widest counts the bars can ever print.
    static const HEROSET_MAX_GOAL = 500;
    static const HEROSET_CONTRACT_VERSION = 1;
    // HeroSet's private complication long label; the face finds it by this.
    static const HEROSET_COMPLICATION_LABEL = "HeroSet";

    static const LOW_BATTERY_PERCENT = 15;
    static const DAYS_PER_WEEK = 7;
    static const SECONDS_PER_DAY = 86400;
    static const HALF_DAY_SECONDS = 43200;
    // Distance is stored in tenths of the display unit (5.2 km -> 52).
    static const CM_PER_TENTH_KM = 10000;
    static const CM_PER_TENTH_MILE = 16093;
    static const HOURS_PER_HALF_DAY = 12;
    // AOD: the time block walks a 3 x 3 grid, one step per minute. Garmin's
    // watch-face guidance caps the move at four pixels, enough to spread wear
    // without the time visibly hopping.
    static const BURN_IN_GRID = 3;
    static const BURN_IN_STEP_PX = 4;

    // Settings property ids (resources/settings/properties.xml); never change.
    static const SETTING_MODE = "Mode";
    static const SETTING_SLOTS = ["Slot1", "Slot2", "Slot3"] as Array<String>;
    static const SETTING_ACCENT = "Accent";
    static const SETTING_SECONDS = "Seconds";
    static const SETTING_WEATHER = "Weather";

    // Storage keys; spellings never change once shipped.
    static const STREAK_KEY = "face_streak";
    static const HEROSET_KEY = "face_heroset";
}
