# Simulator: screenshots and automatic testing

Status 2026-10-04 (heart rate: `sim_activity_data_start`). All runs in container (own simulator, nothing killed on host), **simulator only**, not device proof. Setup, images, run scripts: [`README.md`](README.md).

## 1. How to get a screenshot from the emulator

No pixel read-back in SDK (`Dc.getPixel` does not exist). Screenshot = photo of simulator window or simulator's own "Save Screen Capture". Two tools, pick by need.

| Need | Tool | Output |
|---|---|---|
| Quick look at face on device skin (bezel clip? real fonts?) | `docker/shot.sh <project> <jungle> <device>...` | `<project>/bin/shot-<device>-face.png` (display, 3x, skin + bezel mask), `shot-<device>.png` (whole window, status bar shows memory used / total) |
| Listing screenshot: display at native pixel size, clock, activity data, clock format set | `docker/capture.sh <project> <scenario.sh> [args]` | PNGs scenario saves (454 px on FR965, 176 px on Instinct 2, ...), exactly what File > Save Screen Capture writes |

```bash
docker/shot.sh DaysToGo monkey.jungle instinct2 instincte40mm            # look; FAKETIME="2026-10-04 10:09:00" sets the clock
FLAGS="-r -w" docker/shot.sh TwoSuns monkey.jungle instincte45mm         # a store-like (-r) build: read the memory off the status bar
docker/capture.sh DayArc tools/listing_shots.sh pro                      # writes DayArc/listing-pro/screens/*.png
```

### Scenario scripts (`<project>/tools/listing_shots.sh`)

Scenario = bash file sourced in container after `docker/sim-gui.sh`. Builds in **private copy** of project (repo never touched), writes into `/work/...` (real folder). Helpers:

- `sim_boot "2026-10-04 07:15:00"` starts simulator on that clock (`faketime -f "@..."`: clock runs on from there; bare time freezes it, app never loads). `TZ` does not reach simulator.
- `sim_load <jungle> <device> [monkeyc flags]` builds, runs; `LOAD_WAIT` (default 25 s). Devices with glance (Instinct E, 3 Solar) open on glance in simulator.
- `sim_activity goal=10000 steps=8420 moderate=18 floors=7 calories=1650 history=10000,10000,...` fills Simulation > Activity Monitoring > Set Activity Monitor Info (today's row; dialog placed by reading its window geometry). Faces caching per minute need ~75 s wait after. Seven history rows did not produce multi-day streak in HeroFace.
- `sim_activity_data_start` Simulation > Activity Data > Start and play ("Data Source: Data Simulation"), then closes dialog; simulated activity keeps running, `Sensor.getInfo().heartRate` then returns moving rate (about 120 to 160 in HeroSet runs), dialog's timer, distance, calories count up. Without it heart rate `null` (app reads `--`). Offsets from dialog's centre on simulator window (489x393), retried three times: menu click sometimes does not open it. Cautions: run it **after** app is on wanted screen (done before glance wake, HeroSet glance did not open app); do not combine with `sim_activity` on same run: Activity Monitor Info dialog's Calories value overwritten by simulation, `ActivityMonitor.getInfo().calories` stayed 0 in app for 3 minutes (HeroSet `CAL 0`). HeroSet: `docker/capture.sh HeroSet tools/drive_screens.sh fr965 btn store.jungle 60,45,30 23 glance all act`.
- `sim_24h` switches Settings > Time Display to 24-hour (simulator starts on 12-hour; face with no AM/PM reads 20:00 as 08:00).
- `sim_save <file.png>` File > Save Screen Capture. Deletes existing file first: replace prompt would otherwise swallow save, old picture stays.
- Settings a user would change: edit face's default `properties.xml` in private copy (`set_prop Name "70.3"` with `sed`, see `DaysToGo/tools/listing_shots.sh`). App data a user would produce: put in through app's own code, patched in private copy (HeroSet calls `HeroSetStore.add` once at start, `HeroSet/tools/listing_shots.sh`).
- Simulator also has Settings > Units Display, Set Weather (current, hourly, daily), Set Battery Status, Edit Persistent Storage; menu popups paint black in root screenshot but read fine with `xwd -id <window>`. Add helper to `sim-gui.sh` when needed; read geometry off window, do not hard-code.

### What the simulator's data is

Weather (66 °F, 77/63, 10% rain), stress, Body Battery, heart rate (none until `sim_activity_data_start`, then simulated), battery, calendar event, sun times **canned or random**. Never crop screenshot into claim about real readings; do not use values watch could not produce. Check each picture by eye before it goes anywhere: scripted run proves capture worked, not screen looks right (replaced file, face stuck on glance, state that dropped a row all looked fine to script).

### Existing scenarios

`DaysToGo` (`free`, `pro`), `HeroFace` (`free`, `pro`), `DayArc` (`simple`, `pro`), `HeroSet` (Instinct dashboard, seeded reps), `TwoSuns` (prepared, not run). Pictures written in each project's `listing*/screens/`; order and content in that project's `listing/screenshots.md`.

## 2. What is tested automatically now

Per project, run by hand (no CI yet). All through container: `<Project>/tools/run_tests.sh <device> [jungle]`, `fit_languages.sh`, `compile_sweep.sh`, `check_*.sh`.

| Check | What it proves | Where |
|---|---|---|
| **Unit suite** on a device | logic, layout arithmetic, settings, strings; on real device's own fonts, resolution (test run reports harness's own 8 MB, so memory not measured here) | every project |
| **Screen-fit test** (`everyStateFitsThisDisplay`) | every widest state: no text outside display, no two texts overlapping; on Instinct also **no text under round window, none outside circle bezel leaves visible (about 98 px radius)** | every project; HeroSet `everyScreenFitsThisDisplay` |
| **Per-language fit sweep** (15 languages) | same fit test with each language's strings overlaid (simulator has no CLI language switch) | `HeroSet/tools/fit-sweep.sh`; `fit_languages.sh` in DaysToGo, HeroFace, TwoSuns. DayArc English only |
| **Compile sweep** | every manifest product builds, both tiers, zero warnings (launcher-icon scaling notices counted, not failed); proves round products still build after Instinct changes | `tools/compile_sweep.sh` (HeroSet by loop, see its docs) |
| **Package check** | compiled `.iq`: Free has no Pro key, code or word; Pro has them; Instinct parts have no Accent (or Golden) setting; part numbers equal SDK's | `check_free_package.sh` (DaysToGo, HeroFace, TwoSuns), `DayArc/tools/check_package.sh` |
| **Glance scope check** | code reachable from HeroSet glance process is `(:glance)` (default build silent, watch crashes) | `HeroSet/tools/glance-scope-check.sh` |
| **String parity** | every language has every string, `AppName` only in tier folder | `tools/check_strings.py` |
| **Settings drift** | generated settings files match their table, every key has constant | `TwoSuns/tools/gen_settings.py --check`, DaysToGo `gen_settings.py` |
| **Screenshot + eye** | what unit tests cannot see: bezel clipping, glance, real proportions | `docker/shot.sh` (section 1) |

Counts at last full run (2026-10-03/04): HeroSet dev 116 / store 103; DaysToGo Pro 51, Free 52 (49 / 50 on Instinct); HeroFace 25 (21 on Instinct); DayArc Pro 24, Simple 21 (2026-10-04); TwoSuns Pro 154, Free 67 (146 / 60 on Instinct).

### What is NOT tested automatically

- **Anything on real watch**: sensors, accelerometer rates, GPS/location, real weather, Body Battery, phone settings round trip, battery drain, contrast, legibility in daylight, real bezel margins. (Always-on **can** be simulated, burn-in estimated: section 3. Neither is device proof.)
- **Memory peaks**: unit run does not measure them; read status bar of `-r` shot (`FLAGS="-r -w" docker/shot.sh ...`) after face drew. On-watch Customize menu, pickers, long lists not exercised that way. Two Suns Pro at 45.8 of 59.8 kB on Instinct.
- **Visual quality**: no test says screen looks right; human looks at screenshots.
- **Instinct glance placement** (simulator draws it under round window; HeroSet lays it out around window blind, ADR-055 amended 2026-10-04, a wrist must confirm) and Instinct 2 family for DayArc and Two Suns (no Complications on CIQ 3.4).
- **Round-watch drawing diffs** after layout change: round paths unchanged by construction, round control suites pass, but no old-versus-new pixel comparison exists.

## 3. The simulator's own options (mapped 2026-10-05, SDK 9.2.0, container, fr965)

Menu bar: **File, Settings, Simulation, Data Fields, adb Connection, Help.** Mapped by photographing each menu with `xwd`; items marked *checked* run on Two Suns, worked. Greyed items depend on app type or device.

| Where | Option | What it gives us |
|---|---|---|
| Settings > **Display Mode** | High Power / **Always-On** / Off | *checked:* face enters always-on (onEnterSleep), dims, drifts each minute. `sim_always_on` |
| File > **View Screen Heat Map** (Ctrl+N) | heat map, power mode, Burn-in State, Luminance Usage, **24-Hour Simulation** | *checked:* Two Suns fr965 always-on "no screen burn-in detected, Peak Luminance Usage 1.09%" (Garmin's limit is 10%). `sim_burnin_24h` |
| File | View Watchface Diagnostics (Ctrl+W), Edit Watch Face (Ctrl+E) | greyed on faces tried; likely partial-update power budget, on-watch Customize. Not yet working |
| File | View Memory (Ctrl+M), View Profiler, View HTTP Traffic, Edit Persistent Storage, Reset App Data, Reset Simulator | memory peaks, profiling, Storage edits (Two Suns' remembered place) |
| Settings | Time Display, Units Display, Language, First Day of Week | 12/24 h, statute/metric, **language** (could replace per-language string overlays for real-font check) |
| Settings | Set Weather, Set Position, Set GPS Quality, Set Battery Status, Set Phone Notifications, Set Alarm Count, Set User Profile, Set Training Status | data states faces show: weather rows, Two Suns' place, low battery, notification counts |
| Settings | Sleep Mode, Do Not Disturb, Color Mode, Night Mode, Enhanced Readability Mode, Font Scale, Toggle Touch Screen, Connection Type | system states; Night Mode, Font Scale greyed on fr965 |
| Settings | Force onHide / onShow, **Trigger App Settings**, Trigger Goal | lifecycle, **phone settings change** path (onSettingsChanged), goal-reached events |
| Simulation | Activity Data, Activity Monitoring (`sim_activity`), **Time Simulation**, Background Events, Push Notification, Phone App Message, Complications | live HR, steps/goals, fast-forward clock (midnight flips, window changes), background, complication events |
| Glance | app with glance opens on glance list on glance devices | *checked earlier:* HeroSet's glance (`HeroSet/tools/drive_screens.sh`, step `0b-glance`). Settings > Glance Launch Mode greyed for face |

### Profiling (from Garmin's Profiling article, 2026-10-10)

`monkeyc -k` (`--profile`, confirmed in SDK 9.2.0's `--help`) builds with profiling support. Nothing in `docker/` sets it by default: pass through existing flag hooks (`FLAGS="-r -w -k" docker/shot.sh ...`, `MC_FLAGS="-w --typecheck 3 -k"` for test runner).

- **Simulator:** File > View Profiler, **Start** at point to measure, **Stop**. Profiler > Settings sets sample period that stops it for you.
  Columns: Total Time (us, with callees), **Actual** Time (us, self only), Average Time (us per call), Call Count, Call Stack. Re-sort by each:
  cheap function called thousands of times (draw helper in `onUpdate`) shows in Call Count and Total, not Average.
- **Watch:** build with `-k` (VS Code: Monkey C Compiler Options in workspace settings), `Monkey C: Build for Device`, sideload, run;
  watch writes `<appname>.PRF` to `GARMIN/APPS/LOGS`. Load in simulator's profiler with **Load**. Copy into `device-test/`.
- **Scripted (2026-10-10):** `docker/capture.sh <project> /ciq-docker/profile.sh <jungle> <device> [seconds 30] [tag]` writes
  `<project>/bin/profile/<tag>-<device>/`: `startup-by-{total,calls}-1.png` (table at first Stop: initialize and everything since
  launch, about 15 frames) and `by-{actual,total,calls}-{1,2,3}.png` (30 s steady-state window, sorted by self time / time with callees / Call
  Count, three pages each), plus `APP.PRF` (simulator's own capture; Load reopens it). `-k` build opens Profiler window by itself, collects from launch, so script presses Stop, drags pane splitter right (so Average Time and Call Count show), Start, waits, Stop.
  Person reads PNGs: no screenshot parsed (`APP.PRF` is binary protobuf stream with no function names). Header x positions
  (Total 390, Actual 520, Call Count 775) hit every app's columns, which differ in width; header click flips order whatever column it
  is on, script tracks that. Filter box did not take typed text over xdotool.
- **Limits:** watch **app** (HeroSet) does not attach: window stays on "Load an app to use the profiler", Stop writes no `APP.PRF`, error box blocks rest. Only faces profiled. First `onUpdate` cannot be isolated: profiler only shows totals and per-call average, so worst single call (watchdog's question) needs wrist `.PRF`.
- **Read it with care:** simulator timings are host's emulation, not watch's: `Dc.drawText` and `Dc.clear` dominate every face, says how simulator draws, not what watch spends. **Call Count does not depend on that speed**: divide by `onUpdate`'s count for calls per frame. A finding = our own code repeating unchanged work each frame **and** worth more than a percent of `onUpdate`; absolute `drawText`/`clear` time never one. `-k` adds overhead, so never profile with build that goes to store.
- **First run, fr965, 30 s, 32 `onUpdate` frames per face, all eight face builds (2026-10-10, simulator only): nothing fixed, one borderline left.**
  `onUpdate` averages 36 to 55 ms in simulator (DayArc Pro 55, TwoSuns Pro 48, HeroFace Pro 48, Days To Go Pro 38, Free and Simple
  builds 36 to 52). Self time of every function of ours under 1% of it (DayArc `complicationValue` 13.6 ms and `cellsCovered` 12.5 ms of
  1770 ms; Days To Go `Settings.load` 9 ms of 1228 ms; TwoSuns `Settings.load` 10.6 ms of 1531 ms). Busiest counts trivial helpers
  at 0.2 to 2 us a call (`Array.size`, `permille` 136 a frame, `getFontAscent`). Days To Go re-reads Properties every frame (12 `getValue`
  calls a frame) on purpose (its CLAUDE.md: on-watch picker writes Properties with no callback), 0.4%. DayArc caches plan
  (`DayArcPlanCache`), re-checks each frame. **Borderline, not changed:** TwoSuns rebuilds `skyText` and `sunriseLine` (4 calls a
  frame each, 1.6 to 2.7% of `onUpdate` with callees) and `TwoSunsSources.read` (6 to 7%) every frame from unchanged inputs. Cache
  would cost about 0.2 ms a call in simulator, add state to invalidate, cost memory on face at 45.8 of 59.8 kB on Instinct;
  `TwoSunsSources.mc` also has uncommitted edits from another session. Redraw at 1 Hz is high-power cadence, not defect. Not
  profiled: HeroSet (app: see Limits). Re-run after layout or data-path change, and when face gains per-frame work.

### Recipes built on these (2026-10-05)

- **Watch-framed listing images (chassis and part of strap), any device, no simulator:** `docker/frame_shot.sh <device> <screen.png> <out.png> [scale%]`
  pastes native screenshot under device's own skin (`/root/.Garmin/ConnectIQ/Devices/<dev>/simulator.json`: `image`, and
  `display.location` for where screen goes; skin's display area transparent), keys skin's white background out,
  centres display in 720x720 PNG8 (90 to 110 KB, under store's 150 KB). Round watches scaled to show 454 px
  display; small ones (Instinct, 218 px) 1.6x. Per listing, `docker/frame_listing.sh <listing dir>` reads `src/frames.txt`
  (`<upload name> <device> [scale|-] [source]`; Instinct's source is its native capture in `screens/native/`), writes
  `screens-framed/` plus `bin/framed-preview-<listing>.png`. Device in `frames.txt` must be the one `listing_shots.sh` captured on.
  Good-looking skins (all five projects' manifests): fr965 (yellow strap), fenix847mm, fenix8pro47mm (titanium), epix2pro47mm,
  fr970, fr265, venu3, venu441mm (lilac strap, silver), vivoactive6 (navy); Instinct E 40/45 mm; venusq2 (rectangle); fr255s (small).
- **Edge states of a face:** `docker/capture.sh <project> /ciq-docker/edge_states.sh <jungle> <device> ["YYYY-MM-DD HH:MM:SS"] [tag]`
  saves awake, always-on, always-on a minute later (drift), 24-hour burn-in verdict to `<project>/bin/edge/`. Scenario
  can live in `docker/` (absolute `/ciq-docker/...` path), shared by every project.
- Several containers can capture at once (each has own Xvfb and simulator): eight ran in parallel on 2026-10-05.
- **Lessons from 2026-10-05 runs:** (1) every scenario must delete simulator's stored app settings before each load
  (`rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json`), or changed default (accent, seconds)
  silently ignored: bit HeroFace and DayArc. (2) First `sim_save` after boot sometimes prints `NOT SAVED`; re-take
  that file with scenario's file-name argument. (3) HeroSet's `drive_screens.sh` on `fenix847mm` stayed on glance
  (first START did not open app); fr970, fr265, epix2pro47mm, fr965, instincte45mm work. (4) Heat-map verdict box
  reads black with `xwd`; `import -window root -crop` works. (5) Always-on burn-in, measured: Days To Go 0.84%, Two Suns 1.09%,
  HeroFace 1.23%, DayArc 2.52% peak luminance on fr965 (simulator's own pass mark 10%; not confirmed as Garmin store rule, unverified).
- **Real-clock soak (2026-10-10):** `nohup docker/capture.sh <project> /ciq-docker/soak.sh <jungle> <device> [minutes 1440] [tag] [every 900] [flags -r] [start clock] > log 2>&1 &`
  (start clock such as `"2026-10-10 23:55:30"` runs simulator from there via faketime: midnight and window edges in 10 minutes;
  wrapper scenario under `<project>/bin/` can `sed` private copy's properties first, then `source /ciq-docker/soak.sh ...`)
  runs face on real clock, flips High Power / Always-On at every sample, writes `<project>/bin/soak/<tag>-<device>/`
  as it goes: `samples.csv` (time, mode, simulator alive, error lines in monkeydo's log, display hash), display and
  status-bar memory per sample, `md.log` (crash traces). Launch with `nohup`, not tool's background job: docker passes
  SIGTERM into container. Planted out-of-bounds write caught (`Error: Array Out Of Bounds Error`), so `errors 0` means
  something; two awake samples with same hash mean frozen face. Map `-r` crash address with build's
  `.prg.debug.xml` (`pcToLineNum`). First find: Two Suns Pro 1.2.0 Out Of Memory on Instincts (Two Suns ADR-024 amendment).
- **QA captures:** `docker/capture.sh <project> /ciq-docker/qa_shots.sh <jungle> <device> <tag> <HH:MM>...` (fresh simulator per time,
  default settings, native capture plus window with memory readout). **Environment variables do not reach scenario**
  (`capture.sh` passes none): options go in arguments (tag starting with `h24` selects 24-hour). Memory: status bar
  of 1280x1024 root capture at y 489 (`convert ... -crop 120x22+180+489`); use `FLAGS="-r -w" docker/shot.sh` for
  store-like build (debug builds read about 6 kB higher). Full QA procedure: `reports/QA/Simulator QA 2026-10-05.md`.