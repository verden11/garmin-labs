import Toybox.Lang;

// Parses HeroSet's complication value (HeroSet ADR-044, docs/plan.md):
// "v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal", day keys
// as YYYYMMDD, every field a non-negative integer. HeroSet only publishes while it runs, so the day keys decide
// what is still true today.
class HeroFaceContract {
    static const PUSH = 0;
    static const SIT = 1;
    static const SQUAT = 2;
    static const RANK = 3;
    static const RANK_PERCENT = 4;
    static const STREAK = 5;
    static const GOAL = 6;

    // Nine fields through `lastDoneDay`; a tenth, the daily goal per exercise,
    // was appended by HeroSet without bumping the version (its ADR-045), so it
    // may be missing when an older HeroSet is installed.
    private static const FIELDS = 9;
    private static const OPTIONAL_FIELDS = 1;
    private static const SEPARATOR = "|";

    // [push, sit, squat, rank, rankPercent, streak, goal], or null for anything
    // this version can't trust (unknown version, missing or non-numeric
    // fields).
    static function parse(raw as String?, today as Number, yesterday as Number) as Array<Number>? {
        if (raw == null) {
            return null;
        }
        var fields = numbers(raw);
        if (fields == null || fields[0] != HeroFaceConfig.HEROSET_CONTRACT_VERSION) {
            return null;
        }
        var current = fields[1] == today;
        // Mirrors HeroSetRules.activeStreak: a missed day breaks the streak
        // even if HeroSet hasn't run since to say so.
        var streak = fields[8] >= yesterday ? fields[7] : 0;
        var goal = fields.size() > FIELDS && fields[FIELDS] > 0 ? fields[FIELDS] : HeroFaceConfig.HEROSET_GOAL;
        return [
            current ? fields[2] : 0,
            current ? fields[3] : 0,
            current ? fields[4] : 0,
            fields[5],
            clampPercent(fields[6]),
            streak,
            goal
        ] as Array<Number>;
    }

    // Reads the nine required fields plus the optional tenth. Anything beyond
    // that is a future addition and is ignored.
    private static function numbers(raw as String) as Array<Number>? {
        var out = [] as Array<Number>;
        var rest = raw;
        while (out.size() < FIELDS + OPTIONAL_FIELDS) {
            var cut = rest.find(SEPARATOR);
            var piece = cut == null ? rest : rest.substring(0, cut);
            var value = piece != null ? piece.toNumber() : null;
            if (value == null || value < 0) {
                return null;
            }
            out.add(value);
            if (cut == null) {
                break;
            }
            rest = rest.substring(cut + 1, rest.length()) as String;
        }
        return out.size() >= FIELDS ? out : null;
    }

    private static function clampPercent(value as Number) as Number {
        return value > 100 ? 100 : value;
    }
}
