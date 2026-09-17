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
        var streakY = footerY - dc.getFontHeight(Graphics.FONT_XTINY);
        var counts = [state.pushups, state.situps, state.squats] as Lang.Array<Lang.Number>;
        _missionBars.draw(dc, layout, headerBottom + layout.stackGap(), streakY - layout.stackGap(), counts);
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
    // bottom gap.
    function footerTop(dc as Dc, layout as HeroSetLayout) as Lang.Number {
        var texts = [_hint, _complete, _warning] as Lang.Array<Lang.String>;
        var widest = 0;
        for (var i = 0; i < texts.size(); i++) {
            var width = dc.getTextWidthInPixels(texts[i], Graphics.FONT_XTINY);
            widest = width > widest ? width : widest;
        }
        return layout.fitCenteredY(layout.footerRowBottom(), layout.centerY(), widest, dc.getFontHeight(Graphics.FONT_XTINY));
    }

    // Completing today is what extends the run, so the line turns gold the
    // moment MISSION COMPLETE appears under it; until then it is a muted
    // reminder of what is at stake. No streak says so in words, not a bare 0.
    private function drawStreak(dc as Dc, layout as HeroSetLayout, y as Lang.Number, state as HeroSetDashboardState) as Void {
        var text = HeroSetText.load(Rez.Strings.dashboard_streak_none);
        if (state.streak > 0) {
            var candidates = [
                HeroSetText.format(Rez.Strings.dashboard_streak, [state.streak]),
                HeroSetText.format(Rez.Strings.dashboard_streak_short, [state.streak])
            ] as Lang.Array<Lang.String>;
            text = HeroSetDraw.firstFittingWithin(dc, layout, layout.contentRadius(), y, Graphics.FONT_XTINY, candidates);
        }
        var extendedToday = state.streak > 0 && HeroSetRules.missionComplete(state.pushups, state.situps, state.squats);
        dc.setColor(extendedToday ? HeroSetPalette.GOLD : HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
        dc.drawText(layout.centerX(), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // A storage failure outranks everything (the numbers on screen may not
    // survive a restart); a finished day replaces the menu hint with the
    // payoff, since there's nothing left the hint needs to lead to.
    private function drawFooter(dc as Dc, layout as HeroSetLayout, y as Lang.Number, state as HeroSetDashboardState) as Void {
        var text = _hint;
        var color = HeroSetPalette.MUTED;
        if (state.storageWarning) {
            text = _warning;
            color = HeroSetPalette.ALERT;
        } else if (HeroSetRules.missionComplete(state.pushups, state.situps, state.squats)) {
            text = _complete;
            color = HeroSetPalette.DONE;
        }
        dc.setColor(color, HeroSetPalette.BACKGROUND);
        dc.drawText(layout.centerX(), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
