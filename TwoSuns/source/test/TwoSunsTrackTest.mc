import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Test;

// The rectangle track (docs/decisions.md ADR-028): built for both rectangle sizes on any device, as the layout builds it.
// The glass corner radii were measured off the alpha mask of the SDK's device images (venusq2.png, venux1 device.png).
(:debug)
const TRACK_SIZES = [[320, 360, 10], [448, 486, 68]] as Array<Array<Number>>;   // width, height, glass corner radius
(:debug)
const RING_WIDTH_PERMILLE_TEST = 25;   // TwoSunsLayout's ring width, of D

(:debug)
function testTrack(size as Array<Number>) as TwoSunsTrack {
    var d = size[0] < size[1] ? size[0] : size[1];
    return new TwoSunsTrack(size[0], size[1], TwoSunsLayout.trackInsetFor(d), d * TwoSunsTrack.CORNER_PERMILLE / TwoSunsConfig.PERMILLE);
}

(:debug)
function nearPoint(at as [Float, Float], x as Number, y as Number) as Boolean {
    return (at[0] - x).abs() <= 1 && (at[1] - y).abs() <= 1;
}

// Noon at top centre, 18:00 a quarter of the length on (the right side's middle), midnight at bottom centre, 06:00 on the
// left; midnight at the top when the setting says so; every hour is the same length.
(:test)
function trackMapsATimeToTheRightPoint(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TRACK_SIZES.size(); i++) {
        var w = TRACK_SIZES[i][0];
        var h = TRACK_SIZES[i][1];
        var track = testTrack(TRACK_SIZES[i]);
        var t = (track.pointAt(0.0, 0.0)[1]).toNumber();
        var noon = TwoSunsConfig.ORIENTATION_NOON_TOP;
        Test.assert(nearPoint(track.pointAt(track.distanceFor(720, noon), 0.0), w / 2, t));
        Test.assert(nearPoint(track.pointAt(track.distanceFor(1080, noon), 0.0), w - t, h / 2));
        Test.assert(nearPoint(track.pointAt(track.distanceFor(0, noon), 0.0), w / 2, h - t));
        Test.assert(nearPoint(track.pointAt(track.distanceFor(360, noon), 0.0), t, h / 2));
        var midnight = TwoSunsConfig.ORIENTATION_MIDNIGHT_TOP;
        Test.assert(nearPoint(track.pointAt(track.distanceFor(0, midnight), 0.0), w / 2, t));
        Test.assert(nearPoint(track.pointAt(track.distanceFor(720, midnight), 0.0), w / 2, h - t));
        var hour = track.length() / 24;
        for (var m = 0; m < TwoSunsConfig.MINUTES_PER_DAY - 60; m += 60) {
            var step = track.distanceFor(m + 60, midnight) - track.distanceFor(m, midnight);
            Test.assert((step - hour).abs() < 0.01);
        }
    }
    return true;
}

// The track's outer edge stays on the display and inside the rounded glass at every minute, on both sizes; a tick's
// inner end stays inside the track's inner box.
(:test)
function trackStaysOnTheDisplay(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TRACK_SIZES.size(); i++) {
        var w = TRACK_SIZES[i][0];
        var h = TRACK_SIZES[i][1];
        var glass = TRACK_SIZES[i][2];
        var d = w < h ? w : h;
        var track = testTrack(TRACK_SIZES[i]);
        var half = (d * RING_WIDTH_PERMILLE_TEST / TwoSunsConfig.PERMILLE / 2).toFloat();
        for (var m = 0; m < TwoSunsConfig.MINUTES_PER_DAY; m += 5) {
            var at = track.pointAt(track.distanceFor(m, TwoSunsConfig.ORIENTATION_NOON_TOP), half);
            Test.assertMessage(at[0] >= 0 && at[0] <= w && at[1] >= 0 && at[1] <= h, "off the display at minute " + m);
            Test.assertMessage(insideGlass(at, w, h, glass), "outside the glass corner at minute " + m + " (" + w + ")");
        }
    }
    return true;
}

(:debug)
function insideGlass(at as [Float, Float], w as Number, h as Number, glass as Number) as Boolean {
    return discInsideGlass(at, 0, w, h, glass);
}

// A disc of `reach` px round `at` lies on the display and inside its rounded glass corners.
(:debug)
function discInsideGlass(at as [Float, Float], reach as Number, w as Number, h as Number, glass as Number) as Boolean {
    if (at[0] < reach || at[0] > w - reach || at[1] < reach || at[1] > h - reach) {
        return false;
    }
    var cx = at[0] < glass ? glass : (at[0] > w - glass ? w - glass : at[0]);
    var cy = at[1] < glass ? glass : (at[1] > h - glass ? h - glass : at[1]);
    var dx = at[0] - cx;
    var dy = at[1] - cy;
    return Math.sqrt(dx * dx + dy * dy) + reach <= glass;
}

// The sun marker with its black halo stays on the display and inside the glass corners at every minute, on both sizes.
(:test)
function sunMarkerStaysOnTheGlass(logger as Test.Logger) as Boolean {
    for (var i = 0; i < TRACK_SIZES.size(); i++) {
        var w = TRACK_SIZES[i][0];
        var h = TRACK_SIZES[i][1];
        var d = w < h ? w : h;
        var track = testTrack(TRACK_SIZES[i]);
        var reach = TwoSunsRing.markerReach(d * RING_WIDTH_PERMILLE_TEST / TwoSunsConfig.PERMILLE);
        for (var m = 0; m < TwoSunsConfig.MINUTES_PER_DAY; m++) {
            var at = track.pointAt(track.distanceFor(m, TwoSunsConfig.ORIENTATION_NOON_TOP), 0.0);
            Test.assertMessage(discInsideGlass(at, reach, w, h, TRACK_SIZES[i][2]), "marker off the glass at minute " + m + " (" + w + ")");
        }
    }
    return true;
}

// The inner box is the full width beside the centre, narrower inside its rounded corners, and nothing past its top.
(:test)
function trackBoxFollowsItsCorners(logger as Test.Logger) as Boolean {
    var track = testTrack(TRACK_SIZES[0]);
    var inset = 20;
    var halfH = TRACK_SIZES[0][1] / 2 - inset;
    Test.assertEqual(track.halfWidthAt(inset, 0), TRACK_SIZES[0][0] / 2 - inset);
    Test.assert(track.halfWidthAt(inset, halfH) < track.halfWidthAt(inset, 0));
    Test.assertEqual(track.halfWidthAt(inset, halfH + 1), 0);
    return true;
}

// On a rectangle the layout builds the track and fits rows to its box: the time and every row stay in the box (the
// screen-fit test), and the span is the whole inner box. Elsewhere there is no track.
(:test)
function layoutBuildsTheTrackOnlyOnARectangle(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    var rectangle = System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE;
    Test.assertEqual(layout.track() != null, rectangle);
    if (rectangle) {
        var box = dc.getHeight() - 2 * (dc.getWidth() / 2 - layout.contentRadius());
        Test.assertEqual(layout.spanHeight(), box);
    }
    return true;
}

// A curve draws only when two neighbouring buckets have samples; on a rectangle a lone dot is not drawn (it would float at
// the far end of a band that spans the box), and the bolt and the number stand alone. Pro only (the history).
(:test, :pro)
function rectangleHidesACurveWithNoLine(logger as Test.Logger) as Boolean {
    var now = 1790000000;
    var newest = now - TwoSunsConfig.SECONDS_PER_MINUTE;   // inside the newest bucket (a sample at `now` itself is clamped into it too)
    var lone = TwoSunsBattery.build([50] as Array<Numeric or Null>, [newest] as Array<Number or Null>, now);
    var line = TwoSunsBattery.build([50, 50] as Array<Numeric or Null>, [newest, newest - TwoSunsConfig.BATTERY_BUCKET_SECONDS] as Array<Number or Null>, now);
    Test.assert(!lone.hasALine());
    Test.assert(line.hasALine());
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() != null) {
        Test.assert(!new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], lone, true), false).showCurve);
        Test.assert(new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], line, true), false).showCurve);
    }
    return true;
}

// On a rectangle the grown time never pushes the weather row out (a size that would is skipped for the next smaller
// one), and the time is sized for the Weather setting, not for the data: it keeps its size when the data goes. Pro only.
(:test, :pro)
function rectangleGrowthKeepsTheWeatherRow(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() == null) {
        return true;
    }
    var days = [TwoSunsTestStates.widestDay(), TwoSunsTestStates.widestNextDay()] as Array<TwoSunsWeather>;
    for (var i = 0; i < days.size(); i++) {
        var state = TwoSunsTestStates.withWeather(TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true), days[i]);
        state.weatherOn = true;
        var frame = new TwoSunsFrame(dc, layout, state, false);
        Test.assertMessage(frame.weatherMode != TwoSunsConfig.WEATHER_ROW_NONE, "weather row dropped for the time, day " + i);
        var bare = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true);
        bare.weatherOn = true;
        Test.assertEqual(new TwoSunsFrame(dc, layout, bare, false).timeFont, frame.timeFont);
    }
    return true;
}

// On a rectangle the Battery setting costs the time a size only when the battery row then draws: with the setting on and
// no room for the row, the time is the same as with it off. Pro only.
(:test, :pro)
function rectangleBatteryCostsTheTimeOnlyWhenDrawn(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() == null) {
        return true;
    }
    var days = [null, TwoSunsTestStates.widestDay()] as Array<TwoSunsWeather or Null>;
    for (var i = 0; i < days.size(); i++) {
        var on = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true);
        var off = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], TwoSunsTestStates.curve(50, 3), true);
        off.watchBattery = null;
        var day = days[i];
        if (day != null) {
            on = TwoSunsTestStates.withWeather(on, day);
            off = TwoSunsTestStates.withWeather(off, day);
            on.weatherOn = true;
            off.weatherOn = true;
        }
        var withRow = new TwoSunsFrame(dc, layout, on, false);
        if (!withRow.showBattery) {
            Test.assertEqual(withRow.timeFont, new TwoSunsFrame(dc, layout, off, false).timeFont);
        }
    }
    return true;
}

// On a rectangle the always-on time is always smaller than the awake time it follows.
(:test)
function rectangleAlwaysOnTimeIsSmaller(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() == null) {
        return true;
    }
    var states = TwoSunsTestStates.all();
    for (var i = 0; i < states.size(); i++) {
        var awake = dc.getFontHeight(new TwoSunsFrame(dc, layout, states[i], false).timeFont);
        Test.assertMessage(dc.getFontHeight(new TwoSunsFrame(dc, layout, states[i], true).timeFont) < awake, "state " + i);
    }
    return true;
}

// Free on a rectangle: the number grows with the time but stays clearly second (at most its share of the time's height).
(:test, :free)
function rectangleFreeNumberStaysSecond(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() == null) {
        return true;
    }
    var frame = new TwoSunsFrame(dc, layout, TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true), false);
    var timeH = dc.getFontHeight(frame.timeFont);
    var own = TwoSunsDraw.fontUpTo(dc, TwoSunsLayout.VALUE_FREE_FONTS, layout.capFor(TwoSunsLayout.VALUE_FREE_MAX_PERMILLE));
    Test.assert(frame.valueFont == own
                || dc.getFontHeight(frame.valueFont) * TwoSunsConfig.PERMILLE <= timeH * TwoSunsLayout.RECT_VALUE_TO_TIME_PERMILLE);
    return true;
}

// The rectangle spread: every visible gap the same (within the rounding), margins included, the time's empty bands not
// counted, the time's digits never touching a neighbour; null when the even gap would be under the minimum.
(:test)
function rectangleSpreadGapsAreEven(logger as Test.Logger) as Boolean {
    var heights = [39, 155, 0, 68, 39] as Array<Number>;
    var pads = [0, 30, 0, 0, 0] as Array<Number>;
    var tops = TwoSunsRectSpread.place(heights, pads, 20, 340, 4) as Array<Number>;
    var gaps = [tops[0] - 20, tops[1] + pads[1] - (tops[0] + heights[0]), tops[3] - (tops[1] + heights[1] - pads[1]),
                tops[4] - (tops[3] + heights[3]), 340 - (tops[4] + heights[4])] as Array<Number>;
    for (var i = 1; i < gaps.size(); i++) {
        Test.assertMessage((gaps[i] - gaps[0]).abs() <= gaps.size(), "gap " + i + " is " + gaps[i] + ", first " + gaps[0]);
    }
    Test.assert(tops[0] >= 20 && tops[4] + heights[4] <= 340);
    Test.assert(tops[1] + pads[1] >= tops[0] + heights[0] + 4 && tops[3] >= tops[1] + heights[1] - pads[1] + 4);   // digits never touch
    Test.assert(TwoSunsRectSpread.place(heights, pads, 20, 270, 4) == null);
    return true;
}

// On a rectangle the rows' places do not depend on which wording the sun sentence takes, so nothing jumps as it shortens.
(:test)
function rectangleRowsDoNotDependOnTheWording(logger as Test.Logger) as Boolean {
    var dc = testDc();
    var layout = new TwoSunsLayout(dc);
    if (layout.track() == null) {
        return true;
    }
    var state = TwoSunsTestStates.make(TwoSunsTestStates.skies()[0], null, true);
    var a = new TwoSunsFrame(dc, layout, state, false);
    state.skyLines = ["1h"] as Array<String>;
    var b = new TwoSunsFrame(dc, layout, state, false);
    Test.assertEqual(a.rows.lineTop, b.rows.lineTop);
    Test.assertEqual(a.rows.bandTop, b.rows.bandTop);
    Test.assertEqual(a.rows.timeTop, b.rows.timeTop);
    return true;
}
