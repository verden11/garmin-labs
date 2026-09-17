# HeroSet testing plan

Pyramid: many deterministic unit tests, simulator workflows, recorded-sensor
tests, fewer physical-watch/beta tests.

## P0: automated unit tests (`source/test/*Test.mc`, `Toybox.Test`)

**Rules** (`HeroSetRulesTest.mc`): XP per rep; rank curve (`rankCost` growth and cap,
`rankThreshold` values, `rankForXp` inverting every threshold, a full mission
week lands at rank 5), XP-into-rank and XP-to-next-rank; active streak (0
after a missed day, alive today/yesterday incl. year rollover); picker delta clamp (`clampDelta`); goal-crossing transition
(`crossedGoal`, milestone feedback); negative corrections never go negative; mission completion; same-day no double streak;
consecutive/missed-day streaks; DST (23 h/25 h) and month/year rollover.

**Dates** (`HeroSetCalendarTest.mc` + store): day-key derivation; consecutive-day
across DST/month/year/leap; new date resets counters but preserves XP/streak.

**Store/persistence** (`HeroSetStoreTest.mc`, in-memory `HeroSetStorage` seam +
controllable `HeroSetClock`): legacy flat calibration keys still read and
written; diagnostics log cap and order; sync session day clear; net-delta XP (no refunds, no farm loops, no
over-goal inflation); dashboard snapshot carries XP/rank; rollover/streak
semantics, missed day shows streak 0 until the next completion; unknown exercise throws;
calibration round-trips, uncalibrated uses defaults; flat-key→grouped migration
preserves progress; persisted calibration dictionary is String-keyed (Symbol
dictionary keys/values throw `UnexpectedTypeException` from `Storage.setValue`
and Symbol-key dictionary reads on the 9.2.0 runtime — the test asserts
String keys via `keys()` since probing a Symbol key throws).

**Rep counter + calibration** (`HeroSetRepCounterTest.mc`,
`HeroSetCalibrationTest.mc`): gravity-removed L2 magnitude, at-rest never
counts; synthetic 10-rep waveform counts exactly 10; calibrated thresholds
recount the same fixture; noise/drift without turning points do not count;
cooldown suppresses fast cadence; reset clears partial cycles; mean/2
thresholds clamped; weak sessions rejected via `isUsable`.

**Layout** (`HeroSetLayoutTest.mc`): round chord math; the XP ring fill sweep
never reaches a full circle (`drawArc` draws one when start = end) and
clockwise arc ends normalize into [0, 360).

## P1: simulator workflows

Launch/renders; menu from START, Up/Down and Menu; each session starts/exits; Select
("Finish") hands off to the manual picker pre-loaded with the detected count
(ADR-024) and that save lands back on the dashboard; Back with reps opens
Resume/Save/Discard (Resume keeps counting, Save/Discard land on the
dashboard — never exit the app, ADR-028); relaunch restores; manual delta
picker (each press = ±1, no hold behavior, cannot drop
below minus today's count, Back with a pending delta opens Save/Discard/Keep
Editing), both from the main menu and post-workout, saving or discarding from
either entry point returns to the dashboard; main menu focuses the first
unfinished exercise and shows `N/100`/`DONE` sublabels; no text clips at the
bezel (dashboard with large rank/streak, workout at 3-digit counts, calibration
rejection reasons). Dashboard layout (ADR-031) was checked by measurement: a
temporary test drew states onto a 454×454 `Graphics.createBufferedBitmap` and
printed real font heights and y ranges (RANK 999, `4200 XP TO RANK 61`,
`9999 DAY STREAK`, 100/100 counts, storage warning). Reuse that approach
rather than guessing, but create one bitmap and reuse it: one bitmap per
scenario hung the simulator. Simulator proves UI/navigation/storage
determinism, not real rep accuracy or real HR/calorie values (not modeled in the simulator).

## P1: physical Forerunner 965

Multi-speed push-ups/squats/sit-ups; correct/partial/unrelated movements;
wrist position + strap tightness; listener cleanup after leaving workout;
30-min battery; app suspension/resume, device reboot; live HR/calorie readout
checked for plausibility; with Connect Sync off, confirm no Garmin Connect
activity is created; with it on, run the ADR-030 sync check
(`development.md`).

## P2: sensor replay + compatibility

Record real accelerometer data from FR965, replay in simulator, compare vs known
count. Synthetic waveform fixture is the deterministic stand-in until real
recordings exist. Before Store submission: Garmin beta app on each supported
device verifying memory, battery, input, display, sensor.

## Remaining before Store submission

☐ Simulator workflow coverage ☐ Forerunner 965 validation ☐ Device-matrix
expansion ☐ Beta build

## Official references

[unit testing](https://developer.garmin.com/connect-iq/core-topics/unit-testing/),
[sensors](https://developer.garmin.com/connect-iq/core-topics/sensors/),
[beta apps](https://developer.garmin.com/connect-iq/core-topics/beta-apps/).