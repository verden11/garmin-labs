import Toybox.Lang;

// The foreground-only words under the state word: why it is closed, today's times, and the empty and error states, each
// a plain sentence (never a blank, never a code). The sun or sky is the subject; no state is called good, bad, safe or
// enough (docs/release-contract.md).
class SunWindowReasons {

    // One line under the state word, or "" when there is none.
    static function reason(state as SunWindowState, is24Hour as Boolean) as String {
        var kind = state.kind;
        var day = state.day;
        if (kind == SunWindowConfig.STATE_CLOSED_BEFORE && day != null) {
            return Lang.format(SunWindowText.load(Rez.Strings.reason_opens), [SunWindowClock.text(day.open, is24Hour)]);
        }
        if (kind == SunWindowConfig.STATE_CLOSED_AFTER) {
            return SunWindowText.load(Rez.Strings.reason_closed_today);
        }
        if (kind == SunWindowConfig.STATE_CLOSED_SKY) {
            return SunWindowText.load(Rez.Strings.reason_sky);
        }
        if (kind == SunWindowConfig.STATE_NONE_TODAY) {
            return SunWindowText.load(Rez.Strings.reason_low);
        }
        if (kind == SunWindowConfig.STATE_OPEN && !state.skyKnown) {
            return SunWindowText.load(Rez.Strings.reason_no_weather);
        }
        if (kind == SunWindowConfig.STATE_NO_FIX) {
            return SunWindowText.load(Rez.Strings.no_place);
        }
        if (kind == SunWindowConfig.STATE_LOCATING || kind == SunWindowConfig.STATE_ONCE) {
            return SunWindowText.load(Rez.Strings.locating);
        }
        return "";
    }

    // The third row: today's window as clock times, the start hint when no place was found, else "".
    static function times(state as SunWindowState, is24Hour as Boolean) as String {
        var day = state.day;
        if (state.kind == SunWindowConfig.STATE_NO_FIX) {
            return SunWindowText.load(Rez.Strings.no_place_hint);
        }
        if (day == null || !day.hasWindow) {
            return "";
        }
        return SunWindowClock.range(day.open, day.close, is24Hour);
    }
}
