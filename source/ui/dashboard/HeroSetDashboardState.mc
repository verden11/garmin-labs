import Toybox.Lang;

class HeroSetDashboardState {
    var pushups as Lang.Number;
    var situps as Lang.Number;
    var squats as Lang.Number;
    var xp as Lang.Number;
    var rank as Lang.Number;
    var streak as Lang.Number;
    var storageWarning as Lang.Boolean;

    function initialize(pushups as Lang.Number, situps as Lang.Number, squats as Lang.Number, xp as Lang.Number, rank as Lang.Number, streak as Lang.Number, storageWarning as Lang.Boolean) {
        self.pushups = pushups;
        self.situps = situps;
        self.squats = squats;
        self.xp = xp;
        self.rank = rank;
        self.streak = streak;
        self.storageWarning = storageWarning;
    }
}
