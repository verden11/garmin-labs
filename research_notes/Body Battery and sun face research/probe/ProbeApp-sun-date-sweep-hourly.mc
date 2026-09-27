import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;

class ProbeApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() as [Views] or [Views, InputDelegates] { return [new ProbeView()]; }
}
class ProbeView extends WatchUi.WatchFace {
    var n = 0;
    function initialize() { WatchFace.initialize(); }
    function u(m as Time.Moment or Null) as String {
        if (m == null) { return "null"; }
        var i = Gregorian.utcInfo(m, Time.FORMAT_SHORT);
        return i.day.format("%02d") + "T" + i.hour.format("%02d") + ":" + i.min.format("%02d") + "Z";
    }
    function onUpdate(dc as Dc) as Void {
        dc.clear(); n++; if (n > 1) { return; }
        System.println("PROBE tzoffset=" + System.getClockTime().timeZoneOffset + " dst=" + System.getClockTime().dst);
        var pts = {"Hawaii" => [21.3, -157.86], "Sydney" => [-33.87, 151.2], "London" => [51.5, -0.12]};
        var keys = pts.keys();
        for (var k = 0; k < keys.size(); k++) {
            var p = pts[keys[k]] as Array;
            var L = new Position.Location({:latitude => p[0], :longitude => p[1], :format => :degrees});
            for (var h = 18; h <= 26; h++) {
                var t = Gregorian.moment({:year => 2026, :month => 9, :day => (h >= 24 ? 27 : 26), :hour => (h >= 24 ? h - 24 : h)});
                System.println("PROBE " + keys[k] + " asked=" + u(t) + " rise=" + u(Weather.getSunrise(L, t)) + " set=" + u(Weather.getSunset(L, t)));
            }
        }
        System.println("PROBE done");
    }
}
