import Toybox.Lang;
import Toybox.Time;
import Toybox.Weather;

// The watch's own weather, read fresh at each draw with no cache: a kept "last good" reading could demote OPEN with
// stale cloud (ADR-004). Only ever demotes OPEN to CLOSED, never promotes. Toybox.Weather needs no permission;
// uvIndex and cloudCover exist from API 5.1.0 on (the manifest floor). Any null means "no demotion" (D2 checks on a wrist).
(:glance)
class SunWindowWeather {

    // [uvIndex, cloudCover]; both null when the watch has no weather, none fresh enough, or the read throws.
    static function read(epoch as Number) as Array<Numeric or Null> {
        var none = [null, null] as Array<Numeric or Null>;
        if (!(Toybox has :Weather)) {
            return none;
        }
        try {
            var conditions = Weather.getCurrentConditions();
            if (conditions == null) {
                return none;
            }
            var observed = conditions.observationTime;
            if (observed == null || epoch - observed.value() > SunWindowConfig.WEATHER_MAX_AGE_SECONDS) {
                return none;
            }
            return [conditions.uvIndex, conditions.cloudCover] as Array<Numeric or Null>;
        } catch (e instanceof Lang.Exception) {
            return none;
        }
    }

    // True when the sky is low on UV (or, only if the D2 fallback is on, overcast). A null is not a reason.
    static function demotes(sky as Array<Numeric or Null>) as Boolean {
        var uv = sky[0];
        if (uv != null && uv < SunWindowConfig.UV_DEMOTE) {
            return true;
        }
        var cloud = sky[1];
        return SunWindowConfig.USE_CLOUD_FALLBACK && cloud != null && cloud >= SunWindowConfig.CLOUD_DEMOTE;
    }

    // Whether the watch said anything usable: the full view says "No weather" under OPEN when it did not.
    static function known(sky as Array<Numeric or Null>) as Boolean {
        return sky[0] != null || (SunWindowConfig.USE_CLOUD_FALLBACK && sky[1] != null);
    }
}
