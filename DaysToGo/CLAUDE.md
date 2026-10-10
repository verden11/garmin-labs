# Days To Go — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. One job: days until a date, date always right. 129 products (117 round, 5 rectangular: 3 AMOLED and first-generation Venu Sq and Sq Music, LCD, added 2026-10-05; 7 semi-octagon Instinct, ADR-015 (Instinct family), accepted 2026-10-04; simulator only; rectangles have own square design, rounded-rectangle track, ADR-019, unreleased),
`minApiLevel` 3.0.0, no permissions. Paid: first submitted at USD 1.99, then $2.50 tier for Days To Go Pro ([ADR-017](docs/decisions.md#adr-017), price: $2.50 tier for every paid app; set in upload form with 1.1.0; no price number in listing or site text). Approved 2026-09-28 (late afternoon, owner). Day-45 price-flip review of ADR-002 retired:
owner approved Free + Pro ladder 2026-10-04 (ADR-014), paid app never flipped to free.

**Free + Pro (approved by owner 2026-10-04, uploaded 2026-10-04; Pro update live, Free pending Garmin review on 2026-10-10 (ROADMAP 7.12), ADR-014 "Free + Pro ladder", supersedes ADR-002's price and day-45 review):** live paid app
(`manifest.xml`, `monkey.jungle`) becomes **Days To Go Pro** 1.1.0; new **Free** twin (`manifest.free.xml`, `monkey.free.jungle`, own app id, 1.0.0) built beside it from
same source, split at compile time with `(:pro)` / `(:free)`. Free: Event, Name, Month, Day, Year, Unit, Date style, Accent (ids 0 to 5). Pro adds Hour (timed events), Minute and Event time zone (**"To the minute"**, ADR-018, Pro headline: count to minute event starts in zone it starts in, as UTC offset; day count stays local calendar days; uploaded in Pro 1.1.0 2026-10-04) and Footer (battery or steps). Names (confirmed 2026-10-04: "Days To Go" free, "Days To Go Pro"), icon, uploads are owner's; Free is free.

**Read first:** [`docs/spec.md`](docs/spec.md) (product, rules),
[`docs/status.md`](docs/status.md) (state, gates; open items in root [`ROADMAP.md`](../ROADMAP.md)), [`docs/archive/plan.md`](docs/archive/plan.md) (built, left, owner-only steps),
[`docs/decisions.md`](docs/decisions.md) (ADRs), [`docs/compatibility.md`](docs/compatibility.md).
Evidence in [`../reports/Countdown face research.md`](../reports/Countdown%20face%20research.md).

## Fast facts

- Independent of HeroSet and HeroFace: own app id, no complication link, no shared code.
- Settings are **lists**, never `type="date"` or `numeric` min/max (both failed in rival faces).
  `tools/gen_settings.py [free|pro]` writes `resources-free/settings/*` and `resources-pro/settings/*` (**no settings file in shared `resources/`**) and `resources/strings/generated.xml`.
  `AppName` lives only in `resources-free/strings` and `resources-pro/strings`, never in `resources/` or a `resources-<lang>/` (would override tier name on non-English watch); each jungle appends its tier folder to every `base.lang.<l>`.
  Date can also be set **on the watch** (`getSettingsView`, Menu2 + Picker; 94 of 117 round products; on Venu Sq, Sq Music and X1, **not on Venu Sq 2 / Sq 2 Music**: system picker 30 px wide, so jungles drop `getSettingsView` there with `picker` annotation, ADR-020 (no on-watch picker on the Sq 2)).
- Count = integer calendar-day arithmetic (`DaysToGoCalendar.dayNumber`); never `Time.Moment` maths.
  Flips at local midnight. See `docs/spec.md` "Rules the count follows".
- Properties only (no `Storage`), no permissions, nothing leaves watch.
- Settings re-read on every `onUpdate` (on-watch picker writes Properties with no callback).
- Build (Pro; `monkey.free.jungle` is Free): `monkeyc -d fr965 -f monkey.jungle -o bin/DaysToGo.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
- Tier-only code is `(:pro)` / `(:free)` (`(:free)` twin returns default); Free never reads Hour, Minute, EventZone or Footer. `Application.Properties.getValue` of key missing from properties file throws `InvalidKeyException` (SDK docs, observed in simulator by passing Free test `freeMissingPropertyKeyThrows`).
- Tests: `tools/run_tests.sh <device> [jungle] [testName]` (jungle defaults `monkey.jungle`, Pro; run both). Trust printed `PASSED (…)` line, not exit code.
  Run printing nothing = simulator wedged (script restarts once).
- Screen check per size: `tools/run_tests.sh <device> <jungle> everyStateFitsThisDisplay`; `daysToGoLayoutReport` prints every row's box.
- On-watch date picker (not reachable on watch face in simulator): `tools/picker_shot.sh <jungle> <device>...` from repo root opens it in private-copy harness, screenshots it (`YEARFIRST=1` for widest column). Colour MIP picker draws white in simulator whatever app clears (SDK sample too), so only wrist settles that.
- Compile every product, both jungles, no simulator: `tools/compile_sweep.sh`. Prove packages: `tools/check_free_package.sh [--build]` (Free has no Hour, Minute, EventZone or Footer key and no "Pro" word; Pro has them).
- Beta build (Pro build with own app id, for testing phone settings before release): `python3 tools/make_beta.py`, then export `beta.jungle`.
- Store packages: Free `dist/DaysToGoFree.iq`, Pro `dist/DaysToGoPro.iq` (`dist/DaysToGo-1.0.1-submitted.iq` = paid 1.0.1 as submitted).
- **Nothing here has run on a wrist.** All simulator-only until owner's FR965 tests (plan phase 3 and 9) say otherwise.

## House rules

Same as HeroFace ([`../HeroFace/CLAUDE.md`](../HeroFace/CLAUDE.md)), which this project mirrors:

- Every function: typed params, `as` return type. No `as Any`. Cast only after `instanceof` or null guard.
- No magic numbers: tunables and keys in `DaysToGoConfig`, geometry in `DaysToGoLayout`, colours in `DaysToGoPalette`, words in `strings.xml`.
- Text fit measured, never guessed: draw through `DaysToGoDraw`.
- Render only in `onUpdate`; gather in `DaysToGoReadings`, draw from `DaysToGoState`.
- One class per file, `DaysToGo` prefix. Functions ≲30 lines, files ≲250.
- Value watch does not have hidden, never faked.
- Property key spellings never change once shipped.
- Do not add anything from spec's non-goals.

## Keeping things in sync

- Behaviour change → `docs/spec.md` (and `DESIGN.md` if visual) same session; durable decision → ADR in `docs/decisions.md`.
- New layout or string → run screen-fit test per screen size, update `docs/compatibility.md`.
- User-facing claims live in listing and `../site/src/apps/days-to-go/`; change both together, never change published URL.
- Every store publication gets `CHANGELOG.md` entry and What's New block in `listing/paste.md`.
- Test count appears in `README.md` and here: **Pro 71, Free 60** on round and rectangular products (55 shared + 15 Pro-only / + 4 Free-only, + Instinct layout test; `alwaysOnGreyReadsOnBlack` and `errorFrameDimsAndDriftsWhenAsleep` joined 2026-10-08), **Pro 69, Free 58** on Instinct (colour-only accent tests drop, mono one joins), simulator tests PASSED 2026-10-04 (2026-10-05: Pro on fr965, fr55, fenix5s, fr255s, epix2, venusq2, instincte40mm, instinct2s and Free on fr965 after ROADMAP 13.1 to 13.4; after Venu Sq and always-on fix, both tiers on venusq, venusqm, venusq2, venux1, fr965, fr55, epix2, fr265s) (fr965, fr255s, epix2, venusq2, fr55, fenix5s, instincte40mm, instinct3solar45mm, instinct2, instinct2s; no wrist; after ADR-019 (rectangles get a square design), 2026-10-05: both tiers on venusq, venusq2, venux1, fr965, fr55, instincte40mm); update both.
- **Instinct family (ADR-015, accepted 2026-10-04; 7 products, 1-bit, round window top right):** `DaysToGoPalette` is two classes, `(:color)` and `(:mono)`, chosen by jungles (`base.excludeAnnotations = <tier>;mono`, per Instinct product `<product>.excludeAnnotations = <tier>;color` — per-product line **replaces** base list, so restate tier's own). Accent setting is own file (`resources-accent-<tier>/settings/accent.xml`, from `tools/gen_settings.py`); Instinct `resourcePath` leaves that folder out. Visible area is circle about 98 px radius (`DaysToGoLayout.VISIBLE_RADIUS_PX`), not whole square: **screenshot simulator for every layout change** (`docs/development.md` "Screenshots").
- New language: its line in **both** manifests and **both** jungles; its folder must not define `AppName` (`python3 tools/check_strings.py`).