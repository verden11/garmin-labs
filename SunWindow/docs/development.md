# Sun Window — development

Simulator runs go through the container by default ([`../../docker/README.md`](../../docker/README.md)): each run gets its own
simulator, so any number run at once. The host simulator (`CIQ_DOCKER=0`) only when the owner asks. Everything below is
simulator or compile only, never device proof.

## Build

```
monkeyc -d fr965 -f monkey.jungle -o bin/SunWindow.prg \
  -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3
```

In the container: `CIQ_IMAGE=verden-ciq-build:9.2.0 ../docker/run.sh SunWindow monkeyc -d fr965 -f monkey.jungle -o bin/SunWindow.prg -y /keys/developer_key -w --typecheck 3`
(run from the repo root; the key is mounted at `/keys`). A release-like build with the memory numbers: add `-r --build-stats 0`.

## Test

| What | Command |
|---|---|
| Unit suite on one product | `tools/run_tests.sh <device>`; trust the printed `PASSED (…)` line, not the exit code |
| One test | `tools/run_tests.sh <device> monkey.jungle <testName>` (`everyStateFitsThisDisplay`, `glanceFitsEveryContentArea`, `sunWindowLayoutReport` prints every row's box and the memory) |
| The screen shapes | `tools/fit_all.sh` (13 products: 218 to 466 px round, the 448x486 rectangle, both 1-bit Instincts) |
| Every product | `TAG=-a tools/fit_products.sh id1 id2 …` in as many terminals as you like (shards write `bin/fit-products<TAG>.txt`) |
| Compile every product | `CIQ_IMAGE=verden-ciq-build:9.2.0 ../docker/run.sh SunWindow tools/compile_sweep.sh` (no simulator; zero warnings except the launcher-icon notice) |
| Glance scope | `CIQ_IMAGE=verden-ciq-build:9.2.0 ../docker/run.sh SunWindow tools/glance-scope-check.sh fr965 instincte40mm`: a default build is silent when glance code reaches foreground code, and the watch crashes; this builds at `-l 3` and looks only for that message |
| Generated tests | `python3 tools/gen_sun_tests.py` (from `research_notes/Vitamin D window/solar_elevation_fixtures.py`, plus Apia and Kiritimati for UTC+13/+14), `python3 tools/gen_glance_areas.py` (from the SDK's device files; re-run when the manifest changes) |

Tests run with the watchdog switched off: time one full-view run on `fr255s` (the lowest simulator count, 120,000) without `-t`
before trusting the maths on a wrist (plan P6.4).

## Sideload

Build an `fr965` debug `.prg` and copy it into the watch's `GARMIN/Apps/` folder over USB (the worktree's git-ignored
`device-test/` holds the ones built so far; agents never write to the main checkout's). Sideloaded builds get no phone
settings; the in-app accent menu works there. The steps of the wear day: [`wear-day-checklist.md`](wear-day-checklist.md).

## Simulator and screenshots

`../docker/capture.sh SunWindow tools/shots.sh <device> <tag> "<YYYY-MM-DD HH:MM:SS>" [seed|noseed] [lowuv] [accent]` writes the glance,
the full view and (after a relaunch, once the place is stored) the glance with its state to `bin/shots/<device>-<tag>-*.png`
at native pixels. The container clock is UTC, so the app's offset is 0 and a place at Vilnius's longitude has its window early in
UTC; `seed` patches the place (Vilnius, 54.7 25.3) into `getInitialView` of the private copy, the documented fallback because
Set Position (a menu dialog) has no helper in `docker/sim-gui.sh` yet and was not tried; `lowuv`
patches the weather read to a UV of 1. The simulator's weather, place and clock are set by hand: never present a shot as a
reading. The `nofix` tag waits 75 s to show "No place yet". Delete the simulator's stored app settings before each load (the
script does). The fr965 simulator opens on the glance; Down then START opens the app. Never `getSubscreen()` without
`WatchUi has :getSubscreen`: it crashes the app on watches without a sub-window.

## Export

```
monkeyc -e -r -f monkey.jungle -o dist/SunWindow-1.0.0.iq \
  -y ~/.garmin-connectiq/keys/developer_key
```

Check the reported device count against the manifest's product list before trusting it — see the watch-design-kit plugin's
`knowledge/platform-facts.md` "Build/export". Never commit `dist/*.iq`, `bin/*.prg` or any key file.
