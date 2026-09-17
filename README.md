# HeroSet

A Garmin Forerunner 965 watch app for a daily bodyweight challenge:
**100 push-ups, 100 sit-ups, 100 squats**. Reps are counted automatically
from the wrist accelerometer (beta) and can be corrected by hand. XP, rank and
streak persist; daily counts reset at local midnight. Button-only, no phone
needed.

Goal: publish as a paid app on the Connect IQ Store.

## Status (2026-09-17)

- **Working in the simulator:** counting, manual correction, daily goals,
  XP/rank/streak, dashboard, live HR/calorie readouts. 74 unit tests pass.
- **Not yet proven on a real watch:** automatic counting accuracy (first trials
  were poor) and opt-in Garmin Connect sync (first test suggests the design
  doesn't hold).
- **Not published.** Blockers, in order: [`docs/go-to-market.md`](docs/go-to-market.md)
  → *Status checkpoint*. What the build may honestly claim:
  [`docs/release-contract.md`](docs/release-contract.md).

## Quick start

Requirements: Connect IQ SDK with Forerunner 965 device support, Java 11+, and
a Connect IQ developer key (keep it outside git; see
[`docs/development.md`](docs/development.md#signing-key)).

```bash
# Build the dev app (all screens, incl. calibration)
monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y /path/to/developer_key

# Run it (start the Connect IQ simulator first)
monkeydo bin/HeroSet.prg fr965

# Unit tests: read the printed PASSED/FAILED line; the exit code can be 1 even when all pass
monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y /path/to/developer_key
monkeydo bin/HeroSet-tests.prg fr965 -t

# Release build (calibration and dev log hidden)
monkeyc -d fr965 -f store.jungle -o bin/HeroSet-store.prg -y /path/to/developer_key
```

`monkeyc`/`monkeydo` live in the SDK's `bin/` folder if they're not on your
`PATH`. VS Code users can use the Monkey C extension instead.

## Where to go next

| I want to… | Read |
|---|---|
| Understand the code layout and layers | [`docs/architecture.md`](docs/architecture.md) |
| Know *why* something is the way it is | [`docs/decisions.md`](docs/decisions.md) |
| Change a screen or button behavior | [`docs/input-and-ux.md`](docs/input-and-ux.md) |
| Build, test, debug on a real watch | [`docs/development.md`](docs/development.md) |
| See what's left before launch | [`docs/go-to-market.md`](docs/go-to-market.md) |

Full index: [`docs/README.md`](docs/README.md). Contributor house rules
(typed functions, no magic numbers, measured text fit): `docs/architecture.md`
§6. AI-assistant orientation: [`CLAUDE.md`](CLAUDE.md).

## Repository layout

```text
manifest.xml       app id, target device (fr965), permissions (Sensor, Fit)
monkey.jungle      dev build
store.jungle       release build (overlays resources-store/)
source/            Monkey C: app/ domain/ data/ sensor/ layout/ ui/ test/
resources/         strings, menus, launcher icon
resources-store/   release menu overlay (no calibration, no validation log)
docs/              architecture, decisions, UX, testing, launch plan
bin/               build output (git-ignored)
```
