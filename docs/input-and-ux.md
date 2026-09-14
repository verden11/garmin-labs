# Button-first interaction

Fully usable without touch — physical buttons + native Connect IQ menus.

## Navigation contract

**Dashboard**: Select/Menu/Up/Down → mission menu. Back → leave HeroSet.

**Native menus**: Up/Down move, Select activates, Back returns.

**Exercise session**: counting starts the instant the screen opens — no
pause/resume, no adjustment menu. Select = Finish, which opens the manual
delta picker (below) pre-loaded with the detected count so a miscount can be
corrected before it's saved — nothing is banked until the picker is saved.
Back = confirm before discarding: if any reps counted, asks `Save N reps?`
(Yes banks the detected count as-is, no correction step, and returns to the
dashboard; No discards and resumes counting). Live HR and an
estimated-calories-for-this-set readout show during the session (ADR-021) —
no FIT activity is created.

**Manual entry**: Main menu → Manual Entry → exercise, or automatically after
finishing a workout set (ADR-024). A continuous delta picker opens (at 0 from
the menu, at the detected count after a workout): Up/Down step the delta by 1
per press; holding Up/Down auto-repeats and accelerates (1 → 2 → 5 per tick
the longer it's held), so large corrections don't take dozens of presses.
Select banks the delta and returns to the dashboard. Back with a non-zero
delta asks `Save +N?`/`Save -N?` (Yes banks and returns to the dashboard, No
returns to the picker unchanged); zero delta leaves directly. Saving (either
path) shows a toast — `+N SAVED` normally, `DAILY MISSION COMPLETE!` with a
distinct vibration the moment this save completes all 3 daily goals for the
first time that day.

**Sync boundary**: everything HeroSet tracks — reps, XP, streaks, calibration,
daily totals, live HR/calorie readouts — is local to the watch. HeroSet never
creates a FIT activity and never touches Garmin Connect/Strava sync (ADR-021).

## Calibration

Independent per-exercise profiles for push-ups/situps/squats, from the same
live accelerometer signal as counting — thresholds reflect the user's watch
position and movement style.

- Main menu → Calibrate Exercise → select exercise → Select starts capture.
- Perform ten natural reps; auto-finishes at ten. Select/Menu finishes early.
- A session with fewer than ten strong cycles is rejected (no profile replace).
- Back leaves without replacing the previous profile.
- First release: thresholds = half the mean counted cycle excursion (peak/valley
  each). Recalibrate when switching wrists, changing strap position, or when
  live counting drifts.

No critical action may require a touch target; touch may be added later as an
accelerator only.