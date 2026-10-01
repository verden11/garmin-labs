import Toybox.Lang;
import Toybox.Test;

// Pro only: the remembered place (docs/decisions.md ADR-020, Free + Pro ladder).
(:test, :pro)
function placeRoundsToTenthOfADegree(logger as Test.Logger) as Boolean {
    var place = TwoSunsPlace.pick([[51.5074, -0.1278]] as Array<Array<Float> or Null>);
    Test.assert(place != null);
    if (place != null) {
        Test.assertMessage((place[0] - 51.5).abs() < 0.0001, "lat " + place[0]);
        Test.assertMessage((place[1] + 0.1).abs() < 0.0001, "lon " + place[1]);
    }
    return true;
}

// The first usable source wins, in the caller's order; null and unusable ones are skipped.
(:test, :pro)
function placePickFollowsOrder(logger as Test.Logger) as Boolean {
    var candidates = [null, [0.0, 0.0], [95.0, 10.0], [64.15, -21.94], [40.71, -74.0]] as Array<Array<Float> or Null>;
    var place = TwoSunsPlace.pick(candidates);
    Test.assert(place != null);
    if (place != null) {
        Test.assertMessage((place[0] - 64.2).abs() < 0.0001, "lat " + place[0]);
    }
    Test.assert(TwoSunsPlace.pick([] as Array<Array<Float> or Null>) == null);
    Test.assert(TwoSunsPlace.pick([null, null] as Array<Array<Float> or Null>) == null);
    return true;
}

(:test, :pro)
function placeUsability(logger as Test.Logger) as Boolean {
    Test.assert(TwoSunsPlace.isUsable(51.5, -0.12));
    Test.assert(TwoSunsPlace.isUsable(0.0, 10.0));    // on the equator is a place
    Test.assert(TwoSunsPlace.isUsable(-90.0, 180.0));
    Test.assert(!TwoSunsPlace.isUsable(0.0, 0.0));    // no-fix placeholder
    Test.assert(!TwoSunsPlace.isUsable(90.5, 0.0));
    Test.assert(!TwoSunsPlace.isUsable(10.0, -181.0));
    return true;
}

// Replace only when more than 0.1 degree from the saved place, on either axis.
(:test, :pro)
function placeReplaceHysteresis(logger as Test.Logger) as Boolean {
    var saved = [51.5, -0.1] as Array<Float>;
    Test.assert(TwoSunsPlace.shouldReplace(null, [51.5, -0.1] as Array<Float>));
    Test.assert(!TwoSunsPlace.shouldReplace(saved, [51.5, -0.1] as Array<Float>));
    Test.assert(!TwoSunsPlace.shouldReplace(saved, [51.56, -0.13] as Array<Float>));
    Test.assert(TwoSunsPlace.shouldReplace(saved, [51.65, -0.1] as Array<Float>));
    Test.assert(TwoSunsPlace.shouldReplace(saved, [51.5, 0.05] as Array<Float>));
    return true;
}

// Whatever Storage returns, only two usable Floats come back.
(:test, :pro)
function placeFromStorageTrustsNothing(logger as Test.Logger) as Boolean {
    Test.assert(TwoSunsPlace.fromStorage(null) == null);
    Test.assert(TwoSunsPlace.fromStorage("place") == null);
    Test.assert(TwoSunsPlace.fromStorage([1.0] as Array<Float>) == null);
    Test.assert(TwoSunsPlace.fromStorage(["a", 2.0] as Array<String or Float>) == null);
    Test.assert(TwoSunsPlace.fromStorage([null, 2.0] as Array<Float or Null>) == null);
    Test.assert(TwoSunsPlace.fromStorage([95.0, 2.0] as Array<Float>) == null);
    var good = TwoSunsPlace.fromStorage([51.5, -0.1] as Array<Float>);
    Test.assert(good != null);
    // Whole degrees saved as Numbers still come back as a place.
    var whole = TwoSunsPlace.fromStorage([51, -1] as Array<Number>);
    Test.assert(whole != null);
    if (whole != null) {
        Test.assertMessage((whole[0] - 51.0).abs() < 0.0001, "lat " + whole[0]);
    }
    return true;
}
