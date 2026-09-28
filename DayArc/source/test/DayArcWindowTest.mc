import Toybox.Lang;
import Toybox.Test;

// Boundary cases for every edge the window logic has (docs/decisions.md ADR-004, ADR-010).
(:test)
function windowForCoversEveryBoundary(logger as Test.Logger) as Boolean {
    Test.assertEqual(DayArcWindow.windowFor(4, 59), DayArcConfig.WINDOW_NIGHT);
    Test.assertEqual(DayArcWindow.windowFor(5, 0), DayArcConfig.WINDOW_MORNING);
    Test.assertEqual(DayArcWindow.windowFor(9, 29), DayArcConfig.WINDOW_MORNING);
    Test.assertEqual(DayArcWindow.windowFor(9, 30), DayArcConfig.WINDOW_MIDDAY);
    Test.assertEqual(DayArcWindow.windowFor(16, 59), DayArcConfig.WINDOW_MIDDAY);
    Test.assertEqual(DayArcWindow.windowFor(17, 0), DayArcConfig.WINDOW_EVENING);
    Test.assertEqual(DayArcWindow.windowFor(22, 59), DayArcConfig.WINDOW_EVENING);
    Test.assertEqual(DayArcWindow.windowFor(23, 0), DayArcConfig.WINDOW_NIGHT);
    Test.assertEqual(DayArcWindow.windowFor(0, 0), DayArcConfig.WINDOW_NIGHT);
    Test.assertEqual(DayArcWindow.windowFor(23, 59), DayArcConfig.WINDOW_NIGHT);
    return true;
}

// The window-progress arc's fraction-through-window calc (ADR-013). Midpoints are chosen so the
// expected fraction is exactly 0.5 in binary floating point, avoiding float-precision brittleness;
// the window-start cases check the actual boundary this function's own division depends on.
(:test)
function progressForCoversEveryBoundary(logger as Test.Logger) as Boolean {
    // Morning: 5:00-9:30, 270 minutes.
    Test.assertEqual(DayArcWindow.progressFor(5, 0), 0.0);
    Test.assertEqual(DayArcWindow.progressFor(7, 15), 0.5); // 135 of 270 minutes in
    if (DayArcWindow.progressFor(9, 29) <= 0.9 or DayArcWindow.progressFor(9, 29) >= 1.0) {
        return false;
    }

    // Midday: 9:30-17:00, 450 minutes.
    Test.assertEqual(DayArcWindow.progressFor(9, 30), 0.0);
    Test.assertEqual(DayArcWindow.progressFor(13, 15), 0.5); // 225 of 450 minutes in

    // Evening: 17:00-23:00, 360 minutes.
    Test.assertEqual(DayArcWindow.progressFor(17, 0), 0.0);
    Test.assertEqual(DayArcWindow.progressFor(20, 0), 0.5); // 180 of 360 minutes in

    // Night: no arc is ever drawn for this window (DayArcDraw guards on window, not on this
    // return value) — 0.0 at both the boundary and mid-window, never a divide-by-zero.
    Test.assertEqual(DayArcWindow.progressFor(23, 0), 0.0);
    Test.assertEqual(DayArcWindow.progressFor(2, 30), 0.0);
    return true;
}
