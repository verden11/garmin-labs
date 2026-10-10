# Simulator: screenshots and automatic testing

Status 2026-10-04 (heart rate: `sim_activity_data_start`). Everything here runs in a container (own simulator, nothing killed on the host), is **simulator only**, and is
not device proof. Setup, images and the run scripts: [`README.md`](README.md).

## 1. How to get a screenshot from the emulator

There is no pixel read-back in the SDK (`Dc.getPixel` does not exist), so a screenshot is a photo of the simulator window or the
simulator's own "Save Screen Capture". Two tools, pick by what you need.

| Need | Tool | Output |
|---|---|---|
| A quick look at a face on its device skin (does the bezel clip it? what do the real fonts look like?) | `docker/shot.sh <project> <jungle> <device>...` | `<project>/bin/shot-<device>-face.png` (the display, 3x, with the skin and the bezel mask), `shot-<device>.png` (the whole window, whose status bar shows memory used / total) |
| A listing screenshot: the display at its native pixel size, with the clock, activity data and clock format set | `docker/capture.sh <project> <scenario.sh> [args]` | the PNGs the scenario saves (454 px on an FR965, 176 px on an Instinct 2, ...), exactly what File > Save Screen Capture writes |

```bash
docker/shot.sh DaysToGo monkey.jungle instinct2 instincte40mm            # look; FAKETIME="2026-10-04 10:09:00" sets the clock
FLAGS="-r -w" docker/shot.sh TwoSuns monkey.jungle instincte45mm         # a store-like (-r) build: read the memory off the status bar
docker/capture.sh DayArc tools/listing_shots.sh pro                      # writes DayArc/listing-pro/screens/*.png
```

### Scenario scripts (`<project>/tools/listing_shots.sh`)

A scenario is a bash file sourced inside the container after `docker/sim-gui.sh`. It builds in a **private copy** of the project
(the repo is never touched) and writes into `/work/...` (the real folder). The helpers:

- `sim_boot "2026-10-04 07:15:00"` starts the simulator on that clock (`faketime -f "@..."`: the clock runs on from there; a bare time freezes it and the app never loads). `TZ` does not reach the simulator.
- `sim_load <jungle> <device> [monkeyc flags]` builds and runs; `LOAD_WAIT` (default 25 s). Devices with a glance (Instinct E, 3 Solar) open on the glance in the simulator.
- `sim_activity goal=10000 steps=8420 moderate=18 floors=7 calories=1650 history=10000,10000,...` fills Simulation > Activity Monitoring > Set Activity Monitor Info (today's row; the dialog is placed by reading its window geometry). Faces that cache per minute need a ~75 s wait afterwards. The seven history rows did not produce a multi-day streak in HeroFace.
- `sim_activity_data_start` Simulation > Activity Data > Start and play ("Data Source: Data Simulation"), then closes the dialog; the simulated activity keeps running and `Sensor.getInfo().heartRate` then returns a moving rate (about 120 to 160 in the HeroSet runs), and the dialog's timer, distance and calories count up. Without it the heart rate is `null` (an app reads `--`). Offsets are from the dialog's centre on the simulator window (489x393), retried three times because the menu click sometimes does not open it. Cautions: run it **after** the app is on the screen you want (done before the glance wake, the HeroSet glance did not open the app), and do not combine it with `sim_activity` on the same run: the Activity Monitor Info dialog's Calories value is overwritten by the simulation, and `ActivityMonitor.getInfo().calories` stayed 0 in the app for 3 minutes (HeroSet `CAL 0`). HeroSet: `docker/capture.sh HeroSet tools/drive_screens.sh fr965 btn store.jungle 60,45,30 23 glance all act`.
- `sim_24h` switches Settings > Time Display to 24-hour (the simulator starts on 12-hour, and a face with no AM/PM reads 20:00 as 08:00).
- `sim_save <file.png>` File > Save Screen Capture. It deletes an existing file first: a replace prompt would otherwise swallow the save and the old picture would stay.
- Settings a user would change are set by editing the face's default `properties.xml` in the private copy (`set_prop Name "70.3"` with a `sed`, see `DaysToGo/tools/listing_shots.sh`). App data a user would produce is put in through the app's own code, patched in the private copy (HeroSet calls `HeroSetStore.add` once at start, `HeroSet/tools/listing_shots.sh`).
- The simulator also has Settings > Units Display, Set Weather (current, hourly, daily), Set Battery Status, Edit Persistent Storage; the menu popups paint black in a root screenshot but read fine with `xwd -id <window>`. Add a helper to `sim-gui.sh` when you need one, and read the geometry off the window rather than hard-coding it.

### What the simulator's data is

Weather (66 °F, 77/63, 10% rain), stress, Body Battery, heart rate (none until `sim_activity_data_start`, then simulated), battery, the calendar event and sun times are **canned or random**. Never crop a screenshot into a claim about real readings, and do not use values the watch could not produce. Check each picture by eye before it goes anywhere: the scripted run proves the capture worked, not that the screen looks right (a replaced file, a face stuck on its glance, or a state that dropped a row all looked fine to the script).

### Existing scenarios

`DaysToGo` (`free`, `pro`), `HeroFace` (`free`, `pro`), `DayArc` (`simple`, `pro`), `HeroSet` (the Instinct dashboard, seeded reps), `TwoSuns` (prepared, not run). The pictures they wrote are in each project's `listing*/screens/`; the order and what each shows is in that project's `listing/screenshots.md`.

## 2. What is tested automatically now

Per project, run by hand (no CI yet). All through the container: `<Project>/tools/run_tests.sh <device> [jungle]`, `fit_languages.sh`, `compile_sweep.sh`, `check_*.sh`.

| Check | What it proves | Where |
|---|---|---|
| **Unit suite** on a device | logic, layout arithmetic, settings, strings; on the real device's own fonts and resolution (a test run reports the harness's own 8 MB, so memory is not measured here) | every project |
| **Screen-fit test** (`everyStateFitsThisDisplay`) | every widest state: no text outside the display, no two texts overlapping; on an Instinct also **no text under the round window and none outside the circle the bezel leaves visible (about 98 px radius)** | every project; HeroSet `everyScreenFitsThisDisplay` |
| **Per-language fit sweep** (15 languages) | the same fit test with each language's strings overlaid (the simulator has no CLI language switch) | `HeroSet/tools/fit-sweep.sh`; `fit_languages.sh` in DaysToGo, HeroFace, TwoSuns. DayArc is English only |
| **Compile sweep** | every manifest product builds, both tiers, zero warnings (launcher-icon scaling notices counted, not failed); proves round products still build after Instinct changes | `tools/compile_sweep.sh` (HeroSet by a loop, see its docs) |
| **Package check** | the compiled `.iq`: Free has no Pro key, code or word; Pro has them; Instinct parts have no Accent (or Golden) setting; part numbers equal the SDK's | `check_free_package.sh` (DaysToGo, HeroFace, TwoSuns), `DayArc/tools/check_package.sh` |
| **Glance scope check** | code reachable from the HeroSet glance process is `(:glance)` (the default build is silent, the watch crashes) | `HeroSet/tools/glance-scope-check.sh` |
| **String parity** | every language has every string, `AppName` only in the tier folder | `tools/check_strings.py` |
| **Settings drift** | the generated settings files match their table, every key has a constant | `TwoSuns/tools/gen_settings.py --check`, DaysToGo `gen_settings.py` |
| **Screenshot + eye** | what the unit tests cannot see: bezel clipping, the glance, real proportions | `docker/shot.sh` (section 1) |

Counts at the last full run (2026-10-03/04): HeroSet dev 116 / store 103; DaysToGo Pro 51, Free 52 (49 / 50 on an Instinct); HeroFace 25 (21 on an Instinct); DayArc Pro 24, Simple 21 (2026-10-04); TwoSuns Pro 154, Free 67 (146 / 60 on an Instinct).

### What is NOT tested automatically

- **Anything on a real watch**: sensors and accelerometer rates, GPS/location, real weather and Body Battery, the phone settings round trip, battery drain, contrast and legibility in daylight, the real bezel margins. (Always-on **can** be simulated, and burn-in estimated: section 3. Neither is device proof.)
- **Memory peaks**: the unit run does not measure them; read the status bar of a `-r` shot (`FLAGS="-r -w" docker/shot.sh ...`) after the face drew. The on-watch Customize menu, pickers and long lists are not exercised that way. Two Suns Pro is at 45.8 of 59.8 kB on an Instinct.
- **Visual quality**: no test says a screen looks right; a human looks at the screenshots.
- **The Instinct glance placement** (the simulator draws it under the round window; HeroSet lays it out around the window blind, ADR-055 amended 2026-10-04, a wrist must confirm) and the Instinct 2 family for DayArc and Two Suns (no Complications on CIQ 3.4).
- **Round-watch drawing diffs** after a layout change: the round paths are unchanged by construction and the round control suites pass, but no old-versus-new pixel comparison exists.

## 3. The simulator's own options (mapped 2026-10-05, SDK 9.2.0, container, fr965)

Menu bar: **File, Settings, Simulation, Data Fields, adb Connection, Help.** Mapped by photographing each menu with `xwd`;
the ones marked *checked* were run on Two Suns and worked. Greyed items depend on the app type or device.

| Where | Option | What it gives us |
|---|---|---|
| Settings > **Display Mode** | High Power / **Always-On** / Off | *checked:* the face enters always-on (onEnterSleep), dims and drifts each minute. `sim_always_on` |
| File > **View Screen Heat Map** (Ctrl+N) | heat map, power mode, Burn-in State, Luminance Usage, **24-Hour Simulation** | *checked:* Two Suns fr965 always-on "no screen burn-in detected, Peak Luminance Usage 1.09%" (Garmin's limit is 10%). `sim_burnin_24h` |
| File | View Watchface Diagnostics (Ctrl+W), Edit Watch Face (Ctrl+E) | greyed on the faces tried; likely the partial-update power budget and on-watch Customize. Not yet working |
| File | View Memory (Ctrl+M), View Profiler, View HTTP Traffic, Edit Persistent Storage, Reset App Data, Reset Simulator | memory peaks, profiling, Storage edits (Two Suns' remembered place) |
| Settings | Time Display, Units Display, Language, First Day of Week | 12/24 h, statute/metric, **language** (could replace the per-language string overlays for a real-font check) |
| Settings | Set Weather, Set Position, Set GPS Quality, Set Battery Status, Set Phone Notifications, Set Alarm Count, Set User Profile, Set Training Status | the data states the faces show: weather rows, Two Suns' place, low battery, notification counts |
| Settings | Sleep Mode, Do Not Disturb, Color Mode, Night Mode, Enhanced Readability Mode, Font Scale, Toggle Touch Screen, Connection Type | system states; Night Mode and Font Scale greyed on fr965 |
| Settings | Force onHide / onShow, **Trigger App Settings**, Trigger Goal | lifecycle, the **phone settings change** path (onSettingsChanged), goal-reached events |
| Simulation | Activity Data, Activity Monitoring (`sim_activity`), **Time Simulation**, Background Events, Push Notification, Phone App Message, Complications | live HR, steps/goals, fast-forwarding the clock (midnight flips, window changes), background and complication events |
| Glance | an app with a glance opens on the glance list on glance devices | *checked earlier:* HeroSet's glance (`HeroSet/tools/drive_screens.sh`, step `0b-glance`). Settings > Glance Launch Mode is greyed for a face |

### Profiling (from Garmin's Profiling article, 2026-10-10)

`monkeyc -k` (`--profile`, confirmed in SDK 9.2.0's `--help`) builds with profiling support. Nothing in `docker/` sets it by default: pass it
through the existing flag hooks (`FLAGS="-r -w -k" docker/shot.sh ...`, `MC_FLAGS="-w --typecheck 3 -k"` for the test runner).

- **Simulator:** File > View Profiler, **Start** at the point to measure, **Stop**. Profiler > Settings sets a sample period that stops it for you.
  Columns: Total Time (us, with callees), **Actual** Time (us, self only), Average Time (us per call), Call Count, Call Stack. Re-sort by each:
  a cheap function called thousands of times (a draw helper in `onUpdate`) shows in Call Count and Total, not in Average.
- **Watch:** build with `-k` (VS Code: Monkey C Compiler Options in the workspace settings), `Monkey C: Build for Device`, sideload and run;
  the watch writes `<appname>.PRF` to `GARMIN/APPS/LOGS`. Load it in the simulator's profiler with **Load**. Copy it into `device-test/`.
- **Scripted (2026-10-10):** `docker/capture.sh <project> /ciq-docker/profile.sh <jungle> <device> [seconds 30] [tag]` writes
  `<project>/bin/profile/<tag>-<device>/`: `startup-by-{total,calls}-1.png` (the table at the first Stop: initialize and everything since
  launch, about 15 frames) and `by-{actual,total,calls}-{1,2,3}.png` (a 30 s steady-state window, sorted by self time / time with callees / Call
  Count, three pages each), plus `APP.PRF` (the simulator's own capture; Load reopens it). A `-k` build opens the Profiler window by itself and it
  collects from launch, so the script presses Stop, drags the pane splitter right (so Average Time and Call Count show), Start, waits, Stop.
  A person reads the PNGs: no screenshot is parsed (`APP.PRF` is a binary protobuf stream with no function names). Header x positions
  (Total 390, Actual 520, Call Count 775) hit every app's columns, which differ in width; a header click flips the order whatever column it
  is on, the script tracks that. The Filter box did not take typed text over xdotool.
- **Limits:** a watch **app** (HeroSet) does not attach: the window stays on "Load an app to use the profiler", Stop writes no `APP.PRF` and
  an error box blocks the rest. Only faces are profiled. The first `onUpdate` cannot be isolated: the profiler only shows totals and a
  per-call average, so a worst single call (the watchdog's question) needs a wrist `.PRF`.
- **Read it with care:** simulator timings are the host's emulation, not the watch's: `Dc.drawText` and `Dc.clear` dominate every face, which
  says how the simulator draws, not what a watch spends. **Call Count does not depend on that speed**: divide it by `onUpdate`'s count for
  calls per frame. A finding is our own code repeating unchanged work each frame **and** worth more than a percent of `onUpdate`; absolute
  `drawText`/`clear` time is never one. `-k` adds overhead, so never profile with the build that goes to the store.
- **First run, fr965, 30 s, 32 `onUpdate` frames per face, all eight face builds (2026-10-10, simulator only): nothing fixed, one borderline left.**
  `onUpdate` averages 36 to 55 ms in the simulator (DayArc Pro 55, TwoSuns Pro 48, HeroFace Pro 48, Days To Go Pro 38, Free and Simple
  builds 36 to 52). Self time of every function of ours is under 1% of it (DayArc `complicationValue` 13.6 ms and `cellsCovered` 12.5 ms of
  1770 ms; Days To Go `Settings.load` 9 ms of 1228 ms; TwoSuns `Settings.load` 10.6 ms of 1531 ms). The busiest counts are trivial helpers
  at 0.2 to 2 us a call (`Array.size`, `permille` 136 a frame, `getFontAscent`). Days To Go re-reads Properties every frame (12 `getValue`
  calls a frame) on purpose (its CLAUDE.md: the on-watch picker writes Properties with no callback), 0.4%. DayArc caches its plan
  (`DayArcPlanCache`) and re-checks it each frame. **Borderline, not changed:** TwoSuns rebuilds `skyText` and `sunriseLine` (4 calls a
  frame each, 1.6 to 2.7% of `onUpdate` with their callees) and `TwoSunsSources.read` (6 to 7%) every frame from unchanged inputs. A cache
  would cost about 0.2 ms a call in the simulator, add state to invalidate, and cost memory on a face at 45.8 of 59.8 kB on an Instinct;
  `TwoSunsSources.mc` also has uncommitted edits from another session. Redraw at 1 Hz is the high-power cadence, not a defect. Not
  profiled: HeroSet (an app: see Limits). Re-run after a layout or data-path change, and when a face gains per-frame work.

### Recipes built on these (2026-10-05)

- **Watch-framed listing images (chassis and part of the strap), any device, no simulator:** `docker/frame_shot.sh <device> <screen.png> <out.png> [scale%]`
  pastes a native screenshot under the device's own skin (`/root/.Garmin/ConnectIQ/Devices/<dev>/simulator.json`: `image`, and
  `display.location` for where the screen goes; the skin's display area is transparent), keys the skin's white background out,
  and centres the display in a 720x720 PNG8 (90 to 110 KB, under the store's 150 KB). Round watches are scaled to show a 454 px
  display; small ones (Instinct, 218 px) 1.6x. Per listing, `docker/frame_listing.sh <listing dir>` reads `src/frames.txt`
  (`<upload name> <device> [scale|-] [source]`; an Instinct's source is its native capture in `screens/native/`) and writes
  `screens-framed/` plus `bin/framed-preview-<listing>.png`. The device in `frames.txt` must be the one `listing_shots.sh` captured on.
  Good-looking skins (all five projects' manifests): fr965 (yellow strap), fenix847mm, fenix8pro47mm (titanium), epix2pro47mm,
  fr970, fr265, venu3, venu441mm (lilac strap, silver), vivoactive6 (navy); Instinct E 40/45 mm; venusq2 (rectangle); fr255s (small).
- **Edge states of a face:** `docker/capture.sh <project> /ciq-docker/edge_states.sh <jungle> <device> ["YYYY-MM-DD HH:MM:SS"] [tag]`
  saves awake, always-on, always-on a minute later (the drift) and the 24-hour burn-in verdict to `<project>/bin/edge/`. A scenario
  can live in `docker/` (an absolute `/ciq-docker/...` path) and be shared by every project.
- Several containers can capture at once (each has its own Xvfb and simulator): eight ran in parallel on 2026-10-05.
- **Lessons from the 2026-10-05 runs:** (1) every scenario must delete the simulator's stored app settings before each load
  (`rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json`), or a changed default (an accent, seconds)
  is silently ignored: it bit HeroFace and DayArc. (2) The first `sim_save` after a boot sometimes prints `NOT SAVED`; re-take
  that one file with the scenario's file-name argument. (3) HeroSet's `drive_screens.sh` on `fenix847mm` stayed on the glance
  (the first START did not open the app); fr970, fr265, epix2pro47mm, fr965 and instincte45mm work. (4) The heat-map verdict box
  reads black with `xwd`; `import -window root -crop` works. (5) Always-on burn-in, measured: Days To Go 0.84%, Two Suns 1.09%,
  HeroFace 1.23%, DayArc 2.52% peak luminance on fr965 (the simulator's own pass mark is 10%; not confirmed as a Garmin store rule, unverified).
- **Real-clock soak (2026-10-10):** `nohup docker/capture.sh <project> /ciq-docker/soak.sh <jungle> <device> [minutes 1440] [tag] [every 900] [flags -r] > log 2>&1 &`
  runs a face on the real clock, flips High Power / Always-On at every sample, and writes `<project>/bin/soak/<tag>-<device>/`
  as it goes: `samples.csv` (time, mode, simulator alive, error lines in monkeydo's log, display hash), the display and the
  status-bar memory per sample, `md.log` (crash traces). Launch with `nohup`, not a tool's background job: docker passes a
  SIGTERM into the container. A planted out-of-bounds write was caught (`Error: Array Out Of Bounds Error`), so `errors 0` means
  something; two awake samples with the same hash mean a frozen face. Map a `-r` crash address with the build's
  `.prg.debug.xml` (`pcToLineNum`). First find: Two Suns Pro 1.2.0 Out Of Memory on the Instincts (Two Suns ADR-024 amendment).
- **QA captures:** `docker/capture.sh <project> /ciq-docker/qa_shots.sh <jungle> <device> <tag> <HH:MM>...` (fresh simulator per time,
  default settings, native capture plus the window with its memory readout). **Environment variables do not reach a scenario**
  (`capture.sh` passes none): options go in the arguments (a tag starting with `h24` selects 24-hour). Memory: the status bar
  of a 1280x1024 root capture sits at y 489 (`convert ... -crop 120x22+180+489`); use `FLAGS="-r -w" docker/shot.sh` for a
  store-like build (debug builds read about 6 kB higher). The full QA procedure: `reports/QA/Simulator QA 2026-10-05.md`.
