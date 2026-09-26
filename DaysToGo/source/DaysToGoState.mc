import Toybox.Lang;

// Everything the view draws, already in words. The view never computes.
class DaysToGoState {
    var phase as Number = DaysToGoConfig.PHASE_UPCOMING;
    var hero as String = "";
    var heroIsWord as Boolean = false;   // TODAY / SET A DATE: needs a letter font, not a number font
    var captionLines as Array<String> = [] as Array<String>;   // longest first
    var name as String = "";
    var dateLines as Array<String> = [] as Array<String>;      // longest first
    var time as String = "";
    var ringPermille as Number = 0;      // share of the ring still to go, 0 to 1000
    var ringTrack as Boolean = true;
    var accent as Number = DaysToGoPalette.ACCENTS[0];
    var footer as String? = null;
}
