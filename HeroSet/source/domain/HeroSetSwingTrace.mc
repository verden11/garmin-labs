import Toybox.Lang;

// Every turning point of one set's detector signal, small ones included, so
// the set can be replayed after the user saves the real count: what would
// each candidate threshold have counted? (ADR-040). Reversals smaller than
// TRACE_HYSTERESIS are dropped; that loses nothing a threshold can see,
// because a flip needs a swing of 2 * threshold, and the smallest learned
// threshold keeps that above the hysteresis.
class HeroSetSwingTrace {
    private var _values as Lang.Array<Lang.Float> = [] as Lang.Array<Lang.Float>;
    private var _times as Lang.Array<Lang.Number> = [] as Lang.Array<Lang.Number>;
    private var _flipGapSamples as Lang.Number;
    private var _direction as Lang.Number = 0;
    private var _extreme as Lang.Float?;
    private var _extremeAt as Lang.Number = 0;
    private var _overflowed as Lang.Boolean = false;

    function initialize(flipGapSamples as Lang.Number) {
        _flipGapSamples = flipGapSamples;
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

    // A full trace can't replay honestly, so learning skips the set.
    function isComplete() as Lang.Boolean {
        return !_overflowed;
    }

    // Mirrors HeroSetRepCounter.detect: one rep per two side changes, none
    // closer than the flip gap. Turning-point times stand in for the first
    // sample past the threshold, so the gap is only approximately live's.
    function countAt(threshold as Lang.Float) as Lang.Number {
        var side = 0;
        var lastFlipAt = -_flipGapSamples;
        var flips = 0;
        var points = _values.size();
        for (var i = 0; i <= points; i++) {
            var value = i < points ? _values[i] : _extreme;
            if (value == null) {
                break;
            }
            var at = i < points ? _times[i] : _extremeAt;
            var s = value > threshold ? 1 : (value < -threshold ? -1 : 0);
            if (s != 0 && s != side && at - lastFlipAt >= _flipGapSamples) {
                side = s;
                lastFlipAt = at;
                flips += 1;
            }
        }
        return flips / 2;
    }

    private function emit(value as Lang.Float, at as Lang.Number) as Void {
        if (_values.size() >= HeroSetConfig.TRACE_MAX_POINTS) {
            _overflowed = true;
            return;
        }
        _values.add(value);
        _times.add(at);
    }
}
