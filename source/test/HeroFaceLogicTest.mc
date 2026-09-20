import Toybox.Lang;
import Toybox.Test;

// Pure logic: streak arithmetic, HeroSet's contract, the day-score ring and
// time wording. No device needed.

(:test)
function streakCountsConsecutiveDays(logger as Test.Logger) as Boolean {
    var met = {100 => true, 99 => true, 98 => false, 97 => true} as Dictionary<Number, Boolean>;
    Test.assertEqual(HeroFaceStreak.throughYesterday(met, 100, null), 2);
    Test.assertEqual(HeroFaceStreak.throughYesterday({} as Dictionary<Number, Boolean>, 100, null), 0);
    Test.assertEqual(HeroFaceStreak.throughYesterday({100 => false} as Dictionary<Number, Boolean>, 100, null), 0);
    return true;
}

// The watch only remembers a week, so a stored streak that ends inside (or
// right before) the remembered run keeps counting past it.
(:test)
function streakExtendsPastStoredHistory(logger as Test.Logger) as Boolean {
    var met = {100 => true, 99 => true, 98 => true} as Dictionary<Number, Boolean>;
    // Stored run ended the day before the oldest remembered day: 40 + 3.
    Test.assertEqual(HeroFaceStreak.throughYesterday(met, 100, [97, 40] as Array<Number>), 43);
    // Stored run ends inside the remembered days: 40 + 1 day since.
    Test.assertEqual(HeroFaceStreak.throughYesterday(met, 100, [99, 40] as Array<Number>), 41);
    // Stored run ended before a missed day: only the remembered run counts.
    var broken = {100 => true, 99 => false, 98 => true} as Dictionary<Number, Boolean>;
    Test.assertEqual(HeroFaceStreak.throughYesterday(broken, 100, [98, 40] as Array<Number>), 1);
    // A stale record from an older day never inflates today's streak.
    Test.assertEqual(HeroFaceStreak.throughYesterday(met, 100, [80, 40] as Array<Number>), 3);
    return true;
}

(:test)
function contractReadsHeroSetProgress(logger as Test.Logger) as Boolean {
    var value = HeroFaceContract.parse("1|20260920|37|52|100|4|63|12|20260919", 20260920, 20260919);
    Test.assertEqual(value[HeroFaceContract.PUSH], 37);
    Test.assertEqual(value[HeroFaceContract.SQUAT], 100);
    Test.assertEqual(value[HeroFaceContract.RANK], 4);
    Test.assertEqual(value[HeroFaceContract.RANK_PERCENT], 63);
    Test.assertEqual(value[HeroFaceContract.STREAK], 12);
    Test.assertEqual(value[HeroFaceContract.GOAL], HeroFaceConfig.HEROSET_GOAL);
    return true;
}

// HeroSet publishes the user's own daily goal as a tenth field (its ADR-045).
// An older HeroSet omits it, and then the face falls back to a hundred.
(:test)
function contractReadsTheUsersDailyGoal(logger as Test.Logger) as Boolean {
    var custom = HeroFaceContract.parse("1|20260920|20|0|0|4|63|12|20260919|50", 20260920, 20260919);
    Test.assertEqual(custom[HeroFaceContract.GOAL], 50);
    Test.assertEqual(custom[HeroFaceContract.PUSH], 20);
    var older = HeroFaceContract.parse("1|20260920|20|0|0|4|63|12|20260919", 20260920, 20260919);
    Test.assertEqual(older[HeroFaceContract.GOAL], 100);
    // A zero or missing goal is never divided by.
    var zero = HeroFaceContract.parse("1|20260920|20|0|0|4|63|12|20260919|0", 20260920, 20260919);
    Test.assertEqual(zero[HeroFaceContract.GOAL], 100);
    return true;
}

// HeroSet only publishes while it runs, so the day keys decide what is still
// true: yesterday's counts are gone, and a streak with no day since the day
// before yesterday is broken.
(:test)
function contractExpiresYesterdaysProgress(logger as Test.Logger) as Boolean {
    var stale = HeroFaceContract.parse("1|20260919|37|52|100|4|63|12|20260918", 20260920, 20260919);
    Test.assertEqual(stale[HeroFaceContract.PUSH], 0);
    Test.assertEqual(stale[HeroFaceContract.RANK], 4);
    Test.assertEqual(stale[HeroFaceContract.STREAK], 0);
    var kept = HeroFaceContract.parse("1|20260919|37|52|100|4|63|12|20260919", 20260920, 20260919);
    Test.assertEqual(kept[HeroFaceContract.STREAK], 12);
    return true;
}

(:test)
function contractRejectsAnythingItCannotTrust(logger as Test.Logger) as Boolean {
    Test.assert(HeroFaceContract.parse(null, 20260920, 20260919) == null);
    Test.assert(HeroFaceContract.parse("", 20260920, 20260919) == null);
    // Unknown version.
    Test.assert(HeroFaceContract.parse("2|20260920|37|52|100|4|63|12|20260919", 20260920, 20260919) == null);
    // Too few fields, and a non-numeric field.
    Test.assert(HeroFaceContract.parse("1|20260920|37|52", 20260920, 20260919) == null);
    Test.assert(HeroFaceContract.parse("1|20260920|x|52|100|4|63|12|20260919", 20260920, 20260919) == null);
    // A truncated publish ends in an empty field, which is not a zero.
    Test.assert(HeroFaceContract.parse("1|20260920|37|52|100|4|63|12|", 20260920, 20260919) == null);
    // Extra fields are a future version's addition, not an error.
    var extended = HeroFaceContract.parse("1|20260920|1|2|3|4|63|5|20260920|999|extra", 20260920, 20260919);
    Test.assertEqual(extended[HeroFaceContract.SIT], 2);
    return true;
}

(:test)
function ringAveragesTheDaysMissions(logger as Test.Logger) as Boolean {
    var metrics = [
        new HeroFaceMetric(HeroFaceConfig.STEPS, 5000, 10000),
        new HeroFaceMetric(HeroFaceConfig.FLOORS, 10, 10),
        // No goal: counted by neither the average nor the bar.
        new HeroFaceMetric(HeroFaceConfig.CALORIES, 2000, 0)
    ] as Array<HeroFaceMetric>;
    Test.assertEqual(HeroFaceReadings.dayScore(metrics), 750);
    Test.assertEqual(HeroFaceReadings.dayScore([] as Array<HeroFaceMetric>), 0);
    return true;
}

// The move bar counts down: the watch reports inactivity, the bar shows
// activity left, and it never reads as a finished goal.
(:test)
function moveBarInvertsAndNeverCompletes(logger as Test.Logger) as Boolean {
    var fresh = new HeroFaceMetric(HeroFaceConfig.MOVE, 0, 5);
    Test.assertEqual(fresh.permille(), 1000);
    Test.assert(!fresh.isDone());
    Test.assert(!fresh.isAlert());
    var stale = new HeroFaceMetric(HeroFaceConfig.MOVE, 5, 5);
    Test.assertEqual(stale.permille(), 0);
    Test.assert(stale.isAlert());
    return true;
}

(:test)
function metricFillsClampAtTheGoal(logger as Test.Logger) as Boolean {
    var over = new HeroFaceMetric(HeroFaceConfig.STEPS, 21000, 10000);
    Test.assertEqual(over.permille(), 1000);
    Test.assert(over.isDone());
    var none = new HeroFaceMetric(HeroFaceConfig.CALORIES, 2000, 0);
    Test.assert(!none.hasBar());
    Test.assertEqual(none.permille(), 0);
    Test.assert(!none.isDone());
    return true;
}

(:test)
function timeFollowsTheWatchsClockSetting(logger as Test.Logger) as Boolean {
    Test.assertEqual(HeroFaceReadings.timeText(7, 5, true), "07:05");
    Test.assertEqual(HeroFaceReadings.timeText(7, 5, false), "7:05");
    Test.assertEqual(HeroFaceReadings.timeText(0, 5, false), "12:05");
    Test.assertEqual(HeroFaceReadings.timeText(13, 5, false), "1:05");
    Test.assertEqual(HeroFaceReadings.timeText(0, 5, true), "00:05");
    return true;
}

(:test)
function ringSweepStaysInsideTheArc(logger as Test.Logger) as Boolean {
    Test.assertEqual(HeroFaceLayout.ringSweepFor(0), 0);
    Test.assertEqual(HeroFaceLayout.ringSweepFor(1000), HeroFaceLayout.RING_SWEEP_DEG);
    Test.assertEqual(HeroFaceLayout.ringSweepFor(2000), HeroFaceLayout.RING_SWEEP_DEG);
    // Any progress at all has to be visible.
    Test.assertEqual(HeroFaceLayout.ringSweepFor(1), 1);
    Test.assertEqual(HeroFaceLayout.ringSweepFor(500), HeroFaceLayout.RING_SWEEP_DEG / 2);
    return true;
}
