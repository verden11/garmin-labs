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
        _entries = newestFirst(getApp().getStore().getValidationLog());
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
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(layout.centerX(), layout.bandTop(0), Graphics.FONT_SMALL, header(), Graphics.TEXT_JUSTIFY_CENTER);

        var lines = pageLines();
        for (var i = 0; i < lines.size(); i++) {
            dc.drawText(layout.centerX(), layout.bandTop(i + 1), Graphics.FONT_XTINY, lines[i], Graphics.TEXT_JUSTIFY_CENTER);
        }

        HeroSetDraw.hint(dc, layout, layout.footerRowBottom(), layout.bandTop(PAGE_SIZE + 1), HeroSetText.load(Rez.Strings.validation_log_hint));
    }

    private function header() as Lang.String {
        if (_entries.size() == 0) {
            return "NO LOG DATA";
        }
        return "LOG " + (_page + 1) + "/" + pageCount();
    }

    private function pageLines() as Lang.Array<Lang.String> {
        var start = _page * PAGE_SIZE;
        var lines = [];
        for (var i = start; i < start + PAGE_SIZE && i < _entries.size(); i++) {
            lines.add(_entries[i]);
        }
        return lines;
    }

    // Newest entries first — the ones a tester just recorded are the ones
    // worth reading without paging through the whole log.
    private function newestFirst(entries as Lang.Array<Lang.String>) as Lang.Array<Lang.String> {
        var reversed = [];
        for (var i = entries.size() - 1; i >= 0; i--) {
            reversed.add(entries[i]);
        }
        return reversed;
    }
}
