# Two Suns: spec

Status: 2026-09-27. **Submitted to the Connect IQ Store, pending review** (https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b, live once approved). Plan phases 2 to 6 are done and pass in the simulator (124 tests); spot-checks have run on the owner's FR965 (sunrise/sunset match, Positioning, on-watch Customize — ADR-005, ADR-019), but no full wear day yet, and the look has not had a formal approval pass beyond the owner's own submission call. The location probes have run (M1, M2 only; ADR-005): Positioning is confirmed, not provisional. "Two Suns" is confirmed (ADR-010, 2026-09-27); no trademark search done. Folder `TwoSuns/`, code prefix `TwoSuns`. A Connect IQ watch face, independent of HeroSet, HeroFace and Days To Go: own look, own app id, no complication publishing. Where this spec and the build differ, see "Built vs specified" at the end; the reasons are in [`decisions.md`](decisions.md). **2026-10-01: a Free twin and Pro 1.1.0 are built, proposed and UNRELEASED (simulator only, nothing uploaded): see "Free and Pro" below and ADR-020 (Free + Pro ladder). Everything else in this spec describes the Pro build (the live app id) unless it says Free.**

Sources: [`reports/Body Battery and sun face research.md`](../../reports/Body%20Battery%20and%20sun%20face%20research.md) and the notes in `research_notes/Body Battery and sun face research/` (start with `platform.md`). The build order and state are in [`archive/plan.md`](archive/plan.md); each decision below has an ADR in [`decisions.md`](decisions.md).

## In one paragraph

A watch face that answers one question at a glance: **how much light, and how much energy, do I have left today?** The time is the hero. Around the bezel runs a 24-hour ring for the sky's sun (noon at the top, night dim, daylight lit, a marker for the sun); under the time runs the last 24 hours of the watch's Body Battery as a curve with the current point marked; one line at the bottom says how much daylight is left, or when the sun returns. Sunrise and sunset are **Garmin's own numbers** (the same as the watch's Sunrise/Sunset glance), in the watch's local time. Every failure has a sentence, not a blank. No verdicts on Body Battery, no mood, no advice. Nothing leaves the watch.

## Decisions

| # | Decision | Status | Why |
|---|---|---|---|
| D1 | **Concept: sky's day + your energy on one dial**; hero = time | Built (ADR-001); look **not approved** | No rival relates the two (282 dashboards mention both; none is built around it). Research report §1 |
| D2 | **Name Two Suns**, slug `two-suns`; runner-up **Sun Battery**. "Body Battery" is Garmin's trademark: never in the name, icon or brand | **Confirmed** (ADR-010, 2026-09-27) | Zero store collisions for both (`naming.md`); no trademark search done |
| D3 | **Price: paid, USD 1.99 — Garmin's first paid price step (superseded 2026-10-04: the price is the $2.50 tier, D16, ADR-026)** (custom prices are not offered; this is the same tier as Days To Go). Review cadence: ~~one review 45 days after approval~~ (retired 2026-10-04 by the Free + Pro ladder, ADR-020), the 60-day success test below | Owner, confirmed 2026-09-27 | Paid works for finish (Circles 2) but not yet for a single-idea face (about 75 paid Body Battery/sun faces, 2 at 1,000+). Same risk as the countdown |
| D4 | **v1 devices: the 69 watch-face products at API ≥ 4.2** (Complications), Instinct MIP excluded | Built: all 69 compile at `-w --typecheck 3`; fit run on 10 of 11 screen sizes (ADR-009) | Garmin's own sun and Body Battery numbers with no location. Tier B (API 3.4 to 4.1, 23 products) in 1.1 |
| D5 | **Sunrise and sunset come from `Complications` SUNRISE/SUNSET** (local seconds since midnight). `Weather.getSunrise/getSunset` is **not the primary**: it follows the watch's local day in the simulator and is allowed as the tier B fallback and a cross-check, never without a location. **The build does not call it at all** | Decided (simulator evidence, ADR-003) | Reviewers compare to Garmin's glance, and Complications need no location; the rivals' "shows UTC" bugs are their own conversion mistakes, not the API's (`platform.md` §3) |
| D6 | **Everything else in the sky is our own NOAA calculation**: tomorrow's sunrise, dawn, dusk, golden hour, solar noon, sun height. Tomorrow's sunrise = calculated tomorrow + (Garmin today − calculated today) | Built (ADR-004): 27 USNO reference tests, ≤ 2 min where the Observatory lists an event; simulator | Garmin gives none of these. Own code because the only public Monkey C library is LGPL |
| D7 | **Location order: `Activity.currentLocation` → Weather observation location → `Position.getInfo()` → last good place (rounded 0.1°, `Application.Storage`).** **Positioning confirmed, kept in the manifest** | **Confirmed on the owner's FR965, 2026-09-27** (ADR-005) | On the real watch: `Activity.currentLocation` null even after a GPS activity, Weather's observation location null with or without one, `Position.getInfo` populated immediately with no activity run first (a cached fix). `Position.getInfo` stays isolated in one function for a cheap reversal, but nothing found so far reverses it. M3 (outdoors, over time) and M4 (overnight) were not run; they cannot change this call and are left for before submission |
| D8 | **Body Battery: `SensorHistory` 24 h curve + current value; `Complications` BODY_BATTERY as the fallback for the number** (only when the watch has no history API or reading it throws; never when history exists but holds no valid sample) | Built (ADR-015) | History gives the shape, which is the information (Garmin's own page) |
| D9 | **No verdicts on Body Battery**: no mood, no advice, no good/bad colour in the default. The phone setting is called "Energy curve" | Decided (evidence, ADR-008) | Pokémon Sleep reviews: 59 of 505 ask for background or colour choice, 9 to pick or turn off the mood, one found the sad pose upsetting; Garmin's page: "the occasional low-energy day is no cause for alarm" |
| D10 | **Always-on: the time, the Body Battery value and the sun sentence, dim, drifting; no ring, no curve, no glyph, no date** | Built (ADR-007); device check open | Days To Go ADR-007: a commonly-cited ≤10% lit pixels (uncited); the block moves every minute so any one pixel is lit for at most a minute either way |
| D11 | **Settings: lists only** (accent, ring orientation, golden hour on/off, energy curve on/off, date on/off), no `date`/`numeric` | Built (ADR-018) | Days To Go ADR-003 |
| D12 | **Languages: English + Days To Go's 14** | Built; machine-drafted, no native reader; **never fit-tested in translation** | Few strings; same caveat as Days To Go |
| D13 | **Category:** Health & Fitness or Utility | **Owner to choose** at listing time | Body Battery audience browses Health & Fitness; sun users Utility/Outdoor |
| D14 | **Own Monkey C code; copy the calendar, layout and sleep patterns from Days To Go, no Barrel** | Built | Same reason as Days To Go D10 |
| D15 | **Free + Pro pair**: the paid app becomes Two Suns Pro (1.1.0), a Free twin is added (1.0.0), one codebase, split at compile time (ADR-020, Free + Pro ladder); Free's Body Battery is Garmin's own number only (ADR-021, Body Battery in Free) | **Approved by the owner 2026-10-04; names confirmed, Pro at the $2.50 tier (D16); uploads are still the owner's** (UNRELEASED) | See "Free and Pro" below. ADR-020 superseded D3's day-45 review on 2026-10-04 |
| D16 | **Price: Two Suns Pro at the $2.50 tier** of Garmin's price points; Free is free; no price number in listing or site text (ADR-026 (price: the $2.50 tier for every paid app)) | **Owner, 2026-10-04** | Room for later discounts or a rise; supersedes D3's price (the store showed $2.25, the documented $1.99). Set in the upload form with the 1.1.0 upload |

### Free and Pro

Status: **Approved by the owner 2026-10-04 (ADR-020, ADR-021), UNRELEASED, simulator only; nothing built here is uploaded.** Strategy and evidence: `../../reports/Free and Pro ladder.md`; the build plan is WP5 in `../../reports/Free and Pro ladder execution plan.md`. The decision records are ADR-020 (Free + Pro ladder) and ADR-021 (Body Battery in Free) in [`decisions.md`](decisions.md). Names ("Two Suns" and "Two Suns Pro") are confirmed (owner, 2026-10-04); the price is the $2.50 tier (ADR-026); the store titles stay the owner's.

| | **Free** (new app id, $0) | **Pro** (the existing paid app id) |
|---|---|---|
| Manifest, jungle | `manifest.free.xml`, `monkey.free.jungle` | `manifest.xml`, `monkey.jungle` |
| On-watch name | Two Suns | Two Suns Pro |
| Version | 1.0.0 | 1.1.0 |
| Permissions | **`ComplicationSubscriber` only** | `ComplicationSubscriber`, `SensorHistory`, `Positioning` (Free's are always a subset of Pro's) |
| The time, the 24-hour ring from Garmin's own sunrise and sunset, ticks, sun marker, daylight to come and gone | yes | yes |
| The sun sentence from Garmin's pair ("3:42 of daylight", "Sunrise 06:41", "Sunrise ~06:41" after sunset, "Sun is up", "No sun data") | yes | yes, plus the calculated ones below |
| Body Battery: Garmin's number in a level pill; `--` and a hollow pill when there is none | yes (ADR-021, Body Battery in Free) | yes |
| 24-hour energy curve, the stale state (`SensorHistory`) | no | yes |
| Remembered place, our own calculation: tomorrow's sunrise, civil twilight arcs, "Sun stays up/down today", "No sunrise tomorrow", "No place yet" | no (never says "No place yet": Garmin's null pair is "No sun data") | yes |
| Golden hour (setting and arc) | no | yes |
| Ring orientation (noon or midnight at the top) | no (noon at the top) | yes |
| Date row (setting) | no | yes |
| Accent colour, ids 0 to 5 (sky, mint, autumn, violet, pink, winter), on the phone and in Customize | **yes** (every face has an accent in Free, studio rule) | yes |
| Accent ids 6 to 11 | no | **deferred**: not built; Pro only when they come (cyan, lime, yellow, magenta; orange and coral are not admitted: golden hour is `#FF5500`) |
| Always-on frame (time, value, sun sentence) | yes | yes |
| Languages (15), the 69 products | yes | yes |

Rules: Free has no "Pro" word, no locked or greyed item, no upgrade text and no Pro state it can reach. A phone that sends Orientation, Golden, Curve or Date to Free is ignored (the Free properties file does not define them and Free code never reads them). Free's rows re-stack without the date and the curve (rows follow font heights, ADR-016), so its layout differs from Pro's default; nothing was redesigned and **the look is not approved**. Whether the date row and the orientation belong in Pro is the plan's call (WP5 step 3) and an **owner decision**.

**Privacy-relevant facts, Free** (they differ from Pro's, below): the manifest asks for no location and no history; the Free build reads no location from any source (not the activity, not the weather observation, not `Position`), keeps **no remembered place and writes nothing to `Application.Storage`** (the accent colour is saved as a Properties setting), and sends nothing anywhere. It reads Garmin's own sunrise, sunset and Body Battery numbers from `Complications`, and writes only the Accent property when the wearer changes it. The Free privacy page and listing must say that, and must not describe Pro's place or history to Free users. The Pro facts are unchanged (the next sections).

### Price

**Update 2026-10-04 (D16, ADR-026: price: the $2.50 tier for every paid app):** Two Suns Pro moves to the $2.50 tier of Garmin's price points (US $2.49, eurozone 2,99 EUR) with the 1.1.0 upload, for room to discount or raise later. No price number appears on the site or in listing text. The rest of this section is the 2026-09-27 position, kept as history.

Owner decision (confirmed 2026-09-27): paid, USD 1.99 — Garmin's first paid price step; custom prices such as $1.90 are not offered, so this lands on the same tier as Days To Go. The research adds nothing that changes it, and one warning: **Night & Day** (50,000 downloads) lists free and unlocks on the developer's own site; its 1★ reviews are about that. Do not do that. Days To Go's "Price review (reminder)" applies verbatim: 45 days after approval, using sales report, download bucket and reviews; write "Price review due <approval + 45 days>" into `TwoSuns/CLAUDE.md` and memory the day approval arrives (today the line there reads "not set until approval"). **Garmin's app trials do not work for watch faces** (SDK `Trial_Apps`), so there is no native trial.

## What the face shows

Ring: 24 hours of local clock time, noon at the top by default, clockwise. Bottom line: one of the following.

| State | When | Ring | Bottom line |
|---|---|---|---|
| Day | now between sunrise and sunset | daylight lit; the part already gone dimmer; solid sun marker at now | `H:MM` of light left (e.g. "3:42 of daylight") |
| Day, sunset unknown | a transition day: sunrise known, sunset null and no calculation | daylight from sunrise to the edge of the day | "Sun is up" |
| Before sunrise | now < sunrise | full night dim; sunrise tick; outline marker | "Sunrise 06:41" |
| After sunset | now ≥ sunset | as above | "Sunrise 06:41" (tomorrow's: D6) |
| After sunset, no place | the calculation is unavailable, today's Garmin sunrise is all there is | as above | "Sunrise ~06:41" (today's, flagged as an estimate) |
| After sunset, sun does not rise tomorrow (**Pro only**) | the calculation says so | as above | "No sunrise tomorrow" |
| After sunset, no sunrise known | nothing else to say | as above | "Sunset 20:52", or "No sun data" |
| Golden hour (setting on; **Pro only**) | a place is known; the calculated stretches after sunrise and before sunset (the sun lower than 6°) | warm arc over those stretches | as Day (the sentence does not change) |
| Sun does not set (**Pro only**) | both Complication values null and the calculation says midnight sun | ring fully lit, solid marker | "Sun stays up today" |
| Sun does not rise (**Pro only**) | as above, polar night | ring dim (twilight if calculable), outline marker | "Sun stays down today" |
| No place yet (**Pro only**; Free says "No sun data") | `Complications` exist, both values null and no location | ring plain, no sun marker | "No place yet" |
| No sun data | `Complications` unavailable and no location | as above | "No sun data" |

Free draws only the rows not marked Pro only; the ring has no twilight arc in Free (it needs the calculation). The sentences have shorter wordings for a narrow row ("3:42 light", "Rise 06:41", "Set 20:52", "Sun stays up", "No sunrise", "No sunset"); the layout takes the longest that fits (ADR-014, three wordings for the sun sentence). Times follow the system's 12/24 h: 24 h keeps the leading zero (06:41), 12 h drops it (6:41) and shows no AM or PM. The date line is words in the watch's language, never numbers; month first only for English with statute units, otherwise day first.

Body Battery under the time:

| State | When | Curve | Number |
|---|---|---|---|
| Normal, at or above 30 | ≥ 1 valid sample, level ≥ 30 | last 24 h in 96 buckets of 15 min, current point marked in the accent | last valid sample (0 to 100), in the accent |
| Normal, below 30 | ≥ 1 valid sample, level < 30 | as above, current point dimmed (`dim(accent)`, ADR-008 amendment 2026-09-27) | dimmed, same colour, not a different hue |
| Stale | newest sample older than 60 min | curve muted, dot hollow | last value muted (overrides the level colour) |
| Not worn / none | no valid sample (null, or 127 = not worn) | none | `--` |
| Not available | `SensorHistory` absent on this watch, or reading it throws | none | from Complication if valid, else `--` |

**Free** has only the last row's path: Garmin's Complication number when it is valid (0 to 100), else `--` and a hollow pill; no curve, and no stale state, because a Complication carries no timestamp (ADR-021, Body Battery in Free). A history that exists but holds no valid sample shows `--` and **never** falls back to the Complication's number (ADR-015, Body Battery data rules). The level pill beside the number (2026-09-27: changed from a battery-shaped glyph on the owner's real-device read, which read as watch battery rather than Body Battery) is a small rounded outline, filled left to right to the level in the accent, hollow when the value is stale or `--`.

The face never shows the words good, low, rest, tired or any face/emoji for Body Battery.

### Watch battery row and Body Battery glyph (ADR-023, proposed, built, UNRELEASED)

Pro: a muted row above the stack with the watch's charge (classic battery glyph and a whole percent), setting `Battery` (On by default), drawn only where the round chord has room (not on small screens), never moving another row. Both tiers: the Body Battery glyph is a bolt gauge (dim bolt filled from the bottom to the level; hollow when stale or missing), replacing the level pill. The weather row's next-day marker is an arrow.

### Weather row (Pro, ADR-022, proposed, built, UNRELEASED)

A row between the time and the Body Battery band: while the sun is up, the observed condition icon (fixed hue per icon type, larger than the others) and the **feels-like** number (Celsius from Garmin, shown in the watch's unit, one hue whatever the condition), then up to three mono condition icons from the hourly forecast at even steps to sunset with the hour under each; before sunrise and after sunset, the next daylight day (a chevron and weekday after sunset only, condition, high and low, and the hours the hourly list reaches; the low goes first on a wide row). Pro only, setting `Weather`. Data from `Toybox.Weather` (no permission), cached 5 minutes; a reading older than 3 hours, an hourly entry whose hour has ended, a condition with no icon, and a missing daily entry are left out, never guessed. Full detail, the fit table and the order of giving way: ADR-022. Simulator only (canned weather); the 12-entry hourly list starting at the current hour was seen once on the FR965 (probe log line, 2026-10-03) and matches the forum.

## Data rules (all unit-tested)

**Day arithmetic.** Local date from the clock; local minutes since midnight as integers. `TwoSunsCalendar` is a copy of Days To Go's `DaysToGoCalendar` (integer calendar-day arithmetic, years 1970 to 2200). The 24-hour ring is **wall-clock** minutes 0 to 1440: on a DST change day the ring has a one-hour jump; documented, not fixed.

**Local offset.** Derived exactly from the clock, not from `System.getClockTime().timeZoneOffset` or `.dst` (documented only as "time offset from UTC in seconds" and "daylight savings time offset"): `(local day number - UTC day number) * 1440 + local minute - UTC minute`, from one instant read with `Gregorian.info` and `Gregorian.utcInfo` (`TwoSunsLocalTime.offsetBetween`). It is **not wrapped to +-12 h**, so +14:00 works (ADR-012). The on-watch probe still prints all three.

**Sun times from Complications.** `Complications.getComplication(new Id(COMPLICATION_TYPE_SUNRISE)).value` is seconds since midnight local time or null. Accept 0 to 86399. Both non-null and sunrise < sunset: normal day. **Both non-null and sunset < sunrise: the sunset is after local midnight** (Reykjavik 21 June, sunset 00:04; the simulator shows `set 03:13` before `rise 15:08`); treat it as sunset + 1440 minutes and test it. Both null: polar or unknown (see below). One null: transition day: the missing time is taken from the calculation when there is a place, else the face shows what exists. **Known edge:** on a day whose sunset is after local midnight (Reykjavik in June) the minutes from 00:00 to that sunset read "before sunrise", because Garmin's pair describes the date that is starting, not the sun still up from yesterday. Accepted (ADR-013).

**Sun times from a calculation** (`TwoSunsSun`, pure functions, `Float` maths): NOAA sunrise equation, declination and equation of time evaluated at the **local noon of the local date** (UT noon shifted by the local offset), zenith 90.833° for sunrise and sunset, 96° for civil twilight, 84° for the golden hour. Results are **local minutes since local midnight**, may be > 1440 (sunset after midnight, Reykjavik 21 June: 00:04 the next day) or absent (polar). `cos H` outside ±1 means no event. Accept ±1 day at the polar-circle transitions (Tromsø 18 May: the Naval Observatory lists a set at 00:28 and a rise at 00:53 where one noon declination says "no set"). The build does not call `Weather.getSunrise/getSunset`; they stay allowed only as a cross-check and the tier B fallback (D5). **Fallback rule:** if both Complication values are null and a place is known, the calculation fills in today's sunrise and sunset; polar day and night come from the calculation only. After sunset, tomorrow's sunrise = calculated tomorrow + (Garmin today - calculated today); with no place, today's Garmin sunrise flagged as an estimate; if the calculation says the sun does not rise tomorrow, "No sunrise tomorrow".

**Reference tests** (from `research_notes/.../reference_sun_times.tsv`, US Naval Observatory), tolerance **2 minutes** for rise, set, solar noon and civil twilight: London BST, GMT, solstice, the 29 March and 25 October DST days; Dubai (UTC+4) September and December; Honolulu (UTC−10, no DST) September and June; Sydney AEST and AEDT; Kathmandu (UTC+5:45); Auckland; New York including 8 March; Denver; Reykjavik summer and winter; Ushuaia; Singapore; Tromsø polar night (both null), midnight sun (both null), sun returns 20 and 21 January. Every test computes local minutes and compares them to the table. As built: 27 tests (one per row); tolerance 2 minutes where the Observatory lists an event; polar rows assert the kind and "no event"; the two polar-circle transition days check solar noon only. Simulator only.

**Location.** Order in decision D7. A place is `[lat, lon]` rounded to 0.1° (about 11 km) before it is stored; the accuracy that sun times need is minutes per 0.25°. Stored under one key (`place`); replaced only when a fresher source gives a place more than 0.1° away in either coordinate (both are already rounded, so in effect steps of 0.2°); a fix of exactly (0, 0) is rejected as a no-fix placeholder; values read back from storage are accepted as any numeric type and re-validated; **never sent anywhere** (ADR-006). `Position.getInfo` is isolated in `TwoSunsSources.positionLocation` (ADR-005).

**Body Battery.** `SensorHistory.getBodyBatteryHistory({:period => new Time.Duration(86400)})`, newest first. Keep a sample only if `data` is a Number/Float, not null, 0 ≤ data ≤ 100. Bucket by each sample's own `when` (never `getOldestSampleTime`/`getNewestSampleTime`: forum bug reports say they do not match the samples). A sample stamped up to 5 minutes ahead is clock skew and is kept in the last bucket; later is dropped. The newest sample in a bucket wins; gaps stay gaps. Refresh at most every 5 minutes; hold 96 buckets in memory only. Current value = newest kept sample; **stale** when it is older than 60 minutes. If the watch has no history API or reading it throws, fall back to the Complication value when valid, else `--`. If the history exists but has no valid sample, `--` (no substitution). See ADR-015.

**Battery and CPU.** One redraw a minute (no `onPartialUpdate`). Nothing is recomputed that did not change: sun geometry once per local date and on a change of place or offset; Body Battery history every 5 minutes. No battery figure is claimed until measured on a watch.

## Settings

All lists (Properties only for settings; `Application.Storage` only for the remembered place, and nothing else):

| Setting | Values | Default |
|---|---|---|
| Accent colour | six colours (64-colour safe): sky, mint, autumn, violet, pink, winter | sky (2026-09-27: changed from amber — amber read as a "low" warning at a normal value, on a real-device photo; autumn and winter are the old amber and white, renamed not recoloured) |
| Ring orientation | Noon at the top / Midnight at the top | Noon at the top |
| Golden hour | On / Off | Off |
| Energy curve | On / Off | On |
| Date | On / Off | On |
| Weather | On / Off | On (Pro only) |
| Watch battery | On / Off | On (Pro only) |

**Free has the Accent row only** (the same six colours, default sky); the other six are Pro only (see "Free and Pro"). Property keys: `Accent`, `Orientation`, `Golden`, `Curve`, `Date`, `Weather`, `Battery`; they never change once shipped (the Free properties file defines `Accent` alone). The curve setting is labelled "Energy curve", not "Body Battery" (trademark, D9). Values are validated; anything unexpected falls back to the default. Settings are re-read on every update.

Time format follows the system's 12/24 h. No numeric fields. Settings reach the watch from Garmin Connect, or on-watch via `getSettingsView` (Customize, next to Apply in the watch-face picker; ADR-019) — both write the same Properties, last write wins. **The face works with all defaults if neither round trip ever runs** (the Days To Go lesson).

## Design brief (as built; the owner has not approved the look)

The visual system as built is in [`../DESIGN.md`](../DESIGN.md). **The look, the rectangles and the launcher icon are not approved**; no screenshot of the face exists (this environment cannot capture the simulator). Decided by the build, not by the owner: the colours, the row drop order. The glyph shape (2026-09-27) was the owner's call, on the real-device photo.

Constraints (from the SDK and Days To Go): primitives and system fonts only, no bitmaps; proportional layout with measured text fit; 64-colour safe values (each channel 00, 55, AA or FF); black ground; a state is never colour alone. **In bright sun the dim tracks must still read**: the night track is at least 3:1 against black (`#5555AA`, 3.3:1, computed from the hex value, not measured on a screen).

Direction, **"two suns"**: black ground; one accent; a 24-hour ring around the bezel. Ring encoding: night = dim track; civil twilight = a light lavender; daylight still to come = accent; daylight already gone = the accent with each FF channel dropped to AA; sunrise and sunset = short white radial ticks; sun = a white dot with a black halo on the ring at the current time, solid when the sun is up and an outline when it is not; golden hour (setting) = a `#FF5500` arc. The time is the hero, the largest of `FONT_NUMBER_HOT`, `MEDIUM`, `MILD` that fits under 260 permille of the shorter side (raised from 230, owner feedback on a real FR965, 2026-09-27). Under the time, one band: a level pill (a plain rounded bar, no battery nub — see "Built vs specified"), the Body Battery value in the accent (dimmed to `dim(accent)` below level 30, muted grey when stale), and the 24-hour curve (a fill, a white line, the current point a dot: solid in the level colour, an outline when stale). The bottom line is the sun sentence. The date is small and muted, above the time. No layer overlaps another (a Sun Watch Toutou complaint: steps bar over sun times).

Rows are stacked from measured font heights (Days To Go ADR-012), not from fractions. **Drop order** when the screen is small: date, then curve, then the sun line; the time and the Body Battery value never drop; a curve with no room on its chord is dropped too (ADR-016). The ring and the time are kept on the smallest supported screen (218 px MIP).

**Free (ADR-025):** awake, the Body Battery number is a size larger than in Pro (the stack has room); the always-on frame keeps the small size.

**Always-on (AMOLED):** time, the Body Battery number and the sun sentence in `#5555AA` (ADR-007, amended 2026-09-27), the whole block stepping across a 3 by 3 grid every minute (ADR-007). No ring, no curve, no glyph, no date. MIP watches show the full face at all times.

## Devices and memory

**v1: 69 products, API ≥ 4.2, `minApiLevel` 4.2.0, one build, no bitmaps.** From the SDK's `Devices/*/compiler.json` (`deviceGroup`), 2026-09-26. **Everything here is simulator-only until a watch runs it.** Watch-face memory is at least 128 KB on all 69. Memory used in a normal (non-test) run has not been recorded. The weather row (ADR-022) grew Pro's `.prg` from 172,412 to 190,716 bytes on `fr965` and `fr255s` (+18.3 KB, 2026-10-03); the simulator does not emulate a watch's memory limit (it reports 8 MB), so runtime memory on the lowest-memory product is **not measured**.

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

- The three rectangular ones (Venu Sq 2, Sq 2 Music, Venu X1) keep the round design centred, as Days To Go; the look on a rectangle is not approved and only Venu Sq 2 (`venusq2`) has been through the fit test (not Venu X1).
- **Excluded:** Instinct 3 Solar 45 mm, Instinct E 40 and 45 mm (semi-octagon, 64 KB, monochrome) and every product below API 4.2. The fēnix 5 Plus family has no Body Battery in the SDK lists and is out permanently.
- **Tier B (1.1, gated on the probe): 23 products, API 3.4 to 4.1** (fēnix 6 family, FR55, FR945 LTE, MARQ Gen 1, Enduro, Descent Mk2, Instinct 2 family). No Complications: sunrise and sunset must come from the calculation and a location, which is the failure path the reviews describe, so it ships only when the location probe shows a source that works.
- The fēnix 9 family, FR70 and FR170 (API 6.0) are in v1 by API level; the SDK's device lists omit them (doc lag), like the settings-view case in Days To Go. Their first run is the risk: **verify on a real watch or say so on the listing.**
- **Export oddity:** the `.iq` export claims more devices than the manifest lists (89 against 69). Explained 2026-10-01 from the SDK's own device files (the 69 product ids have exactly 89 part numbers, all in the package); the store form's own list stays authoritative; details in [`compatibility.md`](compatibility.md#the-export-and-89-devices).
- **Fit test coverage:** 10 of the 11 screen sizes (all but 448 by 486, Venu X1), one product each (plus `venu3` at 454 px), English strings only; the other 58 products have not been run through `tools/fit_products.sh` ([`compatibility.md`](compatibility.md)).
- Pro (paid) only: sold on the SDK's App_Sales product list (lowest tier CIQ 3.4) and its country list, so the store list will be shorter than the manifest. No watch count goes in the listing. The Free twin lists the same 69 products and is not held to that list (the Free listing's real device list is only known after approval).

## Permissions, privacy, store form

**Free's manifest permission is `ComplicationSubscriber` alone** (see "Free and Pro" for its privacy facts). Pro's, unchanged: **`SensorHistory`**, **`ComplicationSubscriber`** and **`Positioning`** (D7, confirmed on-device 2026-09-27, ADR-005). The one call that needs it, `Position.getInfo`, stays isolated in `TwoSunsSources.positionLocation` for a cheap reversal if that ever changes. `Application.Storage` needs no permission. No `Background`, `Communications`, `UserProfile` or network. Connect IQ's review guidelines: "seek permission from users prior to collecting location data or data that may be considered sensitive" and no medical claims (SDK `App_Review_Guidelines`). Body Battery is health-adjacent: the privacy page says what is read (Body Battery history, Garmin's own sunrise and sunset, a location rounded to 0.1° that stays on the watch), never sent, never stored beyond the remembered place.

Store name, description and site copy **describe** ("shows your watch's Body Battery, the sun's arc and how much light is left"), never claim ("improves recovery"), never use "Body Battery" as a brand.

Site pages (created with the listing, `site/src/apps/two-suns/`): landing, support (what "No place yet" means; Garmin Connect settings; how to make Garmin's sunrise appear), privacy. Published URLs never change.

## Claims that may be made (the checkable version is [`release-contract.md`](release-contract.md))

Allowed only after the matching test or device check: "sunrise and sunset match your watch's own Sunrise/Sunset glance" (after the device compare), "works without GPS or your phone" (after a run with both off), "your location never leaves the watch", "shows your last 24 hours of Body Battery". Forbidden until measured on a device: battery figures, always-on ghosting, MIP contrast, any watch count, any download or rating figure, accuracy of Body Battery. None of the allowed claims has its check yet: no device compare, no run with phone and GPS off, no location check has been done. Forbidden always: anything about health outcomes, "improves", "optimises", "recovery advice"; the words "accurate Body Battery"; any statement about rivals by name.

## Non-goals (v1)

Moon phase, heart rate, steps, seconds, notifications, multiple locations or "time zones", a city-search or coordinates setting, sunrise alarms, mood or emoji for Body Battery, predictions of Body Battery, sleep score or training readiness, complications publishing, `date`/`numeric` settings, Instinct and tier B/C/D watches, any network.

(Weather was listed here until 2026-10-03: the owner overrode it for a Pro-only weather row, ADR-022 (Weather row in Pro, Proposed, not built); nothing else from this list changes.)

(An on-watch settings screen was listed here when this was written; ADR-019 built one — `getSettingsView()`, "Customize" — after sideloaded apps turned out to need it for any on-watch settings access at all. Removed from this list rather than left contradicting a built ADR.)

## Ideas for a later version (not scoped, not designed)

Owner notes, 2026-09-27, from the real-device look. Neither is v1 or blocking; both need their own design pass before either is built.

- **Always-on: the Body Battery number has no context.** Awake it sits next to the level pill and under the ring, so it reads as Body Battery by position; asleep (D10, ADR-007) it is a bare number with none of that — nothing marks what it is. Flagged again by `watch-design-reviewer` (`watch-design-kit`, 2026-09-27): still open, still not designed. A small mark or word that survives the AMOLED lit-pixel budget (a commonly-cited ≤10%, uncited) would need its own design and a real-device check, not just re-adding the awake pill blind.
- **Stress level.** Garmin exposes a stress score (`ActivityMonitor`/`SensorHistory`, not yet researched for this app). Adding it means a new data source, its own validity/staleness rules (like Body Battery's), a place in the layout that does not crowd the ring, curve or sun line, and a decision on whether it changes the "no mood, no advice" rule (D9) — stress readings invite a good/bad reading more than Body Battery does, so ADR-008 would need revisiting, not just extending.

## Risks and unknowns

| Risk / unknown | Evidence | Handling |
|---|---|---|
| A real watch returns no location to a face | Simulator: Weather's location only with Positioning; `Activity.currentLocation` null; forum: "start any activity, wait for GPS, discard it" | **Probes first** (plan phase 1). v1's sun ring works from Complications without a location; only tomorrow's sunrise, dawn, dusk and golden hour need one, and each hides itself cleanly |
| Positioning adds nothing on a real watch | Simulator: Weather's location needs it, `Position.getInfo` returns null | Drop the permission if probe N (without it) still gets a location from Activity or Weather; the listing then says so |
| The Complication sun values differ from the native glance or are null on some watches | Simulator values are canned | Probe prints them; if null on a watch, that watch shows "No sun data" (not blank); a device compare is a release gate |
| `Weather.getSunrise` follows the watch's local day: simulator only | Hourly sweep over both midnights | Not the primary source (D5); the change-log probe records it across a real local midnight |
| Body Battery history cadence and sample count unknown | Simulator gives 480 samples in 24 h | 96-bucket downsample; probe prints n and the smallest gap; cost measured on device |
| Body Battery accuracy | No independent validation of the composite score found | Show Garmin's number as Garmin reports it; no claims |
| A copy from Vesper Solar and the many sun faces | Vesper Solar, 3 days old | Moat: correct numbers, no blanks, Body Battery curve, finish |
| Translations never fit-tested; no native reader | `tools/fit_languages.sh` written, not run; `tools/check_strings.py` checks parity and length only | Run it on the smallest and a rectangular screen before shipping any language; say "machine-drafted" |
| The stale curve fill is `#555555` (2.8:1 against black); the always-on text was too, raised to `#5555AA` (3.3:1) 2026-09-27 | Computed from the hex value | Stale is carried by shape (hollow glyph, outline dot) and is awake-only; check on a MIP watch in daylight |
| Nobody pays for a single-idea face | about 75 paid Body Battery/sun faces, 2 at 1,000+ | Flagged; same price review and success test as Days To Go |
| DST day ring jump | Wall-clock ring | Documented; a test covers 29 March and 25 October London |
| Polar-circle transition days | USNO vs one-noon declination | ±1 day accepted, tested and documented |
| 64 KB watches and older firmware | Tier B and Instinct excluded | `has` guards everywhere; v1 minimum memory is 128 KB |

## Success and stop test (proposal, owner to confirm)

Judge at 60 days after approval, on the developer dashboard (sales report) and the store. The claim under test: *people will pay for a face that gets the sun right and shows their energy as a curve.* Paid: any sales at all, and at least one review that is not about setup. If there are no sales and downloads stay in the lowest bucket, stop: choose between a switch to free (harder to undo) and leaving it. Do not build a second face in this style on a lowest-bucket result. Extra signal to record: **reviews that mention wrong or blank sun times** (the category's signature complaint); zero of them after 60 days is a real result.

## Built vs specified

What the build did differently from the spec as first written (2026-09-26). Each is in the ADRs.

| Spec (or plan) said | The build does | ADR |
|---|---|---|
| Local offset = clock difference, wrapped to +-12 h | Exact: day numbers compared too, no wrapping (+14:00 works) | 012 |
| Both Complication values null: polar or unknown | If a place is known the calculation fills in; polar day and night come from it; unknown place gives "No place yet" (Complications exist) or "No sun data" (they do not) | 013 |
| One null: "show what exists" | The missing time comes from the calculation when there is a place | 013 |
| Edge case: sunset after midnight is handled | Handled (+1440); the known edge is that 00:00 to that sunset reads "before sunrise" | 013 |
| One bottom sentence per state | Up to three wordings (full, shorter, shortest), chosen by measured fit; added after the fit test failed on `fr265s` and `venusq2` | 014 |
| Sun line "Sunrise 06:41" after sunset | Also "Sunrise ~06:41" (estimate), "No sunrise tomorrow", "Sunset 20:52", "Sun is up" | 013 |
| Golden hour is a state with the sun below 6 degrees | Golden hour only adds a ring arc, and only with a place; the sentence never changes. `TwoSunsSky.golden` is computed and tested but nothing draws from it | 017 |
| Settings table: "Body Battery curve" | The setting is labelled "Energy curve" (trademark) | 018 |
| Body Battery: Complication as the fallback for the number | Also when reading the history throws; not when the history exists but has no valid sample ("--") | 015 |
| Sample stamped in the future: not specified | Up to 5 minutes ahead is clock skew and is kept; later is dropped | 015 |
| Design brief: glyph, colours and drop order open | Decided by the build: a level pill (2026-09-27: changed from a battery-shaped glyph — owner feedback on a real-device photo, it read as watch battery), the palette in DESIGN.md, drop order date then curve then sun line | 016, 017 |
| Always-on: "time and the two numbers" (D10) | Time, Body Battery value and sun sentence; no ring, curve, glyph or date | 007 |
| `Position.getInfo` in the location order | Isolated in one function so that dropping Positioning is a deletion | 005 |
| Weather sun API as a cross-check | Not called at all | 003 |
| Plan phase 5: fit test on the ten sizes plus the two rectangles | `tools/fit_all.sh` runs ten devices (`venusq2` is the only rectangle); Venu X1 and the other 58 products are not run | 009 |
| Plan phase 6: languages fit-tested | Strings written and parity-checked; `tools/fit_languages.sh` written but not run | 014 |
