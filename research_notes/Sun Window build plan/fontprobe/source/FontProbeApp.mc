import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// Throwaway measurement stub (plan P2.1, simulator only): logs the glance and full-view drawing areas, the font heights
// and the pixel width of every candidate string, so the mockup is drawn at real sizes. Lines start with "FP".
(:glance)
class FontProbeApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getGlanceView() as [WatchUi.GlanceView] or [WatchUi.GlanceView, WatchUi.GlanceViewDelegate] or Null {
        return [new FontProbeGlance()];
    }

    (:typecheck(disableGlanceCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new FontProbeView()];
    }
}

(:glance)
module FontProbe {
    const WORDS = ["OPEN", "CLOSED", "NONE TODAY", "Open", "Closed", "None today", "Opens 11:10", "Opens 9:05",
        "Closed for today", "Cloud cover", "Sun stays low", "Sun stays low today", "Open once", "Open the app once",
        "Finding your place", "No place yet", "No weather", "10:26-16:16", "10:26", "16:16", "Closes 16:16",
        "Sun Window"];

    function measure(dc as Graphics.Dc, tag as String, fonts as Array<Graphics.FontDefinition>, names as Array<String>) as Void {
        System.println("FP " + tag + " dc " + dc.getWidth() + "x" + dc.getHeight());
        for (var f = 0; f < fonts.size(); f++) {
            var line = "FP " + tag + " " + names[f] + " h" + dc.getFontHeight(fonts[f]);
            for (var w = 0; w < WORDS.size(); w++) {
                line += " | " + WORDS[w] + "=" + dc.getTextWidthInPixels(WORDS[w], fonts[f]);
            }
            System.println(line);
        }
    }
}

(:glance)
class FontProbeGlance extends WatchUi.GlanceView {
    var done as Boolean = false;

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(0, 0, Graphics.FONT_GLANCE, "CLOSED", Graphics.TEXT_JUSTIFY_LEFT);
        if (!done) {
            done = true;
            FontProbe.measure(dc, "glance", [Graphics.FONT_GLANCE, Graphics.FONT_GLANCE_NUMBER, Graphics.FONT_XTINY, Graphics.FONT_TINY],
                ["GLANCE", "GLANCE_NUMBER", "XTINY", "TINY"]);
        }
    }
}

class FontProbeView extends WatchUi.View {
    var done as Boolean = false;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "FULL", Graphics.TEXT_JUSTIFY_CENTER);
        if (!done) {
            done = true;
            var sub = (WatchUi has :getSubscreen) ? WatchUi.getSubscreen() : null;
            System.println("FP full subscreen " + (sub == null ? "none" : sub.x + "," + sub.y + " " + sub.width + "x" + sub.height));
            FontProbe.measure(dc, "full", [Graphics.FONT_XTINY, Graphics.FONT_TINY, Graphics.FONT_SMALL, Graphics.FONT_MEDIUM,
                Graphics.FONT_LARGE, Graphics.FONT_NUMBER_MILD, Graphics.FONT_NUMBER_MEDIUM, Graphics.FONT_NUMBER_HOT],
                ["XTINY", "TINY", "SMALL", "MEDIUM", "LARGE", "NUMBER_MILD", "NUMBER_MEDIUM", "NUMBER_HOT"]);
        }
    }
}
