import Toybox.Complications;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

// Builds the window's data content: one hero read (docs/decisions.md ADR-004/ADR-008-extension)
// plus, in Pro only, a capped grid of secondary fields (docs/decisions.md ADR-009). Which function
// body compiles in is decided at build time by monkey.simple.jungle/monkey.pro.jungle's
// excludeAnnotations, not a runtime branch — the whole point of ADR-003.
//
// hero: {:label, :value, :sub (String or Null, a second neutral line under the hero)}
// cells (Pro only): Array<{:label as String, :value as String}>, priority order — DayArcLayout
// drops from the end of this array, never the middle, so the highest-priority fields survive on a
// small screen.
class DayArcFields {
    (:simple)
    static function forWindow(window as Number, sources as DayArcSources, epoch as Number) as Dictionary {
        return heroFor(window, sources, epoch);
    }

    (:pro)
    static function forWindow(window as Number, sources as DayArcSources, epoch as Number) as Dictionary {
        var hero = heroFor(window, sources, epoch);
        hero.put(:cells, cellsFor(window, sources));
        return hero;
    }

    // Date is shown in every window now, not just night (ADR-013; was night-only before). The hero
    // icon is the window's identity marker (the morning's is the current condition since 2026-10-05, ROADMAP 13.29, and absent
    // when there is no weather), set here for every active window whatever the reading — and in the wearer's chosen accent (ADR-014), read
    // fresh on every gather, never cached.
    private static function heroFor(window as Number, sources as DayArcSources, epoch as Number) as Dictionary {
        var dateText = DayArcSources.complicationString(Complications.COMPLICATION_TYPE_WEEKDAY_MONTHDAY);
        var hero = {} as Dictionary;
        if (window == DayArcConfig.WINDOW_MORNING) {
            hero = morningHero(sources, epoch);
        } else if (window == DayArcConfig.WINDOW_MIDDAY) {
            hero = middayHero(sources);
        } else if (window == DayArcConfig.WINDOW_EVENING) {
            hero = eveningHero(sources);
        }
        // WINDOW_NIGHT: no data block, time + date only (ADR-010) — an empty hero, so no icon.
        hero.put(:dateText, dateText);
        var choice = DayArcSettings.accentChoice();
        // The morning icon is the current condition (ROADMAP 13.29, 2026-10-05: the fixed sun-behind-cloud showed on rainy days
        // and beside "Weather unavailable"); the other windows keep their window glyph.
        var morning = window == DayArcConfig.WINDOW_MORNING;
        var kind = hero.hasKey(:weatherKind) ? hero.get(:weatherKind) as Number : DayArcConfig.WEATHER_NONE;
        var icon = morning ? DayArcIcons.weatherFor(kind, choice, false) : DayArcIcons.heroFor(window, choice);
        if (icon != null) {
            hero.put(:icon, icon);                                    // beside the HOT number tier
            hero.put(:iconSmall, morning ? DayArcIcons.weatherFor(kind, choice, true) : DayArcIcons.heroSmallFor(window, choice)); // ADR-017
        }
        return hero;
    }

    private static function morningHero(sources as DayArcSources, epoch as Number) as Dictionary {
        var conditions = sources.currentConditions(epoch);
        if (conditions == null) {
            return {
                :label => null,
                :value => WatchUi.loadResource(Rez.Strings.value_none) as String,
                :sub => WatchUi.loadResource(Rez.Strings.morning_weather_unavailable) as String,
            } as Dictionary;
        }
        var feelsLike = conditions has :feelsLikeTemperature ? conditions.feelsLikeTemperature : null;
        var highLow = DayArcSources.complicationString(Complications.COMPLICATION_TYPE_HIGH_LOW_TEMPERATURE);
        var precip = conditions has :precipitationChance ? conditions.precipitationChance : null;
        var sub = highLow != null ? highLow : "";
        if (precip != null) {
            sub += (sub.length() > 0 ? "  " : "") + Lang.format(WatchUi.loadResource(Rez.Strings.morning_precip) as String, [precip]);
        }
        var uv = DayArcSources.uvIndex(conditions);
        if (uv != null) {
            sub += (sub.length() > 0 ? "  " : "") + Lang.format(WatchUi.loadResource(Rez.Strings.morning_uv) as String, [Math.round(uv).toNumber()]);
        }
        // Labelled like the other windows' readings: an unlabelled feels-like 9 under "H 16 / L 13" read as wrong on the
        // wrist (owner's photo, 2026-10-05, ROADMAP 13.28).
        return {
            :label => WatchUi.loadResource(Rez.Strings.morning_feels_label) as String,
            :value => DayArcFormat.temperature(feelsLike),
            :sub => sub.length() > 0 ? sub : null,
            :weatherKind => DayArcWeatherKind.kind(conditions.condition),
        } as Dictionary;
    }

    private static function middayHero(sources as DayArcSources) as Dictionary {
        var stress = DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_STRESS);
        return {
            :label => WatchUi.loadResource(Rez.Strings.midday_stress_label) as String,
            :value => DayArcFormat.count(stress),
            :sub => stress == null ? (WatchUi.loadResource(Rez.Strings.midday_stress_unavailable) as String) : null,
            :gauge => stress, // 0-100 or null; DayArcDraw draws a single-hue fill, never a colour verdict.
            :gaugeMax => DayArcConfig.STRESS_MAX,
        } as Dictionary;
    }

    private static function eveningHero(sources as DayArcSources) as Dictionary {
        var battery = DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_BODY_BATTERY);
        return {
            :label => WatchUi.loadResource(Rez.Strings.evening_battery_label) as String,
            :value => DayArcFormat.count(battery),
            :sub => batterySub(battery),
            :gauge => battery,
            :gaugeMax => DayArcConfig.BODY_BATTERY_MAX,
        } as Dictionary;
    }

    // The empty state is always a sentence. Neither density adds "N of 100" under the gauge: the number and the
    // gauge already say it, and the row is worth more to the hero and the grid (ADR-016, ADR-013 "open" item closed).
    private static function batterySub(battery as Number or Null) as String or Null {
        return battery == null ? WatchUi.loadResource(Rez.Strings.evening_battery_unavailable) as String : null;
    }

    (:pro)
    private static function cellsFor(window as Number, sources as DayArcSources) as Array<Dictionary> {
        if (window == DayArcConfig.WINDOW_MORNING) {
            return morningCells();
        }
        if (window == DayArcConfig.WINDOW_MIDDAY) {
            return middayCells();
        }
        if (window == DayArcConfig.WINDOW_EVENING) {
            return eveningCells();
        }
        return [] as Array<Dictionary>;
    }

    // No date cell here (ADR-013 review, 2026-09-28): the header row now shows the date in every
    // window, Pro included — a separate grid cell would have shown it twice on the same screen.
    (:pro)
    private static function morningCells() as Array<Dictionary> {
        return [
            iconOnlyCell(DayArcIcons.GRID_SUNRISE, timeOfDayString(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_SUNRISE))),
            iconOnlyCell(DayArcIcons.GRID_SUNSET, timeOfDayString(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_SUNSET))),
            iconOnlyCell(DayArcIcons.GRID_BATTERY, DayArcFormat.percent(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_BATTERY))),
            iconOnlyCell(DayArcIcons.GRID_HEART, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_HEART_RATE))),
            iconOnlyCell(DayArcIcons.GRID_STEPS, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_STEPS))),
            iconOnlyCell(DayArcIcons.GRID_STAIRS, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_FLOORS_CLIMBED))),
            iconOnlyCell(DayArcIcons.GRID_BELL, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_NOTIFICATION_COUNT))),
        ] as Array<Dictionary>;
    }

    // Every window's grid is icon-only cells now (morning joined 2026-10-02); the labelled cells below keep
    // a short text label only where the icon cannot carry the meaning.
    (:pro)
    private static function middayCells() as Array<Dictionary> {
        var nextEvent = DayArcSources.complicationString(Complications.COMPLICATION_TYPE_CALENDAR_EVENTS);
        var calendar = iconCell(Rez.Strings.midday_calendar_label, DayArcIcons.GRID_CALENDAR,
            nextEvent != null ? nextEvent : (WatchUi.loadResource(Rez.Strings.midday_calendar_none) as String));
        calendar.put(:flex, true); // an event title is the one value that may end in "..." (DayArcGrid.cellFits)
        return [
            calendar,
            iconOnlyCell(DayArcIcons.GRID_HEART, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_HEART_RATE))),
            iconCell(Rez.Strings.label_intensity_minutes, DayArcIcons.GRID_PULSE, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_INTENSITY_MINUTES))),
            iconOnlyCell(DayArcIcons.GRID_STAIRS, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_FLOORS_CLIMBED))),
            iconOnlyCell(DayArcIcons.GRID_STEPS, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_STEPS))),
            iconOnlyCell(DayArcIcons.GRID_FLAME, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_CALORIES))),
            iconOnlyCell(DayArcIcons.GRID_BELL, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_NOTIFICATION_COUNT))),
            iconOnlyCell(DayArcIcons.GRID_THERMOMETER, DayArcFormat.temperature(DayArcSources.complicationFloat(Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE))),
            iconCell(Rez.Strings.label_weekly_run, DayArcIcons.GRID_RUN, DayArcFormat.distanceMeters(DayArcSources.complicationFloat(Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE))),
            iconCell(Rez.Strings.label_weekly_bike, DayArcIcons.GRID_BIKE, DayArcFormat.distanceMeters(DayArcSources.complicationFloat(Complications.COMPLICATION_TYPE_WEEKLY_BIKE_DISTANCE))),
        ] as Array<Dictionary>;
    }

    (:pro)
    private static function eveningCells() as Array<Dictionary> {
        var vo2Run = DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_VO2MAX_RUN);
        var vo2 = vo2Run != null ? vo2Run : DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_VO2MAX_BIKE);
        return [
            iconCell(Rez.Strings.label_recovery_time, DayArcIcons.GRID_REFRESH, DayArcFormat.hoursFromMinutes(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_RECOVERY_TIME))),
            iconCell(Rez.Strings.label_respiration, DayArcIcons.GRID_BREATH, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_RESPIRATION_RATE))),
            iconOnlyCell(DayArcIcons.GRID_HEART, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_HEART_RATE))),
            iconOnlyCell(DayArcIcons.GRID_STEPS, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_STEPS))),
            iconOnlyCell(DayArcIcons.GRID_FLAME, DayArcFormat.count(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_CALORIES))),
            iconOnlyCell(DayArcIcons.GRID_DROPLET, DayArcFormat.percent(DayArcSources.complicationNumber(Complications.COMPLICATION_TYPE_PULSE_OX))),
            iconCell(Rez.Strings.label_vo2max, DayArcIcons.GRID_BARS, DayArcFormat.count(vo2)),
        ] as Array<Dictionary>;
    }

    // Keeps its text label (the icon alone doesn't read unambiguously — DESIGN.md "Layout").
    (:pro)
    private static function iconCell(labelResource as ResourceId, iconId as Number, value as String or Null) as Dictionary {
        return {
            :label => WatchUi.loadResource(labelResource) as String,
            :value => value != null ? value : (WatchUi.loadResource(Rez.Strings.value_none) as String),
            :icon => iconId,
        } as Dictionary;
    }

    // Drops its text label entirely — the icon alone already reads (DESIGN.md "Layout").
    (:pro)
    private static function iconOnlyCell(iconId as Number, value as String or Null) as Dictionary {
        return {
            :label => null,
            :value => value != null ? value : (WatchUi.loadResource(Rez.Strings.value_none) as String),
            :icon => iconId,
        } as Dictionary;
    }

    // Respects the device's 12/24-hour setting, same as the main clock (DayArcFormat.clockTime) —
    // an earlier version always printed 24-hour here regardless, so a 12-hour device's clock and
    // Pro's own sunrise/sunset cells could disagree on the same screen (code review, 2026-09-28).
    (:pro)
    private static function timeOfDayString(secondsSinceMidnight as Number or Null) as String or Null {
        if (secondsSinceMidnight == null) {
            return null;
        }
        var hour = secondsSinceMidnight / 3600;
        var minute = (secondsSinceMidnight % 3600) / 60;
        return DayArcFormat.clockTime(hour, minute, System.getDeviceSettings().is24Hour);
    }
}
