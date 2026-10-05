# Sun Window — development

No code exists yet (plan phase P3). The commands below are the target
shape. Simulator runs go through the container by default
([`../../docker/README.md`](../../docker/README.md)), never the host simulator, unless the owner agrees.

## Build

```
monkeyc -d fr965 -f monkey.jungle -o bin/SunWindow.prg \
  -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3
```

Glance scope check (a default build is silent about glance scope leaks):
`tools/glance-scope-check.sh` (copied from HeroSet at plan task P3.2).

## Test

```
tools/run_tests.sh fr965
```

Trust the printed `PASSED (…)` line, not the exit code. Tests run with the
watchdog off; time one full-view run on `fr255s` without `-t` (plan P6.4).

## Sideload

Build an `fr965` debug `.prg` into the worktree's git-ignored
`device-test/` (agents never write to the main checkout), add a row to its README, and copy it to the watch's
`GARMIN/Apps/` folder over USB. Sideloaded builds get no phone settings;
the in-app accent menu works there.

## Simulator and screenshots

The simulator's Settings menu has Set Position, Set GPS Quality and Set
Weather; Simulation > Time Simulation moves the clock (midnight, DST); Force
onHide / onShow and Trigger App Settings exercise the lifecycle and the
settings path; File > View Memory reads peaks
([`../../docker/SIMULATOR.md`](../../docker/SIMULATOR.md) §3). A place
patched into `getInitialView` (never `initialize` or `onStart`, HeroSet
`docs/development.md`) is the fallback only if Set Position does not reach
`Position.getInfo()`. Delete the simulator's stored app settings before each
load (§3 lesson 1). The fr965 simulator opens an app with a glance on the
glance; Down then START opens the full view (probe
`research_notes/Sun Window build plan/probe/tools/open_full_view.sh`).
Simulator weather and place are set by hand: never present them as readings.

## Export

```
monkeyc -e -r -f monkey.jungle -o dist/SunWindow-1.0.0.iq \
  -y ~/.garmin-connectiq/keys/developer_key
```

Check the reported device count against the manifest's product list before
trusting it — see the watch-design-kit plugin's `knowledge/platform-facts.md` "Build/export".
