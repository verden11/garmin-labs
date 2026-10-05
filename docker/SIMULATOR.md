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
