import Toybox.Lang;
import Toybox.Weather;

// Garmin's weather conditions (54 in SDK 9.2, all since API 3.2.0) folded onto the morning's five glyphs (ROADMAP 13.29):
// fog and haze read as cloudy, storms as rain, sleet and hail as snow. A condition with no glyph (windy, unknown, a value
// newer than this list) is WEATHER_NONE: no icon, never a guess. The grouping is TwoSuns's (TwoSunsWeatherKind), copied.
class DayArcWeatherKind {
    private static const CLEAR = [Weather.CONDITION_CLEAR, Weather.CONDITION_MOSTLY_CLEAR, Weather.CONDITION_FAIR] as Array<Number>;
    private static const PARTLY = [Weather.CONDITION_PARTLY_CLOUDY, Weather.CONDITION_PARTLY_CLEAR, Weather.CONDITION_THIN_CLOUDS] as Array<Number>;
    private static const CLOUDY = [Weather.CONDITION_CLOUDY, Weather.CONDITION_MOSTLY_CLOUDY, Weather.CONDITION_FOG, Weather.CONDITION_HAZY,
        Weather.CONDITION_MIST, Weather.CONDITION_DUST, Weather.CONDITION_SMOKE, Weather.CONDITION_SAND, Weather.CONDITION_SANDSTORM,
        Weather.CONDITION_HAZE, Weather.CONDITION_VOLCANIC_ASH] as Array<Number>;
    private static const RAIN = [Weather.CONDITION_RAIN, Weather.CONDITION_LIGHT_RAIN, Weather.CONDITION_HEAVY_RAIN,
        Weather.CONDITION_SCATTERED_SHOWERS, Weather.CONDITION_LIGHT_SHOWERS, Weather.CONDITION_SHOWERS, Weather.CONDITION_HEAVY_SHOWERS,
        Weather.CONDITION_CHANCE_OF_SHOWERS, Weather.CONDITION_DRIZZLE, Weather.CONDITION_UNKNOWN_PRECIPITATION,
        Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN, Weather.CONDITION_FREEZING_RAIN, Weather.CONDITION_THUNDERSTORMS,
        Weather.CONDITION_SCATTERED_THUNDERSTORMS, Weather.CONDITION_CHANCE_OF_THUNDERSTORMS, Weather.CONDITION_SQUALL,
        Weather.CONDITION_TORNADO, Weather.CONDITION_HURRICANE, Weather.CONDITION_TROPICAL_STORM] as Array<Number>;
    private static const SNOW = [Weather.CONDITION_SNOW, Weather.CONDITION_LIGHT_SNOW, Weather.CONDITION_HEAVY_SNOW,
        Weather.CONDITION_WINTRY_MIX, Weather.CONDITION_LIGHT_RAIN_SNOW, Weather.CONDITION_HEAVY_RAIN_SNOW, Weather.CONDITION_RAIN_SNOW,
        Weather.CONDITION_HAIL, Weather.CONDITION_ICE, Weather.CONDITION_CHANCE_OF_SNOW, Weather.CONDITION_CHANCE_OF_RAIN_SNOW,
        Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW, Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW, Weather.CONDITION_FLURRIES,
        Weather.CONDITION_SLEET, Weather.CONDITION_ICE_SNOW] as Array<Number>;
    // In the order of the WEATHER_* kinds (clear 0 ... snow 4): the index of the group is the kind.
    private static const GROUPS = [CLEAR, PARTLY, CLOUDY, RAIN, SNOW] as Array<Array<Number>>;

    static function kind(condition as Number or Null) as Number {
        if (condition == null) {
            return DayArcConfig.WEATHER_NONE;
        }
        for (var i = 0; i < GROUPS.size(); i++) {
            if (GROUPS[i].indexOf(condition) >= 0) {
                return i;
            }
        }
        return DayArcConfig.WEATHER_NONE;
    }
}
