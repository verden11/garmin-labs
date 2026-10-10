# Battery impact

Status: 2026-09-26 · code analysis only, **nothing measured yet**. Post-launch backlog (`docs/status.md`).

## Where power goes

No GPS, network, background service, backlight control. Almost all drain = workout screen:

| Consumer | Where | Cost |
|---|---|---|
| Accelerometer 25 Hz, 1 s batches | `HeroSetSensorManager` | Low |
| Optical HR `setEnabledSensors` | `HeroSetWorkoutView.enableHeartRate` | Medium |
| Full redraw every 1 s | workout refresh timer (`LIVE_REFRESH_MS`) | Medium on AMOLED |
| Vibration per rep | `HeroSetHaptics.rep` | Low |
| `ActivityRecording` session | `HeroSetActivitySync`, dev build, sync on | Low–medium |

Dashboard 60 s day check, storage writes (per save only), learning (one burst per save) negligible.

## Don't change

- **25 Hz / 1 s period:** detector constants counted in samples; stored learning ([ADR-040](decisions.md#adr-040)) fitted at 25 Hz. Change -> retunes everything.
- Sensors + HR start in `onShow`, stop in `onHide`; `method(:onSensorData)` binding ([ADR-023](decisions.md#adr-023)).
- Per-rep vibration, black background, no backlight/background/GPS, no recording in store build.

## Candidates (verify on watch first)

1. **No inactivity timeout on workout screen.** Sensors + HR + redraw run forever if set left open — separate from, still open: candidate, pause after N minutes without rep (Back menu has Resume). **System-level timeout for app launched from glance = different, sharper case, no longer silently lossy**: confirmed on FR965 at exactly 120s (redraws don't reset it), fixed same day by [ADR-052](decisions.md#adr-052)'s periodic recoverable draft — gate E1-retest in [`status.md`](status.md) still owed on a watch.
2. **Redraw with display off:** timer stops only in `onHide`; likely keeps redrawing dark screen. Item 1 covers most.
3. **Redraw cost:** new `HeroSetLayout` + font fitting every second. Cache layout and count font (recompute on digit-count change); keep measuring ([ADR-018](decisions.md#adr-018)).
4. **Is `setEnabledSensors([SENSOR_ONBOARD_HEARTRATE])` needed?** `Sensor.getInfo().heartRate` may read at all-day rate without it. HR readout decorative ([ADR-021](decisions.md#adr-021)).

## Measurement (gate 7)

Store build, FR965, battery % before/after, 30 min each: workout screen display on · workout screen display timed out (also note whether set survived: resolves 1 + 2) · watch face baseline. Should drain no more than Garmin's own strength activity.