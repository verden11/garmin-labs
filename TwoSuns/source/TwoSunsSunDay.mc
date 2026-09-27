import Toybox.Lang;

// The sun on one local date, in whole local minutes since local midnight.
// A time is null when the sun does not make that crossing that day (polar).
// `set` can exceed 1440 (a sunset after local midnight) and `rise` can be
// negative in the rare mirror case; nothing here wraps them.
class TwoSunsSunDay {
    var kind as Number;
    var rise as Number or Null;
    var set as Number or Null;
    var noon as Number;
    var civilBegin as Number or Null;
    var civilEnd as Number or Null;
    // The golden hour is the sun below 6 degrees: it ends this long after sunrise and starts before sunset.
    var goldenMorningEnd as Number or Null;
    var goldenEveningStart as Number or Null;

    function initialize(kind as Number, rise as Number or Null, set as Number or Null, noon as Number,
                        civilBegin as Number or Null, civilEnd as Number or Null,
                        goldenMorningEnd as Number or Null, goldenEveningStart as Number or Null) {
        self.kind = kind;
        self.rise = rise;
        self.set = set;
        self.noon = noon;
        self.civilBegin = civilBegin;
        self.civilEnd = civilEnd;
        self.goldenMorningEnd = goldenMorningEnd;
        self.goldenEveningStart = goldenEveningStart;
    }
}
