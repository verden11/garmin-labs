# HeroSet testing plan

Pyramid: many deterministic unit tests, simulator workflows, recorded-sensor
tests, fewer physical-watch/beta tests.

## P0: automated unit tests (`source/test/*Test.mc`, `Toybox.Test`)

**Progress/mission** (`HeroSetProgressTest.mc`): zero/partial/complete/over-goal;
independent exercise goals; positive XP/rank thresholds; negative corrections
never go negative; mission completion; same-day no double streak;
consecutive/missed-day streaks; DST (23 h/25 h) and month/year rollover.

**Dates** (`HeroSetCalendarTest.mc` + store): day-key derivation; consecutive-day
across DST/month/year/leap; new date resets counters but preserves XP/streak.

**Store/persistence** (`HeroSetStoreTest.mc`, in-memory `HeroSetStorage` seam +
controllable `HeroSetClock`): net-delta XP (no refunds, no farm loops, no
over-goal inflation); run distance credits per km capped at goal, never touches
reps; rollover/streak semantics; unknown exercise throws; calibration
round-trips, uncalibrated uses defaults; flat-key→grouped migration preserves
progress.

**Rep counter + calibration** (`HeroSetRepCounterTest.mc`,
`HeroSetCalibrationTest.mc`): gravity-removed L2 magnitude, at-rest never
counts; synthetic 10-rep waveform counts exactly 10; calibrated thresholds
recount the same fixture; noise/drift without turning points do not count;
cooldown suppresses fast cadence; reset clears partial cycles; mean/2
thresholds clamped; weak sessions rejected via `isUsable`.

## P1: simulator workflows

Launch/renders; menu from Select and Menu; each session starts/exits;
pause/resume + correction; finish saves; Back with reps asks `Save N reps?`;
relaunch restores; manual picker (+1/+5/+10, −1/−5/−10); Pro Run save/Back
prompt tuning; GPS-unavailable rendering. Simulator proves UI/navigation/
storage determinism, not real rep accuracy.

## P1: physical Forerunner 965

Multi-speed push-ups/squats/sit-ups; correct/partial/unrelated movements;
wrist position + strap tightness; listener cleanup after leaving workout;
30-min battery; GPS acquisition + distance; FIT save + explicit discard; app
suspension/resume, device reboot.

## P2: sensor replay + compatibility

Record real accelerometer data from FR965, replay in simulator, compare vs known
count. Synthetic waveform fixture is the deterministic stand-in until real
recordings exist. Before Store submission: Garmin beta app on each supported
device verifying memory, battery, input, display, sensor, GPS, recording.

## Execution status

1. ✅ Pure progress/date logic extracted (`HeroSetCalendar`, `HeroSetProgress`,
   `HeroSetStore`)
2. ✅ `Toybox.Test` unit tests (calendar/store/progress/layout; rep counter +
   calibration with detector rewrite)
3. ✅ Rep-counting algorithm extracted + fixture (`HeroSetRepCounter`)
4. ☐ Simulator workflow coverage
5. ☐ Forerunner 965 validation
6. ☐ Device-matrix expansion
7. ☐ Beta before Store submission

## Official references

[unit testing](https://developer.garmin.com/connect-iq/core-topics/unit-testing/),
[sensors](https://developer.garmin.com/connect-iq/core-topics/sensors/),
[activity recording](https://developer.garmin.com/connect-iq/core-topics/activity-recording/),
[beta apps](https://developer.garmin.com/connect-iq/core-topics/beta-apps/).