# HeroSet Architecture

Target: Forerunner 965, Connect IQ 4.2.0, Monkey C. How the app is built today:
structure, layers, module duties, style, navigation, and known debt. **Why**
things are this way lives in [`decisions.md`](decisions.md) (ADR-NNN
references below point there). Related: [`input-and-ux.md`](input-and-ux.md)
(what the user sees), [`testing-plan.md`](testing-plan.md).

## 1. Guiding principles

| # | Principle | Why |
|---|-----------|-----|
| G1 | Pure domain first. Rules live in classes with no UI/Storage imports. | Unit tests without a device. |
| G2 | One class per file; filename = class name (ADR-013). | Monkey C has no module system. |
| G3 | No magic numbers. Tunables are named constants in `HeroSetConfig`. | One place to tune. |
| G4 | Render only in `onUpdate`. Logic runs in delegates, stores, domain. | No draw-time state changes. |
| G5 | Persistent state is typed and schema-versioned (ADR-003, ADR-019). | No silent Number/Float drift. |
| G6 | Back never loses data silently (ADR-028). | Trust in the counts. |
| G7 | Geometry via `HeroSetLayout`; text fit is measured (ADR-006, ADR-018). | Round-screen safety. |

## 2. File structure

```
source/
├── app/          HeroSetApp               entry point, owns the store
│                 HeroSetDelegate          dashboard input → main menu
│                 HeroSetMenuDelegate      Menu2 routing, live menu state
│                 HeroSetSyncCoordinator   Connect sync day logic + log lines
├── domain/       HeroSetConfig            every tunable constant
│                 HeroSetRules             XP, rank curve, streaks, goal transitions
│                 HeroSetCalendar          local-day keys and day math
│                 HeroSetRepCounter        accelerometer rep detector
│                 HeroSetCalibration       threshold fitting
├── data/         HeroSetStore             the only persistence API
│                 HeroSetStorage           storage seam (tests inject in-memory)
│                 HeroSetPersistentStorage real Toybox Storage backend
│                 HeroSetClock             day seam (tests control "today")
├── sensor/       HeroSetSensorManager     accelerometer listener lifecycle
│                 HeroSetActivitySync      opt-in FIT recording session
├── layout/       HeroSetLayout            round-screen geometry
├── ui/
│   ├── dashboard/  HeroSetView, HeroSetDashboardState, HeroSetDayTracker,
│   │               HeroSetRankHeader (XP ring + rank), HeroSetMissionBars
│   ├── workout/    HeroSetWorkoutView, HeroSetWorkoutDelegate,
│   │               HeroSetWorkoutEndMenuDelegate, HeroSetWorkoutMetrics
│   ├── manual/     HeroSetManualPickerView, HeroSetManualPickerDelegate,
│   │               HeroSetManualExitMenuDelegate
│   ├── calibration/ HeroSetCalibrationView, HeroSetCalibrationDelegate,
│   │               HeroSetCalibrationMenuDelegate            (dev build only)
│   ├── diagnostics/ HeroSetValidationLogView, …Delegate      (dev build only)
│   ├── HeroSetSaveFeedback   save toasts + vibration tiers
│   ├── HeroSetHaptics        vibration patterns
│   ├── HeroSetText           strings.xml loading and formatting
│   ├── HeroSetPalette        color roles
│   └── HeroSetDraw           measured text/font fitting
└── test/         one *Test.mc per domain/data/layout area
resources/        strings, Menu2 menus, launcher icon (dev build)
resources-store/  release overlay: main menu without calibration/log (ADR-008)
```

Builds: `monkey.jungle` = dev, `store.jungle` = release (overlays
`resources-store/`). All user-visible text is in
`resources/strings/strings.xml`.

## 3. Layers

```
Presentation  app/, ui/, layout/     may use anything below, never raw Storage
Sensor        sensor/                Toybox.Sensor / ActivityRecording; no Storage
Data          data/                  Toybox.Application.Storage; the only place
Domain        domain/                Toybox.Lang only (Calendar: Time.Gregorian)
```

Dependencies point down only. Sensor classes take plain arguments and return
plain values; anything that needs both a sensor and the store is orchestrated
in Presentation (e.g. `HeroSetSyncCoordinator` combines `HeroSetActivitySync`
with `HeroSetStore`).

## 4. Module responsibilities

**HeroSetConfig**: every tunable number (goals, XP, rank curve, sensor rates,
calibration bounds, vibration, refresh intervals, log size). Read the file; it
is short and commented.

**HeroSetRules**: pure game rules. `xpForReps`; rank curve (`rankCost`,
`rankThreshold`, `rankForXp`, `xpIntoRank`, `xpToNextRank`, ADR-031);
`nextStreak` (on completion) and `activeStreak` (0 once a day is missed);
`missionComplete`, `crossedGoal` (milestone feedback), `clampDelta` (picker).

**HeroSetCalendar**: `todayKey()` → `YYYYMMDD` from the local clock;
`isConsecutiveDate` handles month/year/leap rollover (ADR-001).

**HeroSetRepCounter**: per sample, L2 magnitude minus an EMA gravity baseline;
counts a rep when both a positive excursion past `arm` and a negative one past
`release` occur, then applies a cooldown. `getLastCyclePeak/Valley()` feed
calibration. Exercise-agnostic; thresholds come from the store (ADR-004).

**HeroSetCalibration**: `armThresholdFrom`/`releaseThresholdFrom` (half the
mean excursion, clamped to config bounds) and `isUsable` (10 cycles, minimum
strength).

**HeroSetStore**: the only persistence API; all reads narrow types
(ADR-019). Invariants:
- **Local-day reset:** `ensureCurrentDay()` zeroes daily counts when the day
  key changes.
- **No XP farming:** `awardXpFor` pays only for net gain against a per-exercise
  daily credit ratchet capped at the goal (ADR-002).
- **Write failures:** caught, flagged via `hasWriteFailure()` (ADR-010).
- **Schema v3 migration:** flat keys mirrored into grouped dictionaries; flat
  keys still written and read as fallback (ADR-003).
- **Calibration:** per-exercise profile dictionary keyed by strings, never
  Symbols (ADR-022).
- **Sync state:** `isSyncEnabled`, and the day of the open recording
  (`get/set/clearSyncSessionDay`; 0 sentinel = none) (ADR-025/027).
- **Diagnostics log:** `logValidationTrial`, `logDiagnostic`, capped ring
  buffer (ADR-026/030).

**HeroSetSensorManager**: registers/unregisters the 25 Hz accelerometer
listener. Callers must pass `method(:onSensorData)` (ADR-023).

**HeroSetActivitySync**: the opt-in FIT recording. `beginSet()` (returns time
already recorded, so a resumed session is detectable), `endSet()`,
`closeOpenSession()` (saves only if it recorded time, else discards).

**HeroSetSyncCoordinator**: decides when a stale day's recording is closed,
turns sync on/off, and writes `SYNC …` lines to the diagnostics log (ADR-030).

**HeroSetLayout**: chord-aware insets for round screens, content bands,
footer rows, the dashboard ring geometry, and `fitCenteredY` (walks text up off
the bezel until it measurably fits). **HeroSetDraw** builds on it to choose the
first wording/largest font that fits (ADR-018).

**UI**:
- **Dashboard:** renders a `HeroSetDashboardState` snapshot. `HeroSetRankHeader`
  draws the ring and rank lines, `HeroSetMissionBars` the three bars, and
  `HeroSetDayTracker` redraws at midnight (ADR-031, ADR-012).
- **Workout:** counts via `HeroSetRepCounter`, shows live metrics from
  `HeroSetWorkoutMetrics` (no FIT session, ADR-021), and hands off to the
  picker on Finish (ADR-024).
- **Picker:** edits a signed delta, ±1 per press (ADR-017/029).
- **Calibration:** captures 10 reps and names the rejection reason.

## 5. Data flow

```
Sensor listener → WorkoutView.onSensorData → RepCounter.feedSample(x, y, z)
  → true: _detected += 1, haptic tap (double on goal crossing), requestUpdate
Workout 1 Hz timer → requestUpdate (HR / calories / elapsed)

START (Finish) → pop workout → push picker(seed = detected)       [depth 1]
Picker save → Store.add(exercise, delta)
  → ensureCurrentDay → clamp ≥ 0 → awardXpFor (ratchet) → updateCompletion
  → logValidationTrial (workout-seeded only) → HeroSetSaveFeedback

Connect Sync on: WorkoutView.onShow → SyncCoordinator.beginSet
  → close stale day's recording? → ActivitySync.beginSet → log SYNC line
  WorkoutView.onHide → ActivitySync.endSet (pause between sets)
```

## 6. Code style

- Names: classes `HeroSet` + PascalCase; methods `camelCase`; private vars
  `_camelCase`; constants `UPPER_SNAKE`; symbols `:lower_snake`; storage keys
  `"hero_snake"`.
- Every function has typed params and an `as` return type. Cast only after
  `instanceof` or a null guard; no `as Any`.
- Functions ≲30 lines; files ≲250 lines (split by responsibility).
- Catch only what can throw; degrade and flag, never swallow silently.
- Comments explain **why**, not what.

## 7. Decisions

All ADRs, with status and rationale: [`decisions.md`](decisions.md). New durable
decisions go there, as a new ADR at the end.

## 8. Navigation

```
Dashboard (HeroSetView) ── START/Up/Down (or Menu) ──► Main Menu (Menu2)
  Main Menu ── Start <exercise> (menu popped) ──► Workout      [depth 1]
            ── Log <exercise>   (menu popped) ──► Picker       [depth 1]
            ── Connect Sync (toggle in place)
            ── Calibrate Exercise ──► Calibration Menu ── (menu popped)
                 ──► Calibration view (above Main Menu; Back → Main Menu)
            ── Validation Log (dev) ──► log view (above Main Menu)
  Workout ── START (workout popped) ──► Picker seeded with count [depth 1]
          ── Back, 0 reps ──► Dashboard
          ── Back, reps ──► Workout End Menu [depth 2]
               Resume/Back ──► Workout (1 pop)
               Save / Discard ──► Dashboard (2 pops)
  Picker  ── START ──► save, Dashboard (1 pop)
          ── Up/Down ──► delta ±1 per press (no hold behavior, ADR-029)
          ── Back, delta 0 ──► Dashboard
          ── Back, delta ≠ 0 ──► Manual Exit Menu [depth 2]
               Keep Editing/Back ──► Picker (1 pop)
               Save / Discard ──► Dashboard (2 pops)
  Calibration ── START begin/stop capture (auto-finish at 10)
```

Every fixed pop count relies on Workout/Picker sitting at depth 1 (ADR-024).
Over-popping past the dashboard exits the app.

## 9. Known technical debt

| Item | Why it's not fixed yet | Fix when |
|---|---|---|
| `HeroSetStore.mc` is 472 lines (budget 250) | Guards user data; a bad split corrupts installs (ADR-020) | With a device upgrade check (gate 4) |
| `HeroSetRepCounter.feedSample` is 51 lines (budget 30) | Detector is mid physical accuracy validation; refactoring it now muddies results | After gate 2 results are in |
| Connect Sync's one-activity-per-day design is unverified and probably broken on device | Needs answers from the paused device investigation | See `go-to-market.md` status checkpoint, item 0 |
| Validation log also records in the store build (only the viewer is hidden) | Harmless 30-line buffer; gating it needs a build flag the project doesn't have | If it ever holds anything sensitive |
| Physical-device-only failure modes (ADR-022/023) aren't covered by unit tests | The simulator doesn't reproduce them | Keep reading `CIQ_LOG.YAML` after device runs |

## 10. Out of scope

Touch-first interaction, multiple languages, cloud sync, FFT/ML signal
processing, GPS/distance tracking, one FIT activity per workout.
