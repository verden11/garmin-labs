import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;

(:debug)
function ringSky(state as Number, rise as Number or Null, set as Number or Null) as TwoSunsSky {
    var sky = new TwoSunsSky();
    sky.state = state;
    sky.rise = rise;
    sky.set = set;
    return sky;
}

// A calculation: twilight 05:30 to 20:30, golden hour until 08:00 and from 18:00.
(:debug)
function ringCalc() as TwoSunsSunDay {
    return new TwoSunsSunDay(TwoSunsConfig.SUN_NORMAL, 420, 1140, 780, 330, 1230, 480, 1080);
}

(:debug)
function ringCount(plan as TwoSunsRingPlan, kind as Number) as Number {
    var count = 0;
    for (var i = 0; i < plan.arcs.size(); i++) {
        if (plan.arcs[i].kind == kind) {
            count++;
        }
    }
    return count;
}

// Garmin arc angles: 0 is 3 o'clock, counter-clockwise; the top is 90. Noon at the top by default.
(:test)
function angleNoonAtTop(logger as Test.Logger) as Boolean {
    var noon = TwoSunsConfig.ORIENTATION_NOON_TOP;
    Test.assertEqual(TwoSunsRingPlan.angleFor(720, noon), 90);    // noon: top
    Test.assertEqual(TwoSunsRingPlan.angleFor(1080, noon), 0);    // 18:00: a quarter turn clockwise, 3 o'clock
    Test.assertEqual(TwoSunsRingPlan.angleFor(0, noon), 270);     // midnight: bottom
    Test.assertEqual(TwoSunsRingPlan.angleFor(360, noon), 180);   // 06:00: 9 o'clock
    Test.assertEqual(TwoSunsRingPlan.angleFor(1440, noon), 270);  // 24:00 is midnight again
    Test.assertEqual(TwoSunsRingPlan.angleFor(1444, noon), 269);  // a sunset at 00:04 is just past the bottom
    return true;
}

(:test)
function angleMidnightAtTop(logger as Test.Logger) as Boolean {
    var midnight = TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP;
    Test.assertEqual(TwoSunsRingPlan.angleFor(0, midnight), 90);
    Test.assertEqual(TwoSunsRingPlan.angleFor(360, midnight), 0);
    Test.assertEqual(TwoSunsRingPlan.angleFor(720, midnight), 270);
    Test.assertEqual(TwoSunsRingPlan.angleFor(1080, midnight), 180);
    return true;
}

// Every minute of two days gives an angle from 0 to 359, in both orientations.
(:test)
function angleAlwaysInRange(logger as Test.Logger) as Boolean {
    for (var minute = -100; minute < 2 * TwoSunsConfig.MINUTES_PER_DAY; minute += 7) {
        for (var orientation = 0; orientation <= 1; orientation++) {
            var angle = TwoSunsRingPlan.angleFor(minute, orientation);
            Test.assertMessage(angle >= 0 && angle < 360, "minute " + minute + " angle " + angle);
        }
    }
    return true;
}

// Plain states: no data, no marker, no arcs, no ticks (docs/spec.md: ring plain, no sun marker).
(:test)
function ringPlainWithoutData(logger as Test.Logger) as Boolean {
    var states = [TwoSunsConfig.SKY_NO_PLACE, TwoSunsConfig.SKY_NO_DATA] as Array<Number>;
    for (var i = 0; i < states.size(); i++) {
        var plan = TwoSunsRingPlan.build(ringSky(states[i], null, null), 600, true);
        Test.assert(plan.marker == null);
        Test.assertEqual(plan.arcs.size(), 0);
        Test.assertEqual(plan.ticks.size(), 0);
    }
    return true;
}

// Day: daylight gone from sunrise to now, left from now to sunset, ticks at both, a solid marker at now.
(:test)
function ringDay(logger as Test.Logger) as Boolean {
    var sky = ringSky(TwoSunsConfig.SKY_DAY, 420, 1140);
    sky.calc = ringCalc();
    var plan = TwoSunsRingPlan.build(sky, 900, false);
    Test.assertEqual(plan.arcs.size(), 4);   // two twilight, gone, left
    Test.assertEqual(ringCount(plan, TwoSunsConfig.RING_TWILIGHT), 2);
    Test.assertEqual(ringCount(plan, TwoSunsConfig.RING_DAY_GONE), 1);
    Test.assertEqual(ringCount(plan, TwoSunsConfig.RING_DAY_LEFT), 1);
    Test.assertEqual(ringCount(plan, TwoSunsConfig.RING_GOLDEN), 0);
    Test.assertEqual(plan.ticks.size(), 2);
    Test.assertEqual(sunPresent(plan.marker), 900);
    Test.assert(plan.sunUp);
    // The gone arc ends where the left arc begins: no gap, no overlap.
    var gone = plan.arcs[ringIndex(plan, TwoSunsConfig.RING_DAY_GONE)];
    var left = plan.arcs[ringIndex(plan, TwoSunsConfig.RING_DAY_LEFT)];
    Test.assertEqual(gone.from, 420);
    Test.assertEqual(gone.to, 900);
    Test.assertEqual(left.from, 900);
    Test.assertEqual(left.to, 1140);
    return true;
}

(:debug)
function ringIndex(plan as TwoSunsRingPlan, kind as Number) as Number {
    for (var i = 0; i < plan.arcs.size(); i++) {
        if (plan.arcs[i].kind == kind) {
            return i;
        }
    }
    return -1;
}

// Before sunrise the whole day is still to come; after sunset it is all gone. The marker is an outline.
(:test)
function ringBeforeAndAfter(logger as Test.Logger) as Boolean {
    var before = TwoSunsRingPlan.build(ringSky(TwoSunsConfig.SKY_BEFORE_SUNRISE, 420, 1140), 300, false);
    Test.assertEqual(ringCount(before, TwoSunsConfig.RING_DAY_GONE), 0);
    Test.assertEqual(ringCount(before, TwoSunsConfig.RING_DAY_LEFT), 1);
    var wholeDay = before.arcs[ringIndex(before, TwoSunsConfig.RING_DAY_LEFT)];
    Test.assertEqual(wholeDay.from, 420);   // daylight is clipped to sunrise and sunset, not drawn from "now"
    Test.assertEqual(wholeDay.to, 1140);
    Test.assert(!before.sunUp);
    var after = TwoSunsRingPlan.build(ringSky(TwoSunsConfig.SKY_AFTER_SUNSET, 420, 1140), 1300, false);
    Test.assertEqual(ringCount(after, TwoSunsConfig.RING_DAY_GONE), 1);
    Test.assertEqual(ringCount(after, TwoSunsConfig.RING_DAY_LEFT), 0);
    var spent = after.arcs[ringIndex(after, TwoSunsConfig.RING_DAY_GONE)];
    Test.assertEqual(spent.from, 420);
    Test.assertEqual(spent.to, 1140);
    Test.assert(!after.sunUp);
    return true;
}

// A sunset after midnight (1444): the daylight arc runs past 1440 and the ring still has one bright and one dim part.
(:test)
function ringSunsetAfterMidnight(logger as Test.Logger) as Boolean {
    var plan = TwoSunsRingPlan.build(ringSky(TwoSunsConfig.SKY_DAY, 175, 1444), 1380, false);
    var left = plan.arcs[ringIndex(plan, TwoSunsConfig.RING_DAY_LEFT)];
    Test.assertEqual(left.from, 1380);
    Test.assertEqual(left.to, 1444);
    var gone = plan.arcs[ringIndex(plan, TwoSunsConfig.RING_DAY_GONE)];
    Test.assertEqual(gone.from, 175);
    return true;
}

(:test)
function ringMidnightSunAndPolarNight(logger as Test.Logger) as Boolean {
    var up = TwoSunsRingPlan.build(ringSky(TwoSunsConfig.SKY_MIDNIGHT_SUN, null, null), 600, true);
    Test.assertEqual(up.arcs.size(), 1);
    Test.assertEqual(up.arcs[0].kind, TwoSunsConfig.RING_DAY_LEFT);
    Test.assertEqual(up.arcs[0].to - up.arcs[0].from, TwoSunsConfig.MINUTES_PER_DAY);
    Test.assert(up.sunUp);
    Test.assertEqual(up.ticks.size(), 0);
    // Polar night: no daylight, only the twilight of our own calculation if there is one.
    var night = ringSky(TwoSunsConfig.SKY_POLAR_NIGHT, null, null);
    night.calc = new TwoSunsSunDay(TwoSunsConfig.SUN_DOWN_ALL_DAY, null, null, 700, 570, 830, null, null);
    var plan = TwoSunsRingPlan.build(night, 600, true);
    Test.assertEqual(plan.arcs.size(), 1);
    Test.assertEqual(plan.arcs[0].kind, TwoSunsConfig.RING_TWILIGHT);
    Test.assertEqual(plan.arcs[0].from, 570);
    Test.assert(!plan.sunUp);
    Test.assert(plan.marker != null);
    return true;
}

// The golden hour only shows when the setting is on and a calculation exists.
(:test)
function ringGoldenHour(logger as Test.Logger) as Boolean {
    var sky = ringSky(TwoSunsConfig.SKY_DAY, 420, 1140);
    sky.calc = ringCalc();
    var on = TwoSunsRingPlan.build(sky, 900, true);
    Test.assertEqual(ringCount(on, TwoSunsConfig.RING_GOLDEN), 2);
    Test.assertEqual(on.arcs[on.arcs.size() - 1].kind, TwoSunsConfig.RING_GOLDEN);   // on top of the daylight
    Test.assertEqual(ringCount(TwoSunsRingPlan.build(sky, 900, false), TwoSunsConfig.RING_GOLDEN), 0);
    var noPlace = ringSky(TwoSunsConfig.SKY_DAY, 420, 1140);
    Test.assertEqual(ringCount(TwoSunsRingPlan.build(noPlace, 900, true), TwoSunsConfig.RING_GOLDEN), 0);
    // A calculation that disagrees with Garmin (its golden hour would start after Garmin's sunset, or end
    // before Garmin's sunrise) adds no arc, never a backwards one.
    var late = ringSky(TwoSunsConfig.SKY_DAY, 420, 1000);
    late.calc = new TwoSunsSunDay(TwoSunsConfig.SUN_NORMAL, 420, 1140, 780, 330, 1230, 400, 1080);
    Test.assertEqual(ringCount(TwoSunsRingPlan.build(late, 900, true), TwoSunsConfig.RING_GOLDEN), 0);
    return true;
}

// A transition day with only one of sunrise and sunset: the daylight runs to the edge of the day and only the known tick shows.
(:test)
function ringTransitionDay(logger as Test.Logger) as Boolean {
    var plan = TwoSunsRingPlan.build(ringSky(TwoSunsConfig.SKY_DAY, 420, null), 900, false);
    Test.assertEqual(plan.ticks.size(), 1);
    Test.assertEqual(plan.ticks[0], 420);
    var left = plan.arcs[ringIndex(plan, TwoSunsConfig.RING_DAY_LEFT)];
    Test.assertEqual(left.to, TwoSunsConfig.MINUTES_PER_DAY);
    return true;
}

// Twilight is left out when the calculation disagrees with Garmin (it would start after sunrise).
(:test)
function ringTwilightSkipsAnInconsistentCalculation(logger as Test.Logger) as Boolean {
    var sky = ringSky(TwoSunsConfig.SKY_DAY, 300, 1140);   // Garmin sunrise 05:00, calculation says twilight begins 05:30
    sky.calc = ringCalc();
    var plan = TwoSunsRingPlan.build(sky, 900, false);
    Test.assertEqual(ringCount(plan, TwoSunsConfig.RING_TWILIGHT), 1);   // only the evening one
    return true;
}

(:test, :color)
function dimLowersOnlyFullChannels(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsPalette.dim(0xFFAA00), 0xAAAA00);
    Test.assertEqual(TwoSunsPalette.dim(0x55FFAA), 0x55AAAA);
    // 0xFFFFFF (winter) is the one exception: naively dimming every full channel lands exactly on
    // MUTED, so dim() nudges the red channel one further step (see TwoSunsPalette.dim, ADR-017
    // amendment 2026-09-27) — this assertion used to encode the old, colliding behaviour.
    Test.assertEqual(TwoSunsPalette.dim(0xFFFFFF), 0x55AAAA);
    Test.assertEqual(TwoSunsPalette.dim(0x000000), 0x000000);
    return true;
}

// WCAG contrast of a colour against black: (L + 0.05) / 0.05, L from the sRGB channels.
(:debug)
function ringContrast(color as Number) as Float {
    var luminance = 0.0;
    var weights = [0.2126, 0.7152, 0.0722] as Array<Float>;
    for (var i = 0; i < 3; i++) {
        var channel = ((color >> (16 - 8 * i)) & 0xFF) / 255.0;
        var linear = channel <= 0.04045 ? channel / 12.92 : Math.pow((channel + 0.055) / 1.055, 2.4).toFloat();
        luminance += weights[i] * linear;
    }
    return (luminance + 0.05) / 0.05;
}

// In bright sun the dim parts must still read: the night track and the already-gone daylight of EVERY
// accent are at least 3:1 against black (docs/spec.md "Design brief").
(:test)
function dimPartsStayReadable(logger as Test.Logger) as Boolean {
    Test.assertMessage(ringContrast(TwoSunsPalette.NIGHT) >= 3.0, "night track contrast " + ringContrast(TwoSunsPalette.NIGHT));
    for (var i = 0; i < TwoSunsPalette.ACCENTS.size(); i++) {
        var gone = TwoSunsRing.colorFor(TwoSunsConfig.RING_DAY_GONE, TwoSunsPalette.ACCENTS[i]);
        Test.assertMessage(ringContrast(gone) >= 3.0, "accent " + i + " gone contrast " + ringContrast(gone));
    }
    return true;
}

// For every accent the ring's five colours (night, twilight, gone, left, golden) are all different.
(:test, :color)
function ringColoursAreDistinctForEveryAccent(logger as Test.Logger) as Boolean {
    for (var a = 0; a < TwoSunsPalette.ACCENTS.size(); a++) {
        var accent = TwoSunsPalette.ACCENTS[a];
        var colours = [TwoSunsRing.colorFor(TwoSunsConfig.RING_TWILIGHT, accent), TwoSunsRing.colorFor(TwoSunsConfig.RING_DAY_GONE, accent),
                       TwoSunsRing.colorFor(TwoSunsConfig.RING_DAY_LEFT, accent), TwoSunsRing.colorFor(TwoSunsConfig.RING_GOLDEN, accent),
                       TwoSunsPalette.NIGHT] as Array<Number>;
        for (var i = 0; i < colours.size(); i++) {
            for (var j = i + 1; j < colours.size(); j++) {
                Test.assertMessage(colours[i] != colours[j], "accent " + a + ": colours " + i + " and " + j + " are the same");
            }
        }
        Test.assertEqual(TwoSunsRing.colorFor(TwoSunsConfig.RING_DAY_LEFT, accent), accent);
    }
    return true;
}
