import Toybox.Lang;
import Toybox.Test;

// A reordered tier chain would silently swap which moment the user gets
// (ADR-041): the daily mission must keep its toast even when the same save
// crosses a rank.
(:test)
function saveFeedbackTiersKeepMissionAboveRank(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetSaveFeedback.tierFor(30, 70, 100, false, true, 4, 5, 100), :mission);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(30, 70, 100, false, false, 4, 5, 100), :rank);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(30, 70, 100, false, false, 4, 4, 100), :exercise);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(5, 10, 15, false, false, 4, 4, 100), :saved);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(-5, 15, 10, false, false, 4, 4, 100), :removed);
    // A user-set goal moves the exercise tier with it.
    Test.assertEqual(HeroSetSaveFeedback.tierFor(10, 20, 30, false, false, 4, 4, 30), :exercise);
    return true;
}
