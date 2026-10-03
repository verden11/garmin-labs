import Toybox.Lang;

// Garmin's weather conditions (54 in SDK 9.2, all since API 3.2.0) folded onto the seven icons. A condition with no icon
// (windy, unknown, a value newer than this list) is WEATHER_NONE: the icon is not drawn, never guessed. Pro only: the Free build has no weather.
(:pro)
class TwoSunsWeatherKind {
    private static const CLEAR = [Toybox.Weather.CONDITION_CLEAR, Toybox.Weather.CONDITION_MOSTLY_CLEAR, Toybox.Weather.CONDITION_FAIR] as Array<Number>;
    private static const PARTLY = [Toybox.Weather.CONDITION_PARTLY_CLOUDY, Toybox.Weather.CONDITION_PARTLY_CLEAR,
        Toybox.Weather.CONDITION_THIN_CLOUDS] as Array<Number>;
    private static const CLOUDY = [Toybox.Weather.CONDITION_CLOUDY, Toybox.Weather.CONDITION_MOSTLY_CLOUDY] as Array<Number>;
    private static const RAIN = [Toybox.Weather.CONDITION_RAIN, Toybox.Weather.CONDITION_LIGHT_RAIN, Toybox.Weather.CONDITION_HEAVY_RAIN,
        Toybox.Weather.CONDITION_SCATTERED_SHOWERS, Toybox.Weather.CONDITION_LIGHT_SHOWERS, Toybox.Weather.CONDITION_SHOWERS,
        Toybox.Weather.CONDITION_HEAVY_SHOWERS, Toybox.Weather.CONDITION_CHANCE_OF_SHOWERS, Toybox.Weather.CONDITION_DRIZZLE,
        Toybox.Weather.CONDITION_UNKNOWN_PRECIPITATION, Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN,
        Toybox.Weather.CONDITION_FREEZING_RAIN] as Array<Number>;
    private static const STORM = [Toybox.Weather.CONDITION_THUNDERSTORMS, Toybox.Weather.CONDITION_SCATTERED_THUNDERSTORMS,
        Toybox.Weather.CONDITION_CHANCE_OF_THUNDERSTORMS, Toybox.Weather.CONDITION_SQUALL, Toybox.Weather.CONDITION_TORNADO,
        Toybox.Weather.CONDITION_HURRICANE, Toybox.Weather.CONDITION_TROPICAL_STORM] as Array<Number>;
    private static const SNOW = [Toybox.Weather.CONDITION_SNOW, Toybox.Weather.CONDITION_LIGHT_SNOW, Toybox.Weather.CONDITION_HEAVY_SNOW,
        Toybox.Weather.CONDITION_WINTRY_MIX, Toybox.Weather.CONDITION_LIGHT_RAIN_SNOW, Toybox.Weather.CONDITION_HEAVY_RAIN_SNOW,
        Toybox.Weather.CONDITION_RAIN_SNOW, Toybox.Weather.CONDITION_HAIL, Toybox.Weather.CONDITION_ICE,
        Toybox.Weather.CONDITION_CHANCE_OF_SNOW, Toybox.Weather.CONDITION_CHANCE_OF_RAIN_SNOW, Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW,
        Toybox.Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW, Toybox.Weather.CONDITION_FLURRIES, Toybox.Weather.CONDITION_SLEET,
        Toybox.Weather.CONDITION_ICE_SNOW] as Array<Number>;
    private static const FOG = [Toybox.Weather.CONDITION_FOG, Toybox.Weather.CONDITION_HAZY, Toybox.Weather.CONDITION_MIST,
        Toybox.Weather.CONDITION_DUST, Toybox.Weather.CONDITION_SMOKE, Toybox.Weather.CONDITION_SAND,
        Toybox.Weather.CONDITION_SANDSTORM, Toybox.Weather.CONDITION_HAZE, Toybox.Weather.CONDITION_VOLCANIC_ASH] as Array<Number>;
    // In the order of the WEATHER_* kinds (clear 0 ... fog 6): the index of the group is the kind.
    private static const GROUPS = [CLEAR, PARTLY, CLOUDY, RAIN, STORM, SNOW, FOG] as Array<Array<Number>>;

    static function kind(condition as Number or Null) as Number {
        if (condition == null) {
            return TwoSunsConfig.WEATHER_NONE;
        }
        for (var i = 0; i < GROUPS.size(); i++) {
            if (GROUPS[i].indexOf(condition) >= 0) {
                return i;
            }
        }
        return TwoSunsConfig.WEATHER_NONE;
    }
}
