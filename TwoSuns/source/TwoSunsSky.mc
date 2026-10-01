import Toybox.Lang;

// What the face says about the sky right now: one row of the state table in docs/spec.md, plus the
// numbers the ring and the bottom line draw. Built by resolve() from Garmin's own sunrise and sunset
// (Complications, seconds since local midnight) and, when a place is known, our own NOAA day.
// All times are local minutes since local midnight; `set` can exceed 1440 (a sunset after midnight).
class TwoSunsSky {
    var state as Number = TwoSunsConfig.SKY_NO_DATA;
    var rise as Number or Null = null;
    var set as Number or Null = null;
    var lightLeft as Number or Null = null;      // minutes of daylight left; SKY_DAY only
    var nextRise as Number or Null = null;       // the clock minute (0 to 1439) of the sunrise to announce
    var nextRiseIsToday as Boolean = false;      // only today's sunrise was known, so tomorrow's is that, a few minutes off
    var noNextRise as Boolean = false;           // the calculation says the sun does not rise tomorrow
    var golden as Boolean = false;               // the sun is up and lower than 6 degrees
    var calc as TwoSunsSunDay or Null = null;    // today's own calculation: twilight and golden-hour arcs for the ring

    static function resolve(now as Number, garminRise as Number or Null, garminSet as Number or Null, hasComplications as Boolean,
                            today as TwoSunsSunDay or Null, tomorrow as TwoSunsSunDay or Null) as TwoSunsSky {
        var sky = new TwoSunsSky();
        sky.calc = today;
        var gRise = garminMinute(garminRise);
        var gSet = garminMinute(garminSet);
        var rise = gRise;
        var set = gSet;
        if (today != null && today.kind == TwoSunsConfig.SUN_NORMAL) {
            rise = rise == null ? today.rise : rise;
            set = set == null ? today.set : set;
        }
        if (rise == null && set == null) {
            sky.state = noTimesState(hasComplications, today);
            return sky;
        }
        if (rise != null && set != null && set < rise) {
            set += TwoSunsConfig.MINUTES_PER_DAY;   // the sunset is after local midnight
        }
        sky.rise = rise;
        sky.set = set;
        sky.classify(now, rise, set, gRise, today, tomorrow);
        return sky;
    }

    // Before sunrise, day or after sunset. Known edge: on a day whose sunset is after local midnight
    // (Reykjavik in June) the minutes from 00:00 to that sunset read "before sunrise", because Garmin's
    // pair describes the date that is starting, not the sun that is still up from yesterday.
    function classify(now as Number, rise as Number or Null, set as Number or Null, gRise as Number or Null,
                      today as TwoSunsSunDay or Null, tomorrow as TwoSunsSunDay or Null) as Void {
        if (rise != null && now < rise) {
            state = TwoSunsConfig.SKY_BEFORE_SUNRISE;
            nextRise = rise;
        } else if (set != null && now >= set) {
            state = TwoSunsConfig.SKY_AFTER_SUNSET;
            setTomorrowsSunrise(gRise, today, tomorrow);
        } else {
            state = TwoSunsConfig.SKY_DAY;
            lightLeft = set == null ? null : set - now;
            golden = isGolden(now, rise, set, today);
        }
    }

    // Garmin gives seconds since local midnight, 0 to 86399, or null.
    static function garminMinute(seconds as Number or Null) as Number or Null {
        if (seconds == null || seconds < 0 || seconds >= TwoSunsConfig.SECONDS_PER_DAY) {
            return null;
        }
        return seconds / TwoSunsConfig.SECONDS_PER_MINUTE;
    }

    // Neither sunrise nor sunset exists today: polar day or night if we can calculate, else say why not.
    static function noTimesState(hasComplications as Boolean, today as TwoSunsSunDay or Null) as Number {
        if (today == null) {
            return noCalculationState(hasComplications);
        }
        return today.kind == TwoSunsConfig.SUN_UP_ALL_DAY ? TwoSunsConfig.SKY_MIDNIGHT_SUN : TwoSunsConfig.SKY_POLAR_NIGHT;
    }

    // No calculation, because the watch has no place yet. Pro says so; the sentence points at what fixes it.
    (:pro)
    static function noCalculationState(hasComplications as Boolean) as Number {
        return hasComplications ? TwoSunsConfig.SKY_NO_PLACE : TwoSunsConfig.SKY_NO_DATA;
    }

    // Free never has a place and never asks for one, so "No place yet" would be a standing promise it cannot keep:
    // Garmin's pair is all there is, and when it is null the face says "No sun data" (docs/decisions.md ADR-020, Free + Pro ladder).
    (:free)
    static function noCalculationState(hasComplications as Boolean) as Number {
        return TwoSunsConfig.SKY_NO_DATA;
    }

    // Tomorrow's sunrise = calculated tomorrow + (Garmin's today - calculated today), so it keeps Garmin's
    // offset (docs/spec.md D6). With no calculation the best there is is today's sunrise, flagged.
    function setTomorrowsSunrise(garminRise as Number or Null, today as TwoSunsSunDay or Null, tomorrow as TwoSunsSunDay or Null) as Void {
        var next = null;
        var tomorrowRise = tomorrow == null ? null : tomorrow.rise;
        var todayRise = today == null ? null : today.rise;
        if (tomorrow != null && tomorrow.kind != TwoSunsConfig.SUN_NORMAL) {
            // Polar night (no sunrise ever) and midnight sun starting tomorrow (already up, so no
            // sunrise to wait for) both leave tomorrowRise null; either way there is no next rise.
            noNextRise = true;
        } else if (tomorrowRise != null) {
            next = garminRise != null && todayRise != null ? tomorrowRise + garminRise - todayRise : tomorrowRise;
        } else if (garminRise != null) {
            next = garminRise;
            nextRiseIsToday = true;
        }
        if (next != null) {
            var day = TwoSunsConfig.MINUTES_PER_DAY;
            nextRise = ((next % day) + day) % day;
        }
    }

    // The golden hour: the sun above the horizon and below 6 degrees (own calculation; needs a place).
    static function isGolden(now as Number, rise as Number or Null, set as Number or Null, today as TwoSunsSunDay or Null) as Boolean {
        if (today == null) {
            return false;
        }
        var morningEnd = today.goldenMorningEnd;
        var eveningStart = today.goldenEveningStart;
        var morning = rise != null && morningEnd != null && now >= rise && now < morningEnd;
        var evening = set != null && eveningStart != null && now >= eveningStart && now < set;
        return morning || evening;
    }
}
