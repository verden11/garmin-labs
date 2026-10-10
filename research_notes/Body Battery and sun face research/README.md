# Body Battery and sun face research: notes

Snapshot **2026-09-26**. Sourced notes behind [`reports/Body Battery and sun face research.md`](../../reports/Body%20Battery%20and%20sun%20face%20research.md).
Product it leads to: specified in [`TwoSuns/docs/spec.md`](../../TwoSuns/docs/spec.md), planned in [`TwoSuns/docs/archive/plan.md`](../../TwoSuns/docs/archive/plan.md).
Every claim has source. Unverified says so.

| File | What it holds |
|---|---|
| [`platform.md`](platform.md) | SDK limits for Body Battery, sun times, location: permissions (compiler-checked), simulator probe results, local-day behaviour of `Weather.getSunrise`, location-vs-Positioning result, device tiers |
| [`market_and_pricing.md`](market_and_pricing.md) | Store survey: who ships Body Battery and sun faces, downloads, price, permissions, paid vs free |
| [`rival_reviews.md`](rival_reviews.md) | Reviewer comments on sun and Body Battery faces: what breaks, what they ask for |
| [`garmin_sources.md`](garmin_sources.md) | Garmin's own pages on Body Battery and sunrise/sunset glance, plus validation limits |
| [`naming.md`](naming.md) | Name candidates, store collisions |
| `store_survey.csv` | All 1,378 watch faces from survey (id, name, download bucket, rating, reviews, price, permissions, developer, flags) |
| `key_rival_reviews.tsv` | Text reviews (no reviewer names) of 19 faces used in `rival_reviews.md` |
| `probe/` | Throwaway probe watch faces, simulator logs (reproducible) |

## Method and instruments

- **Store API** (no login), same as countdown research: `.../asw/apps/keywords?keywords=<q>&startPageIndex=<offset>&pageSize=30&countryCode=US&appType=WATCHFACE`
  and `.../apps/<id>/reviews?...&sortType=CreatedDate&ascending=false&withReviewTextOnly=true`. 20 queries (body battery, sunrise, sunset, sun, sunrise sunset, daylight,
  solar, energy, recovery, circadian, golden hour, twilight, sun moon, day night, stress body battery, battery energy level, sunrise sunset arc, dawn dusk, sleep recovery,
  wellness) × up to 3 pages, de-duplicated by `id`: **1,378 unique faces**. `downloadCount` = **bucket**. Prices in **euro** (2.49 € = USD 2.00 tier, lowest, where Days To Go sits); paid = `pricing != null`.
- **"Mentions" vs "core":** face *mentions* Body Battery or sun if English name or description contains term (482 and 588; 282 both). *Core* if term in name or first ~220 characters of description; core-sun test loose (also matches names containing "light", "sol", "sun"), so use ranked lists, not count, for anything that matters.
- **SDK 9.2.0** docs (`doc/Toybox/**`, `doc/docs/**`) and device files (`Devices/<id>/compiler.json`, `simulator.json`).
- **Compiler and simulator probes** (`probe/`): `monkeyc -w --typecheck 3` reports which calls need which permission; `monkeydo` on `fr965` (and `fenix7`, `venu3` compiled) shows runtime behaviour. Simulator has no GPS position, canned weather location, so cannot show what *real* watch returns for location; that is what `device-test/LocationProbe-P.prg` and `LocationProbe-N.prg` are for. Its Weather location, however, **did** depend on Positioning permission (`platform.md` §1).
- **Garmin's own pages** read in browser (fetch tool got 403): Body Battery technology page, Sunrise and Sunset Glance support article.
- **Forums** read via fetch tool (summaries, not full threads): Connect IQ developer forum threads on Body Battery and sunrise/sunset.

## Not done

- No device test of any location source, Body Battery history cadence, or `Weather.getSunrise` semantics on real firmware (two probes for owner's FR965, with and without Positioning, built, waiting).
- No trademark search. Store name search only.
- No download of any rival face to view screenshots.
- Review counts by theme = keyword counts, not hand-coded.
- 62-person ECG study and athletedata/sensai comparisons seen only as search-result summaries, not read in full.