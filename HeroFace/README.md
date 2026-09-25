# HeroFace

A Garmin watch face from Verden, in HeroSet's visual language: the time in the
middle, today's three goals as mission bars, and a progress ring on the bezel.

It works on its own. The bars show **steps, intensity minutes and floors**, the
ring shows how the whole day is going, and a gold line counts the days in a row
you hit your step goal. On watches with Connect IQ 4.2+ and
[HeroSet](../HeroSet) installed, the bars can switch to your push-ups, sit-ups
and squats, with your HeroSet rank and streak.

117 round watches, Connect IQ 3.0 and up, in 15 languages:
[`docs/compatibility.md`](docs/compatibility.md).

## Build

```bash
# Developer key (kept outside the repo, never committed)
KEY=~/.garmin-connectiq/keys/developer_key

monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y $KEY
monkeydo bin/HeroFace.prg fr965            # with the simulator running

# Tests (16)
monkeyc -t -d fr965 -f monkey.jungle -o bin/t-fr965.prg -y $KEY
monkeydo bin/t-fr965.prg fr965 -t

# Store upload package
monkeyc -e -r -f monkey.jungle -o dist/HeroFace.iq -y $KEY
```

`monkeyc`/`monkeydo` live in the SDK's `bin/` folder if they aren't on `PATH`.

`everyStateFitsThisDisplay` renders the face in its widest states at the
device's real resolution and fonts, and fails on text that leaves the round
display or overlaps another row. Run it for a device per screen size after any
layout or string change. `heroFaceLayoutReport` prints every row's box for that
device, which is how layout is checked without a screenshot.

## What it shows

| Row | Everyday | With HeroSet |
|---|---|---|
| Ring | how far today's three goals have come, together | XP into the current rank |
| Top line | days in a row the step goal was met | rank and HeroSet streak |
| Centre | time (+ optional seconds) | same |
| Under it | date and, where supported, temperature | same |
| Bars | steps · intensity minutes · floors | push-ups · sit-ups · squats |
| Bottom | battery · heart rate · notifications | same |

Each bar falls back to a metric the watch actually has: no barometer means the
floors bar becomes the move bar, and so on. Settings (Garmin Connect) choose
the mode, each bar's metric, the accent colour, seconds and the temperature.

## Layout

```text
source/
  HeroFaceApp.mc          entry point; owns the HeroSet link
  HeroFaceView.mc         gathers a state, draws it, sleeps
  HeroFaceReadings.mc     reads the watch: clock, activity, weather, HeroSet
  HeroFaceState.mc        one frame's data
  HeroFaceMetric(s).mc    mission slots and their fallback chains
  HeroFaceStreak.mc       step-goal streak, stored so it outlives history
  HeroFaceContract.mc     parses HeroSet's published value
  HeroFaceLink.mc         HeroSet's private complication (CIQ 4.2+)
  HeroFaceLayout.mc       round-screen geometry, row stack, font choice
  HeroFaceDraw.mc         measured text fitting
  HeroFaceRing/Missions/Footer/Clock/Sleep.mc   the drawn parts
  HeroFacePalette.mc      HeroSet's colour roles
  HeroFaceConfig.mc       every tunable and key
  test/                   logic tests, screen-fit test, layout report
docs/plan.md              what is built and what comes next
PRODUCT.md                product truth
DESIGN.md                 the visual system
```

House rules follow HeroSet's ([`../HeroSet/CLAUDE.md`](../HeroSet/CLAUDE.md)): typed functions, no
magic numbers, one class per file, text fit measured and never guessed,
comments explain *why*.
