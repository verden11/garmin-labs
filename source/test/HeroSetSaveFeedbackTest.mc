import Toybox.Lang;
import Toybox.Test;

// A reordered tier chain would silently swap which moment the user gets
// (ADR-041): the daily mission must keep its toast even when the same save
// crosses a rank.
(:test)
function saveFeedbackTiersKeepMissionAboveRank(logger as Test.Logger) as Lang.Boolean {
    Test.assertEqual(HeroSetSaveFeedback.tierFor(30, 70, 100, false, true, 4, 5), :mission);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(30, 70, 100, false, false, 4, 5), :rank);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(30, 70, 100, false, false, 4, 4), :exercise);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(5, 10, 15, false, false, 4, 4), :saved);
    Test.assertEqual(HeroSetSaveFeedback.tierFor(-5, 15, 10, false, false, 4, 4), :removed);
    return true;
}
