import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;
import Toybox.WatchUi;

// Throwaway probe (research_notes/Two Suns temperature research/probe). Not a face to live with, no permissions, no
// network. Answers two questions the Two Suns weather row (ADR-022) leans on and has never had answered on a watch:
//   Q1  how many entries does getHourlyForecast() return, from which hour, and how often does the list move?
//   Q2  does each getDailyForecast() entry's forecastTime fall inside the local day it describes?
// Even minutes: live readings. Odd minutes: the log, one entry each time the hourly or daily list changed.
class WeatherProbeApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() as [Views] or [Views, InputDelegates] { return [new WeatherProbeView()]; }
}

class WeatherProbeView extends WatchUi.WatchFace {
    var lastKey = "";
    function initialize() { WatchFace.initialize(); }

    function lt(m as Time.Moment or Null) as String {
        if (m == null) { return "null"; }
        var i = Gregorian.info(m, Time.FORMAT_SHORT);
        return i.day.format("%d") + "/" + i.hour.format("%02d") + ":" + i.min.format("%02d");
    }
    function ut(m as Time.Moment or Null) as String {
        if (m == null) { return "null"; }
        var i = Gregorian.utcInfo(m, Time.FORMAT_SHORT);
        return i.day.format("%d") + "T" + i.hour.format("%02d") + ":" + i.min.format("%02d") + "Z";
    }

    // Local day number of a moment: whole days since 1970 after adding the clock's own offset and DST.
    function localDay(m as Time.Moment, offset as Number) as Number { return (m.value() + offset) / 86400; }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var now = Time.now();
        var ct = System.getClockTime();
        var offset = ct.timeZoneOffset + ct.dst;
        var lines = [] as Array<String>;
        lines.add("WXPROBE " + lt(now) + " off=" + (offset / 60) + "m");
        var key = "";
        try {
            var c = Weather.getCurrentConditions();
            if (c == null) { lines.add("cur null"); }
            else {
                var age = c.observationTime == null ? "?" : ((now.value() - c.observationTime.value()) / 60) + "m";
                lines.add("cur c=" + c.condition + " t=" + c.temperature + " f=" + c.feelsLikeTemperature);
                lines.add("obs " + lt(c.observationTime) + " age " + age);
                key += "o" + lt(c.observationTime);
            }
        } catch (e) { lines.add("cur EXC"); }
        try {
            var h = Weather.getHourlyForecast();
            if (h == null) { lines.add("hourly null"); key += "hN"; }
            else {
                var n = h.size();
                lines.add("hourly n=" + n);
                if (n > 0) {
                    var step = n > 1 ? ((h[1].forecastTime.value() - h[0].forecastTime.value()) / 60) + "m" : "-";
                    lines.add("h0 " + lt(h[0].forecastTime) + " c=" + h[0].condition + " t=" + h[0].temperature + " step " + step);
                    lines.add("h" + (n - 1) + " " + lt(h[n - 1].forecastTime) + " c=" + h[n - 1].condition + " t=" + h[n - 1].temperature);
                    lines.add("h0 UTC " + ut(h[0].forecastTime));
                    key += "h" + n + lt(h[0].forecastTime);
                }
            }
        } catch (e) { lines.add("hourly EXC"); }
        try {
            var d = Weather.getDailyForecast();
            if (d == null) { lines.add("daily null"); key += "dN"; }
            else {
                lines.add("daily n=" + d.size() + " (k = local day vs today)");
                for (var i = 0; i < d.size() && i < 5; i++) {
                    var t = d[i].forecastTime;
                    var k = t == null ? "?" : (localDay(t, offset) - localDay(now, offset)).toString();
                    lines.add("d" + i + " k=" + k + " " + lt(t) + " " + ut(t) + " c=" + d[i].condition + " " + d[i].lowTemperature + "/" + d[i].highTemperature);
                }
                key += "d" + d.size() + (d.size() > 0 ? lt(d[0].forecastTime) : "");
            }
        } catch (e) { lines.add("daily EXC"); }

        if (lastKey == "") { var k0 = Application.Storage.getValue("key"); if (k0 instanceof String) { lastKey = k0; } }
        if (!key.equals(lastKey)) {
            var log = Application.Storage.getValue("log");
            var arr = (log instanceof Array) ? log as Array : [] as Array;
            arr.add(lt(now) + " " + key);
            while (arr.size() > 12) { arr = arr.slice(1, arr.size()); }
            Application.Storage.setValue("log", arr);
            Application.Storage.setValue("key", key);
            lastKey = key;
        }

        var show = lines;
        if (ct.min % 2 != 0) {
            show = ["WXPROBE LOG (changes)"] as Array<String>;
            var log2 = Application.Storage.getValue("log");
            if (log2 instanceof Array) { for (var j = 0; j < log2.size(); j++) { show.add(log2[j] as String); } }
        }
        var fh = dc.getFontHeight(Graphics.FONT_XTINY);
        var y = (dc.getHeight() - show.size() * fh) / 2;
        for (var j = 0; j < show.size(); j++) { dc.drawText(dc.getWidth() / 2, y + j * fh, Graphics.FONT_XTINY, show[j], Graphics.TEXT_JUSTIFY_CENTER); }
        for (var j = 0; j < lines.size(); j++) { System.println("WXPROBE " + lines[j]); }
    }
}
