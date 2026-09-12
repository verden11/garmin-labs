import Toybox.Lang;
import Toybox.Math;

// Gravity-removed turning-point cycle detector. Each sample is reduced to an
// L2 magnitude (rotation-invariant), gravity is removed with an exponential
// moving average baseline, and a full rep is counted when BOTH turning points
// (positive excursion past arm, negative excursion past release) are seen.
class HeroSetRepCounter {
    private var _armThreshold;
    private var _releaseThreshold;
    private var _cooldownSamples;
    private var _state = 0;
    private var _cooldown = 0;
    private var _baseline = 0.0;
    private var _baselineSet = false;
    private var _extentPeak = 0.0;
    private var _extentValley = 0.0;
    private var _lastCyclePeak = 0.0;
    private var _lastCycleValley = 0.0;

    function initialize(armThreshold as Lang.Number, releaseThreshold as Lang.Number, sampleRate as Lang.Number, cooldownMs as Lang.Number) {
        _armThreshold = armThreshold;
        _releaseThreshold = releaseThreshold;
        _cooldownSamples = (cooldownMs * sampleRate) / 1000;
        if (_cooldownSamples < 1) {
            _cooldownSamples = 1;
        }
    }

    function feedSample(x as Lang.Number, y as Lang.Number, z as Lang.Number) as Lang.Boolean {
        var mag = Math.sqrt(x * x + y * y + z * z);
        if (!_baselineSet) {
            _baseline = mag;
            _baselineSet = true;
        } else {
            _baseline = _baseline + (mag - _baseline) / 100;
        }
        var signal = mag - _baseline;

        if (_cooldown > 0) {
            _cooldown -= 1;
            return false;
        }

        if (signal > _extentPeak) {
            _extentPeak = signal;
        }
        if (signal < _extentValley) {
            _extentValley = signal;
        }

        if (_state == 0) {
            if (signal > _armThreshold) {
                _state = 1;
            } else if (signal < -_releaseThreshold) {
                _state = 2;
            }
        } else if (_state == 1) {
            if (signal < -_releaseThreshold) {
                _lastCyclePeak = _extentPeak;
                _lastCycleValley = -_extentValley;
                _state = 0;
                _cooldown = _cooldownSamples;
                _extentPeak = 0.0;
                _extentValley = 0.0;
                return true;
            }
        } else if (_state == 2) {
            if (signal > _armThreshold) {
                _lastCyclePeak = _extentPeak;
                _lastCycleValley = -_extentValley;
                _state = 0;
                _cooldown = _cooldownSamples;
                _extentPeak = 0.0;
                _extentValley = 0.0;
                return true;
            }
        }
        return false;
    }

    function reset() as Void {
        _state = 0;
        _cooldown = 0;
        _extentPeak = 0.0;
        _extentValley = 0.0;
        _lastCyclePeak = 0.0;
        _lastCycleValley = 0.0;
    }

    function getLastCyclePeak() as Lang.Float {
        return _lastCyclePeak;
    }

    function getLastCycleValley() as Lang.Float {
        return _lastCycleValley;
    }
}
