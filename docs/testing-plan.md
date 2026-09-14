# HeroSet testing plan

Pyramid: many deterministic unit tests, simulator workflows, recorded-sensor
tests, fewer physical-watch/beta tests.

## P0: automated unit tests (`source/test/*Test.mc`, `Toybox.Test`)

**Progress/mission** (`HeroSetRulesTest.mc`): zero/partial/complete/over-goal;
independent exercise goals; positive XP/rank thresholds; negative corrections
never go negative; mission completion; same-day no double streak;
consecutive/missed-day streaks; DST (23 h/25 h) and month/year rollover.

**Dates** (`HeroSetCalendarTest.mc` + store): day-key derivation; consecutive-day
across DST/month/year/leap; new date resets counters but preserves XP/streak.

**Store/persistence** (`HeroSetStoreTest.mc`, in-memory `HeroSetStorage` seam +
controllable `HeroSetClock`): net-delta XP (no refunds, no farm loops, no
over-goal inflation); rollover/streak semantics; unknown exercise throws;
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

## P1: simulator workflows

Launch/renders; menu from Select and Menu; each session starts/exits; Select
("Finish") hands off to the manual picker pre-loaded with the detected count
(ADR-024) and that save lands back on the dashboard; Back with reps asks
`Save N reps?`; relaunch restores; manual delta picker (tap = ±1, held Up/Down
auto-repeats and accelerates, Back with a pending delta asks `Save +N?`), both
from the main menu and post-workout, saving from either entry point returns
to the dashboard. Simulator proves UI/navigation/storage determinism, not
real rep accuracy or real HR/calorie values (not modeled in the simulator).

## P1: physical Forerunner 965

Multi-speed push-ups/squats/sit-ups; correct/partial/unrelated movements;
wrist position + strap tightness; listener cleanup after leaving workout;
30-min battery; app suspension/resume, device reboot; live HR/calorie readout
checked for plausibility; confirm no Garmin Connect activity is created.

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