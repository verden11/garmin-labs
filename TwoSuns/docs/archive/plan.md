# Two Suns: implementation plan

Written 2026-09-26 for implementer agent w/o this conversation's context. Follow literally. **[OWNER]** = stop, tell owner exactly what needed, wait: needs person, watch or decision only owner can make. **[GATE]** = next phase depends on result.

Product defined in [`spec.md`](../spec.md); evidence in [`reports/Body Battery and sun face research.md`](../../../reports/Body%20Battery%20and%20sun%20face%20research.md) and `research_notes/Body Battery and sun face research/`. Read spec, report, `platform.md` first.

## Implementation status (2026-09-26)

Everything marked "simulator" **not seen on a watch**. No screenshot of face exists.

| Phase | State |
|---|---|
| 0 Owner decisions | **Done in part.** Name (Two Suns, ADR-010), category (Utility), price (USD 1.99, ADR-002) confirmed 2026-09-27. **Look still not decided**: no screenshot, no approval. Owner said 2026-09-26 proceed w/o further permission questions; defaults in [`decisions.md`](../decisions.md) taken, reversible |
| 1 On-watch probes | **Done in part.** Owner ran M1, M2 on FR965, 2026-09-27 (results: `device-test/LocationProbe-RESULTS.md`). Positioning confirmed (Q1 no, Q2 no, Q3 yes → keep it); location code + location path now ran on a watch. **Not run, not blocking**: M3 (outdoors), M4 (overnight log), Q4/Q5/Q7/Q8 full `diff` — none can change Positioning call; left for before submission. Tier B still gated on full probe set |
| 2 Skeleton and verified logic | Done (simulator): sun maths w/ 27 USNO reference tests, calendar, local time, Body Battery buckets, place, sky states |
| 3 Plain working face | Done (simulator): readings, state, settings (five lists, `tools/gen_settings.py`), sources for clock, Complications, history, location |
| 4 The real face | Built (simulator): layout, sky ring, energy curve band, battery glyph, always-on. **Owner has not approved look**; no screenshot; rectangles not looked at by eye |
| 5 Screen-fit tests | **Done for all 69 products** (`tools/fit_products.sh`, 2026-09-27: `bin/fit-products.txt`, `done: 69 pass, 0 fail`, 122 of 122 on each, English only, incl. Venu X1). Started w/ ten screen-size subset (`tools/fit_all.sh`), then full sweep done |
| 6 Languages | Fourteen machine-drafted translations written; `tools/check_strings.py` passes. **Never fit-tested in any language** (`tools/fit_languages.sh` not run); no native reader |
| 7 Documentation | Done this step (`CLAUDE.md`, `README.md`, `PRODUCT.md`, `DESIGN.md`, `CHANGELOG.md`, `docs/*`). `listing/` written by parallel step |
| 8 Listing and site | In progress elsewhere: site pages drafted (`site/src/apps/two-suns/`, staged, not deployed); `listing/` not in tree when written. Screenshots are owner's |
| 9 Device evidence and submission | Not started. Owner's checklist `device-test/TwoSuns-CHECKLIST.md` not written |
| 10 After approval | Not started |
| 11 Free + Pro ladder (WP5 of `../../reports/Free and Pro ladder execution plan.md`) | **Built 2026-10-01, UNRELEASED, simulator-grade, proposed.** Free twin and Pro 1.1.0 compile for both jungles; tests written for both, **not run** (simulator not used); packages built, contents checked. Open: owner decisions (names, prices, tier of date row and orientation, empty Body Battery wording, icon, translations, uploads), test runs, device check. See "Phase 11" below |

Last recorded runs: 120 tests, 2026-09-26, on `fr965`, `fenix7`, `venu3` and ten fit sizes above, all passing in simulator (logs `bin/t-<device>.log`, 21:49 to 22:01). Full 69-product compile sweep, run after 15-language manifest added, printed `BUILD SUCCESSFUL` for all 69 at `-w --typecheck 3`, zero errors, no warning beyond launcher-icon-scaling notice (icon 65 px, placeholder generic); build outputs not kept (`bin/` git-ignored scratch, deleted after each run per house rules), so this rests on run having happened, not saved log. Translations, manifest language list, low-battery colour change all in place for full re-run 2026-09-27: `fr965`, `fenix7`, `venu3` and all ten fit-sweep devices, 122 of 122 on every one. Full 69-product compile not repeated since (earlier sweep still covers build errors for all 69; only language edit followed, and English-language builds compile same regardless of shipped languages). Tests do not check pixels.

Text of phases 0 to 10 below = original plan; table above = state. Owner-only steps (phases 0, 1, 9 and gates in 4 and 8) unchanged.

## What the build learned

- **Sentences too wide for round screen.** Strengthened fit test failed on `fr265s` (360 px) and `venusq2` (320 by 360) with one wording per sentence; fix = three wordings + measured choice (ADR-014).
- **Local offset must not be wrapped.** Comparing day numbers as well as clock times gives +14:00 and -10:00 correctly (ADR-012).
- **Calculation is more than Tier B fallback.** Fills polar days, transition-day gap, tomorrow's sunrise, so spec sky states grew (ADR-013).
- **Wrong number worse than "--".** History w/ no valid sample: Garmin's single number not substituted (ADR-015).
- **Simulator keeps last saved settings**, so Monkey C test cannot see changed default in `properties.xml`; `tools/gen_settings.py --check` verifies files instead.
- **Environment cannot capture simulator**, `Dc.getPixel` does not exist in SDK 9.2, so layout read from fit test's box log ("cut:" lines and boxes), not images.
- **Compiler quirks** cost time: see [`development.md`](../development.md) "Compiler and SDK quirks".
- **Simulator wedges, test runners kill it.** `tools/run_tests.sh` runs `pkill -f monkeydo` after every run, restarts simulator with `pkill` on wedge (`tools/fit_languages.sh` on no-result retry); another session sharing simulator makes wedges worse, loses its work ([`development.md`](../development.md) "Shared simulator").
- **`.iq` export overreports device count** against manifest. Unresolved; details in [`compatibility.md`](../compatibility.md#the-export-and-89-devices).
- **Always-on text contrast fixed 2026-09-27** (ADR-007 amendment, `docs/decisions.md`). Still open: stale curve fill — decide on look approval.

## 0. Ground rules (they override anything below if in conflict)

1. **Do not stage, commit, stash or reset.** Git index mixed staged/unstaged, belongs to owner. Leave everything in working tree; end each phase by listing files created or changed.
2. **Signing key** is `~/.garmin-connectiq/keys/developer_key`, outside repo. Never copy in; never commit any `.der` or `.pem`. Project `.gitignore` copies Days To Go's.
3. **Simulator passing is not device proof.** Every report says, per watch product, what ran in simulator and what (only owner's FR965) ran on a wrist. Simulator has **no GPS position, canned weather, canned sun values, synthetic Body Battery**: proves layout and logic, never data.
4. **Behaviour change → update doc that describes it, same session. Durable decision → ADR** in `docs/decisions.md` (list in phase 7). User-facing claims live in two places: listing and `site`; change both together, never change or remove published URL.
5. **Code rules** (from `DaysToGo/CLAUDE.md`, which this project mirrors): every function has typed parameters and `as` return type; no `as Any`; cast only after `instanceof` or null guard; no magic numbers (tunables and keys in `TwoSunsConfig`, geometry in `TwoSunsLayout`, colours in `TwoSunsPalette`, words in `strings.xml`); text fit measured, never guessed; render only in `onUpdate`, gather data in `TwoSunsReadings`, draw from `TwoSunsState`; one class per file w/ `TwoSuns` prefix; functions ≤ about 30 lines, files ≤ about 250; comments explain why; property key spellings never change once shipped.
6. **Forbidden in this app** (each found to hurt rival or wearer; research notes say why): `Weather.getSunrise` and `getSunset` as primary source (cross-check and tier B fallback only, D5); `Position.getInfo()` in build whose manifest lacks Positioning; `type="date"` and `numeric` settings; any mood, emoji or advice tied to Body Battery; network; `Background`, `Communications`, `UserProfile`; permissioned call outside manifest declaring it (calling `Position.getInfo` without permission **kills app, cannot be caught**); seconds; storing anything but rounded place.
7. **Build with warnings and strict typing on**, keep at zero: `-w --typecheck 3`.
8. **Trust printed `PASSED (…)` line, not exit code.** Simulator wedges every few runs; `tools/run_tests.sh` restarts once. Run printing nothing = wedged, not failed.
9. **Do not invent evidence**: no reviews, downloads, screenshots, battery figures, accuracy claims in any doc or listing.
10. **Edits outside `TwoSuns/` limited to**: root `CLAUDE.md` project table (one row), root `README.md` layout note, `site/` (phase 8 only). Ask before touching `HeroSet/`, `HeroFace/` or `DaysToGo/`. Copy from `DaysToGo/source/` at current commit; do not import.

**Never decide alone**: store name, price, visual identity, launcher icon, Positioning permission, any Connect IQ store upload, any phone or watch test, site deploy, shipping machine translations no native speaker has read.

## 1. Where things are

```
TwoSuns/
  docs/spec.md  docs/archive/plan.md  ...               docs (see phase 7)
  source/*.mc  source/test/*.mc                 the app
  tools/*.py  tools/run_tests.sh  ...           generators and test runners (copy from DaysToGo/tools)
```

Patterns to copy (adapt names, do not depend on them): `DaysToGoCalendar.mc` (integer calendar-day arithmetic), `DaysToGoLayout.mc` (font-height stacking, chord insets, ring), `DaysToGoDraw.mc` (measured text, truncation with marker), `DaysToGoSleep.mc` (always-on grid step), `DaysToGoText.mc`, `DaysToGoPalette.mc`, `source/test/DaysToGoScreenFitTest.mc` (`everyStateFitsThisDisplay`), `tools/gen_settings.py` (list settings), `tools/run_tests.sh`, `tools/fit_all.sh`, `tools/check_strings.py` (translation parity), `docs/development.md`, `docs/status.md`. HeroFace's `HeroFaceLink.mc` shows working complication subscription (`registerComplicationChangeCallback`, `subscribeToUpdates`, `getComplication(id).value`) that ran on real FR965.

Reference data and calculation prototype: `research_notes/Body Battery and sun face research/reference_sun_times.tsv` and `probe/sun_reference_check.py`.

## 2. Phases

### Phase 0. Owner decisions [OWNER]

Ask owner, one message: (1) name: **Two Suns** or **Sun Battery** or own (D2); (2) confirm 69 products for v1, tier B in 1.1 (D4); (3) category (D13); (4) look: spec's direction, "two suns" ring plus curve, or another; (5) Positioning permission: owner said yes 2026-09-26; **stays provisional until phase 1 probes report** (D7). Record answers in `docs/decisions.md`. Wait.

### Phase 1. On-watch probes [OWNER] [GATE] (≈ 1 day of wear, no midnight alarms)

Most valuable, cheapest step. Answers what simulator cannot. **No code beyond existing probes written for location until this reports.** Simulator finding to test on watch: Weather's location appeared only with Positioning declared.

1. Two probe faces, same code, different manifests (sources: `research_notes/.../probe/on-watch/`): **Probe-P** (declares Positioning, calls `Position.getInfo`) and **Probe-N** (no Positioning, never calls it). Copy both `.prg` files from `device-test/` to watch's `GARMIN/APPS/`.
2. Each shows, on **even minutes**, live lines: local time, `timeZoneOffset`, `dst`, difference derived from clock; `Position.getInfo` (P only); `Activity.currentLocation`; weather observation location; Weather's sunrise and sunset (local and UTC); Complication sunrise, sunset, Body Battery; Body Battery history count, smallest gap (absolute), order, count of future-dated samples. On **odd minutes** shows **log**: one entry each time any sun time, location source or time zone changes, stamped with local time. Log stored on watch, owner reads it in morning; nobody awake at 00:00 or 03:00.
3. Owner follows `device-test/LocationProbe-CHECKLIST.md` (photos at few moments, eight answers).
4. **Decision table** (implementer fills from photos; owner approves):

| Question | If yes | If no |
|---|---|---|
| Q1. `Act.curLoc` non-null after GPS activity, in **N** (no Positioning)? | Activity is source 1, needs no permission | rely on sources below |
| Q2. Weather `obsLoc` non-null in **N**? | Weather needs no permission on watch (unlike simulator) | Weather's location needs Positioning |
| Q3. `Pos.getInfo` non-null in **P** when Q1 and Q2 null in **N**? | **keep Positioning**; listing discloses location | if Q1 or Q2 yes in N: **drop Positioning**, say "no location permission" |
| Q4. Complication SUNRISE/SUNSET equal native glance (±1 min)? | primary source stands (D5) | make calculation primary, compare again; no location → tier A at risk: stop, tell owner |
| Q5. Log: does API's sunrise/sunset pair change at **local** midnight (simulator: yes)? Do Complication values change at local midnight? | record; D5 unaffected | record; note any surprise (change at UTC midnight would reopen API as source) |
| Q6. Body Battery: samples in 24 h, smallest gap, order, any future-dated? | size buckets (15 min default), order handling | < 20 samples: 1 h buckets, say so |
| Q7. Any value outside 0 to 100, or nulls, in history? | keep validation as specified | keep it anyway |
| Q8. `timeZoneOffset` + `dst` equal derived difference? | either may be used | use derived difference only (spec) |

5. Report same message: what seen, what not, that it is one watch. Wait for owner.

### Phase 2. Skeleton and verified logic (≈ 1 day)

1. Folder skeleton copied from `DaysToGo` (manifest for 69 products, `monkey.jungle` w/ `base.sourcePath = source`, `resources/` w/ `AppName` and launcher icon, `.gitignore`, `tools/`). `minApiLevel="4.2.0"`. Permissions per phase 1 decision (at minimum `SensorHistory` and `ComplicationSubscriber`).
2. Pure logic, each w/ unit tests in `source/test/`:
   - `TwoSunsSun`: NOAA rise, set, civil twilight, golden hour in local minutes from (year, month, day, lat, lon, local offset in minutes). **Reference tests** in spec "Data rules": generate `TwoSunsSunReferenceTest.mc` from `reference_sun_times.tsv` w/ `tools/gen_sun_tests.py` (tolerance 2 minutes; polar rows assert "no event"; transition rows assert nothing stricter than ±1 day).
   - `TwoSunsCalendar` (copied): local date, next day.
   - `TwoSunsBattery`: keep valid samples, bucket by each sample's `when` into 96 buckets, current value, staleness. Tests: 127, negative, 101, null, empty, one sample, gap of hours, samples out of order, newest older than 60 minutes.
   - `TwoSunsPlace`: rounding to 0.1°, source order, "replace only when > 0.1° away", empty.
   - `TwoSunsSky`: from sun times and now → state table's row (day, before sunrise, after sunset, midnight sun, polar night, no place, no data) and bottom-line values ("3:42", tomorrow's sunrise w/ Garmin-offset correction).
3. `tools/run_tests.sh fr965` prints `PASSED`. Also run on `fenix7` and `venu3`. Record counts.

### Phase 3. Settings and a plain, working face (≈ 1 to 1.5 days)

1. `TwoSunsReadings` gathers: Complication values (subscription pattern from `HeroFaceLink`), location (per D7), Body Battery history (every 5 minutes), clock. `TwoSunsState` carries result. `onUpdate` renders only from state.
2. Settings via `tools/gen_settings.py` (lists; five settings in spec); read w/ fallback to defaults.
3. Plain face: time, two numbers, bottom sentence as text; every state reachable in test states. No ring, no curve yet.
4. Build `-w --typecheck 3`, zero warnings on `fr965`, `fenix7`, `venu3`.

### Phase 4. The real face [OWNER gate on the look] (≈ 2 to 3 days)

1. `TwoSunsLayout` (font-height stacking as ADR-012), `TwoSunsRing` (24-hour ring: night, twilight, daylight, gone, ticks, sun marker, golden arc, orientation setting), `TwoSunsCurve` (96 buckets, filled area, current dot), `TwoSunsDraw` (measured text, truncation marker), `TwoSunsSleep` (always-on).
2. Check by eye in simulator on `fr965` (454 AMOLED), `fenix7` (260 MIP), `fr255s` (218 MIP), `venu2s` (360). **Ask owner to approve look before phase 5.** No screenshots produced in this environment (simulator cannot be captured headless); owner supplies them.
3. Bright-sun check: night track and curve's lower level ≥ 3:1 against black; ring must still read at 218 px.

### Phase 5. Screen-fit tests for every state (≈ 0.5 to 1 day)

Copy `DaysToGoScreenFitTest.mc`, extend states (`TwoSunsTestStates`): widest time strings, longest bottom sentences in every language, all Body Battery states, all sun states. `tools/fit_all.sh` on ten sizes in spec plus two rectangular ones. Always-on frame at each of nine drift positions. Zero problems on every size.

### Phase 6. Languages (≈ 0.5 to 1 day)

English plus Days To Go's 14. `tools/check_strings.py` for parity, `tools/fit_languages.sh` for fit. Machine-drafted, unread by native speakers: say so. Sentence strings few ("of daylight", "Sunrise", "Sun stays up today", "No place yet", "No sun data", "--").

### Phase 7. Documentation (≈ 1 day)

`CLAUDE.md`, `README.md`, `PRODUCT.md`, `DESIGN.md`, `CHANGELOG.md` (1.0.0 entry when submitted), `docs/decisions.md`, `docs/compatibility.md`, `docs/development.md`, `docs/release-contract.md`, `docs/status.md`, `listing/` (`README.md` paste-ready, `NOTES.md`, `screenshots.md`). ADRs to write: ADR-001 concept (two suns); ADR-002 price; ADR-003 sun times from Complications, `Weather.getSunrise` only as cross-check and tier B fallback (w/ hourly-sweep evidence and retracted UTC-date reading); ADR-004 own NOAA calculation and tomorrow's correction; ADR-005 location order and Positioning decision; ADR-006 rounded place in Storage; ADR-007 always-on; ADR-008 no verdicts on Body Battery; ADR-009 device set (tier A) and tier B plan; ADR-010 name and slug; ADR-011 24-hour ring is wall-clock. Add row to root `CLAUDE.md` and `README.md`.

### Phase 8. Store listing and site (≈ 1 day)

`listing/paste.md` in form order as Days To Go's. No claims release contract forbids. Screenshots supplied by owner. Site pages under `site/src/apps/two-suns/` (landing, support, privacy) w/ site's rules (zero client JS, CSP, DESIGN.md). Support text covers: what "No place yet" means, two ways to fix (a GPS activity once; Garmin's Sunrise/Sunset widget); Garmin Connect settings; Body Battery is Garmin's estimate. **Do not deploy site**; owner does.

### Phase 9. Device evidence and submission [OWNER] (≈ 1 day of wear + 72 h review)

1. Owner sideloads dev build on FR965. Checklist (write `device-test/TwoSuns-CHECKLIST.md`): time and ring correct at first sight; sunrise and sunset **equal native glance**; ring on right local day across local midnight and across UTC midnight; run w/ phone off and GPS off; Body Battery curve shape vs Garmin's own graph; always-on night (blanks?); battery over 24 hours vs same watch on Days To Go; DST if change day falls in window.
2. Submit only what was seen. If always-on blanks, raise drift step or shrink number (ADR-007 rule).
3. Store form fields per listing README; price answer per D3; Monetization "No" as Days To Go's.

### Phase 10. After approval

Set "Price review due" (approval + 45 days) in `TwoSuns/CLAUDE.md` and memory index; set `storeUrl` in `site/src/apps/two-suns/app.ts`; update root README status; record HeroSet, HeroFace, Days To Go download buckets as baseline for price review. Tier B (1.1) if probe allowed.

### Phase 11. Free + Pro ladder (proposed, UNRELEASED)

Decision records: ADR-020 (Free + Pro ladder) and ADR-021 (Body Battery in Free) in [`decisions.md`](../decisions.md); what each tier has in [`spec.md`](../spec.md) "Free and Pro". Builds against plan; owner has not signed off OD1 and OD2, so ADR-002 (price, day-45 review) still governs, prepared 1.0.1 separate (plan WP5 step 7).

| Step | State, 2026-10-01 |
|---|---|
| Free manifest (new app id), jungle, tier-only resources and settings (`manifest.free.xml`, `monkey.free.jungle`, `resources-free/`, `resources-pro/`), generator w/ tier argument, `AppName` only in tier folders | Done |
| Pro-only code marked `(:pro)` w/ `(:free)` twins; Pro behaviour unchanged | Done (compiled; `resources-pro/settings` byte-identical to old shared one; weather row, ADR-022, came after, changed Pro on purpose) |
| Free manifest permission `ComplicationSubscriber` only; compiler rejects any `SensorHistory` or `Positioning` call site in Free jungle | Done (that is how sites were found) |
| Tests (as of ADR-020; ADR-022 later added 19 Pro-only weather tests and 4 battery-row tests, so 60 shared, 94 Pro-only, 7 Free-only now): 60 shared, 70 Pro-only, 7 Free-only (Free defaults for Pro keys, no "No place yet", Body Battery without history, missing-key probe, Free frame) plus 6 accent-table tests in Pro's and Free's counts | **Written and compiled for both jungles on ten `fit_all` devices and `venux1`; not run** |
| Compile sweep, both jungles, every manifest product | **Run 2026-10-01, compile only: 69 of 69 pass on each jungle** (`tools/compile_sweep.sh`; 57 per jungle carry only launcher-icon notice, 12 warning-free); 44 of 44 normal and `-t` builds on 11 screen classes |
| Packages `dist/TwoSunsFree.iq`, `dist/TwoSunsPro.iq` and contents check (`tools/check_free_package.sh`) | Done 2026-10-01, both OK (compile only); see `development.md` |
| `listing-free/` (README, NOTES, screenshots), CHANGELOG entries, publish-checklist block, release-contract section | Drafted; no screenshots exist (none invented) |
| **Owner:** OD1 to OD4, names and store titles, Pro price tier, Free icon, translations of any new string (none added), whether date row and orientation are Pro only, wording of empty Body Battery state (ADR-021, Body Battery in Free), look approval (no visual redesign in this build), uploads (Free 1.0.0 new, Pro 1.1.0 on existing id, together), site (WP8) | Open |
| **Tests to run (main thread):** see `development.md`; Pro on device matrix, Free on same, then `fit_all.sh` for each jungle | Open |

## 3. Definition of done for the whole project

- `tools/run_tests.sh` prints `PASSED` on `fr965`, `fenix7`, `venu3`; all reference sun tests pass at 2 minutes; `tools/fit_all.sh` reports zero problems on every size.
- Zero warnings at `-w --typecheck 3`.
- Manifest declares exactly permissions decisions allow, no call outside them.
- `docs/decisions.md` has ADRs; `CHANGELOG.md`, `listing/paste.md`, site pages agree with each other and release contract.
- Owner has seen face on a watch, phase 9 checklist in report.

## 4. Stop and ask the owner when

- Probes show **no location source works** (Q1, Q2, Q3 all "no" in both P and N) *and* Complication sun values null: tier A has no sun data; concept needs decision.
- Complication values disagree w/ native glance by more than 1 minute.
- Always-on frame blanks, or memory used exceeds 70% on smallest v1 watch.
- Translation or any store-facing text needs fact you lack.
- About to use permission, network call or claim spec forbids.

## 5. Command cheat sheet

```bash
cd TwoSuns
tools/run_tests.sh fr965                       # unit tests on one product; trust the PASSED line
tools/run_tests.sh fr965 everyStateFitsThisDisplay
tools/fit_all.sh                               # screen fit on ten devices (one per size but Venu X1)
monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3   # Pro; -f monkey.free.jungle is Free
tools/run_tests.sh fr965 monkey.free.jungle    # the same suite on Free (jungle is the optional second argument)
tools/compile_sweep.sh                         # compile every product, both jungles (no simulator)
tools/check_free_package.sh [--build]          # prove both packages' contents
python3 tools/gen_sun_tests.py                 # regenerate the reference tests from the table
python3 tools/gen_settings.py --check          # settings files match the tables
python3 tools/check_strings.py                 # translation parity and length
tools/fit_products.sh [id ...]                 # every manifest product (slow; kills a shared simulator on a wedge)
tools/fit_languages.sh [-l "deu fin"] <product>  # one run per language
```