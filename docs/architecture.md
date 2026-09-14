# HeroSet Architecture

Target: Forerunner 965, Connect IQ 4.2.0, Monkey C. This is the blueprint:
file structure, layering, module duties, style, and decisions. Related:
[`testing-plan.md`](testing-plan.md), [`input-and-ux.md`](input-and-ux.md),
[`release-contract.md`](release-contract.md).

## 1. Guiding principles

| # | Principle | Why |
|---|-----------|-----|
| G1 | Pure domain first. Testable rules live in classes with zero Toybox UI/Storage imports. | Unit tests without a simulator. |
| G2 | One class per file; filename = class name. | Monkey C has no module system. |
| G3 | No magic numbers. Every threshold/goal/ratio is a named constant in `HeroSetConfig`. | Per-device tuning. |
| G4 | Render only in `onUpdate`. Logic runs in delegates, stores, domain. | Testable UI, no draw-time state corruption. |
| G5 | Persistent state is typed and schema-versioned. | No silent Number/Float drift. |
| G6 | Explicit session contracts. Back never loses data silently. | Resolved inverted-save bug. |
| G7 | Geometry via `HeroSetLayout`. No view computes its own pixels. | Device-matrix safety. |

## 2. File structure

```
source/
├── app/            HeroSetApp, HeroSetDelegate, HeroSetMenuDelegate
│                                                  # wiring, entry, menu routing
├── domain/         HeroSetConfig, HeroSetRules, HeroSetCalendar,
│                   HeroSetRepCounter, HeroSetCalibration   # pure logic
├── data/           HeroSetStore, HeroSetStorage   # only Storage callers
├── sensor/         HeroSetSensorManager            # accelerometer lifecycle
├── layout/         HeroSetLayout                   # geometry math
├── ui/
│   ├── dashboard/  HeroSetView, HeroSetDashboardState, HeroSetDayTracker
│   ├── workout/    HeroSetWorkoutView, HeroSetWorkoutDelegate,
│   │               HeroSetWorkoutConfirmDelegate   # no pause/resume (ADR-024)
│   │                                               # Finish hands off to manual/
│   ├── manual/     HeroSetManualPickerView, HeroSetManualPickerDelegate,
│   │               HeroSetManualConfirmDelegate   # continuous up/down delta;
│   │                                               # doubles as post-workout
│   │                                               # correction (ADR-024)
│   ├── calibration/ HeroSetCalibrationView, HeroSetCalibrationDelegate,
│   │                HeroSetCalibrationMenuDelegate
│   └── HeroSetSaveFeedback   # shared save toast + vibrate (ADR-024)
└── test/           HeroSetConfigTest, HeroSetRulesTest, HeroSetCalendarTest,
                    HeroSetRepCounterTest, HeroSetCalibrationTest,
                    HeroSetStoreTest, HeroSetLayoutTest
```

Builds: `monkey.jungle` = dev (all screens, `resources/`). `store.jungle` =
release (overlays `resources-store/`; calibration menu entry absent).

## 3. Layering

```
Presentation  Views + Delegates + HeroSetLayout
Data          HeroSetStore (typed facade, schema v3, migration) + DayTracker
Sensor        HeroSetSensorManager (accel lifecycle)
Domain        Config, Rules, Calendar, RepCounter, Calibration
```

Dependency rules: Domain imports only `Toybox.Lang` (Calendar may use
`Time.Gregorian`). Data may import Domain + Storage + Time.Gregorian. Sensor
may import Domain + `Toybox.Sensor`. Presentation may import anything except
direct `Storage.*` calls.

## 4. Module responsibilities

**HeroSetConfig** — every tunable constant: `MISSION_GOAL=100`,
`SENSOR_SAMPLE_RATE=25`, `SENSOR_PERIOD_SECONDS=1`,
`SENSOR_COOLDOWN_MS=600`, `DEFAULT_ARM_THRESHOLD=100`,
`DEFAULT_RELEASE_THRESHOLD=70`, `CALIBRATION_REQUIRED_CYCLES=10`,
`CALIBRATION_MIN_PEAK=90`, `CALIBRATION_MIN_VALLEY=70`.

**HeroSetRules** — pure facade: `progress(count, goal)`,
`xpForReps(reps)` (2 XP/rep), `rankForXp(xp)` (`xp/100 + 1`),
`missionComplete(...)`, `nextStreak(last, today, current)` via
`HeroSetCalendar.isConsecutiveDate`. No Storage/Time/Graphics imports.

**HeroSetCalendar** — local-day math (DST-proof by construction, no 86400
arithmetic): `todayKey()` → `year*10000 + month*100 + day` from the LOCAL
clock; `isConsecutiveDate(last, today)` handles month/year/leap rollover.

**HeroSetRepCounter** — gravity-removed turning-point detector. Each sample →
L2 magnitude (`sqrt(x²+y²+z²)`), gravity removed via EMA baseline
(`mag + (mag - baseline)/100`), one rep counted when BOTH a positive excursion
past `armThreshold` and a negative excursion past `releaseThreshold` are seen.
`feedSample(x, y, z)` returns true on a rep; cooldown (in samples, derived from
ms) suppresses fast cadence; `reset()` clears partial-cycle state on resume;
`getLastCyclePeak/Valley()` feed calibration. Does not know the exercise — it
is configured by thresholds from the store.

**HeroSetCalibration** — derives thresholds from counted live cycles:
`armThresholdFrom(meanPeak, meanValley)` (half of mean peak, clamped 60–500),
`releaseThresholdFrom(...)` (half of mean valley, clamped 50–400),
`isUsable(cycles, meanPeak, meanValley)` (≥10 cycles, min peak/valley).

**HeroSetStore** — the only persistence caller. Schema v3 (`SCHEMA_VERSION`).
All reads/writes via typed accessors with null checks and explicit Number/Float
conversion. Key invariants:

- **Local-day reset.** `ensureCurrentDay()` compares `hero_day` against the
  local calendar key; on change, zeroes daily counts.
- **Credit ratchet (no XP farming).** `awardXpFor` pays XP only on the NET
  positive increase in stored count, capped at `MISSION_GOAL`, against a
  per-goal credit. `add(+10)` then `add(-10)` earns XP exactly once.
- **Write failure.** `Storage.setValue` wrapped in try/catch
  (`StorageFullException`); state kept in memory, `hasWriteFailure()` exposed
  for the view.
- **Migration.** On schema mismatch, legacy flat keys are mirrored into grouped
  dictionaries (`hero_daily`, `hero_profile`, `hero_calibration`) and the
  schema is bumped. v1→v3 resets calibration + transient daily state (old
  detector thresholds are meaningless), preserves XP/streak/history.
- Calibration profiles stored per-exercise (`arm`, `release`, `rate`,
  `cooldown_ms`).

**HeroSetStorage** — seam (`getValue`/`setValue`) so tests run in-memory; a
`HeroSetClock` seam controls `todayKey()` for deterministic streak/rollover
tests.

**HeroSetSensorManager** — owns accelerometer lifecycle: `start(callback,
sampleRate)`, `stop()`, `isEnabled()`. Views reset `RepCounter` on resume.

**HeroSetLayout** — single geometry source. `shortInset()`, `bandStep()`,
`bandTop(band)`, `footerRowTop()/footerRowBottom()`, `leftInset(y, height)/
rightInset(y, height)` (round: inscribed-circle chord at the row's farthest
edge from center via `chordHalfWidth(radius, dy)`; square: constant inset),
`fitCenteredY(maxY, minY, textWidth, textHeight)` (round: shifts centered
content up off the bezel until it measurably fits the chord; square: no-op —
see ADR-018). No view computes pixels.

**UI** — Dashboard renders a `HeroSetDashboardState` snapshot (built once per
refresh by the store; `HeroSetDayTracker` Timer fires every 60 s to catch
midnight rollover). Workout confirm delegate enforces the save contract: Back
asks "Save N reps?". `HeroSetWorkoutView` shows live HR/calories with no FIT
session (see ADR-021). Calibration captures ten natural reps, auto-finishes,
rejects weak sessions.

## 5. Data flow

```
SensorManager.onSensorData → RepCounter.feedSample(x,y,z) → true (rep)
  → WorkoutView._detected += 1 → WatchUi.requestUpdate()

Store.add(exercise, amount)
  → ensureCurrentDay()
  → next = clamp(previous + amount, ≥ 0)
  → awardXpFor(exercise, previous, next)   # net gain only, ratcheted
  → updateCompletion()                      # streak via day keys
```

## 6. Code style

- Names: classes `HeroSet` + PascalCase; methods `camelCase`; private
  `_camelCase`; constants `UPPER_SNAKE`; symbols `:lower_snake`; storage keys
  `"hero_snake"`.
- Every function: typed params + `as` return type. Casts only after `instanceof`
  or null guard. No `as Any`.
- Functions under ~30 lines; files target ≤ 250 lines (split along
  responsibility if exceeded); `onUpdate` may exceed via draw helpers.
- Catch only what can throw (`StorageFullException`, sensor registration);
  degrade + flag, never swallow silently.
- Comments: **why**, not what. No boilerplate. Code self-documents via naming.

## 7. Key decisions (all implemented)

| ID | Decision |
|----|----------|
| ADR-001 | Local-day key via `Gregorian.info` → YYYYMMDD integer. No epoch/86400. |
| ADR-002 | XP on net positive stored delta only. Farming impossible. |
| ADR-003 | Schema version key; flat keys migrated to grouped dicts on launch. |
| ADR-004 | Detector = gravity-compensated EMA baseline + turning points; thresholds from fitted cycles. |
| ADR-005 | Sensor rate unified at 25 Hz; calibration uses the same live stream. |
| ADR-006 | Shared `HeroSetLayout` metric layer; no raw pixels in views. |
| ADR-007 | Workout Back → confirm dialog ("Save N reps?"). |
| ADR-008 | Calibration gated out of release via `resources-store` menu overlay. |
| ADR-009 | *Superseded.* Pro Run (GPS distance, `ui/run`, `Positioning` permission) removed permanently. GPS/distance is out of scope; see ADR-016 for the FIT/calorie replacement. |
| ADR-010 | Storage errors caught, flagged in-app; in-memory fallback. |
| ADR-011 | No `SensorLogging` permission until FIT export ships. |
| ADR-012 | Dashboard refresh via 60 s `DayTracker` timer + dirty flag. |
| ADR-013 | One class per file; `HeroSet` prefix globally. |
| ADR-014 | `(:test)` files in `source/test/`; excluded from normal builds. |
| ADR-016 | *Superseded by ADR-021.* Was: per-workout `ActivityRecording`/FIT session for calories/HR/training effect. Dropped — one Garmin Connect activity per set cluttered the timeline/Strava feed. |
| ADR-017 | Manual entry uses `HeroSetManualPickerView`/`Delegate` (continuous Up/Down delta, held keys auto-repeat + accelerate via `Timer`, 1→2→5) instead of a discrete `+1/+5/+10` menu. Same Back-confirm contract as workout ("Save +N?"/"Save -N?"). |
| ADR-018 | Centered footer text is fit at runtime via `HeroSetLayout.fitCenteredY(maxY, minY, textWidth, textHeight)` — measures real pixel width (`dc.getTextWidthInPixels`), walks the row up off the bezel until it fits (reusing `leftInset`/`rightInset`). Do not guess a "safe" character count; it clips at the bezel edge unpredictably by font/device. |
| ADR-019 | `HeroSetStore`'s storage-read helpers return raw `Object?` (values may be `Number` or `Float`); route through `HeroSetStore.asNumber`/`asNumberOrNull` (narrows via `instanceof`) rather than calling `.toNumber()` directly — `Lang.Object` doesn't declare it, and the newer SDK enforces that strictly. |
| ADR-020 | *Deferred*: `HeroSetStore.mc` (~440 lines) exceeds the file's own 250-line budget. Natural split points: schema migration (`migrateSchema`/`migrateFlatStateToDictionaries`) and calibration-profile persistence. Not split without compiler/device access to verify — it backs most of the app's persistence tests and a bad split could silently corrupt real user data. |
| ADR-021 | Workout metrics with no FIT session at all: `Sensor.getInfo().heartRate` (live HR, no session, `Sensor` permission only) and `ActivityMonitor.getInfo().calories` day-delta (current minus the value at workout start) as a real Garmin-computed calorie estimate for that set. `Fit` permission dropped. Trade-off, accepted: no Training Effect/Status/Load data at all — that needs a saved activity, which is exactly what this removed. |
| ADR-022 | `CIQ_LOG.YAML` from a physical FR965 (`/GARMIN/APPS/LOGS/`, or `era -a <uuid>` from the SDK's `bin/`) found two crashes the simulator never caught: (1) `Storage.setValue` forbids `Symbol` as a Dictionary key/value ("Symbols can change from build to build") and throws `UnexpectedTypeException` — `HeroSetStore`'s `CALIBRATION_KEY` dictionary was keyed by the exercise `Symbol` directly (`calibration[:pushups]`); fixed via `exerciseKeyString(exercise)`, a String key, at all three call sites (migration write, `setCalibrationProfile`, `calibrationValue`). Guarded by `HeroSetStoreTest.calibrationDictionaryUsesStringKeysNotSymbols` — the in-memory test seam doesn't enforce this restriction, so it's the one class of bug unit tests can't catch on their own. (2) an explicit `as Lang.Array`/`as Lang.Array<Lang.Number>` cast on `Sensor.AccelerometerData.x/y/z` compiled and ran fine in the simulator (and even matches the SDK's own declared field type) but still threw `UnexpectedTypeException` in the sensor callback on this physical FR965/firmware — the runtime array value doesn't survive a hard `as` cast even though it satisfies `instanceof Array` and indexes fine directly. Fixed by dropping the cast entirely in both `HeroSetWorkoutView` and `HeroSetCalibrationView`'s `onSensorData`: read the field untyped, guard with `instanceof Array`, index directly. Verified on SDK 9.2.0 (simulator VM): passing a runtime `Float` into a `Number`-typed parameter (`feedSample`) does NOT throw, and `as Lang.Array<Number>` casts succeed on simulator-built Float arrays — so the device failure is specific to the firmware-constructed native arrays and cannot be reproduced in the simulator. One gap found during that verification: `HeroSetStoreTest.calibrationDictionaryUsesStringKeysNotSymbols` (the regression guard for (1)) did not compile against SDK 9.2.0 — a Symbol-key dictionary index on an untyped/`Object` receiver is a compile error, and even typed, a Symbol-key dictionary *read* throws `UnexpectedTypeException` at runtime. Rewritten to assert all `keys()` are `Lang.String`. Suite now 59 tests, all green. |
| ADR-023 | Workout/calibration `onSensorData` crashed on every physical FR965 run — "Unexpected Type Error" / "Error in sensor data callback", no stack trace, split-second after `Sensor.registerSensorDataListener` registration (itself always succeeded). Simulator never reproduced it. `git bisect` (real-device testing at each step, since the simulator gave no signal) isolated the regression to commit `e134e74`; static analysis of that diff (a `data as Sensor.SensorData` param type, a callback param type on `HeroSetSensorManager.start`) was a dead end — both were reverted with zero effect on the crash. The actual cause, found by comparing against the SDK's own `samples/PitchCounter` reference app: `_sensorManager.start(self.onSensorData, ...)` passed the listener as a bare `self.onSensorData` method reference. Garmin's sample instead does `Sensor.registerSensorDataListener(method(:accelCallback), options)` — the explicit `method(:symbol)` form. On real FR965 firmware, a listener bound via `self.x` registers without error but is never actually dispatched when sensor data arrives (silent — no exception, no callback, and the simulator does dispatch it fine, so this is invisible without a physical device). Fixed by switching both `HeroSetWorkoutView` and `HeroSetCalibrationView` to `method(:onSensorData)`; this additionally requires the method to be `public` or `protected` (compiler: "the private symbol ... will not be found when using the indirect lookup syntax"), matching the SDK sample's `public function accelCallback`. Diagnosed with a temporary persisted-breadcrumb technique worth keeping in mind for future device-only bugs: `System.println` is invisible on a standalone device (no live on-device debug available for FR965 through the Monkey C VS Code extension — device never appeared in the debug-target picker), so checkpoints were instead written through `HeroSetStore` to on-device Storage and displayed on the next dashboard load — survives the crash, readable by eye, no cable needed. |
| ADR-024 | Workout sessions dropped pause/resume and the mid-workout `+1/+5/-1/Finish` menu (`HeroSetWorkoutMenuDelegate`, deleted): a set now just counts from `onShow` until Select ("Finish"), which hands the detected count straight to `HeroSetManualPickerView` — the same continuous delta picker used by standalone manual entry (ADR-017) — seeded with that count instead of 0, so correcting a miscounted set reuses the existing accelerate-on-hold UI instead of a separate menu. This made the picker's caller-dependent navigation depth a real bug risk: `HeroSetManualPickerDelegate.onSelect` and `HeroSetManualConfirmDelegate.onResponse` pop a *fixed* number of views to land back on the dashboard, and that count is only correct if the picker sits at a fixed depth above the dashboard regardless of who opened it. Fixed by a hard rule, now followed by every caller (`HeroSetMenuDelegate.pushManualPicker`, `HeroSetWorkoutDelegate.onSelect`): pop your own predecessor view *before* pushing the picker, so it always sits at depth 1 directly on the dashboard. Get this wrong (push without popping, or reuse the view from a caller one level deeper) and the fixed pop-count either strands a stale view on the stack or over-pops past the root view — which exits the app outright, not just mis-navigates. Reward feedback (`"+N SAVED"` / `"DAILY MISSION COMPLETE!"` toast + vibrate) was centralized into `HeroSetSaveFeedback.show()` so all three save paths (workout quick-save via Back-confirm, picker direct save, picker Back-confirm save) give consistent feedback rather than duplicating the mission-complete check three times. |

## 8. Navigation

```
Dashboard (HeroSetView) ── Select/Menu ──► Main Menu
  Main Menu ── Workout / Calibrate / Manual Entry
  Workout ── Menu ──► Workout Menu (adjust/finish); Back ──► "Save N reps?"
  Manual Entry ── Up/Down adjust (hold to accelerate); Back ──► "Save +N?"
  Calibration ── exercise picker ──► capture (auto-finish at 10)
```

Push = `WatchUi.pushView`; Back = `WatchUi.popView`. No orphaned pops.

## 9. Out of scope

Touch-first interaction; multi-language; cloud sync; FFT/ML signal processing;
GPS/distance/running tracking (no `Positioning` permission — ADR-009);
`ActivityRecording`/FIT export (no `Fit` permission — ADR-021).