import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.System;

// Reads native daily metrics. Slots resolve once (at start and on settings
// change) to the first metric this watch actually reports, so a watch
// without a barometer never draws an empty floors bar.
class HeroFaceMetrics {

    static function resolve(slots as Array<Number>, info as ActivityMonitor.Info) as Array<Number> {
        var kinds = [] as Array<Number>;
        var chains = HeroFaceConfig.SLOT_CHAINS;
        for (var i = 0; i < chains.size(); i++) {
            var choice = i < slots.size() ? slots[i] : HeroFaceConfig.METRIC_AUTO;
            kinds.add(choice != HeroFaceConfig.METRIC_AUTO && supported(choice, info) ? choice : firstSupported(chains[i], info));
        }
        return kinds;
    }

    private static function firstSupported(chain as Array<Number>, info as ActivityMonitor.Info) as Number {
        for (var i = 0; i < chain.size(); i++) {
            if (supported(chain[i], info)) {
                return chain[i];
            }
        }
        return HeroFaceConfig.STEPS;
    }

    static function supported(kind as Number, info as ActivityMonitor.Info) as Boolean {
        if (kind == HeroFaceConfig.STEPS) {
            return info.steps != null;
        } else if (kind == HeroFaceConfig.CALORIES) {
            return info.calories != null;
        } else if (kind == HeroFaceConfig.INTENSITY) {
            return (info has :activeMinutesDay) && info.activeMinutesDay != null && info.activeMinutesWeekGoal != null;
        } else if (kind == HeroFaceConfig.DISTANCE) {
            return info.distance != null;
        } else if (kind == HeroFaceConfig.FLOORS) {
            return (info has :floorsClimbed) && info.floorsClimbed != null;
        } else if (kind == HeroFaceConfig.MOVE) {
            return info.moveBarLevel != null;
        }
        return false;
    }

    static function read(kinds as Array<Number>, info as ActivityMonitor.Info) as Array<HeroFaceMetric> {
        var metrics = [] as Array<HeroFaceMetric>;
        for (var i = 0; i < kinds.size(); i++) {
            metrics.add(readOne(kinds[i], info));
        }
        return metrics;
    }

    private static function readOne(kind as Number, info as ActivityMonitor.Info) as HeroFaceMetric {
        if (kind == HeroFaceConfig.STEPS) {
            return new HeroFaceMetric(kind, orZero(info.steps), orZero(info.stepGoal));
        } else if (kind == HeroFaceConfig.CALORIES) {
            return new HeroFaceMetric(kind, orZero(info.calories), 0);
        } else if (kind == HeroFaceConfig.INTENSITY) {
            return intensity(info);
        } else if (kind == HeroFaceConfig.DISTANCE) {
            return new HeroFaceMetric(kind, orZero(info.distance) / distanceDivisor(), 0);
        } else if (kind == HeroFaceConfig.FLOORS) {
            return new HeroFaceMetric(kind, orZero(info.floorsClimbed), orZero(info.floorsClimbedGoal));
        }
        return new HeroFaceMetric(HeroFaceConfig.MOVE, orZero(info.moveBarLevel), ActivityMonitor.MOVE_BAR_LEVEL_MAX);
    }

    // Garmin only sets a weekly intensity goal; a seventh of it (rounded up)
    // is the day's fair share.
    private static function intensity(info as ActivityMonitor.Info) as HeroFaceMetric {
        var minutes = info.activeMinutesDay;
        var total = minutes != null ? orZero(minutes.total) : 0;
        var week = orZero(info.activeMinutesWeekGoal);
        var days = HeroFaceConfig.DAYS_PER_WEEK;
        return new HeroFaceMetric(HeroFaceConfig.INTENSITY, total, (week + days - 1) / days);
    }

    static function distanceDivisor() as Number {
        return System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE
            ? HeroFaceConfig.CM_PER_TENTH_MILE
            : HeroFaceConfig.CM_PER_TENTH_KM;
    }

    private static function orZero(value as Number or Null) as Number {
        return value != null ? value : 0;
    }
}
