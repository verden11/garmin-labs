import Toybox.Lang;
import Toybox.Math;

// NOAA's solar position (Meeus), in Double, geometric (no refraction), evaluated on days since J2000.0. Pure functions,
// no clock, no permission. Checked against research_notes/Vitamin D window/solar_elevation_fixtures.py (JPL Horizons
// agrees to 0.0061 degrees): SunWindowSunReferenceTest. Toybox.Math returns a Double only when given a Long or Double,
// so every value here is a Double (ADR-004).
(:glance)
class SunWindowSun {

    // Today's window at the 45-degree line for local day `localDayNumber` (days since 1970), place in degrees (east
    // positive), offset in minutes east of UTC. The edges are found by re-reading the declination and the equation of
    // time at each edge instant (EDGE_ITERATIONS passes), which is how the fixtures bisect it.
    static function day(localDayNumber as Number, latitude as Double, longitude as Double, offsetMinutes as Number) as SunWindowSunDay {
        // Local solar noon without the equation of time, wrapped into the local day: at UTC+13 or +14 west of 180 degrees
        // the sum is a day too late (Apia, Kiritimati), which would read the next day's sun and put the window past midnight.
        var unwrapped = SunWindowConfig.NOON_MINUTE_AT_LONGITUDE_ZERO - SunWindowConfig.MINUTES_PER_DEGREE * longitude + offsetMinutes;
        var base = unwrapped - SunWindowConfig.MINUTES_PER_DAY * Math.floor(unwrapped / SunWindowConfig.MINUTES_PER_DAY).toDouble();
        var solar = parameters(localDayNumber, base, offsetMinutes);
        for (var i = 0; i < SunWindowConfig.EDGE_ITERATIONS; i++) {
            solar = parameters(localDayNumber, base - solar[1], offsetMinutes);
        }
        var noon = base - solar[1];
        var cosH = cosHourAngle(SunWindowConfig.ZENITH_WINDOW, latitude, solar[0]);
        if (cosH > 1.0d) {
            return new SunWindowSunDay(false, 0, 0, solar[0], solar[1]);
        }
        var half = SunWindowConfig.MINUTES_PER_DEGREE * degrees(acos(cosH));
        var openAt = edge(localDayNumber, latitude, base, offsetMinutes, -1, noon - half);
        var closeAt = edge(localDayNumber, latitude, base, offsetMinutes, 1, noon + half);
        if (openAt == null || closeAt == null) {
            return new SunWindowSunDay(false, 0, 0, solar[0], solar[1]);
        }
        var first = Math.ceil(openAt - SunWindowConfig.EDGE_ROUNDING_SLACK).toNumber();
        var last = Math.floor(closeAt + SunWindowConfig.EDGE_ROUNDING_SLACK).toNumber();
        if (first > last) {
            return new SunWindowSunDay(false, 0, 0, solar[0], solar[1]);   // under a minute: no whole minute at the line
        }
        return new SunWindowSunDay(true, first, last, solar[0], solar[1]);
    }

    // One edge: `side` is -1 for the rising crossing and +1 for the setting one; null when the line is not reached there.
    static function edge(localDayNumber as Number, latitude as Double, base as Double, offsetMinutes as Number,
                         side as Number, start as Double) as Double or Null {
        var at = start;
        for (var i = 0; i < SunWindowConfig.EDGE_ITERATIONS; i++) {
            var solar = parameters(localDayNumber, at, offsetMinutes);
            var cosH = cosHourAngle(SunWindowConfig.ZENITH_WINDOW, latitude, solar[0]);
            if (cosH > 1.0d) {
                return null;
            }
            at = base - solar[1] + side * SunWindowConfig.MINUTES_PER_DEGREE * degrees(acos(cosH));
        }
        return at;
    }

    // [declination radians, equation of time minutes] at `localMinute` of local day `localDayNumber`.
    static function parameters(localDayNumber as Number, localMinute as Double, offsetMinutes as Number) as Array<Double> {
        return declinationAndEquation(daysSinceJ2000(localDayNumber, localMinute, offsetMinutes));
    }

    // J2000.0 is 2000-01-01 12:00 UT, half a day after day number 10957.
    static function daysSinceJ2000(localDayNumber as Number, localMinute as Double, offsetMinutes as Number) as Double {
        return localDayNumber.toDouble() - SunWindowConfig.J2000_DAY_NUMBER - SunWindowConfig.J2000_HALF_DAY
            + (localMinute - offsetMinutes) / SunWindowConfig.MINUTES_PER_DAY;
    }

    // Sun's declination in radians and the equation of time in minutes, from days since J2000.
    static function declinationAndEquation(days as Double) as Array<Double> {
        var t = days / SunWindowConfig.DAYS_PER_JULIAN_CENTURY;
        var meanLongitude = wrapDegrees(280.46646d + t * (36000.76983d + t * 0.0003032d));
        var meanAnomaly = wrapDegrees(357.52911d + t * (35999.05029d - 0.0001537d * t));
        var eccentricity = 0.016708634d - t * (0.000042037d + 0.0000001267d * t);
        var m = radians(meanAnomaly);
        var center = dsin(m) * (1.914602d - t * (0.004817d + 0.000014d * t))
            + dsin(2.0d * m) * (0.019993d - 0.000101d * t) + dsin(3.0d * m) * 0.000289d;
        var node = radians(wrapDegrees(125.04d - 1934.136d * t));
        var apparentLongitude = radians(meanLongitude + center - 0.00569d - 0.00478d * dsin(node));
        var obliquity = radians(23.43929d - 0.0130042d * t + 0.00256d * dcos(node));
        var declination = asin(dsin(obliquity) * dsin(apparentLongitude));
        var y = dtan(obliquity / 2.0d);
        y = y * y;
        var l0 = radians(meanLongitude);
        var equation = y * dsin(2.0d * l0) - 2.0d * eccentricity * dsin(m)
            + 4.0d * eccentricity * y * dsin(m) * dcos(2.0d * l0)
            - 0.5d * y * y * dsin(4.0d * l0) - 1.25d * eccentricity * eccentricity * dsin(2.0d * m);
        return [declination, SunWindowConfig.MINUTES_PER_DEGREE * degrees(equation)] as Array<Double>;
    }

    // cos of the sun's hour angle when it stands at `zenith` degrees; above 1 the sun never gets that high today.
    static function cosHourAngle(zenith as Double, latitude as Double, declination as Double) as Double {
        var lat = radians(latitude);
        return dcos(radians(zenith)) / (dcos(lat) * dcos(declination)) - dtan(lat) * dtan(declination);
    }

    // The sun's height in degrees at `utcMinute` (minutes after UTC midnight of the day the parameters were read for).
    static function elevation(latitude as Double, longitude as Double, declination as Double, equation as Double, utcMinute as Double) as Double {
        var hourAngle = (utcMinute + equation + SunWindowConfig.MINUTES_PER_DEGREE * longitude) / SunWindowConfig.MINUTES_PER_DEGREE
            - SunWindowConfig.DEGREES_PER_HALF_TURN;
        var lat = radians(latitude);
        var s = dsin(lat) * dsin(declination) + dcos(lat) * dcos(declination) * dcos(radians(hourAngle));
        return degrees(asin(s));
    }

    // The full pipeline for one instant: UTC day number (days since 1970) and minutes after UTC midnight.
    static function elevationAtUtc(latitude as Double, longitude as Double, utcDayNumber as Number, utcMinute as Double) as Double {
        var days = utcDayNumber.toDouble() - SunWindowConfig.J2000_DAY_NUMBER - SunWindowConfig.J2000_HALF_DAY
            + utcMinute / SunWindowConfig.MINUTES_PER_DAY;
        var solar = declinationAndEquation(days);
        return elevation(latitude, longitude, solar[0], solar[1], utcMinute);
    }

    static function radians(value as Double) as Double {
        return value * SunWindowConfig.PI / SunWindowConfig.DEGREES_PER_HALF_TURN;
    }

    static function degrees(value as Double) as Double {
        return value * SunWindowConfig.DEGREES_PER_HALF_TURN / SunWindowConfig.PI;
    }

    static function wrapDegrees(value as Double) as Double {
        return value - SunWindowConfig.DEGREES_PER_TURN * Math.floor(value / SunWindowConfig.DEGREES_PER_TURN).toDouble();
    }

    // Toybox.Math returns Float or Double; the maths here is Double only. Arguments are clamped where a rounding
    // error could push them just outside the function's domain.
    static function dsin(value as Double) as Double {
        return Math.sin(value).toDouble();
    }

    static function dcos(value as Double) as Double {
        return Math.cos(value).toDouble();
    }

    static function dtan(value as Double) as Double {
        return Math.tan(value).toDouble();
    }

    static function asin(value as Double) as Double {
        return Math.asin(clamp(value)).toDouble();
    }

    static function acos(value as Double) as Double {
        return Math.acos(clamp(value)).toDouble();
    }

    static function clamp(value as Double) as Double {
        return value > 1.0d ? 1.0d : (value < -1.0d ? -1.0d : value);
    }
}
