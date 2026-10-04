# docker/ — reproducible Connect IQ build + simulator

Two images, built from one `Dockerfile` (SDK 9.2.0, JDK 17, your `Devices/` + `Fonts/`):

| Image | For | Runs as |
|---|---|---|
| `verden-ciq:9.2.0` (`sim`) | tests (`monkeydo` + simulator under Xvfb) | linux/amd64 (Rosetta/QEMU on Apple Silicon) |
| `verden-ciq-build:9.2.0` (`build`) | compiles, `compile_sweep.sh` | native (arm64 on Apple Silicon), ~3-4x faster than emulated |
| `verden-ciq-shots:9.2.0` (`shots`) | `shot.sh`, `capture.sh`: simulator screenshots (the sim image + `xwd`, ImageMagick, `xdotool`, `faketime`) | linux/amd64 |

Every `docker/run.sh` call is a fresh container with its **own simulator** and network, so any number run
in parallel, in the same project folder or different worktrees. Nothing `pkill`s anything on the host.

```bash
docker/build.sh                      # once per machine (~5 min); needs the SDK Manager's Devices/ + Fonts/

# Tests: the projects' own scripts. Container is the DEFAULT; arguments and exit codes unchanged.
DayArc/tools/run_tests.sh fr965 monkey.pro.jungle
EXPECT=24 HeroFace/tools/run_tests.sh fr965 monkey.jungle
HeroSet/tools/fit-sweep.sh -l "eng ukr" fr965          # per-language fit sweeps run in a container too
DaysToGo/tools/fit_languages.sh -l "eng ukr" fr965
# Host (macOS) simulator instead: CIQ_DOCKER=0 <script> ... (see "Host simulator" below)
# HeroSet has no run_tests.sh and builds without strict typecheck:
MC_FLAGS="" docker/run.sh HeroSet /ciq-docker/ciq-test.sh fr965 monkey.jungle

# Screenshot the simulator (the face on its device skin, real fonts, real bezel mask): bin/shot-<device>-face.png
docker/shot.sh DaysToGo monkey.jungle instinct2 instincte40mm

# Listing screenshots at native pixels, with the simulator's clock and activity data set (xdotool + faketime):
docker/capture.sh DayArc tools/listing_shots.sh pro      # writes DayArc/listing-pro/screens/*.png; helpers in docker/sim-gui.sh

# Compile sweeps / one-off builds: native image
CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh DayArc tools/compile_sweep.sh
CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh DayArc monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg -y /keys/developer_key -w --typecheck 3
```

Host simulator: `CIQ_DOCKER=0` runs the old macOS flow (one simulator per machine, `pkill`s on a wedge). Use it only
for final pre-release verification, when the owner asks (or agrees to your suggestion). Default is the container.

Notes:
- `ciq-test.sh` builds in a private copy of the project (monkeyc writes `gen/ mir/ internal-mir/` next to
  the sources, which made containers sharing one folder collide) and copies only `bin/t-<device>.{prg,log}` back.
- Ported: `ciq-run.sh` (private copy + Xvfb + simulator, then your command) runs the two zsh sweep scripts, which
  is why the images carry `zsh`. Checked 2026-10-01: `fit-sweep.sh` eng+ukr on fr965 112/112; `fit_languages.sh`
  eng+ukr on fr965 both fit tests PASS (the translated word tests error by design, see the script header).
- Scripts delegate unless `CIQ_IN_DOCKER` is set (the images set it) or `CIQ_DOCKER=0`. No Docker or no image: a clear error.
- HeroSet has no `run_tests.sh`; use `MC_FLAGS="" docker/run.sh HeroSet /ciq-docker/ciq-test.sh ...` as above.
- Also checked 2026-10-01/02 (Linux simulator): default hook on HeroFace Free 24/24, DaysToGo Free 51/51, TwoSuns Free
  67/67; rectangular `venusq2` 23/23; forced simulator wedge restarts once then passes; TwoSuns `fit_all.sh` Free,
  10/10 devices 67/67; native compile sweeps both jungles: HeroFace 117/117, DaysToGo 120/120, TwoSuns 69/69.
  Not tried: a clean-machine `build.sh`, a full 69-product fit sweep.
- Tests passed 2026-10-01, all six at once in the real folders (75-89 s each): DayArc simple 20, DayArc Pro 23,
  HeroFace 24, DaysToGo 50, TwoSuns 130, HeroSet 112. Counts have grown since: see the OrbStack run below (HeroFace
  is 25, so `EXPECT=24` now exits 4 while every test passes).
- Base is `ubuntu:jammy` on purpose: the simulator needs `libwebkit2gtk-4.0` + `libsoup-2.4`, gone in 24.04.
  The Linux simulator is x86-64 only; there is no arm64 build to avoid emulation. Docker Desktop → Settings →
  General → "Use Rosetta for x86_64/amd64 emulation" should be on (not verified here). OrbStack uses Rosetta by default.
- Compiler flags: `ciq-test.sh` defaults to `-w --typecheck 3` (all apps but HeroSet); override with `MC_FLAGS`.
- Dev key is mounted read-only at `/keys` at run time, never baked in. The images contain Garmin's device
  files: never push them to a registry.
- New machine: install Docker Desktop or OrbStack (see "OrbStack" below), install the Connect IQ SDK Manager once and download devices (gives
  `Devices/` + `Fonts/`), run `docker/build.sh`. Bump `CIQ_SDK_VERSION` in the Dockerfile to upgrade.
- Linux simulator, not a watch. Simulator passing is not device proof.
- `capture.sh` / `sim-gui.sh` (2026-10-04): a scenario script (per project, `tools/listing_shots.sh`) boots the simulator on a fake clock (`sim_boot "2026-10-04 07:15:00"`), loads a build, sets activity data through the Simulation menu's dialog (`sim_activity`), switches the time to 24-hour (`sim_24h`) and saves with File > Save Screen Capture (`sim_save`), which writes the display at its native pixel size (no skin). GUI coordinates were read off the simulator on the 1280x1024 virtual screen; the activity dialog is placed by reading its window geometry. Menu popups paint black in a screenshot of the root window but can be read with `xwd -id <window>`. `sim_save` removes an existing file first: a replace prompt would otherwise swallow the save.

## OrbStack (tried 2026-10-04, an alternative to Docker Desktop)

Same `docker` CLI, so no script changed. `brew install orbstack`, `orb start`, `docker context use orbstack` (and
`docker context use desktop-linux` to go back). **Images live per engine**: switching context means `docker/build.sh` again
(5 min 26 s on an M-series Mac, 8 CPUs).

Checked on OrbStack 2.2.3, macOS, 16 GB, fr965, default memory cap (8 GiB, half the RAM):
- **Six suites at once**, real folders, 103 s wall (70-96 s each): DayArc simple 20, DayArc Pro 23, DaysToGo 51, HeroFace 25,
  TwoSuns 154, HeroSet 115, all PASSED. A container peaked at 0.4-1.4 GiB (builds and simulators); most stayed under 1 GiB.
- `docker/shot.sh DaysToGo monkey.jungle fr965 instinct2`: 109 s, skin, fonts and the Instinct bezel mask drawn correctly.
- `docker/capture.sh DayArc tools/listing_shots.sh pro`: six PNGs, exit 0, 913 s while four other containers ran on the same
  engine. Four of six are byte-identical to the committed ones; the other two differ only in the simulator's live fake sensor
  data (heart rate, stress), not in layout.

Why you might want it: Docker Desktop's VM was set to 15.6 GiB (nearly all of a 16 GB Mac); OrbStack's VM grows on demand
and gives memory back (about 2.2 GB resident right after the six-suite run). Change the cap with
`orbctl config set memory_mib 10240`.

Caveats:
- **Licence.** Free for personal use only; this studio sells apps, so it needs Pro (USD 8 per user per month) after the
  30-day trial. Owner's call: ROADMAP 10.14.
- **One engine, every session.** All Claude sessions and worktrees share it, so `docker ps` shows other sessions'
  containers. Do not `docker kill`/`prune` what you did not start; the 8 GiB cap is shared too.
- Rosetta covers x86-64-v2 only; the simulator and SDK run fine on it, but a binary needing v3 would not.
- Not compared head to head with Docker Desktop (no timings of the same run there), not tried: a full fit sweep, more
  than nine containers at once.

Screenshots from the simulator, scenario scripts, and the list of what is tested automatically (and what is not): [`SIMULATOR.md`](SIMULATOR.md).
