import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

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
    Test.assert(state.dateLines.size() == 2);
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
    Test.assertEqual(first.batteryText, second.batteryText);
    return true;
}
