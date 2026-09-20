import Toybox.Lang;
import Toybox.Test;

// The value HeroFace parses (ADR-044). Field order and meaning are a
// contract with another app: changing them silently breaks it.

(:test)
function complicationValueCarriesTodaysProgress(logger as Test.Logger) as Lang.Boolean {
    var state = new HeroSetDashboardState(37, 52, 100, HeroSetRules.rankThreshold(4), 4, 12, false, 100);
    var value = HeroSetComplicationPublisher.valueFor(state, 20260920, 20260919);
    // Rank 4 exactly at its threshold: 0% into the rank.
    Test.assertEqual(value, "1|20260920|37|52|100|4|0|12|20260919|100");
    return true;
}

(:test)
function complicationValueHandlesAFirstRun(logger as Test.Logger) as Lang.Boolean {
    var state = new HeroSetDashboardState(0, 0, 0, 0, 1, 0, false, 100);
    // Never completed a day yet: the day field is 0, which no day key matches,
    // so a subscriber reads the streak as broken.
    Test.assertEqual(HeroSetComplicationPublisher.valueFor(state, 20260920, null), "1|20260920|0|0|0|1|0|0|0|100");
    return true;
}

(:test)
function complicationValueReportsProgressIntoTheRank(logger as Test.Logger) as Lang.Boolean {
    var rank = 3;
    var xp = HeroSetRules.rankThreshold(rank) + HeroSetRules.rankCost(rank) / 2;
    var state = new HeroSetDashboardState(0, 0, 0, xp, rank, 0, false, 250);
    var value = HeroSetComplicationPublisher.valueFor(state, 20260920, 20260901);
    // Half way through the rank, so the face's ring shows 50%.
    Test.assertEqual(value, "1|20260920|0|0|0|3|50|0|20260901|250");
    return true;
}
