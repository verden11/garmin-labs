import Toybox.Lang;
import Toybox.Test;

// Sky tests use a hand-built calculation so the expectations are plain numbers.
// Garmin values are seconds since local midnight; everything else is minutes.

function skyCalc(rise as Number or Null, set as Number or Null) as TwoSunsSunDay {
    return new TwoSunsSunDay(TwoSunsConfig.SUN_NORMAL, rise, set, 780, 400, 1100, 480, 1000);
}

function skyGarmin(minutes as Number) as Number {
    return minutes * TwoSunsConfig.SECONDS_PER_MINUTE;
}

function skyOf(now as Number, gRise as Number or Null, gSet as Number or Null, today as TwoSunsSunDay or Null,
               tomorrow as TwoSunsSunDay or Null) as TwoSunsSky {
    return TwoSunsSky.resolve(now, gRise, gSet, true, today, tomorrow);
}

(:test)
function skyDayShowsLightLeft(logger as Test.Logger) as Boolean {
    var sky = skyOf(900, skyGarmin(420), skyGarmin(1080), null, null);   // 07:00 to 18:00, it is 15:00
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_DAY);
    Test.assertEqual(sunPresent(sky.lightLeft), 180);
    Test.assertEqual(sunPresent(sky.rise), 420);
    Test.assertEqual(sunPresent(sky.set), 1080);
    Test.assert(!sky.golden);
    return true;
}

(:test)
function skyBoundariesAreInclusiveOfSunrise(logger as Test.Logger) as Boolean {
    Test.assertEqual(skyOf(419, skyGarmin(420), skyGarmin(1080), null, null).state, TwoSunsConfig.SKY_BEFORE_SUNRISE);
    Test.assertEqual(skyOf(420, skyGarmin(420), skyGarmin(1080), null, null).state, TwoSunsConfig.SKY_DAY);
    Test.assertEqual(skyOf(1079, skyGarmin(420), skyGarmin(1080), null, null).state, TwoSunsConfig.SKY_DAY);
    Test.assertEqual(skyOf(1080, skyGarmin(420), skyGarmin(1080), null, null).state, TwoSunsConfig.SKY_AFTER_SUNSET);
    return true;
}

(:test)
function skyBeforeSunriseAnnouncesTodaysSunrise(logger as Test.Logger) as Boolean {
    var sky = skyOf(300, skyGarmin(420), skyGarmin(1080), null, null);
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_BEFORE_SUNRISE);
    Test.assertEqual(sunPresent(sky.nextRise), 420);
    Test.assert(sky.lightLeft == null);
    return true;
}

// Tomorrow's sunrise keeps Garmin's offset: calculated tomorrow (07:02) + (Garmin 07:03 - calculated 07:00).
(:test)
function skyAfterSunsetKeepsGarminOffsetForTomorrow(logger as Test.Logger) as Boolean {
    var today = skyCalc(420, 1080);
    var tomorrow = skyCalc(422, 1078);
    var sky = skyOf(1200, skyGarmin(423), skyGarmin(1080), today, tomorrow);
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_AFTER_SUNSET);
    Test.assertEqual(sunPresent(sky.nextRise), 425);
    Test.assert(!sky.nextRiseIsToday);
    return true;
}

// No place: today's Garmin sunrise stands in for tomorrow's and says so.
(:test)
function skyAfterSunsetWithoutPlaceFlagsTheEstimate(logger as Test.Logger) as Boolean {
    var sky = skyOf(1200, skyGarmin(420), skyGarmin(1080), null, null);
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_AFTER_SUNSET);
    Test.assertEqual(sunPresent(sky.nextRise), 420);
    Test.assert(sky.nextRiseIsToday);
    return true;
}

// Sunset after local midnight (Garmin gives 00:04 as 244 s, which is less than the sunrise).
(:test)
function skySunsetAfterMidnightWraps(logger as Test.Logger) as Boolean {
    var sky = skyOf(1380, skyGarmin(175), skyGarmin(4), null, null);   // rise 02:55, set 00:04 next day, now 23:00
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_DAY);
    Test.assertEqual(sunPresent(sky.set), 1444);
    Test.assertEqual(sunPresent(sky.lightLeft), 64);
    return true;
}

(:test)
function skyPolarStates(logger as Test.Logger) as Boolean {
    var up = new TwoSunsSunDay(TwoSunsConfig.SUN_UP_ALL_DAY, null, null, 750, null, null, null, null);
    var down = new TwoSunsSunDay(TwoSunsConfig.SUN_DOWN_ALL_DAY, null, null, 700, 570, 830, null, null);
    Test.assertEqual(skyOf(600, null, null, up, null).state, TwoSunsConfig.SKY_MIDNIGHT_SUN);
    Test.assertEqual(skyOf(600, null, null, down, null).state, TwoSunsConfig.SKY_POLAR_NIGHT);
    return true;
}

// Garmin nulls and no place: say so. Garmin nulls, no Complications at all: say that instead.
(:test)
function skyNoPlaceAndNoData(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsSky.resolve(600, null, null, true, null, null).state, TwoSunsConfig.SKY_NO_PLACE);
    Test.assertEqual(TwoSunsSky.resolve(600, null, null, false, null, null).state, TwoSunsConfig.SKY_NO_DATA);
    Test.assertEqual(skyOf(600, 86400, -5, null, null).state, TwoSunsConfig.SKY_NO_PLACE);   // out-of-range Garmin values are null
    return true;
}

// Garmin has nothing but a place is known: our own calculation fills in (within 2 minutes of the USNO tests).
(:test)
function skyFallsBackToTheCalculation(logger as Test.Logger) as Boolean {
    var sky = skyOf(900, null, null, skyCalc(420, 1080), skyCalc(422, 1078));
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_DAY);
    Test.assertEqual(sunPresent(sky.lightLeft), 180);
    var after = skyOf(1200, null, null, skyCalc(420, 1080), skyCalc(422, 1078));
    Test.assertEqual(sunPresent(after.nextRise), 422);
    return true;
}

// A transition day: Garmin has one of the two. Show what exists; take the other from the calculation when there is one.
(:test)
function skyTransitionDayUsesWhatExists(logger as Test.Logger) as Boolean {
    var onlyRise = skyOf(900, skyGarmin(420), null, null, null);
    Test.assertEqual(onlyRise.state, TwoSunsConfig.SKY_DAY);
    Test.assert(onlyRise.lightLeft == null);
    var onlySet = skyOf(1100, null, skyGarmin(1080), null, null);
    Test.assertEqual(onlySet.state, TwoSunsConfig.SKY_AFTER_SUNSET);
    var filled = skyOf(900, skyGarmin(420), null, skyCalc(421, 1085), null);
    Test.assertEqual(sunPresent(filled.lightLeft), 185);
    return true;
}

// Tomorrow the sun does not rise: no sunrise to announce, and the flag says why.
(:test)
function skyPolarNightTomorrow(logger as Test.Logger) as Boolean {
    var down = new TwoSunsSunDay(TwoSunsConfig.SUN_DOWN_ALL_DAY, null, null, 700, 570, 830, null, null);
    var sky = skyOf(1200, skyGarmin(420), skyGarmin(1080), skyCalc(420, 1080), down);
    Test.assertEqual(sky.state, TwoSunsConfig.SKY_AFTER_SUNSET);
    Test.assert(sky.nextRise == null);
    Test.assert(sky.noNextRise);
    return true;
}

// The offset correction can push tomorrow's sunrise across midnight; it stays a clock minute.
(:test)
function skyNextRiseStaysAClockMinute(logger as Test.Logger) as Boolean {
    var sky = skyOf(1200, skyGarmin(20), skyGarmin(1080), skyCalc(10, 1080), skyCalc(1435, 1080));
    Test.assertEqual(sunPresent(sky.nextRise), 5);   // 1435 + (20 - 10) = 1445, wrapped
    return true;
}

(:test)
function skyGoldenHour(logger as Test.Logger) as Boolean {
    var calc = skyCalc(420, 1080);   // golden hour: morning until 480, evening from 1000
    Test.assert(skyOf(450, skyGarmin(420), skyGarmin(1080), calc, null).golden);
    Test.assert(!skyOf(600, skyGarmin(420), skyGarmin(1080), calc, null).golden);
    Test.assert(skyOf(1050, skyGarmin(420), skyGarmin(1080), calc, null).golden);
    Test.assert(!skyOf(300, skyGarmin(420), skyGarmin(1080), calc, null).golden);
    Test.assert(!skyOf(1050, skyGarmin(420), skyGarmin(1080), null, null).golden);   // needs a place
    return true;
}
