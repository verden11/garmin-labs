import Toybox.Lang;

// One stretch of the 24 hour ring, in minutes on the clock. `to` may exceed 1440 (a sunset after
// midnight); the arc runs clockwise from `from` to `to`.
class TwoSunsRingArc {
    var kind as Number;
    var from as Number;
    var to as Number;

    function initialize(kind as Number, from as Number, to as Number) {
        self.kind = kind;
        self.from = from;
        self.to = to;
    }
}
