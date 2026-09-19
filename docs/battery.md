# Battery impact

Status: 2026-09-19 · analysis only, **no on-device measurement yet**.
Everything below is from reading code; it is the plan for gate 7 (battery
check in `launch-checklist.md`), not a result. Code unchanged by this doc.

## Where power goes

HeroSet uses no GPS, no Wi-Fi/BLE traffic, no background service, no
`Attention.backlight`. Power is spent only while app open, and almost all of
it on workout screen:

| Consumer | Where | When on | Cost |
|---|---|---|---|
| Accelerometer 25 Hz, 1 s batches | `HeroSetSensorManager`, `HeroSetConfig.SENSOR_*` | Workout screen shown | Low: one CPU wake/s, ~25 samples of float math each |
| Optical HR (`setEnabledSensors([SENSOR_ONBOARD_HEARTRATE])`) | `HeroSetWorkoutView.enableHeartRate` | Workout screen shown | Medium: LED sensor likely at higher rate than all-day monitoring |
| Full redraw every 1 s | `HeroSetWorkoutView` refresh timer, `LIVE_REFRESH_MS` | Workout screen shown | Medium on AMOLED: `dc.clear()`, new `HeroSetLayout`, text-fit measurement each tick |
| Vibration per rep (100 ms) | `HeroSetHaptics.rep` | Each detected rep | Low: ~300 short pulses on full day |
| Dashboard day check (60 s) | `HeroSetDayTracker` | Dashboard shown | Negligible: redraw only when day changes |
| Storage writes | `HeroSetStore._set` | Per save, never per rep (dev build also logs a sync line on every workout `onShow`) | Negligible |
| Threshold learning (48 bins × ≤500 trace points) | `HeroSetThresholdLearner.updated` | Once per saved set | Negligible: one short CPU burst |
| `ActivityRecording` session | `HeroSetActivitySync` (`(:sync)`) | **Dev build only**, sync opted in | Low–medium; absent from store build |

Screen: AMOLED power scales with lit pixels. Black background (`HeroSetPalette.BACKGROUND = 0x000000`)
with text-only foreground is already near minimum.

## OK — must not change

- **`SENSOR_SAMPLE_RATE = 25` and `SENSOR_PERIOD_SECONDS = 1`.** Not a battery
  knob. 25 Hz is already lowest standard accelerometer rate and 1 s period
  already batches to one wake per second. More important: `DETECTOR_SMOOTH_SAMPLES`,
  `DETECTOR_BASELINE_SAMPLES`, `DETECTOR_LEAK_SAMPLES` and the flip gap are all
  counted **in samples at this rate**, and per-exercise learner state stored on
  the watch (`setLearningState`, ADR-040) was fitted at 25 Hz. Changing rate
  silently retunes five constants and invalidates stored learning. Above all,
  not before gate-2 re-run (go-to-market item 1).
- **Sensor lifecycle:** listener + HR start in `onShow`, stop in `onHide`
  (`unregisterSensorDataListener`, `setEnabledSensors([])`). Menus pushed over
  workout (Back menu) trigger `onHide`, so sensors pause there too. Keep this
  pairing; ADR-023 callback binding (`method(:onSensorData)`) stays as is.
- **No backlight control, no background process, no GPS.** Keep it that way.
- **Per-rep vibration.** Core affordance (wrist mid-movement, can't look);
  cost tiny.
- **`HeroSetDayTracker` 60 s tick**, stopped in `onHide`.
- **Storage write pattern:** writes only on save/day reset, never in sensor
  callback.
- **Black background / text-only palette** on AMOLED.
- **Store build has no `Fit` permission and no `ActivityRecording`** (ADR-033).

## Must update / verify

Ordered by likely payoff. All pending measurement — none is proven a problem.

1. **No inactivity timeout on workout screen.** Nothing stops accelerometer +
   HR + 1 Hz redraw if user starts a set and walks away (or leaves app open).
   Same code path as the logged accuracy defect (idle phantoms,
   `validation-log.md`): one finding, two symptoms. Caveat: Connect IQ may
   itself time out an idle watch-app back to watch face (fires `onHide`/`onStop`)
   — then drain is bounded, but an in-progress set is **silently lost unsaved**,
   which is the bigger bug. Candidate: after N minutes
   with no detected rep, stop sensors/HR/timer and show a paused state (Back
   menu already has Resume). Needs ADR (tunable in `HeroSetConfig`).
2. **Refresh timer vs display off — verify on watch.** Timer only stops in
   `onHide`. SDK lifecycle docs don't say `onHide` fires when display times out
   or dims, so 1 Hz full redraw likely keeps running against a dark screen.
   Check on FR965 during next session (e.g. `System.println` count in
   `onRefreshTick` with screen off, or battery % over 30 min with screen off
   vs on). If confirmed, item 1 covers most of it.
3. **Workout redraw cost per tick.** `onUpdate` builds a new `HeroSetLayout`,
   runs `firstFitting` over metric candidates and `largestFontInBand` over 4
   number fonts every second, though fonts only change when digit count
   changes. Cache layout (depends only on `dc` size) and chosen count font
   (recompute when `_detected.toString().length()` changes). Keep text-fit
   measured (ADR-018) — cache the measurement, don't guess it.
4. **Is `setEnabledSensors([SENSOR_ONBOARD_HEARTRATE])` needed?** Wrist HR is
   always on for all-day monitoring; `Sensor.getInfo().heartRate` may read
   without it, at lower sensor rate. Also `setEnabledSensors([])` on hide
   replaces the whole enabled list. Test on watch: HR readout with the call
   removed, or swap to `Activity.getActivityInfo().currentHeartRate` (check it
   is non-null with no recording session open — `HeroSetActivitySync.recordedMs`
   already guards null). HR readout is decorative (ADR-021) — if it needs the high-rate
   sensor, make it a setting, don't remove silently.
5. **Measure right build.** `launch-checklist.md` battery line doesn't say which
   build. Dev build adds `ActivityRecording` (if sync on) and validation log →
   pessimistic. Record store build number (or both, labeled).

Not worth doing: lowering sample rate (see above), dropping rep vibration,
reducing dashboard tick, batching storage writes.

## Measurement (gate 7)

Store build, FR965, full charge not required. Note battery % before and after:

- 30 min workout screen, display on (wrist raised / backlight setting).
- 30 min workout screen, display timed out (checks item 2). At end, record
  whether app is still on workout screen with count intact — resolves items
  1 and 2 (system timeout vs none).
- 30 min watch face only, same conditions, as baseline.

Garmin's own strength activity for same 30 min is a fair comparison: HeroSet
should drain no more than it (no GPS either).
