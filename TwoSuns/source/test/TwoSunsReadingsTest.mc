import Toybox.Lang;
import Toybox.Test;

// Word tests assume the simulator language is English (the same assumption Days To Go's word tests make).

function readingsSky(state as Number) as TwoSunsSky {
    var sky = new TwoSunsSky();
    sky.state = state;
    return sky;
}

(:test)
function clockTextTwentyFourHour(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsReadings.clockText(0, true), "00:00");
    Test.assertEqual(TwoSunsReadings.clockText(6 * 60 + 41, true), "06:41");
    Test.assertEqual(TwoSunsReadings.clockText(23 * 60 + 59, true), "23:59");
    return true;
}

(:test)
function clockTextTwelveHour(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsReadings.clockText(0, false), "12:00");
    Test.assertEqual(TwoSunsReadings.clockText(6 * 60 + 41, false), "6:41");
    Test.assertEqual(TwoSunsReadings.clockText(12 * 60, false), "12:00");
    Test.assertEqual(TwoSunsReadings.clockText(18 * 60 + 5, false), "6:05");
    return true;
}

// A sunset after midnight (1444) reads as 00:04; a negative minute wraps backwards.
(:test)
function clockTextWraps(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsReadings.clockText(1444, true), "00:04");
    Test.assertEqual(TwoSunsReadings.clockText(-5, true), "23:55");
    return true;
}

(:test)
function durationText(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsReadings.durationText(222), "3:42");
    Test.assertEqual(TwoSunsReadings.durationText(0), "0:00");
    Test.assertEqual(TwoSunsReadings.durationText(59), "0:59");
    Test.assertEqual(TwoSunsReadings.durationText(64), "1:04");
    return true;
}

(:test)
function skyLineDay(logger as Test.Logger) as Boolean {
    var sky = readingsSky(TwoSunsConfig.SKY_DAY);
    sky.lightLeft = 222;
    Test.assertEqual(TwoSunsReadings.skyLine(sky, true), "3:42 of daylight");
    sky.lightLeft = null;
    Test.assertEqual(TwoSunsReadings.skyLine(sky, true), "Sun is up");
    return true;
}

(:test)
function skyLineSunrise(logger as Test.Logger) as Boolean {
    var before = readingsSky(TwoSunsConfig.SKY_BEFORE_SUNRISE);
    before.nextRise = 6 * 60 + 41;
    Test.assertEqual(TwoSunsReadings.skyLine(before, true), "Sunrise 06:41");
    Test.assertEqual(TwoSunsReadings.skyLine(before, false), "Sunrise 6:41");
    var after = readingsSky(TwoSunsConfig.SKY_AFTER_SUNSET);
    after.nextRise = 6 * 60 + 41;
    after.nextRiseIsToday = true;
    Test.assertEqual(TwoSunsReadings.skyLine(after, true), "Sunrise ~06:41");
    return true;
}

// After sunset with no sunrise to announce: say the true reason, or at least the sunset.
(:test)
function skyLineAfterSunsetFallbacks(logger as Test.Logger) as Boolean {
    var none = readingsSky(TwoSunsConfig.SKY_AFTER_SUNSET);
    none.noNextRise = true;
    Test.assertEqual(TwoSunsReadings.skyLine(none, true), "No sunrise tomorrow");
    var set = readingsSky(TwoSunsConfig.SKY_AFTER_SUNSET);
    set.set = 18 * 60 + 47;
    Test.assertEqual(TwoSunsReadings.skyLine(set, true), "Sunset 18:47");
    Test.assertEqual(TwoSunsReadings.skyLine(readingsSky(TwoSunsConfig.SKY_AFTER_SUNSET), true), "No sun data");
    return true;
}

(:test)
function skyLineOtherStates(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsReadings.skyLine(readingsSky(TwoSunsConfig.SKY_MIDNIGHT_SUN), true), "Sun stays up today");
    Test.assertEqual(TwoSunsReadings.skyLine(readingsSky(TwoSunsConfig.SKY_POLAR_NIGHT), true), "Sun stays down today");
    Test.assertEqual(TwoSunsReadings.skyLine(readingsSky(TwoSunsConfig.SKY_NO_PLACE), true), "No place yet");
    Test.assertEqual(TwoSunsReadings.skyLine(readingsSky(TwoSunsConfig.SKY_NO_DATA), true), "No sun data");
    return true;
}

function readingsCurve(level as Number or Null, ageMinutes as Number) as TwoSunsBatteryCurve {
    var now = 1800000000;
    var values = [level] as Array<Numeric or Null>;
    var whens = [now - ageMinutes * TwoSunsConfig.SECONDS_PER_MINUTE] as Array<Number or Null>;
    return TwoSunsBattery.build(values, whens, now);
}

function readingsState(curve as TwoSunsBatteryCurve or Null, complication as Number or Null, showCurve as Boolean) as TwoSunsState {
    var settings = new TwoSunsSettings({"Curve" => showCurve ? 1 : 0} as Dictionary);
    var time = new TwoSunsLocalTime(2026, 9, 27, 15 * 60, 60, 0);
    var sky = readingsSky(TwoSunsConfig.SKY_NO_PLACE);
    return TwoSunsReadings.build(settings, time, true, sky, curve, complication, ["Sun 27 Sep", "27 Sep"] as Array<String>);
}

// Normal: the newest sample is the number and the curve is drawn; the curve setting hides only the curve.
(:test)
function batteryNormalAndCurveSetting(logger as Test.Logger) as Boolean {
    var shown = readingsState(readingsCurve(62, 3), 99, true);
    Test.assertEqual(shown.batteryText, "62");
    Test.assert(shown.curve != null);
    Test.assert(!shown.batteryStale);
    var withoutCurve = readingsState(readingsCurve(62, 3), null, false);
    Test.assertEqual(withoutCurve.batteryText, "62");
    Test.assert(withoutCurve.curve == null);
    return true;
}

(:test)
function batteryStaleKeepsTheNumberMuted(logger as Test.Logger) as Boolean {
    var state = readingsState(readingsCurve(40, 90), null, true);
    Test.assertEqual(state.batteryText, "40");
    Test.assert(state.batteryStale);
    return true;
}

// History exists but has no valid sample (not worn): "--", and Garmin's single number is NOT substituted.
(:test)
function batteryNotWornIsDashes(logger as Test.Logger) as Boolean {
    var state = readingsState(readingsCurve(127, 3), 55, true);
    Test.assertEqual(state.batteryText, "--");
    Test.assert(state.curve == null);
    return true;
}

// No history on this watch: Garmin's own number, if it is valid, else "--".
(:test)
function batteryFallsBackToTheComplication(logger as Test.Logger) as Boolean {
    Test.assertEqual(readingsState(null, 55, true).batteryText, "55");
    Test.assertEqual(readingsState(null, 127, true).batteryText, "--");
    Test.assertEqual(readingsState(null, null, true).batteryText, "--");
    Test.assert(readingsState(null, 55, true).curve == null);
    return true;
}

(:test)
function buildCarriesTheRest(logger as Test.Logger) as Boolean {
    var settings = new TwoSunsSettings({"Accent" => 1, "Orientation" => 1, "Golden" => 1, "Date" => 0} as Dictionary);
    var time = new TwoSunsLocalTime(2026, 9, 27, 15 * 60 + 5, 60, 0);
    var state = TwoSunsReadings.build(settings, time, false, readingsSky(TwoSunsConfig.SKY_NO_PLACE), null, null,
                                      ["Sun 27 Sep"] as Array<String>);
    Test.assertEqual(state.time, "3:05");
    Test.assertEqual(state.nowMinute, 15 * 60 + 5);
    Test.assertEqual(state.accent, TwoSunsPalette.ACCENTS[1]);
    Test.assertEqual(state.orientation, TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP);
    Test.assert(state.goldenArc);
    Test.assert(!state.showDate);
    Test.assertEqual(state.skyLine, "No place yet");
    Test.assertEqual(state.dateLines[0], "Sun 27 Sep");
    return true;
}

// Every sky state has a shorter wording that is never longer than the full one; sentences with no
// shorter form come back unchanged.
(:test)
function skyLineShortWordings(logger as Test.Logger) as Boolean {
    var day = readingsSky(TwoSunsConfig.SKY_DAY);
    day.lightLeft = 222;
    Test.assertEqual(TwoSunsReadings.skyText(day, true, 1), "3:42 light");
    var before = readingsSky(TwoSunsConfig.SKY_BEFORE_SUNRISE);
    before.nextRise = 6 * 60 + 41;
    Test.assertEqual(TwoSunsReadings.skyText(before, true, 1), "Rise 06:41");
    before.nextRiseIsToday = true;
    Test.assertEqual(TwoSunsReadings.skyText(before, true, 1), "Rise ~06:41");
    var none = readingsSky(TwoSunsConfig.SKY_AFTER_SUNSET);
    none.noNextRise = true;
    Test.assertEqual(TwoSunsReadings.skyText(none, true, 1), "No sunrise");
    var set = readingsSky(TwoSunsConfig.SKY_AFTER_SUNSET);
    set.set = 18 * 60 + 47;
    Test.assertEqual(TwoSunsReadings.skyText(set, true, 1), "Set 18:47");
    Test.assertEqual(TwoSunsReadings.skyText(readingsSky(TwoSunsConfig.SKY_MIDNIGHT_SUN), true, 1), "Sun stays up");
    Test.assertEqual(TwoSunsReadings.skyText(readingsSky(TwoSunsConfig.SKY_POLAR_NIGHT), true, 1), "Sun stays down");
    Test.assertEqual(TwoSunsReadings.skyText(readingsSky(TwoSunsConfig.SKY_NO_PLACE), true, 1), "No place yet");
    Test.assertEqual(TwoSunsReadings.skyText(readingsSky(TwoSunsConfig.SKY_NO_DATA), true, 1), "No sun data");
    Test.assertEqual(TwoSunsReadings.skyText(readingsSky(TwoSunsConfig.SKY_MIDNIGHT_SUN), true, 2), "No sunset");
    Test.assertEqual(TwoSunsReadings.skyText(readingsSky(TwoSunsConfig.SKY_POLAR_NIGHT), true, 2), "No sunrise");
    return true;
}

// The state offers the full sentence first and the short one after it, only when they differ.
(:test)
function stateListsSentencesLongestFirst(logger as Test.Logger) as Boolean {
    var day = readingsSky(TwoSunsConfig.SKY_DAY);
    day.lightLeft = 222;
    var state = TwoSunsReadings.build(new TwoSunsSettings({} as Dictionary), new TwoSunsLocalTime(2026, 9, 27, 900, 60, 0), true, day,
                                      null, null, ["Sun 27 Sep"] as Array<String>);
    Test.assertEqual(state.skyLines.size(), 2);
    Test.assertEqual(state.skyLines[0], "3:42 of daylight");
    Test.assertEqual(state.skyLines[1], "3:42 light");
    var same = TwoSunsReadings.build(new TwoSunsSettings({} as Dictionary), new TwoSunsLocalTime(2026, 9, 27, 900, 60, 0),
                                     true, readingsSky(TwoSunsConfig.SKY_NO_PLACE), null, null, ["Sun 27 Sep"] as Array<String>);
    Test.assertEqual(same.skyLines.size(), 1);
    // The polar sentences have three wordings, longest first.
    var polar = TwoSunsReadings.skyLines(readingsSky(TwoSunsConfig.SKY_POLAR_NIGHT), true);
    Test.assertEqual(polar.size(), 3);
    Test.assertEqual(polar[0], "Sun stays down today");
    Test.assertEqual(polar[2], "No sunrise");
    // The wordings never get longer.
    for (var i = 1; i < polar.size(); i++) {
        Test.assert(polar[i].length() < polar[i - 1].length());
    }
    return true;
}

// The glyph level follows the number the face shows: the newest sample, Garmin's own number when there is no
// history, and nothing when the value is "--".
(:test)
function batteryLevelFollowsTheNumber(logger as Test.Logger) as Boolean {
    Test.assertEqual(sunPresent(readingsState(readingsCurve(62, 3), 99, true).batteryLevel), 62);
    Test.assertEqual(sunPresent(readingsState(null, 55, true).batteryLevel), 55);
    Test.assert(readingsState(readingsCurve(127, 3), 55, true).batteryLevel == null);
    Test.assert(readingsState(null, 127, true).batteryLevel == null);
    Test.assert(readingsState(null, null, true).batteryLevel == null);
    return true;
}

// batteryAccentFor: dim(accent) below the low threshold, the accent itself at or above it, at the boundary too.
(:test)
function batteryAccentForDimsOnlyBelowTheThreshold(logger as Test.Logger) as Boolean {
    var accent = TwoSunsPalette.ACCENTS[0];
    var dim = TwoSunsPalette.dim(accent);
    Test.assertEqual(TwoSunsReadings.batteryAccentFor(0, accent), dim);
    Test.assertEqual(TwoSunsReadings.batteryAccentFor(TwoSunsConfig.BATTERY_LOW_THRESHOLD - 1, accent), dim);
    Test.assertEqual(TwoSunsReadings.batteryAccentFor(TwoSunsConfig.BATTERY_LOW_THRESHOLD, accent), accent);
    Test.assertEqual(TwoSunsReadings.batteryAccentFor(100, accent), accent);
    return true;
}

// The state carries the dimmed or full accent through build(): low from history, low from the Complication
// fallback, and never below the low colour just because the reading is stale (stale is muted separately by
// the view, batteryAccent still reflects the level underneath it).
(:test)
function batteryAccentFollowsTheLevel(logger as Test.Logger) as Boolean {
    var accent = TwoSunsPalette.ACCENTS[0];
    var dim = TwoSunsPalette.dim(accent);
    Test.assertEqual(readingsState(readingsCurve(62, 3), null, true).batteryAccent, accent);
    Test.assertEqual(readingsState(readingsCurve(20, 3), null, true).batteryAccent, dim);
    Test.assertEqual(readingsState(null, 62, true).batteryAccent, accent);
    Test.assertEqual(readingsState(null, 20, true).batteryAccent, dim);
    // Stale and low: still the dim colour underneath (the view draws muted grey instead, this is what it falls back to).
    Test.assertEqual(readingsState(readingsCurve(20, 90), null, true).batteryAccent, dim);
    // No valid reading at all: batteryAccent defaults to the plain accent, unused by the view ("--" never colours by level).
    Test.assertEqual(readingsState(readingsCurve(127, 3), null, true).batteryAccent, accent);
    Test.assertEqual(readingsState(null, null, true).batteryAccent, accent);
    return true;
}
