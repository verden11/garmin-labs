# HeroSet

Gamified bodyweight workout app for Garmin Forerunner 965. Daily mission:
push-ups, sit-ups, squats (100 each) plus an optional 10 km run. Counts reset
on the local calendar day; XP, streaks, and rank persist.

Implemented: automatic rep counting (sensors, calibration-fitted thresholds),
manual correction, per-exercise calibration, XP/rank/streak progression, and GPS
Pro Run with FIT export.

## Project configuration

- App type: Watch App · Target: `fr965` · Min API: 4.2.0 · Language: Monkey C

## Requirements

- Connect IQ SDK + FR965 support, Java 11+
- Monkey C extension (VS Code) or Connect IQ CLI
- Private Connect IQ developer signing key (never commit it)

## Documentation

- [`docs/development.md`](docs/development.md): setup, build, simulator, tests
- [`docs/architecture.md`](docs/architecture.md): structure, layers, decisions
- [`docs/input-and-ux.md`](docs/input-and-ux.md): button-first interaction contract
- [`docs/release-contract.md`](docs/release-contract.md): what the app can honestly claim
- [`docs/testing-plan.md`](docs/testing-plan.md): test strategy
- [`docs/compatibility.md`](docs/compatibility.md): device support policy
- [`docs/store-release.md`](docs/store-release.md): monetization + release requirements
- [`docs/go-to-market.md`](docs/go-to-market.md): Store launch readiness
- [`docs/calories-connect.md`](docs/calories-connect.md): calorie/FIT integration plan

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