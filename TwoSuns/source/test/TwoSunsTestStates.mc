import Toybox.Lang;

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
        return states;
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
        var values = [level] as Array<Numeric or Null>;
        var whens = [NOW - ageMinutes * TwoSunsConfig.SECONDS_PER_MINUTE] as Array<Number or Null>;
        return TwoSunsBattery.build(values, whens, NOW);
    }

    // The widest clock (12:59) and the widest date lines (a long localised weekday and month).
    static function make(sky as TwoSunsSky, curve as TwoSunsBatteryCurve or Null, showDate as Boolean) as TwoSunsState {
        var settings = new TwoSunsSettings({"Date" => showDate ? 1 : 0} as Dictionary);
        var time = new TwoSunsLocalTime(2026, 9, 30, 12 * 60 + 59, 60, NOW);
        var dateLines = ["Wed 30 Sep", "30 Sep"] as Array<String>;
        return TwoSunsReadings.build(settings, time, true, sky, curve, null, dateLines);
    }

    // Every row the frame keeps must have been drawn (a row silently dropped inside the drawing code would
    // pass an overlap check), no two texts may overlap, and the rows that survive must fit the span.
    static function collect(name as String, state as TwoSunsState, frame as TwoSunsFrame, expected as Number, problems as Array<String>) as Void {
        var boxes = TwoSunsDraw.boxes as Array<Array>;
        if (boxes.size() != expected) {
            problems.add("state " + name + " drew " + boxes.size() + " text rows, expected " + expected);
        }
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
        return 3 + (frame.showDate ? 1 : 0) + (frame.showLine ? 1 : 0) + (frame.showCurve ? 1 : 0);
    }
}
