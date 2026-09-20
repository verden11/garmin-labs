import Toybox.Lang;
import Toybox.Math;

// Learns each exercise's rep threshold from the counts users save, instead
// of a calibration screen (ADR-040). Not a running average of corrections:
// the count is a staircase in the threshold, so averaging or feedback
// control would hunt between steps. Each saved set is replayed at every
// candidate threshold, which says exactly which thresholds would have been
// right, and a belief over the candidates is updated from that.
//
// State: log-weights over LEARN_BINS thresholds (log-spaced) times two
// endings. Index k keeps the set as counted; LEARN_BINS + k drops its last
// counted rep, which is how one user's habit of getting up before pressing
// Finish looks. No threshold can drop that rep alone (getting up is the
// biggest swing of the set), and a threshold-only fit lands somewhere
// different every set, so over a few sets the ending hypothesis wins.
//
// ponytail: grid of 2 x LEARN_BINS; a continuous model only if 14% threshold
// steps prove too coarse on real wrists.
class HeroSetThresholdLearner {

    static function initialState() as Lang.Array<Lang.Float> {
        var state = new [2 * HeroSetConfig.LEARN_BINS] as Lang.Array<Lang.Float>;
        for (var i = 0; i < state.size(); i++) {
            state[i] = priorAt(i);
        }
        return state;
    }

    static function thresholdAt(bin as Lang.Number) as Lang.Float {
        var span = HeroSetConfig.LEARN_MAX_THRESHOLD / HeroSetConfig.LEARN_MIN_THRESHOLD;
        return (HeroSetConfig.LEARN_MIN_THRESHOLD * Math.pow(span, bin.toFloat() / (HeroSetConfig.LEARN_BINS - 1))).toFloat();
    }

    // Null when the set can't teach anything: nothing saved, a trace that
    // overflowed, or more reps than the movement can explain at any
    // threshold (reps done without the watch, typed into the same set).
    static function updated(state as Lang.Array<Lang.Float>, trace as HeroSetSwingTrace, saved as Lang.Number) as Lang.Array<Lang.Float>? {
        if (saved < 1 || !trace.isComplete()) {
            return null;
        }
        var bins = HeroSetConfig.LEARN_BINS;
        var counts = new [bins] as Lang.Array<Lang.Number>;
        for (var k = 0; k < bins; k++) {
            counts[k] = trace.countAt(thresholdAt(k));
        }
        if (saved - counts[0] > max(2, saved * HeroSetConfig.LEARN_UNEXPLAINED_PERCENT / 100)) {
            return null;
        }
        var tolerance = max(1, saved * HeroSetConfig.LEARN_TOLERANCE_PERCENT / 100).toFloat();
        var next = new [state.size()] as Lang.Array<Lang.Float>;
        for (var i = 0; i < state.size(); i++) {
            var count = counts[i % bins];
            if (i >= bins && count > 0) {
                count -= 1;
            }
            next[i] = HeroSetConfig.LEARN_MEMORY * state[i] + (1.0 - HeroSetConfig.LEARN_MEMORY) * priorAt(i) + logLikelihood((count - saved).abs(), tolerance);
        }
        return normalized(next);
    }

    // Whichever ending carries more belief.
    static function dropsLastRep(state as Lang.Array<Lang.Float>) as Lang.Boolean {
        var bins = HeroSetConfig.LEARN_BINS;
        var keep = 0.0;
        var drop = 0.0;
        for (var k = 0; k < bins; k++) {
            keep += weight(state[k]);
            drop += weight(state[bins + k]);
        }
        return drop > keep;
    }

    // Median of the belief within the winning ending: when a whole range of
    // thresholds fits every set, that is the middle of the range, the most
    // room for a slightly deeper or shallower rep either way.
    static function threshold(state as Lang.Array<Lang.Float>) as Lang.Number {
        var bins = HeroSetConfig.LEARN_BINS;
        var offset = dropsLastRep(state) ? bins : 0;
        var total = 0.0;
        for (var k = 0; k < bins; k++) {
            total += weight(state[offset + k]);
        }
        var running = 0.0;
        for (var k = 0; k < bins; k++) {
            running += weight(state[offset + k]);
            if (running >= total / 2.0) {
                return thresholdAt(k).toNumber();
            }
        }
        return thresholdAt(bins - 1).toNumber();
    }

    // Log-normal around the default threshold; dropping the last rep starts
    // out less likely than keeping it. Forgetting pulls toward this, so a
    // form change is followed within a few sets and belief never hardens.
    private static function priorAt(index as Lang.Number) as Lang.Float {
        var bins = HeroSetConfig.LEARN_BINS;
        var z = Math.ln(thresholdAt(index % bins) / HeroSetConfig.DEFAULT_THRESHOLD) / HeroSetConfig.LEARN_PRIOR_SPREAD;
        var prior = -z * z / 2.0;
        if (index >= bins) {
            prior += Math.ln(HeroSetConfig.LEARN_DROP_PRIOR / (1.0 - HeroSetConfig.LEARN_DROP_PRIOR));
        }
        return prior.toFloat();
    }

    // Off by `miss` reps. The floor caps what one mistyped count can cost a
    // hypothesis that fitted every earlier set.
    private static function logLikelihood(miss as Lang.Number, tolerance as Lang.Float) as Lang.Float {
        var floor = HeroSetConfig.LEARN_MISTAKE_FLOOR;
        return Math.ln(floor + (1.0 - floor) * Math.pow(Math.E, -miss / tolerance)).toFloat();
    }

    private static function normalized(state as Lang.Array<Lang.Float>) as Lang.Array<Lang.Float> {
        var top = state[0];
        for (var i = 1; i < state.size(); i++) {
            if (state[i] > top) {
                top = state[i];
            }
        }
        for (var i = 0; i < state.size(); i++) {
            state[i] -= top;
        }
        return state;
    }

    private static function weight(logWeight as Lang.Float) as Lang.Float {
        return Math.pow(Math.E, logWeight).toFloat();
    }

    private static function max(a as Lang.Number, b as Lang.Number) as Lang.Number {
        return a > b ? a : b;
    }
}
