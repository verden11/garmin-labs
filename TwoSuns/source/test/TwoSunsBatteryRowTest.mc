import Toybox.Lang;
import Toybox.Test;

// The watch battery row (docs/decisions.md ADR-023, Watch battery row). Pro only: Free has no such row.
(:test, :pro)
function batteryRowTextIsAWholePercent(logger as Test.Logger) as Boolean {
    Test.assertEqual(TwoSunsBatteryRow.text(87), "87%");
    Test.assertEqual(TwoSunsBatteryRow.text(0), "0%");
    Test.assertEqual(TwoSunsBatteryRow.text(100), "100%");
    return true;
}

// The row is only drawn where its ink fits the round chord; a row above the top of the display, or in a chord with no
// width, is not. Nothing else moves for it.
(:test, :pro)
function batteryRowIsNotDrawnWhereTheChordHasNoRoom(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    Test.assert(!TwoSunsBatteryRow.fits(dc, layout, -1, 100));   // above the display
    Test.assert(!TwoSunsBatteryRow.fits(dc, layout, layout.centerY() - layout.contentRadius() - 40, 100));   // outside the content circle
    return true;
}

// Every awake state carries the widest battery text; the frame draws the row only when it fits, and the screen-fit test
// then checks its box against the content circle and every other box. Asleep (always-on) there is no row.
(:test, :pro)
function batteryRowIsNotInTheAlwaysOnFrame(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var state = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true);
    Test.assert(state.watchBattery == 100);
    var asleep = new TwoSunsFrame(dc, new TwoSunsLayout(dc), state, true);
    Test.assert(!asleep.showBattery);
    return true;
}

// The row never changes where the other rows sit: the same state without a battery gives the same rows.
(:test, :pro)
function batteryRowDoesNotMoveTheStack(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() != null) {
        return true;   // a rectangle's time grows into the room the row would take when Battery is off (ADR-028)
    }
    var with = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true);
    var without = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true);
    without.watchBattery = null;
    var a = new TwoSunsFrame(dc, layout, with, false);
    var b = new TwoSunsFrame(dc, layout, without, false);
    Test.assertEqual(a.rows.timeTop, b.rows.timeTop);
    Test.assertEqual(a.rows.bandTop, b.rows.bandTop);
    Test.assert(!b.showBattery);
    return true;
}
