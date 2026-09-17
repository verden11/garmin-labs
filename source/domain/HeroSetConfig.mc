// Every tunable number in the app lives here (house rule: no magic numbers).
class HeroSetConfig {
    static const MISSION_GOAL = 100;
    // XP per credited rep; credit stops at MISSION_GOAL per exercise per day
    // (ADR-002), so a full day earns at most 3 * 100 * 2 = 600 XP.
    static const XP_PER_REP = 2;
    // Rank r -> r+1 costs RANK_XP_STEP * min(r, RANK_COST_CAP_RANK) XP
    // (ADR-031). A full mission day earns at most 600 XP (ADR-002), so each
    // rank costs half a full day more than the last, flattening to one rank
    // per full week from rank 14: rank 10 is ~3 weeks in, rank 60 ~a year.
    static const RANK_XP_STEP = 300;
    static const RANK_COST_CAP_RANK = 14;
    static const SENSOR_SAMPLE_RATE = 25;
    static const SENSOR_PERIOD_SECONDS = 1;
    static const SENSOR_COOLDOWN_MS = 600;
    static const DEFAULT_ARM_THRESHOLD = 100;
    static const DEFAULT_RELEASE_THRESHOLD = 70;
    static const CALIBRATION_REQUIRED_CYCLES = 10;
    static const CALIBRATION_MIN_PEAK = 90;
    static const CALIBRATION_MIN_VALLEY = 70;
    static const CALIBRATION_SAMPLE_ARM = 45;
    static const CALIBRATION_SAMPLE_RELEASE = 30;
    // Safe range for fitted thresholds: a very gentle or very violent
    // calibration session can't produce a detector that never or always fires.
    static const CALIBRATION_ARM_MIN = 60;
    static const CALIBRATION_ARM_MAX = 500;
    static const CALIBRATION_RELEASE_MIN = 50;
    static const CALIBRATION_RELEASE_MAX = 400;
    // Short tap on each detected rep — glanceable confirmation without
    // looking at the screen mid-exercise. Duty cycle is ignored on
    // Forerunner hardware (fixed default motor strength), kept for devices
    // that do honor it.
    static const REP_VIBE_DUTY_CYCLE = 50;
    static const REP_VIBE_DURATION_MS = 100;
    // HR/calorie/elapsed readouts change between reps; without a periodic
    // redraw they would only refresh when a rep is detected.
    static const LIVE_REFRESH_MS = 1000;
    // How often an open dashboard checks for the local day changing.
    static const DAY_CHECK_INTERVAL_MS = 60000;
    // Dev-build diagnostic: capped ring buffer of detected-vs-corrected rep
    // counts from real workout sets, used for physical accuracy validation
    // (ADR-026). Oldest entries drop once the cap is hit.
    static const VALIDATION_LOG_MAX_ENTRIES = 30;
}
