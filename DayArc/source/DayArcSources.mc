import Toybox.Complications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Weather;

// The only class that touches the watch. Complications (permission: ComplicationSubscriber, manifest
// — confirmed required, docs/decisions.md ADR-002) for everything except the morning weather read,
// which is Toybox.Weather (no permission: confirmed against Garmin's own manifest-and-permissions
// page, Weather is not in the permission table). Every accessor is guarded: getComplication() throws
// ComplicationNotFoundException when the complication itself is absent on this device, and many
// values are documented as "or null" even when found (no data yet). Both paths return null; nothing
// here ever throws past this class, and nothing here ever fakes a value.
class DayArcSources {
    private var _conditions as Weather.CurrentConditions or Null = null;
    private var _conditionsAt as Number = -1;

    // A Complication's raw value, or null if unsupported, unpublished, or not yet populated.
    static function complicationValue(type as Complications.Type) as Complications.Value or Null {
        if (!(Toybox has :Complications)) {
            return null;
        }
        try {
            var complication = Complications.getComplication(new Complications.Id(type));
            var value = complication.value as Complications.Value or Null;
            return value;
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    static function complicationNumber(type as Complications.Type) as Number or Null {
        var value = complicationValue(type);
        return value instanceof Number ? value : null;
    }

    static function complicationFloat(type as Complications.Type) as Float or Null {
        var value = complicationValue(type);
        if (value instanceof Float) {
            return value;
        }
        return value instanceof Number ? value.toFloat() : null;
    }

    static function complicationString(type as Complications.Type) as String or Null {
        var value = complicationValue(type);
        return value instanceof String ? value : null;
    }

    // Cached for DayArcConfig.REFRESH_SECONDS: current conditions rarely change second to second,
    // and this is called once per active window's onUpdate, not per field.
    function currentConditions(epoch as Number) as Weather.CurrentConditions or Null {
        if (_conditions != null && epoch - _conditionsAt < DayArcConfig.REFRESH_SECONDS && epoch >= _conditionsAt) {
            return _conditions;
        }
        _conditions = readConditions();
        _conditionsAt = epoch;
        return _conditions;
    }

    private function readConditions() as Weather.CurrentConditions or Null {
        if (!(Toybox has :Weather)) {
            return null;
        }
        try {
            return Weather.getCurrentConditions();
        } catch (e instanceof Lang.Exception) {
            return null;
        }
    }

    // Whether this watch can carry a UV reading at all (the planner's worst-case morning sub follows it). The same test as
    // uvIndex() below (`has :uvIndex` on the live conditions), so the plan and the drawn line cannot disagree; with no
    // conditions to ask, the API level decides (uvIndex needs 5.1).
    static function hasUvIndex() as Boolean {
        var conditions = null as Weather.CurrentConditions or Null;
        try {
            conditions = (Toybox has :Weather) ? Weather.getCurrentConditions() : null;
        } catch (e instanceof Lang.Exception) {
            conditions = null;
        }
        if (conditions != null) {
            return conditions has :uvIndex;
        }
        var version = System.getDeviceSettings().monkeyVersion;
        return version[0] > DayArcConfig.UV_API_MAJOR || (version[0] == DayArcConfig.UV_API_MAJOR && version[1] >= DayArcConfig.UV_API_MINOR);
    }

    // uvIndex needs API 5.1.0 on CurrentConditions (confirmed above the 4.2.0 floor, ADR-005):
    // graceful-hide via `has`, never a baseline field.
    static function uvIndex(conditions as Weather.CurrentConditions or Null) as Float or Null {
        if (conditions == null) {
            return null;
        }
        if (!(conditions has :uvIndex)) {
            return null;
        }
        return conditions.uvIndex;
    }
}
