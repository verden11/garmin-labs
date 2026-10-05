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
        // The window's ring is out of the text's way, so no push there. On a
        // rectangle the rows start at the top of the track's inner box (ADR-057).
        var track = layout.track();
        var top = track != null ? track.contentTop() : layout.shortInset() + (layout.subscreen() == null ? layout.ringWidth() : 0);
        var text = HeroSetText.format(Rez.Strings.dashboard_rank, [state.rank]);
        var fonts = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        if (track != null) {
            // The rectangle's box has room above the rows that the round
            // ring's top chord does not: the rank takes it, the first read.
            fonts = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_XTINY] as Lang.Array<Graphics.FontDefinition>;
        }
        var font = HeroSetDraw.largestFont(dc, layout, layout.contentRadius(), 0, top, text, fonts);
        dc.setColor(HeroSetPalette.GOLD, HeroSetPalette.BACKGROUND);
        HeroSetDraw.centered(dc, layout, top, font, text);

        var xpY = top + dc.getFontHeight(font);
        if (layout.subscreen() != null) {
            // The window's gauge already says how far the next rank is, and
            // the band beside it is too narrow for the words (ADR-055).
            return xpY;
        }
        drawXpToNext(dc, layout, xpY, state);
        return xpY + dc.getFontHeight(Graphics.FONT_XTINY);
    }

    // Track first, then gold for the XP earned inside the current rank, so
    // the fill restarts empty at every rank-up.
    private static function drawRing(dc as Graphics.Dc, layout as HeroSetLayout, state as HeroSetDashboardState) as Void {
        var part = HeroSetRules.xpIntoRank(state.xp);
        var whole = HeroSetRules.rankCost(state.rank);
        var track = layout.track();
        if (track != null) {
            // The rectangle's ring follows the screen, closed (ADR-057).
            dc.setColor(HeroSetPalette.TRACK, HeroSetPalette.BACKGROUND);
            track.draw(dc, track.length());
            dc.setColor(HeroSetPalette.GOLD, HeroSetPalette.BACKGROUND);
            track.draw(dc, track.fillFor(part, whole));
            return;
        }
        var sweep = HeroSetLayout.ringSweepFor(part, whole);
        var window = layout.windowRing();
        if (window != null) {
            drawWindowRing(dc, window, sweep);
            return;
        }
        dc.setPenWidth(layout.ringWidth());
        drawRingArc(dc, layout, HeroSetPalette.TRACK, HeroSetLayout.RING_SWEEP_DEG);
        if (sweep > 0) {
            drawRingArc(dc, layout, HeroSetPalette.GOLD, sweep);
        }
    }

    // The Instinct's window is a gauge of its own (ADR-055): the XP ring's
    // track is a hairline circle (a 1-bit display has no dim shade) and the
    // fill a thick arc along its inside, leaving the same gap at the bottom.
    private static function drawWindowRing(dc as Graphics.Dc, window as [Lang.Number, Lang.Number, Lang.Number, Lang.Number], sweep as Lang.Number) as Void {
        dc.setColor(HeroSetPalette.TRACK, HeroSetPalette.BACKGROUND);
        dc.setPenWidth(1);
        dc.drawCircle(window[0], window[1], window[2]);
        if (sweep > 0) {
            var start = HeroSetLayout.RING_START_DEG;
            dc.setColor(HeroSetPalette.GOLD, HeroSetPalette.BACKGROUND);
            dc.setPenWidth(window[3]);
            dc.drawArc(window[0], window[1], window[2] - window[3] / 2, Graphics.ARC_CLOCKWISE, start, HeroSetLayout.arcEndDegree(start, sweep));
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
        var text = HeroSetDraw.firstFitting(dc, layout, layout.contentRadius(), 0, y, Graphics.FONT_XTINY, candidates);
        dc.setColor(HeroSetPalette.MUTED, HeroSetPalette.BACKGROUND);
        HeroSetDraw.centered(dc, layout, y, Graphics.FONT_XTINY, text);
    }
}
