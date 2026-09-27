# Two Suns decision log (ADRs)

Every durable design decision, newest last. [`spec.md`](spec.md) says what the product is; this file says why. Add an ADR at the end for any decision a future contributor would otherwise re-litigate. Mark old ADRs **Superseded** or **Amended**, never delete.

**Evidence levels used below.** *Owner choice*: the owner decided, nothing tests it. *Desk research*: the research report and notes, no code ran. *Simulator test*: a unit or screen-fit test that passed in the SDK 9.2.0 simulator (122 tests, 2026-09-27; the tests do not check pixels). Nothing here has run on a watch. Each ADR also says what would reverse it.

| ADR | Decision | Status |
|---|---|---|
| 001 | Concept: the sky's day and your energy on one dial; the time is the hero | Active (look **not approved**) |
| 002 | Price: paid, USD 1.99, the same tier as Days To Go | Active |
| 003 | Sunrise and sunset from Complications; `Weather.getSunrise` is a cross-check and tier B fallback only | Active |
| 004 | Own NOAA calculation for everything Garmin does not give; tomorrow's sunrise keeps Garmin's offset | Active |
| 005 | Location order and the Positioning permission (confirmed, 2026-09-27); `Position.getInfo` isolated | Active |
| 006 | The remembered place: rounded to 0.1 degree, `Application.Storage`, replaced only when it moved | Active |
| 007 | Always-on is time, Body Battery value and sun sentence, dim, drifting; no ring, no curve | Active (device check open) |
| 008 | No verdicts on Body Battery; the curve setting is called "Energy curve" | Active |
| 009 | Device set: 69 products at API 4.2+ (tier A); tier B is 1.1 | Active |
| 010 | Name **Two Suns** (working name), slug `two-suns` | **Open**: owner to confirm |
| 011 | The 24-hour ring is wall-clock | Active |
| 012 | The local UTC offset is derived exactly from the clock | Active |
| 013 | Sky states: the calculation fills what Garmin leaves null | Active |
| 014 | Sun sentences come in three wordings, chosen by measured fit | Active |
| 015 | Body Battery data rules: buckets, staleness, no substitution | Active |
| 016 | Rows are stacked from font heights; fixed drop order on small screens | Active |
| 017 | Ring, curve and glyph encodings; state is never colour alone | Active (look **not approved**) |
| 018 | List settings only | Active |

## ADR-001: Concept

**Decision.** One face answers one question: how much light, and how much energy, do I have left today? A 24-hour ring around the bezel is the sky's sun, a 24-hour curve under the time is the watch's Body Battery, and one sentence at the bottom says how much daylight is left or when the sun returns. The time is the hero.
**Why.** No rival relates the two: 282 of 1,378 surveyed faces mention both, almost all as 14-to-40-field dashboards; none is built around the pair.
**Evidence.** Desk research: `reports/Body Battery and sun face research.md` §1 and §2. The build's look is the spec's recommended direction and the owner has **not** approved it ([`../DESIGN.md`](../DESIGN.md)).
**Reversed by.** The owner replacing the look with a mock-up (then `spec.md` and `DESIGN.md` change, the concept stands), or a decision that a face should not carry Body Battery at all.

## ADR-002: Price

**Decision.** Paid, USD 1.99 at first submission (owner, confirmed 2026-09-27) — Garmin's first paid price step; a lower figure the owner initially named (USD 1.90) turned out not to be an offered price, since Garmin does not allow custom prices, only fixed steps. This lands on the same tier as Days To Go, which the owner had originally wanted to avoid, but is the nearest real option. The review cadence follows Days To Go's rules ([`../../DaysToGo/docs/decisions.md`](../../DaysToGo/docs/decisions.md) ADR-002): one review 45 days after store approval, and the success test at day 60 ([`spec.md`](spec.md) "Success and stop test"). Days To Go's proposed flip rule (fewer than 5 sales in 45 days and a download bucket of 10 or lower) is the working proposal here too; the owner has not confirmed it for this app.
**Why.** Owner choice, 2026-09-26 ("Paid like Days To Go"). Risk on record: about 75 paid Body Battery or sun faces, 2 of them at 1,000+ downloads. **Night & Day** (50,000 downloads) lists free and unlocks on the developer's own site; its 1-star reviews are about that. Do not copy it. Garmin's app trials do not work for watch faces, so there is no native trial.
**Evidence.** Owner choice; desk research (`market_and_pricing.md`).
**Reversed by.** The day-45 review. Details and the "email developer support first, never cancel the merchant account" rule: Days To Go ADR-002. Price review due: not set until approval.

## ADR-003: Sunrise and sunset come from Complications

**Decision.** Today's sunrise and sunset are `Complications` SUNRISE and SUNSET (seconds since local midnight, 0 to 86399, truncated to minutes): Garmin's own numbers, the ones the watch's Sunrise/Sunset glance shows, in the watch's local time, with no location. `Weather.getSunrise` and `getSunset` are **not** the primary source; they are allowed only as a cross-check and as the tier B fallback (1.1), and never without a location. The code today does not call them at all.
**Why.** Reviewers compare a face with Garmin's glance, and Complications need no location. The rivals' "it shows UTC" bugs are not explained by the Weather API (below), so there was no API defect to design around.
**Evidence.** Desk research plus simulator probes, `research_notes/Body Battery and sun face research/platform.md` §3 and `probe/sim-sun-date-sweep-hourly.log`. An hourly sweep (the simulator's clock was UTC+3) asked `Weather.getSunrise/getSunset` for every hour from 26 September 18:00Z to 27 September 02:00Z for Hawaii, Sydney and London. The returned pair flipped at 26 September 21:00Z, which is 00:00 on the watch's clock, not at 00:00Z: the API follows the watch's **local** calendar day. **An earlier reading was wrong and is retracted:** a first sweep in 6-hour steps spanned both the local and the UTC midnight and was read as "UTC date". Simulator only; whether real firmware behaves the same is what the on-watch probe log (an `A` line across local midnight) records. The Complication values in the simulator are canned (sunrise 54535, sunset 11599, a sunset earlier than the sunrise), so they prove parsing and the after-midnight rule, not Garmin's numbers.
**Reversed by.** The device compare: if the Complication values differ from the native glance by more than 1 minute, or are null on the owner's watch, the calculation becomes primary and this ADR is superseded. If there is then no location, tier A has no sun data and the owner decides ([`plan.md`](plan.md) "Stop and ask").

## ADR-004: Own NOAA calculation, and tomorrow's sunrise

**Decision.** Everything the sky needs that Garmin does not give is our own calculation (`TwoSunsSun`, pure `Float` functions): sunrise, sunset, solar noon, civil twilight (zenith 96 degrees), golden hour (84 degrees), evaluated at the local noon of the local date, zenith 90.833 degrees for sunrise and sunset. After sunset the face announces tomorrow's sunrise as calculated tomorrow plus (Garmin's today minus calculated today), so it keeps Garmin's offset. No copy of any library: the only public Monkey C one is LGPL.
**Why.** Garmin gives no tomorrow, dawn, dusk or golden hour. The correction keeps the two sources consistent to the minute.
**Evidence.** Simulator test: `TwoSunsSunReferenceTest` (generated by `tools/gen_sun_tests.py` from `reference_sun_times.tsv`): 27 place-and-date reference tests against the US Naval Observatory, tolerance 2 minutes where the Observatory lists an event (rise, set, civil twilight; solar noon compared around the clock). Polar rows assert "no event" and the sun's kind; the two polar-circle transition days (Tromso 18 May and the day the midnight sun starts) check solar noon only, so a difference of one day at the transitions is accepted, as the spec says. The maths runs on days since J2000 in 32-bit floats because a Julian date does not fit a `Float`. Not verified: that a watch's float behaviour equals the simulator's; the calculation's agreement with Garmin's own numbers (the simulator's `Weather` day was 7 minutes longer than the Observatory's for London on 27 September, and which zenith Garmin uses is undocumented).
**Reversed by.** The device compare showing our calculation and Garmin's differing by more than the tolerance in a way the tomorrow correction does not absorb.

## ADR-005: Location order and the Positioning permission

**Decision.** The location sources are read in this order: `Activity.getActivityInfo().currentLocation`, then the Weather observation location, then `Position.getInfo()`, then the saved place (ADR-006). The manifest declares `Positioning`, **now confirmed, not provisional.** `Position.getInfo()` is isolated in one function, `TwoSunsSources.positionLocation`, and its one entry in `updatePlace()`, kept that way even though the permission is confirmed, so a future reversal stays a two-deletion change. Every location source is guarded; a watch without one just gives null and the face says "No place yet".
**Why.** On the owner's FR965 (2026-09-27, real watch, not the simulator): `Activity.currentLocation` stayed null even right after a GPS run was started and discarded (Q1 = no); the Weather observation location stayed null throughout, with or without a GPS activity (Q2 = no); `Position.getInfo()` returned a location immediately at first look, with no GPS activity run first — a cached fix (Q3 = yes). Per the decision table (`plan.md` phase 1): Q1 and Q2 no, Q3 yes → keep Positioning. Simulator behaviour for Q3 was the opposite (always null without an activity); the real watch differs.
**Evidence.** Simulator probes (`platform.md` §1 and §2) plus the on-watch probes, run 2026-09-27 (`../../device-test/LocationProbe-P.prg` with the permission, `LocationProbe-N.prg` without; results in `../../device-test/LocationProbe-RESULTS.md`). M1 (first look) and M2 (after a GPS activity, discarded) were run on N; M3 (outdoors, over time) and M4 (overnight log) were not, and neither was the native-glance comparison (Q4) — none of them can change this call (Q3 already answers it), so they are left for later, before store submission.
**Reversed by.** Nothing found so far reverses it. If a later run of M3 or M4 ever shows Activity or Weather giving a location without Positioning, drop the permission, delete `positionLocation()` and its entry in `updatePlace()`, and say "no location permission" on the listing.

## ADR-006: The remembered place

**Decision.** A place is `[latitude, longitude]` rounded to 0.1 degree (about 11 km), kept in `Application.Storage` under the key `place`, the only thing the app stores. A fresher source replaces it only when it is more than 0.1 degree away (plus a 0.001 epsilon) in latitude or longitude; since both values are already rounded, that is in practice a step of 0.2 degree, and jitter causes no writes. A fix of exactly (0, 0) is rejected as a no-fix placeholder, and so is anything outside +-90 or +-180. Values read back from Storage are accepted as any numeric type (Float, Double or Number) and re-validated. A failing store only loses the memory. It is never sent anywhere.
**Why.** Sun times need minutes per quarter degree, so 0.1 degree is enough and is not a precise location. Storing little, writing rarely and validating on read protects the face from a bad or foreign value.
**Evidence.** Simulator test: `TwoSunsPlaceTest` (rounding, source order, replace only when moved, empty, (0, 0), storage types). Nothing about a real fix.
**Reversed by.** ADR-005 removing every location source that could fill it (then the key is unused), or a listing/privacy decision that the face must not store a place.

## ADR-007: Always-on

**Decision.** On AMOLED watches that require burn-in protection the sleep frame is the time, the Body Battery value and the sun sentence, in dim grey `#555555`, the block stepping across a 3 by 3 grid once a minute; no ring, no curve, no glyph, no date. The time is two font sizes smaller than awake (it starts at `FONT_NUMBER_MEDIUM`). MIP watches show the full face at all times. The step is 35 permille of the shorter screen side (`BURN_IN_STEP_PERMILLE`), 15 px on 454 by integer arithmetic.
**Why.** The same rule as Days To Go ADR-007: at most 10% of pixels lit and a pixel on for at most three updates, else the whole screen goes dark.
**Evidence.** The rule is Garmin's, copied from Days To Go. Simulator test: the always-on frame fits at every one of the nine drift positions (`alwaysOnFrameFitsAtEveryDrift`). **Not measured:** lit-pixel share, ghosting, a night on a real AMOLED.
**Reversed by.** The always-on night check ([`publish-checklist.md`](publish-checklist.md) gate 5): if the screen blanks or ghosts, raise `BURN_IN_STEP_PERMILLE` or shrink the time, then repeat.

## ADR-008: No verdicts on Body Battery

**Decision.** Body Battery is shown as a number and a neutral picture: never a mood, an emoji, advice, a threshold word or a good/bad colour scheme (red/amber/green). The face never shows the words good, low, rest or tired. The phone setting that hides the curve is labelled "Energy curve", not "Body Battery". "Body Battery" is Garmin's trademark: never in the store name, the icon or the brand, used only descriptively in the listing.
**Amended 2026-09-27 (owner): the value, pill and current-point dot dim below 30** (`TwoSunsConfig.BATTERY_LOW_THRESHOLD`, `TwoSunsReadings.batteryAccentFor`) — the chosen accent turns to `TwoSunsPalette.dim(accent)`, the exact colour the sky ring already uses for daylight already gone, so "dim" means the same thing everywhere on the face. This is a real exception to "no colour by level," narrowly scoped: one brightness step, the same hue throughout (never a hue change, never red), no word, no icon, no threshold named anywhere in the UI. It exists because a flat accent colour created its own problem (a normal value read as "looks low" purely from the colour's own connotation, amber especially); two brightness states, keyed to the chosen hue, read as "less charge" without reading as "bad." The pill's fill length and the curve's height already carry the continuous level signal; this only adds a glance-level cue, and stops at two states because a third palette-safe step collapses most accents into the same grey already used for "stale," which would make "very low" and "no data" indistinguishable — rejected for that reason ([`DESIGN.md`](../DESIGN.md) "Energy curve, glyph and value").
**Why.** Reviewers of the Pokemon Sleep faces asked for background or colour choice (59 of 505) and to pick or turn off the mood (9), and one found the sad pose upsetting; Garmin's own Body Battery page says "the occasional low-energy day is no cause for alarm". The store's review guidelines forbid medical claims. The 2026-09-27 amendment: a real-device photo showed the flat amber accent misreading a normal value as low; brightness-of-one-hue was picked over a red/green scale specifically to avoid reintroducing that verdict risk.
**Evidence.** Desk research (`rival_reviews.md`, `garmin_sources.md`, `naming.md`). No test enforces the absence of a verdict WORD; `strings.xml` has no such words (checked by reading, and by `tools/check_strings.py` only for length). The two-tier dim IS tested: `TwoSunsReadingsTest.batteryAccentForDimsOnlyBelowTheThreshold` and `batteryAccentFollowsTheLevel`.
**Reversed by.** The owner. A three-tier or hue-based scheme needs a new palette design (the current one cannot go past two brightness states without colour collapse, see above).

## ADR-009: Device set

**Decision.** v1 is the 69 watch-face products at API 4.2 or newer (Complications), one build, `minApiLevel` 4.2.0, no bitmaps, no per-device resources. They are 66 round and 3 rectangular (Venu Sq 2, Venu Sq 2 Music, Venu X1; the round design stays centred, sized by the shorter side). Excluded: Instinct 3 Solar 45 mm and Instinct E 40 and 45 mm (semi-octagon, 64 KB, monochrome), and every product below API 4.2. Tier B (API 3.4 to 4.1, 23 products, no Complications) is version 1.1 and only if the location probes show a source that works; tiers C and D (API below 3.4) never get a paid face.
**Why.** Complications give Garmin's own sun and Body Battery numbers with no location; below API 4.2 sun times must come from a calculation and a location, which is the failure path the rival reviews describe.
**Evidence.** Desk research: the SDK's `Devices/*/compiler.json` `deviceGroup` (2026-09-26). Simulator test: a full 69-product compile sweep, run after the 15-language manifest was added, printed `BUILD SUCCESSFUL` for all 69 at `-w --typecheck 3` with zero errors and no warning beyond the launcher-icon-scaling notice — the build outputs were not kept as artifacts (`bin/` is git-ignored scratch, deleted after each run per house rules), so this rests on the run having happened, not a saved log; the fit test ran on ten of the eleven screen sizes ([`compatibility.md`](compatibility.md)). The fit sweep over all 69 products has not been run.
**Reversed by.** A product failing its fit run (drop or fix it), or the owner widening to tier B.

## ADR-010: Name and slug

**Decision.** **Two Suns** is a working name; site slug `two-suns`; code prefix `TwoSuns`; runner-up **Sun Battery**. The slug is permanent once a site page is published. The app id (`6c3c5a3d-b312-4c0f-bf37-2a3fc3a79580`) never changes once published.
**Why.** Zero store collisions for both in a keyword search, no trademark search done. "Sun Battery" invites confusion with a device-battery face.
**Evidence.** Desk research (`naming.md`). Owner has not confirmed.
**Reversed by.** The owner's choice or a trademark finding. The rename is mechanical: `strings.xml` `AppName`, the site slug, the docs; the code prefix and folder can stay or be renamed before the first commit.

## ADR-011: The 24-hour ring is wall-clock

**Decision.** The ring shows local wall-clock minutes 0 to 1440, noon at the top by default (a setting puts midnight at the top), clockwise. One degree is four minutes (marker and tick precision is about +-1 degree). On a daylight-saving change day the ring has a one-hour jump; documented, not fixed.
**Why.** It reads like a clock and matches the numbers on the face. The alternative (elapsed time) needs a zone database the watch face does not have.
**Evidence.** Simulator test: `TwoSunsRingPlanTest` (angles always in range, arcs, ticks, both orientations). The sun tests cover the London DST change days (29 March and 25 October) and New York 8 March, but that tests the sun times, not the drawn ring across the change.
**Reversed by.** A device wear day across a DST change showing a confusing ring.

## ADR-012: The local UTC offset is derived exactly

**Decision.** The offset is `(local day number - UTC day number) * 1440 + local minute - UTC minute` (`TwoSunsLocalTime.offsetBetween`), from one instant read twice with `Gregorian.info` and `Gregorian.utcInfo`. It is not wrapped to +-12 hours, so +14:00 works, and `System.getClockTime().timeZoneOffset` and `.dst` are not used.
**Why.** The Garmin docs say only "time offset from UTC in seconds" and "daylight savings time offset"; comparing two readings of the same instant needs no assumption. Comparing day numbers as well as clock times keeps +14:00 and -10:00 (the same clock time, 24 hours apart) from being mixed up. This replaces the spec's original "wrapped to +-12 h" rule.
**Evidence.** Simulator test: `TwoSunsLocalTimeTest`. Probe Q8 on a watch (does `timeZoneOffset` plus `dst` equal the derived difference?) has not been run and is not needed for the face.
**Reversed by.** Nothing planned; a watch where the two readings of one instant disagree in a way the arithmetic cannot absorb.

## ADR-013: Sky states and the calculation fallback

**Decision.** `TwoSunsSky.resolve` takes Garmin's sunrise and sunset first. If both are null but a place is known, the calculation fills in; a polar day or night comes from the calculation only. If a place is unknown, the sentence is "No place yet" when Complications exist and "No sun data" when they do not. If only one is null (a transition day) the missing time is taken from the calculation when there is one. A sunset earlier than the sunrise means the sunset is after local midnight (add 1440). After sunset the sentence announces tomorrow's sunrise per ADR-004; with no place it shows today's Garmin sunrise flagged as an estimate ("Sunrise ~06:41"); if the calculation says the sun does not rise tomorrow it says "No sunrise tomorrow"; if nothing is known it says "Sunset HH:MM" or "No sun data". **Known edge:** on a day whose sunset is after local midnight (Reykjavik in June), the minutes from 00:00 to that sunset read "before sunrise", because Garmin's pair describes the date that is starting, not the sun still up from yesterday.
**Why.** Every failure has a sentence, never a blank (the category's signature complaint is blank sun times). The edge is accepted because fixing it needs yesterday's pair.
**Evidence.** Simulator test: `TwoSunsSkyTest` (13 tests: boundaries, tomorrow's offset, estimate, after-midnight sunset, polar states, transition day, no place and no data, fallback to the calculation), `TwoSunsReadingsTest`. The polar and transition rows use the simulator's canned Complication values and the calculation only.
**Reversed by.** The device compare; a real Reykjavik-like day showing the edge is worse than expected.

## ADR-014: Three wordings for the sun sentence

**Decision.** Each sun sentence has up to three wordings: full, shorter, shortest (`TwoSunsConfig.SKY_WORDING_LEVELS` = 2 levels below the full one). The layout takes the longest that fits the round chord at the row, stepping down in font as well. Sentences with no shorter form ("No place yet", "No sun data", "Sun is up") are kept to 14 characters or fewer in every language (`tools/check_strings.py`), and each last-resort wording with a time in it to 16 characters.
**Why.** The sun line sits low on the round screen where the chord is narrow. The strengthened screen-fit test failed on `fr265s` (360 px) and `venusq2` (320 by 360) with a single wording, before this fix.
**Evidence.** Simulator test: `everyStateFitsThisDisplay` on ten sizes, `skyLineShortWordings`, `stateListsSentencesLongestFirst`; `check_strings.py` passes on the current strings. The character limits are a proxy; `tools/fit_languages.sh` measures pixels and has **not been run**, so no translation has been fit-tested.
**Reversed by.** A translation that does not fit in `fit_languages.sh`, or a native reader rewriting the sentences.

## ADR-015: Body Battery data rules

**Decision.** The last 24 hours of `SensorHistory` Body Battery go into 96 buckets of 15 minutes by each sample's own `when` (never `getOldestSampleTime` or `getNewestSampleTime`); the newest sample in a bucket wins; only 0 to 100 is valid (127 means not worn and is dropped, so are null and negative values). A sample stamped up to 5 minutes ahead is clock skew and is kept in the last bucket; later is dropped. The value is **stale** when the newest sample is older than 60 minutes: the curve, the value and the glyph are muted, the dot and the glyph become outlines. The history is re-read at most every 300 seconds. Gaps stay gaps: no interpolation. If the watch has no history API (or reading it throws), the Complication BODY_BATTERY number is used when it is valid, with no curve. **If history exists but has no valid sample, the value is "--" and Garmin's number is not substituted.**
**Why.** Forum reports say the oldest and newest sample times do not match the samples. A wrong number is worse than "--". Staleness is a shape as well as a colour (ADR-017).
**Evidence.** Simulator test: `TwoSunsBatteryTest` (11 tests: 127, negative, 101, null, empty, one sample, hours-long gaps, out-of-order, stale, skew), `TwoSunsReadingsTest`, `TwoSunsCurveTest`. The simulator's history is synthetic (480 samples a minute apart, oldest-first, mostly dated in the future), so real cadence, order and sample count are unknown until the probe log.
**Reversed by.** Probe Q6 and Q7: fewer than 20 samples in 24 hours means 1-hour buckets ([`plan.md`](plan.md) phase 1).

## ADR-016: Rows follow font heights; drop order

**Decision.** Everything is a share of D, the shorter screen side. Each row takes the largest font up to a height cap (date 60 permille of D, time 230, value 80, sun line 75; the curve band at least 110), then the rows are stacked from those measured heights (Days To Go ADR-012), never from fractions. The stack may use 800 permille of the content circle's height. When it is too tall, optional rows drop in this order: **date, then curve, then sun line**. The time and the Body Battery value never drop. A curve that has less than 180 permille of D on its chord is dropped too, and the glyph and value stay. Rectangular screens are centred and sized by D. Ring and content circle are sized so text never touches the ring.
**Why.** System fonts do not scale with the screen; fractional bands overlapped on small screens in Days To Go.
**Evidence.** Simulator test: `everyStateFitsThisDisplay` (fails on a text cut with "...", an overlap, a dropped row or a stack taller than the span), `frameDropsRowsInOrder`, `framesDropRowsInOrderWhenTheScreenIsTiny`, `bigScreensKeepEveryRow`. The rectangles were not looked at by eye.
**Reversed by.** The owner's look approval changing the row set; a screen where the time or value cannot fit.

## ADR-017: Ring, curve and glyph encodings

**Decision.** Ring: a night track all the way round (`#5555AA`, 3.3:1 against black); civil twilight `#AAAAFF`; daylight still to come in the accent, daylight already gone in the dimmed accent (each `FF` channel to `AA`); golden hour `#FF5500` only when the setting is on and a place is known; white ticks at sunrise and sunset; the sun marker at now, white with a black halo, **solid when the sun is up, an outline when it is not**. No place or no data: a plain track and no marker. Midnight sun: fully lit. Polar night: dim, with twilight if it can be calculated. Curve: a fill (`#5555AA` fresh, `#555555` stale), a white line (muted when stale), the newest point a solid accent dot (fresh) or an outline dot (stale). Glyph: a level pill, not battery-shaped (no nub — amended 2026-09-27, owner feedback on a real-device photo: a battery-shaped glyph reads as watch battery on a Garmin face regardless of fill colour), a plain rounded bar filled left to right to the level in the accent, hollow when stale or when the value is "--". So stale is a shape as well as a colour, and a state is never colour alone.
**Why.** In bright sun the dim tracks must still read: the night track is at least 3:1 against black, and every dimmed accent is at least 4.6:1 (the unit test `dimPartsStayReadable` asserts at least 3:1 for the night track and for the dimmed form of all six). Two more colours are dimmer: the stale fill and the always-on text are `#555555`, 2.8:1, and are carried by shape and words rather than contrast.
**Evidence.** Simulator test: `TwoSunsRingPlanTest`, `TwoSunsCurveTest`, palette contrast test. Contrast ratios are computed from the hex values, not measured on a screen. **The look has not been approved by the owner and no screenshot of the face exists.**
**Reversed by.** The owner's look decision, or a bright-sun check on a MIP watch.

## ADR-018: List settings only

**Decision.** Five settings, all lists: Accent colour (sky default, mint, autumn, violet, pink, winter — amended 2026-09-27: sky replaced amber as the default, and amber/white were renamed autumn/winter, same hex values, after the owner read amber as a "low" warning on a real-device photo of a normal Body Battery value; see ADR-017), Ring orientation (noon at the top default, midnight at the top), Golden hour (off), Energy curve (on), Date (on). Property keys `Accent`, `Orientation`, `Golden`, `Curve`, `Date` never change once shipped. Properties only; no `date` or `numeric` settings. Values are validated and fall back to the defaults, so the face works with all defaults if the phone round trip fails. Generated by `tools/gen_settings.py`.
**Why.** Days To Go ADR-003: Garmin Connect's date picker and numeric limits failed in rival faces; a list has nothing to validate.
**Evidence.** Simulator test: `TwoSunsSettingsTest`; `tools/gen_settings.py --check` verifies the generated files and the `KEY_*` constants (a Monkey C test cannot see a changed default in `properties.xml`, because the simulator keeps the last saved settings). Not tested on a phone or in Garmin Connect.
**Reversed by.** A phone test showing a list setting failing to save.
