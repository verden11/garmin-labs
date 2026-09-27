# Two Suns — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. **"Two Suns" is confirmed** (ADR-010). One question at a glance: how much light, and how much energy, do I have left today? A 24-hour ring is the sky's sun, a 24-hour curve under the time is the watch's own Body Battery, one sentence at the bottom is the light left or the next sunrise. 69 products (66 round, 3 rectangular AMOLED), API 4.2 and newer, `minApiLevel` 4.2.0, permissions `SensorHistory`, `ComplicationSubscriber` and `Positioning`. Paid, USD 1.99. **Submitted 2026-09-27, pending review**: https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b (live once approved — Garmin's own app id, distinct from the manifest AppID below).

**Read first:** [`docs/spec.md`](docs/spec.md) (the product and its rules; "Built vs specified" lists what the build changed),
[`docs/plan.md`](docs/plan.md) (state of each phase, what the build learned, the owner-only steps),
[`docs/decisions.md`](docs/decisions.md) (ADRs, each with its evidence level and what would reverse it),
[`docs/publish-checklist.md`](docs/publish-checklist.md) (the gates before a store upload), [`docs/release-contract.md`](docs/release-contract.md) (what may be claimed), [`docs/compatibility.md`](docs/compatibility.md), [`docs/development.md`](docs/development.md), [`docs/ideas.md`](docs/ideas.md) (post-v1 candidates, none built).
The evidence is in [`../reports/Body Battery and sun face research.md`](../reports/Body%20Battery%20and%20sun%20face%20research.md) and `../research_notes/Body Battery and sun face research/` (start with `platform.md`).

## Fast facts

- Independent of HeroSet, HeroFace and Days To Go: own app id (`6c3c5a3d-b312-4c0f-bf37-2a3fc3a79580`, never changes once published), no complication publishing, no shared code (calendar, layout and sleep patterns were copied from Days To Go).
- **Sunrise and sunset are Garmin's own numbers** (`Complications` SUNRISE and SUNSET, local seconds since midnight). Our own NOAA calculation (`TwoSunsSun`) fills what Garmin does not give: tomorrow's sunrise, twilight, golden hour, polar days, a null. `Weather.getSunrise` is not called.
- **Body Battery** is `SensorHistory` (24 h, 96 buckets of 15 min) plus the Complication number as the fallback. No verdicts, no mood, no advice on it, ever. "Body Battery" is Garmin's trademark: never in the name, icon or brand; the phone setting says "Energy curve".
- Local UTC offset is derived exactly from the clock (`TwoSunsLocalTime.offsetBetween`), not from `System.getClockTime().timeZoneOffset`.
- Only `Application.Storage` use: the remembered place, `[lat, lon]` rounded to 0.1 degree, key `place`. Never sent anywhere. Settings are Properties, lists only, re-read on every update.
- **`Position.getInfo` is isolated in `TwoSunsSources.positionLocation`.** Calling it without the Positioning permission kills the app and cannot be caught. If the permission is dropped, delete that function and its entry in `updatePlace()`.
- Property keys `Accent`, `Orientation`, `Golden`, `Curve`, `Date` and the Storage key `place` never change once shipped.
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/TwoSuns.prg -y ~/.garmin-connectiq/keys/developer_key -w --typecheck 3`
- Tests: `tools/run_tests.sh <device> [testName]`. Trust the printed `PASSED (…)` line, not the exit code. A run that prints nothing means the simulator wedged (the script restarts it once).
- Screen fit, ten devices: `tools/fit_all.sh`. All 69 products: `tools/fit_products.sh` (slow; **run 2026-09-27, `done: 69 pass, 0 fail`, `bin/fit-products.txt`** — predates the 2026-09-27 fixes below, re-run before submit). One size: `tools/run_tests.sh <device> everyStateFitsThisDisplay`; `twoSunsLayoutReport` prints every row's box.
- Generated and checked files: `python3 tools/gen_settings.py [--check|--ids]`, `python3 tools/gen_sun_tests.py` (writes `source/test/TwoSunsSunReferenceTest.mc` from the research notes' USNO table), `python3 tools/check_strings.py`, `tools/fit_languages.sh [-l "deu fin"] <product>`.
- **Shared simulator.** `tools/run_tests.sh`, `tools/fit_all.sh`, `tools/fit_products.sh` and `tools/fit_languages.sh` `pkill -f monkeydo` after every run (which ends any app another session has running in the simulator) and `pkill` the simulator itself when it wedges. If another session or the owner is using it, do not run them; check first. Never `pkill` it by hand for someone else.
- **No full wear day yet.** Everything but a few spot-checks is simulator-only until the owner's FR965 wear test (plan phase 9). The simulator has no GPS position, canned weather, canned sun values and synthetic Body Battery: it can prove layout and logic, never data. No screenshot of the face exists; the environment cannot capture the simulator. What HAS run on the FR965: the location probes (2026-09-27, M1 and M2; `device-test/LocationProbe-RESULTS.md`, confirmed Positioning, ADR-005 — M3, M4 and the glance/widget comparisons still open, not blocking), a sunrise/sunset comparison against the native glance (exact match, gate 3), and on-watch Customize (ADR-019).

## Open owner decisions

Not decided, and not to be decided alone: the look (colours, glyph, layout, the rectangles) and the launcher icon (a generic placeholder now); the price flip rule; tier B (v1.1); screenshots (owner supplies); the site deploy; the store submission. Decided: the name (Two Suns, ADR-010), the category (Utility), the Positioning permission (kept; ADR-005), languages (ship all 15). Full list with gates: [`docs/publish-checklist.md`](docs/publish-checklist.md).

Price: paid, USD 1.99, Garmin's first paid price step, same tier as Days To Go (spec D3, ADR-002).
Price review due: not set until approval. On the day approval arrives set it to approval + 45 days here and in the memory index.

## House rules

Same as Days To Go ([`../DaysToGo/CLAUDE.md`](../DaysToGo/CLAUDE.md)) and HeroFace ([`../HeroFace/CLAUDE.md`](../HeroFace/CLAUDE.md)), which this project mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only after `instanceof` or a null guard.
- No magic numbers: tunables and keys in `TwoSunsConfig`, geometry in `TwoSunsLayout`, colours in `TwoSunsPalette`, words in `strings.xml`.
- Text fit is measured, never guessed: draw through `TwoSunsDraw`.
- Render only in `onUpdate`; gather in `TwoSunsSources`/`TwoSunsReadings`, draw from a `TwoSunsState`.
- One class per file, `TwoSuns` prefix. Functions ≲30 lines, files ≲250.
- A value the watch does not have is hidden or said in words, never faked or blank ("No place yet", "No sun data", `--`).
- Forbidden here: `Weather.getSunrise` as the primary source; `date` or `numeric` settings; any mood, emoji or advice tied to Body Battery; the network; `Background`, `Communications`, `UserProfile`; seconds; storing anything but the rounded place; a permissioned call outside a manifest that declares it. Do not add anything from the spec's non-goals.
- Warnings and strict typing on, zero warnings (`-w --typecheck 3`; the only accepted notices are launcher-icon scaling until the real icon ships).
- Do not invent evidence: no reviews, downloads, screenshots, battery figures or accuracy claims about Body Battery, in any doc or listing. Say "simulator only" wherever a claim rests on the simulator.

## Keeping things in sync

- Behaviour change → `docs/spec.md` (and `DESIGN.md` if visual) in the same session; a durable decision → an ADR in `docs/decisions.md`.
- New layout or string → run the screen-fit test for each screen size and update `docs/compatibility.md`. New string → `tools/check_strings.py`.
- Settings change → `tools/gen_settings.py`, then `--check`.
- User-facing claims live in the listing and `../site/src/apps/two-suns/`; change both together, never change a published URL. Check every claim against `docs/release-contract.md`.
- Every store publication gets a `CHANGELOG.md` entry and a What's New block in `listing/README.md`.
- Test count appears in `README.md` and here (**124**); update both.
- Edits outside `TwoSuns/` are limited to the root `CLAUDE.md` table row, the root `README.md`, and `site/`. Ask before touching `HeroSet/`, `HeroFace/` or `DaysToGo/`.
