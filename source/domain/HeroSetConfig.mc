class HeroSetConfig {
    static const MISSION_GOAL = 100;
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
    // Short tap on each detected rep — glanceable confirmation without
    // looking at the screen mid-exercise. Duty cycle is ignored on
    // Forerunner hardware (fixed default motor strength), kept for devices
    // that do honor it.
    static const REP_VIBE_DUTY_CYCLE = 50;
    static const REP_VIBE_DURATION_MS = 100;
}
