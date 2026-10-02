import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Dev-only viewer for the on-device validation log (ADR-026): pages through
// recent detected-vs-corrected rep trials so results can be read/transcribed
// off the watch face without a USB/live-debug connection — neither works
// reliably for reading arbitrary app Storage on this device (see
// docs/development.md).
class HeroSetValidationLogView extends WatchUi.View {

    private const PAGE_SIZE = 3;
    private const LOG_STAMP_LENGTH = 5;

    private var _entries as Lang.Array<Lang.String>;
    private var _page as Lang.Number = 0;

    function initialize() {
        View.initialize();
        // Newest first — the entries a tester just recorded are the ones worth
        // reading without paging through the whole log.
        _entries = getApp().getStore().getValidationLog().reverse() as Lang.Array<Lang.String>;
    }

    function pageCount() as Lang.Number {
        if (_entries.size() == 0) {
            return 1;
        }
        return (_entries.size() + PAGE_SIZE - 1) / PAGE_SIZE;
    }

    function nextPage() as Void {
        _page = (_page + 1) % pageCount();
        WatchUi.requestUpdate();
    }

    function previousPage() as Void {
        _page = (_page - 1 + pageCount()) % pageCount();
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        var layout = new HeroSetLayout(dc);
        dc.setColor(HeroSetPalette.TEXT, HeroSetPalette.BACKGROUND);
        dc.clear();
        // Rows stack by measured height: at fixed bands the header clipped
        // or overlapped the first line (ADR-034).
        // Log lines are too wide for the band beside a subscreen window, so
        // they start below it (ADR-056).
        var y = layout.belowWindow(HeroSetDraw.title(dc, layout, header()));
        var lines = pageLines();
        for (var i = 0; i < lines.size(); i++) {
            HeroSetDraw.centered(dc, layout, y, Graphics.FONT_XTINY, fitted(dc, layout, y, lines[i]));
            y += dc.getFontHeight(Graphics.FONT_XTINY);
        }

        HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), y, HeroSetText.load(HeroSetInput.touchFirst() ? Rez.Strings.validation_log_hint_touch : Rez.Strings.validation_log_hint));
    }

    // A line wider than the display loses its leading date/time stamp (five
    // characters, "mmdd " or "HH:MM"): the widest synthetic line of the
    // screen-fit test overflows a 176 px square. Measured against the same
    // chord the fit test checks, so a line that fits is never touched.
    private function fitted(dc as Dc, layout as HeroSetLayout, y as Lang.Number, line as Lang.String) as Lang.String {
        var candidates = [line, line.substring(LOG_STAMP_LENGTH, null) as Lang.String] as Lang.Array<Lang.String>;
        return HeroSetDraw.firstFitting(dc, layout, layout.displayRadius(), 0, y, Graphics.FONT_XTINY, candidates);
    }

    private function header() as Lang.String {
        if (_entries.size() == 0) {
            return HeroSetText.load(Rez.Strings.validation_log_empty);
        }
        return HeroSetText.format(Rez.Strings.validation_log_page, [_page + 1, pageCount()]);
    }

    private function pageLines() as Lang.Array<Lang.String> {
        var start = _page * PAGE_SIZE;
        var lines = [];
        for (var i = start; i < start + PAGE_SIZE && i < _entries.size(); i++) {
            lines.add(_entries[i]);
        }
        return lines;
    }
}
