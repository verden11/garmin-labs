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
│   │               HeroSetWorkoutMenuDelegate, HeroSetWorkoutConfirmDelegate
│   ├── manual/     HeroSetManualPickerView, HeroSetManualPickerDelegate,
│   │               HeroSetManualConfirmDelegate   # continuous up/down delta
│   └── calibration/ HeroSetCalibrationView, HeroSetCalibrationDelegate,
│                    HeroSetCalibrationMenuDelegate
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
asks "Save N reps?". `HeroSetWorkoutView` also owns a real `ActivityRecording`
session per counted set (see ADR-016) — live calories/HR shown in-view via
`Activity.getActivityInfo()`, saved as a FIT activity alongside the rep count,
discarded on a 0-rep finish or a real exit. Calibration captures ten natural
reps, auto-finishes, rejects weak sessions.

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
| ADR-016 | Counted (sensor-driven) workouts record a real `ActivityRecording.Session` (`SPORT_GENERIC`/`SUB_SPORT_GENERIC`, no GPS), saved as a FIT activity on Finish/save-confirm so Garmin computes calories/HR/training effect (no guaranteed effect on Training Status/Load — no public API for that). Manual entry stays local-only, no session. `Fit` permission restored, `Positioning` stays dropped. **Use `SUB_SPORT_GENERIC`, not `STRENGTH_TRAINING`** — the latter triggers the watch's native strength-training auto-set UI and hangs the screen (confirmed on physical FR965). Session lifecycle: `HeroSetWorkoutView.beginChildOverlay()` tells `onHide` a menu/confirm cover apart from a real exit; an interrupt that bypasses our delegates (e.g. a call) is treated as exit and discards — known limitation. |
| ADR-017 | Manual entry uses `HeroSetManualPickerView`/`Delegate` (continuous Up/Down delta, held keys auto-repeat + accelerate via `Timer`, 1→2→5) instead of a discrete `+1/+5/+10` menu. Same Back-confirm contract as workout ("Save +N?"/"Save -N?"). |
| ADR-018 | Centered footer text is fit at runtime via `HeroSetLayout.fitCenteredY(maxY, minY, textWidth, textHeight)` — measures real pixel width (`dc.getTextWidthInPixels`), walks the row up off the bezel until it fits (reusing `leftInset`/`rightInset`). Do not guess a "safe" character count; it clips at the bezel edge unpredictably by font/device. |
| ADR-019 | `HeroSetStore`'s storage-read helpers return raw `Object?` (values may be `Number` or `Float`); route through `HeroSetStore.asNumber`/`asNumberOrNull` (narrows via `instanceof`) rather than calling `.toNumber()` directly — `Lang.Object` doesn't declare it, and the newer SDK enforces that strictly. |
| ADR-020 | *Deferred*: `HeroSetStore.mc` (~440 lines) exceeds the file's own 250-line budget. Natural split points: schema migration (`migrateSchema`/`migrateFlatStateToDictionaries`) and calibration-profile persistence. Not split without compiler/device access to verify — it backs most of the app's persistence tests and a bad split could silently corrupt real user data. |

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
GPS/distance/running tracking (no `Positioning` permission — ADR-009).
`ActivityRecording`/FIT export is in scope per-workout (ADR-016), just never
for GPS/distance.