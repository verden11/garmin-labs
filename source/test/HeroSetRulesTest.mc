import Toybox.Lang;
import Toybox.Test;

(:test)
function negativeCorrectionsDoNotAwardXp(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.xpForReps(-1), 0);
    Test.assertEqual(HeroSetRules.xpForReps(5), 10);
    return true;
}

// Rank curve (ADR-031): rank r -> r+1 costs 300 * min(r, 14) XP.

(:test)
function rankCostGrowsThenCaps(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.rankCost(0), 300);
    Test.assertEqual(HeroSetRules.rankCost(1), 300);
    Test.assertEqual(HeroSetRules.rankCost(13), 3900);
    Test.assertEqual(HeroSetRules.rankCost(14), 4200);
    Test.assertEqual(HeroSetRules.rankCost(15), 4200);
    Test.assertEqual(HeroSetRules.rankCost(100), 4200);
    return true;
}

(:test)
function rankThresholdsFollowTheCurve(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.rankThreshold(-3), 0);
    Test.assertEqual(HeroSetRules.rankThreshold(1), 0);
    Test.assertEqual(HeroSetRules.rankThreshold(2), 300);
    Test.assertEqual(HeroSetRules.rankThreshold(3), 900);
    Test.assertEqual(HeroSetRules.rankThreshold(10), 13500);
    Test.assertEqual(HeroSetRules.rankThreshold(15), 31500);
    Test.assertEqual(HeroSetRules.rankThreshold(16), 35700);
    Test.assertEqual(HeroSetRules.rankThreshold(60), 220500);
    return true;
}

(:test)
function rankForXpUsesTheCurve(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.rankForXp(-5), 1);
    Test.assertEqual(HeroSetRules.rankForXp(0), 1);
    Test.assertEqual(HeroSetRules.rankForXp(299), 1);
    Test.assertEqual(HeroSetRules.rankForXp(300), 2);
    Test.assertEqual(HeroSetRules.rankForXp(899), 2);
    Test.assertEqual(HeroSetRules.rankForXp(900), 3);
    Test.assertEqual(HeroSetRules.rankForXp(13499), 9);
    Test.assertEqual(HeroSetRules.rankForXp(31499), 14);
    Test.assertEqual(HeroSetRules.rankForXp(31500), 15);
    Test.assertEqual(HeroSetRules.rankForXp(220500), 60);
    return true;
}

// A full mission day (600 XP) is worth one rank at the start, and a week of
// them lands at rank 5, not the old 42.
(:test)
function fullMissionDaysNoLongerPrintRanks(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.rankForXp(600), 2);
    Test.assertEqual(HeroSetRules.rankForXp(600 * 7), 5);
    return true;
}

(:test)
function rankForXpInvertsEveryThreshold(logger as Test.Logger) as Lang.Boolean {
    for (var rank = 2; rank <= 40; rank++) {
        Test.assertEqual(HeroSetRules.rankForXp(HeroSetRules.rankThreshold(rank)), rank);
        Test.assertEqual(HeroSetRules.rankForXp(HeroSetRules.rankThreshold(rank) - 1), rank - 1);
    }
    return true;
}

(:test)
function xpIntoRankRestartsEachRank(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.xpIntoRank(-5), 0);
    Test.assertEqual(HeroSetRules.xpIntoRank(0), 0);
    Test.assertEqual(HeroSetRules.xpIntoRank(299), 299);
    Test.assertEqual(HeroSetRules.xpIntoRank(300), 0);
    Test.assertEqual(HeroSetRules.xpIntoRank(1000), 100);
    return true;
}

(:test)
function xpToNextRankCountsDown(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.xpToNextRank(-5), 300);
    Test.assertEqual(HeroSetRules.xpToNextRank(0), 300);
    Test.assertEqual(HeroSetRules.xpToNextRank(299), 1);
    Test.assertEqual(HeroSetRules.xpToNextRank(300), 600);
    Test.assertEqual(HeroSetRules.xpToNextRank(31500), 4200);
    return true;
}

(:test)
function clampDeltaNeverDropsBelowStoredCount(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.clampDelta(10, -15), -10);
    Test.assertEqual(HeroSetRules.clampDelta(10, -3), -3);
    Test.assertEqual(HeroSetRules.clampDelta(10, 5), 5);
    Test.assertEqual(HeroSetRules.clampDelta(0, -1), 0);
    return true;
}

(:test)
function crossedGoalOnlyOnTransition(logger as Test.Logger) as Lang.Boolean {
    Test.assert(HeroSetRules.crossedGoal(99, 100));
    Test.assert(HeroSetRules.crossedGoal(0, 150));
    Test.assert(!HeroSetRules.crossedGoal(100, 101));
    Test.assert(!HeroSetRules.crossedGoal(50, 99));
    Test.assert(!HeroSetRules.crossedGoal(120, 90));
    return true;
}

(:test)
function missionNeedsAllThreeGoals(logger as Test.Logger) as Lang.Boolean {
    Test.assert(!HeroSetRules.missionComplete(100, 100, 99));
    Test.assert(HeroSetRules.missionComplete(100, 100, 100));
    return true;
}

// Streak tests use local calendar day keys (yyyy*10000+mm*100+dd). Epoch
// subtraction is gone; DST days differ by 23h/25h yet must still extend.

(:test)
function sameDayDoesNotDoubleStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20260911, 20260911, 4), 4);
    return true;
}

(:test)
function consecutiveDayIncrementsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20260911, 20260912, 4), 5);
    return true;
}

(:test)
function missedDayResetsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20260910, 20260912, 4), 1);
    return true;
}

(:test)
function firstCompletionStartsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(null, 20260912, 0), 1);
    return true;
}

(:test)
function dstSpringForwardExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20260307, 20260308, 4), 5);
    return true;
}

(:test)
function dstFallBackExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20261101, 20261102, 4), 5);
    return true;
}

(:test)
function monthRollExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20260930, 20261001, 4), 5);
    return true;
}

(:test)
function yearRollExtendsStreak(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.nextStreak(20251231, 20260101, 4), 5);
    return true;
}

// The stored streak is only rewritten at the next completion; the active
// streak is what the dashboard may honestly show.

(:test)
function activeStreakNeedsACompletion(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.activeStreak(null, 20260912, 4), 0);
    return true;
}

(:test)
function activeStreakSurvivesTodayAndYesterday(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.activeStreak(20260912, 20260912, 4), 4);
    Test.assertEqual(HeroSetRules.activeStreak(20260911, 20260912, 4), 4);
    Test.assertEqual(HeroSetRules.activeStreak(20261231, 20270101, 4), 4);
    return true;
}

(:test)
function activeStreakBreaksAfterAMissedDay(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetRules.activeStreak(20260910, 20260912, 4), 0);
    return true;
}
