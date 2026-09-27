import Toybox.Lang;
import Toybox.Position;
class PosProbe {
    static function name() as String { return "PROBE-P"; }
    static function read() as Position.Location or Null {
        var i = Position.getInfo();
        return i.position;
    }
    static function describe(l as Position.Location or Null) as String {
        if (l == null) { return "null"; }
        var d = l.toDegrees();
        return d[0].format("%.2f") + "," + d[1].format("%.2f");
    }
}
