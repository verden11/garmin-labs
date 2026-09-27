import Toybox.Lang;
import Toybox.Position;
class PosProbe {
    static function name() as String { return "PROBE-N"; }
    static function read() as Position.Location or Null { return null; }
    static function describe(l as Position.Location or Null) as String { return "not called"; }
}
