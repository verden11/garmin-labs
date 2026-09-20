import Toybox.Lang;

// Everything one frame shows, gathered before drawing (HeroFaceReadings) so
// drawing is pure and the screen-fit test can render its widest states.
class HeroFaceState {
    var time as String = "";
    // Null when seconds are off or not shown in this power mode.
    var seconds as String?;
    // Wordings longest first; the first that fits is drawn.
    var dateLines as Array<String> = [] as Array<String>;
    // Null where the watch has no weather, or the user turned it off.
    var temperature as String?;
    // Empty when there is no streak to show (no step goal on this watch).
    var streakLines as Array<String> = [] as Array<String>;
    // Gold only for something the user keeps; a zero streak stays muted.
    var streakKept as Boolean = false;
    var metrics as Array<HeroFaceMetric> = [] as Array<HeroFaceMetric>;
    var ringPermille as Number = 0;
    var ringColor as Number = HeroFacePalette.ACCENTS[0];
    var accent as Number = HeroFacePalette.ACCENTS[0];
    var battery as Number = 0;
    var heartRate as Number?;
    var notifications as Number = 0;

    function initialize() {
    }
}
