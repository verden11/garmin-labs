# Days To Go — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. One job: how many
days until a date, and the date is always right. 120 products (117 round, 3 rectangular AMOLED),
`minApiLevel` 3.0.0, no permissions. Paid, USD 1.99 first, with one price
review 45 days after store approval (spec "Price review").

**Read first:** [`docs/spec.md`](docs/spec.md) (the product and its rules),
[`docs/plan.md`](docs/plan.md) (what is built and what is left, with the owner-only steps),
[`docs/publish-checklist.md`](docs/publish-checklist.md) (when and how to publish), [`docs/decisions.md`](docs/decisions.md) (ADRs), [`docs/compatibility.md`](docs/compatibility.md).
The evidence is in [`../reports/Countdown face research.md`](../reports/Countdown%20face%20research.md).

## Fast facts

- Independent of HeroSet and HeroFace: own app id, no complication link, no shared code.
- Settings are **lists**, never `type="date"` or `numeric` min/max (both failed in rival faces).
  `tools/gen_settings.py` writes `resources/settings/*` and `resources/strings/generated.xml`.
  The date can also be set **on the watch** (`getSettingsView`, Menu2 + Picker; 94 of the 117 round products; not checked for the 3 rectangles).
- The count is integer calendar-day arithmetic (`DaysToGoCalendar.dayNumber`); never `Time.Moment` maths.
  It flips at local midnight. See `docs/spec.md` "Rules the count follows".
- Properties only (no `Storage`), no permissions, nothing leaves the watch.
- Settings are re-read on every `onUpdate` (the on-watch picker writes Properties with no callback).
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
- Tests: `tools/run_tests.sh <device> [testName]`. Trust the printed `PASSED (…)` line, not the exit code.
  A run that prints nothing means the simulator wedged (the script restarts it once).
- Screen check per size: `tools/run_tests.sh <device> everyStateFitsThisDisplay`; `daysToGoLayoutReport` prints every row's box.
- Beta build (own app id, for testing phone settings before release): `python3 tools/make_beta.py`, then export `beta.jungle`.
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
- Test count appears in `README.md` and here (**43**); update both.
