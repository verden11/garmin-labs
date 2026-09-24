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
        var y = HeroSetDraw.title(dc, layout, header());
        var lines = pageLines();
        for (var i = 0; i < lines.size(); i++) {
            HeroSetDraw.text(dc, layout, layout.centerX(), y, Graphics.FONT_XTINY, lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += dc.getFontHeight(Graphics.FONT_XTINY);
        }

        HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), y, HeroSetText.load(HeroSetInput.touchFirst() ? Rez.Strings.validation_log_hint_touch : Rez.Strings.validation_log_hint));
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
