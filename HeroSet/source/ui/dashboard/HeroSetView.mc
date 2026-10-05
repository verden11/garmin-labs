import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Home screen (ADR-031): rank header and XP ring on top, today's mission
// bars in the middle, streak and footer at the bottom.
class HeroSetView extends WatchUi.View {

    private var _dayTracker;
    private var _missionBars as HeroSetMissionBars;
    private var _hint as Lang.String;
    private var _complete as Lang.String;
    private var _warning as Lang.String;

    function initialize() {
        View.initialize();
        _dayTracker = new HeroSetDayTracker();
        _missionBars = new HeroSetMissionBars();
        _hint = HeroSetText.load(Rez.Strings.dashboard_hint);
        _complete = HeroSetText.load(Rez.Strings.dashboard_mission_complete);
        _warning = HeroSetText.load(Rez.Strings.dashboard_storage_warning);
    }

    function onUpdate(dc as Dc) as Void {
        drawState(dc, getApp().getStore().getDashboardState());
    }

    // Split from onUpdate so a state can be drawn without the app's store
    // (layout measurement against a buffered bitmap). The header stacks down
    // from the top, the footer and streak stack up from the bottom, and the
    // mission bars take whatever is left between.
    function drawState(dc as Dc, state as HeroSetDashboardState) as Void {
        var layout = new HeroSetLayout(dc);

        dc.setColor(HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        dc.clear();
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        var headerBottom = HeroSetRankHeader.draw(dc, layout, state);
        var footerY = footerTop(dc, layout);
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        // Beside a subscreen window the streak moves up under the rank, into
        // the band left of the window, and the mission bars start below the
        // window; the screen is too short for the usual stack (ADR-055).
        // Elsewhere the streak stacks above the footer.
        var beside = layout.subscreen() != null;
        var streakY = beside ? headerBottom : footerY - line;
        var barsTop = (beside ? layout.belowWindow(headerBottom + line) : headerBottom) + layout.stackGap();
        var barsBottom = (beside ? footerY : streakY) - layout.stackGap();
        var counts = [state.pushups, state.situps, state.squats] as Lang.Array<Lang.Number>;
        _missionBars.draw(dc, layout, barsTop, barsBottom, counts, state.goal);
        drawStreak(dc, layout, streakY, state);
        drawFooter(dc, layout, footerY, state);
    }

    function onShow() as Void {
        _dayTracker.start();
    }

    function onHide() as Void {
        _dayTracker.stop();
    }

    // One y for every footer state, fitted to the widest of them, so the bars
    // above never shift when the footer text changes. It lands in the ring's
    // bottom gap; on a rectangle, on the floor of the track's inner box (ADR-057).
    function footerTop(dc as Dc, layout as HeroSetLayout) as Lang.Number {
        var track = layout.track();
        var line = dc.getFontHeight(Graphics.FONT_XTINY);
        if (track != null) {
            return track.contentBottom() - line;
        }
        var texts = [_hint, _complete, _warning] as Lang.Array<Lang.String>;
        var widest = 0;
        for (var i = 0; i < texts.size(); i++) {
            var width = dc.getTextWidthInPixels(texts[i], Graphics.FONT_XTINY);
            widest = width > widest ? width : widest;
        }
        return layout.fitCenteredY(layout.footerRowBottom(), layout.centerY(), widest, line);
    }

    // Completing today is what extends the run, so the line turns gold the
    // moment MISSION COMPLETE appears under it; until then it is a muted
    // reminder of what is at stake. No streak says so in words, not a bare 0.
    private function drawStreak(dc as Dc, layout as HeroSetLayout, y as Lang.Number, state as HeroSetDashboardState) as Void {
        var none = HeroSetText.load(Rez.Strings.dashboard_streak_none);
        var shortText = HeroSetText.format(Rez.Strings.dashboard_streak_short, [state.streak]);
        // "NO STREAK YET" stays unmeasured wherever it always fit. Beside a subscreen window, where it does not fit, a zero
        // streak draws nothing: "STREAK 0" read as a failure on day one (design critique 2026-10-05, ROADMAP 13.23). A
        // streak too long even for "STREAK 9999" there shows the bare number.
        if (state.streak == 0 && layout.subscreen() != null && !HeroSetDraw.fits(dc, layout, layout.contentRadius(), 0, y, none, Graphics.FONT_XTINY)) {
            return;
        }
        var candidates = state.streak > 0 ? [HeroSetText.format(Rez.Strings.dashboard_streak, [state.streak]), shortText] : [none];
        if (layout.subscreen() != null && state.streak > 0) {
            candidates.add(state.streak.toString());
        }
        var text = HeroSetDraw.firstFitting(dc, layout, layout.contentRadius(), 0, y, Graphics.FONT_XTINY, candidates as Lang.Array<Lang.String>);
        var extendedToday = state.streak > 0 && HeroSetRules.missionComplete(state.pushups, state.situps, state.squats, state.goal);
        dc.setColor(extendedToday ? HeroSetPalette.GOLD : HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
        HeroSetDraw.centered(dc, layout, y, Graphics.FONT_XTINY, text);
    }

    // A storage failure outranks everything (the numbers on screen may not
    // survive a restart); a finished day replaces the menu hint with the
    // payoff, since there's nothing left the hint needs to lead to.
    private function drawFooter(dc as Dc, layout as HeroSetLayout, y as Lang.Number, state as HeroSetDashboardState) as Void {
        var text = _hint;
        var color = HeroSetPalette.MUTED;
        // The Instinct's bezel leaves the bottom row about 100 px (ADR-055): the long wordings fall back to a short one
        // instead of being cut mid-word ("DONE" is already translated for the mission rows; the warning keeps its "!").
        // A rectangle's bottom row is cut by the XP track's rounded corners the same way (ADR-057).
        var shorter = null;
        if (state.storageWarning) {
            text = _warning;
            color = HeroSetPalette.ALERT;
            shorter = "!";
        } else if (HeroSetRules.missionComplete(state.pushups, state.situps, state.squats, state.goal)) {
            text = _complete;
            color = HeroSetPalette.DONE;
            shorter = HeroSetText.load(Rez.Strings.menu_sublabel_done);
        }
        var track = layout.track();
        if (shorter != null && track != null && dc.getTextWidthInPixels(text, Graphics.FONT_XTINY) > track.innerWidth(y, dc.getFontHeight(Graphics.FONT_XTINY))) {
            text = shorter;
        } else if (shorter != null && layout.subscreen() != null) {
            text = HeroSetDraw.firstFitting(dc, layout, layout.displayRadius(), 0, y, Graphics.FONT_XTINY, [text, shorter] as Lang.Array<Lang.String>);
        }
        dc.setColor(color, HeroSetPalette.BACKGROUND);
        HeroSetDraw.centered(dc, layout, y, Graphics.FONT_XTINY, text);
    }
}
