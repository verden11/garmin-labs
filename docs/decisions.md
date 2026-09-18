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
| 025 | Opt-in Connect sync, one activity per day | Dev build only (033); **unverified, see 030** |
| 026 | On-watch validation log (dev build) | Active |
| 027 | Main menu on `Menu2`; sync is a toggle | Active, amended by 033 |
| 028 | UX pass: Back action menus, menu focus, feedback | Active |
| 029 | Button rules: no long-press, bezel names | Active |
| 030 | Sync diagnostics + empty-session guard | Dev build only (033); investigation paused |
| 031 | Dashboard redesign + rank curve | Active |
| 032 | Rep detector follows tilt (push-ups, sit-ups) or height (squats) | Active, **unvalidated on the watch** |
| 033 | v1 store build: calibration in, Connect sync out, no `Fit` permission | Active |
| 034 | Wave 1: 16 round AMOLED five-button watches; per-device screen-fit test | Active, **simulator-verified except FR965** |
| 035 | Wave 2: 18 round MIP watches (fēnix 7/8 Solar/9 Pro Solar, FR255/955, Enduro 3) | Active, **simulator-verified** |
| 036 | Storage writes flat keys only; shared fit/exit-menu helpers | Active, amends 003 |
| 037 | Wave 3: 16 more round AMOLED five-button watches | Active, **simulator-verified**, amended by 038 |
| 038 | Wave 4: `minApiLevel` 3.4.0, 17 fēnix 6 / MARQ Gen 1 / Descent MK2 / FR945 LTE / Enduro watches | Active, **simulator-verified** |
| 039 | First paid submission lists all 67 products; no in-app trial for v1 | Active |

---

### ADR-001: Local calendar day key
`HeroSetCalendar.todayKey()` = `year*10000 + month*100 + day` from local clock (`Gregorian.info`). Never epoch/86400 math: DST days 23 or 25 hours, so "same day" / "next day" must compare calendar dates.

### ADR-002: XP only for net stored progress
2 XP per rep (`XP_PER_REP`), credited against per-exercise daily ratchet capped at `MISSION_GOAL`. `add(+10)` then `add(-10)` pays once; reps past 100 pay nothing. Max 600 XP a day. Rank and streak build on this → never award XP from raw input amounts.

### ADR-003: Schema-versioned storage. **Amended by ADR-032**
`hero_schema` (currently 3). On mismatch, flat keys mirrored into grouped dictionaries (`hero_daily`, `hero_profile`, `hero_calibration`). Flat keys still written and used as read fallback → their spelling must never change. Since ADR-032, flat calibration keys no longer written or read outside migration, and profiles carry detector `model` number.

### ADR-004: Rep detector. **Superseded by ADR-032**
Accelerometer magnitude, gravity removed with EMA baseline; one rep = positive excursion past `arm` **and** negative excursion past `release`, with cooldown. Thresholds fitted from calibration cycles (half the mean excursion, clamped). Exercise-agnostic.

### ADR-005: 25 Hz, one stream
Counting and calibration use same 25 Hz listener → calibrated thresholds match what counter sees.

### ADR-006: Shared layout layer
All geometry from `HeroSetLayout` (round-chord insets, bands, ring). Views never compute raw pixels.

### ADR-007: Workout Back confirm dialog. **Superseded by ADR-028**
Was Yes/No "Save N reps?" dialog. Couldn't express "discard".

### ADR-008: Calibration hidden from the release build. **Superseded by ADR-033**
`store.jungle` overlays `resources-store/`, whose main menu omits Calibrate and Validation Log. Calibration returns to store build only after physical validation passes (go-to-market gate 1/2).

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

### ADR-016: Per-workout FIT session. **Superseded by ADR-021**
One Garmin Connect activity per set cluttered Connect/Strava feed.

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

### ADR-025: Opt-in Connect sync, one activity per day. **Dev build only (ADR-033); unverified (see 030)**
Off by default (`Fit` permission, privacy-sensitive). When on, one `ActivityRecording` session per calendar day, started/stopped around each set (`SPORT_TRAINING`/`STRENGTH_TRAINING`, no GPS); manual entries don't record. Relies on `createSession()` returning still-open session after HeroSet closed and reopened. Undocumented by Garmin, and first device test suggests it doesn't hold.

### ADR-026: On-watch validation log (dev build)
No reliable way to pull app data off this FR965 → workout-seeded saves log `mmdd EX detected->saved error` into capped ring buffer (`VALIDATION_LOG_MAX_ENTRIES` = 30, flat key, no schema bump). Read via dev menu → Validation Log; transcribe into `validation-log.md`.

### ADR-027: `Menu2` main menu; sync toggle. **Amended by ADR-033**
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

### ADR-030: Sync diagnostics + empty-session guard. **Dev build only (ADR-033); investigation paused**
`HeroSetSyncCoordinator` owns sync day logic, logs `HH:MM SYNC
NEW/KEPT/LOST/SAVED/EMPTY` to validation log; test steps in `development.md`. `closeOpenSession` saves only if session recorded time, else discards → lost session can't become blank activity.
**First device result (2026-09-16):** `SYNC LOST`, plus two HeroSet activities in Garmin Connect that HeroSet didn't save. Hypothesis: watch saves unfinished recording when app closes. Next steps and constraints: `go-to-market.md` status checkpoint, item 0.

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
- **Screen-fit test:** all view text goes through `HeroSetDraw.text`, which — while `HeroSetDraw.misfits` set (tests only; null in app) — records text boxes outside round display and every box drawn. `everyScreenFitsThisDisplay` swaps in seeded in-memory store (`HeroSetApp.swapStoreForTest`; this and `HeroSetWorkoutView.setCountsForTest` are `(:debug)`, since runner would execute a `(:test)` method as a test, and release exports strip them), renders every screen in widest state (3-digit counts, full log page, RANK 999…) onto bitmap of device size, asserts no clipping and no overlapping text boxes per screen. Running suite in each product's simulator checks that product's real fonts. Real bugs found, FR965 included: Validation Log header clipped at `FONT_SMALL` (12 of 16 devices; now shrinks to fit) and overlapped first log line on Forerunner 265; calibration screen `FONT_LARGE` counter overlapped status line. Both screens now stack rows by measured font height instead of fixed bands.
- **Launcher icon:** one 65 px SVG; compiler scales it to 54/60 px on smaller products (build warning, expected).
- **Test hooks** are `(:debug)`, and `store.jungle` excludes `debug` as well as `sync`: without that they compiled into non-release store build. Screen-fit test and harness carry `(:test :debug)` → store-build test run skips them (counts differ between the two runs; current numbers in ADR-036 and `development.md`).
- **Fonts differ inside a family:** `fr965` and `fr970` are same 454 px round AMOLED product family with different font metrics → every product gets own simulator run, not one per family.
- **Limit:** only FR965 used on real watch. Boxes use full font height → test judges clipping and overlap only, not visual balance. `HeroSetDraw.misfits`/`boxes` ship in release build as inert statics.

### ADR-035: Wave 2 — round MIP watches
18 more products (fēnix 7 and 7 Pro in all three sizes, fēnix 8 Solar, fēnix 9 Pro Solar, Forerunner 255 and 955, Enduro 3), taking both manifests to 34. Chosen over other excluded groups because they needed no code change, only verification:
- **Color:** MIP panels 8 bits per pixel against AMOLED 16, but `HeroSetPalette` already uses Garmin 64-color palette (every channel 00, 55, AA or FF) → no role color quantized into another.
- **Size:** 218–280 px against 360–454 px. Proportional layout and measured text fit absorbed it; `everyScreenFitsThisDisplay` passes on all 18, including 218 px `fr255s`, which also has smallest app memory (512 KB).
- Screen-fit test gained minimum-rows-per-screen assertion first, since screen that drew nothing would otherwise pass clipping and overlap checks.

Still excluded, and why, in `compatibility.md`: touch-first watches need different input model (ADR-029), Instinct needs sub-window layout, square products need untested rectangle path. **MIP contrast in daylight is unverified** — no MIP watch used on a wrist here.

### ADR-036: Storage writes flat keys only; one fit helper, one exit menu
Repo-wide simplification pass (2026-09-18). No behaviour change intended; 80 tests pass in the dev build, 79 in the store build, and `everyScreenFitsThisDisplay` passes on every supported product.
- **Storage drops the grouped dictionaries** ADR-003 introduced. `_set` wrote every value twice — flat key *and* a `hero_daily`/`hero_profile` group dict — and `readNumber` read the dict first with a flat fallback, so the second copy was never the answer to anything. Flat keys stay the format (spellings unchanged, ADR-003), `SCHEMA_VERSION` stays 3 because nothing on disk changes, and `migrateFlatStateToDictionaries` plus the pre-grouping calibration key reader go with it. Calibration keeps its own `hero_calibration` dictionary — that one holds real per-exercise structure.
- **Exercise storage keys derive from one mapping.** `keyFor` and `creditKeyFor` are `"hero_" +` / `"hero_credit_" +` `exerciseKeyString(exercise)`, which is now the single place an unknown exercise throws instead of silently writing SQUATS state.
- **One text-fit helper.** `HeroSetDraw.fits/firstFitting/largestFont` take a radius and a margin instead of existing twice, once against the display and once (`*Within`) against the dashboard's content circle. Call sites pass `layout.displayRadius(), layout.textMargin()` or `layout.contentRadius(), 0`; the arithmetic is unchanged, so no device needed re-checking by eye.
- **One exit menu.** `HeroSetExitMenuDelegate` owns Save / Discard / stay and the ADR-024 pop counts; the workout and picker versions are ~15-line subclasses overriding `save()`. Inheritance rather than a stored `Lang.Method`, because indirect binding has failed silently on device before (ADR-023) and this is the save path.
- **`configKeepsMissionAndSensorContracts` deleted**: it asserted each tunable equalled its own literal, so deliberately retuning a constant "failed" it.
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

