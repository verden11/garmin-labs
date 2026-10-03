import Toybox.Graphics;
import Toybox.Lang;

// The seven weather icons, drawn from circles, lines and polygons (DESIGN.md: primitives only, no bitmaps) so one
// drawing serves every screen size. `size` is the icon's width and height in pixels, centred on (x, y). Coloured
// icons use one fixed hue per part (TwoSunsPalette.WEATHER_*); a mono icon is MUTED all over. Every proportion
// below is a thousandth of `size`.
(:pro)
class TwoSunsWeatherIcons {
    private static const RAY_FROM = 300;
    private static const RAY_TO = 430;
    private static const SUN_RADIUS = 200;
    private static const RAY_PEN = 70;
    private static const KNOCKOUT_PERMILLE = 1120;   // the cloud over the sun is first drawn this much larger in black, so mono sun and cloud stay apart
    // The eight ray directions, in thousandths: right, then clockwise.
    private static const RAY_X = [1000, 707, 0, -707, -1000, -707, 0, 707] as Array<Number>;
    private static const RAY_Y = [0, 707, 1000, 707, 0, -707, -1000, -707] as Array<Number>;
    private static const PARTLY_SUN_X = -180;
    private static const PARTLY_SUN_Y = -160;
    private static const PARTLY_SUN_SIZE = 800;
    private static const PARTLY_CLOUD_X = 100;
    private static const PARTLY_CLOUD_Y = 100;
    private static const PARTLY_CLOUD_SIZE = 850;
    private static const CLOUD_LIFT = 140;        // cloud over rain, snow and bolt sits this much higher
    private static const DROP_FROM = 260;
    private static const DROP_TO = 430;
    private static const DROP_LEAN = 60;
    private static const DROP_X = [-220, 0, 220] as Array<Number>;
    private static const DROP_PEN = 90;
    private static const FLAKE_Y = 380;
    private static const FLAKE_RADIUS = 70;
    private static const FLAKE_MIN_RADIUS = 2;
    private static const FOG_Y = [-200, 0, 200] as Array<Number>;
    private static const FOG_HALF = 360;
    private static const FOG_TAPER = 40;
    private static const FOG_PEN = 80;
    // The cloud: three puffs (x, y, radius) and a rounded base (left, top, width, height, corner radius).
    private static const CLOUD_PUFFS = [[-260, 80, 200], [-20, -60, 290], [280, 60, 200]] as Array<Array<Number>>;
    private static const CLOUD_BASE = [-460, 80, 940, 200, 100] as Array<Number>;
    private static const FLAKE_X = DROP_X;
    // The bolt, as x and y pairs. Every kind's lowest point stays above 480 (half the icon and a little less), where the hour label starts in a full-row cell.
    private static const BOLT = [[40, 190], [-120, 337], [-10, 337], [-70, 459], [160, 288], [40, 288]] as Array<Array<Number>>;

    static function draw(dc as Graphics.Dc, kind as Number, x as Number, y as Number, size as Number, mono as Boolean) as Void {
        var sun = mono ? TwoSunsPalette.MUTED : TwoSunsPalette.WEATHER_SUN;
        var cloud = mono ? TwoSunsPalette.MUTED : TwoSunsPalette.TEXT;
        var rain = mono ? TwoSunsPalette.MUTED : TwoSunsPalette.WEATHER_RAIN;
        if (kind == TwoSunsConfig.WEATHER_CLEAR) {
            sunIcon(dc, x, y, size, sun);
        } else if (kind == TwoSunsConfig.WEATHER_PARTLY) {
            sunIcon(dc, x + at(size, PARTLY_SUN_X), y + at(size, PARTLY_SUN_Y), at(size, PARTLY_SUN_SIZE), sun);
            if (mono) {
                cloudIcon(dc, x + at(size, PARTLY_CLOUD_X), y + at(size, PARTLY_CLOUD_Y), at(at(size, PARTLY_CLOUD_SIZE), KNOCKOUT_PERMILLE), TwoSunsPalette.BACKGROUND);
            }
            cloudIcon(dc, x + at(size, PARTLY_CLOUD_X), y + at(size, PARTLY_CLOUD_Y), at(size, PARTLY_CLOUD_SIZE), cloud);
        } else if (kind == TwoSunsConfig.WEATHER_CLOUDY) {
            cloudIcon(dc, x, y, size, cloud);
        } else if (kind == TwoSunsConfig.WEATHER_FOG) {
            fogIcon(dc, x, y, size, cloud);
        } else if (kind >= TwoSunsConfig.WEATHER_RAIN && kind <= TwoSunsConfig.WEATHER_SNOW) {
            cloudIcon(dc, x, y - at(size, CLOUD_LIFT), size, cloud);
            if (kind == TwoSunsConfig.WEATHER_RAIN) {
                dropsIcon(dc, x, y, size, rain);
            } else if (kind == TwoSunsConfig.WEATHER_STORM) {
                boltIcon(dc, x, y, size, sun);
            } else {
                flakesIcon(dc, x, y, size, mono ? TwoSunsPalette.MUTED : TwoSunsPalette.TEXT);
            }
        }
    }

    private static function at(size as Number, permille as Number) as Number {
        return size * permille / TwoSunsConfig.PERMILLE;
    }

    // One multiply, so a diagonal ray is as long as an upright one at 16 px.
    private static function ray(size as Number, reach as Number, direction as Number) as Number {
        return size * reach * direction / (TwoSunsConfig.PERMILLE * TwoSunsConfig.PERMILLE);
    }

    private static function pen(size as Number, permille as Number) as Number {
        var width = at(size, permille);
        return width < 1 ? 1 : width;
    }

    private static function sunIcon(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, at(size, SUN_RADIUS));
        dc.setPenWidth(pen(size, RAY_PEN));
        for (var i = 0; i < RAY_X.size(); i++) {
            dc.drawLine(x + ray(size, RAY_FROM, RAY_X[i]), y + ray(size, RAY_FROM, RAY_Y[i]), x + ray(size, RAY_TO, RAY_X[i]), y + ray(size, RAY_TO, RAY_Y[i]));
        }
    }

    private static function cloudIcon(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < CLOUD_PUFFS.size(); i++) {
            dc.fillCircle(x + at(size, CLOUD_PUFFS[i][0]), y + at(size, CLOUD_PUFFS[i][1]), at(size, CLOUD_PUFFS[i][2]));
        }
        dc.fillRoundedRectangle(x + at(size, CLOUD_BASE[0]), y + at(size, CLOUD_BASE[1]), at(size, CLOUD_BASE[2]), at(size, CLOUD_BASE[3]), at(size, CLOUD_BASE[4]));
    }

    private static function dropsIcon(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen(size, DROP_PEN));
        for (var i = 0; i < DROP_X.size(); i++) {
            dc.drawLine(x + at(size, DROP_X[i]), y + at(size, DROP_FROM), x + at(size, DROP_X[i] - DROP_LEAN), y + at(size, DROP_TO));
        }
    }

    private static function flakesIcon(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var radius = at(size, FLAKE_RADIUS) < FLAKE_MIN_RADIUS ? FLAKE_MIN_RADIUS : at(size, FLAKE_RADIUS);
        for (var i = 0; i < FLAKE_X.size(); i++) {
            dc.fillCircle(x + at(size, FLAKE_X[i]), y + at(size, FLAKE_Y), radius);
        }
    }

    private static function boltIcon(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var points = [] as Array<[Numeric, Numeric]>;
        for (var i = 0; i < BOLT.size(); i++) {
            points.add([x + at(size, BOLT[i][0]), y + at(size, BOLT[i][1])] as [Numeric, Numeric]);
        }
        dc.fillPolygon(points);
    }

    private static function fogIcon(dc as Graphics.Dc, x as Number, y as Number, size as Number, color as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen(size, FOG_PEN));
        for (var i = 0; i < FOG_Y.size(); i++) {
            dc.drawLine(x - at(size, FOG_HALF - i * FOG_TAPER), y + at(size, FOG_Y[i]), x + at(size, FOG_HALF - i * FOG_TAPER), y + at(size, FOG_Y[i]));
        }
    }
}
