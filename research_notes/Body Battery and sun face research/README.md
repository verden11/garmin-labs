# Body Battery and sun face research: notes

Snapshot **2026-09-26**. Sourced notes behind [`reports/Body Battery and sun face research.md`](../../reports/Body%20Battery%20and%20sun%20face%20research.md).
The product it leads to is specified in [`TwoSuns/docs/spec.md`](../../TwoSuns/docs/spec.md) and planned in [`TwoSuns/docs/plan.md`](../../TwoSuns/docs/plan.md).
Every claim carries its source. Anything not verified says so.

| File | What it holds |
|---|---|
| [`platform.md`](platform.md) | What the SDK allows for Body Battery, sun times and location: permissions (compiler-checked), simulator probe results, the local-day behaviour of `Weather.getSunrise` and the location-vs-Positioning result, device tiers |
| [`market_and_pricing.md`](market_and_pricing.md) | The store survey: who ships Body Battery and sun faces, downloads, price, permissions, paid vs free |
| [`rival_reviews.md`](rival_reviews.md) | What reviewers of the sun and Body Battery faces say: what breaks, what they ask for |
| [`garmin_sources.md`](garmin_sources.md) | What Garmin's own pages say about Body Battery and the sunrise/sunset glance, plus validation limits |
| [`naming.md`](naming.md) | Name candidates and their store collisions |
| `store_survey.csv` | All 1,378 watch faces from the survey (id, name, download bucket, rating, reviews, price, permissions, developer, flags) |
| `key_rival_reviews.tsv` | Text reviews (no reviewer names) of 19 faces used in `rival_reviews.md` |
| `probe/` | The throwaway probe watch faces and their simulator logs (reproducible) |

## Method and instruments

- **Store API** (no login), same as the countdown research: `.../asw/apps/keywords?keywords=<q>&startPageIndex=<offset>&pageSize=30&countryCode=US&appType=WATCHFACE`
  and `.../apps/<id>/reviews?...&sortType=CreatedDate&ascending=false&withReviewTextOnly=true`. 20 queries (body battery, sunrise, sunset, sun, sunrise sunset, daylight,
  solar, energy, recovery, circadian, golden hour, twilight, sun moon, day night, stress body battery, battery energy level, sunrise sunset arc, dawn dusk, sleep recovery,
  wellness) × up to 3 pages, de-duplicated by `id`: **1,378 unique faces**. `downloadCount` is a **bucket**. Prices come back in **euro** (2.49 € is the USD 2.00 tier, the
  lowest, which is where Days To Go sits); paid is `pricing != null`.
- **"Mentions" vs "core":** a face *mentions* Body Battery or sun if its English name or description contains the term (482 and 588; 282 both). It is *core* if the term is
  in its name or the first ~220 characters of its description; the core-sun test is loose (it also matches names containing "light", "sol", "sun"), so use the ranked lists,
  not the count, for anything that matters.
- **SDK 9.2.0** docs (`doc/Toybox/**`, `doc/docs/**`) and device files (`Devices/<id>/compiler.json`, `simulator.json`).
- **Compiler and simulator probes** (`probe/`): `monkeyc -w --typecheck 3` reports which calls need which permission; `monkeydo` on `fr965` (and `fenix7`, `venu3` compiled) shows runtime behaviour. The simulator has no GPS position and a canned weather location, so it cannot show what a *real* watch returns for location; that is what `device-test/LocationProbe-P.prg` and `LocationProbe-N.prg` are for. Its Weather location, however, **did** depend on the Positioning permission (`platform.md` §1).
- **Garmin's own pages** read in a browser (the fetch tool got a 403): the Body Battery technology page and the Sunrise and Sunset Glance support article.
- **Forums** read through the fetch tool (summaries, not full threads): Connect IQ developer forum threads on Body Battery and on sunrise/sunset.

## Not done

- No device test of any location source, of Body Battery history cadence, or of `Weather.getSunrise` semantics on real firmware (two probes for the owner's FR965, with and without Positioning, are built and waiting).
- No trademark search. Store name search only.
- No download of any rival face to look at its screenshots.
- Review counts by theme are keyword counts, not hand-coded.
- The 62-person ECG study and the athletedata/sensai comparisons were seen only as search-result summaries, not read in full.
