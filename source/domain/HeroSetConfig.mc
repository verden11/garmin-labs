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
    // Shortest believable half-rep (down or up); side changes closer
    // together are jitter around a threshold. Persisted in calibration
    // profiles under "cooldown" (ADR-003 spelling).
    static const SENSOR_COOLDOWN_MS = 250;
    // Rep detector filters (ADR-032), in samples at SENSOR_SAMPLE_RATE:
    // smoothing ~0.1 s, gravity/posture baseline ~2 s, squat velocity and
    // height leaks ~1 s. Tuned on HeroSetMotionFixture traces, not yet on
    // watch recordings.
    static const DETECTOR_SMOOTH_SAMPLES = 3.0;
    static const DETECTOR_BASELINE_SAMPLES = 50.0;
    static const DETECTOR_LEAK_SAMPLES = 25.0;
    // Deviation (mg) that seeds the movement axis; wrist jitter stays below.
    static const DETECTOR_AXIS_LOCK_MG = 60.0;
    // Oja's rule step = projection * deviation / this: about a 2% turn per
    // sample at a typical 200 mg swing, so the axis settles within a rep.
    static const DETECTOR_AXIS_LEARN_DIVISOR = 2000000.0;
    // Squat height (mg*s^2, leaky) scaled into the same threshold range as
    // tilt swings (mg), so one set of thresholds fits every exercise: a
    // 45 cm squat swings roughly +-150.
    static const DETECTOR_HEIGHT_GAIN = 16.0;
    // Thresholds are in detector signal units: mg of tilt swing, or scaled
    // velocity for squats. Defaults apply until an exercise is calibrated.
    static const DEFAULT_ARM_THRESHOLD = 80;
    static const DEFAULT_RELEASE_THRESHOLD = 80;
    static const CALIBRATION_REQUIRED_CYCLES = 10;
    static const CALIBRATION_MIN_PEAK = 100;
    static const CALIBRATION_MIN_VALLEY = 100;
    // Provisional thresholds while calibrating. They are also the floor for
    // fitted thresholds, so every rep that counted during calibration can
    // count again in a workout.
    static const CALIBRATION_SAMPLE_ARM = 50;
    static const CALIBRATION_SAMPLE_RELEASE = 50;
    // Fitted threshold = this percent of the mean swing: low enough that
    // the weaker reps at the end of a set still cross it.
    static const CALIBRATION_FIT_PERCENT = 25;
    // Safe range for fitted thresholds: a very gentle or very violent
    // calibration session can't produce a detector that never or always fires.
    static const CALIBRATION_ARM_MIN = 50;
    static const CALIBRATION_ARM_MAX = 500;
    static const CALIBRATION_RELEASE_MIN = 50;
    static const CALIBRATION_RELEASE_MAX = 500;
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
