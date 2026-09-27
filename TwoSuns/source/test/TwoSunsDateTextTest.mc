import Toybox.Lang;
import Toybox.Test;

(:test)
function dateLinesDayFirst(logger as Test.Logger) as Boolean {
    var lines = TwoSunsDateText.lines("Sat", 26, "Sep", false);
    Test.assertEqual(lines.size(), 2);
    Test.assertEqual(lines[0], "Sat 26 Sep");
    Test.assertEqual(lines[1], "26 Sep");
    return true;
}

(:test)
function dateLinesMonthFirst(logger as Test.Logger) as Boolean {
    var lines = TwoSunsDateText.lines("Sat", 26, "Sep", true);
    Test.assertEqual(lines[0], "Sat Sep 26");
    Test.assertEqual(lines[1], "Sep 26");
    return true;
}

// Month first only for English with statute units.
(:test)
function monthFirstOnlyForUsStyle(logger as Test.Logger) as Boolean {
    Test.assert(TwoSunsDateText.monthFirst(true, true));
    Test.assert(!TwoSunsDateText.monthFirst(true, false));
    Test.assert(!TwoSunsDateText.monthFirst(false, true));
    return true;
}
