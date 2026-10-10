import Toybox.Lang;
import Toybox.Math;

// The remembered place: [latitude, longitude] rounded to 0.1 degree. That is all the sun maths needs and all the app
// ever stores; it never leaves the watch. Copied from TwoSuns (credited), glance-safe: the glance reads it and never writes.
(:glance)
class SunWindowPlace {

    // A fix of exactly 0,0 is a "no fix" placeholder, and so is exactly +-180 longitude (a forum report; D6 will say).
    static function isUsable(latitude as Float, longitude as Float) as Boolean {
        var nullIsland = latitude.abs() < SunWindowConfig.NULL_ISLAND_DEGREES && longitude.abs() < SunWindowConfig.NULL_ISLAND_DEGREES;
        return !nullIsland
            && latitude >= -SunWindowConfig.LATITUDE_LIMIT && latitude <= SunWindowConfig.LATITUDE_LIMIT
            && longitude > -SunWindowConfig.LONGITUDE_LIMIT && longitude < SunWindowConfig.LONGITUDE_LIMIT;
    }

    static function round(value as Float) as Float {
        return Math.round(value * SunWindowConfig.PLACE_TENTHS).toFloat() / SunWindowConfig.PLACE_TENTHS;
    }

    // The first usable candidate wins. Each is [latitude, longitude] or null. Returns the place rounded, or null.
    static function pick(candidates as Array<Array<Float> or Null>) as Array<Float> or Null {
        for (var i = 0; i < candidates.size(); i++) {
            var candidate = candidates[i];
            if (candidate != null && candidate.size() == 2 && isUsable(candidate[0], candidate[1])) {
                // 179.96 rounds to 180.0, which isUsable rejects on the way back: keep it a place (179.9).
                var longitude = round(candidate[1]);
                var limit = SunWindowConfig.LONGITUDE_LIMIT - 1.0 / SunWindowConfig.PLACE_TENTHS;
                longitude = longitude > limit ? limit : (longitude < -limit ? -limit : longitude);
                return [round(candidate[0]), longitude] as Array<Float>;
            }
        }
        return null;
    }

    // Save a fresher fix only when it is more than 0.1 degree from the saved place (no writes for jitter).
    static function shouldReplace(saved as Array<Float> or Null, fresh as Array<Float>) as Boolean {
        if (saved == null) {
            return true;
        }
        var limit = SunWindowConfig.PLACE_REPLACE_DEGREES + SunWindowConfig.PLACE_EPSILON;
        return (fresh[0] - saved[0]).abs() > limit || (fresh[1] - saved[1]).abs() > limit;
    }

    // Storage hands back an Object; trust it only when it is exactly the two usable numbers SunWindowSources writes
    // (any numeric type is accepted and converted, so a place saved as Float, Double or Number is never lost).
    static function fromStorage(stored as Object or Null) as Array<Float> or Null {
        if (!(stored instanceof Lang.Array) || stored.size() != 2) {
            return null;
        }
        var latitude = numeric(stored[0] as Object or Null);
        var longitude = numeric(stored[1] as Object or Null);
        if (latitude == null || longitude == null || !isUsable(latitude, longitude)) {
            return null;
        }
        return [latitude, longitude] as Array<Float>;
    }

    static function numeric(value as Object or Null) as Float or Null {
        if (value instanceof Lang.Float || value instanceof Lang.Double || value instanceof Lang.Number) {
            return value.toFloat();
        }
        return null;
    }
}
