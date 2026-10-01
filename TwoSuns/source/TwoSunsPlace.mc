import Toybox.Lang;
import Toybox.Math;

// The remembered place: [latitude, longitude] rounded to 0.1 degree. That is all the sun maths needs
// (minutes per quarter degree) and all the face ever stores; it never leaves the watch.
// Pro only: the Free build has no place and writes no Application.Storage (docs/decisions.md ADR-020, Free + Pro ladder).
(:pro)
class TwoSunsPlace {

    static function isUsable(latitude as Float, longitude as Float) as Boolean {
        var nullIsland = latitude.abs() < TwoSunsConfig.NULL_ISLAND_DEGREES && longitude.abs() < TwoSunsConfig.NULL_ISLAND_DEGREES;
        return !nullIsland
            && latitude >= -TwoSunsConfig.LATITUDE_LIMIT && latitude <= TwoSunsConfig.LATITUDE_LIMIT
            && longitude >= -TwoSunsConfig.LONGITUDE_LIMIT && longitude <= TwoSunsConfig.LONGITUDE_LIMIT;
    }

    static function round(value as Float) as Float {
        return Math.round(value * TwoSunsConfig.PLACE_TENTHS).toFloat() / TwoSunsConfig.PLACE_TENTHS;
    }

    // The first usable source wins (order: activity, weather, GPS, saved: the caller lists them).
    // Each candidate is [latitude, longitude] or null. Returns the place rounded, or null.
    static function pick(candidates as Array<Array<Float> or Null>) as Array<Float> or Null {
        for (var i = 0; i < candidates.size(); i++) {
            var candidate = candidates[i];
            if (candidate != null && candidate.size() == 2 && isUsable(candidate[0], candidate[1])) {
                return [round(candidate[0]), round(candidate[1])] as Array<Float>;
            }
        }
        return null;
    }

    // Save a fresher source only when it is more than 0.1 degree from the saved place (no writes for jitter).
    static function shouldReplace(saved as Array<Float> or Null, fresh as Array<Float>) as Boolean {
        if (saved == null) {
            return true;
        }
        var limit = TwoSunsConfig.PLACE_REPLACE_DEGREES + TwoSunsConfig.PLACE_EPSILON;
        return (fresh[0] - saved[0]).abs() > limit || (fresh[1] - saved[1]).abs() > limit;
    }

    // Storage hands back an Object; trust it only when it is two usable numbers (any numeric type is
    // accepted and converted, so a place saved as Float, Double or Number is never lost).
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
