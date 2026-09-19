# HeroSet Architecture

Target: 67 round watches, AMOLED and MIP, FR965 first (`compatibility.md`), Connect IQ 3.4.0 (ADR-038), Monkey C. How app built today: structure, layers, module duties, style, navigation, known debt. **Why** live in [`decisions.md`](decisions.md) (ADR-NNN refs below point there). Related: [`input-and-ux.md`](input-and-ux.md) (what user see), [`testing-plan.md`](testing-plan.md).

## 1. Guiding principles

| # | Principle | Why |
|---|-----------|-----|
| G1 | Pure domain first. Rules in classes with no UI/Storage imports. | Unit test without device. |
| G2 | One class per file; filename = class name (ADR-013). | Monkey C has no module system. |
| G3 | No magic numbers. Tunables are named constants in `HeroSetConfig`. | One place to tune. |
| G4 | Render only in `onUpdate`. Logic run in delegates, stores, domain. | No draw-time state change. |
| G5 | Persistent state typed and schema-versioned (ADR-003, ADR-019). | No silent Number/Float drift. |
| G6 | Back never lose data silently (ADR-028). | Trust counts. |
| G7 | Geometry via `HeroSetLayout`; text fit measured (ADR-006, ADR-018). | Round-screen safety. |

## 2. File structure

```
source/
├── app/          HeroSetApp               entry point, owns the store
│                 HeroSetDelegate          dashboard input → main menu
│                 HeroSetMenuDelegate      Menu2 routing, live menu state
│                 HeroSetSyncCoordinator   Connect sync day logic + log lines (dev;
│                                          store build: no-op …Off.mc, ADR-033)
├── domain/       HeroSetConfig            every tunable constant
│                 HeroSetRules             XP, rank curve, streaks, goal transitions
│                 HeroSetCalendar          local-day keys and day math
│                 HeroSetRepCounter        tilt/height rep detector (ADR-032)
│                 HeroSetSwingTrace        one set's turning points, replayable
│                 HeroSetThresholdLearner  threshold belief from saved counts (ADR-040)
├── data/         HeroSetStore             the only persistence API
│                 HeroSetStorage           storage seam (tests inject in-memory)
│                 HeroSetPersistentStorage real Toybox Storage backend
│                 HeroSetClock             day seam (tests control "today")
├── sensor/       HeroSetSensorManager     accelerometer listener lifecycle
│                 HeroSetActivitySync      opt-in FIT recording session (dev;
│                                          store build: no-op …Off.mc, ADR-033)
├── layout/       HeroSetLayout            round-screen geometry
├── ui/
│   ├── dashboard/  HeroSetView, HeroSetDashboardState, HeroSetDayTracker,
│   │               HeroSetRankHeader (XP ring + rank), HeroSetMissionBars
│   ├── workout/    HeroSetWorkoutView, HeroSetWorkoutDelegate,
│   │               HeroSetWorkoutEndMenuDelegate, HeroSetWorkoutMetrics
│   ├── manual/     HeroSetManualPickerView, HeroSetManualPickerDelegate,
│   │               HeroSetManualExitMenuDelegate
│   ├── diagnostics/ HeroSetValidationLogView, …Delegate      (dev build only)
│   ├── HeroSetExitMenuDelegate  shared Save/Discard/stay back-menu (ADR-036)
│   ├── HeroSetSaveFeedback   store.add + save toasts + vibration tiers (rank-up first, ADR-041)
│   ├── HeroSetHaptics        vibration patterns
│   ├── HeroSetText           strings.xml loading and formatting
│   ├── HeroSetPalette        color roles
│   └── HeroSetDraw           measured text/font fitting
└── test/         one *Test.mc per domain/data/layout area, plus
                  HeroSetMotionFixture (physically shaped rep traces) and
                  HeroSetRepCounterHarness (shared test steps)
resources/        English fallback strings, Menu2 menus, launcher icon (dev build)
resources-<lang>/  translated strings for launch languages (`deu`, `fre`, `spa`,
                  `ita`, `por`, `dut`, `pol`, `swe`, `dan`, `nob`, `fin`, `tur`,
                  `lit`, `ukr`); Garmin selects by device language
resources-store/  release overlay: main menu without sync toggle and log (ADR-033)
manifest.xml      dev build: Sensor + Fit permissions
manifest-store.xml release build: Sensor only; same app id as manifest.xml
```

Builds: `monkey.jungle` = dev (excludes `(:nosync)`), `store.jungle` = release (overlays `resources-store/`, uses `manifest-store.xml`, excludes `(:sync)`; ADR-033). All user-visible text resource-backed: English fallback in `resources/strings/strings.xml`, language-qualified translations in `resources-<lang>/strings/strings.xml` folders. `HeroSetText` stay runtime access seam.

## 3. Layers

```
Presentation  app/, ui/, layout/     may use anything below, never raw Storage
Sensor        sensor/                Toybox.Sensor / ActivityRecording; no Storage
Data          data/                  Toybox.Application.Storage; the only place
Domain        domain/                Toybox.Lang only (Calendar: Time.Gregorian)
```

Dependencies point down only. Sensor classes take plain args, return plain values; anything needing both sensor and store orchestrated in Presentation (e.g. `HeroSetSyncCoordinator` combine `HeroSetActivitySync` with `HeroSetStore`).

## 4. Module responsibilities

**HeroSetConfig**: every tunable number (goals, XP, rank curve, sensor rates, learning tunables, vibration, refresh intervals, log size). Read file; short and commented.

**HeroSetRules**: pure game rules. `xpForReps`; rank curve (`rankCost`, `rankThreshold`, `rankForXp`, `xpIntoRank`, `xpToNextRank`, ADR-031); `nextStreak` (on completion) and `activeStreak` (0 once day missed); `missionComplete`, `crossedGoal` (milestone feedback), `clampDelta` (picker).

**HeroSetCalendar**: `todayKey()` → `YYYYMMDD` from local clock; `isConsecutiveDate` handle month/year/leap rollover (ADR-001).

**HeroSetRepCounter**: turn 25 Hz samples into one signal per exercise: push-ups and sit-ups use tilt swing along deviation's principal axis; squats use leaky double integral of strength, roughly height (`integratesMotion`). Count one rep per full swing past `+threshold` then `-threshold` (or reverse), sides at least `SENSOR_COOLDOWN_MS` apart (ADR-032). Feeds every signal value to its `HeroSetSwingTrace`.

**HeroSetSwingTrace**: turning points of one set's signal (sub-`TRACE_HYSTERESIS` reversals dropped, capped), and `countAt(threshold)` replaying the detector on them.

**HeroSetThresholdLearner**: belief over 24 thresholds × keep/drop-last-rep, `updated` from a trace and the saved count, `threshold` (belief median) and `dropsLastRep` for the next set (ADR-040).

**HeroSetStore**: only persistence API; all reads narrow types (ADR-019). Invariants:
- **Local-day reset:** `ensureCurrentDay()` zero daily counts when day key change.
- **No XP farming:** `awardXpFor` pay only for net gain against per-exercise daily credit ratchet capped at goal (ADR-002).
- **Write failures:** caught, flagged via `hasWriteFailure()` (ADR-010).
- **Flat keys only:** one `hero_*` key per value, spellings fixed by ADR-003; the grouped `hero_daily`/`hero_profile` mirrors were removed as dead weight (ADR-036). `keyFor`/`creditKeyFor` derive from `exerciseKeyString`, the one place an unknown exercise throws.
- **Learned thresholds:** `hero_learning` dict keyed by exercise strings, never Symbols (ADR-022); wrong `model` or malformed state reads as fresh (ADR-040). Old `hero_calibration` profiles not read.
- **Sync state:** `isSyncEnabled`, and day of open recording (`get/set/clearSyncSessionDay`; 0 sentinel = none) (ADR-025/027).
- **Diagnostics log:** `logValidationTrial` (validation trials) and `logDiagnostic` (sync lines), one capped ring buffer read by `getValidationLog` (ADR-026/030).

**HeroSetSensorManager**: register/unregister 25 Hz accelerometer listener. Callers must pass `method(:onSensorData)` (ADR-023).

**HeroSetActivitySync** (dev build; ADR-033): opt-in FIT recording. `beginSet()` (return time already recorded, so resumed session detectable), `endSet()`, `closeOpenSession()` (save only if recorded time, else discard).

**HeroSetSyncCoordinator** (dev build; ADR-033): decide when stale day's recording closed, turn sync on/off, write `SYNC …` lines to diagnostics log (ADR-030).

**HeroSetLayout**: chord-aware insets for round screens, content bands, footer rows, dashboard ring geometry, and `fitCenteredY` (walk text up off bezel until measurably fits). **HeroSetDraw** build on it to choose first wording/largest font that fits (ADR-018): `fits`/`firstFitting`/`largestFont` take the radius to measure against (`displayRadius()` with `textMargin()`, or `contentRadius()` with 0) rather than existing in two variants (ADR-036).

**UI**:
- **Dashboard:** render `HeroSetDashboardState` snapshot. `HeroSetRankHeader` draw ring and rank lines, `HeroSetMissionBars` three bars, `HeroSetDayTracker` redraw at midnight (ADR-031, ADR-012).
- **Workout:** count via `HeroSetRepCounter`, show live metrics from `HeroSetWorkoutMetrics` (no FIT session, ADR-021), hand off to picker on Finish (ADR-024).
- **Picker:** edit signed delta, ±1 per press (ADR-017/029); on save after a workout, feed set trace + saved count to learner (ADR-040).

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

- Names: classes `HeroSet` + PascalCase; methods `camelCase`; private vars `_camelCase`; constants `UPPER_SNAKE`; symbols `:lower_snake`; storage keys `"hero_snake"`.
- Every function has typed params and `as` return type. Cast only after `instanceof` or null guard; no `as Any`.
- Functions ≲30 lines; files ≲250 lines (split by responsibility).
- Catch only what can throw; degrade and flag, never swallow silently.
- Comments explain **why**, not what.

## 7. Decisions

All ADRs, with status and rationale: [`decisions.md`](decisions.md). New durable decisions go there, as new ADR at end.

## 8. Navigation

```
Dashboard (HeroSetView) ── START/Up/Down (or Menu) ──► Main Menu (Menu2)
  Main Menu ── Start <exercise> (menu popped) ──► Workout      [depth 1]
            ── Log <exercise>   (menu popped) ──► Picker       [depth 1]
            ── Connect Sync (dev, toggle in place)
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
```

Every fixed pop count rely on Workout/Picker sitting at depth 1 (ADR-024). Over-popping past dashboard exits app.

## 9. Known technical debt

| Item | Why it's not fixed yet | Fix when |
|---|---|---|
| `HeroSetStore.mc` is 472 lines (budget 250) | Guards user data; bad split corrupts installs (ADR-020) | With device upgrade check (gate 4) |
| Rep detector and learning constants are tuned on synthetic fixtures, not watch recordings (ADR-032/040) | No way yet to pull raw sensor data off watch | When gate 2 trials show misses; record traces with dev build if needed |
| Connect Sync's one-activity-per-day design is unverified and probably broken on device | Out of v1 (ADR-033); needs paused device investigation | Before sync returns to store build |
| Validation log also records in store build (only viewer hidden) | Harmless 30-entry buffer, disclosed in HeroSet privacy page (`../verden-site`); could now be gated with annotation like sync (ADR-033) | If it ever holds anything sensitive |
| Screen-fit audit statics (`HeroSetDraw.misfits`/`boxes`) ship in release build (ADR-034) | One null check per text draw; annotating them out need second `HeroSetDraw.text` | If draw cost ever show up in profiling |
| Physical-device-only failure modes (ADR-022/023) aren't covered by unit tests | Simulator doesn't reproduce them | Keep reading `CIQ_LOG.YAML` after device runs |

## 10. Out of scope

Touch-first interaction, multiple languages, cloud sync, FFT/ML signal processing, GPS/distance tracking, one FIT activity per workout.