import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

// Fixed states for the tests: a place, a date and a clock minute in, a SunWindowState out, through the same
// SunWindowReader.build the app uses. Helpers are a (:test) class because the runner treats every (:test) function as a test.
(:test)
class SunWindowTestStates {
    static const VILNIUS = [54.7, 25.3] as Array<Float>;
    static const SYDNEY = [-33.9, 151.2] as Array<Float>;
    static const SKY_BRIGHT = [8.0, 10] as Array<Numeric or Null>;
    static const SKY_LOW_UV = [1.0, 80] as Array<Numeric or Null>;
    static const SKY_UNKNOWN = [null, null] as Array<Numeric or Null>;

    static function time(year as Number, month as Number, day as Number, minute as Number, offset as Number) as SunWindowLocalTime {
        return new SunWindowLocalTime(year, month, day, minute, offset, 0);
    }

    // Vilnius at midsummer: today's window is 10:26 to 16:16 (the fixtures).
    static function vilnius(minute as Number, sky as Array<Numeric or Null>) as SunWindowState {
        return SunWindowReader.build(time(2026, 6, 21, minute, 180), VILNIUS, false, false, sky, true);
    }

    // Every state the full view can show, widest wording first.
    static function all() as Array<SunWindowState> {
        return [
            vilnius(13 * 60, SKY_BRIGHT),                    // OPEN
            vilnius(9 * 60, SKY_BRIGHT),                     // CLOSED, before ("Opens 10:26")
            vilnius(13 * 60, SKY_LOW_UV),                    // CLOSED, sky
            vilnius(18 * 60, SKY_BRIGHT),                    // CLOSED, after
            vilnius(13 * 60, SKY_UNKNOWN),                   // OPEN with no weather
            SunWindowReader.build(time(2026, 12, 21, 12 * 60, 120), VILNIUS, false, false, SKY_BRIGHT, true),   // NONE TODAY
            SunWindowReader.build(time(2026, 6, 21, 12 * 60, 180), null, true, false, SKY_BRIGHT, true),        // locating
            SunWindowReader.build(time(2026, 6, 21, 12 * 60, 180), null, false, true, SKY_BRIGHT, true),        // no fix
            SunWindowReader.build(time(2026, 6, 21, 12 * 60, 180), null, false, false, SKY_BRIGHT, true)        // once
        ] as Array<SunWindowState>;
    }
}

(:debug)
function testDc() as Graphics.Dc {
    var settings = System.getDeviceSettings();
    var size = {:width => settings.screenWidth, :height => settings.screenHeight};
    return (Graphics.createBufferedBitmap(size).get() as Graphics.BufferedBitmap).getDc();
}
