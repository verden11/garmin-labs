import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

// The date row's words: Pro reads two lines (weekday with date, and date alone), Free has no date row.
(:pro, :debug)
function expectedDateLineCount() as Number {
    return 2;
}

(:free, :debug)
function expectedDateLineCount() as Number {
    return 0;
}

// The real read on the simulator: it must give a complete state (words in every field), whatever the
// simulator's canned data is. This proves the calls are wired and guarded, not that the data is right:
// the simulator has no GPS, canned weather, canned sun values and synthetic Body Battery.
(:test)
function sourcesReadGivesACompleteState(logger as Test.Logger) as Boolean {
    var state = new TwoSunsSources().read(TwoSunsSettings.load());
    logger.debug("time " + state.time + " bb " + state.batteryText + " sky " + state.skyLine);
    Test.assert(state.time.length() >= 4);
    Test.assert(state.batteryText.length() >= 1);
    Test.assert(state.skyLine.length() >= 1);
    Test.assertEqual(state.dateLines.size(), expectedDateLineCount());
    return true;
}

// Two reads in one run give the same words (it checks consistency, not that the caches are used: the caches
// are an efficiency, and nothing here can tell a cache hit from a fresh read).
(:test)
function secondReadIsTheSame(logger as Test.Logger) as Boolean {
    var sources = new TwoSunsSources();
    var first = sources.read(TwoSunsSettings.load());
    var second = sources.read(TwoSunsSettings.load());
    Test.assertEqual(first.skyLine, second.skyLine);
    assertSameBattery(first, second);
    return true;
}

// Pro reads Body Battery from the history, which holds still between two reads. Free reads Garmin's live
// complication, which the simulator makes up afresh on every read (96 then 75, seen 2026-10-01), so Free
// can only check that both reads gave a value.
(:pro, :debug)
function assertSameBattery(first as TwoSunsState, second as TwoSunsState) as Void {
    Test.assertEqual(first.batteryText, second.batteryText);
}

(:free, :debug)
function assertSameBattery(first as TwoSunsState, second as TwoSunsState) as Void {
    Test.assert(first.batteryText.length() >= 1 && second.batteryText.length() >= 1);
}
