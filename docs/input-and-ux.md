# Button-first interaction

Fully usable without touch — physical buttons + native Connect IQ menus.

## Navigation contract

**Dashboard**: Select/Menu/Up/Down → mission menu. Back → leave HeroSet.

**Native menus**: Up/Down move, Select activates, Back returns.

**Exercise session**: Select = pause/resume counting (also pauses/resumes the
FIT recording, see below). Menu = adjustment actions (+1/+5/−1, finish). Back
= confirm before discarding: if any reps counted, asks `Save N reps?` (Yes
banks the reps and saves the FIT activity, No leaves both unsaved); zero reps
leaves directly and discards the empty recording.

**Manual entry**: Main menu → Manual Entry → exercise. A continuous delta
picker opens at 0: Up/Down step the delta by 1 per press; holding Up/Down
auto-repeats and accelerates (1 → 2 → 5 per tick the longer it's held), so
large corrections don't take dozens of presses. Select banks the delta. Back
with a non-zero delta asks `Save +N?`/`Save -N?` (Yes banks, No returns to the
picker unchanged); zero delta leaves directly. No FIT session is created —
manual entry has no real elapsed-time/HR signal to attach one to.

**Sync boundary**: reps, XP, streaks, calibration, and daily totals are local
to the watch. Every counted (sensor-driven) workout also records a real Garmin
`ActivityRecording` session (no GPS) so calories/HR/training effect are
computed by Garmin's own engine; saving it (`Save N reps?` → Yes, or Finish)
creates a FIT activity that Garmin Connect processes like any native
activity — it may sync to Strava if the user has that linked, same as any
other Garmin activity; HeroSet does not control that and does not add its own
sync/upload step. Manual entry never creates a FIT activity.

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