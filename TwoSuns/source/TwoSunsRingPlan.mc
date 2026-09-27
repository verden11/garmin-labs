import Toybox.Lang;

// What the sky ring shows, decided from a TwoSunsSky: which stretches of the day are twilight, daylight
// gone, daylight left and golden hour, where the sunrise and sunset ticks go and where the sun is now.
// Pure minutes, no drawing (TwoSunsRing draws it). The night track under it is always the whole circle.
class TwoSunsRingPlan {
    var arcs as Array<TwoSunsRingArc> = [] as Array<TwoSunsRingArc>;   // draw in order: later ones lie on top
    var ticks as Array<Number> = [] as Array<Number>;                  // minutes of sunrise and sunset
    var marker as Number or Null = null;                               // minute of now; null: no sun data, no marker
    var sunUp as Boolean = false;                                      // a solid marker when the sun is up, a hollow one when it is not

    static function build(sky as TwoSunsSky, now as Number, golden as Boolean) as TwoSunsRingPlan {
        var plan = new TwoSunsRingPlan();
        var state = sky.state;
        if (state == TwoSunsConfig.SKY_NO_PLACE || state == TwoSunsConfig.SKY_NO_DATA) {
            return plan;   // a plain track: nothing is known about the sun
        }
        plan.marker = now;
        plan.sunUp = state == TwoSunsConfig.SKY_DAY || state == TwoSunsConfig.SKY_MIDNIGHT_SUN;
        if (state == TwoSunsConfig.SKY_MIDNIGHT_SUN) {
            plan.arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_DAY_LEFT, 0, TwoSunsConfig.MINUTES_PER_DAY));
            return plan;
        }
        plan.addTwilight(sky);
        if (state != TwoSunsConfig.SKY_POLAR_NIGHT) {
            plan.addDaylight(sky, now);
            if (golden) {
                plan.addGolden(sky);
            }
        }
        return plan;
    }

    // Civil twilight from our own calculation, on either side of Garmin's sunrise and sunset (or the
    // whole of it on a polar-night day). Left out when the calculation is missing or disagrees.
    function addTwilight(sky as TwoSunsSky) as Void {
        var calc = sky.calc;
        if (calc == null) {
            return;
        }
        var begin = calc.civilBegin;
        var end = calc.civilEnd;
        var rise = sky.rise;
        var set = sky.set;
        if (rise == null && set == null) {
            if (begin != null && end != null && end > begin) {
                arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_TWILIGHT, begin, end));
            }
            return;
        }
        if (begin != null && rise != null && begin < rise) {
            arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_TWILIGHT, begin, rise));
        }
        if (end != null && set != null && end > set) {
            arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_TWILIGHT, set, end));
        }
    }

    // Daylight from sunrise to sunset: the part already gone, then the part still to come. A missing
    // sunrise or sunset (a transition day) runs to the edge of the day, and gets no tick.
    function addDaylight(sky as TwoSunsSky, now as Number) as Void {
        var rise = sky.rise;
        var set = sky.set;
        var from = rise == null ? 0 : rise;
        var to = set == null ? TwoSunsConfig.MINUTES_PER_DAY : set;
        if (rise != null) {
            ticks.add(rise);
        }
        if (set != null) {
            ticks.add(set);
        }
        var split = now < from ? from : (now > to ? to : now);
        if (split > from) {
            arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_DAY_GONE, from, split));
        }
        if (to > split) {
            arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_DAY_LEFT, split, to));
        }
    }

    // The golden hour after sunrise and before sunset, from our own calculation (needs a place).
    function addGolden(sky as TwoSunsSky) as Void {
        var calc = sky.calc;
        if (calc == null) {
            return;
        }
        var rise = sky.rise;
        var set = sky.set;
        var morningEnd = calc.goldenMorningEnd;
        var eveningStart = calc.goldenEveningStart;
        if (rise != null && morningEnd != null && morningEnd > rise) {
            arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_GOLDEN, rise, morningEnd));
        }
        if (set != null && eveningStart != null && set > eveningStart) {
            arcs.add(new TwoSunsRingArc(TwoSunsConfig.RING_GOLDEN, eveningStart, set));
        }
    }

    // Garmin's arc angle (0 is 3 o'clock, counter-clockwise, 0 to 359) of a minute on the ring: noon or
    // midnight at the top (90), the day running clockwise, 4 minutes to a degree.
    static function angleFor(minute as Number, orientation as Number) as Number {
        var top = orientation == TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP ? 0 : TwoSunsConfig.NOON_MINUTE;
        var clockwise = (minute - top) / TwoSunsConfig.MINUTES_PER_DEGREE_RING;
        var angle = (TwoSunsConfig.DEGREES_TOP - clockwise) % TwoSunsConfig.DEGREES_FULL_TURN;
        return angle < 0 ? angle + TwoSunsConfig.DEGREES_FULL_TURN : angle;
    }
}
