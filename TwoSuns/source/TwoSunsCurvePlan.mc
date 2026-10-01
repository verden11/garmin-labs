import Toybox.Lang;

// The 96 buckets of the last 24 hours as screen points inside a box: x by bucket, y by level (0 at the
// bottom, 100 at the top). A bucket with no sample has no point (a gap, never an invented value).
// Pure numbers; TwoSunsCurve draws them. Pro only: the Free build has no history, so no curve (docs/decisions.md ADR-020, Free + Pro ladder).
(:pro)
class TwoSunsCurvePlan {
    var xs as Array<Number> = [] as Array<Number>;
    var ys as Array<Number or Null> = [] as Array<Number or Null>;
    var bottom as Number = 0;       // the baseline the fill stands on
    var lastIndex as Number = -1;   // the newest bucket that has a point, -1 when there is none

    static function build(curve as TwoSunsBatteryCurve, left as Number, top as Number, width as Number, height as Number) as TwoSunsCurvePlan {
        var plan = new TwoSunsCurvePlan();
        var count = TwoSunsConfig.BATTERY_BUCKETS;
        plan.bottom = top + height - 1;
        for (var i = 0; i < count; i++) {
            plan.xs.add(left + i * (width - 1) / (count - 1));
            var level = curve.buckets[i];
            if (level == null) {
                plan.ys.add(null);
                continue;
            }
            var clamped = level < 0 ? 0 : (level > TwoSunsConfig.BATTERY_MAX ? TwoSunsConfig.BATTERY_MAX : level);
            plan.ys.add(plan.bottom - clamped * (height - 1) / TwoSunsConfig.BATTERY_MAX);
            plan.lastIndex = i;
        }
        return plan;
    }

    // The width of the fill column that belongs to bucket i: up to the next bucket, at least one pixel.
    function cellWidth(i as Number) as Number {
        if (i >= xs.size() - 1) {
            return 1;
        }
        var width = xs[i + 1] - xs[i];
        return width < 1 ? 1 : width;
    }
}
