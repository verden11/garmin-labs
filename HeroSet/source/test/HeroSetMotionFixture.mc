import Toybox.Lang;
import Toybox.Math;

// Physically shaped wrist accelerometer traces (milli-g, 25 Hz) at real rep
// tempo, holds included. The original fixture was a pure 1.2 s sinusoid in
// acceleration magnitude, which no real exercise produces, so it hid both
// watch failures (ADR-032): a planted-hand push-up barely moves the watch
// (it tilts), and a squat's vertical acceleration has two same-sign lobes
// per rep. Each rep: move away (half-cosine position profile), hold, move
// back, hold.
(:test)
class HeroSetMotionFixture {
    static const GRAVITY = 1000.0;
    static const SQUAT_TRAVEL_M = 0.45;
    static const PUSHUP_TILT_DEGREES = 25.0;
    static const SITUP_TILT_DEGREES = 70.0;
    static const MG_PER_MS2 = 101.97;
    // A set starts with the watch still for about a second: START is pressed,
    // then the first rep begins.
    static const LEAD_IN_SAMPLES = 25;

    // Tempo presets: [move samples, hold samples] at 25 Hz.
    static function fast() as Lang.Array<Lang.Number> {
        return [15, 3] as Lang.Array<Lang.Number>;
    }

    static function medium() as Lang.Array<Lang.Number> {
        return [25, 12] as Lang.Array<Lang.Number>;
    }

    static function slow() as Lang.Array<Lang.Number> {
        return [38, 38] as Lang.Array<Lang.Number>;
    }

    static function verySlow() as Lang.Array<Lang.Number> {
        return [50, 50] as Lang.Array<Lang.Number>;
    }

    // Squats: arms hanging, wrist travels vertically, no tilt. Push-ups: hand
    // planted, forearm pivots at the wrist, no travel. Sit-ups: arms crossed
    // on chest, torso rotates.
    static function reps(counter as HeroSetRepCounter, exercise as Lang.Symbol, count as Lang.Number, tempo as Lang.Array<Lang.Number>) as Lang.Number {
        var tempos = [] as Lang.Array<Lang.Array<Lang.Number> >;
        for (var r = 0; r < count; r++) {
            tempos.add(tempo);
        }
        return repsAt(counter, exercise, tempos);
    }

    // Fatigue: each rep's moves and holds get 4 samples (0.16 s) longer.
    static function slowingReps(counter as HeroSetRepCounter, exercise as Lang.Symbol, count as Lang.Number) as Lang.Number {
        var tempos = [] as Lang.Array<Lang.Array<Lang.Number> >;
        for (var r = 0; r < count; r++) {
            tempos.add([15 + 4 * r, 3 + 4 * r] as Lang.Array<Lang.Number>);
        }
        return repsAt(counter, exercise, tempos);
    }

    private static function repsAt(counter as HeroSetRepCounter, exercise as Lang.Symbol, tempos as Lang.Array<Lang.Array<Lang.Number> >) as Lang.Number {
        var detected = idle(counter, LEAD_IN_SAMPLES);
        var n = LEAD_IN_SAMPLES;
        for (var r = 0; r < tempos.size(); r++) {
            var tempo = tempos[r];
            for (var phase = 0; phase < 4; phase++) {
                var length = (phase % 2 == 0) ? tempo[0] : tempo[1];
                for (var s = 0; s < length; s++) {
                    var sample = sampleAt(exercise, phase, s.toFloat() / tempo[0], tempo[0].toFloat() / 25.0);
                    if (feedNoisy(counter, sample, n)) {
                        detected += 1;
                    }
                    n += 1;
                }
            }
        }
        return detected;
    }

    // Wrist still in the rest position with light jitter, for false positives.
    static function idle(counter as HeroSetRepCounter, samples as Lang.Number) as Lang.Number {
        var detected = 0;
        for (var i = 0; i < samples; i++) {
            if (feedNoisy(counter, [0.0, -GRAVITY, 0.0] as Lang.Array<Lang.Float>, i)) {
                detected += 1;
            }
        }
        return detected;
    }

    private static function feedNoisy(counter as HeroSetRepCounter, sample as Lang.Array<Lang.Float>, n as Lang.Number) as Lang.Boolean {
        return counter.feedSample((sample[0] + jitter(n)).toNumber(), (sample[1] + jitter(n + 3)).toNumber(), (sample[2] + jitter(n + 7)).toNumber());
    }

    // phase 0 = away, 1 = hold away, 2 = back, 3 = hold at start; u in [0, 1)
    // is progress through a move phase lasting seconds.
    private static function sampleAt(exercise as Lang.Symbol, phase as Lang.Number, u as Lang.Float, seconds as Lang.Float) as Lang.Array<Lang.Float> {
        var moving = phase % 2 == 0;
        var progress = moving ? (1.0 - Math.cos(Math.PI * u)) / 2.0 : (phase == 1 ? 1.0 : 0.0);
        if (phase == 2) {
            progress = 1.0 - progress;
        }
        if (exercise == :squats) {
            // x = (D/2)(1 - cos(pi t/T)) -> a = (D/2)(pi/T)^2 cos(pi t/T).
            // Going down first, so the up-axis reading drops first.
            var peak = SQUAT_TRAVEL_M / 2.0 * Math.pow(Math.PI / seconds, 2) * MG_PER_MS2;
            var shape = moving ? Math.cos(Math.PI * u) * (phase == 0 ? 1.0 : -1.0) : 0.0;
            return [0.0, -(GRAVITY - peak * shape), 0.0] as Lang.Array<Lang.Float>;
        }
        var degrees = exercise == :pushups ? PUSHUP_TILT_DEGREES : SITUP_TILT_DEGREES;
        var angle = Math.toRadians(degrees * progress);
        return [GRAVITY * Math.sin(angle), -GRAVITY * Math.cos(angle), 0.0] as Lang.Array<Lang.Float>;
    }

    // Deterministic +-20 mg sensor/hand noise.
    private static function jitter(n as Lang.Number) as Lang.Float {
        return (((n * 7919) % 41) - 20).toFloat();
    }
}
