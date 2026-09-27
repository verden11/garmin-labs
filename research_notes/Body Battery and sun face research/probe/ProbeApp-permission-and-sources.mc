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

class ProbeView extends WatchUi.WatchFace {
    var n = 0;
    function initialize() { WatchFace.initialize(); }
    function ll(loc as Position.Location or Null) as String {
        if (loc == null) { return "null"; }
        var d = loc.toDegrees();
        return d[0].format("%.3f") + "," + d[1].format("%.3f");
    }
    function mm(m as Time.Moment or Null) as String {
        if (m == null) { return "null"; }
        var i = Gregorian.info(m, Time.FORMAT_SHORT);
        return i.hour.format("%02d") + ":" + i.min.format("%02d") + "(" + m.value() + ")";
    }
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK); dc.clear();
        n++;
        if (n > 2) { return; }
        System.println("PROBE run " + n + " api=" + System.getDeviceSettings().monkeyVersion);
        try { var i = Position.getInfo(); System.println("PROBE Position.getInfo pos=" + ll(i.position) + " acc=" + i.accuracy); } catch (e) { System.println("PROBE Position.getInfo EXC " + e.getErrorMessage()); }
        try { var a = Activity.getActivityInfo(); System.println("PROBE Activity.currentLocation=" + ll(a.currentLocation)); } catch (e) { System.println("PROBE Activity EXC " + e.getErrorMessage()); }
        var loc = null;
        try {
            var c = Weather.getCurrentConditions();
            if (c == null) { System.println("PROBE Weather.getCurrentConditions = null"); }
            else { loc = c.observationLocationPosition; System.println("PROBE Weather.observationLocationPosition=" + ll(loc) + " temp=" + c.temperature); }
        } catch (e) { System.println("PROBE Weather EXC " + e.getErrorMessage()); }
        var now = Time.now();
        var pts = {"Tromso" => [69.6496, 18.956], "Hawaii" => [21.3, -157.86], "Dubai" => [25.2, 55.27], "London" => [51.5, -0.12], "Sydney" => [-33.87, 151.2]};
        var keys = pts.keys();
        for (var k = 0; k < keys.size(); k++) {
            var p = pts[keys[k]] as Array;
            try {
                var L = new Position.Location({:latitude => p[0], :longitude => p[1], :format => :degrees});
                System.println("PROBE sun " + keys[k] + " rise=" + mm(Weather.getSunrise(L, now)) + " set=" + mm(Weather.getSunset(L, now)));
            } catch (e) { System.println("PROBE sun EXC " + e.getErrorMessage()); }
        }
        try {
            var cs = [Complications.COMPLICATION_TYPE_SUNRISE, Complications.COMPLICATION_TYPE_SUNSET, Complications.COMPLICATION_TYPE_BODY_BATTERY];
            for (var q = 0; q < cs.size(); q++) {
                var c = Complications.getComplication(new Complications.Id(cs[q]));
                System.println("PROBE complication " + cs[q] + " value=" + (c == null ? "no-comp" : c.value));
            }
        } catch (e) { System.println("PROBE Complications EXC " + e.getErrorMessage()); }
        try {
            var it = SensorHistory.getBodyBatteryHistory({:period => 5});
            var s = it.next(); var cnt = 0;
            while (s != null) { System.println("PROBE BB sample " + s.data + " at " + mm(s.when)); s = it.next(); cnt++; }
            System.println("PROBE BB samples=" + cnt);
        } catch (e) { System.println("PROBE BB EXC " + e.getErrorMessage()); }
    }
}
