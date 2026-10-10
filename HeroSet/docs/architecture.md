# HeroSet Architecture

Target: 82 round watches (80 live + 2 Instinct 3 AMOLED unreleased) plus 7 Instinct 1-bit ([ADR-055](decisions.md#adr-055)) and three touch-first rectangles ([ADR-057](decisions.md#adr-057)), AMOLED and MIP, five-button and touch-first ([ADR-048](decisions.md#adr-048)), FR965 first ([`compatibility.md`](compatibility.md)), Connect IQ 3.4.0 ([ADR-038](decisions.md#adr-038)), Monkey C. App as built today: structure, layers, module duties, style, navigation, known debt. **Why** in [`decisions.md`](decisions.md) (ADR-NNN refs below point there). Related: [`input-and-ux.md`](input-and-ux.md) (what user sees), [`testing-plan.md`](testing-plan.md).

## 1. Guiding principles

| # | Principle | Why |
|---|-----------|-----|
| G1 | Pure domain first. Rules in classes, no UI/Storage imports. | Unit test without device. |
| G2 | One class per file; filename = class name ([ADR-013](decisions.md#adr-013)). | Monkey C no module system. |
| G3 | No magic numbers. Tunables = named constants in `HeroSetConfig`. | One place to tune. |
| G4 | Render only in `onUpdate`. Logic in delegates, stores, domain. | No draw-time state change. |
| G5 | Persistent state typed, schema-versioned ([ADR-003](decisions.md#adr-003), [ADR-019](decisions.md#adr-019)). | No silent Number/Float drift. |
| G6 | Back never loses data silently ([ADR-028](decisions.md#adr-028)). | Trust counts. |
| G7 | Geometry via `HeroSetLayout`; text fit measured ([ADR-006](decisions.md#adr-006), [ADR-018](decisions.md#adr-018)). | Round-screen safety. |

## 2. File structure

```
source/
├── app/          HeroSetApp               entry point; builds the store and sync lazily
│                                          (the glance process loads this class, ADR-051)
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
│                 HeroSetGlanceReader      read-only copy of that read for the glance,
│                                          no HeroSetStore, never writes (ADR-051)
├── sensor/       HeroSetSensorManager     accelerometer listener lifecycle
│                 HeroSetActivitySync      FIT session + lap/session fields (dev
│                                          only, `(:sync)`; ADR-043)
├── layout/       HeroSetLayout            round-screen geometry; HeroSetRectTrack (rectangle XP track, ADR-057)
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
│   ├── glance/     HeroSetGlanceView (the glance-list entry: streak/check row +
│   │               three pill bars), HeroSetGlanceLayout (rectangle geometry);
│   │               `(:glance)`, CIQ 4.0+ products only (ADR-051)
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
manifest-store.xml release build: Sensor + ComplicationPublisher; same app id as manifest.xml
```

Builds: `monkey.jungle` = dev (excludes `(:nosync)`), `store.jungle` = release (overlays `resources-store/`, uses `manifest-store.xml`, excludes `(:sync)`; [ADR-033](decisions.md#adr-033)). All user-visible text resource-backed: English fallback in `resources/strings/strings.xml`, language-qualified translations in `resources-<lang>/strings/strings.xml` folders. `HeroSetText` remains runtime access seam.

## 3. Layers

```
Presentation  app/, ui/, layout/     may use anything below, never raw Storage
Sensor        sensor/                Toybox.Sensor / ActivityRecording; no Storage
Data          data/                  Toybox.Application.Storage; the only place
Domain        domain/                Toybox.Lang only (Calendar: Time.Gregorian)
```

**The glance is a second process entry** ([ADR-051](decisions.md#adr-051)). On CIQ 4.0+ products system loads only `(:glance)` code (plus whole `HeroSetApp` class) to draw glance list entry. That code reads Storage through `HeroSetGlanceReader`, never constructs `HeroSetStore`, `HeroSetSyncCoordinator` or anything else outside annotated set; `tools/glance-scope-check.sh` guards it, because default build silent about violations.

Dependencies point down only. Sensor classes take plain args, return plain values, load no UI text (activity name and unit passed in); anything needing both sensor and store orchestrated in Presentation (e.g. `HeroSetSyncCoordinator` combines `HeroSetActivitySync` with `HeroSetStore`). `HeroSetDashboardState` lives in `data/` because store builds it.

## 4. Module responsibilities

**HeroSetConfig**: every tunable number (goals, XP, rank curve, sensor rates, learning tunables, vibration, refresh intervals, log size). Read file; short, commented.

**HeroSetRules**: pure game rules. `xpForReps`; rank curve (`rankCost`, `rankThreshold`, `rankForXp`, `xpIntoRank`, `xpToNextRank`, [ADR-031](decisions.md#adr-031)); `nextStreak` (on completion) and `activeStreak` (0 once day missed); `missionComplete`, `crossedGoal` (milestone feedback), `clampDelta` (picker).

**HeroSetCalendar**: `todayKey()` → `YYYYMMDD` from local clock; `isConsecutiveDate` handles month/year/leap rollover, `previousDayKey` its inverse (undo of today completion, [ADR-058](decisions.md#adr-058)) ([ADR-001](decisions.md#adr-001)).

**HeroSetRepCounter**: turns 25 Hz samples into one signal per exercise: push-ups and sit-ups use tilt swing along deviation's principal axis; squats use leaky double integral of strength, roughly height (`integratesMotion`). One rep per full swing past `+threshold` then `-threshold` (or reverse), sides at least `SENSOR_COOLDOWN_MS` apart ([ADR-032](decisions.md#adr-032)). Feeds every signal value to its `HeroSetSwingTrace`.

**HeroSetSwingTrace**: live replay of one set at every candidate threshold ([ADR-046](decisions.md#adr-046)). Each turning point of signal (sub-`TRACE_HYSTERESIS` reversals dropped, capped at `TRACE_MAX_POINTS`) updates `LEARN_BINS` running counters in sensor callback; `counts()` reads them per bin. Nothing about set stored, so picker's save is O(bins) — batch replay it replaced tripped watchdog on a real FR965.

**HeroSetThresholdLearner**: belief over 24 thresholds × keep/drop-last-rep, `updated` from trace and saved count, `threshold` (belief median) and `dropsLastRep` for next set ([ADR-040](decisions.md#adr-040)).

**HeroSetStore**: only persistence API; all reads narrow types ([ADR-019](decisions.md#adr-019)). Invariants:
- **Local-day reset:** `ensureCurrentDay()` zeroes daily counts when day key changes.
- **No XP farming:** `awardXpFor` pays only for net gain against per-exercise daily credit ratchet capped at `XP_DAILY_CAP_REPS` (100 reps), never at user goal ([ADR-002](decisions.md#adr-002)/[045](decisions.md#adr-045)).
- **Goal is store-owned:** `HeroSetStore.getGoal()/setGoal()` (`hero_goal`), passed down as argument (`HeroSetRules`, `HeroSetMissionBars.draw`) or on `HeroSetDashboardState`. Domain and views never read Storage for it.
- **Write failures:** caught, flagged via `hasWriteFailure()` ([ADR-010](decisions.md#adr-010)).
- **Flat keys only:** one `hero_*` key per value, spellings fixed by [ADR-003](decisions.md#adr-003); grouped `hero_daily`/`hero_profile` mirrors removed as dead weight ([ADR-036](decisions.md#adr-036)). `keyFor`/`creditKeyFor` derive from `exerciseKeyString`, the one place unknown exercise throws.
- **Learned thresholds:** `hero_learning` dict keyed by exercise strings, never Symbols ([ADR-022](decisions.md#adr-022)); wrong `model` or malformed state reads as fresh ([ADR-040](decisions.md#adr-040)). Old `hero_calibration` profiles not read.
- **Sync state:** `isSyncEnabled` only ([ADR-027](decisions.md#adr-027)/[043](decisions.md#adr-043)); `hero_sync_day` retired, never reused.
- **Diagnostics log:** `logValidationTrial` (validation trials) and `logDiagnostic` (sync lines), one capped ring buffer read by `getValidationLog` ([ADR-026](decisions.md#adr-026)/[030](decisions.md#adr-030)).
- **Recoverable workout draft** ([ADR-052](decisions.md#adr-052)): `saveWorkoutDraft`/`getWorkoutDraft`/`clearWorkoutDraft`, checkpoint of live workout screen's in-progress count, not saved value — untouched by XP, streak or complication. Day `0` = no draft; draft for different exercise or earlier day reads as none.

**HeroSetGlanceReader** ([ADR-051](decisions.md#adr-051)): `read(storage, todayKey)` → `HeroSetDashboardState` of today's counts, goal, streak, for glance. Same flat keys and number narrowing as `HeroSetStore` (spellings duplicated on purpose; `HeroSetGlanceReaderTest` compares it with a real store). Never writes: count from earlier day reads 0, streak from `HeroSetRules.activeStreak`, so glance right at 00:01 before app has run `ensureCurrentDay`.

**HeroSetComplicationPublisher** ([ADR-044](decisions.md#adr-044)): packs dashboard state, today's day key, last completion day into one private complication value for HeroFace (`../HeroFace`). `valueFor` pure; `publish` no-op below CIQ 4.2.

**HeroSetSensorManager**: register/unregister 25 Hz accelerometer listener. Callers must pass `method(:onSensorData)` ([ADR-023](decisions.md#adr-023)).

**HeroSetActivitySync** (dev build; [ADR-043](decisions.md#adr-043)): one FIT session. `open()` (session + 5 developer fields, start; false if watch refuses), `resume()`/`pause()`, `closeLap(name, reps)`, `finish(name, reps, totals)` → save (discards if watch refuses), `abandon()` → discard; both return whether watch accepted. Field ids 0–4 match `resources/fitcontributions`, never change.

**HeroSetSyncCoordinator** (dev build; [ADR-043](decisions.md#adr-043)): one instance per app (`getApp().getSync()`). Tracks running set's lap and visit totals, closes lap when next set begins, saves (≥ 1 saved workout rep) or discards in `stop()` from `AppBase.onStop`, writes `SYNC NEW/SAVED/EMPTY/OFF/FAIL` to diagnostics log.

**HeroSetLayout**: chord-aware insets for round screens, content bands, footer rows, dashboard ring geometry, `fitCenteredY` (walk text up off bezel until measurably fits). **HeroSetDraw** builds on it to choose first wording/largest font that fits ([ADR-018](decisions.md#adr-018)): `fits`/`firstFitting`/`largestFont` take radius to measure against (`displayRadius()` with `textMargin()`, or `contentRadius()` with 0) rather than existing in two variants ([ADR-036](decisions.md#adr-036)).

**UI**:
- **Dashboard:** renders `HeroSetDashboardState` snapshot. `HeroSetRankHeader` draws ring and rank lines, `HeroSetMissionBars` three bars, `HeroSetDayTracker` redraws at midnight ([ADR-031](decisions.md#adr-031), [ADR-012](decisions.md#adr-012)).
- **Workout:** counts via `HeroSetRepCounter`, shows live metrics from `HeroSetWorkoutMetrics` (no FIT session, [ADR-021](decisions.md#adr-021)), hands off to picker on Finish ([ADR-024](decisions.md#adr-024)). Seeds from and periodically checkpoints recoverable draft ([ADR-052](decisions.md#adr-052)), cleared at Finish, Save, Discard and no-count Back.
- **Glance:** `HeroSetGlanceView` (`(:glance)`) draws one status row (streak; drawn check and `MISSION COMPLETE` when all three goals met) over three pill bars, in rectangle system gives it, transparent background. Measures and draws own text (`HeroSetDraw` and `HeroSetText` assume round display, not glance code), picks longest wording that fits ([ADR-051](decisions.md#adr-051)). Read-only; selecting it starts app.
- **Picker:** edits signed delta, ±1 per press ([ADR-017](decisions.md#adr-017)/[029](decisions.md#adr-029)); on save after workout, feeds set trace + saved count to learner ([ADR-040](decisions.md#adr-040)).

## 5. Data flow

```
Launch → getInitialView → store built lazily → ensureCurrentDay → publish complication → dashboard
(onStart is empty: it also runs when the system loads the glance, ADR-051)
Glance list → getGlanceView → HeroSetGlanceView.onUpdate → GlanceReader.read(Storage, today) → draw
  (read-only; select → app launch with :launchedFromGlance)

Sensor listener → WorkoutView.onSensorData → RepCounter.feedSample(x, y, z)
  → true: _detected += 1, haptic tap (double on goal crossing), requestUpdate
Workout 1 Hz timer → requestUpdate (HR / calories / elapsed)

START (Finish) → pop workout → push picker(seed = detected)       [depth 1]
Picker save → Store.add(exercise, delta)
  → ensureCurrentDay → clamp ≥ 0 → awardXpFor (ratchet) → updateCompletion (sets, or undoes today on a count save, ADR-058)
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
- Every function typed params and `as` return type. Cast only after `instanceof` or null guard; no `as Any`.
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

Every fixed pop count relies on Workout/Picker at depth 1 ([ADR-024](decisions.md#adr-024)). Over-popping past dashboard exits app.

## 8. Known technical debt

| Item | Why it's not fixed yet | Fix when |
|---|---|---|
| `HeroSetStore.mc` ~340 lines (budget 250); `HeroSetStoreTest.mc` 377 lines | Guards user data; bad split corrupts installs ([ADR-020](decisions.md#adr-020)) | With device upgrade check (gate 4) |
| `HeroSetLayout.mc` ~300 lines (budget 250) | Round and semi-octagon window geometry share same inset functions; rectangle track moved out to `HeroSetRectTrack` (2026-10-06) ([ADR-055](decisions.md#adr-055), [ADR-057](decisions.md#adr-057)) | When fourth screen shape arrives: split window geometry out |
| Rep detector and learning constants tuned on synthetic fixtures, not watch recordings ([ADR-032](decisions.md#adr-032)/[040](decisions.md#adr-040)) | No way yet to pull raw sensor data off watch | When gate 2 trials show misses; record traces with dev build if needed |
| Connect Sync (one activity per workout, [ADR-043](decisions.md#adr-043)) unverified on device | Dev build only until FR965 acceptance ([`connect-sync-plan.md`](archive/connect-sync-plan.md) device acceptance) | Before sync goes into store build |
| Validation log also records in store build (only viewer hidden) | Harmless 30-entry buffer, disclosed in HeroSet privacy page (`../site`); could now be gated with annotation like sync ([ADR-033](decisions.md#adr-033)) | If it ever holds anything sensitive |
| Screen-fit audit statics (`HeroSetDraw.misfits`/`boxes`) ship in release build ([ADR-034](decisions.md#adr-034)) | One null check per text draw; annotating them out needs second `HeroSetDraw.text` | If draw cost ever shows in profiling |
| Physical-device-only failure modes ([ADR-022](decisions.md#adr-022)/[023](decisions.md#adr-023)) not covered by unit tests | Simulator doesn't reproduce them | Keep reading `CIQ_LOG.YAML` after device runs |

## 9. Out of scope

Touch as primary input for commits (taps never finish or save, [ADR-048](decisions.md#adr-048); swipe replaces UP/DOWN on touch-first watches), cloud sync, FFT/ML signal processing, GPS/distance tracking, one FIT activity per set ([ADR-016](decisions.md#adr-016)), one merged activity per day (impossible, [ADR-043](decisions.md#adr-043)).