import Toybox.Lang;
import Toybox.Math;

// Counts reps from how the watch actually moves during each exercise, not
// from overall acceleration strength with one threshold pair (ADR-032). That
// old detector counted 0/10 push-ups and sit-ups on physically shaped
// fixtures (4/10 on the watch) and 19/10 squats (19/10 on the watch too).
//   Push-ups, sit-ups: the wrist mostly tilts, and strength is blind to
//     rotation. Smooth each axis, subtract a slow per-axis baseline, and
//     project the deviation onto its principal axis (Oja's rule): a signed
//     tilt swing, whichever way the watch is worn.
//   Squats: the wrist travels up and down without tilting. Acceleration has
//     two same-sign lobes per squat (braking at the bottom, then pushing
//     up), which counted every squat twice, and velocity shrinks with tempo.
//     Strength minus its baseline, integrated twice with leaks, is roughly
//     the height change: one swing per squat, the same size fast or slow.
// Either signal then counts one rep per full swing: past +threshold then
// past -threshold, or the reverse.
class HeroSetRepCounter {
    private var _threshold as Lang.Float;
    private var _flipGapSamples as Lang.Number;
    private var _integrate as Lang.Boolean;
    private var _sampleRate as Lang.Float;
    private var _smooth as Lang.Array<Lang.Float>?;
    private var _baseline as Lang.Array<Lang.Float> = [0.0, 0.0, 0.0] as Lang.Array<Lang.Float>;
    private var _strengthBaseline as Lang.Float = 0.0;
    private var _samplesSeen as Lang.Number = 0;
    private var _axis as Lang.Array<Lang.Float>?;
    private var _velocity as Lang.Float = 0.0;
    private var _height as Lang.Float = 0.0;
    private var _side as Lang.Number = 0;
    private var _flips as Lang.Number = 0;
    private var _sinceFlip as Lang.Number = 0;
    private var _trace as HeroSetSwingTrace;

    // flipGapMs: the shortest believable half-rep. Swings closer together
    // than this are hand jitter around a threshold, not movement.
    function initialize(threshold as Lang.Number, sampleRate as Lang.Number, flipGapMs as Lang.Number, integrate as Lang.Boolean) {
        _threshold = threshold.toFloat();
        _sampleRate = sampleRate.toFloat();
        _integrate = integrate;
        _flipGapSamples = (flipGapMs * sampleRate) / 1000;
        if (_flipGapSamples < 1) {
            _flipGapSamples = 1;
        }
        _sinceFlip = _flipGapSamples;
        _trace = new HeroSetSwingTrace(_flipGapSamples);
    }

    // Squats move the wrist up and down without tilting it; the other
    // exercises tilt it with the torso or forearm.
    static function integratesMotion(exercise as Lang.Symbol) as Lang.Boolean {
        return exercise == :squats;
    }

    function feedSample(x as Lang.Number, y as Lang.Number, z as Lang.Number) as Lang.Boolean {
        var signal = signalFor([x.toFloat(), y.toFloat(), z.toFloat()] as Lang.Array<Lang.Float>);
        if (signal == null) {
            return false;
        }
        return detect(signal);
    }

    // The set so far, for learning from the saved count (ADR-040).
    function getTrace() as HeroSetSwingTrace {
        return _trace;
    }

    // Null until the watch has moved enough to know which axis matters.
    private function signalFor(sample as Lang.Array<Lang.Float>) as Lang.Float? {
        var smooth = smoothed(sample);
        if (_integrate) {
            return heightFrom(smooth);
        }
        var deviation = tiltDeviation(smooth);
        var axis = _axis;
        if (axis == null) {
            axis = lockAxis(deviation);
            if (axis == null) {
                return null;
            }
        }
        var projected = dot(deviation, axis);
        learnAxis(axis, deviation, projected);
        return projected;
    }

    private function smoothed(sample as Lang.Array<Lang.Float>) as Lang.Array<Lang.Float> {
        var smooth = _smooth;
        if (smooth == null) {
            smooth = [sample[0], sample[1], sample[2]] as Lang.Array<Lang.Float>;
            _smooth = smooth;
            _baseline = [sample[0], sample[1], sample[2]] as Lang.Array<Lang.Float>;
            _strengthBaseline = Math.sqrt(dot(sample, sample)).toFloat();
        }
        for (var i = 0; i < 3; i++) {
            smooth[i] += (sample[i] - smooth[i]) / HeroSetConfig.DETECTOR_SMOOTH_SAMPLES;
        }
        _samplesSeen += 1;
        return smooth;
    }

    // Until a full baseline window has passed, baselines are a plain running
    // mean, so a set started mid-movement doesn't anchor on one odd sample.
    private function baselineWindow() as Lang.Float {
        return _samplesSeen < HeroSetConfig.DETECTOR_BASELINE_SAMPLES ? _samplesSeen.toFloat() : HeroSetConfig.DETECTOR_BASELINE_SAMPLES;
    }

    private function tiltDeviation(smooth as Lang.Array<Lang.Float>) as Lang.Array<Lang.Float> {
        var window = baselineWindow();
        var deviation = [0.0, 0.0, 0.0] as Lang.Array<Lang.Float>;
        for (var i = 0; i < 3; i++) {
            _baseline[i] += (smooth[i] - _baseline[i]) / window;
            deviation[i] = smooth[i] - _baseline[i];
        }
        return deviation;
    }

    // Strength above its own slow baseline is, for small tilts, the
    // vertical acceleration. Both integrators leak so sensor bias can't
    // drift the height away between reps.
    private function heightFrom(smooth as Lang.Array<Lang.Float>) as Lang.Float {
        var strength = Math.sqrt(dot(smooth, smooth)).toFloat();
        _strengthBaseline += (strength - _strengthBaseline) / baselineWindow();
        _velocity += (strength - _strengthBaseline) / _sampleRate - _velocity / HeroSetConfig.DETECTOR_LEAK_SAMPLES;
        _height += _velocity * HeroSetConfig.DETECTOR_HEIGHT_GAIN / _sampleRate - _height / HeroSetConfig.DETECTOR_LEAK_SAMPLES;
        return _height;
    }

    // The first clear movement seeds the axis, so the first rep isn't spent
    // converging from an arbitrary direction.
    private function lockAxis(deviation as Lang.Array<Lang.Float>) as Lang.Array<Lang.Float>? {
        var length = Math.sqrt(dot(deviation, deviation)).toFloat();
        if (length < HeroSetConfig.DETECTOR_AXIS_LOCK_MG) {
            return null;
        }
        _axis = [deviation[0] / length, deviation[1] / length, deviation[2] / length] as Lang.Array<Lang.Float>;
        return _axis;
    }

    // Oja's rule: nudge the axis toward the deviation, weighted by how much
    // of it already lies along the axis, then renormalize. Converges on the
    // principal direction without ever flipping sign mid-set.
    private function learnAxis(axis as Lang.Array<Lang.Float>, deviation as Lang.Array<Lang.Float>, projected as Lang.Float) as Void {
        var rate = projected / HeroSetConfig.DETECTOR_AXIS_LEARN_DIVISOR;
        for (var i = 0; i < 3; i++) {
            axis[i] += rate * deviation[i];
        }
        var length = Math.sqrt(dot(axis, axis)).toFloat();
        if (length > 0.0) {
            for (var i = 0; i < 3; i++) {
                axis[i] /= length;
            }
        }
    }

    // Counting every second side change means a signal that stays past a
    // threshold for a long hold can't count again, which is how the old
    // state machine double-counted slow reps.
    private function detect(signal as Lang.Float) as Lang.Boolean {
        _sinceFlip += 1;
        _trace.feed(signal, _samplesSeen);
        var side = signal > _threshold ? 1 : (signal < -_threshold ? -1 : 0);
        if (side == 0 || side == _side || _sinceFlip < _flipGapSamples) {
            return false;
        }
        _side = side;
        _sinceFlip = 0;
        _flips += 1;
        return _flips % 2 == 0;
    }

    private static function dot(a as Lang.Array<Lang.Float>, b as Lang.Array<Lang.Float>) as Lang.Float {
        return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
    }
}
