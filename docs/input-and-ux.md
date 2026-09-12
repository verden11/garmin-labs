# Button-first interaction

Fully usable without touch — physical buttons + native Connect IQ menus.

## Navigation contract

**Dashboard**: Select/Menu/Up/Down → mission menu. Back → leave HeroSet.

**Native menus**: Up/Down move, Select activates, Back returns.

**Exercise session**: Select = pause/resume counting. Menu = adjustment actions
(+1/+5/+10, −1/−5/−10, finish). Back = confirm before discarding: if any reps
counted, asks `Save N reps?` (Yes banks, No leaves unsaved); zero reps leaves
directly.

**Manual entry**: Main menu → Manual Entry → exercise. Picker opens at 0 with
add/sub actions (+1/+5/+10, −1/−5/−10); finish banks the value.

**Pro Run**: Select/Menu = stop, save FIT, credit run distance. Back = `Save
run?` (Yes commits activity + credits; No discards FIT without credit). App
shutdown or incoming notification never saves silently.

**Sync boundary**: dashboard progress, reps, XP, streaks, calibration, daily
totals are local. Only an explicitly started Pro Run creates an
`ActivityRecording.Session`; saving it creates a FIT activity Garmin Connect can
sync (may auto-forward to Strava if linked — HeroSet does not control that).

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