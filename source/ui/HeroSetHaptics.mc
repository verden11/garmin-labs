import Toybox.Attention;
import Toybox.Lang;

// Feedback tiers are told apart by pulse count alone (1 = rep, 2 = one
// exercise hit its goal, 3 = whole daily mission, 4 = new rank), since the wrist is
// usually mid-movement and not looking at the screen.
class HeroSetHaptics {

    static function rep() as Void {
        pulses(1);
    }

    static function goalReached() as Void {
        pulses(2);
    }

    static function missionComplete() as Void {
        pulses(3);
    }

    static function rankUp() as Void {
        pulses(4);
    }

    // Built from the rep pulse timing so every tier feels like the same
    // family of tap, just repeated.
    private static function pulses(count as Lang.Number) as Void {
        if (!(Attention has :vibrate)) {
            return;
        }
        var profiles = [] as Lang.Array<Attention.VibeProfile>;
        for (var i = 0; i < count; i++) {
            if (i > 0) {
                profiles.add(new Attention.VibeProfile(0, HeroSetConfig.REP_VIBE_DURATION_MS));
            }
            profiles.add(new Attention.VibeProfile(HeroSetConfig.REP_VIBE_DUTY_CYCLE, HeroSetConfig.REP_VIBE_DURATION_MS));
        }
        Attention.vibrate(profiles);
    }
}
