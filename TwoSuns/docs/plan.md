# Two Suns: implementation plan

Written 2026-09-26 for an implementer agent that has none of this conversation's context. Follow it literally. Where it says **[OWNER]**, stop, tell the owner exactly what you need, and wait: those steps need a person, a watch or a decision only the owner can make. Where it says **[GATE]**, the next phase depends on the result.

The product is defined in [`spec.md`](spec.md); the evidence is in [`reports/Body Battery and sun face research.md`](../../reports/Body%20Battery%20and%20sun%20face%20research.md) and `research_notes/Body Battery and sun face research/`. Read the spec, the report and `platform.md` first.

## Implementation status (2026-09-26)

Everything marked "simulator" has **not been seen on a watch**. No screenshot of the face exists.

| Phase | State |
|---|---|
| 0 Owner decisions | **Done in part.** Name (Two Suns, ADR-010), category (Utility) and price (USD 1.99, ADR-002) confirmed 2026-09-27. **The look is still not decided**: no screenshot exists, no approval given. The owner said on 2026-09-26 to proceed with implementation without further permission questions; the defaults in [`decisions.md`](decisions.md) were taken and are reversible |
| 1 On-watch probes | **Done in part.** Owner ran M1 and M2 on the FR965, 2026-09-27 (results: `device-test/LocationProbe-RESULTS.md`). Positioning is confirmed (Q1 no, Q2 no, Q3 yes → keep it), so the location code and the location path have now run on a watch. **Not run, and not blocking**: M3 (outdoors), M4 (overnight log), Q4/Q5/Q7/Q8's full `diff` — none of these can change the Positioning call; left for before submission. Tier B still gated on the full probe set |
| 2 Skeleton and verified logic | Done (simulator): sun maths with 27 USNO reference tests, calendar, local time, Body Battery buckets, place, sky states |
| 3 Plain working face | Done (simulator): readings, state, settings (five lists, `tools/gen_settings.py`), sources for the clock, Complications, history and location |
| 4 The real face | Built (simulator): layout, sky ring, energy curve band, battery glyph, always-on. **The owner has not approved the look**; no screenshot exists; the rectangles were not looked at by eye |
| 5 Screen-fit tests | **Done for all 69 products** (`tools/fit_products.sh`, 2026-09-27: `bin/fit-products.txt`, `done: 69 pass, 0 fail`, 122 of 122 on each, English only, including Venu X1). Started for the ten screen-size subset first (`tools/fit_all.sh`), then the full sweep completed |
| 6 Languages | Fourteen machine-drafted translations written; `tools/check_strings.py` passes. **Never fit-tested in any language** (`tools/fit_languages.sh` not run); no native reader |
| 7 Documentation | Done in this step (`CLAUDE.md`, `README.md`, `PRODUCT.md`, `DESIGN.md`, `CHANGELOG.md`, `docs/*`). `listing/` is written by a parallel step |
| 8 Listing and site | In progress elsewhere: site pages drafted (`site/src/apps/two-suns/`, staged, not deployed); `listing/` not in the tree when this was written. Screenshots are the owner's |
| 9 Device evidence and submission | Not started. The owner's checklist `device-test/TwoSuns-CHECKLIST.md` is not written |
| 10 After approval | Not started |

Last recorded runs: 120 tests, 2026-09-26, on `fr965`, `fenix7`, `venu3` and the ten fit sizes above, all passing in the simulator (logs `bin/t-<device>.log`, 21:49 to 22:01). A full 69-product compile sweep, run after the 15-language manifest was added, printed `BUILD SUCCESSFUL` for all 69 at `-w --typecheck 3` with zero errors and no warning beyond the launcher-icon-scaling notice (the icon is 65 px and the placeholder is generic); the build outputs were not kept as artifacts (`bin/` is git-ignored scratch, deleted after each run per house rules), so this rests on the run having happened, not a saved log. The translations, the manifest's language list, and the low-battery colour change were all in place for a full re-run on 2026-09-27: `fr965`, `fenix7`, `venu3` and all ten fit-sweep devices, 122 of 122 on every one. The full 69-product compile has not been repeated since (the earlier sweep above still covers build errors for all 69; only the language edit followed it, and English-language builds compile the same regardless of which languages ship). Tests do not check pixels.

The text of phases 0 to 10 below is the original plan; the table above is the state. The owner-only steps (phases 0, 1, 9 and the gates in 4 and 8) are unchanged.

## What the build learned

- **Sentences were too wide for a round screen.** The strengthened fit test failed on `fr265s` (360 px) and `venusq2` (320 by 360) with one wording per sentence; the fix is three wordings and a measured choice (ADR-014).
- **The local offset must not be wrapped.** Comparing day numbers as well as clock times gives +14:00 and -10:00 correctly (ADR-012).
- **The calculation is more than a Tier B fallback.** It fills polar days, the transition-day gap and tomorrow's sunrise, so the sky states in the spec grew (ADR-013).
- **A wrong number is worse than "--".** With a history that holds no valid sample, Garmin's single number is not substituted (ADR-015).
- **The simulator keeps the last saved settings**, so a Monkey C test cannot see a changed default in `properties.xml`; `tools/gen_settings.py --check` verifies the files instead.
- **The environment cannot capture the simulator**, and `Dc.getPixel` does not exist in SDK 9.2, so layout is read from the fit test's box log ("cut:" lines and boxes), not from images.
- **Compiler quirks** cost time: see [`development.md`](development.md) "Compiler and SDK quirks".
- **The simulator wedges, and the test runners kill it.** `tools/run_tests.sh` runs `pkill -f monkeydo` after every run and restarts the simulator with `pkill` on a wedge (`tools/fit_languages.sh` on a no-result retry); another session sharing the simulator makes wedges worse and loses its work to them ([`development.md`](development.md) "Shared simulator").
- **The `.iq` export prints "89 OUT OF 89 DEVICES BUILT"** for a manifest of 69 products. Unresolved; check the package before submission ([`publish-checklist.md`](publish-checklist.md)).
- **Contrast item, partly resolved 2026-09-27.** Phase 4 asked for the night track and "the curve's lower level" at 3:1 against black. The night track is 3.3:1 and every dimmed accent at least 4.6:1 (unit-tested). The always-on text was `#555555`, 2.8:1 — under the project's own bar for a persistent colour — fixed to `#5555AA`, 3.3:1 (ADR-007 amendment). Still open: the stale curve fill (`#555555`, 2.8:1, awake-only) — decide on the look approval whether that's acceptable given it's also carried by shape.

## 0. Ground rules (they override anything below if in conflict)

1. **Do not stage, commit, stash or reset.** The git index is mixed staged/unstaged and belongs to the owner. Leave everything in the working tree and end each phase by listing the files you created or changed.
2. **The signing key** is `~/.garmin-connectiq/keys/developer_key`, outside the repo. Never copy it in; never commit any `.der` or `.pem`. The project `.gitignore` copies Days To Go's.
3. **Simulator passing is not device proof.** Every report says, per watch product, what ran in the simulator and what (only the owner's FR965) ran on a wrist. The simulator has **no GPS position, canned weather, canned sun values and synthetic Body Battery**: it can prove layout and logic, never data.
4. **Behaviour change → update the doc that describes it, same session. A durable decision → an ADR** in `docs/decisions.md` (list in phase 7). User-facing claims live in two places: the listing and `site`; change both together and never change or remove a published URL.
5. **Code rules** (from `DaysToGo/CLAUDE.md`, which this project mirrors): every function has typed parameters and an `as` return type; no `as Any`; cast only after `instanceof` or a null guard; no magic numbers (tunables and keys in `TwoSunsConfig`, geometry in `TwoSunsLayout`, colours in `TwoSunsPalette`, words in `strings.xml`); text fit is measured, never guessed; render only in `onUpdate`, gather data in `TwoSunsReadings`, draw from a `TwoSunsState`; one class per file with the `TwoSuns` prefix; functions of about 30 lines or fewer, files about 250 or fewer; comments explain why; property key spellings never change once shipped.
6. **Forbidden in this app** (each was found to hurt a rival or a wearer; the research notes say why): `Weather.getSunrise` and `getSunset` as the primary source (cross-check and tier B fallback only, D5); `Position.getInfo()` in a build whose manifest lacks Positioning; `type="date"` and `numeric` settings; any mood, emoji or advice tied to Body Battery; the network; `Background`, `Communications`, `UserProfile`; a permissioned call outside a manifest that declares it (calling `Position.getInfo` without the permission **kills the app and cannot be caught**); seconds; storing anything but the rounded place.
7. **Build with warnings and strict typing on** and keep them at zero: `-w --typecheck 3`.
8. **Trust the printed `PASSED (…)` line, not an exit code.** The simulator wedges every few runs; `tools/run_tests.sh` restarts it once. A run that prints nothing means wedged, not failed.
9. **Do not invent evidence**: no reviews, downloads, screenshots, battery figures or accuracy claims in any doc or listing.
10. **Edits outside `TwoSuns/` are limited to**: the root `CLAUDE.md` project table (one row), the root `README.md` layout note, and `site/` (phase 8 only). Ask before touching `HeroSet/`, `HeroFace/` or `DaysToGo/`. Copy from `DaysToGo/source/` at the current commit; do not import.

**Never decide alone**: the store name, the price, the visual identity, the launcher icon, the Positioning permission, any upload to the Connect IQ store, any phone or watch test, a site deploy, and shipping machine translations no native speaker has read.

## 1. Where things are

```
TwoSuns/
  docs/spec.md  docs/plan.md  ...               docs (see phase 7)
  source/*.mc  source/test/*.mc                 the app
  tools/*.py  tools/run_tests.sh  ...           generators and test runners (copy from DaysToGo/tools)
```

Patterns to copy (adapt names, do not depend on them): `DaysToGoCalendar.mc` (integer calendar-day arithmetic), `DaysToGoLayout.mc` (font-height stacking, chord insets, ring), `DaysToGoDraw.mc` (measured text, truncation with a marker), `DaysToGoSleep.mc` (always-on grid step), `DaysToGoText.mc`, `DaysToGoPalette.mc`, `source/test/DaysToGoScreenFitTest.mc` (`everyStateFitsThisDisplay`), `tools/gen_settings.py` (list settings), `tools/run_tests.sh`, `tools/fit_all.sh`, `tools/check_strings.py` (translation parity), `docs/development.md`, `docs/publish-checklist.md`. HeroFace's `HeroFaceLink.mc` shows a working complication subscription (`registerComplicationChangeCallback`, `subscribeToUpdates`, `getComplication(id).value`) that ran on a real FR965.

Reference data and the calculation prototype: `research_notes/Body Battery and sun face research/reference_sun_times.tsv` and `probe/sun_reference_check.py`.

## 2. Phases

### Phase 0. Owner decisions [OWNER]

Ask the owner, in one message: (1) name: **Two Suns** or **Sun Battery** or their own (D2); (2) confirm 69 products for v1, tier B in 1.1 (D4); (3) category (D13); (4) the look: the spec's direction, "two suns" ring plus curve, or another; (5) the Positioning permission: the owner said yes on 2026-09-26; **it stays provisional until the phase 1 probes report** (D7). Record the answers in `docs/decisions.md`. Wait.

### Phase 1. On-watch probes [OWNER] [GATE] (≈ 1 day of wear, no midnight alarms)

The most valuable step and the cheapest. It answers what the simulator cannot. **No code beyond the existing probes is written for location until this reports.** Simulator finding to test on a watch: Weather's location appeared only with Positioning declared.

1. Two probe faces, same code, different manifests (sources: `research_notes/.../probe/on-watch/`): **Probe-P** (declares Positioning, calls `Position.getInfo`) and **Probe-N** (no Positioning, never calls it). Copy both `.prg` files from `device-test/` to the watch's `GARMIN/APPS/`.
2. Each shows, on **even minutes**, live lines: local time, `timeZoneOffset`, `dst` and the difference derived from the clock; `Position.getInfo` (P only); `Activity.currentLocation`; the weather observation location; Weather's sunrise and sunset (local and UTC); the Complication sunrise, sunset and Body Battery; Body Battery history count, smallest gap (absolute), order and how many samples are future-dated. On **odd minutes** it shows the **log**: one entry each time any sun time, location source or time zone changes, stamped with the local time. The log is stored on the watch, so the owner reads it in the morning; nobody needs to be awake at 00:00 or 03:00.
3. Owner follows `device-test/LocationProbe-CHECKLIST.md` (photos at a few moments, eight answers).
4. **Decision table** (the implementer fills it from the photos; the owner approves):

| Question | If yes | If no |
|---|---|---|
| Q1. `Act.curLoc` non-null after a GPS activity, in **N** (no Positioning)? | Activity is source 1 and needs no permission | rely on the sources below |
| Q2. Weather `obsLoc` non-null in **N**? | Weather needs no permission on a watch (unlike the simulator) | Weather's location needs Positioning |
| Q3. `Pos.getInfo` non-null in **P** when Q1 and Q2 are null in **N**? | **keep Positioning**; the listing discloses location | if Q1 or Q2 is yes in N: **drop Positioning** and say "no location permission" |
| Q4. Complication SUNRISE/SUNSET equal the native glance (±1 min)? | primary source stands (D5) | make the calculation primary, compare again; if there is no location, tier A is at risk: stop and tell the owner |
| Q5. Log: does the API's sunrise/sunset pair change at **local** midnight (simulator: yes)? Do the Complication values change at local midnight? | record; D5 unaffected | record; note any surprise (a change at UTC midnight would reopen the API as a source) |
| Q6. Body Battery: how many samples in 24 h, smallest gap, order, any future-dated? | size the buckets (15 min default) and the order handling | if < 20 samples, use 1 h buckets and say so |
| Q7. Any value outside 0 to 100, or nulls, in the history? | keep the validation as specified | keep it anyway |
| Q8. `timeZoneOffset` + `dst` equal the derived difference? | either may be used | use the derived difference only (spec) |

5. Report in the same message: what was seen, what was not, and that it is one watch. Wait for the owner.

### Phase 2. Skeleton and verified logic (≈ 1 day)

1. Folder skeleton copied from `DaysToGo` (manifest for the 69 products, `monkey.jungle` with `base.sourcePath = source`, `resources/` with `AppName` and the launcher icon, `.gitignore`, `tools/`). `minApiLevel="4.2.0"`. Permissions per the phase 1 decision (at minimum `SensorHistory` and `ComplicationSubscriber`).
2. Pure logic, each with unit tests in `source/test/`:
   - `TwoSunsSun`: NOAA rise, set, civil twilight and golden hour in local minutes from (year, month, day, lat, lon, local offset in minutes). **The reference tests** in spec "Data rules": generate `TwoSunsSunReferenceTest.mc` from `reference_sun_times.tsv` with `tools/gen_sun_tests.py` (tolerance 2 minutes; polar rows assert "no event"; transition rows assert nothing stricter than ±1 day).
   - `TwoSunsCalendar` (copied): local date, next day.
   - `TwoSunsBattery`: keep valid samples, bucket by each sample's `when` into 96 buckets, current value, staleness. Tests: 127, negative, 101, null, empty, one sample, gap of hours, samples out of order, newest older than 60 minutes.
   - `TwoSunsPlace`: rounding to 0.1°, the source order, "replace only when > 0.1° away", empty.
   - `TwoSunsSky`: from sun times and now → the state table's row (day, before sunrise, after sunset, midnight sun, polar night, no place, no data) and the bottom-line values ("3:42", tomorrow's sunrise with the Garmin-offset correction).
3. `tools/run_tests.sh fr965` prints `PASSED`. Run also on `fenix7` and `venu3`. Record the counts.

### Phase 3. Settings and a plain, working face (≈ 1 to 1.5 days)

1. `TwoSunsReadings` gathers: Complication values (subscription pattern from `HeroFaceLink`), the location (per D7), Body Battery history (every 5 minutes), the clock. `TwoSunsState` carries the result. `onUpdate` renders only from a state.
2. Settings via `tools/gen_settings.py` (lists; five settings in spec); read with fallback to defaults.
3. A plain face: time, the two numbers and the bottom sentence as text; every state reachable in the test states. No ring, no curve yet.
4. Build with `-w --typecheck 3` and zero warnings on `fr965`, `fenix7`, `venu3`.

### Phase 4. The real face [OWNER gate on the look] (≈ 2 to 3 days)

1. `TwoSunsLayout` (font-height stacking as ADR-012), `TwoSunsRing` (24-hour ring: night, twilight, daylight, gone, ticks, sun marker, golden arc, orientation setting), `TwoSunsCurve` (96 buckets, filled area, current dot), `TwoSunsDraw` (measured text, truncation marker), `TwoSunsSleep` (always-on).
2. Check by eye in the simulator on `fr965` (454 AMOLED), `fenix7` (260 MIP), `fr255s` (218 MIP), `venu2s` (360). **Ask the owner to approve the look before phase 5.** No screenshots are produced in this environment (the simulator cannot be captured headless); the owner supplies them.
3. Bright-sun check: the night track and the curve's lower level must be ≥ 3:1 against black; the ring must still read at 218 px.

### Phase 5. Screen-fit tests for every state (≈ 0.5 to 1 day)

Copy `DaysToGoScreenFitTest.mc` and extend the states (`TwoSunsTestStates`): the widest time strings, the longest bottom sentences in every language, all Body Battery states, all sun states. `tools/fit_all.sh` on the ten sizes in the spec plus the two rectangular ones. The always-on frame at each of the nine drift positions. Zero problems on every size.

### Phase 6. Languages (≈ 0.5 to 1 day)

English plus Days To Go's 14. Use `tools/check_strings.py` for parity and `tools/fit_languages.sh` for fit. Machine-drafted, unread by native speakers: say so. The sentence strings are few ("of daylight", "Sunrise", "Sun stays up today", "No place yet", "No sun data", "--").

### Phase 7. Documentation (≈ 1 day)

`CLAUDE.md`, `README.md`, `PRODUCT.md`, `DESIGN.md`, `CHANGELOG.md` (1.0.0 entry when submitted), `docs/decisions.md`, `docs/compatibility.md`, `docs/development.md`, `docs/release-contract.md`, `docs/publish-checklist.md`, `listing/` (`README.md` paste-ready, `NOTES.md`, `screenshots.md`). ADRs to write: ADR-001 concept (two suns); ADR-002 price; ADR-003 sun times from Complications, `Weather.getSunrise` only as cross-check and tier B fallback (with the hourly-sweep evidence and the retracted UTC-date reading); ADR-004 own NOAA calculation and tomorrow's correction; ADR-005 location order and the Positioning decision; ADR-006 rounded place in Storage; ADR-007 always-on; ADR-008 no verdicts on Body Battery; ADR-009 device set (tier A) and tier B plan; ADR-010 name and slug; ADR-011 24-hour ring is wall-clock. Add the row to the root `CLAUDE.md` and `README.md`.

### Phase 8. Store listing and site (≈ 1 day)

`listing/README.md` in form order as Days To Go's. No claims the release contract forbids. Screenshots supplied by the owner. Site pages under `site/src/apps/two-suns/` (landing, support, privacy) with the site's rules (zero client JS, CSP, DESIGN.md). Support text covers: what "No place yet" means and the two ways to fix it (a GPS activity once; Garmin's Sunrise/Sunset widget); Garmin Connect settings; that Body Battery is Garmin's estimate. **Do not deploy the site**; the owner does.

### Phase 9. Device evidence and submission [OWNER] (≈ 1 day of wear + 72 h review)

1. Owner sideloads the dev build on the FR965. Checklist (write `device-test/TwoSuns-CHECKLIST.md`): time and ring correct at first sight; sunrise and sunset **equal the native glance**; the ring on the right local day across local midnight and across UTC midnight; a run with the phone off and GPS off; Body Battery curve shape against Garmin's own graph; always-on night (blanks?); battery over 24 hours compared with the same watch on Days To Go; DST if a change day falls in the window.
2. Submit only what was seen. If the always-on blanks, raise the drift step or shrink the number (ADR-007 rule).
3. Store form fields per the listing README; the price answer per D3; Monetization "No" as Days To Go's.

### Phase 10. After approval

Set "Price review due" (approval + 45 days) in `TwoSuns/CLAUDE.md` and the memory index; set `storeUrl` in `site/src/apps/two-suns/app.ts`; update the root README status; record HeroSet, HeroFace and Days To Go download buckets as the baseline for the price review. Tier B (1.1) if the probe allowed it.

## 3. Definition of done for the whole project

- `tools/run_tests.sh` prints `PASSED` on `fr965`, `fenix7` and `venu3`; all reference sun tests pass at 2 minutes; `tools/fit_all.sh` reports zero problems on every size.
- Zero warnings at `-w --typecheck 3`.
- The manifest declares exactly the permissions the decisions allow, and no call outside them.
- `docs/decisions.md` has the ADRs; `CHANGELOG.md`, `listing/README.md` and the site pages agree with each other and with the release contract.
- The owner has seen the face on a watch, and the phase 9 checklist is in the report.

## 4. Stop and ask the owner when

- The probes show **no location source works** (Q1, Q2 and Q3 all "no" in both P and N) *and* the Complication sun values are null: tier A has no sun data; the concept needs a decision.
- Complication values disagree with the native glance by more than 1 minute.
- The always-on frame blanks, or the memory used exceeds 70% on the smallest v1 watch.
- A translation or any store-facing text needs a fact you do not have.
- You are about to use a permission, a network call or a claim the spec forbids.

## 5. Command cheat sheet

```bash
cd TwoSuns
tools/run_tests.sh fr965                       # unit tests on one product; trust the PASSED line
tools/run_tests.sh fr965 everyStateFitsThisDisplay
tools/fit_all.sh                               # screen fit on ten devices (one per size but Venu X1)
monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3
python3 tools/gen_sun_tests.py                 # regenerate the reference tests from the table
python3 tools/gen_settings.py --check          # settings files match the tables
python3 tools/check_strings.py                 # translation parity and length
tools/fit_products.sh [id ...]                 # every manifest product (slow; kills a shared simulator on a wedge)
tools/fit_languages.sh [-l "deu fin"] <product>  # one run per language
```
