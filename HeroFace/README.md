# HeroFace

A Garmin watch face from Verden, in HeroSet's visual language: the time in the
middle, today's three goals as mission bars, and a progress ring on the bezel.

It works on its own. The bars show **steps, intensity minutes and floors**, the
ring shows how the whole day is going, and a gold line counts the days in a row
you hit your step goal. On watches with Connect IQ 4.2+ and
[HeroSet](../HeroSet) installed, the bars can switch to your push-ups, sit-ups
and squats, with your HeroSet rank and streak.

Two builds from one source (uploaded 2026-10-04, in Garmin review; ladder approved by the owner 2026-10-04, [`docs/decisions.md`](docs/decisions.md) ADR-001, the Free + Pro ladder): **HeroFace** (Free,
`monkey.free.jungle`: everyday and HeroSet mode, accent colour) and **HeroFace Pro** (the paid app, `monkey.jungle`: adds the metric per
bar, seconds and the temperature). The on-watch names are placeholders.

117 round watches, 7 Instinct watches (black and white, with a round window; ADR-002, simulator only) and 5 rectangular Venu Sq / Sq 2 / X1 watches (the ring becomes a frame; ADR-005, proposed, simulator only), Connect IQ 3.0 and up, in 15 languages:
[`docs/compatibility.md`](docs/compatibility.md).

## Build

```bash
# Developer key (kept outside the repo, never committed)
KEY=~/.garmin-connectiq/keys/developer_key

monkeyc -d fr965 -f monkey.jungle      -o bin/HeroFace.prg     -y $KEY -w --typecheck 3   # Pro
monkeyc -d fr965 -f monkey.free.jungle -o bin/HeroFaceFree.prg -y $KEY -w --typecheck 3   # Free
monkeydo bin/HeroFace.prg fr965            # with the simulator running

# Tests: Pro 27, Free 27 on round and rectangle products and 23 each on an Instinct (PASSED in the simulator 2026-10-06; no wrist); prints PASSED (…)
tools/run_tests.sh fr965                       # Pro (monkey.jungle)
tools/run_tests.sh fr965 monkey.free.jungle    # Free
tools/compile_sweep.sh                         # compile every product, both jungles, no simulator

# Store upload packages, and the check on what they contain
monkeyc -e -r -f monkey.free.jungle -o dist/HeroFaceFree.iq -y $KEY   # Free (a new app id)
monkeyc -e -r -f monkey.jungle      -o dist/HeroFacePro.iq  -y $KEY   # Pro (the live app id)
tools/check_free_package.sh                    # Free has no Slot/Seconds/Weather key and no "Pro"; Pro has them
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
the mode and the accent colour (both tiers), and in Pro each bar's metric, seconds and the
temperature. Free has the three bars on Auto, no seconds and no temperature.

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
  test/                   logic tests, accent and settings tests, screen-fit test, layout report
resources/                shared strings and drawables; NO settings, NO AppName
resources-free/           AppName "HeroFace", Free settings and properties (Mode, Accent)
resources-pro/            AppName "HeroFace Pro", all seven settings and properties
manifest.xml, monkey.jungle              Pro (the live app id)
manifest.free.xml, monkey.free.jungle    Free (its own app id)
tools/                    run_tests.sh, compile_sweep.sh, check_free_package.sh, check_strings.py
listing/                  store form copy (Pro, the live listing)
listing-free/             store form copy (Free, uploaded 2026-10-04)
docs/archive/plan.md              what is built and what comes next
docs/decisions.md         durable decisions (the Free + Pro ladder)
PRODUCT.md                product truth
DESIGN.md                 the visual system
```

House rules follow HeroSet's ([`../HeroSet/CLAUDE.md`](../HeroSet/CLAUDE.md)): typed functions, no
magic numbers, one class per file, text fit measured and never guessed,
comments explain *why*.
