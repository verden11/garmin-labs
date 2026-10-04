# HeroSet decision log (ADRs)

Every durable design decision, newest last. [`architecture.md`](architecture.md) describe how app built *now*; this file explain *why*. Add new ADR at end for any decision future contributor would otherwise re-litigate. Mark old ADRs **Superseded** or **Amended**, never delete.

Numbers 009 and 015 never recorded.

## Read these first

If only read five: **[ADR-002](#adr-002)** (XP can't be farmed), **[ADR-018](#adr-018)** (measure text, never guess), **[ADR-022](#adr-022)/[023](#adr-023)** (device-only crashes simulator can't show), **[ADR-024](#adr-024)** (navigation depth invariant: wrong pop counts exit app).

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
| 029 | Button rules: no long-press, bezel names | Active, amended by 048 |
| 030 | Sync diagnostics + empty-session guard | Superseded by 043 (its device result still stands) |
| 031 | Dashboard redesign + rank curve | Active |
| 032 | Rep detector follows tilt (push-ups, sit-ups) or height (squats) | Active, **unvalidated on the watch** |
| 033 | v1 store build: calibration in, Connect sync out, no `Fit` permission | Active, sync clause amended by 043 |
| 034 | Wave 1: 16 round AMOLED five-button watches; per-device screen-fit test | Active, **simulator-verified except FR965**, amended by 051 |
| 035 | Wave 2: 18 round MIP watches (fēnix 7/8 Solar/9 Pro Solar, FR255/955, Enduro 3) | Active, **simulator-verified** |
| 036 | Storage writes flat keys only; shared fit/exit-menu helpers | Active, amends 003 |
| 037 | Wave 3: 16 more round AMOLED five-button watches | Active, **simulator-verified**, amended by 038 |
| 038 | Wave 4: `minApiLevel` 3.4.0, 17 fēnix 6 / MARQ Gen 1 / Descent MK2 / FR945 LTE / Enduro watches | Active, **simulator-verified** |
| 039 | First paid submission lists all 67 products; no in-app trial for v1 | Active |
| 040 | Thresholds learned from saved counts; calibration screen removed; no position gating | Active, **simulator-verified**, amends 032/033 |
| 043 | Connect sync: one activity per workout, one lap per set with exercise + reps | Shelved, see 054 |
| 048 | Wave 5: 13 touch-first round watches (Venu 2/3/4, vívoactive 5/6, Approach S50/S70, D2 Air X10); swipe adjusts, only START commits | Active, **simulator-verified**, amends 029 |
| 049 | Long translations on 360 px: dashboard drops `DONE` word, titles move down | Active, **simulator-verified**, fixes live 1.1.0 |
| 050 | Owner calls after the 2026-09-24 review: Back gate on the saveable count, swipe up = +1 kept, exit-menu order kept, next upload is 1.1.1 | Active |
| 051 | App glance: read-only, `(:glance)`-scoped, 63 of 80 watches; lazy `HeroSetApp`; publish point moves to `getInitialView` | Active; simulator-verified only |
| 052 | Recoverable workout draft: checkpoint the in-progress rep count so the glance-launch idle-kill (E1) doesn't lose it | Active; FR965 device test still owed |
| 053 | Glance upload submitted as 1.2.0, not 1.1.2; Connect sync moves to 1.3.0 | Active |
| 054 | Connect sync shelved: Connect's UI never renders developer lap/session fields; two device bugs found (stray recording on exit, discard still lapping) | Active, amends 043 |
| 055 | Instinct family (semi-octagon, 1-bit, subscreen window): keep-out layout, black-and-white palette, XP gauge in the window; Instinct 2 / 2S / 2X, Descent G1, Instinct E, Instinct 3 Solar | **Proposed**, simulator evidence only, look approved 2026-10-03 |

---

### <a id="adr-001"></a>ADR-001: Local calendar day key
`HeroSetCalendar.todayKey()` = `year*10000 + month*100 + day` from local clock (`Gregorian.info`). Never epoch/86400 math: DST days 23 or 25 hours, so "same day" / "next day" must compare calendar dates.

### <a id="adr-002"></a>ADR-002: XP only for net stored progress. **Amended by [ADR-045](#adr-045)**
2 XP per rep (`XP_PER_REP`), credited against per-exercise daily ratchet capped at `XP_DAILY_CAP_REPS` (100 reps — the goal used to be the cap, until the goal became user-set). `add(+10)` then `add(-10)` pays once; reps past 100 pay nothing. Max 600 XP a day. Rank and streak build on this → never award XP from raw input amounts.

### <a id="adr-003"></a>ADR-003: Schema-versioned storage. **Amended by [ADR-032](#adr-032)**
`hero_schema` (3). Flat `hero_*` keys: their spelling must never change. The grouped dictionaries this ADR added were removed by [ADR-036](#adr-036).

### <a id="adr-004"></a>ADR-004: Magnitude rep detector. **Superseded by [ADR-032](#adr-032)**
Gravity-removed acceleration magnitude, calibrated thresholds. Blind to wrist rotation; failed on the watch.

### <a id="adr-005"></a>ADR-005: 25 Hz, one stream
Counting and calibration use same 25 Hz listener → calibrated thresholds match what counter sees.

### <a id="adr-006"></a>ADR-006: Shared layout layer
All geometry from `HeroSetLayout` (round-chord insets, bands, ring). Views never compute raw pixels.

### <a id="adr-007"></a>ADR-007: Workout Back Yes/No dialog. **Superseded by [ADR-028](#adr-028)**
Couldn't express "discard".

### <a id="adr-008"></a>ADR-008: Calibration hidden from the release build. **Superseded by [ADR-033](#adr-033)**
Origin of the `store.jungle` + `resources-store/` menu overlay.

### <a id="adr-010"></a>ADR-010: Storage write failures
`Storage.setValue` wrapped in try/catch (any exception, `StorageFullException` being the expected one; logged with `println`); app keeps running, dashboard footer shows `! COULD NOT SAVE`. The flag is sticky for the rest of the save: a later successful write can't clear it, only the next save that writes cleanly (2026-09-24, `aFailedWriteStaysFlaggedThroughTheRestOfTheSave`).

### <a id="adr-011"></a>ADR-011: No `SensorLogging` permission
Not requested until raw sensor export actually built.

### <a id="adr-012"></a>ADR-012: Dashboard day refresh
`HeroSetDayTracker` checks every `DAY_CHECK_INTERVAL_MS` (60 s) while dashboard visible, redraws when local day changes → counts reset at midnight without relaunch.

### <a id="adr-013"></a>ADR-013: One class per file
Filename = class name, `HeroSet` prefix everywhere (Monkey C has no modules). Test files may hold small test-only helper classes.

### <a id="adr-014"></a>ADR-014: Tests
`(:test)` functions live in `source/test/`, excluded from normal builds, run with `monkeyc -t` + `monkeydo … -t` ([`development.md`](development.md)).

### <a id="adr-016"></a>ADR-016: One FIT activity per set. **Superseded by [ADR-021](#adr-021)**
Cluttered the Connect/Strava feed.

### <a id="adr-017"></a>ADR-017: Manual entry picker. **Amended by 028, 029**
`HeroSetManualPickerView` edits signed delta with Up/Down instead of `+1/+5/+10` menu. Now: exactly ±1 per press (029), Back opens Save/Discard/Keep Editing (028).

### <a id="adr-018"></a>ADR-018: Measure text, never guess
Fit decided by `dc.getTextWidthInPixels` against round chord (`HeroSetLayout.fitCenteredY`, `HeroSetDraw`), falling back to shorter wording or smaller fonts. "Safe character count" clips unpredictably by font/device.

### <a id="adr-019"></a>ADR-019: Narrow stored numbers
Storage returns `Object` (Number *or* Float). Read through `asNumber`/`asNumberOrNull` (`instanceof` narrowing); `.toNumber()` on `Object` fails to compile on current SDK.

### <a id="adr-020"></a>ADR-020: `HeroSetStore` size. **Open debt**
472 lines (2026-09-17), ~340 after calibration was removed ([ADR-040](#adr-040)), against 250-line budget. Natural splits now: learning state, diagnostics log. Deferred because it guards real user data: do it with store test suite green *and* device upgrade check (go-to-market gate 4), not as drive-by.

### <a id="adr-021"></a>ADR-021: Workout metrics without a FIT session
Live HR from `Sensor.getInfo().heartRate`; calories = change in `ActivityMonitor.getInfo().calories` (Garmin whole-day total) since set started. No Training Effect/Load, accepted. (`Fit` permission came back for [ADR-025](#adr-025) sync only; readouts still don't use a session.)

### <a id="adr-022"></a>ADR-022: Device-only crashes (lesson)
Found in `CIQ_LOG.YAML` from real FR965; simulator never reproduced them.
1. `Storage.setValue` throws on **Symbol** dictionary keys/values: calibration dictionary keyed by exercise *strings* (`exerciseKeyString`). Guarded by `learningDictionaryUsesStringKeysNotSymbols` (the calibration dictionary it once guarded became the learning dictionary, [ADR-040](#adr-040)), and since 2026-09-24 at compile time: the storage seam takes `Storage.ValueType`, which excludes Symbol.
2. `as Lang.Array` cast on firmware-built accelerometer arrays throws. Read `x/y/z` untyped, guard with `instanceof Array`, index directly.

### <a id="adr-023"></a>ADR-023: Sensor listener binding (lesson)
`registerSensorDataListener(self.onSensorData, …)` registers fine but **never dispatched** on FR965 firmware (simulator dispatches it). Use `method(:onSensorData)` with `public` method, like SDK PitchCounter sample. Found by `git bisect` on device, using persisted breadcrumbs (technique in [`development.md`](development.md)).

### <a id="adr-024"></a>ADR-024: Finish → picker; depth-1 invariant. **Amended by 028**
No pause/resume. START (Finish) opens manual picker seeded with detected count → correcting miscount reuses one UI. **Invariant:** every caller pops its own view *before* pushing picker, so picker always sits directly on dashboard. Save/Discard paths pop fixed count; break invariant and they either strand a view or pop past root, which **exits the app**. Save feedback centralized in `HeroSetSaveFeedback`.

### <a id="adr-025"></a>ADR-025: Opt-in sync, one session per day. **Superseded by [ADR-043](#adr-043)**
Relied on a session surviving app close; it doesn't ([ADR-030](#adr-030)).

### <a id="adr-026"></a>ADR-026: On-watch validation log (dev build)
No reliable way to pull app data off this FR965 → workout-seeded saves log `mmdd EX detected->saved error` into capped ring buffer (`VALIDATION_LOG_MAX_ENTRIES` = 30, flat key, no schema bump). Read via dev menu → Validation Log; transcribe into [`validation-log.md`](validation-log.md).

### <a id="adr-027"></a>ADR-027: `Menu2` main menu; sync toggle. **Amended by [ADR-033](#adr-033), [ADR-043](#adr-043)**
Main menu is `Menu2` so Connect Sync is `ToggleMenuItem` with visible On/Off; no confirmation. Resource toggles static → `HeroSetMenuDelegate.prepare` stamps live state before pushing. `Menu2` never pops itself: every handler pops explicitly. Turning sync off saves day's session and clears stored session day.

### <a id="adr-028"></a>ADR-028: UX pass
- **Back action menus** replace Yes/No: workout `Resume/Save/Discard`, picker `Save/Discard/Keep Editing`. Leaving pops 2, resuming pops 1 (relies on [ADR-024](#adr-024)).
- **Menu shortcut:** Start items show `42/100`/`DONE`; focus lands on first unfinished exercise.
- **Feedback tiers:** mission complete (toast + 3 pulses) > exercise done (+2) > `+N SAVED`; in-set rep that crosses goal pulses twice.
- **Honest calibration:** manual stop can't succeed (10 cycles auto-finish), so it reads `STOP`; rejections say `ONLY n/10 REPS` or `WEAK SIGNAL`.
- Picker delta clamped at `-storedCount`; workout redraws at 1 Hz; all text in `strings.xml` via `HeroSetText`; hints light gray for contrast.

### <a id="adr-029"></a>ADR-029: Button rules. **Amended by [ADR-048](#adr-048)**
- **No long-press gestures:** holding button opens watch shortcuts on FR965. Picker is ±1 per press, calibration ignores Menu.
- **Hints use bezel names:** `START`, `UP/DOWN`, never `SELECT`/`DN`.
- **Sync label** is `Connect Sync` so toggle switch doesn't cut it off.

### <a id="adr-030"></a>ADR-030: Sync diagnostics for the per-day session. **Superseded by [ADR-043](#adr-043)**
Added `SYNC …` lines to the validation log. **Device result that still stands (2026-09-16):** after reopening, the day's session was gone (`SYNC LOST`) and Connect had two HeroSet activities HeroSet never saved → the watch saves an unfinished recording when the app closes.

### <a id="adr-031"></a>ADR-031: Dashboard redesign + rank curve
- **Rank curve:** flat 100 XP/rank gave +6 ranks per full day. Now rank r→r+1 costs `300 × min(r, 14)` XP: rank 10 ≈ 3 weeks, then 1 rank per full week. Rank derived, never stored → no migration.
- **Home screen:** gold XP ring on bezel, `RANK N` + `N XP TO RANK M`, thick mission bars (blue in progress, green + `DONE` label when done), streak line, footer.
- **Honest streak:** `HeroSetRules.activeStreak` shows 0 once a day missed.
- **Palette:** `HeroSetPalette` roles: gold = kept progress, blue = today's effort, green = done, gray = secondary, red = alert. State never relies on color alone.

### <a id="adr-032"></a>ADR-032: Rep detector follows tilt or height. **Unvalidated on the watch**
[ADR-004](#adr-004) detector failed first watch trials (push-ups 4/10, squats 19/10). Physically shaped fixtures (`HeroSetMotionFixture`: real tempos, holds, still lead-in) reproduced both in simulator: 0/10 push-ups and sit-ups, 19/10 squats. Two causes:
- **Magnitude is blind to rotation.** Planted-hand push-up or sit-up mostly tilts wrist → acceleration strength unchanged.
- **State machine counted half-reps.** Squat braking and push-up are same-sign lobes; with pause at bottom each completed its own "cycle".

New detector (`HeroSetRepCounter`), one rep per **full** swing (past +arm, then past -release, or reverse), at least `SENSOR_COOLDOWN_MS` (250 ms) between the two sides:
- **Push-ups, sit-ups:** smooth each axis, subtract ~2 s per-axis baseline, project onto principal axis of deviation (Oja's rule, seeded by first clear movement). Signed, independent of how watch worn.
- **Squats:** strength minus its baseline, integrated twice with ~1 s leaks → approximates height. Velocity tried first but shrinks with tempo, so squats calibrated fast counted 0/10 slow ones.
- **Calibration** fits 25% of mean swing, floored at calibration thresholds → rep that counted while calibrating can count again.
- **Stored profiles** carry `model = 2`; anything else (including every profile fitted by old detector) reads as uncalibrated.

**Known limit:** leaky double integral swings back past zero after any single movement (about 25–80% of the swing), so one isolated up or down movement — standing up from a kneel mid-set — can count as rep. Within a set the swing-back merges with next movement, no harm.

Tests: every exercise at four tempos (0.6 s to 2 s per movement), slowing reps, calibrating fast or slow then repping at every tempo, still wrist for 60 s, a knock, slow posture drift. Filter constants tuned on those fixtures only, not on watch recordings, so **launch gate 2 still needs the on-watch trials** ([`validation-log.md`](validation-log.md)).

### <a id="adr-033"></a>ADR-033: v1 store build: calibration in, Connect sync out
Decided 2026-09-17 to publish sooner.
- **Connect sync is dev-build only.** Watch saved more than one activity a day ([ADR-030](#adr-030)), fix not agreed. `HeroSetSyncCoordinator` and `HeroSetActivitySync` annotated `(:sync)`; store build excludes them and compiles `(:nosync)` no-op classes of same names → callers don't branch. `store.jungle` uses `manifest-store.xml`, identical to `manifest.xml` except **no `Fit` permission** → nothing in store build can record activity. Both manifests must keep same app id. Store menu has no sync toggle; `HeroSetMenuDelegate.prepare` guards missing item, since `getItem(-1)` would run on every menu open.
- **Calibration ships in the store build** (Phase 1 option A). Without it release auto-counted with default thresholds and no way to tune them. Validation Log stays dev-only.
- **New app id** `568d5c9b-eb10-4678-bf28-0080c3efbbc1`, since test uploads used up old one. Dev build sideloaded under old id is separate app on watch, own storage.

### <a id="adr-034"></a>ADR-034: Wave-1 devices and a per-device screen-fit test. **Amended by [ADR-051](#adr-051)** (`ui/glance/` draws its own text)
- **Products:** 16 watches matching FR965 hardware shape: round AMOLED, five buttons, Connect IQ 5.2+, 100 Hz accelerometer, 786 KB app memory (Forerunner 165/265/570/965/970, epix Gen 2 and Pro, fēnix 8 AMOLED, fēnix E). List and exclusions: [`compatibility.md`](compatibility.md). Two-button touch watches, MIP screens, Instinct cut-out screens left for later waves — they need input, palette or layout work, not just manifest entry.
- **Screen-fit test:** all view text goes through `HeroSetDraw.text`, which — while `HeroSetDraw.misfits` set (tests only; null in app) — records text boxes outside round display and every box drawn. `everyScreenFitsThisDisplay` swaps in seeded in-memory store (`HeroSetApp.swapStoreForTest`; this and `HeroSetWorkoutView.setCountsForTest` are `(:debug)`, since runner would execute a `(:test)` method as a test, and release exports strip them), renders every screen in widest state (3-digit counts, full log page, RANK 999…) onto bitmap of device size, asserts no clipping and no overlapping text boxes per screen. Running suite in each product's simulator checks that product's real fonts. It found real clipping and overlap, FR965 included; affected screens now stack rows by measured font height.
- **Launcher icon:** one 65 px SVG; compiler scales it to 54/60 px on smaller products (build warning, expected).
- **Test hooks** are `(:debug)`, and `store.jungle` excludes `debug` as well as `sync`: without that they compiled into non-release store build. Screen-fit test and harness carry `(:test :debug)` → store-build test run skips them (counts differ between the two runs; current numbers in [`development.md`](development.md)).
- **Fonts differ inside a family:** `fr965` and `fr970` are same 454 px round AMOLED product family with different font metrics → every product gets own simulator run, not one per family.
- **Limit:** only FR965 used on real watch. Boxes use full font height → test judges clipping and overlap only, not visual balance. `HeroSetDraw.misfits`/`boxes` ship in release build as inert statics.

### <a id="adr-035"></a>ADR-035: Wave 2 — round MIP watches
18 more products (fēnix 7 and 7 Pro in all three sizes, fēnix 8 Solar, fēnix 9 Pro Solar, Forerunner 255 and 955, Enduro 3), taking both manifests to 34. Chosen over other excluded groups because they needed no code change, only verification:
- **Color:** MIP panels 8 bits per pixel against AMOLED 16, but `HeroSetPalette` already uses Garmin 64-color palette (every channel 00, 55, AA or FF) → no role color quantized into another.
- **Size:** 218–280 px against 360–454 px. Proportional layout and measured text fit absorbed it; `everyScreenFitsThisDisplay` passes on all 18, including 218 px `fr255s`, which also has smallest app memory (512 KB).
- Screen-fit test gained minimum-rows-per-screen assertion first, since screen that drew nothing would otherwise pass clipping and overlap checks.

Still excluded, and why, in [`compatibility.md`](compatibility.md): touch-first watches need different input model ([ADR-029](#adr-029)), Instinct needs sub-window layout, square products need untested rectangle path. **MIP contrast in daylight is unverified** — no MIP watch used on a wrist here.

### <a id="adr-036"></a>ADR-036: Storage writes flat keys only; one fit helper, one exit menu
Repo-wide simplification pass (2026-09-18), no behaviour change.
- **Storage drops the grouped dictionaries** [ADR-003](#adr-003) introduced. `_set` wrote every value twice — flat key *and* a `hero_daily`/`hero_profile` group dict — and `readNumber` read the dict first with a flat fallback, so the second copy was never the answer to anything. Flat keys stay the format (spellings unchanged, [ADR-003](#adr-003)), `SCHEMA_VERSION` stays 3 because nothing on disk changes, and `migrateFlatStateToDictionaries` plus the pre-grouping calibration key reader go with it. Calibration keeps its own `hero_calibration` dictionary — that one holds real per-exercise structure.
- **Exercise storage keys derive from one mapping.** `keyFor` and `creditKeyFor` are `"hero_" +` / `"hero_credit_" +` `exerciseKeyString(exercise)`, which is now the single place an unknown exercise throws instead of silently writing SQUATS state.
- **One text-fit helper.** `HeroSetDraw.fits/firstFitting/largestFont` take a radius and a margin instead of existing twice, once against the display and once (`*Within`) against the dashboard's content circle. Call sites pass `layout.displayRadius(), layout.textMargin()` or `layout.contentRadius(), 0`; the arithmetic is unchanged, so no device needed re-checking by eye.
- **One exit menu.** `HeroSetExitMenuDelegate` owns Save / Discard / stay and the [ADR-024](#adr-024) pop counts; the workout and picker versions are ~15-line subclasses overriding `save()`. Inheritance rather than a stored `Lang.Method`, because indirect binding has failed silently on device before ([ADR-023](#adr-023)) and this is the save path.
- **Connect sync was audited as removable and deliberately kept.** It ships in no store build already (`excludeAnnotations = sync`), so deleting it would have saved nothing at runtime, and sync is wanted in the near future ([ADR-030](#adr-030)'s one-activity-per-day bug is the real blocker, not the code).

### <a id="adr-037"></a>ADR-037: Wave 3 — 16 more round AMOLED five-button watches
Takes both manifests to 50 products. Same selection rule as [ADR-034](#adr-034): identical input model to FR965 (`enter, up, menu, down, esc`), round AMOLED, Connect IQ 5.1+, 768 KB app memory, so no code changed — only manifest entries and verification.
- **Products:** fēnix 9 and 9 Pro AMOLED (`fenix943mm`, `fenix947mm`, `fenix9pro43mm`, `fenix9pro47mm`, `fenix9pro51mm`), MARQ Gen 2 (`marq2`, `marq2aviator`), D2 Mach (`d2mach1`, `d2mach2`, `d2mach2pro`), Descent (`descentmk343mm`, `descentmk351mm`, `descentg2`), Forerunner 170 (`fr170`, `fr170m`) and Forerunner 70 (`fr70`).
- **New screen size:** `fenix9pro51mm` is 466 px, the first `round-466x466` family here. The proportional layout absorbed it; `everyScreenFitsThisDisplay` passes.
- **Still excluded** for the same reasons as before ([`compatibility.md`](compatibility.md)): Approach, Venu and vívoactive expose no UP/DOWN keys, so the button-first picker and hints ([ADR-029](#adr-029)) do not apply; Instinct has the sub-window cut-out; square products are untested. Devices below Connect IQ 4.2 stay out (amended by [ADR-038](#adr-038): minimum now 3.4).
- **Limit:** unchanged from [ADR-034](#adr-034)/[035](#adr-035) — FR965 is still the only watch used on a wrist.

### <a id="adr-038"></a>ADR-038: Wave 4 — minimum API lowered to 3.4.0
`minApiLevel` 4.2.0 → 3.4.0 in both manifests, adding 17 five-button round MIP watches (67 products): fēnix 6 / 6S / 6 Pro / 6S Pro / 6X Pro, MARQ Gen 1 (8 editions), Descent MK2 / MK2S, Forerunner 945 LTE, Enduro (Gen 1). 4.2.0 was never a deliberate requirement — no earlier ADR relied on it.
- **API check:** every Toybox member the app uses (outside tests) is listed in each 3.4 device's `api.debug.xml` symbol table. `monkeyc` does not check this per device — even at `-l 3` it compiled a 4.0-only call for a 3.4 product — so the symbol table and a simulator run are the evidence, not a clean build.
- **Only test code changed:** `everyScreenFitsThisDisplay` used `Graphics.createBufferedBitmap` (4.0+); it now falls back to `new Graphics.BufferedBitmap` behind a `has` check.
- **Memory:** `fenix6`, `fenix6s`, `enduro` give watch apps 128 KB. Store build measured with `System.getSystemStats()` in the simulator: ~52 KB on the dashboard, ~54 KB peak in a workout, ~73 KB free. The test runner gets 8 MB regardless of device, so a passing suite says nothing about memory.
- **Verification:** store build compiles and the full suite (81 tests, including screen fit) passes on all 17.
- **Why not lower:** below 3.4 `WatchUi.showToast` is missing, so the save confirmation would crash; ≤3.1 also lacks `SENSOR_ONBOARD_HEARTRATE`. With a `has :showToast` guard FR945, FR745 and FR245M (3.3) pass the suite, but a guard alone leaves them with no visible save confirmation, and fēnix 5 Plus (240 px) fails screen fit — older firmware fonts run larger. That wave needs a replacement confirmation and per-device checks. Forerunner 55 (3.4, 208 px) fails screen fit and stays out.
- **Limit:** unchanged — FR945 LTE lacks a `maxAccelRate` entry in its SDK profile (app samples at 25 Hz, which every accelerometer device supports), and no wave 4 watch has been used on a wrist.

### <a id="adr-039"></a>ADR-039: First paid submission lists all 67 products; no in-app trial
Decided 2026-09-18 (user call on [`go-to-market.md`](status.md) open item 0).
- **Products:** submit every product in both manifests, not a short FR965-first list. More buyers day one; accepted risk is that the store ([`listing/paste.md`](../listing/paste.md)) asks for every listed product to be tested and only FR965 was on a wrist. Listing and support page say the other 66 are simulator-verified ([`release-contract.md`](release-contract.md) forbidden claims unchanged). Beta testers per family (status item 6) stay wanted but no longer gate launch; a watch family that misbehaves in the field gets removed from both manifests in an update.
- **Trial:** wanted a 3-day trial, but Garmin's paid-app monetization documents none; its 48-hour return window is the only built-in try-before-keep. The SDK's `iq:trialMode` (`AppBase.isTrial`, `getTrialDaysRemaining`) predates it and unlocks through a developer-run HTTPS unlock URL with an OAuth1 callback — a payment backend of our own, which is the opposite of selling through Garmin. v1 ships paid with no trial. Revisit only if Garmin documents trials for monetized apps (ask on the developer forum before a later release).
- **Screenshots:** listing images come from the simulator running the store build (still the real build, no mockups), not from the watch.

### <a id="adr-040"></a>ADR-040: Thresholds learned from saved counts; calibration removed. **Amended by [ADR-046](#adr-046)**
Decided 2026-09-19 after the first FR965 trials of the [ADR-032](#adr-032) detector ([`validation-log.md`](validation-log.md), 2026-09-18): counting mostly right (median error 0.5), but +1/+2 from getting up after push-ups, fast squats missing reps, and phantom reps from arm movement outside the exercise.
- **Learning replaces calibration.** Every saved workout set teaches the detector. During the set `HeroSetSwingTrace` keeps each turning point of the detector signal (reversals under `TRACE_HYSTERESIS` dropped, capped at `TRACE_MAX_POINTS`, memory only). When the picker saves, `HeroSetThresholdLearner` replays the trace at 24 log-spaced thresholds and updates a belief over them: likelihood falls with how far each replay lands from the saved count (tolerance 10% of it, floor so one mistyped count can't overturn agreeing sets), and each set keeps 85% of the old belief and resets the rest toward a log-normal prior around the old default, so roughly the last 6–7 sets decide and a form change is followed. The threshold used is the belief's median: the middle of whichever range fits, the most margin either way. Sets the movement can't explain (more reps saved than swings at the lowest threshold, plus slack) teach nothing. Only the belief (48 numbers per exercise, `hero_learning`) is stored.
- **Why not averaging corrections, or a PID loop.** The count is a staircase in the threshold, so feedback control hunts between steps, and an integral term would chase the getting-up rep by raising the threshold until real reps were lost. Replay says exactly which thresholds would have been right, so there is nothing to estimate by trial and error.
- **Getting up is learned, not thresholded.** The belief has a second half: "this user's last counted rep is getting up, drop it". Getting up is usually the biggest swing of a set, so no threshold removes it alone and the threshold-only fit lands somewhere different every set; the drop hypothesis fits consistently and wins within a few sets. The live screen still shows every detected rep; the picker seed and quick-save use the dropped count.
- **Calibration removed** from both builds: screen, menu entry, 15 strings in 15 languages, `HeroSetCalibration`. Old `hero_calibration` profiles are no longer read. Detector takes one threshold (arm = release). Learning starts at `DEFAULT_THRESHOLD`; the first sets count as the default detector did.
- **No position gating (user call).** Users start a set when in position; arm movement before or between sets is on them. So the gate 2 idle check means 60 s still in exercise position, not 60 s of everyday arm movement (which counted 14 push-ups on 2026-09-18 and is what gating would have fixed).
- **Quick-save (Back → Save) doesn't learn**: the user didn't review the count, so it says nothing about the right one.
- **Limit:** every behaviour above is proven on synthetic traces (`HeroSetThresholdLearnerTest`), not on wrists. ~~Worst-case learning (the longest accepted trace) took ~55 ms in the simulator on fr965 and fenix6; device time unmeasured.~~ It took 181 ms, tripped the watchdog on a real FR965, and the replay is now streamed ([ADR-046](#adr-046)).

### <a id="adr-041"></a>ADR-041: Rank-up feedback; live count in effort blue
Decided 2026-09-19 after an Impeccable critique of the watch UI (`.impeccable/critique/`).
- **Rank-up is the top save tier.** The XP ring restarts empty at each rank ([ADR-031](#adr-031)), so without a signal the payoff read as a loss. `HeroSetSaveFeedback.save` snapshots rank before and after `store.add` and shows `RANK N!` with four pulses (`HeroSetHaptics.rankUp`). Tier order: mission complete → rank up → exercise done → saved/removed. Mission complete stays first: it is the once-a-day peak and the save most likely to also cross a rank, and a second toast would only replace the first (`HeroSetSaveFeedbackTest`). Rank stays derived, never stored. A full-ring flourish on the next dashboard was considered and skipped: it needs cross-screen state for a one-frame effect.
- **Every save path goes through `HeroSetSaveFeedback.save`**, so no caller can miss a before/after snapshot.
- **Live count and positive picker delta use `EFFORT`, not gold/green.** Gold means kept (rank, XP, streak), green means a goal met; reps not yet saved are effort. Workout, picker and validation log now use `HeroSetPalette` roles only (no raw `Graphics.COLOR_*`).
- **`EFFORT` 0x00AAFF → 0x55AAFF**: blue bar fill on `TRACK` was 2.91:1, now 3.05:1; still MIP-safe.
- **Picker shows `DETECTED 24 (-1)`** when the learned getting-up rep ([ADR-040](#adr-040)) is dropped, instead of a bare 23 right after the workout showed 24. The validation log still records the dropped count.
- **Screen titles shrink to fit** (`HeroSetDraw.title`, SMALL → TINY → XTINY) on workout and picker too; long translations (Dutch `BUIKSPIEROEFENINGEN`) clipped at fixed `FONT_SMALL`.

### <a id="adr-042"></a>ADR-042: Paid launch before full gate 2 measurement. **Amended 2026-09-21 ([ADR-047](#adr-047))**
Decided 2026-09-19 (user call) after the first learning-build session on FR965: 4 medium-pace 10-rep sets counted +2/0/0/0 (push-ups 12 then 10, squats 10, sit-ups 10), every save returned to the dashboard.
- **Ship paid now, measure after.** Slow/fast sets, the 60 s idle-in-position check, a 30+ rep set and the store build sideload were not run. The listing already makes no accuracy claim: it says the count can be off, each set is reviewed before save, and the count can be corrected (no "beta" in public copy, [`release-contract.md`](release-contract.md)), so a miscount costs a button press, not stored progress ([ADR-002](#adr-002)).
- **Known risks carried into launch:** fast squats undercounted on the calibrated detector (2026-09-18, −7/−2); push-up getting-up rep only seen dropped once; learning time on a long trace unmeasured on device (~55 ms in simulator, [ADR-040](#adr-040)).
- **Amended 2026-09-21 (with [ADR-047](#adr-047)):** the validation log was cleared and the FR965 fresh-installed, so every row above is gone — it mixed three detector eras on a learner trained by those same sets. The detector is unchanged and stays unchanged for 1.1.0 ([ADR-046](#adr-046) only rounded the learner's candidate thresholds to integers, ≤ 1.5% of a step): accuracy work is a **1.1.1** item, taken up only if buyers report it. **Gate 2 for 1.1.0 is crash-only**: one 30+ rep set saved on the watch without a `Watchdog Tripped Error`, proving [ADR-046](#adr-046) on device. The old data's findings, kept because they still name where to look first: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, sit-ups clean.
- **Amends** [`go-to-market.md`](status.md) Phase 1 "accuracy validation method" and the [`release-contract.md`](release-contract.md) release decision: gate 2 becomes a post-launch check; a failure is fixed in an update, and the listing is rewritten manual-first if counting can't be defended as beta.

### <a id="adr-043"></a>ADR-043: Connect sync: one activity per workout, laps per set. **Shelved, [ADR-054](#adr-054)** (was scheduled for 1.3.0, [ADR-047](#adr-047), renumbered by [ADR-053](#adr-053))
Decided 2026-09-19 (user call); full reasoning and platform limits in [`connect-sync-plan.md`](archive/connect-sync-plan.md).
- **A day can't be merged into one activity.** A Connect IQ session records live only (no backdating), doesn't survive the app closing ([ADR-030](#adr-030)'s device result), can't run in a 30 s background service, and no Garmin API accepts a finished activity from outside. So the unit is one HeroSet **visit**. The user is fine with several activities a day and mutes Strava noise on Strava's side.
- **Behavior (sync On):** a visit's first workout set opens a `SPORT_TRAINING`/`STRENGTH_TRAINING` session; the timer runs only while a set screen is up. Each set is one lap, closed when the next set begins, carrying FIT developer fields `Exercise` (string) and `Reps`; session fields hold push-up/sit-up/squat totals. Only workout-seeded saves count (same boundary as learning, [ADR-040](#adr-040)); negative corrections count as 0. `AppBase.onStop` always saves (≥ 1 saved rep) or discards, and a refused save is discarded: on a normal exit nothing is left open, which should stop the stray activities of [ADR-030](#adr-030). Negative corrections lower the visit total (lap stays ≥ 0).
- **Setting:** same `Connect Sync` toggle and `hero_sync_enabled` key ([ADR-027](#adr-027)), off by default; sublabels say `Saves to Connect` / `Watch only`. Turning it off mid-visit discards the recording. `hero_sync_day` retired, name never reused ([ADR-003](#adr-003)). FIT field ids 0–4 are fixed forever: they are baked into saved activities.
- **Code:** `HeroSetSyncCoordinator` is now one instance per app (`getApp().getSync()`), `HeroSetActivitySync` is owned by it (its `(:nosync)` twin deleted: nothing outside `(:sync)` code references it). Dev manifest adds `FitContributor`.
- **Still dev-only.** Store build ([ADR-033](#adr-033)) unchanged until the FR965 acceptance in [`connect-sync-plan.md`](archive/connect-sync-plan.md) device acceptance passes; then `Fit` + `FitContributor` go into `manifest-store.xml` and privacy/store copy change the same session.
- **Unverified:** whether Connect (web and phone) shows string lap fields (fallback: three numeric lap fields); that `onStop` covers every exit path (it does **not** run if HeroSet crashes, so a crash mid-visit may still leave a session for the watch to save); where the lap boundary falls when `addLap()` runs right after `start()`; session memory on the 128 KB watches (fēnix 6/6S, Enduro).

### <a id="adr-044"></a>ADR-044: HeroSet publishes today's progress to our own watch face. **Amended 2026-09-24 and by [ADR-051](#adr-051) (publish point)**
Decided 2026-09-20 while building HeroFace, the sibling watch face (`../HeroFace`, its `docs/archive/plan.md`).
- **Complications are the only bridge.** An app's `Storage` is private to that app, so a watch face cannot read HeroSet's counts. Connect IQ's complication publish/subscribe (CIQ 4.2+) is the one supported channel: a device app publishes, and only watch faces may subscribe.
- **Private access, one complication.** `access="private"` limits readers to apps signed with the same developer key, so the data reaches our face and nothing else — not other developers' apps, and not Face It (which is why the resource carries no `faceIt` element). Complication id `0` never changes. **Subscribers find it by its long label `HeroSet`** (`complication_label`, `translatable="false"`; HeroFace `HeroFaceLink`), so that label is part of the contract too.
- **One packed string, not four values.** The value is `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal` (ten fields; `goal` appended by [ADR-045](#adr-045) without a version bump). Every field is a non-negative integer: HeroFace drops the whole value if any field is negative or non-numeric. HeroSet only publishes while it runs, so the face needs the day keys to tell today's counts from yesterday's and to break a streak HeroSet has not yet seen expire. Field order is fixed; new fields go on the end and `v` only changes on a breaking change. `HeroSetComplicationPublisher.valueFor` is pure and unit-tested.
- **Published on every stored change:** app start (since [ADR-051](#adr-051), the first foreground view request in `getInitialView`; `onStart` also runs for the glance and stays empty), every save (`HeroSetSaveFeedback`, the one path all stored counts go through), and midnight while the dashboard is open (`HeroSetDayTracker`).
- **Older watches build without it.** The resource only compiles for products that have the API, so `resources-complications/` is added per product in both jungles for the 50 products at CIQ 4.2+; the 17 at 3.4–4.1 ([ADR-038](#adr-038) wave, e.g. fēnix 6, MARQ Gen 1, Enduro) build without it, and `Toybox has :Complications` makes every publish call a no-op there. Those users' faces fall back to their own everyday goals.
- **Store build publishes too** (unlike Connect sync, [ADR-043](#adr-043)): nothing leaves the watch, it needs no network and no new user-facing claim, and a face that only worked in dev builds could never ship. The `ComplicationPublisher` permission is in both manifests.
- **Verified on FR965 2026-09-20:** the store build sideloaded over an existing install showed **no permission prompt** for `ComplicationPublisher`, and a saved set reached HeroFace within seconds (publish → subscribe → redraw works on real firmware, not just the simulator).
- **Also verified 2026-09-20:** progress survived a watch reboot, on the face and in HeroSet. From outside it cannot be told whether the system kept the published value or HeroFace read back its own cached copy; both are designed to produce this, so the face needs no publish-on-boot from HeroSet.
- **Still unverified:** the midnight publish path in `HeroSetDayTracker`, which only runs once a day.
- **Publishing never crashes the app** (2026-09-24): `updateComplication` throws `OperationNotAllowedException` if a product is listed without the complication resource; the publisher catches exactly that.

### <a id="adr-045"></a>ADR-045: User-set daily goal, fixed XP cap
Decided 2026-09-20 (user call), researched in a plan since deleted (`git log -- HeroSet/docs/configurable-goal-plan.md`). 100 reps suits neither a beginner nor a strong user, so the goal is now the user's; everything about the rank economy stays where it was.
- **On the watch, in `Storage`, not Connect IQ app settings.** `Properties`/`settings.xml` needs the phone app, and a phone-side plus a watch-side value is a sync problem we would be inventing. The app is standalone on all 67 products (min API 3.4.0). One `Daily Goal` item in both menus opens a picker; `hero_goal` holds the value ([ADR-003](#adr-003): spelling fixed — a later per-exercise split adds `hero_goal_pushups` and keeps this as the fallback).
- **A free number, not easy/medium/hard modes.** Every representation persists as the same integer anyway, and mode labels would cost 15 locale files for no mechanical gain. Range 10…500 in steps of 10 (`MIN_MISSION_GOAL`/`MAX_MISSION_GOAL`/`MISSION_GOAL_STEP`); `HeroSetRules.clampGoal` snaps anything read back. Presets and an auto-ramping goal stay possible later, writing the same integer.
- **XP stays pinned to 100 reps per exercise per day** (`XP_DAILY_CAP_REPS`), whatever the goal is. The cap exists to stop sheer volume printing ranks ([ADR-002](#adr-002)), and a cap the user can raise is not a cap: goal 500 would be 3000 XP and a rank a day. So the goal drives bars, done state, mission completion, streak and the complication — **never XP**. Closed doors: cap = goal, or `max(100, goal)`, are the same hole; scaling XP per rep so any goal yields 600 a day would make rank measure consistency, which the streak already measures.
- **Intended, visible consequence:** above goal 100 the XP cap bites before the goal is met; below it, reps past the goal still earn up to 100. A beginner at goal 30 completes the mission daily with the streak climbing while rank moves at about a third speed — correct (a third of the work), and said out loud in [`input-and-ux.md`](input-and-ux.md) and the public copy: **rank reflects reps done, not goals hit**.
- **Streak vs a mid-day goal change, accepted:** lowering the goal completes today at once (that is the feature — `setGoal` re-runs `updateCompletion`), so goal 10 → 30 reps → streak banked → goal back to 500 is possible. It buys a number with no progression behind it, because the XP cap means nothing was earned toward rank. XP measures effort, the streak measures consistency; revoking a banked day would cost more code than the exploit is worth.
- **Domain stays Storage-free:** `crossedGoal`/`missionComplete` take the goal as a trailing argument, `HeroSetDashboardState` carries it, and `HeroSetMissionBars.draw` takes it — never a mutable static, which would also break `HeroSetScreenFitTest` (it draws states without the app's store).
- **Complication ([ADR-044](#adr-044)): `goal` appended as field 10 with `VERSION` left at 1** (the HeroFace side was already written and is verified, not new here). HeroFace drops a value whose version it does not know but ignores a field it does not know, and HeroSet updates first, so a bump would blank the missions on every not-yet-updated face. HeroFace reads field 10 when present and falls back to 100 (also when it is 0, so no bar is ever divided by nothing).

### <a id="adr-046"></a>ADR-046: The set is counted as it runs, not replayed on save. **Ships in 1.1.0 ([ADR-047](#adr-047))**
Decided 2026-09-20 after a `Watchdog Tripped Error - Code Executed Too Long` on a real FR965 (firmware 29.05, CIQ 6.0.2, 11:56 UTC), thrown from `HeroSetThresholdLearner.updated` under `HeroSetManualPickerDelegate.onSelect`. This is the third risk [ADR-042](#adr-042) carried into launch landing: "learning time on a long trace unmeasured on device".
- **The cost was one batch replay in an input callback.** [ADR-040](#adr-040) stored every turning point and, when the picker saved, scanned them once per candidate threshold: 24 × up to 500 points, on top of the two flash writes `saveEntry` already does before learning starts. Measured in the simulator on fr965 at 499 points: **181 ms total, 173 ms of it the replay loop** — 96%. The 48-term belief update is ~1 ms and was never the problem. [ADR-040](#adr-040)'s "~55 ms" was measured on a trace of unknown shape and is withdrawn.
- **`HeroSetSwingTrace` now counts instead of recording.** Each turning point is applied to `LEARN_BINS` running counters (side, last flip, flips) in the sensor callback that produced it — two per rep, spread over the minutes of the set, which is the granularity the watchdog actually measures. `counts()` reads the finished answer in O(bins); the still-open turning point is applied to a copy, so reading never ends the set. `_values`/`_times`/`countAt` are gone. Same numbers, same flip-gap rule, 181 ms → 1 ms.
- **Candidate thresholds are now whole numbers** (`HeroSetThresholdLearner.thresholds()`, memoised). The live detector takes a `Number`, so a replay at bin *k* is only comparable to what the detector counted if the bin is that same integer; rounding 14% steps costs at most 1.5% of a step. It also keeps the grid off the sensor hot path — the old code called `Math.pow` per bin per replay.
- **The overflow cap stays.** Past `TRACE_MAX_POINTS` turning points the counters stop and `isComplete()` is false, so a 4-minute-plus set still teaches nothing. Streaming makes lifting that cap cheap, but lifting it would start feeding long sets into the learner with no device evidence; that is its own decision, not part of a crash fix.
- **Less memory, too.** Per-set state drops from ~500 Floats plus ~500 Numbers to 72 Numbers, which matters on the 64 KB MIP products as much as the latency does on any of them.
- **`longestLearnableSetFinishes` now times and bounds both halves.** The old test ran the exact crashing path and passed, because nothing looked at the number it printed. Streaming moves cost rather than deleting it, so the sensor side is bounded too: on fr965, saving 1–2 ms (was 181 ms) and counting 97 ms for a whole 249-rep set, the latter spread over minutes of 25 Hz callbacks.
- **Not done:** the cheaper fixes were weighed and rejected. Memoising the grid alone saves 8 ms of 181. Moving learning to a `Timer` gives a fresh budget but still one ~0.5–1 s device chunk. Lowering `TRACE_MAX_POINTS` turns the crash into silently-skipped learning on exactly the long sets a 100-rep-a-day app is for.
- **Simulator numbers. Device unproven** until a 30+ rep set is saved on the watch (gate 2).

### <a id="adr-047"></a>ADR-047: 1.0.0 stays published; the crash is fixed forward in 1.1.0. **Carried out — 1.1.0 live 2026-09-21**
Decided 2026-09-21 (user call), the day Garmin approved the 2026-09-19 upload. The approved build is the one [ADR-046](#adr-046) describes: it crashes with `Watchdog Tripped Error` on a reviewing save, and it predates [ADR-044](#adr-044) and [ADR-045](#adr-045). The alternative was to pull or hold the listing until a fixed build cleared review.
- **The listing stays live.** https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 — $1.99, published 2026-09-21. Buyers before 1.1.0 can hit the crash on a save that learns; quick-save (Back → Save) never learns and is unaffected.
- **There is no 1.0.1.** The next submission is **1.1.0** and carries what is already on disk and verifiable in days: [ADR-046](#adr-046)'s crash fix, [ADR-044](#adr-044)'s complication, [ADR-045](#adr-045)'s daily goal. Its permission line gains `ComplicationPublisher`, so it is a full review cycle regardless.
- **Connect sync ([ADR-043](#adr-043)) moves to 1.2.0.** Amended 2026-09-21, same day: sync is gated on an FR965 spike that is still a design fork (string vs numeric lap fields, [`connect-sync-plan.md`](archive/connect-sync-plan.md) step 0) and a ten-item device acceptance, which is weeks. Pinning it to 1.1.0 would hold the crash fix — live on buyers' watches today — behind unrelated feature work. The `Fit`/`FitContributor` permission change and the privacy/support/listing copy it forces ride 1.2.0 together (step 8), so nothing is spent twice.
- **Consequence for HeroFace:** the published HeroSet does not publish the complication, so buyers who own both see everyday mode until 1.1.0 clears review ([`../../HeroFace/docs/status.md`](../../HeroFace/docs/status.md) §2).
- **Consequence for the launch plan:** private beta and announcing the paid launch wait for 1.1.0 — there is no point recruiting testers onto a build with a known crash. Gate 2's 30+ rep set on the watch is still owed before the upload, since [ADR-046](#adr-046)'s 1 ms is simulator only.
- **The version number is not in the repo.** CIQ manifest v3 carries no version attribute; "1.1.0" is typed into the store upload form.
- **Outcome (2026-09-22):** 1.1.0 was uploaded from the 2026-09-21 23:45 `bin/HeroSet-store.iq` and is live, so every consequence above is discharged: the save crash is gone from the shipping app, the complication publishes, the daily goal is real, and the site's `storeUrl` is set. 1.0.0 was exposed to buyers for roughly one day. Next submission is 1.2.0 (Connect sync).

### <a id="adr-048"></a>ADR-048: Wave 5 — touch-first watches; swipe adjusts, only START commits

**Context.** A buyer asked for Venu 4. 13 round products at Connect IQ 4.2+ have no UP/DOWN keys: `venu441mm`, `venu445mm`, `venu3`, `venu3s`, `venu2`, `venu2plus`, `venu2s`, `vivoactive5`, `vivoactive6`, `d2airx10`, `approachs50`, `approachs7042mm`, `approachs7047mm`. Their simulators map swipe up → next page, swipe down → previous page, tap → select, swipe right from the edge → back. The Venu 4 manual names its two buttons START and BACK.

**Decision.**
- **Supported, one build.** Added to both manifests and, since all are CIQ 4.2+, to the complication resource path in both jungles ([ADR-044](#adr-044)).
- **Swipe replaces UP/DOWN.** The pickers already act on page behaviors, so swipes drive them unchanged; the validation log moved from raw `KEY_UP`/`KEY_DOWN` to page behaviors for the same reason. On touch-first products (`DeviceSettings.inputButtons` has no `BUTTON_INPUT_UP`, `HeroSetInput`), swipe up raises the value: under a finger, pushing the screen up reads as "more". Five-button watches are unchanged (UP raises).
- **Commits are START only, on every product.** A tap is also the select behavior, so Finish (workout) and Save (both pickers) now return false from `onSelect` and act in `onKey` on `KEY_ENTER`; taps fall through and do nothing. A palm or wet wrist on the screen mid-set can't end the set, and a stray tap can't save an uncorrected count the detector then learns from ([ADR-040](#adr-040)). The FR965 has a touchscreen too, so this closes the same hole there. The dashboard tap still opens the menu, which is harmless.
- **Hints.** `START:` hints stay (the button is called START). `UP/DOWN:` hints become `SWIPE:` on touch-first products, chosen at runtime so each product's screen-fit run measures its own text. New string ids `picker_hint_adjust_touch`, `validation_log_hint_touch` in every language.
- **Scope of the guard:** the counting and adjust screens only. Native `Menu2` menus (Back's Resume/Save/Discard, the picker exit menu) still select by tap, as all Garmin menus do.
- **Amends [ADR-029](#adr-029) / [`input-and-ux.md`](input-and-ux.md):** "no critical action may require touch" becomes "a tap on the counting or adjust screen never finishes or saves"; adjusting by swipe is the only way on a watch without UP/DOWN.

**Known gaps.**
- Swipe right from the edge is Back. Mid-set that opens the Resume/Save/Discard menu and pauses counting. Nothing is lost, but it interrupts; some devices send it as `KEY_ESC`, so it can't be told apart from the button. Not engineered around until a Venu owner reports it.
- `dashboard_hint` still says `START: MENU` (true); a tap also works.
- Venu 2/3, vívoactive 5 and Approach have a third (menu) button, unused beyond the dashboard's existing `onMenu`.

**Evidence (2026-09-24).** Final state (with [ADR-049](#adr-049) and the review fixes): dev tests 97/97 on all 80 products, and in all 15 languages on venu2s and fr265s; store tests 88/88 on fr965, venu441mm and d2airx10; 98/98 dev on fr965 with the picker-dispatch test added last. `d2airx10`'s simulator maps START to no behavior, so the dashboard also opens the menu from `onKey` (`HeroSetDelegate`). `everyScreenFitsThisDisplay` passes with the `SWIPE:` hints (the test logs `touchFirst=`: true on venu441mm, vivoactive5, venu2s; false on fr965, fenix6, fenix7, enduro; every one of the 67 earlier products has an UP key in its simulator definition). English only: translated `SWIPE:` hints not written by native speakers, and not fit-checked by hand in the widest language (Ukrainian) on the narrowest screen (venu2s, 360 px). **Simulator only:** the tap-guard and swipe direction have not been exercised by hand in the simulator or on any touch-first watch; the FR965 START path after the `onSelect` → `onKey` move needs one on-wrist check.

### <a id="adr-049"></a>ADR-049: Long translations on 360 px — dashboard drops `DONE`, titles move down

**Context.** The per-language screen-fit run ([`development.md`](development.md) asks for it after string changes) had not been repeated on the 360 px products since [ADR-045](#adr-045) widened the count to 500. Done on 2026-09-24 by overlaying each language's strings on the base resources in a scratch jungle (the simulator has no CLI language switch). The live 1.1.0 fails on `fr265s` and `venu2s` in Ukrainian, Danish, Dutch, Finnish, French, Polish and Portuguese: the dashboard's `<EXERCISE> DONE` label overlaps the count (e.g. `ПІДЙОМИ ТУЛУБА ГОТОВО` and `500`), and the Dutch `BUIKSPIEROEFENINGEN` title pokes past the bezel in the top band even at `FONT_XTINY`.

**Decision.**
- **Mission bars:** `countFont` now returns null when no font fits; the rows then use the plain labels. Done still doesn't rely on color: the bar is full and the count is at or over the goal, and the footer reads `MISSION COMPLETE` once all three are.
- **Titles:** `HeroSetDraw.title` steps down 2 px at a time (never past center) until the smallest font fits the chord. Everything under the title stacks from its returned y, so rows below shift, and the fit test still checks them.
- **Workout `TODAY` row** is measured like the picker's (`FONT_TINY` → `FONT_XTINY`) instead of fixed `FONT_TINY`.
- **Shorter translations** where no layout fallback was enough on `fr265s` (checked with `tools/fit-sweep.sh`): Dutch sit-ups `BUIKSPIEROEFENINGEN` → `SIT-UPS` (the common Dutch word; menus and FIT label follow), French squats `FLEXIONS DE JAMBES` → `SQUATS` (likewise), French `AUJOURD'HUI` → `AUJ.`, Portuguese storage warning `! NÃO FOI POSSÍVEL SALVAR` → `! ERRO AO SALVAR` (the wide footer pushed the bars into each other). Not reviewed by native speakers.
- The layout changes are fallbacks: where the old layout fitted, nothing moves.

**Evidence.** See the sweep line in [ADR-048](#adr-048)'s evidence and [`go-to-market.md`](status.md). Simulator fonts are not device fonts.

### <a id="adr-050"></a>ADR-050: Owner calls after the 2026-09-24 review
Decided 2026-09-24 on the review's open items ([`../reports/Verden code quality review.md`](../../reports/archive/Verden%20code%20quality%20review.md)).
- **Back gates on the count Save would bank** (`getCount()`, not the live detected count). A lone rep the learner drops as getting up ([ADR-040](#adr-040)) used to open a `0 reps` menu whose Save banked nothing. Back now just leaves; START still opens the picker at `DETECTED 1 (-1)`, where one press keeps the rep. Banking the dropped rep instead was rejected: it saves what the learner already judged to be getting up. Pinned by `backLeavesWhenTheOnlyRepIsDropped`.
- **Swipe up = +1 on touch-first watches stays** ([ADR-048](#adr-048)); flip only if testers disagree.
- **Exit-menu order stays** (Save first in the picker exit menu, Resume first after a set). On a touchscreen a tap picks whatever it lands on, so order doesn't guard against stray taps; revisit only on a mis-tap report.
- **The next upload is 1.1.1**: it fixes a live bug ([ADR-049](#adr-049)) and adds devices ([ADR-048](#adr-048)) with no new feature. 1.2.0 stays Connect sync ([ADR-043](#adr-043)/[047](#adr-047)).

### <a id="adr-051"></a>ADR-051: App glance: read-only, `(:glance)`-scoped, 63 of 80 watches
Decided 2026-09-26 on the research in [`../../reports/HeroSet glance view research.md`](../../reports/HeroSet%20glance%20view%20research.md) (owner request: "a widget"; idea #1 in [`ideas.md`](ideas.md)). The owner delegated the open calls to the implementer, recorded below; the version label is still the owner's to confirm at upload.

**Context.** Connect IQ 4.0+ lets a watch-app supply a glance: a rectangle in the glance list drawn while the app is not running. Selecting it starts the app (`:launchedFromGlance`, then `getInitialView`). A separate widget app cannot serve this: Storage is private per app ([ADR-044](#adr-044)), and only watch faces can subscribe to a complication. The glance is HeroSet's own second front door.

**Decision.**
- **Content: today's progress, read-only.** One status row over three pill bars in the fixed [ADR-044](#adr-044) order (push-ups, sit-ups, squats). The row is the streak (`N DAY STREAK`, then `STREAK N`, then `NO STREAK YET` at zero), muted while today is open and gold once banked ([ADR-031](#adr-031)); when all three goals are met a drawn check and `MISSION COMPLETE` replace it. A pill turns green and full at goal, so done never rests on colour or a translatable word ([ADR-049](#adr-049)). Words are chosen longest-first by measured width and dropped when none fits. **No hint text** (a "next exercise" line needs a string in 15 unreviewed locales and does not fit 63 px glances; the first pill that is not full already says it) and **no time-of-day streak-at-risk cue** in v1.
- **Never writes.** `HeroSetGlanceReader.read(storage, todayKey)` reads the same flat keys as `HeroSetStore` ([ADR-003](#adr-003)) and constructs nothing that writes. A count saved on an earlier day reads as 0 and the streak comes from the pure `HeroSetRules.activeStreak`, so a glance opened at 00:01 shows zeros without the app having run `ensureCurrentDay`. It reads on every draw.
- **Key spellings are duplicated in the reader** (owner-delegated recommendation) and pinned by `HeroSetGlanceReaderTest`, which compares the reader with a real store on the same storage. A shared key-constants class waits for the store split ([ADR-020](#adr-020)).
- **Glance process rules.** The glance process loads the whole `HeroSetApp` class, so `initialize`, `onStart`, `onStop`, `getGlanceView` and `onUpdate` touch only `(:glance)` code: `HeroSetApp` (and the free function `getApp()`), `HeroSetGlanceReader`, `HeroSetGlanceView`, `HeroSetGlanceLayout`, `HeroSetDashboardState`, `HeroSetStorage`, `HeroSetPersistentStorage`, `HeroSetCalendar`, `HeroSetConfig`, `HeroSetRules`, `HeroSetPalette`. The store and sync coordinator are built lazily by `getStore()`/`getSync()`; `ensureCurrentDay` and the [ADR-044](#adr-044) publish moved from `onStart` into `getInitialView` (same moment for any real launch; `onStart` is empty because it also runs for the glance). `onStop` keeps only the null-guarded `sync.stop()`; it carries `disableGlanceCheck`, so anything added there is not checked.
- **Text is drawn in the glance view, not through `HeroSetDraw.text`/`HeroSetText`.** Both assume the round display and are not `(:glance)`; the view measures with `dc.getTextWidthInPixels` and draws with `dc.drawText`. This is the one place [ADR-034](#adr-034)'s "never `dc.drawText`" does not apply. `HeroSetGlanceLayout` holds the rectangle geometry (pad, pill sizes) as named constants.
- **No background fill.** The system draws the themed card behind a glance; an opaque `dc.clear()` paints over it. Each pill has a 1 px outline drawn outside the bar so the empty track stays visible on a light card.
- **Resources.** `dashboard_streak`, `dashboard_streak_short`, `dashboard_streak_none` and `dashboard_mission_complete` carry `scope="glance"` in all 15 `strings.xml` files. No new strings, no new permission, no manifest, jungle or complication change.
- **Coverage: 63 of 80.** Watch-app glances need CIQ 4.0; the 17 CIQ 3.4 products (fēnix 6 family, MARQ Gen 1, Descent Mk2/Mk2S, FR945 LTE, Enduro Gen 1) get nothing: the compiler (with `-w`) prints "The (:glance) annotation will be ignored" and the build is unchanged. Accepted; no widget build for them. The 63 all have a 64 KB glance limit (device data; the SDK prose's 32 KB is stale) and live updates.
- **Gate for scope errors.** The default build is silent when glance code reaches foreground code. `monkeyc -w -l 3 … | grep "not available in all function scopes"` must print nothing, for both jungles, app and `-t` (`tools/glance-scope-check.sh`). `-l 2` misses `new HeroSetStore(...)`, and `-l 3` also prints unrelated pre-existing type errors, hence the grep.
- **Release: its own upload, 1.1.2** (owner-delegated recommendation): no permission change, so a normal review, and a new process type is safer isolated from 1.2.0 (Connect sync). The "feature work waits" line in [`go-to-market.md`](status.md) is lifted for this feature by the request to build it.
- **The idle timeout is a hard pre-upload gate.** The SDK says an app launched from the glance list is terminated after inactivity, unlike one launched from the activity list. HeroSet waits for reps without a key press, and [`battery.md`](battery.md) records that a timeout would silently lose an unsaved set. Duration and whether motion resets it are undocumented. **No mitigation is built speculatively**; if the FR965 test shows termination, the follow-up is a new ADR (persist the running set, or branch on `:launchedFromGlance`).

**Measured (simulator and compiler, 2026-09-26).** Glance closure on fr965: 5,430 bytes store build (data 2,112 + code 3,318), 5,480 dev (`monkeyc --build-stats 0`), against 65,536. All 80 products build in both jungles; the 17 CIQ 3.4 products print the ignored-annotation warning (with `-w`). The suite passes on fr965 and on one product per glance screen width; `HeroSetGlanceFitTest` checks the layout, the status row's words and every state's drawing at the content areas of the running screen width, with that product's own fonts (32 distinct areas over the 63 products; the suite's glance tests were run on each of the 63 products).

**Not measured.** No glance ran in glance mode or on a watch (the simulator's Glance Launch Mode is a GUI setting): peak heap in the 64 KB process, real fonts and MIP contrast, per-language resource loading in the glance process, the idle timeout, whether the glance appears in the list by default after an update (confirmed yes on FR965, 2026-09-27), and whether the complication publish behaves on the FR965 after moving to `getInitialView`. See [`go-to-market.md`](status.md) "Next session" E.

**Rejected.** Annotating nothing (loads the whole ~30 KB app into the glance, with the store's writes and the publish); tagging `HeroSetStore` (7.7 KB, drags in the learner and swing trace, still writes from the glance); reading the complication from a glance (watch faces only); a separate widget app; a background service; hint text; combined percent (the fallback if the pills read too small on a wrist); "reps left" (a new plural-sensitive string in 15 languages); per-product exclusion of the 17.

**Consequences.** [ADR-044](#adr-044)'s "app start" publish is now the first view request. HeroFace code is untouched; its docs already say "app start". Tests: +4 reader, +3 fit. A sideloaded app may not appear in the glance list until the user adds it.

### <a id="adr-052"></a>ADR-052: Recoverable workout draft, against the glance-launch idle kill
Decided 2026-09-27, the day the owner ran gate E1 on FR965 (dev build, sideloaded 1.1.2): a set started from the glance-launched app and left idle is killed at **exactly 120 s** — screen still lit, the workout's own 1 Hz HR/calorie redraw still running — and whatever was detected is gone, nothing banked, because nothing is saved until Save is pressed. Redraws do not reset the system's timer; only real input does, so there is no way to *avoid* the kill from inside the app, only to survive it.

**Decision.**
- **A checkpoint, not a save.** `HeroSetStore.saveWorkoutDraft(exercise, detected)` writes the live workout screen's raw detected count to three flat keys (`hero_draft_day`, `hero_draft_exercise`, `hero_draft_count`; day `0` means no draft). It never touches XP, the streak, the complication or the validation log — the "nothing is saved until you've seen it" promise ([`release-contract.md`](release-contract.md)) is unchanged; a resumed count still goes through Finish, the review picker and Save exactly like a fresh one.
- **Scope: the live-counting workout screen only.** `HeroSetWorkoutView.initialize()` reads `HeroSetStore.getWorkoutDraft(exercise)`; null unless today's draft is for this exact exercise, so a different exercise's leftover draft never bleeds into a fresh one and a draft from an earlier day is exactly as stale as any other daily value ([ADR-001](#adr-001)). Found, it seeds `_detected` and counting continues from there — same screen, same Finish/Back paths, no new view and no new navigation stack shape (ADR-024's depth-1 invariant is untouched).
- **Cadence:** every `HeroSetConfig.DRAFT_CHECKPOINT_TICKS` (15) ticks of the existing 1 Hz refresh timer, only when the count changed since the last checkpoint, plus one flush in `onHide()` (the Resume/Save/Discard menu pauses the timer, and that menu can be idled exactly as easily as the workout screen). Worst-case loss is bounded to the last checkpoint interval, not zero — a recovered count can be a few reps short of the very latest, which is the trade-off of a periodic checkpoint over a per-rep one.
- **Cleared at every terminal point**, never on `onHide` alone (which also fires when the Resume/Save/Discard menu is merely shown over a live set — clearing there would erase a draft the moment Back is pressed, before the user has chosen anything): Finish (`HeroSetWorkoutDelegate.onKey`, handing off to the picker), the no-count Back (`onBack`, ADR-050's "Back now just leaves"), quick-Save (`HeroSetWorkoutView.saveSet`), and Discard (a new `discard()` hook on `HeroSetExitMenuDelegate`, default no-op, overridden by `HeroSetWorkoutEndMenuDelegate`). Resume ("stay") clears nothing; the timer resumes checkpointing where it left off.
- **Per-rep and silent-full-save were rejected.** Writing Storage on every single rep multiplies flash writes for no benefit once a 15 s bound is already well inside the 60-120 s kill window. Auto-banking the count without review (skipping Finish/picker/Save) would break the review-before-it-counts promise and could feed the threshold learner ([ADR-040](#adr-040)) a count the user never confirmed.
- **Not covered, and not built now:** the review picker's own in-progress delta (after Finish, before Save) isn't checkpointed, so idling *there* can still lose an adjustment — smaller window in practice (a correction is a few button presses, not a timed set), but the same failure shape. Manual entry and the goal picker have the identical gap. Extending the same mechanism to those screens is straightforward if it turns out to matter; not built speculatively.

**Evidence.** Written without the simulator (shared with another session), then verified once it was free: 112/112 dev, 101/101 store, `tools/glance-scope-check.sh` clean. Caught by that run: two tests used `Test.assertEqual(x, null)`, which the runner throws on — fixed to `Test.assert(x == null)`, the pattern already used elsewhere in the suite. **Confirmed on FR965 the same day:** a set killed by the idle timeout resumes when the same exercise is started again; a different exercise correctly shows 0 (no cross-exercise bleed). Not yet checked, not blocking: a draft surviving unresumed to the next calendar day reads as 0.

**Consequences.** Three new flat keys, spellings fixed by [ADR-003](#adr-003) like every other `hero_*` key. No manifest, permission or complication change. Test count: +N (`HeroSetWorkoutDraftTest`, store-level only — no UI test, since nothing is drawn differently).

**Amendment, 2026-10-02 (bug found on a watch):** the hide-time flush wrote the count back after a terminal clear, so a set under 15 s (no periodic checkpoint yet) left a stale draft and the next set of that exercise started from it. `HeroSetWorkoutView` now sets `_draftEnded` in `discardDraft()` and `checkpointDraft()` returns at once when it is set; a view merely hidden (Resume/Save/Discard menu) still flushes. Regression tests in `HeroSetWorkoutDraftTest`.

### <a id="adr-053"></a>ADR-053: Glance upload submitted to the store as 1.2.0, not 1.1.2; Connect sync renumbered to 1.3.0
Decided 2026-09-27 (owner call). The glance + idle-kill fix build (ADR-051/052, `dist/HeroSet-store.iq`, permissions unchanged: `Sensor` + `ComplicationPublisher`) was uploaded to the Connect IQ Store with **App Version `1.2.0`**, not the `1.1.2` this doc set had been calling it. No Connect sync code, `Fit`/`FitContributor` permission, or manifest change is in this build — App Version is free text typed into the upload form ([`listing/NOTES.md`](../listing/NOTES.md)), not derived from the manifest, so nothing on the watch or in the package changed as a result.

**Consequence:** `1.2.0` is spent. Connect sync ([ADR-043](#adr-043), [`connect-sync-plan.md`](archive/connect-sync-plan.md)) now targets **1.3.0** — its own permission and manifest change still gates that upload exactly as before, only the number moves. Nothing else about the sync plan changes.

### <a id="adr-054"></a>ADR-054: Connect sync shelved — step 0 spike failed, two device bugs found. **Amends [ADR-043](#adr-043)**
Decided 2026-09-27 (owner call), on FR965, dev build, sideloaded. Step 0 of [`connect-sync-plan.md`](archive/connect-sync-plan.md) run before the 10-item device acceptance.

**Step 0 spike result: fail, and not the string-vs-numeric question it was written to answer.** One visit, one set, sync On. Checked both Garmin Connect mobile (Overview → Exercises) and Connect web (exported page): the Strength Training activity's Sets/Exercises table shows exactly one row, `Exercise Name` = the native "Choose an Exercise" placeholder link, `Reps` and `Time` both `0`. Searched the full web export for `pushup`/`situp`/`squat`/`developer`: zero matches. None of our `FitContributor` fields (`exercise`, `reps` on the lap; `pushups`/`situps`/`squats` on the session) render anywhere in Garmin Connect, on either platform. Session-level native fields work fine (0:35 total time, 66 bpm avg HR, 1 cal all came through correctly).

**Root cause, matching a limit this doc already named** ([`connect-sync-plan.md`](archive/connect-sync-plan.md) platform-limits table: "no FIT `set`/exercise-category API → no native set list"): Garmin Connect's Sets/Exercises UI is built entirely around FIT's *native* `Set` message, not developer fields on LAP/SESSION messages. The plan's central promise — "one lap per set, exercise + reps in the summary" — can't be shown in Connect's own app on either platform. Whether the developer fields exist at all in the raw FIT bytes was not checked (no export pulled); moot regardless, since what a buyer sees in Connect is what matters for the store description.

**Two further bugs found in the same session, independent of the above:**
- **Exiting HeroSet mid-visit leaves the native session recording.** Reopening the app afterward reports it's still recording and refuses a clean restart — the exact stray-activity failure class [ADR-030](#adr-030) already found and this design's `onStop` save-or-discard-always rule ([ADR-043](#adr-043)) was meant to close off. It isn't closing it off on this exit path.
- **Discard still creates a lap.** A discarded set was expected to leave a 0-rep lap only ([ADR-043](#adr-043) "Discarded / empty sets keep a 0-rep lap"); instead new laps kept appearing after Discard, which reads as the boundary logic firing independent of the discard path.

Neither bug was investigated further (not worth root-causing a design whose main value can't render).

**Decision.** Connect sync does not ship. Not this session, not as designed. 1.3.0 is not uploaded today; no store publication happens. `dist/` and the store listing are untouched — 1.2.0 (glance, [ADR-053](#adr-053)) stays the only thing awaiting Garmin review.

**Consequences.** [ADR-043](#adr-043) is shelved, not superseded — the dev-build code stays as-is (still `(:sync)`-scoped, still excluded from `store.jungle`), nothing to revert. Resuming this feature later means solving the actual product question first (own exercise log inside HeroSet, since Connect can't show it: a "Health & Fitness" positioning built around it, not "Health & Fitness *and syncs to Connect*"), not re-running the same acceptance checklist expecting a different render result. `docs/connect-sync-plan.md` and `docs/status.md`'s 1.3.0 backlog item both note this.

### <a id="adr-055"></a>ADR-055: Instinct family: semi-octagon, 1-bit, subscreen window. **Proposed**
Written 2026-10-01 on branch `heroset-instinct2` (numbered 056 first, renumbered 055 on 2026-10-03: nothing used 055). **Not accepted: nothing has run on a watch; the look was approved by the owner on 2026-10-03 and simulator evidence was accepted as enough because no watch is available. The products are in the branch's manifests only.**

**Context.** Wave 2-5 products are all round or touch-first. The Instinct family is the next obvious ask ([`compatibility.md`](compatibility.md)): a 1-bit memory-in-pixel display (palette `000000`/`FFFFFF` only), a semi-octagon outline, five buttons, and a round **subscreen window** cut into the top-right corner of the display. `HeroSetLayout` treats every non-round screen as a plain square with a full inset on each side, and the dashboard stacks one more row than 156-176 px of height has.

**Inventory** (SDK 9.2.0 `Devices/` JSONs; every semi-octagon or 1-bit-MIP *watch* product):

| Product | Screen | Window (x, y, w, h) | Watch-app memory | API | Glance |
|---|---|---|---|---|---|
| `instinct2` | 176x176 | 113, 0, 62x62 | 98,304 | 3.4 | no (needs 4.0) |
| `instinct2x` | 176x176 | 113, 0, 62x62 | 98,304 | 3.4 | no |
| `instinct2s` | 163x156 | 108, 0, 54x54 | 98,304 | 3.4 | no |
| `descentg1` | 176x176 | 113, 0, 62x62 | 98,304 | 3.4 | no |
| `instinctcrossover` | 176x176 | none in the simulator (the real watch has analog hands over the display) | 98,304 | 3.4 | no |
| `instincte45mm`, `instinct3solar45mm` | 176x176 | 113, 0, 62x62 | 131,072 | 6.0 | yes, 32 KB glance limit |
| `instincte40mm` | 166x166 | 113, 0, 52x52 | 131,072 | 6.0 | yes, 32 KB glance limit |

All are at or above `minApiLevel` 3.4.0 (`instinct2`/`2s`/`crossover` list CIQ 3.2.7 part numbers as well: units on that firmware will not get the app). Layout is shared by everything with the same width: one code path for all of them. Round AMOLED relatives (`instinct3amoled45mm`/`50mm`, `instinctcrossoveramoled`) are wave-1-shaped products with a 98 px subscreen on the first two; not touched.

**Memory is not the blocker.** Measured in the simulator with a scratch store build carrying a `System.getSystemStats()` probe (timer-driven: dashboard, main menu, workout, manual picker, goal picker, back to dashboard), `-r` as the store upload is built: **peak 53,216 B used of 94,024 B total** on the final code (the simulator's total; the manifest limit is 98,304), about 41 KB free; dashboard 49,848 B. The first measurement, before the Instinct layout code, was 52,960 B peak; same figures on `instinct2` and `instinct2s`. A build without `-r` (debug info) peaks at 66,624 B and also fits. fēnix 6 measured 52 KB the same way ([ADR-038](#adr-038)). The sensor path allocates fixed arrays (`HeroSetSwingTrace` is bounded). The unit-test run's ~127 KB figure is the test harness and says nothing about the app.

**Decision (proposed).**
- **Subscreen-aware layout.** `HeroSetLayout` asks `WatchUi.getSubscreen()` on `SCREEN_SHAPE_SEMI_OCTAGON` products only, so no round product's geometry can depend on it. Rows that start above the window's lower edge plus a ring clearance (two thirds of the short inset, about 11 px, measured off the simulator's device image) end left of it; `HeroSetDraw.centered` centers text in the band that is left (`rowCenterX`), which is the screen's center everywhere else. A semi-octagon takes the narrower side margin (`textMargin`, not the full inset). *(The rest of this sentence, "its chamfers only reach corners no row occupies", was wrong; see the amendment below.)* Every text draw already goes through `HeroSetDraw.text`, so the screen-fit test now also fails on any text that pokes into the window.
- **Black-and-white palette by annotation.** `HeroSetPaletteMono` (`:mono`) and `HeroSetPalette` (`:color`) are the same class; the jungles exclude `mono` for everything and `color` for the Instinct products (`exclude = ...` property, so `sync;debug` stay in the release build). All roles are white on black: how the display would round `0x55AAFF`, `0x00FF00` or `0xFF0000` is unspecified, and no state may depend on it. Tracks are outlines under solid fills (`HeroSetPalette.MONO`). Colour was never the only cue ([`ADR-031`](#adr-031): full bars, DONE, signs), which is what makes this cheap. **Long translations:** beside the window a title that does not fit the band is cut with a trailing `.` instead of moving below the window (the rows under it have no room for it), and footer and picker hints, and mission labels next to their counts, are cut the same way when they overflow (`HeroSetDraw.truncated`); found by the per-language fit sweep on `instinct2` (Swedish and Ukrainian overlapped before). **DONE placement:** a finished row first tries `NAME DONE` + count; if none of the count fonts fits that (Instinct 2's 142 px column), the count slot reads DONE instead; only if that fails too does the full bar carry it alone.
- **The window is the XP gauge.** Dashboard: the XP ring becomes a hairline circle with a thick 260-degree fill in the window; rank and streak sit in the band left of it; the "XP TO GO" line is dropped (the gauge says it, and the band is too narrow for the words); mission bars use the full width below the window. Workout and picker screens keep their order; their first rows share the band beside the window, and wide rows (the validation log's lines) start below it.
- **Unchanged:** every round product's drawing (`rowCenterX` returns `centerX()` unless a window exists; the streak's zero-streak fallback only exists beside a window).

**Verification status.**
- Compile: store and dev builds for `instinct2`, `instinct2s`, `descentg1` and the round control products `fr965`, `fenix6`.
- `--typecheck 3` is not Instinct-specific: `HeroSetWorkoutView.mc` raises the same 46 errors on `fr965`, `fenix6` and `instinct2`, among hundreds of pre-existing ones, so no code was changed for it.
- Simulator: see "Evidence" below. Simulator is not device proof.

**Open, owner's.** (1) The look (mockup `docs/archive/instinct-mockup.html`): approved 2026-10-03. (2) Button hints stay `START` although the Instinct 2's select key is printed `GPS` (owner, 2026-10-03: no GPS is needed, so `GPS` would mislead; [ADR-029](#adr-029) names printed labels). (3) Accelerometer: the API symbols exist at 3.4 and a refusal is already handled (`_sensing` false shows NO SENSOR and manual entry works), but whether Instinct 2 firmware serves 25 Hz is unknown until a watch runs it. (4) Which products ship: **decided 2026-10-03, simulator evidence is enough (no watch available)**: the four above plus the CIQ 6 `instincte40mm`, `instincte45mm`, `instinct3solar45mm`, whose glance closure measures 2,112 B data + 3,241 B code against the 32 KB limit (`--build-stats 0`, store build; run-time heap not measurable in the simulator CLI) and whose glance areas (164x61, 154x61) are in `HeroSetGlanceFitTest`; the Crossover stays out (hands unmodelled). (5) Store listing, release contract and site claims: none changed here.

**Amended 2026-10-03 (after the 1.3.0 upload was prepared): the bezel hides the corners, so the bottom row is about 100 px wide.** A simulator screenshot showed "MISSION COMPLETE" drawn as "ISSION COMPLET", and "! COULD NOT SAVE" and long translations of the bottom hints are cut the same way. The earlier fit tests measured a plain square (and the mockup drew a 20 px chamfer). What shows on an Instinct is the square cut by a **circle about 98 px in radius** (96 to 100 px on all seven products: the alpha mask of the SDK's device image, `Devices/<id>/<id>.png`, inside `display.location` in `simulator.json`). Fix: `HeroSetLayout` clips every non-round row's insets to a 96 px circle (`SEMI_OCTAGON_VISIBLE_RADIUS`, semi-octagon products only, so round products are unchanged); on the Instinct the finished-day footer falls back from MISSION COMPLETE to the already-translated DONE, and the storage warning to "!", when the long wording does not fit (`HeroSetView.drawFooter`); every other row is cut with a "." by the existing `fitted`. The screen-fit harness now also fails any text box whose corner leaves the circle (`HeroSetScreenFitHarness.collectCorners`; boxes include font padding, so it is stricter than the ink). Checked by simulator screenshot (the finished footer reads DONE) and the 15-language sweep on `instinct2`, `instinct2s` and `instincte40mm`.

**Amended again 2026-10-04 (found while taking listing screenshots).** (1) The corner clip was cut against the whole font box, which shortened the main hint "START: MENU" (105 px) to "START: MEN." on the bottom row, though its ink shows whole. The clip is now cut against the ink of capitals (a quarter of the short inset off each end of the row, `HeroSetLayout.inkTrim`) and the radius is 98 px (the measured value on the 176 px products); the fit harness uses the same trim. (2) The glance's mission bars filled their track white on a 1-bit display, so every bar read as full; on the Instinct the track is now the outline only (`HeroSetGlanceView.drawPill`). (3) **Open here, fixed in the next paragraph:** in the simulator the glance of the Instinct E 40/45 mm and 3 Solar is drawn at the top of the screen, under the round window: the status text ("NO STREAK YET") and the third bar are cut at the window's left edge. Whether a real watch places the glance there is unknown; if it does, the glance layout needs `getSubscreen()`.

**Amended 2026-10-04 (owner decision, 1.3.1): the glance of the Instinct E 40/45 mm and 3 Solar is laid out around the window, blind.** The simulator draws the glance at the SDK's `glance.contentArea` (x 9, y 19, 164 x 61 on the 45 mm products, 154 x 61 on the 40 mm one), which puts the round window over its top right: "NO STREAK YET" and the third bar were cut at about x 106. Whether a real watch draws it there is unknown, so the layout is a guess to be confirmed on a wrist (ROADMAP 9.6).
- `HeroSetGlanceView.window()` asks `WatchUi.getSubscreen()` (guarded by `has`, and only when `screenShape` is `SCREEN_SHAPE_SEMI_OCTAGON`, so no other glance can depend on it) and hands `[left, bottom]` of the window to `HeroSetGlanceLayout`. Still `(:glance)`, still read-only; `tools/glance-scope-check.sh` is clean.
- `HeroSetGlanceLayout.rightEdge()`: when the window's bottom, less the glance's own origin and one pad for the bezel ring, reaches the block's top, both rows end one pad left of the window instead of at the padded right edge. The origin (`WINDOW_AREA_X`/`_Y` = 9 and 19) is not available to an app; it is a constant copied from the three products' `simulator.json`, the only products with both a window and a glance. Without a window `rightEdge()` is `width - pad()` and the pill gap is the old `width / 20`, so every other product's glance is unchanged.
- Result at 164 px: the rows are 90 px wide, so the pills are about 25 px each and the status row says `STREAK 12` (not `12 DAY STREAK`). **New fallback:** at zero streak with the day open the row now ends with `STREAK 0` (the `dashboard_streak_short` string, as on the dashboard beside the window) when `NO STREAK YET` does not fit; it applies to every glance but only shows where that phrase did not fit before (the row used to be blank). **Accepted loss:** with the day done there is no room for the check plus any words (`MISSION COMPLETE`, `N DAY STREAK`, `STREAK N` are all wider than the 71 px left), so the row is the check alone and the streak is not shown; the full bars and the check still say done (ADR-049).
- Tests: the suite's glance tests now build the layout with the product's own window and fail on any pill or words past it (`glanceLayoutFitsEveryAreaOnThisScreen`, `glanceStatusRowStaysInsideTheAreaOnThisScreen`), and the new `glanceRowsStopLeftOfASubscreenWindow` checks the arithmetic with a made-up window on every product (116 dev tests). Looked at in the container simulator on `instincte40mm`, `instincte45mm`, `instinct3solar45mm`: empty, partly done and done glances sit wholly left of the ring. Simulator only: the glance's real place, the real window clearance and the real fonts are unknown.
- **Measured, simulator and compiler:** glance closure on `instincte40mm`, store build, `--build-stats 0`: 2,139 B data + 3,451 B code (was 2,112 + 3,241) against the 32 KB limit. The tests bound the rows by the window's edge, not by its bezel ring (about 7 px further left in the simulator image), so on the 3 Solar the third pill's 1 px outline can touch the ring: a 1 px loss on a blind layout, not narrowed further.
- **Rejected:** moving the block below the window (the area is 61 px tall and the window plus its ring reaches 50 px), hiding the glance's pills, shrinking the font (the glance has one font).

**Evidence (2026-10-02, simulator only; the Instinct 2 family has never run on a watch).**
- Dev suite, 113/113 passing: `instinct2`, `instinct2s`, `instinct2x`; round controls `fr255s` and `fenix6`. Store suite, 102/102: `instinct2`, `fr255s`. These include `everyScreenFitsThisDisplay` with its new window check, and the new `rowsBesideASubscreenWindowStayClearOfIt`.
- `descentg1`: its unit suite would not run (the simulator hung on every attempt for that product). The same screen-fit logic, run as a plain app on the Descent G1's own simulator (176 x 176), reports 0 problems, as it does on `instinct2` (176 x 176), `instinct2x` and `instinct2s` (163 x 156); that is weaker evidence than the suite. `fr965` could not be run at all in this simulator: its suite hangs on the untouched baseline commit too, so the FR965 check is still owed.
- Palette: a run on `instinct2` prints `HeroSetPalette.MONO = true`, colour products keep `false` (suites on `fr255s`/`fenix6` pass).
- 2026-10-03, container simulator: dev suite 115/115 on `instinct2`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`, `fr965`; store 102/102 on `instinct2`, `instincte40mm`, `instinct3solar45mm`; per-language fit sweep (15 languages) on `instinct2`, `instinct2s`, `instincte40mm` all PASSED after the truncation fix above, and on `fr255s`/`venu2s` (round) for eng, dut, lit, por, ukr; all 87 products compile in both jungles (174 builds); `glance-scope-check` clean on `fr965`, `instincte45mm`.
- Memory (the figures above) was re-measured on the final code: peak 53,216 B of 94,024 B total on `instinct2` (dashboard 49,848 B), store build with `-r`.
- Not measured: whether a real Instinct 2 serves the accelerometer at 25 Hz (a scratch probe that registered the listener hung the shared simulator twice, so no callback count exists), real bezel margins, real contrast. Round-product drawing was not box-diffed old versus new (the simulator would not run the comparison); the round paths are unchanged by construction (`rowCenterX` returns `centerX()` without a window, `textMargin` and the side inset are unchanged off semi-octagon products) and the round control suites pass.
- Text widths at 176 px are larger than at 163 px (the 176 px products ship bigger fonts: XTINY is 23 px high against 19), which is why "STREAK 9999" needed a bare-number fallback and why the XP-to-go line is dropped rather than shortened.

