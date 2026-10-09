import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// The widest states the face can show, shared by the screen-fit test and the layout report. A class,
// because the runner treats every (:test) function as a test case.
(:test)
class TwoSunsTestStates {
    private static const NOW = 1800000000;

    // Every sky state that can be widest, times every Body Battery state, with the widest clock.
    // Free has no history, so its only Body Battery state is Garmin's number (null here: the value is "--", the widest
    // text is "100" either way) and it has no place, so no place-dependent sky state (docs/decisions.md ADR-020, Free + Pro ladder).
    static function all() as Array<TwoSunsState> {
        var states = [] as Array<TwoSunsState>;
        var skies = skies();
        var curves = curves();
        for (var s = 0; s < skies.size(); s++) {
            for (var c = 0; c < curves.size(); c++) {
                states.add(make(skies[s], curves[c], true));
            }
        }
        states.add(make(skies[0], curves[0], false));   // date off: the rows re-stack
        addWeatherStates(states, skies);
        return states;
    }

    // Pro only: the weather row in its widest forms, on a day (a lead cell and three ahead cells) and the next day
    // (weekday, icon, high, low and ahead cells), each with and without the date and curve rows.
    (:pro)
    static function addWeatherStates(states as Array<TwoSunsState>, skies as Array<TwoSunsSky>) as Void {
        var curve = curve(100, 3);
        states.add(withWeather(make(skies[0], curve, true), widestDay()));
        states.add(withWeather(make(skies[0], null, false), widestDay()));
        states.add(withWeather(make(skies[2], curve, true), widestNextDay()));
        states.add(withWeather(make(skies[2], null, false), widestNextDay()));
    }

    (:free)
    static function addWeatherStates(states as Array<TwoSunsState>, skies as Array<TwoSunsSky>) as Void {
    }

    static function withWeather(state as TwoSunsState, weather as TwoSunsWeather) as TwoSunsState {
        state.weather = weather;
        return state;
    }

    // The widest day row: a three-digit Fahrenheit number and three ahead cells with two-digit 12 hour labels.
    static function widestDay() as TwoSunsWeather {
        var weather = new TwoSunsWeather();
        weather.leadKind = TwoSunsConfig.WEATHER_PARTLY;
        weather.leadText = "104" + TwoSunsConfig.DEGREE_CODE.toChar().toString();
        weather.aheadKinds = [TwoSunsConfig.WEATHER_RAIN, TwoSunsConfig.WEATHER_STORM, TwoSunsConfig.WEATHER_SNOW] as Array<Number>;
        weather.aheadLabels = ["12p", "12p", "12p"] as Array<String>;
        return weather;
    }

    // The widest next-day row: a long weekday, a three-digit high, a negative low and three ahead cells.
    static function widestNextDay() as TwoSunsWeather {
        var weather = widestDay();
        weather.nextDay = true;
        weather.dayLabel = "Wed";
        weather.lowText = "-40" + TwoSunsConfig.DEGREE_CODE.toChar().toString();
        return weather;
    }

    static function skies() as Array<TwoSunsSky> {
        var skies = [] as Array<TwoSunsSky>;
        var day = sky(TwoSunsConfig.SKY_DAY);
        day.lightLeft = 23 * 60 + 59;
        skies.add(day);
        skies.add(sky(TwoSunsConfig.SKY_DAY));   // transition day: "Sun is up"
        var before = sky(TwoSunsConfig.SKY_BEFORE_SUNRISE);
        before.nextRise = 12 * 60 + 59;
        skies.add(before);
        var estimate = sky(TwoSunsConfig.SKY_AFTER_SUNSET);
        estimate.nextRise = 12 * 60 + 59;
        estimate.nextRiseIsToday = true;
        skies.add(estimate);
        var none = sky(TwoSunsConfig.SKY_AFTER_SUNSET);
        none.noNextRise = true;
        skies.add(none);
        var setOnly = sky(TwoSunsConfig.SKY_AFTER_SUNSET);
        setOnly.set = 12 * 60 + 59;
        skies.add(setOnly);
        addPlaceSkies(skies);
        skies.add(sky(TwoSunsConfig.SKY_NO_DATA));
        return skies;
    }

    // Pro only: the states that need our own calculation or a missing place (polar days, "No place yet").
    (:pro)
    static function addPlaceSkies(skies as Array<TwoSunsSky>) as Void {
        skies.add(sky(TwoSunsConfig.SKY_MIDNIGHT_SUN));
        skies.add(sky(TwoSunsConfig.SKY_POLAR_NIGHT));
        skies.add(sky(TwoSunsConfig.SKY_NO_PLACE));
    }

    (:free)
    static function addPlaceSkies(skies as Array<TwoSunsSky>) as Void {
    }

    // Pro: fresh, stale and no history. Free: no history ever.
    (:pro)
    static function curves() as Array<TwoSunsBatteryCurve or Null> {
        return [curve(100, 3), curve(100, 90), null] as Array<TwoSunsBatteryCurve or Null>;
    }

    (:free)
    static function curves() as Array<TwoSunsBatteryCurve or Null> {
        return [null] as Array<TwoSunsBatteryCurve or Null>;
    }

    // A history curve in Pro, null in Free (which has no history): for tests that run in both tiers.
    (:pro)
    static function curveOrNull(level as Number, ageMinutes as Number) as TwoSunsBatteryCurve or Null {
        return curve(level, ageMinutes);
    }

    (:free)
    static function curveOrNull(level as Number, ageMinutes as Number) as TwoSunsBatteryCurve or Null {
        return null;
    }

    static function sky(state as Number) as TwoSunsSky {
        var sky = new TwoSunsSky();
        sky.state = state;
        return sky;
    }

    // A curve whose newest sample is `level`, `ageMinutes` old. Pro only (it builds the history).
    (:pro)
    static function curve(level as Number, ageMinutes as Number) as TwoSunsBatteryCurve {
        // two samples a bucket apart, so the curve draws a stretch of line (a rectangle hides a lone dot, ADR-028)
        var newest = NOW - ageMinutes * TwoSunsConfig.SECONDS_PER_MINUTE;
        var values = [level, level] as Array<Numeric or Null>;
        var whens = [newest, newest - TwoSunsConfig.BATTERY_BUCKET_SECONDS] as Array<Number or Null>;
        return TwoSunsBattery.build(values, whens, NOW);
    }

    // The widest clock (12:59) and the widest date lines (a long localised weekday and month).
    static function make(sky as TwoSunsSky, curve as TwoSunsBatteryCurve or Null, showDate as Boolean) as TwoSunsState {
        var settings = new TwoSunsSettings({"Date" => showDate ? 1 : 0} as Dictionary);
        var time = new TwoSunsLocalTime(2026, 9, 30, 12 * 60 + 59, 60, NOW);
        var dateLines = ["Wed 30 Sep", "30 Sep"] as Array<String>;
        var state = TwoSunsReadings.build(settings, time, true, sky, curve, null, dateLines);
        state.watchBattery = widestWatchBattery();
        return state;
    }

    // The widest watch battery text, "100%" (Pro only: Free has no battery row).
    (:pro)
    static function widestWatchBattery() as Number or Null {
        return TwoSunsConfig.BATTERY_MAX;
    }

    (:free)
    static function widestWatchBattery() as Number or Null {
        return null;
    }

    // Every row the frame keeps must have been drawn (a row silently dropped inside the drawing code would
    // pass an overlap check), no two texts may overlap, and the rows that survive must fit the span.
    static function collect(name as String, state as TwoSunsState, frame as TwoSunsFrame, expected as Number, problems as Array<String>) as Void {
        var boxes = TwoSunsDraw.boxes as Array<Array>;
        if (boxes.size() != expected) {
            problems.add("state " + name + " drew " + boxes.size() + " text rows, expected " + expected);
        }
        collectWindowAndCorners(name, boxes, problems);
        for (var i = 0; i < boxes.size(); i++) {
            for (var j = i + 1; j < boxes.size(); j++) {
                var a = boxes[i];
                var b = boxes[j];
                var apart = a[0] + a[2] <= b[0] || b[0] + b[2] <= a[0] || a[1] + a[3] <= b[1] || b[1] + b[3] <= a[1];
                if (!apart) {
                    problems.add("state " + name + " overlap: '" + (a[4] as String) + "' and '" + (b[4] as String) + "'");
                }
            }
        }
    }

    // How many boxes a frame draws. Awake: the time, the value and the glyph always, the date, the line and
    // the curve when kept. Asleep (always-on): the time and the value always, the line when kept.
    static function rowCount(frame as TwoSunsFrame, sleeping as Boolean) as Number {
        if (sleeping) {
            return 2 + (frame.showLine ? 1 : 0);
        }
        return 3 + (frame.showDate ? 1 : 0) + (frame.showLine ? 1 : 0) + (frame.showCurve ? 1 : 0) + frame.weatherBoxCount + (frame.showBattery ? 1 : 0);
    }

    // The Instinct (ADR-024): no text box may sit under the round window, and none may reach outside the circle the bezel
    // leaves visible (about 98 px in radius). Boxes include font padding, so this is stricter than the ink (a quarter of the
    // short inset is cut off each end, as TwoSunsLayout does); a simulator screenshot decides a disputed case.
    static function collectWindowAndCorners(name as String, boxes as Array<Array>, problems as Array<String>) as Void {
        var settings = System.getDeviceSettings();
        if (settings.screenShape != System.SCREEN_SHAPE_SEMI_OCTAGON || !(WatchUi has :getSubscreen)) {
            return;
        }
        var window = WatchUi.getSubscreen();
        var trim = (settings.screenWidth < settings.screenHeight ? settings.screenWidth : settings.screenHeight) / 40;
        var radius = TwoSunsLayout.VISIBLE_RADIUS_PX;
        for (var i = 0; i < boxes.size(); i++) {
            var box = boxes[i] as Array;
            if (window != null) {
                var wx = window.x as Number;
                var wy = window.y as Number;
                var clear = (box[0] as Number) + (box[2] as Number) <= wx || (box[1] as Number) >= wy + (window.height as Number)
                    || (box[1] as Number) + (box[3] as Number) <= wy;
                if (!clear) {
                    problems.add("state " + name + " window overlap: '" + (box[4] as String) + "'");
                }
            }
            for (var k = 0; k < 4; k++) {
                var dx = (box[0] as Number) + (k % 2 == 0 ? 0 : box[2] as Number) - settings.screenWidth / 2;
                var dy = (box[1] as Number) + (k < 2 ? trim : (box[3] as Number) - trim) - settings.screenHeight / 2;
                if (dx * dx + dy * dy > radius * radius) {
                    problems.add("state " + name + " corner: '" + (box[4] as String) + "'");
                    break;
                }
            }
        }
    }
}
