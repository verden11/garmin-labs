import Toybox.Lang;

// Replays one set at every candidate threshold (ADR-040), counting as the
// set runs instead of storing it. Each turning point of the detector signal
// — two per rep — is applied to LEARN_BINS running counters inside the
// sensor callback that produced it, so the picker's save reads a finished
// answer. The whole-set replay this replaces scanned up to 500 stored points
// 24 times in one input callback and tripped the watchdog on a real FR965.
//
// Reversals smaller than TRACE_HYSTERESIS are dropped; that loses nothing a
// threshold can see, because a flip needs a swing of 2 * threshold, and the
// smallest candidate threshold keeps that above the hysteresis.
class HeroSetSwingTrace {
    private var _flipGapSamples as Lang.Number;
    private var _direction as Lang.Number = 0;
    private var _extreme as Lang.Float?;
    private var _extremeAt as Lang.Number = 0;
    private var _points as Lang.Number = 0;
    private var _overflowed as Lang.Boolean = false;
    private var _side as Lang.Array<Lang.Number>;
    private var _lastFlipAt as Lang.Array<Lang.Number>;
    private var _flips as Lang.Array<Lang.Number>;

    function initialize(flipGapSamples as Lang.Number) {
        _flipGapSamples = flipGapSamples;
        var bins = HeroSetConfig.LEARN_BINS;
        _side = new [bins] as Lang.Array<Lang.Number>;
        _lastFlipAt = new [bins] as Lang.Array<Lang.Number>;
        _flips = new [bins] as Lang.Array<Lang.Number>;
        for (var k = 0; k < bins; k++) {
            _side[k] = 0;
            _lastFlipAt[k] = -flipGapSamples;
            _flips[k] = 0;
        }
    }

    function feed(signal as Lang.Float, sampleIndex as Lang.Number) as Void {
        var extreme = _extreme;
        if (extreme == null || (_direction >= 0 && signal >= extreme) || (_direction <= 0 && signal <= extreme)) {
            if (extreme != null && _direction == 0) {
                _direction = signal > extreme ? 1 : (signal < extreme ? -1 : 0);
            }
            _extreme = signal;
            _extremeAt = sampleIndex;
            return;
        }
        if ((extreme - signal).abs() > HeroSetConfig.TRACE_HYSTERESIS) {
            emit(extreme, _extremeAt);
            _direction = signal > extreme ? 1 : -1;
            _extreme = signal;
            _extremeAt = sampleIndex;
        }
    }

    // A set past TRACE_MAX_POINTS turning points stopped being counted, so
    // it can't replay honestly and learning skips it.
    function isComplete() as Lang.Boolean {
        return !_overflowed;
    }

    // Reps at each candidate threshold. Mirrors HeroSetRepCounter.detect:
    // one rep per two side changes, none closer than the flip gap. The
    // turning point still open is applied to a copy, so reading never ends
    // the set. Turning-point times stand in for the first sample past the
    // threshold, so the gap is only approximately live's.
    function counts() as Lang.Array<Lang.Number> {
        var bins = HeroSetConfig.LEARN_BINS;
        var side = _side.slice(0, null) as Lang.Array<Lang.Number>;
        var lastFlipAt = _lastFlipAt.slice(0, null) as Lang.Array<Lang.Number>;
        var flips = _flips.slice(0, null) as Lang.Array<Lang.Number>;
        var extreme = _extreme;
        if (extreme != null) {
            apply(side, lastFlipAt, flips, extreme, _extremeAt);
        }
        var counted = new [bins] as Lang.Array<Lang.Number>;
        for (var k = 0; k < bins; k++) {
            counted[k] = flips[k] / 2;
        }
        return counted;
    }

    private function emit(value as Lang.Float, at as Lang.Number) as Void {
        if (_points >= HeroSetConfig.TRACE_MAX_POINTS) {
            _overflowed = true;
            return;
        }
        _points += 1;
        apply(_side, _lastFlipAt, _flips, value, at);
    }

    // Candidates are ascending, so the first one the swing doesn't clear
    // ends the point: no higher threshold can see it either.
    private function apply(side as Lang.Array<Lang.Number>, lastFlipAt as Lang.Array<Lang.Number>, flips as Lang.Array<Lang.Number>, value as Lang.Float, at as Lang.Number) as Void {
        var thresholds = HeroSetThresholdLearner.thresholds();
        for (var k = 0; k < thresholds.size(); k++) {
            var threshold = thresholds[k];
            var s = value > threshold ? 1 : (value < -threshold ? -1 : 0);
            if (s == 0) {
                return;
            }
            if (s != side[k] && at - lastFlipAt[k] >= _flipGapSamples) {
                side[k] = s;
                lastFlipAt[k] = at;
                flips[k] += 1;
            }
        }
    }
}
