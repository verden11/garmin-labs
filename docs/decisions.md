# HeroSet decision log (ADRs)

Every durable design decision, newest last. `architecture.md` describe how app built *now*; this file explain *why*. Add new ADR at end for any decision future contributor would otherwise re-litigate. Mark old ADRs **Superseded** or **Amended**, never delete.

Numbers 009 and 015 never recorded.

## Read these first

If only read five: **ADR-002** (XP can't be farmed), **ADR-018** (measure text, never guess), **ADR-022/023** (device-only crashes simulator can't show), **ADR-024** (navigation depth invariant: wrong pop counts exit app).

## Index

| ADR | Decision | Status |
|---|---|---|
| 001 | Local calendar day key, no epoch math | Active |
| 002 | XP only for net stored progress | Active |
| 003 | Schema-versioned storage, grouped dictionaries | Active, amended by 032 and 036 |
| 004 | Gravity-removed turning-point rep detector | Superseded by 032 |
| 005 | 25 Hz sensor; calibration shares the live stream | Active |
| 006 | Shared `HeroSetLayout` geometry | Active |
| 007 | Workout Back → Yes/No confirm | Superseded by 028 |
| 008 | Calibration hidden from the release build | Superseded by 033 |
| 010 | Storage write failures flagged, not fatal | Active |
| 011 | No `SensorLogging` permission | Active |
| 012 | Dashboard redraws on day change | Active |
| 013 | One class per file, `HeroSet` prefix | Active |
| 014 | Tests in `source/test/` | Active |
| 016 | One FIT activity per workout | Superseded by 021 |
| 017 | Manual entry is a delta picker | Active, amended by 028, 029 |
| 018 | Measure text, never guess fit | Active |
| 019 | Narrow stored numbers via `instanceof` | Active |
| 020 | `HeroSetStore` over its size budget | Open debt |
| 021 | Workout HR/calories without a FIT session | Active |
| 022 | Device-only crashes: Storage Symbols, array casts | Active (lesson) |
| 023 | Sensor listener must use `method(:symbol)` | Active (lesson) |
| 024 | Finish → picker; picker always at depth 1 | Active, amended by 028 |
| 025 | Opt-in Connect sync, one activity per day | Superseded by 043 |
| 026 | On-watch validation log (dev build) | Active |
| 027 | Main menu on `Menu2`; sync is a toggle | Active, amended by 033, 043 |
| 028 | UX pass: Back action menus, menu focus, feedback | Active |
| 029 | Button rules: no long-press, bezel names | Active |
| 030 | Sync diagnostics + empty-session guard | Superseded by 043 (its device result still stands) |
| 031 | Dashboard redesign + rank curve | Active |
| 032 | Rep detector follows tilt (push-ups, sit-ups) or height (squats) | Active, **unvalidated on the watch** |
| 033 | v1 store build: calibration in, Connect sync out, no `Fit` permission | Active, sync clause amended by 043 |
| 034 | Wave 1: 16 round AMOLED five-button watches; per-device screen-fit test | Active, **simulator-verified except FR965** |
| 035 | Wave 2: 18 round MIP watches (fēnix 7/8 Solar/9 Pro Solar, FR255/955, Enduro 3) | Active, **simulator-verified** |
| 036 | Storage writes flat keys only; shared fit/exit-menu helpers | Active, amends 003 |
| 037 | Wave 3: 16 more round AMOLED five-button watches | Active, **simulator-verified**, amended by 038 |
| 038 | Wave 4: `minApiLevel` 3.4.0, 17 fēnix 6 / MARQ Gen 1 / Descent MK2 / FR945 LTE / Enduro watches | Active, **simulator-verified** |
| 039 | First paid submission lists all 67 products; no in-app trial for v1 | Active |
| 040 | Thresholds learned from saved counts; calibration screen removed; no position gating | Active, **simulator-verified**, amends 032/033 |
| 043 | Connect sync: one activity per workout, one lap per set with exercise + reps | Dev build only, **unverified on the watch** |

---

### ADR-001: Local calendar day key
`HeroSetCalendar.todayKey()` = `year*10000 + month*100 + day` from local clock (`Gregorian.info`). Never epoch/86400 math: DST days 23 or 25 hours, so "same day" / "next day" must compare calendar dates.

### ADR-002: XP only for net stored progress
2 XP per rep (`XP_PER_REP`), credited against per-exercise daily ratchet capped at `MISSION_GOAL`. `add(+10)` then `add(-10)` pays once; reps past 100 pay nothing. Max 600 XP a day. Rank and streak build on this → never award XP from raw input amounts.

### ADR-003: Schema-versioned storage. **Amended by ADR-032**
`hero_schema` (3). Flat `hero_*` keys: their spelling must never change. The grouped dictionaries this ADR added were removed by ADR-036.

### ADR-004: Magnitude rep detector. **Superseded by ADR-032**
Gravity-removed acceleration magnitude, calibrated thresholds. Blind to wrist rotation; failed on the watch.

### ADR-005: 25 Hz, one stream
Counting and calibration use same 25 Hz listener → calibrated thresholds match what counter sees.

### ADR-006: Shared layout layer
All geometry from `HeroSetLayout` (round-chord insets, bands, ring). Views never compute raw pixels.

### ADR-007: Workout Back Yes/No dialog. **Superseded by ADR-028**
Couldn't express "discard".

### ADR-008: Calibration hidden from the release build. **Superseded by ADR-033**
Origin of the `store.jungle` + `resources-store/` menu overlay.

### ADR-010: Storage write failures
`Storage.setValue` wrapped in try/catch (`StorageFullException`); app keeps running, dashboard footer shows `! COULD NOT SAVE`.

### ADR-011: No `SensorLogging` permission
Not requested until raw sensor export actually built.

### ADR-012: Dashboard day refresh
`HeroSetDayTracker` checks every `DAY_CHECK_INTERVAL_MS` (60 s) while dashboard visible, redraws when local day changes → counts reset at midnight without relaunch.

### ADR-013: One class per file
Filename = class name, `HeroSet` prefix everywhere (Monkey C has no modules). Test files may hold small test-only helper classes.

### ADR-014: Tests
`(:test)` functions live in `source/test/`, excluded from normal builds, run with `monkeyc -t` + `monkeydo … -t` (`development.md`).

### ADR-016: One FIT activity per set. **Superseded by ADR-021**
Cluttered the Connect/Strava feed.

### ADR-017: Manual entry picker. **Amended by 028, 029**
`HeroSetManualPickerView` edits signed delta with Up/Down instead of `+1/+5/+10` menu. Now: exactly ±1 per press (029), Back opens Save/Discard/Keep Editing (028).

### ADR-018: Measure text, never guess
Fit decided by `dc.getTextWidthInPixels` against round chord (`HeroSetLayout.fitCenteredY`, `HeroSetDraw`), falling back to shorter wording or smaller fonts. "Safe character count" clips unpredictably by font/device.

### ADR-019: Narrow stored numbers
Storage returns `Object` (Number *or* Float). Read through `asNumber`/`asNumberOrNull` (`instanceof` narrowing); `.toNumber()` on `Object` fails to compile on current SDK.

### ADR-020: `HeroSetStore` size. **Open debt**
472 lines (2026-09-17) against 250-line budget. Natural splits: schema migration, calibration profiles, diagnostics log. Deferred because it guards real user data: do it with store test suite green *and* device upgrade check (go-to-market gate 4), not as drive-by.

### ADR-021: Workout metrics without a FIT session
Live HR from `Sensor.getInfo().heartRate`; calories = change in `ActivityMonitor.getInfo().calories` (Garmin whole-day total) since set started. No Training Effect/Load, accepted. (`Fit` permission came back for ADR-025 sync only; readouts still don't use a session.)

### ADR-022: Device-only crashes (lesson)
Found in `CIQ_LOG.YAML` from real FR965; simulator never reproduced them.
1. `Storage.setValue` throws on **Symbol** dictionary keys/values: calibration dictionary keyed by exercise *strings* (`exerciseKeyString`). Guarded by `calibrationDictionaryUsesStringKeysNotSymbols`.
2. `as Lang.Array` cast on firmware-built accelerometer arrays throws. Read `x/y/z` untyped, guard with `instanceof Array`, index directly.

### ADR-023: Sensor listener binding (lesson)
`registerSensorDataListener(self.onSensorData, …)` registers fine but **never dispatched** on FR965 firmware (simulator dispatches it). Use `method(:onSensorData)` with `public` method, like SDK PitchCounter sample. Found by `git bisect` on device, using persisted breadcrumbs (technique in `development.md`).

### ADR-024: Finish → picker; depth-1 invariant. **Amended by 028**
No pause/resume. START (Finish) opens manual picker seeded with detected count → correcting miscount reuses one UI. **Invariant:** every caller pops its own view *before* pushing picker, so picker always sits directly on dashboard. Save/Discard paths pop fixed count; break invariant and they either strand a view or pop past root, which **exits the app**. Save feedback centralized in `HeroSetSaveFeedback`.

### ADR-025: Opt-in sync, one session per day. **Superseded by ADR-043**
Relied on a session surviving app close; it doesn't (ADR-030).

### ADR-026: On-watch validation log (dev build)
No reliable way to pull app data off this FR965 → workout-seeded saves log `mmdd EX detected->saved error` into capped ring buffer (`VALIDATION_LOG_MAX_ENTRIES` = 30, flat key, no schema bump). Read via dev menu → Validation Log; transcribe into `validation-log.md`.

### ADR-027: `Menu2` main menu; sync toggle. **Amended by ADR-033, ADR-043**
Main menu is `Menu2` so Connect Sync is `ToggleMenuItem` with visible On/Off; no confirmation. Resource toggles static → `HeroSetMenuDelegate.prepare` stamps live state before pushing. `Menu2` never pops itself: every handler pops explicitly. Turning sync off saves day's session and clears stored session day.

### ADR-028: UX pass
- **Back action menus** replace Yes/No: workout `Resume/Save/Discard`, picker `Save/Discard/Keep Editing`. Leaving pops 2, resuming pops 1 (relies on ADR-024).
- **Menu shortcut:** Start items show `42/100`/`DONE`; focus lands on first unfinished exercise.
- **Feedback tiers:** mission complete (toast + 3 pulses) > exercise done (+2) > `+N SAVED`; in-set rep that crosses goal pulses twice.
- **Honest calibration:** manual stop can't succeed (10 cycles auto-finish), so it reads `STOP`; rejections say `ONLY n/10 REPS` or `WEAK SIGNAL`.
- Picker delta clamped at `-storedCount`; workout redraws at 1 Hz; all text in `strings.xml` via `HeroSetText`; hints light gray for contrast.

### ADR-029: Button rules
- **No long-press gestures:** holding button opens watch shortcuts on FR965. Picker is ±1 per press, calibration ignores Menu.
- **Hints use bezel names:** `START`, `UP/DOWN`, never `SELECT`/`DN`.
- **Sync label** is `Connect Sync` so toggle switch doesn't cut it off.

### ADR-030: Sync diagnostics for the per-day session. **Superseded by ADR-043**
Added `SYNC …` lines to the validation log. **Device result that still stands (2026-09-16):** after reopening, the day's session was gone (`SYNC LOST`) and Connect had two HeroSet activities HeroSet never saved → the watch saves an unfinished recording when the app closes.

### ADR-031: Dashboard redesign + rank curve
- **Rank curve:** flat 100 XP/rank gave +6 ranks per full day. Now rank r→r+1 costs `300 × min(r, 14)` XP: rank 10 ≈ 3 weeks, then 1 rank per full week. Rank derived, never stored → no migration.
- **Home screen:** gold XP ring on bezel, `RANK N` + `N XP TO RANK M`, thick mission bars (blue in progress, green + `DONE` label when done), streak line, footer.
- **Honest streak:** `HeroSetRules.activeStreak` shows 0 once a day missed.
- **Palette:** `HeroSetPalette` roles: gold = kept progress, blue = today's effort, green = done, gray = secondary, red = alert. State never relies on color alone.

### ADR-032: Rep detector follows tilt or height. **Unvalidated on the watch**
ADR-004 detector failed first watch trials (push-ups 4/10, squats 19/10). Physically shaped fixtures (`HeroSetMotionFixture`: real tempos, holds, still lead-in) reproduced both in simulator: 0/10 push-ups and sit-ups, 19/10 squats. Two causes:
- **Magnitude is blind to rotation.** Planted-hand push-up or sit-up mostly tilts wrist → acceleration strength unchanged.
- **State machine counted half-reps.** Squat braking and push-up are same-sign lobes; with pause at bottom each completed its own "cycle".

New detector (`HeroSetRepCounter`), one rep per **full** swing (past +arm, then past -release, or reverse), at least `SENSOR_COOLDOWN_MS` (250 ms) between the two sides:
- **Push-ups, sit-ups:** smooth each axis, subtract ~2 s per-axis baseline, project onto principal axis of deviation (Oja's rule, seeded by first clear movement). Signed, independent of how watch worn.
- **Squats:** strength minus its baseline, integrated twice with ~1 s leaks → approximates height. Velocity tried first but shrinks with tempo, so squats calibrated fast counted 0/10 slow ones.
- **Calibration** fits 25% of mean swing, floored at calibration thresholds → rep that counted while calibrating can count again.
- **Stored profiles** carry `model = 2`; anything else (including every profile fitted by old detector) reads as uncalibrated.

**Known limit:** leaky double integral swings back past zero after any single movement (about 25–80% of the swing), so one isolated up or down movement — standing up from a kneel mid-set — can count as rep. Within a set the swing-back merges with next movement, no harm.

Tests: every exercise at four tempos (0.6 s to 2 s per movement), slowing reps, calibrating fast or slow then repping at every tempo, still wrist for 60 s, a knock, slow posture drift. Filter constants tuned on those fixtures only, not on watch recordings, so **launch gate 2 still needs the on-watch trials** (`validation-log.md`).

### ADR-033: v1 store build: calibration in, Connect sync out
Decided 2026-09-17 to publish sooner.
- **Connect sync is dev-build only.** Watch saved more than one activity a day (ADR-030), fix not agreed. `HeroSetSyncCoordinator` and `HeroSetActivitySync` annotated `(:sync)`; store build excludes them and compiles `(:nosync)` no-op classes of same names → callers don't branch. `store.jungle` uses `manifest-store.xml`, identical to `manifest.xml` except **no `Fit` permission** → nothing in store build can record activity. Both manifests must keep same app id. Store menu has no sync toggle; `HeroSetMenuDelegate.prepare` guards missing item, since `getItem(-1)` would run on every menu open.
- **Calibration ships in the store build** (Phase 1 option A). Without it release auto-counted with default thresholds and no way to tune them. Validation Log stays dev-only.
- **New app id** `568d5c9b-eb10-4678-bf28-0080c3efbbc1`, since test uploads used up old one. Dev build sideloaded under old id is separate app on watch, own storage.

### ADR-034: Wave-1 devices and a per-device screen-fit test
- **Products:** 16 watches matching FR965 hardware shape: round AMOLED, five buttons, Connect IQ 5.2+, 100 Hz accelerometer, 786 KB app memory (Forerunner 165/265/570/965/970, epix Gen 2 and Pro, fēnix 8 AMOLED, fēnix E). List and exclusions: `compatibility.md`. Two-button touch watches, MIP screens, Instinct cut-out screens left for later waves — they need input, palette or layout work, not just manifest entry.
- **Screen-fit test:** all view text goes through `HeroSetDraw.text`, which — while `HeroSetDraw.misfits` set (tests only; null in app) — records text boxes outside round display and every box drawn. `everyScreenFitsThisDisplay` swaps in seeded in-memory store (`HeroSetApp.swapStoreForTest`; this and `HeroSetWorkoutView.setCountsForTest` are `(:debug)`, since runner would execute a `(:test)` method as a test, and release exports strip them), renders every screen in widest state (3-digit counts, full log page, RANK 999…) onto bitmap of device size, asserts no clipping and no overlapping text boxes per screen. Running suite in each product's simulator checks that product's real fonts. It found real clipping and overlap, FR965 included; affected screens now stack rows by measured font height.
- **Launcher icon:** one 65 px SVG; compiler scales it to 54/60 px on smaller products (build warning, expected).
- **Test hooks** are `(:debug)`, and `store.jungle` excludes `debug` as well as `sync`: without that they compiled into non-release store build. Screen-fit test and harness carry `(:test :debug)` → store-build test run skips them (counts differ between the two runs; current numbers in `development.md`).
- **Fonts differ inside a family:** `fr965` and `fr970` are same 454 px round AMOLED product family with different font metrics → every product gets own simulator run, not one per family.
- **Limit:** only FR965 used on real watch. Boxes use full font height → test judges clipping and overlap only, not visual balance. `HeroSetDraw.misfits`/`boxes` ship in release build as inert statics.

### ADR-035: Wave 2 — round MIP watches
18 more products (fēnix 7 and 7 Pro in all three sizes, fēnix 8 Solar, fēnix 9 Pro Solar, Forerunner 255 and 955, Enduro 3), taking both manifests to 34. Chosen over other excluded groups because they needed no code change, only verification:
- **Color:** MIP panels 8 bits per pixel against AMOLED 16, but `HeroSetPalette` already uses Garmin 64-color palette (every channel 00, 55, AA or FF) → no role color quantized into another.
- **Size:** 218–280 px against 360–454 px. Proportional layout and measured text fit absorbed it; `everyScreenFitsThisDisplay` passes on all 18, including 218 px `fr255s`, which also has smallest app memory (512 KB).
- Screen-fit test gained minimum-rows-per-screen assertion first, since screen that drew nothing would otherwise pass clipping and overlap checks.

Still excluded, and why, in `compatibility.md`: touch-first watches need different input model (ADR-029), Instinct needs sub-window layout, square products need untested rectangle path. **MIP contrast in daylight is unverified** — no MIP watch used on a wrist here.

### ADR-036: Storage writes flat keys only; one fit helper, one exit menu
Repo-wide simplification pass (2026-09-18), no behaviour change.
- **Storage drops the grouped dictionaries** ADR-003 introduced. `_set` wrote every value twice — flat key *and* a `hero_daily`/`hero_profile` group dict — and `readNumber` read the dict first with a flat fallback, so the second copy was never the answer to anything. Flat keys stay the format (spellings unchanged, ADR-003), `SCHEMA_VERSION` stays 3 because nothing on disk changes, and `migrateFlatStateToDictionaries` plus the pre-grouping calibration key reader go with it. Calibration keeps its own `hero_calibration` dictionary — that one holds real per-exercise structure.
- **Exercise storage keys derive from one mapping.** `keyFor` and `creditKeyFor` are `"hero_" +` / `"hero_credit_" +` `exerciseKeyString(exercise)`, which is now the single place an unknown exercise throws instead of silently writing SQUATS state.
- **One text-fit helper.** `HeroSetDraw.fits/firstFitting/largestFont` take a radius and a margin instead of existing twice, once against the display and once (`*Within`) against the dashboard's content circle. Call sites pass `layout.displayRadius(), layout.textMargin()` or `layout.contentRadius(), 0`; the arithmetic is unchanged, so no device needed re-checking by eye.
- **One exit menu.** `HeroSetExitMenuDelegate` owns Save / Discard / stay and the ADR-024 pop counts; the workout and picker versions are ~15-line subclasses overriding `save()`. Inheritance rather than a stored `Lang.Method`, because indirect binding has failed silently on device before (ADR-023) and this is the save path.
- **Connect sync was audited as removable and deliberately kept.** It ships in no store build already (`excludeAnnotations = sync`), so deleting it would have saved nothing at runtime, and sync is wanted in the near future (ADR-030's one-activity-per-day bug is the real blocker, not the code).

### ADR-037: Wave 3 — 16 more round AMOLED five-button watches
Takes both manifests to 50 products. Same selection rule as ADR-034: identical input model to FR965 (`enter, up, menu, down, esc`), round AMOLED, Connect IQ 5.1+, 768 KB app memory, so no code changed — only manifest entries and verification.
- **Products:** fēnix 9 and 9 Pro AMOLED (`fenix943mm`, `fenix947mm`, `fenix9pro43mm`, `fenix9pro47mm`, `fenix9pro51mm`), MARQ Gen 2 (`marq2`, `marq2aviator`), D2 Mach (`d2mach1`, `d2mach2`, `d2mach2pro`), Descent (`descentmk343mm`, `descentmk351mm`, `descentg2`), Forerunner 170 (`fr170`, `fr170m`) and Forerunner 70 (`fr70`).
- **New screen size:** `fenix9pro51mm` is 466 px, the first `round-466x466` family here. The proportional layout absorbed it; `everyScreenFitsThisDisplay` passes.
- **Still excluded** for the same reasons as before (`compatibility.md`): Approach, Venu and vívoactive expose no UP/DOWN keys, so the button-first picker and hints (ADR-029) do not apply; Instinct has the sub-window cut-out; square products are untested. Devices below Connect IQ 4.2 stay out (amended by ADR-038: minimum now 3.4).
- **Limit:** unchanged from ADR-034/035 — FR965 is still the only watch used on a wrist.

### ADR-038: Wave 4 — minimum API lowered to 3.4.0
`minApiLevel` 4.2.0 → 3.4.0 in both manifests, adding 17 five-button round MIP watches (67 products): fēnix 6 / 6S / 6 Pro / 6S Pro / 6X Pro, MARQ Gen 1 (8 editions), Descent MK2 / MK2S, Forerunner 945 LTE, Enduro (Gen 1). 4.2.0 was never a deliberate requirement — no earlier ADR relied on it.
- **API check:** every Toybox member the app uses (outside tests) is listed in each 3.4 device's `api.debug.xml` symbol table. `monkeyc` does not check this per device — even at `-l 3` it compiled a 4.0-only call for a 3.4 product — so the symbol table and a simulator run are the evidence, not a clean build.
- **Only test code changed:** `everyScreenFitsThisDisplay` used `Graphics.createBufferedBitmap` (4.0+); it now falls back to `new Graphics.BufferedBitmap` behind a `has` check.
- **Memory:** `fenix6`, `fenix6s`, `enduro` give watch apps 128 KB. Store build measured with `System.getSystemStats()` in the simulator: ~52 KB on the dashboard, ~54 KB peak in a workout, ~73 KB free. The test runner gets 8 MB regardless of device, so a passing suite says nothing about memory.
- **Verification:** store build compiles and the full suite (81 tests, including screen fit) passes on all 17.
- **Why not lower:** below 3.4 `WatchUi.showToast` is missing, so the save confirmation would crash; ≤3.1 also lacks `SENSOR_ONBOARD_HEARTRATE`. With a `has :showToast` guard FR945, FR745 and FR245M (3.3) pass the suite, but a guard alone leaves them with no visible save confirmation, and fēnix 5 Plus (240 px) fails screen fit — older firmware fonts run larger. That wave needs a replacement confirmation and per-device checks. Forerunner 55 (3.4, 208 px) fails screen fit and stays out.
- **Limit:** unchanged — FR945 LTE lacks a `maxAccelRate` entry in its SDK profile (app samples at 25 Hz, which every accelerometer device supports), and no wave 4 watch has been used on a wrist.

### ADR-039: First paid submission lists all 67 products; no in-app trial
Decided 2026-09-18 (user call on `go-to-market.md` open item 0).
- **Products:** submit every product in both manifests, not a short FR965-first list. More buyers day one; accepted risk is that `store-release.md` asks for every listed product to be tested and only FR965 was on a wrist. Listing and support page say the other 66 are simulator-verified (`release-contract.md` forbidden claims unchanged). Beta testers per family (status item 6) stay wanted but no longer gate launch; a watch family that misbehaves in the field gets removed from both manifests in an update.
- **Trial:** wanted a 3-day trial, but Garmin's paid-app monetization documents none; its 48-hour return window is the only built-in try-before-keep. The SDK's `iq:trialMode` (`AppBase.isTrial`, `getTrialDaysRemaining`) predates it and unlocks through a developer-run HTTPS unlock URL with an OAuth1 callback — a payment backend of our own, which is the opposite of selling through Garmin. v1 ships paid with no trial. Revisit only if Garmin documents trials for monetized apps (ask on the developer forum before a later release).
- **Screenshots:** listing images come from the simulator running the store build (still the real build, no mockups), not from the watch.

### ADR-040: Thresholds learned from saved counts; calibration removed
Decided 2026-09-19 after the first FR965 trials of the ADR-032 detector (`validation-log.md`, 2026-09-18): counting mostly right (median error 0.5), but +1/+2 from getting up after push-ups, fast squats missing reps, and phantom reps from arm movement outside the exercise.
- **Learning replaces calibration.** Every saved workout set teaches the detector. During the set `HeroSetSwingTrace` keeps each turning point of the detector signal (reversals under `TRACE_HYSTERESIS` dropped, capped at `TRACE_MAX_POINTS`, memory only). When the picker saves, `HeroSetThresholdLearner` replays the trace at 24 log-spaced thresholds and updates a belief over them: likelihood falls with how far each replay lands from the saved count (tolerance 10% of it, floor so one mistyped count can't overturn agreeing sets), and each set keeps 85% of the old belief and resets the rest toward a log-normal prior around the old default, so roughly the last 6–7 sets decide and a form change is followed. The threshold used is the belief's median: the middle of whichever range fits, the most margin either way. Sets the movement can't explain (more reps saved than swings at the lowest threshold, plus slack) teach nothing. Only the belief (48 numbers per exercise, `hero_learning`) is stored.
- **Why not averaging corrections, or a PID loop.** The count is a staircase in the threshold, so feedback control hunts between steps, and an integral term would chase the getting-up rep by raising the threshold until real reps were lost. Replay says exactly which thresholds would have been right, so there is nothing to estimate by trial and error.
- **Getting up is learned, not thresholded.** The belief has a second half: "this user's last counted rep is getting up, drop it". Getting up is usually the biggest swing of a set, so no threshold removes it alone and the threshold-only fit lands somewhere different every set; the drop hypothesis fits consistently and wins within a few sets. The live screen still shows every detected rep; the picker seed and quick-save use the dropped count.
- **Calibration removed** from both builds: screen, menu entry, 15 strings in 15 languages, `HeroSetCalibration`. Old `hero_calibration` profiles are no longer read. Detector takes one threshold (arm = release). Learning starts at `DEFAULT_THRESHOLD`; the first sets count as the default detector did.
- **No position gating (user call).** Users start a set when in position; arm movement before or between sets is on them. So the gate 2 idle check means 60 s still in exercise position, not 60 s of everyday arm movement (which counted 14 push-ups on 2026-09-18 and is what gating would have fixed).
- **Quick-save (Back → Save) doesn't learn**: the user didn't review the count, so it says nothing about the right one.
- **Limit:** every behaviour above is proven on synthetic traces (`HeroSetThresholdLearnerTest`), not on wrists. Worst-case learning (the longest accepted trace) took ~55 ms in the simulator on fr965 and fenix6; device time unmeasured.

### ADR-041: Rank-up feedback; live count in effort blue
Decided 2026-09-19 after an Impeccable critique of the watch UI (`.impeccable/critique/`).
- **Rank-up is the top save tier.** The XP ring restarts empty at each rank (ADR-031), so without a signal the payoff read as a loss. `HeroSetSaveFeedback.save` snapshots rank before and after `store.add` and shows `RANK N!` with four pulses (`HeroSetHaptics.rankUp`). Tier order: mission complete → rank up → exercise done → saved/removed. Mission complete stays first: it is the once-a-day peak and the save most likely to also cross a rank, and a second toast would only replace the first (`HeroSetSaveFeedbackTest`). Rank stays derived, never stored. A full-ring flourish on the next dashboard was considered and skipped: it needs cross-screen state for a one-frame effect.
- **Every save path goes through `HeroSetSaveFeedback.save`**, so no caller can miss a before/after snapshot.
- **Live count and positive picker delta use `EFFORT`, not gold/green.** Gold means kept (rank, XP, streak), green means a goal met; reps not yet saved are effort. Workout, picker and validation log now use `HeroSetPalette` roles only (no raw `Graphics.COLOR_*`).
- **`EFFORT` 0x00AAFF → 0x55AAFF**: blue bar fill on `TRACK` was 2.91:1, now 3.05:1; still MIP-safe.
- **Picker shows `DETECTED 24 (-1)`** when the learned getting-up rep (ADR-040) is dropped, instead of a bare 23 right after the workout showed 24. The validation log still records the dropped count.
- **Screen titles shrink to fit** (`HeroSetDraw.title`, SMALL → TINY → XTINY) on workout and picker too; long translations (Dutch `BUIKSPIEROEFENINGEN`) clipped at fixed `FONT_SMALL`.

### ADR-042: Paid launch before full gate 2 measurement
Decided 2026-09-19 (user call) after the first learning-build session on FR965: 4 medium-pace 10-rep sets counted +2/0/0/0 (push-ups 12 then 10, squats 10, sit-ups 10), every save returned to the dashboard.
- **Ship paid now, measure after.** Slow/fast sets, the 60 s idle-in-position check, a 30+ rep set and the store build sideload were not run. The listing already makes no accuracy claim: it says the count can be off, each set is reviewed before save, and the count can be corrected (no "beta" in public copy, `release-contract.md`), so a miscount costs a button press, not stored progress (ADR-002).
- **Known risks carried into launch:** fast squats undercounted on the calibrated detector (2026-09-18, −7/−2); push-up getting-up rep only seen dropped once; learning time on a long trace unmeasured on device (~55 ms in simulator, ADR-040).
- **Amends** `go-to-market.md` Phase 1 "accuracy validation method" and the `release-contract.md` release decision: gate 2 becomes a post-launch check; a failure is fixed in an update, and the listing is rewritten manual-first if counting can't be defended as beta.

### ADR-043: Connect sync: one activity per workout, laps per set
Decided 2026-09-19 (user call); full reasoning and platform limits in `connect-sync-plan.md`.
- **A day can't be merged into one activity.** A Connect IQ session records live only (no backdating), doesn't survive the app closing (ADR-030's device result), can't run in a 30 s background service, and no Garmin API accepts a finished activity from outside. So the unit is one HeroSet **visit**. The user is fine with several activities a day and mutes Strava noise on Strava's side.
- **Behavior (sync On):** a visit's first workout set opens a `SPORT_TRAINING`/`STRENGTH_TRAINING` session; the timer runs only while a set screen is up. Each set is one lap, closed when the next set begins, carrying FIT developer fields `Exercise` (string) and `Reps`; session fields hold push-up/sit-up/squat totals. Only workout-seeded saves count (same boundary as learning, ADR-040); negative corrections count as 0. `AppBase.onStop` always saves (≥ 1 saved rep) or discards, and a refused save is discarded: on a normal exit nothing is left open, which should stop the stray activities of ADR-030. Negative corrections lower the visit total (lap stays ≥ 0).
- **Setting:** same `Connect Sync` toggle and `hero_sync_enabled` key (ADR-027), off by default; sublabels say `Saves to Connect` / `Watch only`. Turning it off mid-visit discards the recording. `hero_sync_day` retired, name never reused (ADR-003). FIT field ids 0–4 are fixed forever: they are baked into saved activities.
- **Code:** `HeroSetSyncCoordinator` is now one instance per app (`getApp().getSync()`), `HeroSetActivitySync` is owned by it (its `(:nosync)` twin deleted: nothing outside `(:sync)` code references it). Dev manifest adds `FitContributor`.
- **Still dev-only.** Store build (ADR-033) unchanged until the FR965 acceptance in `connect-sync-plan.md` device acceptance passes; then `Fit` + `FitContributor` go into `manifest-store.xml` and privacy/store copy change the same session.
- **Unverified:** whether Connect (web and phone) shows string lap fields (fallback: three numeric lap fields); that `onStop` covers every exit path (it does **not** run if HeroSet crashes, so a crash mid-visit may still leave a session for the watch to save); where the lap boundary falls when `addLap()` runs right after `start()`; session memory on the 128 KB watches (fēnix 6/6S, Enduro).

### ADR-044: HeroSet publishes today's progress to our own watch face
Decided 2026-09-20 while building HeroFace, the sibling watch face (repo `../heroFace`, its `docs/plan.md`).
- **Complications are the only bridge.** An app's `Storage` is private to that app, so a watch face cannot read HeroSet's counts. Connect IQ's complication publish/subscribe (CIQ 4.2+) is the one supported channel: a device app publishes, and only watch faces may subscribe.
- **Private access, one complication.** `access="private"` limits readers to apps signed with the same developer key, so the data reaches our face and nothing else — not other developers' apps, and not Face It (which is why the resource carries no `faceIt` element). Complication id `0` is stored by subscribers and never changes.
- **One packed string, not four values.** The value is `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay`. HeroSet only publishes while it runs, so the face needs the day keys to tell today's counts from yesterday's and to break a streak HeroSet has not yet seen expire. Field order is fixed; new fields go on the end and `v` only changes on a breaking change. `HeroSetComplicationPublisher.valueFor` is pure and unit-tested.
- **Published on every stored change:** app start, every save (`HeroSetSaveFeedback`, the one path all stored counts go through), and midnight while the dashboard is open (`HeroSetDayTracker`).
- **Older watches build without it.** The resource only compiles for products that have the API, so `resources-complications/` is added per product in both jungles for the 50 products at CIQ 4.2+; the 17 at 3.4–4.1 (ADR-038 wave, e.g. fēnix 6, MARQ Gen 1, Enduro) build without it, and `Toybox has :Complications` makes every publish call a no-op there. Those users' faces fall back to their own everyday goals.
- **Store build publishes too** (unlike Connect sync, ADR-043): nothing leaves the watch, it needs no network and no new user-facing claim, and a face that only worked in dev builds could never ship. The `ComplicationPublisher` permission is in both manifests.
- **Unverified on device:** whether a published value survives a reboot while HeroSet is not running (the face caches the last value either way), and whether the added permission prompts existing users to re-approve on update.
