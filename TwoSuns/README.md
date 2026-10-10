# Two Suns

Garmin watch face from Verden, answers one question at glance: how much light, how much energy left today? Time biggest on screen. 24-hour ring around bezel = sky's sun, 24-hour curve under time = watch's own Body Battery, one bottom line says daylight left or when sun returns. Sunrise/sunset = Garmin's own numbers, same as watch's Sunrise/Sunset glance. Every failure gets sentence, not blank. Nothing leaves watch.

**"Two Suns" is confirmed** (ADR-010, 2026-09-27); no trademark search done.

Two builds, one source (uploaded 2026-10-04, in Garmin review; ladder approved by owner 2026-10-04, `docs/decisions.md` ADR-020 (Free + Pro ladder)): **Two Suns** (Free, `monkey.free.jungle`: time, sun ring from Garmin's own sunrise/sunset, Garmin's Body Battery number, accent colour; permission `ComplicationSubscriber` only, no location) and **Two Suns Pro** (paid app, `monkey.jungle`: adds 24-hour energy curve, place-based sun, golden hour, ring orientation, date row). Everything below describes Pro unless says Free.

72 products, Connect IQ 4.2+ (66 round, 3 rectangular AMOLED, 3 Instinct with round window, black and white: ADR-024 (Instinct support), accepted 2026-10-04, simulator only): [`docs/compatibility.md`](docs/compatibility.md).
Status: **submitted 2026-09-27, pending review.** Built, simulator-tested, spot-checked on real FR965, no full wear day yet. Store page (live once approved): https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b

## Build

```bash
KEY=~/.garmin-connectiq/keys/developer_key      # outside the repo, never committed

monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y $KEY -w --typecheck 3          # Pro
monkeyc -d fr965 -f monkey.free.jungle -o bin/TwoSunsFree.prg -y $KEY -w --typecheck 3  # Free
monkeydo bin/TwoSuns.prg fr965                  # with the simulator running

tools/run_tests.sh fr965                        # Pro: 166 tests; prints PASSED (…)
tools/run_tests.sh fr965 monkey.free.jungle     # Free: 76 tests
tools/run_tests.sh fr965 monkey.jungle everyStateFitsThisDisplay
tools/fit_all.sh [jungle]                       # screen fit on ten devices, one per size but Venu X1
tools/compile_sweep.sh                          # compile every product, both jungles, no simulator

python3 tools/gen_settings.py --check           # settings files match their tables
python3 tools/check_strings.py                  # translation parity and length
monkeyc -e -r -f monkey.free.jungle -o dist/TwoSunsFree.iq -y $KEY   # Free store package
monkeyc -e -r -f monkey.jungle -o dist/TwoSunsPro.iq -y $KEY         # Pro store package (the live app id; see docs/status.md: the "89 devices" oddity)
tools/check_free_package.sh                     # Free has only ComplicationSubscriber, only the Accent key, no Pro code or word; Pro has them
# dist/TwoSuns.iq is the pre-ladder 1.0.1 package, never overwritten (a copy: dist/TwoSuns-1.0.1-prepared.iq)
```

Test runners run in container by default (`docker/README.md`). With `CIQ_DOCKER=0` (host simulator) they run `pkill -f monkeydo` after every run, restart simulator with `pkill` when wedged: do not run while another session uses it ([`docs/development.md`](docs/development.md)).

## What it shows

| Part | What |
|---|---|
| Ring | 24 hours local clock time, noon at top (setting puts midnight there), clockwise. Night dim, civil twilight, daylight in accent (part already gone dimmer), ticks at sunrise and sunset, sun marker at now (solid while sun up, outline when not). Optional golden-hour arc. |
| Time | Hero, largest system numeric font that fits. |
| Body Battery band | Bolt glyph, value, last 24 hours as curve, current point marked (not drawn until two neighbouring 15-minute samples exist). Stale (newest sample over 1 hour old) muted, hollow. No number: muted `--` beside hollow bolt. |
| Sun sentence | "3:42 of daylight", "Sunrise 06:41", "Sun stays up today", "No place yet", "No sun data", and shorter wordings on narrow rows. |
| Date | Small, muted, above time; optional. |

Always-on (AMOLED): time, Body Battery value, sun sentence, dim, drifting on 3 × 3 grid; no ring, no curve. MIP watches keep full face. Body Battery shown as Garmin reports: no verdicts, no advice.

Settings (Garmin Connect, lists only): Accent colour, Ring orientation, Golden hour, Energy curve, Date, Weather, Watch battery (Pro; Weather and Watch battery Off by default). Free has Accent colour only. Free: no curve, no date row, no twilight or golden arc, keeps no place; missing Body Battery number = `--` and hollow bolt (ADR-021 (Body Battery in Free)).

## Layout

```text
source/
  TwoSunsApp.mc / TwoSunsView.mc    entry point; reads settings, builds a state, draws it, sleeps
  TwoSunsSources.mc                 the one class that touches the watch: clock, Complications, history, location
  TwoSunsReadings.mc / State.mc     inputs -> words; what the view draws
  TwoSunsSun / SunDay.mc            the NOAA calculation (pure)
  TwoSunsSky.mc                     sun times + now -> the state table's row (pure)
  TwoSunsLocalTime / Calendar.mc    local date, exact UTC offset, day arithmetic
  TwoSunsBattery / BatteryCurve.mc  history -> 96 buckets (pure)
  TwoSunsPlace.mc                   the remembered place (rounded, validated)
  TwoSunsRingPlan / Ring / RingArc  sky ring: plan (pure) and drawing
  TwoSunsCurvePlan / Curve / Band   Body Battery band: plan (pure) and drawing
  TwoSunsLayout/Rows/Frame/Draw/Sleep/Palette/Config/Text/DateText/Settings
  test/                             unit and screen-fit tests (Pro 166, Free 76)
resources/  resources-<lang>/       shared strings and drawables (English + 14 machine-drafted); NO settings, NO AppName
resources-free/  resources-pro/     AppName ("Two Suns" / "Two Suns Pro"), the settings and properties of each tier
manifest.xml, monkey.jungle              Pro (the live app id)
manifest.free.xml, monkey.free.jungle    Free (its own app id)
tools/                              run_tests.sh, fit_all.sh, fit_products.sh, fit_languages.sh, compile_sweep.sh,
                                    check_free_package.sh, gen_settings.py, gen_sun_tests.py, check_strings.py
docs/                               spec, plan, decisions, compatibility, development, release contract, publish checklist
listing/                            store form copy, Pro (the live listing): listing/paste.md, listing/NOTES.md
listing-free/                       store form copy, Free (uploaded 2026-10-04)
```
