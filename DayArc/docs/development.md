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

Trust printed `PASSED` line, not exit code alone (matches exit code here, but convention across studio projects: trust the line).

## Compile sweep (both densities, every product)

```
tools/compile_sweep.sh
```

Compile-only, no simulator (`knowledge/platform-facts.md` "Tooling" — compiling always safe regardless of who holds simulator). Writes `bin/compile-sweep-monkey.simple.txt` and `bin/compile-sweep-monkey.pro.txt`. Proves every product *builds*; not render or per-device fit sweep — see `tools/run_tests.sh` for that, on whichever devices need it.

## Sideload

Drag exported `.prg`/`.iq` to device's `GARMIN/APPS/` folder over USB mass storage, or use Garmin Express.

## Simulator

Scripts run in container by default (`../docker/README.md`); host simulator (`CIQ_DOCKER=0`) = shared resource across concurrent sessions (`knowledge/platform-facts.md` "Tooling"). Compiling never needs it; `monkeydo`/`tools/run_tests.sh` do. Check `pgrep -f monkeydo` first if another session might use it.

## Export

```
monkeyc -e -r -f monkey.simple.jungle -o dist/DayArc.iq -y ~/.garmin-connectiq/keys/developer_key
monkeyc -e -r -f monkey.pro.jungle -o dist/DayArcPro.iq -y ~/.garmin-connectiq/keys/developer_key
```

Check reported device count against each manifest's product list before trusting it (`knowledge/platform-facts.md` "Build/export").

## Screenshots (Instinct and any layout change)

Unit suite measures numbers; cannot see bezel. Every layout change: photograph what simulator draws (face on device skin, real fonts, real bezel mask): `../docker/shot.sh DayArc monkey.pro.jungle instinct2 instincte40mm` writes `bin/shot-<device>-face.png` (display, 3x). Instinct visible area = circle about 98 px radius, which 176 x 176 square test misses: finished-day footer clipped in HeroSet that way (HeroSet ADR-055, amended 2026-10-03). `PREP='sed -i ... resources/properties.xml' ../docker/shot.sh ...` shows particular state without touching repo.