import Toybox.Lang;

// Maps a hero/grid field to its bitmap resource (ADR-013). Every icon is pre-coloured at build
// time (see resources/drawables/icons/, resources-pro/drawables/icons/) and drawn with plain
// dc.drawBitmap — no runtime tint, since a fixed hue never needs one (DESIGN.md "Iconography").
// Morning's Pro grid (sunrise/sunset/battery%/HR/steps/floors/notifications — no date cell: the header shows it) is unchanged by
// ADR-013 and has no icons — the owner's own request that triggered this redesign named midday and
// evening specifically; DESIGN.md's icon table covers only those two windows' 17 grid fields.
class DayArcIcons {
    // Hero icons are pre-coloured bitmaps, one per hue (tools/gen_hero_icons.py) — a runtime tint
    // would hit drawBitmap2's FR165/FR165m :tintColor bug. Indexed like DayArcPalette.ACCENTS.
    // `choice` is the wearer's Accent colour (0 = Auto: this window's own hue).
    static function heroFor(window as Number, choice as Number) as ResourceId or Null {
        var hue = DayArcPalette.hueIndex(window, choice);
        if (window == DayArcConfig.WINDOW_MORNING) {
            return [Rez.Drawables.IconHeroWeatherCyan, Rez.Drawables.IconHeroWeatherAmber, Rez.Drawables.IconHeroWeatherRose,
                    Rez.Drawables.IconHeroWeatherGreen, Rez.Drawables.IconHeroWeatherBlue, Rez.Drawables.IconHeroWeatherPurple][hue];
        }
        if (window == DayArcConfig.WINDOW_MIDDAY) {
            return [Rez.Drawables.IconHeroStressCyan, Rez.Drawables.IconHeroStressAmber, Rez.Drawables.IconHeroStressRose,
                    Rez.Drawables.IconHeroStressGreen, Rez.Drawables.IconHeroStressBlue, Rez.Drawables.IconHeroStressPurple][hue];
        }
        if (window == DayArcConfig.WINDOW_EVENING) {
            return [Rez.Drawables.IconHeroBatteryCyan, Rez.Drawables.IconHeroBatteryAmber, Rez.Drawables.IconHeroBatteryRose,
                    Rez.Drawables.IconHeroBatteryGreen, Rez.Drawables.IconHeroBatteryBlue, Rez.Drawables.IconHeroBatteryPurple][hue];
        }
        return null; // night: no hero, no icon
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
        return Rez.Drawables.IconGridBars;
    }
}
