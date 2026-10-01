# docker/ — reproducible Connect IQ build + simulator

Two images, built from one `Dockerfile` (SDK 9.2.0, JDK 17, your `Devices/` + `Fonts/`):

| Image | For | Runs as |
|---|---|---|
| `verden-ciq:9.2.0` (`sim`) | tests (`monkeydo` + simulator under Xvfb) | linux/amd64 (Rosetta/QEMU on Apple Silicon) |
| `verden-ciq-build:9.2.0` (`build`) | compiles, `compile_sweep.sh` | native (arm64 on Apple Silicon), ~3-4x faster than emulated |

Every `docker/run.sh` call is a fresh container with its **own simulator** and network, so any number run
in parallel, in the same project folder or different worktrees. Nothing `pkill`s anything on the host.

```bash
docker/build.sh                      # once per machine (~5 min); needs the SDK Manager's Devices/ + Fonts/

# Tests: the projects' own script, opted in with CIQ_DOCKER=1 (same arguments, same exit codes)
CIQ_DOCKER=1 DayArc/tools/run_tests.sh fr965 monkey.pro.jungle
CIQ_DOCKER=1 EXPECT=24 HeroFace/tools/run_tests.sh fr965 monkey.jungle
# HeroSet has no run_tests.sh and builds without strict typecheck:
MC_FLAGS="" docker/run.sh HeroSet /ciq-docker/ciq-test.sh fr965 monkey.jungle

# Compile sweeps / one-off builds: native image
CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh DayArc tools/compile_sweep.sh
CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh DayArc monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg -y /keys/developer_key -w --typecheck 3
```

Notes:
- `ciq-test.sh` builds in a private copy of the project (monkeyc writes `gen/ mir/ internal-mir/` next to
  the sources, which made containers sharing one folder collide) and copies only `bin/t-<device>.{prg,log}` back.
- Tests passed 2026-10-01, all six at once in the real folders (75-89 s each): DayArc simple 20, DayArc Pro 23,
  HeroFace 24, DaysToGo 50, TwoSuns 130, HeroSet 112.
- Base is `ubuntu:jammy` on purpose: the simulator needs `libwebkit2gtk-4.0` + `libsoup-2.4`, gone in 24.04.
  The Linux simulator is x86-64 only; there is no arm64 build to avoid emulation. Docker Desktop → Settings →
  General → "Use Rosetta for x86_64/amd64 emulation" should be on (not verified here).
- Compiler flags: `ciq-test.sh` defaults to `-w --typecheck 3` (all apps but HeroSet); override with `MC_FLAGS`.
- Dev key is mounted read-only at `/keys` at run time, never baked in. The images contain Garmin's device
  files: never push them to a registry.
- New machine: install Docker Desktop, install the Connect IQ SDK Manager once and download devices (gives
  `Devices/` + `Fonts/`), run `docker/build.sh`. Bump `CIQ_SDK_VERSION` in the Dockerfile to upgrade.
- Linux simulator, not a watch. Simulator passing is not device proof.
