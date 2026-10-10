import Toybox.Lang;
import Toybox.Math;

// Turns SensorHistory Body Battery samples into a TwoSunsBatteryCurve. Pure: the caller feeds the
// iterator's samples one by one to `add` (the tests pass parallel arrays to `build`), so every rule below
// is unit-tested without a watch.
class TwoSunsBattery {

    // `whens` are epoch seconds (each sample's own `when`, never getOldestSampleTime). Order does not matter.
    // Pro only (SensorHistory): the Free build never builds a curve (docs/decisions.md ADR-020, Free + Pro ladder).
    (:pro)
    static function build(values as Array<Numeric or Null>, whens as Array<Number or Null>, now as Number) as TwoSunsBatteryCurve {
        var curve = new TwoSunsBatteryCurve();
        var bucketWhen = new Array<Number or Null>[TwoSunsConfig.BATTERY_BUCKETS];
        var count = values.size() < whens.size() ? values.size() : whens.size();
        for (var i = 0; i < count; i++) {
            add(curve, bucketWhen, values[i], whens[i], now);
        }
        return finish(curve, now);
    }

    // One sample into the curve; the newest sample of each bucket wins. Fed straight from the iterator so a
    // read never holds the raw samples on top of it (an Instinct has 59.8 kB; simulator soak, 2026-10-10).
    (:pro)
    static function add(curve as TwoSunsBatteryCurve, bucketWhen as Array<Number or Null>, value as Numeric or Null, when as Number or Null, now as Number) as Void {
        var start = now - TwoSunsConfig.BATTERY_WINDOW_SECONDS;
        if (value == null || when == null || !isValidValue(value) || when < start || when > now + TwoSunsConfig.BATTERY_FUTURE_SLACK_SECONDS) {
            return;
        }
        var level = Math.round(value).toNumber();
        var index = bucketIndex(when, start);
        var held = bucketWhen[index];
        if (held == null || when > held) {
            curve.buckets[index] = level;
            bucketWhen[index] = when;
        }
        var newest = curve.newestWhen;
        if (newest == null || when > newest) {
            curve.newestWhen = when;
            curve.current = level;
        }
    }

    (:pro)
    static function finish(curve as TwoSunsBatteryCurve, now as Number) as TwoSunsBatteryCurve {
        var newestWhen = curve.newestWhen;
        curve.stale = newestWhen != null && now - newestWhen > TwoSunsConfig.BATTERY_STALE_SECONDS;
        return curve;
    }

    // Whether this watch's firmware has the Body Battery history at all (a property of the watch, not of one read).
    (:pro)
    static function hasHistory() as Boolean {
        return (Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory);
    }

    (:free)
    static function hasHistory() as Boolean {
        return false;
    }

    // A real reading: a number from 0 to 100. Null, negative and 127 (not worn) are not.
    static function isValidValue(value as Numeric) as Boolean {
        return value >= 0 && value <= TwoSunsConfig.BATTERY_MAX;
    }

    (:pro)
    static function bucketIndex(when as Number, start as Number) as Number {
        var index = (when - start) / TwoSunsConfig.BATTERY_BUCKET_SECONDS;
        return index < TwoSunsConfig.BATTERY_BUCKETS ? index : TwoSunsConfig.BATTERY_BUCKETS - 1;
    }
}
