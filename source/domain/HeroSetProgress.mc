import Toybox.Lang;

class HeroSetProgress {

    static function progress(count as Lang.Number, goal as Lang.Number) as Lang.Number {
        if (goal <= 0 || count <= 0) {
            return 0;
        }
        if (count >= goal) {
            return 100;
        }
        return (count * 100) / goal;
    }

    static function xpForReps(reps as Lang.Number) as Lang.Number {
        return reps <= 0 ? 0 : reps * 2;
    }

    static function rankForXp(xp as Lang.Number) as Lang.Number {
        return (xp < 0 ? 0 : xp) / 100 + 1;
    }

    static function missionComplete(pushups as Lang.Number, situps as Lang.Number, squats as Lang.Number) as Lang.Boolean {
        return pushups >= 100 && situps >= 100 && squats >= 100;
    }

    // Streak from day keys (yyyy*10000+mm*100+dd), never from epoch seconds.
    // `lastDay == null` means this is the first completion ever.
    static function nextStreak(lastDay, todayDay as Lang.Number, currentStreak as Lang.Number) as Lang.Number {
        if (lastDay == null) {
            return 1;
        }
        if (lastDay == todayDay) {
            return currentStreak;
        }
        if (HeroSetCalendar.isConsecutiveDate(lastDay, todayDay)) {
            return currentStreak + 1;
        }
        return 1;
    }
}
