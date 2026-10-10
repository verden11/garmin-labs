import Toybox.Application;
import Toybox.Lang;

// Read-only and glance-safe: the clock, the stored place and (when asked) the watch's weather in, one SunWindowState
// out. The glance and the full view both call it at every draw, so they always agree (ADR-010); nothing is stored
// between draws, so nothing can outlive midnight. Never writes Storage, never calls Position.
(:glance)
class SunWindowReader {

    // `locating` and `failed` are the full view's own knowledge of its location request; the glance passes false, false.
    static function read(locating as Boolean, failed as Boolean, withSky as Boolean) as SunWindowState {
        var time = SunWindowLocalTime.now();
        var place = SunWindowPlace.fromStorage(Application.Storage.getValue(SunWindowConfig.KEY_PLACE));
        var sky = withSky ? SunWindowWeather.read(time.epoch) : [null, null] as Array<Numeric or Null>;
        return build(time, place, locating, failed, sky, withSky);
    }

    // The rule, pure so tests can drive every branch. `skyRead` is false when the weather was not read at all (a
    // glance with GLANCE_READS_WEATHER off): then no demotion and no "No weather" note.
    static function build(time as SunWindowLocalTime, place as Array<Float> or Null, locating as Boolean, failed as Boolean,
                          sky as Array<Numeric or Null>, skyRead as Boolean) as SunWindowState {
        if (place == null) {
            return new SunWindowState(locating ? SunWindowConfig.STATE_LOCATING : (failed ? SunWindowConfig.STATE_NO_FIX : SunWindowConfig.STATE_ONCE));
        }
        var day = SunWindowSun.day(time.dayNumber(), place[0].toDouble(), place[1].toDouble(), time.offsetMinutes);
        var state = new SunWindowState(kindFor(day, time.minuteOfDay, SunWindowWeather.demotes(sky)));
        state.day = day;
        state.minuteOfDay = time.minuteOfDay;
        state.offsetMinutes = time.offsetMinutes;
        state.latitude = place[0].toDouble();
        state.longitude = place[1].toDouble();
        state.skyKnown = !skyRead || SunWindowWeather.known(sky);
        return state;
    }

    static function kindFor(day as SunWindowSunDay, minuteOfDay as Number, demoted as Boolean) as Number {
        if (!day.hasWindow) {
            return SunWindowConfig.STATE_NONE_TODAY;
        }
        if (minuteOfDay < day.open) {
            return SunWindowConfig.STATE_CLOSED_BEFORE;
        }
        if (minuteOfDay > day.close) {
            return SunWindowConfig.STATE_CLOSED_AFTER;
        }
        return demoted ? SunWindowConfig.STATE_CLOSED_SKY : SunWindowConfig.STATE_OPEN;
    }
}
