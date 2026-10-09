import Toybox.Lang;

// The last 24 hours of Body Battery, ready to draw: 96 buckets of 15 minutes, oldest first.
// A bucket is null when no valid sample fell in it. `current` is the newest valid sample (0 to 100),
// null when there is none; `stale` is true when that newest sample is older than an hour.
class TwoSunsBatteryCurve {
    var buckets as Array<Number or Null>;
    var current as Number or Null = null;
    var newestWhen as Number or Null = null;
    var stale as Boolean = false;

    function initialize() {
        buckets = new Array<Number or Null>[TwoSunsConfig.BATTERY_BUCKETS];
    }

    // Whether two neighbouring buckets both have a sample, so the curve draws at least one stretch of line.
    function hasALine() as Boolean {
        for (var i = 1; i < buckets.size(); i++) {
            if (buckets[i] != null && buckets[i - 1] != null) {
                return true;
            }
        }
        return false;
    }
}
