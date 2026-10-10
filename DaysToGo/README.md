# Days To Go

Garmin watch face from Verden, one job: days until date, date always right. Day count biggest on screen, time second, nothing else on by default.

Set date on phone (plain lists, no date picker) **or on watch**.
Nothing set? Counts to next New Year's Day. No permissions, nothing leaves watch.

Two builds, one source (uploaded 2026-10-04, in Garmin review; ladder approved by owner 2026-10-04, `docs/decisions.md` ADR-014 (Free + Pro ladder)): **Days To Go** (Free, `monkey.free.jungle`) and **Days To Go Pro** (paid app, `monkey.jungle`, adds timed events and battery or steps line).

117 round watches (Connect IQ 3.0 and up), 5 rectangular (Venu Sq 2, Venu Sq 2 Music, Venu X1; first-generation Venu Sq and Venu Sq Music, added 2026-10-05, Free-only reach) and 7 Instinct watches (black and white, round window; accepted 2026-10-04, simulator only): [`docs/compatibility.md`](docs/compatibility.md).
Status: built, simulator-tested, **not yet run on a wrist**.

## Build

```bash
KEY=~/.garmin-connectiq/keys/developer_key      # outside the repo, never committed

monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3        # Pro
monkeyc -d fr965 -f monkey.free.jungle -o bin/DaysToGoFree.prg -y $KEY -w --typecheck 3   # Free
monkeydo bin/DaysToGo.prg fr965                 # with the simulator running

tools/run_tests.sh fr965                        # Pro: 71 tests, 69 on an Instinct (PASSED in the simulator 2026-10-08); prints PASSED (…)
tools/run_tests.sh fr965 monkey.free.jungle     # Free: 60 tests, 58 on an Instinct (PASSED in the simulator 2026-10-08)
tools/run_tests.sh fr55 monkey.jungle everyStateFitsThisDisplay
tools/compile_sweep.sh                          # compile every product, both jungles

python3 tools/make_beta.py                      # beta.jungle: the Pro build with its own app id, for phone-settings tests
monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY
monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y $KEY  # Free store package
monkeyc -e -r -f monkey.jungle -o dist/DaysToGoPro.iq -y $KEY        # Pro store package (the live app id)
tools/check_free_package.sh                     # Free has no Hour/Footer and no "Pro"; Pro has them
```

## What it shows

| State | Hero | Caption | Ring |
|---|---|---|---|
| Upcoming | days (or whole weeks, `+ n DAYS`) | DAYS / WEEKS | square root of share of next 365 days still to go (grey track only beyond a year) |
| Last 24 h of timed event | `H:MM` | HOURS | share of 24 h still to go |
| The day itself | TODAY | | full |
| Past | days since | DAYS SINCE | track only |
| Date that does not exist | SET A DATE | | none |

Always: time, event name (if set), target date as words. Optional
bottom line: battery or steps (Pro only; last-24-hours `H:MM` state Pro only too). Always-on (AMOLED): hero and time only, dim,
drifting on 3 × 3 grid.

## Layout

```text
source/
  DaysToGoApp.mc        entry point; the watch's own settings screen
  DaysToGoView.mc       reads settings, builds a state, draws it, sleeps
  DaysToGoSettings.mc   validated settings (bad values fall back)
  DaysToGoReadings.mc   settings + clock -> DaysToGoState (words)
  DaysToGoCountdown.mc  the counting rule (pure); Calendar, Event, LocalTime, Result
  DaysToGoDateText.mc   the date line and Date style
  DaysToGoLayout/Rows/Frame/Draw/Ring/Sleep/Palette  geometry and drawing
  settings/             on-watch date picker (Menu2 + Picker)
  test/                 unit and screen-fit tests
resources/              shared strings and drawables (English + translations); NO settings, NO AppName
resources-free/         AppName "Days To Go", Free settings and properties
resources-pro/          AppName "Days To Go Pro", full settings and properties
manifest.xml, monkey.jungle              Pro (the live app id)
manifest.free.xml, monkey.free.jungle    Free (its own app id)
tools/                  gen_settings.py, make_beta.py, run_tests.sh, compile_sweep.sh, check_free_package.sh
docs/                   spec, plan, decisions, compatibility, development, release contract
listing/                store form copy (Pro, the live listing)
listing-free/           store form copy (Free, uploaded 2026-10-04)
```
