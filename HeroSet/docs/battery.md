# Battery impact

Status: 2026-09-20 · code analysis only, **nothing measured yet**. Post-launch backlog (go-to-market).

## Where power goes

No GPS, network, background service or backlight control. Almost all drain is the workout screen:

| Consumer | Where | Cost |
|---|---|---|
| Accelerometer 25 Hz, 1 s batches | `HeroSetSensorManager` | Low |
| Optical HR `setEnabledSensors` | `HeroSetWorkoutView.enableHeartRate` | Medium |
| Full redraw every 1 s | workout refresh timer (`LIVE_REFRESH_MS`) | Medium on AMOLED |
| Vibration per rep | `HeroSetHaptics.rep` | Low |
| `ActivityRecording` session | `HeroSetActivitySync`, dev build, sync on | Low–medium |

Dashboard 60 s day check, storage writes (per save only) and learning (one burst per save) are negligible.

## Don't change

- **25 Hz / 1 s period:** detector constants are counted in samples and stored learning (ADR-040) was fitted at 25 Hz. Changing it retunes everything.
- Sensors + HR start in `onShow`, stop in `onHide`; `method(:onSensorData)` binding (ADR-023).
- Per-rep vibration, black background, no backlight/background/GPS, no recording in store build.

## Candidates (verify on watch first)

1. **No inactivity timeout on the workout screen.** Sensors + HR + redraw run forever if a set is left open. If the system times the app out instead, an unsaved set is **silently lost** — the bigger bug. Candidate: pause after N minutes without a rep (Back menu has Resume). Needs ADR + `HeroSetConfig` tunable.
2. **Redraw with display off:** timer stops only in `onHide`; likely keeps redrawing a dark screen. Item 1 covers most of it.
3. **Redraw cost:** new `HeroSetLayout` + font fitting every second. Cache layout and count font (recompute on digit-count change); keep measuring (ADR-018).
4. **Is `setEnabledSensors([SENSOR_ONBOARD_HEARTRATE])` needed?** `Sensor.getInfo().heartRate` may read at all-day rate without it. HR readout is decorative (ADR-021).

## Measurement (gate 7)

Store build, FR965, battery % before/after, 30 min each: workout screen display on · workout screen display timed out (also note whether the set survived: resolves 1 + 2) · watch face baseline. Should drain no more than Garmin's own strength activity.
