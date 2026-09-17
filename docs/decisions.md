# HeroSet decision log (ADRs)

Every durable design decision, newest last. `architecture.md` describes how
the app is built *now*; this file explains *why*. Add a new ADR at the end for
any decision a future contributor would otherwise re-litigate, and mark older
ADRs **Superseded** or **Amended** rather than deleting them.

Numbers 009 and 015 were never recorded.

## Read these first

If you only read five: **ADR-002** (XP can't be farmed), **ADR-018** (measure
text, never guess), **ADR-022/023** (device-only crashes the simulator can't
show), **ADR-024** (navigation depth invariant: wrong pop counts exit the app).

## Index

| ADR | Decision | Status |
|---|---|---|
| 001 | Local calendar day key, no epoch math | Active |
| 002 | XP only for net stored progress | Active |
| 003 | Schema-versioned storage, grouped dictionaries | Active |
| 004 | Gravity-removed turning-point rep detector | Active |
| 005 | 25 Hz sensor; calibration shares the live stream | Active |
| 006 | Shared `HeroSetLayout` geometry | Active |
| 007 | Workout Back → Yes/No confirm | Superseded by 028 |
| 008 | Calibration hidden from the release build | Active |
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
| 025 | Opt-in Connect sync, one activity per day | Active, **unverified; see 030** |
| 026 | On-watch validation log (dev build) | Active |
| 027 | Main menu on `Menu2`; sync is a toggle | Active |
| 028 | UX pass: Back action menus, menu focus, feedback | Active |
| 029 | Button rules: no long-press, bezel names | Active |
| 030 | Sync diagnostics + empty-session guard | Active, investigation open |
| 031 | Dashboard redesign + rank curve | Active |

---

### ADR-001: Local calendar day key
`HeroSetCalendar.todayKey()` = `year*10000 + month*100 + day` from the local
clock (`Gregorian.info`). Never epoch/86400 arithmetic: DST days are 23 or
25 hours, so "same day" / "next day" must compare calendar dates.

### ADR-002: XP only for net stored progress
2 XP per rep (`XP_PER_REP`), credited against a per-exercise daily ratchet
capped at `MISSION_GOAL`. `add(+10)` then `add(-10)` pays once; reps past 100
pay nothing. Max 600 XP a day. Rank and streak build on this, so never award
XP from raw input amounts.

### ADR-003: Schema-versioned storage
`hero_schema` (currently 3). On mismatch, flat keys are mirrored into grouped
dictionaries (`hero_daily`, `hero_profile`, `hero_calibration`). Flat keys are
still written and used as a read fallback, so their spelling must never change
(guarded by `legacyFlatCalibrationKeysStillRead`).

### ADR-004: Rep detector
Accelerometer magnitude, gravity removed with an EMA baseline; one rep = a
positive excursion past `arm` **and** a negative excursion past `release`,
with a cooldown. Thresholds are fitted from calibration cycles (half the mean
excursion, clamped). Exercise-agnostic.

### ADR-005: 25 Hz, one stream
Counting and calibration use the same 25 Hz listener, so calibrated thresholds
match what the counter sees.

### ADR-006: Shared layout layer
All geometry comes from `HeroSetLayout` (round-chord insets, bands, ring). Views
never compute raw pixels.

### ADR-007: Workout Back confirm dialog. **Superseded by ADR-028**
Was a Yes/No "Save N reps?" dialog, which couldn't express "discard".

### ADR-008: Calibration hidden from the release build
`store.jungle` overlays `resources-store/`, whose main menu omits Calibrate and
Validation Log. Calibration returns to the store build only after physical
validation passes (go-to-market gate 1/2).

### ADR-010: Storage write failures
`Storage.setValue` is wrapped in try/catch (`StorageFullException`); the app
keeps running and the dashboard footer shows `! COULD NOT SAVE`.

### ADR-011: No `SensorLogging` permission
Not requested until raw sensor export is actually built.

### ADR-012: Dashboard day refresh
`HeroSetDayTracker` checks every `DAY_CHECK_INTERVAL_MS` (60 s) while the
dashboard is visible and redraws when the local day changes, so counts reset at
midnight without a relaunch.

### ADR-013: One class per file
Filename = class name, `HeroSet` prefix everywhere (Monkey C has no modules).
Test files may hold small test-only helper classes.

### ADR-014: Tests
`(:test)` functions live in `source/test/`, are excluded from normal builds,
and run with `monkeyc -t` + `monkeydo … -t` (`development.md`).

### ADR-016: Per-workout FIT session. **Superseded by ADR-021**
One Garmin Connect activity per set cluttered the Connect/Strava feed.

### ADR-017: Manual entry picker. **Amended by 028, 029**
`HeroSetManualPickerView` edits a signed delta with Up/Down instead of a
`+1/+5/+10` menu. Now: exactly ±1 per press (029), Back opens
Save/Discard/Keep Editing (028).

### ADR-018: Measure text, never guess
Fit is decided by `dc.getTextWidthInPixels` against the round chord
(`HeroSetLayout.fitCenteredY`, `HeroSetDraw`), falling back to shorter wording
or smaller fonts. A "safe character count" clips unpredictably by font/device.

### ADR-019: Narrow stored numbers
Storage returns `Object` (Number *or* Float). Read through
`asNumber`/`asNumberOrNull` (`instanceof` narrowing); calling `.toNumber()` on
`Object` fails to compile on the current SDK.

### ADR-020: `HeroSetStore` size. **Open debt**
472 lines (2026-09-17) against a 250-line budget. Natural splits: schema
migration, calibration profiles, diagnostics log. Deferred because it guards
real user data: do it with the store test suite green *and* a device upgrade
check (go-to-market gate 4), not as a drive-by.

### ADR-021: Workout metrics without a FIT session
Live HR from `Sensor.getInfo().heartRate`; calories = change in
`ActivityMonitor.getInfo().calories` (Garmin's whole-day total) since the set
started. No Training Effect/Load, accepted. (The `Fit` permission came back
for ADR-025 sync only; readouts still don't use a session.)

### ADR-022: Device-only crashes (lesson)
Found in `CIQ_LOG.YAML` from a real FR965; the simulator never reproduced them.
1. `Storage.setValue` throws on **Symbol** dictionary keys/values: the
   calibration dictionary is keyed by exercise *strings*
   (`exerciseKeyString`). Guarded by
   `calibrationDictionaryUsesStringKeysNotSymbols`.
2. An `as Lang.Array` cast on firmware-built accelerometer arrays throws. Read
   `x/y/z` untyped, guard with `instanceof Array`, index directly.

### ADR-023: Sensor listener binding (lesson)
`registerSensorDataListener(self.onSensorData, …)` registers fine but is
**never dispatched** on FR965 firmware (the simulator dispatches it). Use
`method(:onSensorData)` with a `public` method, as in the SDK's PitchCounter
sample. Found by `git bisect` on the device, using persisted breadcrumbs
(technique in `development.md`).

### ADR-024: Finish → picker; depth-1 invariant. **Amended by 028**
No pause/resume. START (Finish) opens the manual picker seeded with the
detected count, so correcting a miscount reuses one UI. **Invariant:** every
caller pops its own view *before* pushing the picker, so the picker always sits
directly on the dashboard. Save/Discard paths pop a fixed count; break the
invariant and they either strand a view or pop past the root, which **exits
the app**. Save feedback is centralized in `HeroSetSaveFeedback`.

### ADR-025: Opt-in Connect sync, one activity per day. **Unverified (see 030)**
Off by default (`Fit` permission, privacy-sensitive). When on, one
`ActivityRecording` session per calendar day, started/stopped around each set
(`SPORT_TRAINING`/`STRENGTH_TRAINING`, no GPS); manual entries don't record.
Relies on `createSession()` returning the still-open session after HeroSet is
closed and reopened. Undocumented by Garmin, and the first device test suggests
it doesn't hold.

### ADR-026: On-watch validation log (dev build)
No reliable way to pull app data off this FR965, so workout-seeded saves log
`mmdd EX detected->saved error` into a capped ring buffer
(`VALIDATION_LOG_MAX_ENTRIES` = 30, flat key, no schema bump). Read it via dev
menu → Validation Log; transcribe into `validation-log.md`.

### ADR-027: `Menu2` main menu; sync toggle
The main menu is `Menu2` so Connect Sync is a `ToggleMenuItem` with visible
On/Off; no confirmation. Resource toggles are static, so
`HeroSetMenuDelegate.prepare` stamps live state before pushing. `Menu2` never
pops itself: every handler pops explicitly. Turning sync off saves the day's
session and clears the stored session day.

### ADR-028: UX pass
- **Back action menus** replace Yes/No: workout `Resume/Save/Discard`,
  picker `Save/Discard/Keep Editing`. Leaving pops 2, resuming pops 1
  (relies on ADR-024).
- **Menu shortcut:** Start items show `42/100`/`DONE`; focus lands on the
  first unfinished exercise.
- **Feedback tiers:** mission complete (toast + 3 pulses) > exercise done
  (+2) > `+N SAVED`; the in-set rep that crosses the goal pulses twice.
- **Honest calibration:** a manual stop can't succeed (10 cycles auto-finish),
  so it reads `STOP`, and rejections say `ONLY n/10 REPS` or `WEAK SIGNAL`.
- Picker delta clamped at `-storedCount`; workout redraws at 1 Hz; all text in
  `strings.xml` via `HeroSetText`; hints in light gray for contrast.

### ADR-029: Button rules
- **No long-press gestures:** holding a button opens watch shortcuts on the
  FR965. The picker is ±1 per press, and calibration ignores Menu.
- **Hints use bezel names:** `START`, `UP/DOWN`, never `SELECT`/`DN`.
- **Sync label** is `Connect Sync` so it isn't cut off by the toggle switch.

### ADR-030: Sync diagnostics + empty-session guard. **Investigation open**
`HeroSetSyncCoordinator` owns the sync day logic and logs `HH:MM SYNC
NEW/KEPT/LOST/SAVED/EMPTY` to the validation log; test steps in
`development.md`. `closeOpenSession` saves only if the session recorded time,
otherwise discards, so a lost session can't become a blank activity.
**First device result (2026-09-16):** `SYNC LOST`, plus two HeroSet activities
in Garmin Connect that HeroSet didn't save. Hypothesis: the watch saves an
unfinished recording when the app closes. Next steps and constraints:
`go-to-market.md` status checkpoint, item 0.

### ADR-031: Dashboard redesign + rank curve
- **Rank curve:** a flat 100 XP/rank gave +6 ranks per full day. Now rank r→r+1
  costs `300 × min(r, 14)` XP: rank 10 ≈ 3 weeks, then 1 rank per full week.
  Rank is derived, never stored, so no migration.
- **Home screen:** gold XP ring on the bezel, `RANK N` + `N XP TO RANK M`,
  thick mission bars (blue in progress, green + `DONE` label when done), streak
  line, footer.
- **Honest streak:** `HeroSetRules.activeStreak` shows 0 once a day is missed.
- **Palette:** `HeroSetPalette` roles: gold = kept progress, blue = today's
  effort, green = done, gray = secondary, red = alert. State never relies on
  color alone.
