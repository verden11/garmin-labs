# HeroSet

Gamified bodyweight workout app for Garmin Forerunner 965. Daily mission:
push-ups, sit-ups, squats (100 each). Counts reset on the local calendar day;
XP, streaks, and rank persist.

Implemented: automatic rep counting (sensors, calibration-fitted thresholds),
manual correction, per-exercise calibration, XP/rank/streak progression, and
— for auto-counted sets — a real Garmin activity recording (no GPS) so
calories/HR/training effect are computed by Garmin's own engine.

## Project configuration

- App type: Watch App · Target: `fr965` · Min API: 4.2.0 · Language: Monkey C

## Requirements

- Connect IQ SDK + FR965 support, Java 11+
- Monkey C extension (VS Code) or Connect IQ CLI
- Private Connect IQ developer signing key (never commit it)

## Documentation

See [`docs/README.md`](docs/README.md) for the full index.

## Repository layout

```text
manifest.xml       App metadata and target products
monkey.jungle      Dev build (all screens)
store.jungle       Release build (resources-store overlay, no calibration)
source/            Monkey C source (app/ domain/ data/ sensor/ layout/ ui/ test/)
resources/         Dev assets (includes calibration menu)
resources-store/   Release asset overlay
bin/               Build output (git-ignored)
```