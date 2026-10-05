import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Position;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Timer;
import Toybox.Weather;
import Toybox.WatchUi;

// Throwaway spike probe for Sun Window (reports/Sun Window build plan.md, P1.1). Not the product, not its code.
// Answers on the owner's FR965 what the simulator cannot:
//   D2  are Weather uvIndex / cloudCover filled in (current conditions and the first hourly entry)?
//   D6  does Position.getInfo() give a usable place in the full view, cold-launched and glance-launched,
//       and how long does LOCATION_ONE_SHOT take? (glance: getInfo only after MENU turns "glance-pos" on)
//   D7  does the glance show up and draw from a sideload (the counter moves on each draw)?
//   D11 which press reaches onMenu (the "menu" counter)?
//   D12 how long does the app stay open when launched from the glance ("last run" on the next open)?
// The glance never writes Storage. Every line is also printed to the log (System.println).
(:glance)
class SunProbeApp extends Application.AppBase {
    var fromGlance as Boolean = false;

    function initialize() {
        AppBase.initialize();
    }

    // Runs for the glance process too: reads only, writes nothing.
    function onStart(state as Dictionary?) as Void {
        if (state != null) {
            fromGlance = SunProbeText.isTrue(state.get(:launchedFromGlance));
        }
    }

    function getGlanceView() as [WatchUi.GlanceView] or [WatchUi.GlanceView, WatchUi.GlanceViewDelegate] or Null {
        return [new SunProbeGlance()];
    }

    (:typecheck(disableGlanceCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new SunProbeView(fromGlance);
        return [view, new SunProbeDelegate(view)];
    }
}

(:glance)
module SunProbeText {
    function hm(m as Time.Moment or Null) as String {
        if (m == null) {
            return "null";
        }
        var i = Gregorian.info(m, Time.FORMAT_SHORT);
        return i.hour.format("%02d") + ":" + i.min.format("%02d") + ":" + i.sec.format("%02d");
    }

    function isTrue(v as Object or Null) as Boolean {
        return v instanceof Boolean && v;
    }

    function flag(key as String) as Boolean {
        return isTrue(Application.Storage.getValue(key));
    }

    function str(v as Object or Null) as String {
        if (v == null) {
            return "null";
        }
        if (v instanceof Float || v instanceof Double) {
            return v.format("%.1f");
        }
        return v.toString();
    }

    function weatherLines() as Array<String> {
        var out = [] as Array<String>;
        try {
            var c = Weather.getCurrentConditions();
            if (c == null) {
                out.add("cur null");
            } else {
                out.add("cur uv " + str(c.uvIndex) + " cc " + str(c.cloudCover) + " obs " + hm(c.observationTime));
            }
        } catch (e) {
            out.add("cur EXC");
        }
        try {
            var h = Weather.getHourlyForecast();
            if (h == null) {
                out.add("h0 null");
            } else if (h.size() == 0) {
                out.add("h0 n=0");
            } else {
                var f = h[0];
                out.add("h0 uv " + str(f.uvIndex) + " cc " + str(f.cloudCover) + " @" + hm(f.forecastTime) + " n" + h.size());
            }
        } catch (e) {
            out.add("h0 EXC");
        }
        return out;
    }

    // Glance-sized: "c <uv>/<cloud> h <uv>/<cloud>" for current conditions and the first hourly entry.
    function compactWeather() as String {
        var c = "?";
        var h = "?";
        try {
            var cur = Weather.getCurrentConditions();
            c = cur == null ? "null" : str(cur.uvIndex) + "/" + str(cur.cloudCover);
        } catch (e) {
            c = "EXC";
        }
        try {
            var hours = Weather.getHourlyForecast();
            h = (hours == null || hours.size() == 0) ? "null" : str(hours[0].uvIndex) + "/" + str(hours[0].cloudCover);
        } catch (e) {
            h = "EXC";
        }
        return "c " + c + " h " + h;
    }

    function compactPos() as String {
        try {
            var i = Position.getInfo();
            var when = i.when;
            var age = when == null ? "?" : (Time.now().value() - when.value()).toString();
            return "q" + i.accuracy + " " + age + "s " + (i.position == null ? "nopos" : "pos");
        } catch (e) {
            return "pos EXC";
        }
    }

    function posLine() as String {
        try {
            var i = Position.getInfo();
            var when = i.when;
            var age = when == null ? "?" : (Time.now().value() - when.value()).toString() + "s";
            var p = i.position;
            var where = "null";
            if (p != null) {
                var d = p.toDegrees();
                where = d[0].format("%.1f") + "," + d[1].format("%.1f");
            }
            return "pos q" + i.accuracy + " age " + age + " " + where;
        } catch (e) {
            return "pos EXC";
        }
    }

    function draw(dc as Graphics.Dc, lines as Array<String>, centred as Boolean) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var font = Graphics.FONT_XTINY;
        var fh = dc.getFontHeight(font);
        // The glance gets a small top inset: on round watches the card's top edge sits under the bezel curve.
        var y = centred ? (dc.getHeight() - lines.size() * fh) / 2 : fh / 4;
        var x = centred ? dc.getWidth() / 2 : 0;
        var just = centred ? Graphics.TEXT_JUSTIFY_CENTER : Graphics.TEXT_JUSTIFY_LEFT;
        for (var k = 0; k < lines.size(); k++) {
            dc.drawText(x, y + k * fh, font, lines[k], just);
            System.println("SWPROBE " + lines[k]);
        }
    }
}

// No background fill: an opaque clear would wipe the system's themed glance card.
(:glance)
class SunProbeGlance extends WatchUi.GlanceView {
    var draws as Number = 0;

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        draws += 1;
        var place = Application.Storage.getValue("place") == null ? " pl-" : " pl+";
        var lines = ["#" + draws + " " + SunProbeText.hm(Time.now()).substring(0, 5) + place] as Array<String>;
        lines.add(SunProbeText.compactWeather());
        if (SunProbeText.flag("gpos")) {
            lines.add(SunProbeText.compactPos());
        }
        SunProbeText.draw(dc, lines, false);
    }
}

class SunProbeView extends WatchUi.View {
    var fromGlance as Boolean;
    var shownAt as Number = 0;
    var timer as Timer.Timer?;
    var fixStart as Number = 0;
    var fixLine as String = "fix: not asked";
    var menus as Number = 0;
    var lastRun as String = "last run -";

    function initialize(launchedFromGlance as Boolean) {
        View.initialize();
        fromGlance = launchedFromGlance;
        var alive = Application.Storage.getValue("alive");
        if (alive instanceof Array && alive.size() == 3) {
            var secs = (alive[1] as Number) - (alive[0] as Number);
            lastRun = "last run " + secs + "s " + (SunProbeText.isTrue(alive[2]) ? "glance" : "launcher");
        }
    }

    function onShow() as Void {
        shownAt = Time.now().value();
        var t = new Timer.Timer();
        t.start(method(:tick), 1000, true);
        timer = t;
        var info = Position.getInfo();
        if (info.position != null && info.accuracy >= Position.QUALITY_LAST_KNOWN) {
            storePlace(info);
        } else {
            askFix();
        }
    }

    function onHide() as Void {
        var t = timer;
        if (t != null) {
            t.stop();
            timer = null;
        }
        Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
    }

    // Each second: remember how long this run has lasted (read back as "last run" on the next open, D12).
    function tick() as Void {
        Application.Storage.setValue("alive", [shownAt, Time.now().value(), fromGlance]);
        WatchUi.requestUpdate();
    }

    function askFix() as Void {
        fixStart = Time.now().value();
        fixLine = "fix: asking";
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    }

    function onPosition(info as Position.Info) as Void {
        fixLine = "fix " + (Time.now().value() - fixStart) + "s q" + info.accuracy;
        storePlace(info);
        WatchUi.requestUpdate();
    }

    function storePlace(info as Position.Info) as Void {
        var p = info.position;
        if (p == null) {
            return;
        }
        var d = p.toDegrees();
        Application.Storage.setValue("place", [(d[0] * 10).toNumber() / 10.0, (d[1] * 10).toNumber() / 10.0]);
    }

    function toggleGlancePosition() as Void {
        menus += 1;
        Application.Storage.setValue("gpos", !SunProbeText.flag("gpos"));
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var now = Time.now();
        var lines = [SunProbeText.hm(now) + (fromGlance ? " glance" : " launcher")] as Array<String>;
        lines.add("open " + (now.value() - shownAt) + "s, " + lastRun);
        lines.add(SunProbeText.posLine());
        lines.add(fixLine);
        lines.add("place " + SunProbeText.str(Application.Storage.getValue("place")));
        lines.addAll(SunProbeText.weatherLines());
        lines.add("menu " + menus + ", glance-pos " + (SunProbeText.flag("gpos") ? "ON" : "off"));
        lines.add("START fix, MENU pos");
        SunProbeText.draw(dc, lines, true);
    }
}

class SunProbeDelegate extends WatchUi.BehaviorDelegate {
    var view as SunProbeView;

    function initialize(v as SunProbeView) {
        BehaviorDelegate.initialize();
        view = v;
    }

    function onSelect() as Boolean {
        view.askFix();
        return true;
    }

    function onMenu() as Boolean {
        view.toggleGlancePosition();
        return true;
    }
}
