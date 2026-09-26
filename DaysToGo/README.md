# Days To Go

A Garmin watch face from Verden with one job: how many days until a date, and
the date is always right. The day count is the biggest thing on the screen, the
time is second, and nothing else is on by default.

Set the date on the phone (plain lists, no date picker) **or on the watch**.
Nothing is set up yet? It counts to the next New Year's Day. No permissions,
nothing leaves the watch.

117 round watches (Connect IQ 3.0 and up) and 3 rectangular AMOLED ones (Venu Sq 2, Venu Sq 2 Music, Venu X1): [`docs/compatibility.md`](docs/compatibility.md).
Status: built and simulator-tested, **not yet run on a wrist**.

## Build

```bash
KEY=~/.garmin-connectiq/keys/developer_key      # outside the repo, never committed

monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y $KEY -w --typecheck 3
monkeydo bin/DaysToGo.prg fr965                 # with the simulator running

tools/run_tests.sh fr965                        # 43 tests; prints PASSED (…)
tools/run_tests.sh fr55 everyStateFitsThisDisplay

python3 tools/make_beta.py                      # beta.jungle: own app id, for phone-settings tests
monkeyc -e -r -f beta.jungle -o dist/DaysToGo-beta.iq -y $KEY
monkeyc -e -r -f monkey.jungle -o dist/DaysToGo.iq -y $KEY      # store package
```

## What it shows

| State | Hero | Caption | Ring |
|---|---|---|---|
| Upcoming | days (or whole weeks, `+ n DAYS`) | DAYS / WEEKS | square root of the share of the next 365 days still to go (grey track only beyond a year) |
| Last 24 h of a timed event | `H:MM` | HOURS | share of the 24 h still to go |
| The day itself | TODAY | | full |
| Past | days since | DAYS SINCE | track only |
| A date that does not exist | SET A DATE | | none |

Always: the time, the event name (if set), the target date as words. Optional
bottom line: battery or steps. Always-on (AMOLED): hero and time only, dim,
drifting on a 3 × 3 grid.

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
resources/              strings (English + translations), settings, properties
tools/                  gen_settings.py, make_beta.py, run_tests.sh
docs/                   spec, plan, decisions, compatibility, development, release contract
listing/                store form copy
```
