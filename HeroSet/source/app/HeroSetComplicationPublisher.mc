import Toybox.Complications;
import Toybox.Lang;

// Publishes today's progress as one private complication so HeroFace (the
// sibling watch face, same developer key) can show it. Private access means
// only our own apps ever read it, and nothing leaves the watch.
//
// Connect IQ 4.2+ only; on older watches (ADR-038 products cap at 3.4) the
// `has` check makes every call a no-op, and HeroFace falls back to its own
// everyday goals.
class HeroSetComplicationPublisher {

    // Must match the id in resources/complications.xml, and never change:
    // subscribers store it.
    private static const COMPLICATION_ID = 0;
    private static const VERSION = 1;
    private static const SEPARATOR = "|";

    static function publish(store as HeroSetStore) as Void {
        if (!(Toybox has :Complications)) {
            return;
        }
        var lastDay = store.getLastCompletionDay();
        var value = valueFor(store.getDashboardState(), HeroSetCalendar.todayKey(), lastDay);
        Complications.updateComplication(COMPLICATION_ID, {:value => value});
    }

    // "v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal"
    // (HeroFace docs/plan.md). The day keys let a subscriber tell today's
    // counts from yesterday's, because this only publishes while the app
    // runs. Field order never changes; new fields go on the end — `goal`
    // was appended without bumping VERSION, because a version a face does
    // not know makes it drop the whole value, while a tenth field it does
    // not know is simply ignored (ADR-045).
    static function valueFor(state as HeroSetDashboardState, today as Lang.Number, lastCompletionDay as Lang.Number?) as Lang.String {
        var cost = HeroSetRules.rankCost(state.rank);
        var percent = cost > 0 ? HeroSetRules.xpIntoRank(state.xp) * 100 / cost : 0;
        var fields = [
            VERSION,
            today,
            state.pushups,
            state.situps,
            state.squats,
            state.rank,
            percent,
            state.streak,
            lastCompletionDay != null ? lastCompletionDay : 0,
            state.goal
        ] as Lang.Array<Lang.Number>;
        var value = fields[0].toString();
        for (var i = 1; i < fields.size(); i++) {
            value += SEPARATOR + fields[i].toString();
        }
        return value;
    }
}
