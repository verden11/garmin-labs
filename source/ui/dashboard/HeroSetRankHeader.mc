import Toybox.Graphics;
import Toybox.Lang;

// Lifetime progress at the top of the dashboard (ADR-031): the XP ring on
// the bezel, RANK N, and how much XP the next rank still needs. That last
// line is what tells the user what XP is for.
class HeroSetRankHeader {

    // Returns the y just below the header so the mission bars can stack
    // underneath it.
    static function draw(dc as Graphics.Dc, layout as HeroSetLayout, state as HeroSetDashboardState) as Lang.Number {
        drawRing(dc, layout, state);
        // First row starts where every other screen's first band does, pushed
        // down by the ring's width so the ring and rank never crowd each other.
        var top = layout.shortInset() + layout.ringWidth();
        var text = HeroSetText.format(Rez.Strings.dashboard_rank, [state.rank]);
        var fonts = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        var font = HeroSetDraw.largestFontWithin(dc, layout, layout.contentRadius(), top, text, fonts);
        dc.setColor(HeroSetPalette.GOLD, HeroSetPalette.BACKGROUND);
        dc.drawText(layout.centerX(), top, font, text, Graphics.TEXT_JUSTIFY_CENTER);

        var xpY = top + dc.getFontHeight(font);
        drawXpToNext(dc, layout, xpY, state);
        return xpY + dc.getFontHeight(Graphics.FONT_XTINY);
    }

    // Track first, then gold for the XP earned inside the current rank, so
    // the fill restarts empty at every rank-up.
    private static function drawRing(dc as Graphics.Dc, layout as HeroSetLayout, state as HeroSetDashboardState) as Void {
        var sweep = HeroSetLayout.ringSweepFor(HeroSetRules.xpIntoRank(state.xp), HeroSetRules.rankCost(state.rank));
        dc.setPenWidth(layout.ringWidth());
        drawRingArc(dc, layout, HeroSetPalette.TRACK, HeroSetLayout.RING_SWEEP_DEG);
        if (sweep > 0) {
            drawRingArc(dc, layout, HeroSetPalette.GOLD, sweep);
        }
    }

    private static function drawRingArc(dc as Graphics.Dc, layout as HeroSetLayout, color as Graphics.ColorType, sweep as Lang.Number) as Void {
        var start = HeroSetLayout.RING_START_DEG;
        dc.setColor(color, HeroSetPalette.BACKGROUND);
        dc.drawArc(layout.centerX(), layout.centerY(), layout.ringRadius(), Graphics.ARC_CLOCKWISE, start, HeroSetLayout.arcEndDegree(start, sweep));
    }

    // XP and ranks grow without bound, so a tighter wording is measured in
    // rather than assuming the long one always fits.
    private static function drawXpToNext(dc as Graphics.Dc, layout as HeroSetLayout, y as Lang.Number, state as HeroSetDashboardState) as Void {
        var toGo = HeroSetRules.xpToNextRank(state.xp);
        var candidates = [
            HeroSetText.format(Rez.Strings.dashboard_xp_to_rank, [toGo, state.rank + 1]),
            HeroSetText.format(Rez.Strings.dashboard_xp_to_go, [toGo])
        ] as Lang.Array<Lang.String>;
        var text = HeroSetDraw.firstFittingWithin(dc, layout, layout.contentRadius(), y, Graphics.FONT_XTINY, candidates);
        dc.setColor(HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
        dc.drawText(layout.centerX(), y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
