import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Complications;
import Toybox.SensorHistory;

class ProbeApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() as [Views] or [Views, InputDelegates] { return [new ProbeView()]; }
}

// Throwaway probe (research_notes/Body Battery and sun face research). Even minutes: live readings.
// Odd minutes: the log, one entry each time anything changed (sun times, location sources, time zone).
class ProbeView extends WatchUi.WatchFace {
    var lastKey = "";
    function initialize() { WatchFace.initialize(); }

    function ll(loc as Position.Location or Null) as String {
        if (loc == null) { return "null"; }
        var d = loc.toDegrees();
        return d[0].format("%.2f") + "," + d[1].format("%.2f");
    }
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
    function hm(sec as Number or Null) as String {
        if (sec == null) { return "null"; }
        return (sec / 3600).format("%02d") + ":" + ((sec % 3600) / 60).format("%02d");
    }
    function flag(x as Object or Null) as String { return x == null ? "-" : "+"; }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var now = Time.now();
        var lines = [] as Array<String>;
        var ct = System.getClockTime();
        var li = Gregorian.info(now, Time.FORMAT_SHORT); var ui = Gregorian.utcInfo(now, Time.FORMAT_SHORT);
        var diffMin = (li.hour * 60 + li.min) - (ui.hour * 60 + ui.min);
        if (diffMin > 720) { diffMin -= 1440; } else if (diffMin < -720) { diffMin += 1440; }
        var tzs = "tz=" + ct.timeZoneOffset + " dst=" + ct.dst + " diff=" + diffMin + "m";
        lines.add(PosProbe.name() + " " + lt(now));
        lines.add(tzs);

        var here = null;
        var pos = PosProbe.read();
        lines.add("Pos.getInfo " + PosProbe.describe(pos));
        if (pos != null) { here = pos; }

        var act = null;
        try { act = Activity.getActivityInfo().currentLocation; lines.add("Act.curLoc " + ll(act)); } catch (e) { lines.add("Act EXC"); }
        if (here == null && act != null) { here = act; }

        var wxl = null; var wxt = "";
        try {
            var c = Weather.getCurrentConditions();
            if (c == null) { wxt = "Wx cond null"; }
            else { wxl = c.observationLocationPosition; wxt = "Wx obsLoc " + ll(wxl) + " " + lt(c.observationTime); }
        } catch (e) { wxt = "Wx EXC"; }
        lines.add(wxt);
        if (here == null && wxl != null) { here = wxl; }

        var apiR = null; var apiS = null;
        try {
            if (here != null) { apiR = Weather.getSunrise(here, now); apiS = Weather.getSunset(here, now); }
            lines.add("API rise " + lt(apiR) + " set " + lt(apiS));
            lines.add("  UTC " + ut(apiR) + " " + ut(apiS));
        } catch (e) { lines.add("API sun EXC"); }

        var cr = null; var cs = null; var cb = null;
        try {
            var a = Complications.getComplication(new Complications.Id(Complications.COMPLICATION_TYPE_SUNRISE));
            var b = Complications.getComplication(new Complications.Id(Complications.COMPLICATION_TYPE_SUNSET));
            var c2 = Complications.getComplication(new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY));
            cr = a == null ? null : a.value; cs = b == null ? null : b.value; cb = c2 == null ? null : c2.value;
            lines.add("Cmp rise " + hm(cr) + " set " + hm(cs));
            lines.add("Cmp BB " + cb);
        } catch (e) { lines.add("Cmp EXC"); }

        try {
            var it = SensorHistory.getBodyBatteryHistory({:period => new Time.Duration(86400)});
            var s = it.next(); var cnt = 0; var first = null; var last = null; var prev = null; var minGap = 999999; var bad = 0; var future = 0;
            while (s != null) {
                cnt++; if (first == null) { first = s; } last = s;
                if (s.data == null || s.data < 0 || s.data > 100) { bad++; }
                if (s.when.value() > now.value() + 60) { future++; }
                if (prev != null) { var g = prev.when.value() - s.when.value(); if (g < 0) { g = -g; } if (g > 0 && g < minGap) { minGap = g; } }
                prev = s; s = it.next();
            }
            var order = (first != null && last != null) ? (first.when.value() >= last.when.value() ? "newest-first" : "oldest-first") : "-";
            lines.add("BB24h n=" + cnt + " bad=" + bad + " future=" + future);
            lines.add("BB gap=" + (minGap == 999999 ? "-" : minGap + "s") + " " + order);
            if (first != null) { lines.add("BB 1st " + first.data + " @" + lt(first.when)); }
            if (last != null) { lines.add("BB last " + last.data + " @" + lt(last.when)); }
        } catch (e) { lines.add("BB EXC"); }

        var key = hm(cr) + hm(cs) + ut(apiR) + ut(apiS) + flag(pos) + flag(act) + flag(wxl) + tzs;
        if (lastKey == "") { var k0 = Application.Storage.getValue("key"); if (k0 instanceof String) { lastKey = k0; } }
        if (key != lastKey) { logChange(lt(now), cr, cs, apiR, apiS, pos, act, wxl, tzs); lastKey = key; Application.Storage.setValue("key", key); }

        var show = (ct.min % 2 == 0) ? lines : logLines();
        var w = dc.getWidth(); var h = dc.getHeight();
        var fh = dc.getFontHeight(Graphics.FONT_XTINY);
        var y = (h - show.size() * fh) / 2;
        for (var k = 0; k < show.size(); k++) { dc.drawText(w / 2, y + k * fh, Graphics.FONT_XTINY, show[k], Graphics.TEXT_JUSTIFY_CENTER); }
        for (var k = 0; k < lines.size(); k++) { System.println("PROBE " + lines[k]); }
    }

    function logChange(t as String, cr as Number or Null, cs as Number or Null, ar as Time.Moment or Null, as_ as Time.Moment or Null, p as Object or Null, a as Object or Null, w as Object or Null, tzs as String) as Void {
        var log = Application.Storage.getValue("log");
        var arr = (log instanceof Array) ? log as Array : [] as Array;
        arr.add(t + " C " + hm(cr) + "/" + hm(cs));
        arr.add("  A " + ut(ar) + " " + ut(as_) + " P" + flag(p) + "A" + flag(a) + "W" + flag(w));
        while (arr.size() > 14) { arr = arr.slice(2, arr.size()); }
        Application.Storage.setValue("log", arr);
    }
    function logLines() as Array<String> {
        var log = Application.Storage.getValue("log");
        var out = [PosProbe.name() + " LOG (changes)"] as Array<String>;
        if (log instanceof Array) { for (var i = 0; i < log.size(); i++) { out.add(log[i] as String); } }
        return out;
    }
}
