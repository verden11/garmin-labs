import Toybox.Lang;
import Toybox.Test;

(:test)
function progressStartsAtZero(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.progress(0, 100), 0);
    return true;
}

(:test)
function progressIsPercentage(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.progress(50, 100), 50);
    return true;
}

(:test)
function progressCapsAtGoal(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.progress(125, 100), 100);
    return true;
}

(:test)
function negativeCorrectionsDoNotAwardXp(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.xpForReps(-1), 0);
    Test.assertEqual(HeroSetProgress.xpForReps(5), 10);
    return true;
}

(:test)
function rankAdvancesEveryHundredXp(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.rankForXp(0), 1);
    Test.assertEqual(HeroSetProgress.rankForXp(99), 1);
    Test.assertEqual(HeroSetProgress.rankForXp(100), 2);
    return true;
}

(:test)
function missionNeedsAllThreeGoals(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetProgress.missionComplete(100, 100, 99));
    Test.assert(HeroSetProgress.missionComplete(100, 100, 100));
    return true;
}

// Streak tests use local calendar day keys (yyyy*10000+mm*100+dd). Epoch
// subtraction is gone; DST days differ by 23h/25h yet must still extend.

(:test)
function sameDayDoesNotDoubleStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20260911, 20260911, 4), 4);
    return true;
}

(:test)
function consecutiveDayIncrementsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20260911, 20260912, 4), 5);
    return true;
}

(:test)
function missedDayResetsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20260910, 20260912, 4), 1);
    return true;
}

(:test)
function firstCompletionStartsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(null, 20260912, 0), 1);
    return true;
}

(:test)
function dstSpringForwardExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20260307, 20260308, 4), 5);
    return true;
}

(:test)
function dstFallBackExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20261101, 20261102, 4), 5);
    return true;
}

(:test)
function monthRollExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20260930, 20261001, 4), 5);
    return true;
}

(:test)
function yearRollExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetProgress.nextStreak(20251231, 20260101, 4), 5);
    return true;
}
