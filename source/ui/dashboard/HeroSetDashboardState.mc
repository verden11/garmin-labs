import Toybox.Lang;

class HeroSetDashboardState {
    var pushups as Lang.Number;
    var situps as Lang.Number;
    var squats as Lang.Number;
    var runKm as Lang.Float;
    var rank as Lang.Number;
    var streak as Lang.Number;
    var storageWarning as Lang.Boolean;

    function initialize(pushups as Lang.Number, situps as Lang.Number, squats as Lang.Number, runKm as Lang.Float, rank as Lang.Number, streak as Lang.Number, storageWarning as Lang.Boolean) {
        self.pushups = pushups;
        self.situps = situps;
        self.squats = squats;
        self.runKm = runKm;
        self.rank = rank;
        self.streak = streak;
        self.storageWarning = storageWarning;
    }
}
