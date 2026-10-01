# Two Suns

A Garmin watch face from Verden that answers one question at a glance: how
much light, and how much energy, do I have left today? The time is the
biggest thing on the screen. A 24-hour ring around the bezel is the sky's sun,
a 24-hour curve under the time is the watch's own Body Battery, and one line at
the bottom says how much daylight is left or when the sun returns. Sunrise
and sunset are Garmin's own numbers, the same as the watch's Sunrise/Sunset
glance. Every failure has a sentence, not a blank. Nothing leaves the watch.

**"Two Suns" is confirmed** (ADR-010, 2026-09-27); no trademark search done.

Two builds from one source (proposed, UNRELEASED, `docs/decisions.md` ADR-020 (Free + Pro ladder)): **Two Suns** (Free, `monkey.free.jungle`: the time, the sun ring from Garmin's own sunrise and sunset, Garmin's Body Battery number, an accent colour; permission `ComplicationSubscriber` only, no location) and **Two Suns Pro** (the paid app, `monkey.jungle`: adds the 24-hour energy curve, the place-based sun, golden hour, ring orientation and the date row). Everything below describes Pro unless it says Free.

69 products at Connect IQ 4.2 and up (66 round, 3 rectangular AMOLED): [`docs/compatibility.md`](docs/compatibility.md).
Status: **submitted 2026-09-27, pending review.** Built and simulator-tested, spot-checked on a real FR965, no full wear day yet. Store page (live once approved): https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b

## Build

```bash
KEY=~/.garmin-connectiq/keys/developer_key      # outside the repo, never committed

monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y $KEY -w --typecheck 3          # Pro
monkeyc -d fr965 -f monkey.free.jungle -o bin/TwoSunsFree.prg -y $KEY -w --typecheck 3  # Free
monkeydo bin/TwoSuns.prg fr965                  # with the simulator running

tools/run_tests.sh fr965                        # Pro: 130 tests (compiled, not yet run); prints PASSED (…)
tools/run_tests.sh fr965 monkey.free.jungle     # Free: 67 tests (compiled, not yet run)
tools/run_tests.sh fr965 monkey.jungle everyStateFitsThisDisplay
tools/fit_all.sh [jungle]                       # screen fit on ten devices, one per size but Venu X1
tools/compile_sweep.sh                          # compile every product, both jungles, no simulator

python3 tools/gen_settings.py --check           # settings files match their tables
python3 tools/check_strings.py                  # translation parity and length
monkeyc -e -r -f monkey.free.jungle -o dist/TwoSunsFree.iq -y $KEY   # Free store package
monkeyc -e -r -f monkey.jungle -o dist/TwoSunsPro.iq -y $KEY         # Pro store package (the live app id; see docs/publish-checklist.md: the "89 devices" oddity)
tools/check_free_package.sh                     # Free has only ComplicationSubscriber, only the Accent key, no Pro code or word; Pro has them
# dist/TwoSuns.iq is the pre-ladder 1.0.1 package, never overwritten (a copy: dist/TwoSuns-1.0.1-prepared.iq)
```

The test runners run `pkill -f monkeydo` after every run and restart the simulator with `pkill` when it wedges: do not run them while another session uses it ([`docs/development.md`](docs/development.md)).

## What it shows

| Part | What |
|---|---|
| Ring | 24 hours of local clock time, noon at the top (a setting puts midnight there), clockwise. Night dim, civil twilight, daylight in the accent (the part already gone dimmer), ticks at sunrise and sunset, a sun marker at now (solid while the sun is up, an outline when it is not). Optional golden-hour arc. |
| Time | The hero, in the largest system numeric font that fits. |
| Body Battery band | A battery glyph, the value, and the last 24 hours as a curve with the current point marked. Stale (newest sample over an hour old) is muted and hollow. No number: `--`. |
| Sun sentence | "3:42 of daylight", "Sunrise 06:41", "Sun stays up today", "No place yet", "No sun data", and their shorter wordings on narrow rows. |
| Date | Small, muted, above the time; optional. |

Always-on (AMOLED): the time, the Body Battery value and the sun sentence, dim, drifting on a 3 × 3 grid; no ring, no curve. MIP watches keep the full face. Body Battery is shown as Garmin reports it: no verdicts, no advice.

Settings (Garmin Connect, lists only): Accent colour, Ring orientation, Golden hour, Energy curve, Date (Pro). Free has Accent colour only. Free has no curve, no date row, no twilight or golden arc, and keeps no place; a missing Body Battery number is `--` and a hollow pill (ADR-021, Body Battery in Free).

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
  test/                             unit and screen-fit tests (Pro 130, Free 67)
resources/  resources-<lang>/       shared strings and drawables (English + 14 machine-drafted); NO settings, NO AppName
resources-free/  resources-pro/     AppName ("Two Suns" / "Two Suns Pro"), the settings and properties of each tier
manifest.xml, monkey.jungle              Pro (the live app id)
manifest.free.xml, monkey.free.jungle    Free (its own app id)
tools/                              run_tests.sh, fit_all.sh, fit_products.sh, fit_languages.sh, compile_sweep.sh,
                                    check_free_package.sh, gen_settings.py, gen_sun_tests.py, check_strings.py
docs/                               spec, plan, decisions, compatibility, development, release contract, publish checklist
listing/                            store form copy, Pro (the live listing): listing/README.md, listing/NOTES.md
listing-free/                       store form copy, Free (a draft; nothing uploaded)
```
