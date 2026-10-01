import Toybox.Lang;
import Toybox.Math;

// NOAA's sunrise equation, evaluated once at the local noon of a local date
// (docs/spec.md "Data rules", checked against the US Naval Observatory to
// 2 minutes on 27 cases: TwoSunsSunReferenceTest). Pure functions, no clock,
// no permission. Monkey C floats are 32-bit, so the maths runs on days since
// J2000, never on a Julian date (which would be too big for a Float).
// Pro only: it needs a place, and Free has none (docs/decisions.md ADR-020, Free + Pro ladder).
(:pro)
class TwoSunsSun {

    // `offsetMinutes` is the local offset from UTC in minutes (the caller derives it from the clock).
    // `latitude` and `longitude` are degrees, east positive.
    static function compute(year as Number, month as Number, day as Number,
                            latitude as Float, longitude as Float, offsetMinutes as Number) as TwoSunsSunDay {
        var daysSinceJ2000 = TwoSunsCalendar.dayNumber(year, month, day) - TwoSunsConfig.J2000_DAY_NUMBER
            - offsetMinutes.toFloat() / TwoSunsConfig.MINUTES_PER_DAY;
        var solar = declinationAndEquationOfTime(daysSinceJ2000);
        var declination = solar[0];
        var noon = TwoSunsConfig.MINUTES_AT_LONGITUDE_ZERO_NOON
            - TwoSunsConfig.MINUTES_PER_DEGREE * longitude - solar[1] + offsetMinutes;
        var cosHorizon = cosHourAngle(TwoSunsConfig.ZENITH_HORIZON, latitude, declination);
        var kind = TwoSunsConfig.SUN_NORMAL;
        if (cosHorizon < -1.0) {
            kind = TwoSunsConfig.SUN_UP_ALL_DAY;
        } else if (cosHorizon > 1.0) {
            kind = TwoSunsConfig.SUN_DOWN_ALL_DAY;
        }
        var civil = halfDay(TwoSunsConfig.ZENITH_CIVIL, latitude, declination);
        var golden = halfDay(TwoSunsConfig.ZENITH_GOLDEN, latitude, declination);
        var horizon = kind == TwoSunsConfig.SUN_NORMAL ? halfDay(TwoSunsConfig.ZENITH_HORIZON, latitude, declination) : null;
        return new TwoSunsSunDay(kind,
            horizon == null ? null : rounded(noon - horizon), horizon == null ? null : rounded(noon + horizon),
            rounded(noon),
            civil == null ? null : rounded(noon - civil), civil == null ? null : rounded(noon + civil),
            golden == null ? null : rounded(noon - golden), golden == null ? null : rounded(noon + golden));
    }

    // Sun's declination in radians and the equation of time in minutes, from days since J2000.
    static function declinationAndEquationOfTime(days as Float) as Array<Float> {
        var t = days / TwoSunsConfig.DAYS_PER_JULIAN_CENTURY;
        var meanLongitude = wrapDegrees(280.46646 + t * (36000.76983 + t * 0.0003032));
        var meanAnomaly = wrapDegrees(357.52911 + t * (35999.05029 - 0.0001537 * t));
        var eccentricity = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);
        var m = radians(meanAnomaly);
        var center = fSin(m) * (1.914602 - t * (0.004817 + 0.000014 * t))
            + fSin(2.0 * m) * (0.019993 - 0.000101 * t) + fSin(3.0 * m) * 0.000289;
        var node = radians(wrapDegrees(125.04 - 1934.136 * t));
        var apparentLongitude = radians(meanLongitude + center - 0.00569 - 0.00478 * fSin(node));
        var obliquity = radians(23.43929 - 0.0130042 * t + 0.00256 * fCos(node));
        var declination = fAsin(fSin(obliquity) * fSin(apparentLongitude));
        var y = fTan(obliquity / 2.0);
        y = y * y;
        var l0 = radians(meanLongitude);
        var equation = y * fSin(2.0 * l0) - 2.0 * eccentricity * fSin(m)
            + 4.0 * eccentricity * y * fSin(m) * fCos(2.0 * l0)
            - 0.5 * y * y * fSin(4.0 * l0) - 1.25 * eccentricity * eccentricity * fSin(2.0 * m);
        return [declination, TwoSunsConfig.MINUTES_PER_DEGREE * degrees(equation)] as Array<Float>;
    }

    // cos of the sun's hour angle when it stands at `zenith`; outside -1..1 the sun never gets there.
    static function cosHourAngle(zenith as Float, latitude as Float, declination as Float) as Float {
        var lat = radians(latitude);
        return fCos(radians(zenith)) / (fCos(lat) * fCos(declination))
            - fTan(lat) * fTan(declination);
    }

    // Minutes from solar noon to the crossing of `zenith`, or null when there is none that day.
    static function halfDay(zenith as Float, latitude as Float, declination as Float) as Float or Null {
        var cosH = cosHourAngle(zenith, latitude, declination);
        if (cosH > 1.0 || cosH < -1.0) {
            return null;
        }
        return TwoSunsConfig.MINUTES_PER_DEGREE * degrees(fAcos(cosH));
    }

    static function rounded(minutes as Float) as Number {
        return Math.round(minutes).toNumber();
    }

    static function radians(value as Float) as Float {
        return value * Math.PI.toFloat() / TwoSunsConfig.DEGREES_PER_HALF_TURN;
    }

    static function degrees(value as Float) as Float {
        return value * TwoSunsConfig.DEGREES_PER_HALF_TURN / Math.PI.toFloat();
    }

    static function wrapDegrees(value as Float) as Float {
        return value - TwoSunsConfig.DEGREES_PER_TURN * Math.floor(value / TwoSunsConfig.DEGREES_PER_TURN).toFloat();
    }

    // Toybox.Math returns Float or Double; the maths here is Float only.
    static function fSin(value as Float) as Float {
        return Math.sin(value).toFloat();
    }

    static function fCos(value as Float) as Float {
        return Math.cos(value).toFloat();
    }

    static function fTan(value as Float) as Float {
        return Math.tan(value).toFloat();
    }

    static function fAsin(value as Float) as Float {
        return Math.asin(value).toFloat();
    }

    static function fAcos(value as Float) as Float {
        return Math.acos(value).toFloat();
    }
}
