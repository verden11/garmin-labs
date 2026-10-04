import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Every number the watch owner sees converted to their own device's units, never raw metric
// (Toybox.Complications' own docs: "it is the subscriber's role to convert the value to the metric
// specified in system settings"). "--" for anything null, in every formatter here.
class DayArcFormat {
    static function temperature(celsius as Float or Null) as String {
        return temperatureIn(celsius, System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE);
    }

    // Split from temperature() so the conversion itself is testable with a fixed unit
    // (DayArcFormatTest) rather than whatever unit this simulator/device happens to be set to.
    static function temperatureIn(celsius as Float or Null, statute as Boolean) as String {
        if (celsius == null) {
            return WatchUi.loadResource(Rez.Strings.value_none) as String;
        }
        var value = statute ? celsius * 9.0 / 5.0 + 32.0 : celsius;
        // toNumber() truncates toward zero, not to nearest (Garmin's own docs: "6.8 becomes 6").
        // Round first, or every fractional reading is biased toward zero — code review, 2026-09-28.
        return Math.round(value).toNumber().toString() + "°";
    }

    static function distanceMeters(meters as Float or Null) as String {
        return distanceMetersIn(meters, System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE);
    }

    static function distanceMetersIn(meters as Float or Null, statute as Boolean) as String {
        if (meters == null) {
            return WatchUi.loadResource(Rez.Strings.value_none) as String;
        }
        var value = statute ? meters / 1609.34 : meters / 1000.0;
        return value.format("%.1f") + (statute ? " mi" : " km");
    }

    // Shared by the main clock (DayArcView) and any other time-of-day read (e.g. Pro's sunrise/
    // sunset grid cells, DayArcFields) — both must respect the device's 12/24-hour setting the same
    // way, not reimplement it twice with one of the two forgetting (code review, 2026-09-28).
    static function clockTime(hour as Number, minute as Number, is24Hour as Boolean) as String {
        var h = hour;
        if (!is24Hour) {
            h = hour % 12;
            if (h == 0) {
                h = 12;
            }
        }
        return h.format("%02d") + ":" + minute.format("%02d");
    }

    static function count(value as Number or Null) as String {
        return value == null ? (WatchUi.loadResource(Rez.Strings.value_none) as String) : value.toString();
    }

    // Recovery time arrives in MINUTES (Complications.COMPLICATION_TYPE_RECOVERY_TIME, SDK 9.2.0), the wrist
    // photo of 2026-10-03 showed it raw as "2501"; the watch's own screens say hours, so round to hours.
    static function hoursFromMinutes(minutes as Number or Null) as String {
        return minutes == null ? (WatchUi.loadResource(Rez.Strings.value_none) as String) : ((minutes + 30) / 60).toString() + "h";
    }

    static function percent(value as Number or Null) as String {
        return value == null ? (WatchUi.loadResource(Rez.Strings.value_none) as String) : value.toString() + "%";
    }
}
