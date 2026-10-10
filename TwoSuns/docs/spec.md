# Two Suns: spec

Status: 2026-10-05. **Live since 2026-09-28** (https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b); Pro 1.1.0 and Free twin uploaded 2026-10-04, in review. As of 2026-09-27: Plan phases 2 to 6 done, pass in simulator (124 tests); spot-checks run on owner's FR965 (sunrise/sunset match, Positioning, on-watch Customize — ADR-005, ADR-019), but no full wear day yet, look had no formal approval pass beyond owner's own submission call. Location probes run (M1, M2 only; ADR-005): Positioning confirmed, not provisional. "Two Suns" confirmed (ADR-010, 2026-09-27); no trademark search done. Folder `TwoSuns/`, code prefix `TwoSuns`. Connect IQ watch face, independent of HeroSet, HeroFace, Days To Go: own look, own app id, no complication publishing. Where spec and build differ, see "Built vs specified" at end; reasons in [`decisions.md`](decisions.md). **2026-10-04: Free twin and Pro 1.1.0 built (2026-10-01), approved, uploaded (in Garmin review, simulator only): see "Free and Pro" below, ADR-020 (Free + Pro ladder). Everything else here describes Pro build (live app id) unless it says Free.**

Sources: [`reports/Body Battery and sun face research.md`](../../reports/Body%20Battery%20and%20sun%20face%20research.md) and notes in `research_notes/Body Battery and sun face research/` (start `platform.md`). Build order and state in [`archive/plan.md`](archive/plan.md); each decision below has ADR in [`decisions.md`](decisions.md).

## In one paragraph

Watch face answering one question at a glance: **how much light, how much energy, left today?** Time = hero. Bezel: 24-hour ring for sky's sun (noon top, night dim, daylight lit, sun marker); under time: last 24 hours of watch's Body Battery as curve, current point marked; bottom line: daylight left, or when sun returns. Sunrise and sunset = **Garmin's own numbers** (same as watch's Sunrise/Sunset glance), watch local time. Every failure has a sentence, not a blank. No verdicts on Body Battery, no mood, no advice. Nothing leaves watch.

## Decisions

| # | Decision | Status | Why |
|---|---|---|---|
| D1 | **Concept: sky's day + your energy on one dial**; hero = time | Built (ADR-001); look approved 2026-10-08 (status gate 4, owner's "consider all UI changes approved"; launcher icon not approved) | No rival relates the two (282 dashboards mention both; none built around it). Research report §1 |
| D2 | **Name Two Suns**, slug `two-suns`; runner-up **Sun Battery**. "Body Battery" = Garmin's trademark: never in name, icon, brand | **Confirmed** (ADR-010, 2026-09-27) | Zero store collisions both (`naming.md`); no trademark search done |
| D3 | **Price: paid, USD 1.99 — Garmin's first paid price step (superseded 2026-10-04: price = $2.50 tier, D16, ADR-026)** (custom prices not offered; same tier as Days To Go). Review cadence: ~~one review 45 days after approval~~ (retired 2026-10-04 by Free + Pro ladder, ADR-020), 60-day success test below | Owner, confirmed 2026-09-27 | Paid works for finish (Circles 2) but not yet for single-idea face (about 75 paid Body Battery/sun faces, 2 at 1,000+). Same risk as countdown |
| D4 | **v1 devices: 69 watch-face products at API ≥ 4.2** (Complications), Instinct MIP excluded (superseded 2026-10-04 by ADR-024, Instinct E and 3 Solar: 72 products, three Instincts in) | Built: all 69 compile at `-w --typecheck 3`; fit run on 10 of 11 screen sizes (ADR-009) | Garmin's own sun and Body Battery numbers, no location. Tier B (API 3.4 to 4.1, 23 products) in 1.1 |
| D5 | **Sunrise and sunset from `Complications` SUNRISE/SUNSET** (local seconds since midnight). `Weather.getSunrise/getSunset` **not primary**: follows watch's local day in simulator; allowed as tier B fallback and cross-check, never without location. **Build does not call it at all** | Decided (simulator evidence, ADR-003) | Reviewers compare to Garmin's glance, Complications need no location; rivals' "shows UTC" bugs = own conversion mistakes, not API's (`platform.md` §3) |
| D6 | **Everything else in sky = own NOAA calculation**: tomorrow's sunrise, dawn, dusk, golden hour, solar noon, sun height. Tomorrow's sunrise = calculated tomorrow + (Garmin today − calculated today) | Built (ADR-004): 27 USNO reference tests, ≤ 2 min where Observatory lists event; simulator | Garmin gives none. Own code: only public Monkey C library is LGPL |
| D7 | **Location order: `Activity.currentLocation` → Weather observation location → `Position.getInfo()` → last good place (rounded 0.1°, `Application.Storage`).** **Positioning confirmed, kept in manifest** | **Confirmed on owner's FR965, 2026-09-27** (ADR-005) | Real watch: `Activity.currentLocation` null even after GPS activity, Weather observation location null with or without one, `Position.getInfo` populated immediately, no activity run first (cached fix). `Position.getInfo` stays isolated in one function for cheap reversal, nothing found so far reverses it. M3 (outdoors, over time) and M4 (overnight) not run; cannot change this call, left for before submission |
| D8 | **Body Battery: `SensorHistory` 24 h curve + current value; `Complications` BODY_BATTERY as fallback for number** (only when watch has no history API or reading throws; never when history exists but holds no valid sample) | Built (ADR-015) | History gives shape = the information (Garmin's own page) |
| D9 | **No verdicts on Body Battery**: no mood, no advice, no good/bad colour in default. Phone setting called "Energy curve" | Decided (evidence, ADR-008) | Pokémon Sleep reviews: 59 of 505 ask background or colour choice, 9 to pick or turn off mood, one found sad pose upsetting; Garmin's page: "the occasional low-energy day is no cause for alarm" |
| D10 | **Always-on: time, Body Battery value, sun sentence, dim, drifting; no ring, no curve, no glyph, no date** | Built (ADR-007); device check open | Garmin's published always-on limit (unverified here: `watch-design-kit` `platform-facts.md` tags timing for re-fetch): over 10% pixels lit or one on for 3 minutes (original Venu; luminance from Venu 2; ADR-007 amended 2026-10-04); block moves every minute so any one pixel lit at most a minute either way |
| D11 | **Settings: lists only** (accent, ring orientation, golden hour on/off, energy curve on/off, date on/off), no `date`/`numeric` | Built (ADR-018) | Days To Go ADR-003 |
| D12 | **Languages: English + Days To Go's 14** | Built; machine-drafted, no native reader; **never fit-tested in translation** | Few strings; same caveat as Days To Go |
| D13 | **Category:** Health & Fitness or Utility | **Owner to choose** at listing time | Body Battery audience browses Health & Fitness; sun users Utility/Outdoor |
| D14 | **Own Monkey C code; copy calendar, layout, sleep patterns from Days To Go, no Barrel** | Built | Same reason as Days To Go D10 |
| D15 | **Free + Pro pair**: paid app becomes Two Suns Pro (1.1.0), Free twin added (1.0.0), one codebase, split at compile time (ADR-020, Free + Pro ladder); Free's Body Battery = Garmin's own number only (ADR-021, Body Battery in Free) | **Approved by owner 2026-10-04; names confirmed, Pro at $2.50 tier (D16); both uploaded by owner 2026-10-04, in Garmin review** | See "Free and Pro" below. ADR-020 superseded D3's day-45 review 2026-10-04 |
| D16 | **Price: Two Suns Pro at $2.50 tier** of Garmin's price points; Free is free; no price number in listing or site text (ADR-026 (price: the $2.50 tier for every paid app)) | **Owner, 2026-10-04** | Room for later discounts or rise; supersedes D3's price (store showed $2.25, documented $1.99). Set in upload form with 1.1.0 upload |

### Free and Pro

Status: **Approved by owner 2026-10-04 (ADR-020, ADR-021), uploaded 2026-10-04 (in Garmin review), simulator only.** Strategy and evidence: `../../reports/Free and Pro ladder.md`; build plan = WP5 in `../../reports/Free and Pro ladder execution plan.md`. Decision records: ADR-020 (Free + Pro ladder) and ADR-021 (Body Battery in Free) in [`decisions.md`](decisions.md). Names ("Two Suns" and "Two Suns Pro") confirmed (owner, 2026-10-04); price = $2.50 tier (ADR-026); store titles stay owner's.

| | **Free** (new app id, $0) | **Pro** (existing paid app id) |
|---|---|---|
| Manifest, jungle | `manifest.free.xml`, `monkey.free.jungle` | `manifest.xml`, `monkey.jungle` |
| On-watch name | Two Suns | Two Suns Pro |
| Version | 1.0.0 | 1.1.0 |
| Permissions | **`ComplicationSubscriber` only** | `ComplicationSubscriber`, `SensorHistory`, `Positioning` (Free's always subset of Pro's) |
| The time, 24-hour ring from Garmin's own sunrise and sunset, ticks, sun marker, daylight to come and gone | yes | yes |
| Sun sentence from Garmin's pair ("3h 42m of daylight", "Sunrise 06:41", "Sunrise ~06:41" after sunset, "Sun is up", "No sun data") | yes | yes, plus calculated ones below |
| Body Battery: Garmin's number beside solid bolt; `--` and hollow bolt when none | yes (ADR-021, Body Battery in Free) | yes |
| 24-hour energy curve, stale state (`SensorHistory`) | no | yes |
| Remembered place, own calculation: tomorrow's sunrise, civil twilight arcs, "Sun stays up/down today", "No sunrise tomorrow", "No place yet" | no (never says "No place yet": Garmin's null pair = "No sun data") | yes |
| Golden hour (setting and arc) | no | yes |
| Ring orientation (noon or midnight at top) | no (noon at top) | yes |
| Date row (setting) | no | yes |
| Accent colour, ids 0 to 5 (sky, mint, autumn, violet, pink, winter), on phone and in Customize | **yes** (every face has accent in Free, studio rule) | yes |
| Accent ids 6 to 11 | no | **deferred**: not built; Pro only when they come (cyan, lime, yellow, magenta; orange and coral not admitted: golden hour is `#FF5500`) |
| Always-on frame (time, value, sun sentence) | yes | yes |
| Languages (15), the 69 products | yes | yes |

Rules: Free has no "Pro" word, no locked or greyed item, no upgrade text, no Pro state it can reach. Phone sending Orientation, Golden, Curve or Date to Free is ignored (Free properties file does not define them, Free code never reads them). Free's rows re-stack without date and curve (rows follow font heights, ADR-016), so layout differs from Pro's default; nothing redesigned, **look not approved**. Whether date row and orientation belong in Pro = plan's call (WP5 step 3) and **owner decision**.

**Privacy-relevant facts, Free** (differ from Pro's, below): manifest asks no location, no history; Free build reads no location from any source (not activity, not weather observation, not `Position`), keeps **no remembered place, writes nothing to `Application.Storage`** (accent colour saved as Properties setting), sends nothing anywhere. Reads Garmin's own sunrise, sunset, Body Battery numbers from `Complications`, writes only Accent property when wearer changes it. Free privacy page and listing must say that, must not describe Pro's place or history to Free users. Pro facts unchanged (next sections).

### Price

**Update 2026-10-04 (D16, ADR-026: price: the $2.50 tier for every paid app):** Two Suns Pro moves to $2.50 tier of Garmin's price points (US $2.49, eurozone 2,99 EUR) with 1.1.0 upload, room to discount or raise later. No price number on site or in listing text. Rest of this section = 2026-09-27 position, kept as history.

Owner decision (confirmed 2026-09-27): paid, USD 1.99 — Garmin's first paid price step; custom prices such as $1.90 not offered, so same tier as Days To Go. Research adds nothing that changes it, one warning: **Night & Day** (50,000 downloads) lists free and unlocks on developer's own site; its 1★ reviews are about that. Do not do that. Days To Go's "Price review (reminder)" applies verbatim: 45 days after approval, using sales report, download bucket, reviews; write "Price review due <approval + 45 days>" into `TwoSuns/CLAUDE.md` and memory the day approval arrives (today line there reads "not set until approval"). **Garmin's app trials do not work for watch faces** (SDK `Trial_Apps`), so no native trial.

## What the face shows

Ring: 24 hours local clock time, noon at top by default, clockwise. Bottom line: one of following.

| State | When | Ring | Bottom line |
|---|---|---|---|
| Day | now between sunrise and sunset | daylight lit; part already gone dimmer; solid sun marker at now | hours and minutes of light left (e.g. "3h 42m of daylight", "41m of daylight" under an hour; ROADMAP 13.17) |
| Day, sunset unknown | transition day: sunrise known, sunset null, no calculation | daylight from sunrise to edge of day | "Sun is up" |
| Before sunrise | now < sunrise | full night dim; sunrise tick; outline marker | "Sunrise 06:41" |
| After sunset | now ≥ sunset | as above | "Sunrise 06:41" (tomorrow's: D6) |
| After sunset, no place | calculation unavailable, today's Garmin sunrise all there is | as above | "Sunrise ~06:41" (today's, flagged as estimate) |
| After sunset, sun does not rise tomorrow (**Pro only**) | calculation says so | as above | "No sunrise tomorrow" |
| After sunset, no sunrise known | nothing else to say | as above | "Sunset 20:52", or "No sun data" |
| Golden hour (setting on; **Pro only**) | place known; calculated stretches after sunrise and before sunset (sun lower than 6°) | warm arc over those stretches | as Day (sentence does not change) |
| Sun does not set (**Pro only**) | both Complication values null, calculation says midnight sun | ring fully lit, solid marker | "Sun stays up today" |
| Sun does not rise (**Pro only**) | as above, polar night | ring dim (twilight if calculable), outline marker | "Sun stays down today" |
| No place yet (**Pro only**; Free says "No sun data") | `Complications` exist, both values null, no location | ring plain, no sun marker | "No place yet" |
| No sun data | `Complications` unavailable, no location | as above | "No sun data" |

Free draws only rows not marked Pro only; ring has no twilight arc in Free (needs calculation). Sentences have shorter wordings for narrow row ("3h 42m light", "Rise 06:41", "Set 20:52", "Sun stays up", "No sunrise", "No sunset"); layout takes longest that fits (ADR-014, three wordings for sun sentence). Times follow system 12/24 h: 24 h keeps leading zero (06:41), 12 h drops it (6:41), shows no AM or PM. Date line = words in watch's language, never numbers; month first only for English with statute units, otherwise day first.

Body Battery under time:

| State | When | Curve | Number |
|---|---|---|---|
| Normal | ≥ 1 valid sample, any level | last 24 h in 96 buckets of 15 min, current point marked in accent; not drawn until two neighbouring buckets have samples (ADR-028 amendment 2026-10-08) | last valid sample (0 to 100), in accent whatever level (no dim below 30 since 2026-10-08, ADR-008 amendment) |
| Stale | newest sample older than 60 min | curve muted, dot hollow | last value muted |
| Not worn / none | no valid sample (null, or 127 = not worn) | none | `--`, muted (every shape since 2026-10-08) |
| Not available | `SensorHistory` absent on this watch, or reading throws | none | from Complication if valid, else `--` |

**Free** has only last row's path: Garmin's Complication number when valid (0 to 100), else `--` and hollow bolt; no curve, no stale state, because Complication carries no timestamp (ADR-021, Body Battery in Free). History that exists but holds no valid sample shows `--` and **never** falls back to Complication's number (ADR-015, Body Battery data rules). Glyph beside number = solid bolt in current battery colour since 2026-10-05 (ROADMAP 13.16; replaced bolt gauge of ADR-023, which replaced level pill of 2026-09-27), hollow (muted outline) when value stale or `--`.

Face never shows words good, low, rest, tired or any face/emoji for Body Battery.

### Watch battery row and Body Battery glyph (ADR-023, proposed until the wrist check, built, uploaded in Pro 1.1.0 2026-10-04)

Pro: muted row above stack with watch's charge (classic battery glyph, whole percent), setting `Battery` (Off by default since 2026-10-05, ROADMAP 13.13), drawn only where round chord has room (not small screens), never moving another row on round screens (on rectangle, switching on can step time down a size, ADR-028). Both tiers: Body Battery glyph = solid bolt in current battery colour (since 2026-10-05, ROADMAP 13.16; hollow when stale or missing), replacing level pill then bolt gauge. Weather row's next-day marker = arrow.

### Weather row (Pro, ADR-022, proposed until the wrist check, built, uploaded in Pro 1.1.0 2026-10-04)

Row between time and Body Battery band: sun up → observed condition icon (fixed hue per icon type, larger than others) and **feels-like** number (Celsius from Garmin, shown in watch's unit, one hue whatever condition), then up to three mono condition icons from hourly forecast at even steps to sunset, hour under each; before sunrise and after sunset → next daylight day (chevron and weekday after sunset only, condition, high and low, hours the hourly list reaches; low goes first on wide row). Pro only, setting `Weather`. Data from `Toybox.Weather` (no permission), cached 5 minutes; reading older than 3 hours, hourly entry whose hour has ended, condition with no icon, missing daily entry left out, never guessed. Full detail, fit table, order of giving way: ADR-022. Simulator only (canned weather); 12-entry hourly list starting at current hour seen once on FR965 (probe log line, 2026-10-03), matches forum.

## Data rules (all unit-tested)

**Day arithmetic.** Local date from clock; local minutes since midnight as integers. `TwoSunsCalendar` = copy of Days To Go's `DaysToGoCalendar` (integer calendar-day arithmetic, years 1970 to 2200). 24-hour ring = **wall-clock** minutes 0 to 1440: on DST change day ring has one-hour jump; documented, not fixed.

**Local offset.** Derived exactly from clock, not from `System.getClockTime().timeZoneOffset` or `.dst` (documented only as "time offset from UTC in seconds" and "daylight savings time offset"): `(local day number - UTC day number) * 1440 + local minute - UTC minute`, from one instant read with `Gregorian.info` and `Gregorian.utcInfo` (`TwoSunsLocalTime.offsetBetween`). **Not wrapped to +-12 h**, so +14:00 works (ADR-012). On-watch probe still prints all three.

**Sun times from Complications.** `Complications.getComplication(new Id(COMPLICATION_TYPE_SUNRISE)).value` = seconds since midnight local time or null. Accept 0 to 86399. Both non-null and sunrise < sunset: normal day. **Both non-null and sunset < sunrise: sunset after local midnight** (Reykjavik 21 June, sunset 00:04; simulator shows `set 03:13` before `rise 15:08`); treat as sunset + 1440 minutes, test it. Both null: polar or unknown (see below). One null: transition day: missing time taken from calculation when place exists, else face shows what exists. **Known edge:** on day whose sunset is after local midnight (Reykjavik in June) minutes 00:00 to that sunset read "before sunrise", because Garmin's pair describes date that is starting, not sun still up from yesterday. Accepted (ADR-013).

**Sun times from calculation** (`TwoSunsSun`, pure functions, `Float` maths): NOAA sunrise equation, declination and equation of time evaluated at **local noon of local date** (UT noon shifted by local offset), zenith 90.833° for sunrise and sunset, 96° civil twilight, 84° golden hour. Results = **local minutes since local midnight**, may be > 1440 (sunset after midnight, Reykjavik 21 June: 00:04 next day) or absent (polar). `cos H` outside ±1 = no event. Accept ±1 day at polar-circle transitions (Tromsø 18 May: Naval Observatory lists set 00:28 and rise 00:53 where one noon declination says "no set"). Build does not call `Weather.getSunrise/getSunset`; allowed only as cross-check and tier B fallback (D5). **Fallback rule:** if both Complication values null and place known, calculation fills in today's sunrise and sunset; polar day and night from calculation only. After sunset, tomorrow's sunrise = calculated tomorrow + (Garmin today - calculated today); no place → today's Garmin sunrise flagged as estimate; calculation says sun does not rise tomorrow → "No sunrise tomorrow".

**Reference tests** (from `research_notes/.../reference_sun_times.tsv`, US Naval Observatory), tolerance **2 minutes** for rise, set, solar noon, civil twilight: London BST, GMT, solstice, 29 March and 25 October DST days; Dubai (UTC+4) September and December; Honolulu (UTC−10, no DST) September and June; Sydney AEST and AEDT; Kathmandu (UTC+5:45); Auckland; New York including 8 March; Denver; Reykjavik summer and winter; Ushuaia; Singapore; Tromsø polar night (both null), midnight sun (both null), sun returns 20 and 21 January. Every test computes local minutes, compares to table. As built: 27 tests (one per row); tolerance 2 minutes where Observatory lists event; polar rows assert kind and "no event"; two polar-circle transition days check solar noon only. Simulator only.

**Location.** Order in decision D7. Place = `[lat, lon]` rounded to 0.1° (about 11 km) before stored; accuracy sun times need = minutes per 0.25°. Stored under one key (`place`); replaced only when fresher source gives place more than 0.1° away in either coordinate (both already rounded, so in effect steps of 0.2°); fix of exactly (0, 0) rejected as no-fix placeholder; values read back from storage accepted as any numeric type and re-validated; **never sent anywhere** (ADR-006). `Position.getInfo` isolated in `TwoSunsSources.positionLocation` (ADR-005).

**Body Battery.** `SensorHistory.getBodyBatteryHistory({:period => new Time.Duration(86400)})`, newest first. Keep sample only if `data` is Number/Float, not null, 0 ≤ data ≤ 100. Bucket by each sample's own `when` (never `getOldestSampleTime`/`getNewestSampleTime`: forum bug reports say they do not match samples). Sample stamped up to 5 minutes ahead = clock skew, kept in last bucket; later dropped. Newest sample in bucket wins; gaps stay gaps. Refresh at most every 5 minutes; hold 96 buckets in memory only. Current value = newest kept sample; **stale** when older than 60 minutes. Watch has no history API or reading throws → Complication value when valid, else `--`. History exists but no valid sample → `--` (no substitution). See ADR-015.

**Battery and CPU.** One redraw a minute (no `onPartialUpdate`). Nothing recomputed that did not change: sun geometry once per local date and on change of place or offset; Body Battery history every 5 minutes. No battery figure claimed until measured on watch.

## Settings

All lists (Properties only for settings; `Application.Storage` only for remembered place, nothing else):

| Setting | Values | Default |
|---|---|---|
| Accent colour | six colours (64-colour safe): sky, mint, autumn, violet, pink, winter | sky (2026-09-27: changed from amber — amber read as "low" warning at normal value, on real-device photo; autumn and winter are old amber and white, renamed not recoloured) |
| Ring orientation | Noon at the top / Midnight at the top | Noon at the top |
| Golden hour | On / Off | Off |
| Energy curve | On / Off | On |
| Date | On / Off | On |
| Weather | On / Off | Off (Pro only; Off by default since 2026-10-05, ROADMAP 13.13) |
| Watch battery | On / Off | Off (Pro only; Off by default since 2026-10-05, ROADMAP 13.13) |

**Free has Accent row only** (same six colours, default sky); other six Pro only (see "Free and Pro"). Property keys: `Accent`, `Orientation`, `Golden`, `Curve`, `Date`, `Weather`, `Battery`; never change once shipped (Free properties file defines `Accent` alone). Curve setting labelled "Energy curve", not "Body Battery" (trademark, D9). Values validated; anything unexpected falls back to default. Settings re-read on every update.

Time format follows system 12/24 h. No numeric fields. Settings reach watch from Garmin Connect, or on-watch via `getSettingsView` (Customize, next to Apply in watch-face picker; ADR-019) — both write same Properties, last write wins. **Face works with all defaults if neither round trip ever runs** (Days To Go lesson).

## Design brief (as built; shipped by the owner with 1.0.0)

Visual system as built in [`../DESIGN.md`](../DESIGN.md). **Launcher icon not approved; look passed status gate 4 on 2026-10-08** on owner's "consider all UI changes approved" (relayed by coordinator; no fenix7x capture). Before that, rectangles' square form (ADR-028, rectangle track) approved by owner 2026-10-08 from simulator screenshots in `../../device-test/rect-review/after/`, and round follow-up of that day (muted `--`, no lone dot) and curve's room (ADR-028 second amendment) covered by that statement. Simulator screenshots exist since 2026-10-04 (`../docker/shot.sh`, `../docker/capture.sh`). Decided by build, not owner: colours, row drop order. Glyph shape (2026-09-27) was owner's call, on real-device photo.

Constraints (SDK and Days To Go): primitives and system fonts only, no bitmaps; proportional layout with measured text fit; 64-colour safe values (each channel 00, 55, AA or FF; one exception: AMOLED-only always-on grey `#5C5C5C`, ADR-027); black ground; state never colour alone. **In bright sun dim tracks must still read**: night track at least 3:1 against black (`#5555AA`, 3.3:1, computed from hex value, not measured on screen).

Direction, **"two suns"**: black ground; one accent; 24-hour ring around bezel. Ring encoding: night = dim track; civil twilight = light lavender; daylight still to come = accent; daylight already gone = accent with each FF channel dropped to AA; sunrise and sunset = short white radial ticks; sun = white dot with black halo on ring at current time, solid when sun up, outline when not; golden hour (setting) = `#FF5500` arc. Time = hero, largest of `FONT_NUMBER_HOT`, `MEDIUM`, `MILD` that fits under 260 permille of shorter side (raised from 230, owner feedback on real FR965, 2026-09-27). Under time, one band: solid bolt (hollow when stale or `--`; replaced level pill and bolt gauge, see "Built vs specified"), Body Battery value in accent whatever level (muted grey when stale or `--`; dim below 30 removed 2026-10-08, ADR-008), and 24-hour curve (white line, no fill since 2026-10-05, current point a dot: solid in accent, outline when stale; not drawn until two neighbouring samples exist). Bottom line = sun sentence. Date small and muted, above time. No layer overlaps another (Sun Watch Toutou complaint: steps bar over sun times).

Rows stacked from measured font heights (Days To Go ADR-012), not fractions. **Drop order** on small screen: date, then curve, then sun line; time and Body Battery value never drop; curve with no room on its chord dropped too (ADR-016). Ring and time kept on smallest supported screen (218 px MIP).

**Free (ADR-025):** awake, Body Battery number one size larger than in Pro (stack has room); always-on frame keeps small size. Measured: on `venusq2` 130 permille cap picks `FONT_XTINY`, same as Pro, so size up does not happen there under this rule; on rectangles number grows with time instead (ADR-028).

**Always-on (AMOLED):** time, Body Battery number, sun sentence in `#5C5C5C`, dim grey (ADR-007, amended 2026-09-27; colour changed by ADR-027, always-on text is a dim grey), whole block stepping across 3 by 3 grid every minute (ADR-007). No ring, no curve, no glyph, no date. Time two font steps below awake time; on rectangle below grown awake time, in list continuing past `FONT_NUMBER_MILD` to `FONT_LARGE` and `FONT_MEDIUM`, so always smaller (ADR-028). MIP watches show full face at all times.

## Devices and memory

**v1: 69 products, API ≥ 4.2, `minApiLevel` 4.2.0, one build, no bitmaps** (72 since ADR-024 added three Instincts, 2026-10-04; 69 counts below = round and rectangular set). From SDK's `Devices/*/compiler.json` (`deviceGroup`), 2026-09-26. **Everything here simulator-only until a watch runs it.** Watch-face memory at least 128 KB on all 69. Memory used in normal (non-test) run not recorded. Weather row (ADR-022) grew Pro's `.prg` from 172,412 to 190,716 bytes on `fr965` and `fr255s` (+18.3 KB, 2026-10-03); simulator does not emulate watch's memory limit (reports 8 MB), so runtime memory on lowest-memory product **not measured**.

| Screen | Products | `manifest` ids |
|---|---|---|
| 466 px AMOLED | 1 | `fenix9pro51mm` |
| 454 px AMOLED | 14 | `approachs7047mm`, `d2mach2`, `d2mach2pro`, `descentmk351mm`, `epix2pro51mm`, `fenix847mm`, `fenix8pro47mm`, `fenix947mm`, `fenix9pro47mm`, `fr57047mm`, `fr965`, `fr970`, `venu3`, `venu445mm` |
| 448 × 486 px AMOLED | 1 | `venux1` |
| 416 px AMOLED | 12 | `d2airx10`, `d2mach1`, `epix2`, `epix2pro47mm`, `fenix843mm`, `fenix943mm`, `fenix9pro43mm`, `fenixe`, `fr265`, `instinct3amoled50mm`, `venu2`, `venu2plus` |
| 390 px AMOLED | 19 | `approachs50`, `approachs7042mm`, `descentg2`, `descentmk343mm`, `epix2pro42mm`, `fr165`, `fr165m`, `fr170`, `fr170m`, `fr57042mm`, `fr70`, `instinct3amoled45mm`, `instinctcrossoveramoled`, `marq2`, `marq2aviator`, `venu3s`, `venu441mm`, `vivoactive5`, `vivoactive6` |
| 360 px AMOLED | 2 | `fr265s`, `venu2s` |
| 320 × 360 px AMOLED | 2 | `venusq2`, `venusq2m` |
| 280 px MIP | 6 | `enduro3`, `fenix7x`, `fenix7xpro`, `fenix7xpronowifi`, `fenix8solar51mm`, `fenix9prosolar51mm` |
| 260 px MIP | 8 | `fenix7`, `fenix7pro`, `fenix7pronowifi`, `fenix8solar47mm`, `fenix9prosolar47mm`, `fr255`, `fr255m`, `fr955` |
| 240 px MIP | 2 | `fenix7s`, `fenix7spro` |
| 218 px MIP | 2 | `fr255s`, `fr255sm` |

- Three rectangular ones (Venu Sq 2, Sq 2 Music, Venu X1) have own square form since 2026-10-05 (ADR-028, rectangle track, accepted 2026-10-08): sky ring = rounded-rectangle track along glass with 24 hours by its length (noon or midnight top centre, clockwise), rows fill rounded box inside, time grows into room left; every meaning and colour = round face's (muted `--` and hidden lone-dot curve were rectangle-only until round followed 2026-10-08, ADR-028 amendment) (`../DESIGN.md` "Rectangle"). Fit-tested on `venusq2` and `venux1`, both tiers; screenshots exist (simulator only); owner approved look from those screenshots 2026-10-08; round follow-up of same day (muted `--`, no lone dot) approved by owner that day too; curve's room (ADR-028 second amendment, 2026-10-08) approved same day.
- **Excluded:** every product below API 4.2. (Instinct 3 Solar 45 mm and Instinct E 40 and 45 mm excluded here until ADR-024 (Instinct E and 3 Solar) added them 2026-10-04: 72 products, `../CLAUDE.md`.) fēnix 5 Plus family has no Body Battery in SDK lists, out permanently.
- **Tier B (1.1, gated on probe): 23 products, API 3.4 to 4.1** (fēnix 6 family, FR55, FR945 LTE, MARQ Gen 1, Enduro, Descent Mk2, Instinct 2 family). No Complications: sunrise and sunset must come from calculation and location, the failure path reviews describe, so ships only when location probe shows a source that works.
- fēnix 9 family, FR70, FR170 (API 6.0) in v1 by API level; SDK's device lists omit them (doc lag), like settings-view case in Days To Go. First run = risk: **verify on real watch or say so on listing.**
- **Export oddity:** `.iq` export claims more devices than manifest lists (89 against 69). Explained 2026-10-01 from SDK's own device files (69 product ids have exactly 89 part numbers, all in package); store form's own list stays authoritative; details in [`compatibility.md`](compatibility.md#the-export-and-89-devices).
- **Fit test coverage:** all 11 screen sizes and all 69 round and rectangular products by full sweep of 2026-09-27 (`tools/fit_products.sh`, 69 pass), rectangles then in round-centred form, sweep predates later changes; rectangles' square form (ADR-028, rectangle track) runs on `venusq2` and `venux1` since 2026-10-05 (full suites 2026-10-07). English strings only, except 15-language fit on Instinct sizes (2026-10-04) and on `venusq2` and `venux1` (2026-10-06/07, both tiers, all pass) ([`compatibility.md`](compatibility.md)).
- Pro (paid) only: sold on SDK's App_Sales product list (lowest tier CIQ 3.4) and its country list, so store list shorter than manifest. No watch count in listing. Free twin lists same 69 products, not held to that list (Free listing's real device list only known after approval).

## Permissions, privacy, store form

**Free's manifest permission = `ComplicationSubscriber` alone** (see "Free and Pro" for privacy facts). Pro's, unchanged: **`SensorHistory`**, **`ComplicationSubscriber`**, **`Positioning`** (D7, confirmed on-device 2026-09-27, ADR-005). The one call needing it, `Position.getInfo`, stays isolated in `TwoSunsSources.positionLocation` for cheap reversal if that ever changes. `Application.Storage` needs no permission. No `Background`, `Communications`, `UserProfile` or network. Connect IQ review guidelines: "seek permission from users prior to collecting location data or data that may be considered sensitive" and no medical claims (SDK `App_Review_Guidelines`). Body Battery health-adjacent: privacy page says what is read (Body Battery history, Garmin's own sunrise and sunset, location rounded to 0.1° that stays on watch), never sent, never stored beyond remembered place.

Store name, description, site copy **describe** ("shows your watch's Body Battery, the sun's arc and how much light is left"), never claim ("improves recovery"), never use "Body Battery" as brand.

Site pages (created with listing, `site/src/apps/two-suns/`): landing, support (what "No place yet" means; Garmin Connect settings; how to make Garmin's sunrise appear), privacy. Published URLs never change.

## Claims that may be made (the checkable version is [`release-contract.md`](release-contract.md))

Allowed only after matching test or device check: "sunrise and sunset match your watch's own Sunrise/Sunset glance" (after device compare), "works without GPS or your phone" (after run with both off), "your location never leaves the watch", "shows your last 24 hours of Body Battery". Forbidden until measured on device: battery figures, always-on ghosting, MIP contrast, any watch count, any download or rating figure, accuracy of Body Battery. None of allowed claims has its check yet: no device compare, no run with phone and GPS off, no location check done. Forbidden always: anything about health outcomes, "improves", "optimises", "recovery advice"; words "accurate Body Battery"; any statement about rivals by name.

## Non-goals (v1)

Moon phase, heart rate, steps, seconds, notifications, multiple locations or "time zones", city-search or coordinates setting, sunrise alarms, mood or emoji for Body Battery, predictions of Body Battery, sleep score or training readiness, complications publishing, `date`/`numeric` settings, Instinct 2 family and tier B/C/D watches (Instinct E and 3 Solar in since ADR-024), any network.

(Weather listed here until 2026-10-03: owner overrode it for Pro-only weather row, ADR-022 (Weather row in Pro, Proposed, not built); nothing else from this list changes.)

(On-watch settings screen listed here when written; ADR-019 built one — `getSettingsView()`, "Customize" — after sideloaded apps turned out to need it for any on-watch settings access at all. Removed from list rather than left contradicting built ADR.)

## Ideas for a later version (not scoped, not designed)

Owner notes, 2026-09-27, from real-device look. Neither v1 nor blocking; both need own design pass before building.

- **Always-on: Body Battery number has no context.** Awake it sits next to bolt and under ring, so reads as Body Battery by position; asleep (D10, ADR-007) bare number, nothing marks what it is. Flagged again by `watch-design-reviewer` (`watch-design-kit`, 2026-09-27): still open, still not designed. Small mark or word surviving AMOLED lit-pixel budget (commonly-cited ≤10%, uncited) needs own design and real-device check, not just re-adding awake pill blind.
- **Stress level.** Garmin exposes stress score (`ActivityMonitor`/`SensorHistory`, not yet researched for this app). Adding it means new data source, own validity/staleness rules (like Body Battery's), place in layout not crowding ring, curve or sun line, and decision whether it changes "no mood, no advice" rule (D9) — stress readings invite good/bad reading more than Body Battery does, so ADR-008 would need revisiting, not just extending.

## Risks and unknowns

| Risk / unknown | Evidence | Handling |
|---|---|---|
| Real watch returns no location to a face | Simulator: Weather's location only with Positioning; `Activity.currentLocation` null; forum: "start any activity, wait for GPS, discard it" | **Probes first** (plan phase 1). v1's sun ring works from Complications without location; only tomorrow's sunrise, dawn, dusk, golden hour need one, each hides itself cleanly |
| Positioning adds nothing on real watch | Simulator: Weather's location needs it, `Position.getInfo` returns null | Drop permission if probe N (without it) still gets location from Activity or Weather; listing then says so |
| Complication sun values differ from native glance or null on some watches | Simulator values canned | Probe prints them; null on a watch → that watch shows "No sun data" (not blank); device compare = release gate |
| `Weather.getSunrise` follows watch's local day: simulator only | Hourly sweep over both midnights | Not primary source (D5); change-log probe records it across real local midnight |
| Body Battery history cadence and sample count unknown | Simulator gives 480 samples a minute apart from clock into future (face keeps one: one dot, no line; measured 2026-10-08) | 96-bucket downsample; probe prints n, smallest gap, gap distribution (how often consecutive samples land in neighbouring 15-minute buckets: curve draws only there, ADR-028 amendment 2026-10-08, ADR-015); cost measured on device |
| Body Battery accuracy | No independent validation of composite score found | Show Garmin's number as Garmin reports; no claims |
| Copy from Vesper Solar and many sun faces | Vesper Solar, 3 days old | Moat: correct numbers, no blanks, Body Battery curve, finish |
| Translations never fit-tested; no native reader | `tools/fit_languages.sh` run on Instinct sizes and both rectangles (all 15 languages pass, simulator); not on smallest round `fr255s`; `tools/check_strings.py` checks parity and length only | Run on smallest and a rectangular screen before shipping any language; say "machine-drafted" |
| Stale curve = muted `#AAAAAA` line, 9:1 (its `#555555` fill, 2.8:1, gone since 2026-10-05); always-on text was `#555555`, raised to `#5555AA` 2026-09-27 and moved to grey `#5C5C5C` (3.1:1) 2026-10-04 (ADR-027, always-on text is a dim grey) | Computed from hex value | Stale carried by shape (hollow glyph, outline dot), awake-only; check on MIP watch in daylight |
| Nobody pays for single-idea face | about 75 paid Body Battery/sun faces, 2 at 1,000+ | Flagged; same price review and success test as Days To Go |
| DST day ring jump | Wall-clock ring | Documented; test covers 29 March and 25 October London |
| Polar-circle transition days | USNO vs one-noon declination | ±1 day accepted, tested, documented |
| 64 KB watches and older firmware | Tier B excluded; 64 KB Instinct E and 3 Solar in since ADR-024 (Pro 44.4 of 59.8 kB since 2026-10-10, after Out Of Memory crash at 50.0 kB: `compatibility.md` "Memory, 2026-10-10", ADR-024 amendment) | `has` guards everywhere; v1 minimum memory 128 KB |

## Success and stop test (proposal, owner to confirm)

Judge 60 days after approval, on developer dashboard (sales report) and store. Claim under test: *people will pay for a face that gets the sun right and shows their energy as a curve.* Paid: any sales at all, and at least one review not about setup. No sales and downloads stay in lowest bucket → stop: choose between switch to free (harder to undo) and leaving it. Do not build second face in this style on lowest-bucket result. Extra signal to record: **reviews mentioning wrong or blank sun times** (category's signature complaint); zero of them after 60 days = real result.

## Built vs specified

What build did differently from spec as first written (2026-09-26). Each in ADRs.

| Spec (or plan) said | The build does | ADR |
|---|---|---|
| Local offset = clock difference, wrapped to +-12 h | Exact: day numbers compared too, no wrapping (+14:00 works) | 012 |
| Both Complication values null: polar or unknown | Place known → calculation fills in; polar day and night come from it; unknown place gives "No place yet" (Complications exist) or "No sun data" (they do not) | 013 |
| One null: "show what exists" | Missing time from calculation when place exists | 013 |
| Edge case: sunset after midnight handled | Handled (+1440); known edge: 00:00 to that sunset reads "before sunrise" | 013 |
| One bottom sentence per state | Up to three wordings (full, shorter, shortest), chosen by measured fit; added after fit test failed on `fr265s` and `venusq2` | 014 |
| Sun line "Sunrise 06:41" after sunset | Also "Sunrise ~06:41" (estimate), "No sunrise tomorrow", "Sunset 20:52", "Sun is up" | 013 |
| Golden hour = state with sun below 6 degrees | Golden hour only adds ring arc, only with place; sentence never changes. `TwoSunsSky.golden` computed and tested but nothing draws from it | 017 |
| Settings table: "Body Battery curve" | Setting labelled "Energy curve" (trademark) | 018 |
| Body Battery: Complication as fallback for number | Also when reading history throws; not when history exists but has no valid sample ("--") | 015 |
| Sample stamped in future: not specified | Up to 5 minutes ahead = clock skew, kept; later dropped | 015 |
| Design brief: glyph, colours, drop order open | Decided by build (since 2026-10-05 solid bolt, ROADMAP 13.16; earlier): level pill (2026-09-27: changed from battery-shaped glyph — owner feedback on real-device photo, it read as watch battery), palette in DESIGN.md, drop order date then curve then sun line | 016, 017 |
| Body Battery curve: drawn when there is history | Pro, Curve on: band keeps curve's room (its height, bolt and number at left edge) whenever watch has history API, line drawn only once two neighbouring 15-minute buckets hold samples; nothing moves when it lands or ages out (simulator only) | 028 (amendment 2026-10-08) |
| Always-on: "time and the two numbers" (D10) | Time, Body Battery value, sun sentence; no ring, curve, glyph, date | 007 |
| `Position.getInfo` in location order | Isolated in one function so dropping Positioning = deletion | 005 |
| Weather sun API as cross-check | Not called at all | 003 |
| Plan phase 5: fit test on ten sizes plus two rectangles | `tools/fit_all.sh` runs ten devices (`venusq2` only rectangle); Venu X1's full suites, screen fit included, run since 2026-10-05 (ADR-028); other 58 products not run by it | 009, 028 |
| Plan phase 6: languages fit-tested | Strings written and parity-checked; `tools/fit_languages.sh` run on Instinct sizes (2026-10-04) and on `venusq2` and `venux1`, both tiers (2026-10-06/07): all 15 languages pass both screen-fit tests, simulator only; not run on `fr255s` | 014, 028 |