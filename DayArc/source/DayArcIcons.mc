import Toybox.Lang;

// Maps a hero/grid field to its bitmap resource (ADR-013). Every icon is pre-coloured at build
// time (see resources/drawables/icons/, resources-pro/drawables/icons/) and drawn with plain
// dc.drawBitmap — no runtime tint, since a fixed hue never needs one (DESIGN.md "Iconography").
// Morning's Pro grid (sunrise/sunset/battery%/HR/steps/floors/notifications — no date cell: the header shows it) had no icons
// until 2026-10-02 (owner, after a wrist photo: icon-less pills lost their labels), when it got the same icon-only cells
// as midday and evening: three new icons (sunrise, sunset, battery) plus the heart, steps, stairs and bell already here.
class DayArcIcons {
    // Hero icons are pre-coloured bitmaps, one per hue (tools/gen_hero_icons.py) — a runtime tint
    // would hit drawBitmap2's FR165/FR165m :tintColor bug. Indexed like DayArcPalette.ACCENTS.
    // `choice` is the wearer's Accent colour (0 = Auto: this window's own hue). Two sizes of every icon exist per screen
    // (ADR-017: the jungles load them from resources-hero-*): the LARGE one (heroFor) sits beside the HOT number tier, the
    // SMALL one (heroSmallFor) beside MEDIUM and MILD, so the icon stays about as tall as the digits whichever tier the
    // planner picks.
    static function heroFor(window as Number, choice as Number) as ResourceId or Null {
        return heroIcon(window, choice, false);
    }

    static function heroSmallFor(window as Number, choice as Number) as ResourceId or Null {
        return heroIcon(window, choice, true);
    }

    private static function heroIcon(window as Number, choice as Number, small as Boolean) as ResourceId or Null {
        var hue = DayArcPalette.hueIndex(window, choice);
        if (window == DayArcConfig.WINDOW_MORNING) {
            return (small ? smallWeather() : largeWeather())[hue];
        }
        if (window == DayArcConfig.WINDOW_MIDDAY) {
            return (small ? smallStress() : largeStress())[hue];
        }
        if (window == DayArcConfig.WINDOW_EVENING) {
            return (small ? smallBattery() : largeBattery())[hue];
        }
        return null; // night: no hero, no icon
    }

    private static function largeWeather() as Array<ResourceId> {
        return [Rez.Drawables.IconHeroWeatherCyan, Rez.Drawables.IconHeroWeatherAmber, Rez.Drawables.IconHeroWeatherRose,
                Rez.Drawables.IconHeroWeatherGreen, Rez.Drawables.IconHeroWeatherBlue, Rez.Drawables.IconHeroWeatherPurple] as Array<ResourceId>;
    }

    private static function largeStress() as Array<ResourceId> {
        return [Rez.Drawables.IconHeroStressCyan, Rez.Drawables.IconHeroStressAmber, Rez.Drawables.IconHeroStressRose,
                Rez.Drawables.IconHeroStressGreen, Rez.Drawables.IconHeroStressBlue, Rez.Drawables.IconHeroStressPurple] as Array<ResourceId>;
    }

    private static function largeBattery() as Array<ResourceId> {
        return [Rez.Drawables.IconHeroBatteryCyan, Rez.Drawables.IconHeroBatteryAmber, Rez.Drawables.IconHeroBatteryRose,
                Rez.Drawables.IconHeroBatteryGreen, Rez.Drawables.IconHeroBatteryBlue, Rez.Drawables.IconHeroBatteryPurple] as Array<ResourceId>;
    }

    private static function smallWeather() as Array<ResourceId> {
        return [Rez.Drawables.IconHeroSmallWeatherCyan, Rez.Drawables.IconHeroSmallWeatherAmber, Rez.Drawables.IconHeroSmallWeatherRose,
                Rez.Drawables.IconHeroSmallWeatherGreen, Rez.Drawables.IconHeroSmallWeatherBlue, Rez.Drawables.IconHeroSmallWeatherPurple] as Array<ResourceId>;
    }

    private static function smallStress() as Array<ResourceId> {
        return [Rez.Drawables.IconHeroSmallStressCyan, Rez.Drawables.IconHeroSmallStressAmber, Rez.Drawables.IconHeroSmallStressRose,
                Rez.Drawables.IconHeroSmallStressGreen, Rez.Drawables.IconHeroSmallStressBlue, Rez.Drawables.IconHeroSmallStressPurple] as Array<ResourceId>;
    }

    private static function smallBattery() as Array<ResourceId> {
        return [Rez.Drawables.IconHeroSmallBatteryCyan, Rez.Drawables.IconHeroSmallBatteryAmber, Rez.Drawables.IconHeroSmallBatteryRose,
                Rez.Drawables.IconHeroSmallBatteryGreen, Rez.Drawables.IconHeroSmallBatteryBlue, Rez.Drawables.IconHeroSmallBatteryPurple] as Array<ResourceId>;
    }

    (:pro)
    static const GRID_CALENDAR = 0;
    (:pro)
    static const GRID_HEART = 1;
    (:pro)
    static const GRID_BOLT = 2;
    (:pro)
    static const GRID_STAIRS = 3;
    (:pro)
    static const GRID_STEPS = 4;
    (:pro)
    static const GRID_FLAME = 5;
    (:pro)
    static const GRID_BELL = 6;
    (:pro)
    static const GRID_THERMOMETER = 7;
    (:pro)
    static const GRID_RUN = 8;
    (:pro)
    static const GRID_BIKE = 9;
    (:pro)
    static const GRID_REFRESH = 10;
    (:pro)
    static const GRID_BREATH = 11;
    (:pro)
    static const GRID_DROPLET = 12;
    (:pro)
    static const GRID_BARS = 13;
    (:pro)
    static const GRID_SUNRISE = 14;
    (:pro)
    static const GRID_SUNSET = 15;
    (:pro)
    static const GRID_BATTERY = 16;

    (:pro)
    static function gridFor(iconId as Number) as ResourceId {
        if (iconId == GRID_CALENDAR) { return Rez.Drawables.IconGridCalendar; }
        if (iconId == GRID_HEART) { return Rez.Drawables.IconGridHeart; }
        if (iconId == GRID_BOLT) { return Rez.Drawables.IconGridBolt; }
        if (iconId == GRID_STAIRS) { return Rez.Drawables.IconGridStairs; }
        if (iconId == GRID_STEPS) { return Rez.Drawables.IconGridSteps; }
        if (iconId == GRID_FLAME) { return Rez.Drawables.IconGridFlame; }
        if (iconId == GRID_BELL) { return Rez.Drawables.IconGridBell; }
        if (iconId == GRID_THERMOMETER) { return Rez.Drawables.IconGridThermometer; }
        if (iconId == GRID_RUN) { return Rez.Drawables.IconGridRun; }
        if (iconId == GRID_BIKE) { return Rez.Drawables.IconGridBike; }
        if (iconId == GRID_REFRESH) { return Rez.Drawables.IconGridRefresh; }
        if (iconId == GRID_BREATH) { return Rez.Drawables.IconGridBreath; }
        if (iconId == GRID_DROPLET) { return Rez.Drawables.IconGridDroplet; }
        if (iconId == GRID_SUNRISE) { return Rez.Drawables.IconGridSunrise; }
        if (iconId == GRID_SUNSET) { return Rez.Drawables.IconGridSunset; }
        if (iconId == GRID_BATTERY) { return Rez.Drawables.IconGridBattery; }
        return Rez.Drawables.IconGridBars;
    }
}
