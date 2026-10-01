# Days To Go — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. One job: how many
days until a date, and the date is always right. 120 products (117 round, 3 rectangular AMOLED),
`minApiLevel` 3.0.0, no permissions. Paid, USD 1.99 first, with one price
review 45 days after store approval (spec "Price review"; ADR-002, the price and day-45 review).

**Free + Pro (proposed, UNRELEASED, ADR-014 "Free + Pro ladder"; the owner has not signed off, so ADR-002, the price and day-45 review, still governs):** the live paid app
(`manifest.xml`, `monkey.jungle`) becomes **Days To Go Pro** 1.1.0; a new **Free** twin (`manifest.free.xml`, `monkey.free.jungle`, own app id, 1.0.0) is built beside it from the
same source, split at compile time with `(:pro)` / `(:free)`. Free: Event, Name, Month, Day, Year, Unit, Date style, Accent (ids 0 to 5). Pro adds Hour (timed events) and Footer (battery or steps). Names, prices, icon, uploads are the owner's.

**Read first:** [`docs/spec.md`](docs/spec.md) (the product and its rules),
[`docs/plan.md`](docs/plan.md) (what is built and what is left, with the owner-only steps),
[`docs/publish-checklist.md`](docs/publish-checklist.md) (when and how to publish), [`docs/decisions.md`](docs/decisions.md) (ADRs), [`docs/compatibility.md`](docs/compatibility.md).
The evidence is in [`../reports/Countdown face research.md`](../reports/Countdown%20face%20research.md).

## Fast facts

- Independent of HeroSet and HeroFace: own app id, no complication link, no shared code.
- Settings are **lists**, never `type="date"` or `numeric` min/max (both failed in rival faces).
  `tools/gen_settings.py [free|pro]` writes `resources-free/settings/*` and `resources-pro/settings/*` (**no settings file in the shared `resources/`**) and `resources/strings/generated.xml`.
  `AppName` lives only in `resources-free/strings` and `resources-pro/strings`, never in `resources/` or a `resources-<lang>/` (it would override the tier name on a non-English watch); each jungle appends its tier folder to every `base.lang.<l>`.
  The date can also be set **on the watch** (`getSettingsView`, Menu2 + Picker; 94 of the 117 round products; not checked for the 3 rectangles).
- The count is integer calendar-day arithmetic (`DaysToGoCalendar.dayNumber`); never `Time.Moment` maths.
  It flips at local midnight. See `docs/spec.md` "Rules the count follows".
- Properties only (no `Storage`), no permissions, nothing leaves the watch.
- Settings are re-read on every `onUpdate` (the on-watch picker writes Properties with no callback).
- Build (Pro; `monkey.free.jungle` is Free): `monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
- Tier-only code is `(:pro)` / `(:free)` (a `(:free)` twin returns the default); Free never reads Hour or Footer. `Application.Properties.getValue` of a key missing from the properties file throws `InvalidKeyException` (SDK docs, and observed in the simulator by the passing Free test `freeMissingPropertyKeyThrows`).
- Tests: `tools/run_tests.sh <device> [jungle] [testName]` (jungle defaults to `monkey.jungle`, Pro; run both). Trust the printed `PASSED (…)` line, not the exit code.
  A run that prints nothing means the simulator wedged (the script restarts it once).
- Screen check per size: `tools/run_tests.sh <device> <jungle> everyStateFitsThisDisplay`; `daysToGoLayoutReport` prints every row's box.
- Compile every product, both jungles, no simulator: `tools/compile_sweep.sh`. Prove the packages: `tools/check_free_package.sh [--build]` (Free has no Hour/Footer key and no "Pro" word; Pro has them).
- Beta build (the Pro build with its own app id, for testing phone settings before release): `python3 tools/make_beta.py`, then export `beta.jungle`.
- Store packages: Free `dist/DaysToGoFree.iq`, Pro `dist/DaysToGoPro.iq` (`dist/DaysToGo-1.0.1-submitted.iq` is the paid 1.0.1 as submitted).
- **Nothing here has run on a wrist.** Everything is simulator-only until the owner's FR965 tests (plan phase 3 and 9) say otherwise.

## House rules

Same as HeroFace ([`../HeroFace/CLAUDE.md`](../HeroFace/CLAUDE.md)), which this project mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only after `instanceof` or a null guard.
- No magic numbers: tunables and keys in `DaysToGoConfig`, geometry in `DaysToGoLayout`, colours in `DaysToGoPalette`, words in `strings.xml`.
- Text fit is measured, never guessed: draw through `DaysToGoDraw`.
- Render only in `onUpdate`; gather in `DaysToGoReadings`, draw from a `DaysToGoState`.
- One class per file, `DaysToGo` prefix. Functions ≲30 lines, files ≲250.
- A value the watch does not have is hidden, never faked.
- Property key spellings never change once shipped.
- Do not add anything from the spec's non-goals.

## Keeping things in sync

- Behaviour change → `docs/spec.md` (and `DESIGN.md` if visual) in the same session; a durable decision → an ADR in `docs/decisions.md`.
- New layout or string → run the screen-fit test for each screen size and update `docs/compatibility.md`.
- User-facing claims live in the listing and `../site/src/apps/days-to-go/`; change both together, never change a published URL.
- Every store publication gets a `CHANGELOG.md` entry and a What's New block in `listing/README.md`.
- Test count appears in `README.md` and here: **Pro 50, Free 51** (48 shared + 2 Pro-only / + 3 Free-only), simulator tests PASSED 2026-10-01 (fr965, fr55, venusq2; no wrist); update both.
- A new language: its line in **both** manifests and **both** jungles; its folder must not define `AppName` (`python3 tools/check_strings.py`).
