import Toybox.Lang;
import Toybox.System;

// The small date line: words, never numbers, so it cannot be misread (03/04 is 3 April or 4 March).
// Weekday and month come from the system in the watch's language; the order is the one thing the
// system does not tell us, so it follows the watch's language and units.
class TwoSunsDateText {

    // Candidates, longest first, for measured fitting.
    static function lines(weekday as String, day as Number, month as String, monthFirst as Boolean) as Array<String> {
        var date = monthFirst ? month + " " + day : day + " " + month;
        return [weekday + " " + date, date] as Array<String>;
    }

    // Month first only for English with statute units (US style); everything else is day first.
    static function monthFirst(english as Boolean, statute as Boolean) as Boolean {
        return english && statute;
    }

    static function monthFirstNow() as Boolean {
        var device = System.getDeviceSettings();
        return device.systemLanguage == System.LANGUAGE_ENG && device.distanceUnits == System.UNIT_STATUTE;
    }
}
