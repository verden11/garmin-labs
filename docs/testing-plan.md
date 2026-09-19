# HeroSet testing plan

Pyramid: many deterministic unit tests, simulator workflows, recorded-sensor tests, fewer physical-watch/beta tests.

## P0: automated unit tests (`source/test/*Test.mc`, `Toybox.Test`)

**Rules** (`HeroSetRulesTest.mc`): XP per rep; rank curve (`rankCost` growth + cap, `rankThreshold` values, `rankForXp` inverts every threshold, full mission week lands rank 5), XP-into-rank, XP-to-next-rank; active streak (0 after missed day, alive today/yesterday incl. year rollover); picker delta clamp (`clampDelta`); goal-crossing transition (`crossedGoal`, milestone feedback); negative corrections never go negative; mission completion; same-day no double streak; consecutive/missed-day streaks; DST (23 h/25 h) + month/year rollover.

**Dates** (`HeroSetCalendarTest.mc` + store): day-key derivation; consecutive-day across DST/month/year/leap; new date resets counters but keeps XP/streak.

**Store/persistence** (`HeroSetStoreTest.mc`, in-memory `HeroSetStorage` seam + controllable `HeroSetClock`): learned state round-trips per exercise, stale/malformed state reads as fresh, stored String-keyed (ADR-040); diagnostics log cap + order; sync session day clear; net-delta XP (no refunds, no farm loops, no over-goal inflation); dashboard snapshot carries XP/rank; rollover/streak semantics, missed day shows streak 0 until next completion; unknown exercise throws; calibration round-trips, uncalibrated uses defaults; flat-key→grouped migration keeps progress; persisted calibration dictionary is String-keyed (Symbol dictionary keys/values throw `UnexpectedTypeException` from `Storage.setValue` and Symbol-key dictionary reads on 9.2.0 runtime — test asserts String keys via `keys()` since probing Symbol key throws).

**Rep counter + learning** (`HeroSetRepCounterTest.mc`, `HeroSetThresholdLearnerTest.mc`, traces from `HeroSetMotionFixture` and synthetic swing lists): push-ups (planted hand, 25° forearm tilt), sit-ups (70° torso tilt), squats (45 cm travel) count exactly 10 at four tempos (0.6 s to 2 s per movement, with holds) and while reps slow; still wrist 60 s (at the lowest learnable threshold), knock, slow posture drift never count; trace replay counts what live detector counted at any threshold. Learner: fresh state sits at default; learns to see reps below default, to ignore wobble between reps, to drop a getting-up last swing while still seeing weak reps; one mistyped count doesn't undo agreeing sets; unexplained reps skipped; longest accepted trace learns within watchdog budget. Fixtures reproduced watch first failures on old detector (0/10 push-ups, 19/10 squats), but they models — no replace gate 2 trials.

**Menu** (`HeroSetMenuTest.mc`): `HeroSetMenuDelegate.prepare` on real main menu resource. Run suite with both `monkey.jungle` and `store.jungle`: store menu has no sync toggle, unguarded lookup crashed there (ADR-033).

**Screen fit** (`HeroSetScreenFitTest.mc`): renders every screen in widest state (seeded in-memory store) at running device resolution + fonts; any text outside round display, or two text boxes overlapping on one screen, fails (ADR-034). Run suite in each supported product simulator (`development.md`).

**Localization resources**: each launch resource file must hold same string IDs as English fallback and keep every `$1$`, `$2$`, `$3$` placeholder. Run screen-fit test with `eng`, `deu`, `fre`, `spa`, `ita`, `por`, `dut`, `pol`, `swe`, `dan`, `nob`, `fin`, `tur`, `lit`, `ukr` selected in simulator; translated text not device-validated until checked on physical watches.

**Layout** (`HeroSetLayoutTest.mc`): round chord math; XP ring fill sweep never reaches full circle (`drawArc` draws one when start = end); clockwise arc ends normalize into [0, 360).

## P1: simulator workflows

Launch/renders; menu from START, Up/Down + Menu; each session starts/exits; Select ("Finish") hands off to manual picker pre-loaded with detected count (ADR-024), save lands back on dashboard; Back with reps opens Resume/Save/Discard (Resume keeps counting, Save/Discard land on dashboard — never exit app, ADR-028); relaunch restores; manual delta picker (each press = ±1, no hold behavior, cannot drop below minus today's count, Back with pending delta opens Save/Discard/Keep Editing), both from main menu and post-workout, saving or discarding from either entry point returns to dashboard; main menu focuses first unfinished exercise, shows `N/100`/`DONE` sublabels; save that crosses a rank shows `RANK N!` with four pulses, unless the same save completes the daily mission (that toast wins, ADR-041); no text clips at bezel (dashboard with large rank/streak, workout at 3-digit counts, calibration rejection reasons). Dashboard layout (ADR-031) checked by measurement: temporary test drew states onto 454×454 `Graphics.createBufferedBitmap`, printed real font heights + y ranges (RANK 999, `4200 XP TO RANK 61`, `9999 DAY STREAK`, 100/100 counts, storage warning). Reuse that approach over guessing, but create one bitmap and reuse: one bitmap per scenario hung simulator. Simulator proves UI/navigation/storage determinism, not real rep accuracy or real HR/calorie values (not modeled in simulator).

## P1: physical Forerunner 965

Multi-speed push-ups/squats/sit-ups; correct/partial/unrelated movements; wrist position + strap tightness; listener cleanup after leaving workout; 30-min battery; app suspension/resume, device reboot; live HR/calorie readout checked for plausibility; with store build, confirm no Garmin Connect activity created and main menu has no Connect Sync entry (ADR-033). Sync checks (ADR-030) apply to dev build only.

## P2: sensor replay + compatibility

Record real accelerometer data from FR965, replay in simulator, compare vs known count. `HeroSetMotionFixture` traces are deterministic stand-in until real recordings exist. Before Store submission: Garmin beta app on each supported device verifying memory, battery, input, display, sensor.

## Remaining before Store submission

☐ Simulator workflow coverage ☐ Forerunner 965 validation ☑ Device-matrix expansion, waves 1-4 (simulator) ☐ Beta testers on non-FR965 products ☐ Beta build

## Official references

[unit testing](https://developer.garmin.com/connect-iq/core-topics/unit-testing/),
[sensors](https://developer.garmin.com/connect-iq/core-topics/sensors/),
[beta apps](https://developer.garmin.com/connect-iq/core-topics/beta-apps/).