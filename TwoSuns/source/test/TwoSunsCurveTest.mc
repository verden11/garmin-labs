import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Test;

// Buckets 0..95 as a curve: `levels` at the given indexes, nothing elsewhere.
function curveWith(indexes as Array<Number>, levels as Array<Number>) as TwoSunsBatteryCurve {
    var curve = new TwoSunsBatteryCurve();
    for (var i = 0; i < indexes.size(); i++) {
        curve.buckets[indexes[i]] = levels[i];
    }
    return curve;
}

(:test)
function curvePlanMapsBucketsToPoints(logger as Test.Logger) as Boolean {
    var plan = TwoSunsCurvePlan.build(curveWith([0, 95, 47] as Array<Number>, [0, 100, 50] as Array<Number>), 10, 20, 96, 51);
    Test.assertEqual(plan.xs[0], 10);
    Test.assertEqual(plan.xs[95], 10 + 95);         // the last bucket lands on the right edge (width 96 -> 95 px span)
    Test.assertEqual(plan.bottom, 20 + 51 - 1);
    Test.assertEqual(sunPresent(plan.ys[0]), 70);    // level 0 sits on the baseline
    Test.assertEqual(sunPresent(plan.ys[95]), 20);   // level 100 sits at the top
    Test.assertEqual(sunPresent(plan.ys[47]), 45);   // level 50 halfway
    Test.assertEqual(plan.lastIndex, 95);
    return true;
}

// A bucket with no sample has no point, and the newest bucket that has one is the last index.
(:test)
function curvePlanKeepsGaps(logger as Test.Logger) as Boolean {
    var plan = TwoSunsCurvePlan.build(curveWith([10, 11, 40] as Array<Number>, [30, 40, 60] as Array<Number>), 0, 0, 96, 101);
    Test.assert(plan.ys[9] == null);
    Test.assert(plan.ys[12] == null);
    Test.assert(plan.ys[10] != null && plan.ys[11] != null);
    Test.assertEqual(plan.lastIndex, 40);
    var empty = TwoSunsCurvePlan.build(new TwoSunsBatteryCurve(), 0, 0, 96, 50);
    Test.assertEqual(empty.lastIndex, -1);
    return true;
}

// Every x is inside the box and never goes backwards; a fill cell reaches the next bucket and no further.
(:test)
function curvePlanStaysInsideItsBox(logger as Test.Logger) as Boolean {
    var widths = [40, 96, 97, 130, 200] as Array<Number>;
    for (var w = 0; w < widths.size(); w++) {
        var plan = TwoSunsCurvePlan.build(curveWith([0, 50, 95] as Array<Number>, [10, 90, 50] as Array<Number>), 5, 5, widths[w], 40);
        for (var i = 0; i < plan.xs.size(); i++) {
            Test.assertMessage(plan.xs[i] >= 5 && plan.xs[i] <= 5 + widths[w] - 1, "width " + widths[w] + " x[" + i + "]=" + plan.xs[i]);
            if (i > 0) {
                Test.assert(plan.xs[i] >= plan.xs[i - 1]);
            }
            Test.assert(plan.cellWidth(i) >= 1);
            if (i < plan.xs.size() - 1) {
                Test.assert(plan.xs[i] + plan.cellWidth(i) <= plan.xs[i + 1] + 1);   // a fill cell never runs past the next bucket's column
            }
        }
    }
    return true;
}

// Out-of-range levels (a corrupt sample that reached a bucket) are clamped into the box, not drawn outside it.
(:test)
function curvePlanClampsLevels(logger as Test.Logger) as Boolean {
    var plan = TwoSunsCurvePlan.build(curveWith([1, 2] as Array<Number>, [-20, 250] as Array<Number>), 0, 10, 96, 41);
    Test.assertEqual(sunPresent(plan.ys[1]), 50);   // clamped to 0: the baseline
    Test.assertEqual(sunPresent(plan.ys[2]), 10);   // clamped to 100: the top
    return true;
}

// The band: glyph, value and curve as one block, centred, inside the chord; a narrow chord loses the curve, never the value.
(:test)
function bandKeepsTheValueAndDropsTheCurveWhenNarrow(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var frame = new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(80, 3), true), false);
    var valueWidth = dc.getTextWidthInPixels("100", frame.valueFont);
    var height = dc.getFontHeight(frame.valueFont);
    var wide = TwoSunsBand.plan(layout, frame.rows.bandTop, frame.bandHeight, valueWidth, height, true);
    var none = TwoSunsBand.plan(layout, frame.rows.bandTop, frame.bandHeight, valueWidth, height, false);
    Test.assert(!none.hasCurve);
    Test.assertEqual(none.curveWidth, 0);
    if (wide.hasCurve) {
        Test.assert(wide.curveLeft > wide.valueCenterX + valueWidth / 2);   // the curve is right of the value
        Test.assert(wide.glyphLeft + wide.glyphWidth <= wide.valueCenterX - valueWidth / 2);   // the glyph is left of it
        Test.assert(wide.curveWidth >= layout.capFor(TwoSunsConfig.CURVE_MIN_WIDTH_PERMILLE));
    }
    // A chord too narrow for the glyph, a 100 px value and a curve: the curve goes, the value's place stays.
    var tiny = Graphics.createBufferedBitmap({:width => 120, :height => 120}).get() as Graphics.BufferedBitmap;
    var tinyLayout = new TwoSunsLayout(tiny.getDc());
    var squeezed = TwoSunsBand.plan(tinyLayout, 40, 30, 100, height, true);
    Test.assert(!squeezed.hasCurve);
    return true;
}

// The glyph and curve are drawn on this device's real resolution for a fresh curve, a stale one, and none, without an error.
(:test)
function curveAndGlyphDrawWithoutError(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var view = new TwoSunsView();
    var curves = [TwoSunsTestStates.curve(100, 3), TwoSunsTestStates.curve(0, 90), null] as Array<TwoSunsBatteryCurve or Null>;
    for (var i = 0; i < curves.size(); i++) {
        view.drawState(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], curves[i], true));
    }
    return true;
}
