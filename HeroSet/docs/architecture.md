# HeroSet Architecture

Target: 80 round watches, AMOLED and MIP, five-button and touch-first (ADR-048), FR965 first (`compatibility.md`), Connect IQ 3.4.0 (ADR-038), Monkey C. How app built today: structure, layers, module duties, style, navigation, known debt. **Why** live in [`decisions.md`](decisions.md) (ADR-NNN refs below point there). Related: [`input-and-ux.md`](input-and-ux.md) (what user see), [`testing-plan.md`](testing-plan.md).

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
│                 HeroSetComplicationPublisher  today's progress for our own
│                                          watch face (private, ADR-044)
│                 HeroSetDelegate          dashboard input → main menu
│                 HeroSetMenuDelegate      Menu2 routing, live menu state
│                 HeroSetSyncCoordinator   Connect sync: visit → activity, laps, log
│                                          (dev; store build: no-op …Off.mc, ADR-043)
├── domain/       HeroSetConfig            every tunable constant
│                 HeroSetRules             XP, rank curve, streaks, goal transitions
│                 HeroSetCalendar          local-day keys and day math
│                 HeroSetRepCounter        tilt/height rep detector (ADR-032)
│                 HeroSetSwingTrace        the running set, counted at every candidate
│                 HeroSetThresholdLearner  threshold belief from saved counts (ADR-040)
├── data/         HeroSetStore             the only persistence API
│                 HeroSetStorage           storage seam (tests inject in-memory)
│                 HeroSetPersistentStorage real Toybox Storage backend
│                 HeroSetClock             day seam (tests control "today")
│                 HeroSetDashboardState    one read of everything the dashboard draws
├── sensor/       HeroSetSensorManager     accelerometer listener lifecycle
│                 HeroSetActivitySync      FIT session + lap/session fields (dev
│                                          only, `(:sync)`; ADR-043)
├── layout/       HeroSetLayout            round-screen geometry
├── ui/
│   ├── dashboard/  HeroSetView, HeroSetDayTracker,
│   │               HeroSetRankHeader (XP ring + rank), HeroSetMissionBars
│   ├── workout/    HeroSetWorkoutView, HeroSetWorkoutDelegate,
│   │               HeroSetWorkoutEndMenuDelegate, HeroSetWorkoutMetrics
│   ├── manual/     HeroSetManualPickerView, HeroSetManualPickerDelegate,
│   │               HeroSetManualExitMenuDelegate
│   ├── settings/   HeroSetGoalPickerView, HeroSetGoalPickerDelegate,
│   │               HeroSetGoalExitMenuDelegate (daily goal, ADR-045)
│   ├── diagnostics/ HeroSetValidationLogView, …Delegate      (dev build only)
│   ├── HeroSetPickerDelegate  shared picker input: one step per press/swipe,
│   │                          save on the START key only (ADR-029/048)
│   ├── HeroSetInput          button-first vs touch-first hints and swipe
│   │                          direction; START-key check (ADR-048)
│   ├── HeroSetExitMenuDelegate  shared Save/Discard/stay back-menu (ADR-036)
│   ├── HeroSetSaveFeedback   store.add / setGoal + save toasts + vibration tiers (rank-up first, ADR-041)
│   ├── HeroSetHaptics        vibration patterns
│   ├── HeroSetText           strings.xml loading and formatting
│   ├── HeroSetPalette        color roles
│   └── HeroSetDraw           measured text/font fitting
└── test/         one *Test.mc per domain/data/layout area, plus
                  HeroSetMotionFixture (physically shaped rep traces) and
                  HeroSetRepCounterHarness (shared test steps)
resources/        English fallback strings, Menu2 menus, launcher icon (dev build)
resources-complications/  private complication for HeroFace; on the resource
                  path of CIQ 4.2+ products only (ADR-044)
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

Dependencies point down only. Sensor classes take plain args, return plain values, and load no UI text (the activity name and unit are passed in); anything needing both sensor and store orchestrated in Presentation (e.g. `HeroSetSyncCoordinator` combine `HeroSetActivitySync` with `HeroSetStore`). `HeroSetDashboardState` lives in `data/` because the store builds it.

## 4. Module responsibilities

**HeroSetConfig**: every tunable number (goals, XP, rank curve, sensor rates, learning tunables, vibration, refresh intervals, log size). Read file; short and commented.

**HeroSetRules**: pure game rules. `xpForReps`; rank curve (`rankCost`, `rankThreshold`, `rankForXp`, `xpIntoRank`, `xpToNextRank`, ADR-031); `nextStreak` (on completion) and `activeStreak` (0 once day missed); `missionComplete`, `crossedGoal` (milestone feedback), `clampDelta` (picker).

**HeroSetCalendar**: `todayKey()` → `YYYYMMDD` from local clock; `isConsecutiveDate` handle month/year/leap rollover (ADR-001).

**HeroSetRepCounter**: turn 25 Hz samples into one signal per exercise: push-ups and sit-ups use tilt swing along deviation's principal axis; squats use leaky double integral of strength, roughly height (`integratesMotion`). Count one rep per full swing past `+threshold` then `-threshold` (or reverse), sides at least `SENSOR_COOLDOWN_MS` apart (ADR-032). Feeds every signal value to its `HeroSetSwingTrace`.

**HeroSetSwingTrace**: the live replay of one set at every candidate threshold (ADR-046). Each turning point of the signal (sub-`TRACE_HYSTERESIS` reversals dropped, capped at `TRACE_MAX_POINTS`) updates `LEARN_BINS` running counters in the sensor callback; `counts()` reads them per bin. Nothing about the set is stored, so the picker's save is O(bins) — the batch replay it replaced tripped the watchdog on a real FR965.

**HeroSetThresholdLearner**: belief over 24 thresholds × keep/drop-last-rep, `updated` from a trace and the saved count, `threshold` (belief median) and `dropsLastRep` for the next set (ADR-040).

**HeroSetStore**: only persistence API; all reads narrow types (ADR-019). Invariants:
- **Local-day reset:** `ensureCurrentDay()` zero daily counts when day key change.
- **No XP farming:** `awardXpFor` pay only for net gain against per-exercise daily credit ratchet capped at `XP_DAILY_CAP_REPS` (100 reps), never at the user goal (ADR-002/045).
- **Goal is store-owned:** `HeroSetStore.getGoal()/setGoal()` (`hero_goal`), passed down as argument (`HeroSetRules`, `HeroSetMissionBars.draw`) or on `HeroSetDashboardState`. Domain and views never read Storage for it.
- **Write failures:** caught, flagged via `hasWriteFailure()` (ADR-010).
- **Flat keys only:** one `hero_*` key per value, spellings fixed by ADR-003; the grouped `hero_daily`/`hero_profile` mirrors were removed as dead weight (ADR-036). `keyFor`/`creditKeyFor` derive from `exerciseKeyString`, the one place an unknown exercise throws.
- **Learned thresholds:** `hero_learning` dict keyed by exercise strings, never Symbols (ADR-022); wrong `model` or malformed state reads as fresh (ADR-040). Old `hero_calibration` profiles not read.
- **Sync state:** `isSyncEnabled` only (ADR-027/043); `hero_sync_day` retired, never reused.
- **Diagnostics log:** `logValidationTrial` (validation trials) and `logDiagnostic` (sync lines), one capped ring buffer read by `getValidationLog` (ADR-026/030).

**HeroSetComplicationPublisher** (ADR-044): packs the dashboard state, today's day key and the last completion day into one private complication value for HeroFace (`../HeroFace`). `valueFor` is pure; `publish` is a no-op below CIQ 4.2.

**HeroSetSensorManager**: register/unregister 25 Hz accelerometer listener. Callers must pass `method(:onSensorData)` (ADR-023).

**HeroSetActivitySync** (dev build; ADR-043): one FIT session. `open()` (session + 5 developer fields, start; false if the watch refuses), `resume()`/`pause()`, `closeLap(name, reps)`, `finish(name, reps, totals)` → save (discards if the watch refuses), `abandon()` → discard; both return whether the watch accepted. Field ids 0–4 match `resources/fitcontributions` and never change.

**HeroSetSyncCoordinator** (dev build; ADR-043): one instance per app (`getApp().getSync()`). Tracks the running set's lap and visit totals, closes a lap when the next set begins, saves (≥ 1 saved workout rep) or discards in `stop()` from `AppBase.onStop`, writes `SYNC NEW/SAVED/EMPTY/OFF/FAIL` to the diagnostics log.

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

Connect Sync on (ADR-043):
  WorkoutView first onShow → Sync.beginSet(exercise)
    → open session (first set) | resume + closeLap(previous set)
  WorkoutView later onShow → Sync.resumeSet · onHide → Sync.pauseSet
  workout save (picker seeded / Back → Save) → Sync.setSaved(reps)
  App.onStop → Sync.stop → finish (save) | abandon (discard)
```

## 6. Code style

- Names: classes `HeroSet` + PascalCase; methods `camelCase`; private vars `_camelCase`; constants `UPPER_SNAKE`; symbols `:lower_snake`; storage keys `"hero_snake"`.
- Every function has typed params and `as` return type. Cast only after `instanceof` or null guard; no `as Any`.
- Functions ≲30 lines; files ≲250 lines (split by responsibility).
- Catch only what can throw; degrade and flag, never swallow silently.
- Comments explain **why**, not what.

## 7. Navigation

```
Dashboard (HeroSetView) ── START/Up/Down (or Menu, tap, swipe) ──► Main Menu (Menu2)
  Main Menu ── Start <exercise> (menu popped) ──► Workout      [depth 1]
            ── Log <exercise>   (menu popped) ──► Picker       [depth 1]
            ── Daily Goal       (menu popped) ──► Goal Picker  [depth 1]
            ── Connect Sync (dev, toggle in place)
            ── Validation Log (dev) ──► log view (above Main Menu)
  Workout ── START key (workout popped) ──► Picker seeded with count [depth 1]
          ── tap ──► nothing (ADR-048)
          ── Back, 0 reps ──► Dashboard
          ── Back, reps ──► Workout End Menu [depth 2]
               Resume/Back ──► Workout (1 pop)
               Save / Discard ──► Dashboard (2 pops)
  Picker  ── START key ──► save, Dashboard (1 pop); tap ──► nothing (ADR-048)
          ── Up/Down or swipe ──► delta ±1 per press (no hold behavior, ADR-029)
          ── Back, delta 0 ──► Dashboard
          ── Back, delta ≠ 0 ──► Manual Exit Menu [depth 2]
               Keep Editing/Back ──► Picker (1 pop)
               Save / Discard ──► Dashboard (2 pops)
  Goal Picker ── same as Picker, ±10 per step; Back with a change ──► the same
               Save/Discard/Keep Editing menu (Goal Exit Menu)
```

Every fixed pop count rely on Workout/Picker sitting at depth 1 (ADR-024). Over-popping past dashboard exits app.

## 8. Known technical debt

| Item | Why it's not fixed yet | Fix when |
|---|---|---|
| `HeroSetStore.mc` is ~340 lines (budget 250); `HeroSetStoreTest.mc` 377 lines | Guards user data; bad split corrupts installs (ADR-020) | With device upgrade check (gate 4) |
| Rep detector and learning constants are tuned on synthetic fixtures, not watch recordings (ADR-032/040) | No way yet to pull raw sensor data off watch | When gate 2 trials show misses; record traces with dev build if needed |
| Connect Sync (one activity per workout, ADR-043) unverified on device | Dev build only until FR965 acceptance (`connect-sync-plan.md` device acceptance) | Before sync goes into the store build |
| Validation log also records in store build (only viewer hidden) | Harmless 30-entry buffer, disclosed in HeroSet privacy page (`../verden-site`); could now be gated with annotation like sync (ADR-033) | If it ever holds anything sensitive |
| Screen-fit audit statics (`HeroSetDraw.misfits`/`boxes`) ship in release build (ADR-034) | One null check per text draw; annotating them out need second `HeroSetDraw.text` | If draw cost ever show up in profiling |
| Physical-device-only failure modes (ADR-022/023) aren't covered by unit tests | Simulator doesn't reproduce them | Keep reading `CIQ_LOG.YAML` after device runs |

## 9. Out of scope

Touch as the primary input for commits (taps never finish or save, ADR-048; swipe replaces UP/DOWN on touch-first watches), cloud sync, FFT/ML signal processing, GPS/distance tracking, one FIT activity per set (ADR-016), one merged activity per day (impossible, ADR-043).