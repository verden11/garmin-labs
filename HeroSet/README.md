# HeroSet

Garmin watch app for daily bodyweight challenge:
**100 push-ups, 100 sit-ups, 100 squats**. Reps counted auto from wrist
accelerometer (beta), hand-correctable. XP, rank, streak persist; daily counts
reset at local midnight. Button-only, no phone.

Built on Forerunner 965; 66 more round five-button watches supported,
simulator-checked only — AMOLED (Forerunner 70/165/170/265/570/970, epix Gen 2
and Pro, fēnix 8/9 AMOLED, fēnix E, MARQ Gen 2, D2 Mach, Descent MK3/G2) and
MIP (fēnix 6/7/8 Solar/9 Pro Solar, MARQ Gen 1, Forerunner 255/945 LTE/955,
Enduro and Enduro 3, Descent MK2), Connect IQ 3.4+:
[`docs/compatibility.md`](docs/compatibility.md).

Goal: publish as paid app on Connect IQ Store.

## Status (2026-09-20)

- **v1 uploaded, in Garmin review.** Counting that learns from saved counts
  (ADR-040), manual correction, goals, XP/rank/streak, live HR/calories,
  15 languages. 99 unit tests pass (88 in the store build).
- **Not proven on a wrist:** counting accuracy beyond a few FR965 sets; the
  other 66 watches (simulator only).
- **v1.1 Connect sync:** dev build only, unverified (ADR-043).
- Open items: [`docs/go-to-market.md`](docs/go-to-market.md). Allowed claims:
  [`docs/release-contract.md`](docs/release-contract.md).

## Quick start

Needs: Connect IQ SDK with device support for products you build, Java 11+,
Connect IQ developer key (keep outside git; see
[`docs/development.md`](docs/development.md#signing-key)).

```bash
# Build the dev app (all screens, incl. Validation Log)
monkeyc -d fr965 -f monkey.jungle -o bin/HeroSet.prg -y /path/to/developer_key

# Run it (start the Connect IQ simulator first)
monkeydo bin/HeroSet.prg fr965

# Unit tests: read the printed PASSED/FAILED line; the exit code can be 1 even when all pass
monkeyc -t -d fr965 -f monkey.jungle -o bin/HeroSet-tests.prg -y /path/to/developer_key
monkeydo bin/HeroSet-tests.prg fr965 -t

# Release build (no Connect Sync, no Fit permission, no dev log)
monkeyc -d fr965 -f store.jungle -o bin/HeroSet-store.prg -y /path/to/developer_key

# Store upload package
monkeyc -e -r -f store.jungle -o bin/HeroSet-store.iq -y /path/to/developer_key
```

`monkeyc`/`monkeydo` live in SDK's `bin/` folder if not on `PATH`. VS Code
users can use Monkey C extension instead.

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

## Project layout

```text
manifest.xml       dev build: app id, 80 products, Sensor + Fit + FitContributor
manifest-store.xml release build: same app id, Sensor permission only
monkey.jungle      dev build
store.jungle       release build (manifest-store.xml, resources-store/ overlay)
source/            Monkey C: app/ domain/ data/ sensor/ layout/ ui/ test/
resources/         strings, menus, launcher icon
resources-store/   release menu overlay (no Connect Sync, no validation log)
docs/              architecture, decisions, UX, testing, launch plan
listing/           Connect IQ Store upload images (screens/, cover, hero, device icons; sources in src/)
bin/               build output (git-ignored)
```