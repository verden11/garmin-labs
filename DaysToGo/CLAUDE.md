# Days To Go — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. One job: how many
days until a date, and the date is always right. 129 products (117 round, 5 rectangular: 3 AMOLED and the first-generation Venu Sq and Sq Music, LCD, added 2026-10-05; 7 semi-octagon Instinct, ADR-015 (Instinct family), accepted 2026-10-04; simulator only; the rectangles have their own square design, a rounded-rectangle track, ADR-019, unreleased),
`minApiLevel` 3.0.0, no permissions. Paid: first submitted at USD 1.99, then the $2.50 tier for Days To Go Pro ([ADR-017](docs/decisions.md#adr-017), price: the $2.50 tier for every paid app; set in the upload form with 1.1.0; no price number in listing or site text). Approved 2026-09-28 (late afternoon, owner). The day-45 price-flip review of ADR-002 is retired:
the owner approved the Free + Pro ladder on 2026-10-04 (ADR-014), and the paid app is never flipped to free.

**Free + Pro (approved by the owner 2026-10-04, uploaded 2026-10-04 and in Garmin review, ADR-014 "Free + Pro ladder", which supersedes ADR-002's price and day-45 review):** the live paid app
(`manifest.xml`, `monkey.jungle`) becomes **Days To Go Pro** 1.1.0; a new **Free** twin (`manifest.free.xml`, `monkey.free.jungle`, own app id, 1.0.0) is built beside it from the
same source, split at compile time with `(:pro)` / `(:free)`. Free: Event, Name, Month, Day, Year, Unit, Date style, Accent (ids 0 to 5). Pro adds Hour (timed events), Minute and Event time zone (**"To the minute"**, ADR-018, the Pro headline: count to the minute an event starts in the zone it starts in, as a UTC offset; the day count stays local calendar days; uploaded in Pro 1.1.0 2026-10-04) and Footer (battery or steps). Names (confirmed 2026-10-04: "Days To Go" free, "Days To Go Pro"), icon, uploads are the owner's; Free is free.

**Read first:** [`docs/spec.md`](docs/spec.md) (the product and its rules),
[`docs/status.md`](docs/status.md) (state, gates; open items are in the root [`ROADMAP.md`](../ROADMAP.md)), [`docs/archive/plan.md`](docs/archive/plan.md) (what is built and what is left, with the owner-only steps),
[`docs/decisions.md`](docs/decisions.md) (ADRs), [`docs/compatibility.md`](docs/compatibility.md).
The evidence is in [`../reports/Countdown face research.md`](../reports/Countdown%20face%20research.md).

## Fast facts

- Independent of HeroSet and HeroFace: own app id, no complication link, no shared code.
- Settings are **lists**, never `type="date"` or `numeric` min/max (both failed in rival faces).
  `tools/gen_settings.py [free|pro]` writes `resources-free/settings/*` and `resources-pro/settings/*` (**no settings file in the shared `resources/`**) and `resources/strings/generated.xml`.
  `AppName` lives only in `resources-free/strings` and `resources-pro/strings`, never in `resources/` or a `resources-<lang>/` (it would override the tier name on a non-English watch); each jungle appends its tier folder to every `base.lang.<l>`.
  The date can also be set **on the watch** (`getSettingsView`, Menu2 + Picker; 94 of the 117 round products; not checked for the 5 rectangles).
- The count is integer calendar-day arithmetic (`DaysToGoCalendar.dayNumber`); never `Time.Moment` maths.
  It flips at local midnight. See `docs/spec.md` "Rules the count follows".
- Properties only (no `Storage`), no permissions, nothing leaves the watch.
- Settings are re-read on every `onUpdate` (the on-watch picker writes Properties with no callback).
- Build (Pro; `monkey.free.jungle` is Free): `monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
- Tier-only code is `(:pro)` / `(:free)` (a `(:free)` twin returns the default); Free never reads Hour, Minute, EventZone or Footer. `Application.Properties.getValue` of a key missing from the properties file throws `InvalidKeyException` (SDK docs, and observed in the simulator by the passing Free test `freeMissingPropertyKeyThrows`).
- Tests: `tools/run_tests.sh <device> [jungle] [testName]` (jungle defaults to `monkey.jungle`, Pro; run both). Trust the printed `PASSED (…)` line, not the exit code.
  A run that prints nothing means the simulator wedged (the script restarts it once).
- Screen check per size: `tools/run_tests.sh <device> <jungle> everyStateFitsThisDisplay`; `daysToGoLayoutReport` prints every row's box.
- The on-watch date picker (not reachable on a watch face in the simulator): `tools/picker_shot.sh <jungle> <device>...` from the repo root opens it in a private-copy harness and screenshots it (`YEARFIRST=1` for the widest column). A colour MIP picker draws white in the simulator whatever the app clears (the SDK sample does too), so only a wrist settles that.
- Compile every product, both jungles, no simulator: `tools/compile_sweep.sh`. Prove the packages: `tools/check_free_package.sh [--build]` (Free has no Hour, Minute, EventZone or Footer key and no "Pro" word; Pro has them).
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
- Every store publication gets a `CHANGELOG.md` entry and a What's New block in `listing/paste.md`.
- Test count appears in `README.md` and here: **Pro 70, Free 59** on round and rectangular products (54 shared + 15 Pro-only / + 4 Free-only, + the Instinct layout test; `alwaysOnGreyReadsOnBlack` joined 2026-10-08), **Pro 68, Free 57** on an Instinct (the colour-only accent tests drop, a mono one joins), simulator tests PASSED 2026-10-04 (2026-10-05: Pro on fr965, fr55, fenix5s, fr255s, epix2, venusq2, instincte40mm, instinct2s and Free on fr965 after ROADMAP 13.1 to 13.4; after the Venu Sq and the always-on fix, both tiers on venusq, venusqm, venusq2, venux1, fr965, fr55, epix2, fr265s) (fr965, fr255s, epix2, venusq2, fr55, fenix5s, instincte40mm, instinct3solar45mm, instinct2, instinct2s; no wrist; after ADR-019 (rectangles get a square design), 2026-10-05: both tiers on venusq, venusq2, venux1, fr965, fr55, instincte40mm); update both.
- **Instinct family (ADR-015, accepted 2026-10-04; 7 products, 1-bit, a round window top right):** `DaysToGoPalette` is two classes, `(:color)` and `(:mono)`, chosen by the jungles (`base.excludeAnnotations = <tier>;mono`, and per Instinct product `<product>.excludeAnnotations = <tier>;color` — a per-product line **replaces** the base list, so restate the tier's own). The Accent setting is its own file (`resources-accent-<tier>/settings/accent.xml`, from `tools/gen_settings.py`) and the Instinct `resourcePath` leaves that folder out. The visible area is a circle about 98 px in radius (`DaysToGoLayout.VISIBLE_RADIUS_PX`), not the whole square: **screenshot the simulator for every layout change** (`docs/development.md` "Screenshots").
- A new language: its line in **both** manifests and **both** jungles; its folder must not define `AppName` (`python3 tools/check_strings.py`).
