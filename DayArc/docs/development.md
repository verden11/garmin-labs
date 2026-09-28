# DayArc — development

## Build

```
# Simple
monkeyc -d fr965 -f monkey.simple.jungle -o bin/DayArc.prg \
  -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3

# Pro
monkeyc -d fr965 -f monkey.pro.jungle -o bin/DayArcPro.prg \
  -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3
```

## Test

```
tools/run_tests.sh <device> [jungle] [testName]      # jungle defaults to monkey.simple.jungle
tools/run_tests.sh fr965 monkey.pro.jungle
```

Trust the printed `PASSED` line, not the exit code alone (matches the exit code here, but the
convention across this studio's projects is to trust the line).

## Compile sweep (both densities, every product)

```
tools/compile_sweep.sh
```

Compile-only, no simulator (`knowledge/platform-facts.md` "Tooling" — compiling is always safe to
run regardless of who holds the simulator). Writes `bin/compile-sweep-monkey.simple.txt` and
`bin/compile-sweep-monkey.pro.txt`. This proves every product *builds*; it is not a render or
per-device fit sweep — see `tools/run_tests.sh` for that, on whichever devices need it.

## Sideload

Drag the exported `.prg`/`.iq` to the device's `GARMIN/APPS/` folder over USB mass storage, or use
Garmin Express.

## Simulator

Shared resource across concurrent sessions (`knowledge/platform-facts.md` "Tooling"). Compiling
never needs it; `monkeydo`/`tools/run_tests.sh` do. Check `pgrep -f monkeydo` first if another
session might be using it.

## Export

```
monkeyc -e -r -f monkey.simple.jungle -o dist/DayArc.iq -y ~/.garmin-connectiq/keys/developer_key
monkeyc -e -r -f monkey.pro.jungle -o dist/DayArcPro.iq -y ~/.garmin-connectiq/keys/developer_key
```

Check the reported device count against each manifest's product list before trusting it
(`knowledge/platform-facts.md` "Build/export").
