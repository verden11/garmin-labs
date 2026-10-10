# Repo patterns and reuse for the Sun Window widget

Scope: what in the studio monorepo the new `SunWindow/` widget (Free only, glance + full view, no background, no notification; `SunWindow/docs/spec.md`, ADR-002, ADR-003) should copy or mirror. Read-only survey of the worktree `/Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake` on 2026-10-04. All paths below are relative to that root. Evidence levels are tagged: **[code]** read in source, **[doc]** a project doc says so, **[sim]** simulator-only, **[compiler]** build output, **[FR965 probe]** / **[FR965 wear]** owner's real watch.

**Top-line gap (read first):** there is **no widget anywhere in this repo**. Every manifest is `type="watchface"` (TwoSuns, DaysToGo, HeroFace, DayArc) or `type="watch-app"` (HeroSet), and every probe app is `watchface` — [TwoSuns/manifest.free.xml:4](TwoSuns/manifest.free.xml), [DayArc/manifest.simple.xml:5](DayArc/manifest.simple.xml), [HeroFace/manifest.xml:4](HeroFace/manifest.xml), [DaysToGo/manifest.xml:4](DaysToGo/manifest.xml), [HeroSet/manifest.xml:8](HeroSet/manifest.xml), [research_notes/Body Battery and sun face research/probe/on-watch/manifest-P.xml:3](research_notes/Body%20Battery%20and%20sun%20face%20research/probe/on-watch/manifest-P.xml). The only glance precedent is HeroSet's (a watch-app glance), and it has never been observed running in glance mode on a watch ([HeroSet/docs/decisions.md:369](HeroSet/docs/decisions.md)). The platform notes record (forum-grade) that a `widget` manifest on CIQ 4+ is built as a watch-app ([research_notes/Vitamin D window/platform_and_permissions.md:175](research_notes/Vitamin%20D%20window/platform_and_permissions.md)).

---

## 1. Shared project file layout, and how the SunWindow scaffold differs

### Takeaway
Every watch project has the same tree (root `README.md` "Layout"); the `SunWindow/` scaffold came from the watch-design-kit template, not from that tree, so it lacks `PRODUCT.md`, `docs/README.md`, `docs/status.md`, `listing/paste.md` + `meta.yaml`, and all code (`source/`, `resources/`, manifest, jungle, `tools/`). Source naming is `<Prefix><Role>.mc`, one class per file, with Config / Layout / Palette / Draw / Settings / Sources(Readings) / State / View roles.

### Cited Findings
- Root layout tree, verbatim:
  ```
  HeroSet/ · HeroFace/ · DaysToGo/ · TwoSuns/ · DayArc/
    README.md  CLAUDE.md  CHANGELOG.md   one CHANGELOG entry per store publication
    PRODUCT.md  DESIGN.md                what it is, how it looks (HeroSet has no DESIGN.md)
    docs/
      README.md                          the index of this folder
      spec.md or PRODUCT/architecture    what the product is and its rules
      decisions.md                       ADRs (why); never deleted, only superseded
      compatibility.md                   products, API levels, memory, evidence per device
      release-contract.md                what may be claimed
      development.md                     commands, tests, how to debug
      status.md                          where things stand, evidence, release gates, upload steps (no open checkboxes: those are in ROADMAP.md)
      archive/                           finished plans, mockups, shelved plans
    listing/ (listing-free/ or listing-pro/ beside it)
      paste.md                           ONLY the copy-and-paste form blocks, in upload-form order
      meta.yaml                          status, version, package, price, limits, assets, open ids
      NOTES.md                           why each answer is what it is; history
      screenshots.md  screens/  src/     how the images are made; the images
    source/  resources*/  manifest*.xml  *.jungle  tools/
  ```
  — [README.md "Layout"](README.md)
- SunWindow scaffold contents: `CHANGELOG.md CLAUDE.md DESIGN.md README.md docs/{compatibility,decisions,development,plan,publish-checklist,release-contract,spec}.md listing/{NOTES,README,screenshots}.md`; no source, resources, manifest, jungle or tools — [fd listing of SunWindow/](SunWindow/). `listing/README.md` is named where the repo uses `listing/paste.md` + `listing/meta.yaml` — [SunWindow/CLAUDE.md "Layout"](SunWindow/CLAUDE.md) vs [README.md "Layout"](README.md). `docs/development.md`, `docs/plan.md` and `DESIGN.md` are unfilled `{{...}}` templates — [SunWindow/docs/development.md](SunWindow/docs/development.md), [SunWindow/docs/plan.md](SunWindow/docs/plan.md), [SunWindow/DESIGN.md](SunWindow/DESIGN.md). Note: the scaffold's `development.md` build line writes `-o bin/Sun Window.prg` (a space in the file name) — [SunWindow/docs/development.md](SunWindow/docs/development.md).
- Closest code template (TwoSuns, a single codebase split Free/Pro by annotation): `source/` holds `TwoSunsApp, TwoSunsView, TwoSunsConfig (constants and keys), TwoSunsLayout (geometry), TwoSunsPalette (colours), TwoSunsDraw (measured text), TwoSunsSettings (validated Properties), TwoSunsSources (the one class that touches the watch), TwoSunsReadings (pure state builder), TwoSunsState (what is drawn), TwoSunsLocalTime, TwoSunsCalendar, TwoSunsSun, TwoSunsSunDay, TwoSunsPlace, TwoSunsWeatherSource ...`; `source/settings/` holds the Customize menu classes; `source/test/` holds `*Test.mc` and a shared `TwoSunsTestStates` class; resources are `resources/` (shared strings, drawables), `resources-<lang>/strings/`, `resources-free/`, `resources-pro/`, `resources-accent-*/` — [TwoSuns file listing](TwoSuns/source), [TwoSuns/CLAUDE.md "House rules"](TwoSuns/CLAUDE.md).
- House code rules SunWindow already copied: typed params and `as` returns, no `as Any`; no magic numbers (Config / Layout / Palette / strings.xml); draw text through `<Prefix>Draw`; render only in `onUpdate`, gather in Sources/Readings, draw from a State; one class per file, functions ≲30 lines, files ≲250; a missing value is hidden or said in words — [SunWindow/CLAUDE.md "Code conventions"](SunWindow/CLAUDE.md), same as [TwoSuns/CLAUDE.md "House rules"](TwoSuns/CLAUDE.md). TwoSuns adds: zero warnings at `-w --typecheck 3` (launcher-icon scaling notice the only accepted one) — [TwoSuns/CLAUDE.md "House rules"](TwoSuns/CLAUDE.md).

### Inferences
- Planner task: before code, bring the scaffold to the repo layout: add `PRODUCT.md` (or keep `spec.md`, which the layout allows), `docs/README.md`, `docs/status.md`; rename `listing/README.md` → `listing/paste.md` and add `listing/meta.yaml` (copy shape from `TwoSuns/listing-free/meta.yaml`); fix `bin/Sun Window.prg` → `bin/SunWindow.prg`.
- Code layout to create: `SunWindow/manifest.xml`, `SunWindow/monkey.jungle` (must be named exactly this; see section 7), `resources/{strings,settings,drawables}/`, `resources-<lang>/strings/` later, `source/` with `SunWindowApp, SunWindowView, SunWindowGlanceView, SunWindowConfig, SunWindowLayout, SunWindowPalette, SunWindowDraw, SunWindowSettings, SunWindowSources, SunWindowState, SunWindowLocalTime, SunWindowCalendar, SunWindowSun, SunWindowPlace`, `source/test/`, `tools/`.
- Being Free-only, SunWindow needs **one** manifest and **one** jungle and no `(:free)`/`(:pro)` annotations; every tier-split mechanism in TwoSuns (twin functions, `resources-free`/`resources-pro`, AppName in a tier folder, `check_free_package.sh`) can be dropped.

### Gaps
- Whether `type="widget"` is the right manifest type at API 5.1+ (vs `watch-app` with a glance) has no in-repo precedent; see top-line gap.

---

## 2. TwoSuns solar maths: what exists, and what Sun Window must add

### Takeaway
`TwoSuns/source/TwoSunsSun.mc` is a pure, permission-free NOAA sunrise-equation port in **32-bit Float**, evaluated **once per day at local noon**, returning **rounded** whole minutes. Its `cosHourAngle`/`halfDay` already answer "when does the sun cross a given zenith" — `halfDay(45.0, ...)` is the 45-degree window half-width and `cosHourAngle(45.0, ...) > 1` is NONE TODAY — so reuse is near-total, but Sun Window must (a) port to Double, (b) add a per-instant `elevationAt`, (c) match the fixtures' ceil/floor minute convention, and (d) tighten tests from 2 minutes vs USNO to 1 minute / 0.02 degrees vs the new fixtures.

### Cited Findings
- File and scope: `TwoSunsSun.compute(year, month, day, latitude as Float, longitude as Float, offsetMinutes)` → `TwoSunsSunDay` (rise, set, noon, civil begin/end, golden morning end/evening start, kind) — [TwoSuns/source/TwoSunsSun.mc:15-38](TwoSuns/source/TwoSunsSun.mc); data class [TwoSuns/source/TwoSunsSunDay.mc:7-30](TwoSuns/source/TwoSunsSunDay.mc). Class is `(:pro)` in TwoSuns — [TwoSunsSun.mc:10](TwoSuns/source/TwoSunsSun.mc).
- Formulas: NOAA spreadsheet / Meeus series — T in Julian centuries, mean longitude `280.46646 + t*(36000.76983 + t*0.0003032)`, mean anomaly, eccentricity, equation of centre, apparent longitude with nutation `-0.00569 - 0.00478 sin(node)`, obliquity `23.43929 - 0.0130042 t + 0.00256 cos(node)`, declination `asin(sin(obl) sin(appLong))`, equation of time from the `y = tan²(obl/2)` series — [TwoSunsSun.mc:41-60](TwoSuns/source/TwoSunsSun.mc). Not Spencer. The fixture script uses the same NOAA/Meeus chain — [research_notes/Vitamin D window/solar_elevation_fixtures.md:16](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md).
- Hour angle at a zenith: `cosHourAngle(zenith, lat, dec) = cos(zenith)/(cos lat cos dec) - tan lat tan dec`; `halfDay` returns `4 * degrees(acos(cosH))` minutes, or null outside -1..1 — [TwoSunsSun.mc:63-76](TwoSuns/source/TwoSunsSun.mc). Solar noon `720 - 4*longitude - EoT + offsetMinutes` — [TwoSunsSun.mc:21-22](TwoSuns/source/TwoSunsSun.mc). Zeniths are constants (`ZENITH_HORIZON = 90.833`, `ZENITH_CIVIL = 96.0`, `ZENITH_GOLDEN = 84.0`) — [TwoSuns/source/TwoSunsConfig.mc:29-31](TwoSuns/source/TwoSunsConfig.mc).
- Precision: "Monkey C floats are 32-bit, so the maths runs on days since J2000, never on a Julian date"; all trig goes through `fSin/fCos/fTan/fAsin/fAcos` wrappers that call `.toFloat()` — [TwoSunsSun.mc:7-8, 94-113](TwoSuns/source/TwoSunsSun.mc); "`Toybox.Math` returns `Float` or `Double`: wrap results with `.toFloat()`" — [TwoSuns/docs/development.md:133](TwoSuns/docs/development.md). Times are `Math.round(minutes)` — [TwoSunsSun.mc:78-80](TwoSuns/source/TwoSunsSun.mc).
- Epoch: `daysSinceJ2000 = dayNumber(y,m,d) - J2000_DAY_NUMBER - offsetMinutes/1440`, with `J2000_DAY_NUMBER = 10957` = "2000-01-01 00:00 UT; J2000.0 is 12 hours later" — [TwoSunsSun.mc:17-18](TwoSuns/source/TwoSunsSun.mc), [TwoSunsConfig.mc:21-22](TwoSuns/source/TwoSunsConfig.mc). `dayNumber` is days since 1970-01-01 (proleptic Gregorian, integer only) — [TwoSuns/source/TwoSunsCalendar.mc:27-35](TwoSuns/source/TwoSunsCalendar.mc). The fixture script uses `T = (JD - 2451545.0)/36525` — [solar_elevation_fixtures.py:58](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.py).
- Declination and EoT are computed once per date, at local noon (ADR-004: "evaluated at the local noon of the local date") — [TwoSuns/docs/decisions.md:115](TwoSuns/docs/decisions.md). The fixture script computes elevation per minute (`elev_from(lat, lon, utc_min_of_day, decl, eot)`, `ha = tst/4 - 180`), and defines window edges as "first / last WHOLE MINUTE whose geometric elevation is >= 45 deg (first = ceil of the crossing, last = floor)" — [solar_elevation_fixtures.py:77-84](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.py), [solar_elevation_fixtures.md:17](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md).
- Fixture accuracy: NOAA Double port agrees with JPL Horizons within 0.0061 degrees over 51,876 samples; whole-minute 45 and 30 degree windows identical in 71 of 72 cases (one +1 minute) — [solar_elevation_fixtures.md:9](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md). Table A gives per place/date `>=45 first/last` (e.g. Vilnius 2026-06-21 10:26–16:16 at +3; Vilnius 2026-03-20 "never") — [solar_elevation_fixtures.md Table A](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md).
- TwoSuns tests: `TwoSunsSunReferenceTest.mc` is GENERATED by `tools/gen_sun_tests.py` from `research_notes/Body Battery and sun face research/reference_sun_times.tsv` (27 USNO rows), tolerance 2 minutes, helpers `sunAssertNear`/`sunAssertNoonNear` are `(:debug)` — [TwoSuns/source/test/TwoSunsSunReferenceTest.mc:1-22](TwoSuns/source/test/TwoSunsSunReferenceTest.mc), [TwoSuns/docs/development.md:116-118](TwoSuns/docs/development.md). Hand tests: day order, after-midnight sunset not wrapped (Reykjavik 21 June), equator day 715–730 min every month, years 2001–2100 give a sane noon — [TwoSuns/source/test/TwoSunsSunTest.mc](TwoSuns/source/test/TwoSunsSunTest.mc). Evidence level: [sim] only; "Not verified: that a watch's float behaviour equals the simulator's" — [TwoSuns/docs/decisions.md:117](TwoSuns/docs/decisions.md).
- Licence note: "No copy of any library: the only public Monkey C one is LGPL" — [TwoSuns/docs/decisions.md:115](TwoSuns/docs/decisions.md).
- Spec requirement: "a `Double` port of the full NOAA formulas must match `solar_elevation_fixtures.md` to 0.02 degrees and 1 minute on window edges (2026 values only; never assert exact edge dates)" — [SunWindow/docs/spec.md "Data sources"](SunWindow/docs/spec.md); device check D9 — [SunWindow/docs/spec.md "Device checks"](SunWindow/docs/spec.md).
- No Double-precision solar code exists anywhere in the repo's `.mc` sources (rg for `Double|toDouble` hits only TwoSunsPlace/Readings type checks, DaysToGo/HeroFace readings and probes) — [rg over *.mc](TwoSuns/source/TwoSunsPlace.mc).

### Inferences
- **Copy** `TwoSunsSun.mc` → `SunWindowSun.mc`, `TwoSunsCalendar.mc` → `SunWindowCalendar.mc`, `TwoSunsLocalTime.mc` → `SunWindowLocalTime.mc` (exact UTC offset, ADR-012), and the needed constants from `TwoSunsConfig.mc:9-31`. **Drop** `(:pro)`, the civil/golden outputs and `SunWindowSunDay`'s unused fields.
- **Adapt to Double:** change `Float` types to `Double`, the `f*` wrappers' `.toFloat()` → `.toDouble()`, and give literals a `d` suffix (e.g. `280.46646d`) so Monkey C does not narrow them to Float (the `d` suffix convention is from general Monkey C knowledge, not verified in this repo — confirm by compiling at `--typecheck 3`).
- **J2000 half-day, worked out:** `dayNumber - 10957` counts days from 2000-01-01 00:00 UT; subtracting `offset/1440` moves to local midnight in UT, which is 0.5 day *before* J2000-relative local noon, while J2000 itself is 0.5 day after the 10957 origin — the two halves cancel, so TwoSuns' value is exactly "days from J2000 to local noon". A per-minute port must therefore use `days = dayNumber - 10957 - 0.5 + (minuteOfDay - offsetMinutes)/1440` (minutes local). Pin this with a test against the fixture C0 spot checks.
- **Window edges and NONE TODAY:** `halfDay(45.0, lat, dec)` (zenith 45 = elevation 45) around solar noon gives open/close; `cosHourAngle > 1` = sun never reaches 45 (NONE TODAY). That is a two-line reuse. **OPEN now** can be `open <= nowMinute <= close`, avoiding a separate elevation call, but D9's 0.02-degree elevation check needs an explicit `elevationAt(days, lat, lon, utcMinute)` = `90 - acos(sin lat sin dec + cos lat cos dec cos HA)` with `HA = (utcMin + EoT + 4*lon)/4 - 180` (the fixture's formula, [solar_elevation_fixtures.md:16](research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md)). TwoSuns has no such function.
- **Noon-frozen declination:** acceptable for window edges (declination moves at most about 0.4 degrees a day, so a few hours off noon moves the 45-degree crossing well under a minute — an inference, to be confirmed by the fixture test), but for elevation at arbitrary instants call `declinationAndEquationOfTime(days)` at the sample instant, as the fixtures do.
- **Rounding convention:** fixtures use ceil for the opening minute and floor for the closing minute; TwoSuns uses `Math.round`. With a 1-minute tolerance this passes either way, but if tests assert exact equality, switch to ceil/floor.
- **Test generator:** copy `TwoSuns/tools/gen_sun_tests.py` → `SunWindow/tools/gen_sun_tests.py`, but it reads a TSV; the fixtures are Markdown tables (Tables A, C0). Either export a TSV from `solar_elevation_fixtures.py` or parse the Markdown. Skip the 2026-04-19 Sydney edge date per spec.
- Refraction: the fixtures and spec are geometric (no refraction), whereas TwoSuns' 90.833 zenith includes refraction for sunrise — keep 45 degrees geometric (`zenith = 45.0`).

### Gaps
- Watch float/double behaviour vs simulator is unverified for TwoSuns ([sim] only); D9 is open.
- Whether Monkey C `Math.acos` etc. return Double when given Double was not checked in-repo (development.md only says "Float or Double").

---

## 3. TwoSuns location handling (ADR-005, ADR-006): exact code path

### Takeaway
Location is read only in `TwoSunsSources` (Pro), in the order Activity → Weather observation → `Position.getInfo()` → saved place; on the owner's FR965 only `Position.getInfo()` worked (a cached fix, immediately). The place is rounded to 0.1 degree, validated, written to `Application.Storage` key `place` only when it moves more than 0.1 degree, and read back tolerantly. Sun Window can copy `TwoSunsPlace.mc` whole and the `updatePlace`/`positionLocation` pattern, dropping the two sources that were null on the FR965 (the spec already says so).

### Cited Findings
- Order and permission: "`Activity.getActivityInfo().currentLocation`, then the Weather observation location, then `Position.getInfo()`, then the saved place ... The manifest declares `Positioning`, now confirmed" — [TwoSuns/docs/decisions.md:120-126](TwoSuns/docs/decisions.md).
- Device evidence [FR965 probe, 2026-09-27]: `Activity.currentLocation` stayed null even after a GPS run; Weather observation location null throughout; `Position.getInfo()` returned a location immediately with no GPS activity (cached fix). Simulator was the opposite (always null without an activity). M3 (outdoors over time) and M4 (overnight) not run — [TwoSuns/docs/decisions.md:123-124](TwoSuns/docs/decisions.md).
- Code path: constructor reads `TwoSunsPlace.fromStorage(Application.Storage.getValue(KEY_PLACE))` — [TwoSuns/source/TwoSunsSources.mc:38-40](TwoSuns/source/TwoSunsSources.mc); `updatePlace()` picks the first usable of `[activityLocation(), weatherLocation(), positionLocation()]`, saves with `Application.Storage.setValue(KEY_PLACE, [lat, lon])` inside try/catch only when `shouldReplace` — [TwoSunsSources.mc:139-150](TwoSuns/source/TwoSunsSources.mc); `positionLocation()` = `degrees(Toybox.Position.getInfo().position)` in try/catch — [TwoSunsSources.mc:185-194](TwoSuns/source/TwoSunsSources.mc); `degrees()` uses `location.toDegrees()` → `[Float, Float]` — [TwoSunsSources.mc:152-159](TwoSuns/source/TwoSunsSources.mc). The sun is recomputed only when the local date, place or offset changes — [TwoSunsSources.mc:115-134](TwoSuns/source/TwoSunsSources.mc).
- Rounding and validation (`TwoSunsPlace`): `round` to 0.1 degree (`PLACE_TENTHS = 10.0`); `isUsable` rejects exact (0,0) ("null island", `NULL_ISLAND_DEGREES = 0.000001`) and anything outside ±90/±180; `shouldReplace` only when more than `PLACE_REPLACE_DEGREES 0.1 + PLACE_EPSILON 0.001` away; `fromStorage` accepts Float, Double or Number and re-validates — [TwoSuns/source/TwoSunsPlace.mc:10-61](TwoSuns/source/TwoSunsPlace.mc), constants [TwoSunsConfig.mc:56-65](TwoSuns/source/TwoSunsConfig.mc). Rationale and "never sent anywhere" — [TwoSuns/docs/decisions.md:129-135](TwoSuns/docs/decisions.md). Tests: `TwoSunsPlaceTest` (rounding, order, replace only when moved, empty, (0,0), storage types) [sim] — [TwoSuns/source/test/TwoSunsPlaceTest.mc](TwoSuns/source/test/TwoSunsPlaceTest.mc).
- Hazard: "`Position.getInfo()` without the Positioning permission ends the app and cannot be caught; it is isolated in `TwoSunsSources.positionLocation`" — [TwoSuns/docs/development.md:139](TwoSuns/docs/development.md). `Activity.getActivityInfo()` is typed never-null so the code catches instead of null-checking — [TwoSunsSources.mc:162-170](TwoSuns/source/TwoSunsSources.mc).
- Permission declaration: Pro manifest lists `Positioning` (Free manifest has `ComplicationSubscriber` only) — [TwoSuns/manifest.free.xml](TwoSuns/manifest.free.xml), [TwoSuns/docs/decisions.md:257-258](TwoSuns/docs/decisions.md).
- Spec for Sun Window: `Position.getInfo()` in the foreground, rounded to 0.1 degree, kept in Storage; Activity and Weather location not used; never-opened → glance shows an "open once" state; whether a glance may call `Position` is untested (D6) — [SunWindow/docs/spec.md "Data sources"](SunWindow/docs/spec.md).
- Reusable probe sources for D6: `research_notes/Body Battery and sun face research/probe/on-watch/PosProbe-with-positioning.mc`, `PosProbe-no-positioning.mc`, `manifest-P.xml`/`manifest-N.xml` (both `type="watchface"`) — [probe folder](research_notes/Body%20Battery%20and%20sun%20face%20research/probe/on-watch/manifest-P.xml).

### Inferences
- **Copy** `TwoSunsPlace.mc` → `SunWindowPlace.mc` unchanged except prefix and removing `(:pro)`; keep it Float (0.1-degree storage does not need Double; convert to Double at the sun-maths boundary).
- **Mirror** `updatePlace()` with a single fresh source (`positionLocation()` only) plus the saved place, called from the full-screen view's data layer (foreground), never from the glance until D6 says otherwise. Keep `Position.getInfo()` in exactly one function, as ADR-005 asks.
- Declare `<iq:uses-permission id="Positioning"/>` in `SunWindow/manifest.xml`; the release contract must then never say "no location" (spec already says this).
- Glance reads the stored place via `Application.Storage.getValue` (glances may read Storage, [platform_and_permissions.md:172](research_notes/Vitamin%20D%20window/platform_and_permissions.md)); `fromStorage` must therefore be `(:glance)`.
- For D6, copy the PosProbe pair and change the manifest type to `widget`, adding a `getGlanceView` that also calls `Position.getInfo()`.

### Gaps
- No probe has run as a widget or in a glance; D6 open.
- M3/M4 (outdoor drift, overnight) never run for TwoSuns either.

---

## 4. TwoSuns weather (ADR-022) and Toybox.Weather null handling

### Takeaway
`TwoSunsWeatherSource` is the only Weather reader in the repo: `Toybox has :Weather` guard, whole read in try/catch, 5-minute cache, keep-last-good on an empty or failed read, null-checks every field and list. It reads `condition`, `feelsLikeTemperature`, `temperature`, `observationTime`, hourly and daily lists — **never `uvIndex` or `cloudCover`**, which Sun Window needs (API 5.1.0+). The shape is reusable; the fields and the age rule must be added.

### Cited Findings
- Reader: `readWeather()` returns null if `!(Toybox has :Weather)`, wraps `readCurrent/readHourly/readDaily` in `try ... catch (e instanceof Lang.Exception)`, returns null when `data.isEmpty()` — [TwoSuns/source/TwoSunsWeatherSource.mc:43-56](TwoSuns/source/TwoSunsWeatherSource.mc). Cache: re-read at most every `WEATHER_REFRESH_SECONDS`; a failed/empty read keeps the last good data — [TwoSunsWeatherSource.mc:31-41](TwoSuns/source/TwoSunsWeatherSource.mc). Current: `getCurrentConditions()` null-checked, `observationTime` null-checked before `.value()` — [TwoSunsWeatherSource.mc:58-67](TwoSuns/source/TwoSunsWeatherSource.mc). Hourly: loop guards `hours != null`, skips entries with null `forecastTime` — [TwoSunsWeatherSource.mc:69-78](TwoSuns/source/TwoSunsWeatherSource.mc).
- Rules: "A read that fails or comes back empty keeps the last good data ... No forecast, or forecast entries older than the current hour: those cells are not drawn. `observationTime` older than 3 hours (proposal): the now cell is not drawn. Nothing at all: the row is absent ... Never an invented or greyed value" — [TwoSuns/docs/decisions.md:56](TwoSuns/docs/decisions.md). No permission needed for Weather — [TwoSuns/docs/decisions.md:59](TwoSuns/docs/decisions.md).
- Device evidence [FR965 probe photos 2026-10-03, FR965 wear 2026-10-03/04]: hourly list 12 entries 60 min apart starting at the **current hour**; daily list 5 entries stamped at local midnight; observation 18–20 minutes old; weather re-issued about hourly; row matched Garmin's Weather widget at 09:11 — [TwoSuns/docs/decisions.md:66, 69](TwoSuns/docs/decisions.md). Simulator weather is canned (66 °F, partly cloudy) and the Set Weather editor did not change what the face read — [docker/SIMULATOR.md "What the simulator's data is"](docker/SIMULATOR.md), [TwoSuns/docs/development.md:150](TwoSuns/docs/development.md).
- In TwoSuns the "name Weather in full, do not import" rule exists only so an un-annotatable `import` does not leak into the Free tier — [TwoSuns/docs/development.md:94, 130](TwoSuns/docs/development.md).
- Sun Window needs `uvIndex` (0–10 Float) and `cloudCover` (0–100 Number) on `CurrentConditions` and `HourlyForecast`, API 5.1.0+ — [research_notes/Vitamin D window/platform_and_permissions.md:15, 22](research_notes/Vitamin%20D%20window/platform_and_permissions.md); demote OPEN only — [SunWindow/docs/spec.md "What it does"](SunWindow/docs/spec.md). D2 (non-null, plausible on a real watch) open — [SunWindow/docs/spec.md "Device checks"](SunWindow/docs/spec.md).
- The existing weather probe (`research_notes/Two Suns temperature research/probe/`) is a `watchface` and does not read `uvIndex`/`cloudCover` (rg found neither) — [probe manifest](research_notes/Two%20Suns%20temperature%20research/probe/manifest.xml).

### Inferences
- **Copy** the `TwoSunsWeatherSource` skeleton → `SunWindowWeather.mc`: has-guard, try/catch, 5-minute cache, keep-last-good, null-check each field. **Add** `uvIndex`/`cloudCover` reads with `has :uvIndex`-style guards (API 5.1 fields on a 5.1 floor are still worth guarding against null). **Add** an age rule: use the current-hour hourly entry (FR965 shows the list starts at the current hour) or `CurrentConditions` if `observationTime` is under 3 hours old; otherwise no demotion (weather never promotes).
- In a single-tier app `import Toybox.Weather;` is fine; the full-name rule does not apply.
- D2 probe: extend `WeatherProbeApp.mc` to print `uvIndex`/`cloudCover` for current and hourly.

### Gaps
- No studio evidence that `uvIndex`/`cloudCover` are non-null on any watch.

---

## 5. HeroSet glance: construction, scope rules, memory lessons, tests

### Takeaway
HeroSet's glance is a `(:glance)`-annotated, read-only `GlanceView` whose `onUpdate` reads Storage through a tiny reader on every draw; the `AppBase` subclass is `(:glance)` and does nothing in `initialize`/`onStart`; foreground-only methods carry `(:typecheck(disableGlanceCheck))`; glance strings carry `scope="glance"`; a separate script compiles at `-l 3` to catch scope leaks the default build misses. Memory is measured with `--build-stats 0` at about 5.4 KB of 64 KB (2.1+3.4 KB of 32 KB on Instinct E) [compiler]; no glance has run in glance mode on a watch.

### Cited Findings
- App class: `(:glance) class HeroSetApp extends Application.AppBase`; empty `onStart` "because it also runs for the glance"; `getGlanceView() as [WatchUi.GlanceView] or [WatchUi.GlanceView, WatchUi.GlanceViewDelegate] or Null { return [ new HeroSetGlanceView() ]; }`; `getInitialView`, `getStore`, `getSync`, `onStop` carry `(:typecheck(disableGlanceCheck))` and build heavy objects lazily — [HeroSet/source/app/HeroSetApp.mc:5-60](HeroSet/source/app/HeroSetApp.mc).
- View: `(:glance) class HeroSetGlanceView extends WatchUi.GlanceView`, font `Graphics.FONT_GLANCE`, reads state on every `onUpdate` ("a live glance can outlive midnight"), no background fill ("the system draws the themed card behind a glance"), text measured with `dc.getTextWidthInPixels` and a longest-first candidate list, `drawState(dc, w, h, state)` split out so tests can draw into a bitmap at any glance size, `loadResource` result checked `instanceof String` — [HeroSet/source/ui/glance/HeroSetGlanceView.mc:6-160](HeroSet/source/ui/glance/HeroSetGlanceView.mc). Instinct window via `WatchUi.getSubscreen()` guarded by `has` and `SCREEN_SHAPE_SEMI_OCTAGON` — [HeroSetGlanceView.mc:41-50](HeroSet/source/ui/glance/HeroSetGlanceView.mc).
- Reader: `(:glance) class HeroSetGlanceReader`, static `read(storage, today)`, never writes, narrows Number/Float, stale day reads as 0 — [HeroSet/source/data/HeroSetGlanceReader.mc:1-45](HeroSet/source/data/HeroSetGlanceReader.mc).
- ADR-051 rules: never writes; list of `(:glance)` classes; "The glance process loads the whole `HeroSetApp` class, so `initialize`, `onStart`, `onStop`, `getGlanceView` and `onUpdate` touch only `(:glance)` code"; strings carry `scope="glance"` in all 15 `strings.xml`; "The default build is silent when glance code reaches foreground code. `monkeyc -w -l 3 … | grep "not available in all function scopes"` must print nothing" — [HeroSet/docs/decisions.md:349-363](HeroSet/docs/decisions.md). Example: `<string id="dashboard_streak" scope="glance">` — [HeroSet/resources/strings/strings.xml:33-35](HeroSet/resources/strings/strings.xml).
- Scope check script: builds app and `-t` for each jungle at `-l 3` and greps for the scope message — [HeroSet/tools/glance-scope-check.sh:1-33](HeroSet/tools/glance-scope-check.sh) (it uses the host SDK, not the container).
- Memory [compiler]: "Glance closure on fr965: 5,430 bytes store build (data 2,112 + code 3,318) ... against 65,536"; Instinct E 40 mm 2,139 + 3,451 B against the 32 KB limit; runtime heap not measurable in the simulator CLI — [HeroSet/docs/decisions.md:367, 446, 457](HeroSet/docs/decisions.md). "The 63 all have a 64 KB glance limit (device data; the SDK prose's 32 KB is stale)" — [HeroSet/docs/decisions.md:362](HeroSet/docs/decisions.md). Rejected alternative: annotating nothing loads the whole ~30 KB app into the glance — [HeroSet/docs/decisions.md:371](HeroSet/docs/decisions.md).
- Field lessons (forum-grade, in the research notes): realistic limit about 28 KB of an advertised 32 KB; a 3.5 kB JSON became ~12 kB as a Dictionary; `AppBase` always loaded in glance/background; compiler only warns on exceeding glance memory; SDK 8.3 broke `GlanceView` in the macOS simulator — [research_notes/HeroSet glance view research/pitfalls_and_field_evidence.md:19-47](research_notes/HeroSet%20glance%20view%20research/pitfalls_and_field_evidence.md).
- Not measured: "No glance ran in glance mode or on a watch (the simulator's Glance Launch Mode is a GUI setting): peak heap in the 64 KB process, real fonts and MIP contrast, per-language resource loading in the glance process, the idle timeout" — [HeroSet/docs/decisions.md:369](HeroSet/docs/decisions.md). Instinct glance placement is a blind layout pending a wrist — [HeroSet/docs/decisions.md:452](HeroSet/docs/decisions.md), [docker/SIMULATOR.md "What is NOT tested"](docker/SIMULATOR.md).
- Tests: `HeroSetGlanceFitTest` checks layout, status words and every state's drawing at each glance content area with that product's fonts (32 distinct areas over 63 products); `HeroSetGlanceReaderTest` pins key spellings against the real store — [HeroSet/docs/decisions.md:357, 367](HeroSet/docs/decisions.md), files [HeroSet/source/test/HeroSetGlanceFitTest.mc](HeroSet/source/test/HeroSetGlanceFitTest.mc), [HeroSet/source/test/HeroSetGlanceReaderTest.mc](HeroSet/source/test/HeroSetGlanceReaderTest.mc).
- Platform lesson for Sun Window: "Glance reads at draw time must be date-safe: a glance can outlive midnight, so a stored 'window ends 14:20' should carry its own date or timestamp" — [research_notes/Vitamin D window/platform_and_permissions.md:182](research_notes/Vitamin%20D%20window/platform_and_permissions.md).

### Inferences
- **Mirror** `HeroSetApp` → `SunWindowApp`: `(:glance)` class, empty `onStart`, `getGlanceView` returning `[new SunWindowGlanceView()]`, foreground methods `(:typecheck(disableGlanceCheck))`.
- **Mirror** `HeroSetGlanceView` → `SunWindowGlanceView`: `FONT_GLANCE`, no fill, longest-first word candidates, `drawState` split for tests, `getSubscreen` guard for Instinct E/3 Solar.
- Glance closure must include: `SunWindowConfig`, `SunWindowCalendar`, `SunWindowLocalTime`, `SunWindowSun`, `SunWindowPlace` (fromStorage), `SunWindowPalette`, state class — all `(:glance)`. Computing the sun in the glance (not just reading a stored state) avoids the stale-across-midnight problem; the Sun class is small (TwoSunsSun is 114 lines). **This diverges from the spec**, whose data-sources table has Storage hold a "last-known state for the glance" ([SunWindow/docs/spec.md "Data sources"](SunWindow/docs/spec.md)); the planner should pick one explicitly (compute-in-glance from the stored place, or a stored state that carries its own date).
- **Copy** `HeroSet/tools/glance-scope-check.sh` → `SunWindow/tools/glance-scope-check.sh`; change the jungle loop from `monkey store` to `monkey` only.
- **Copy** the `HeroSetGlanceFitTest` approach for a glance fit test; measure with `--build-stats 0` on `instincte40mm` (32 KB) and `fr965` (64 KB).

### Gaps
- No glance precedent for a `widget` type, and none observed in glance mode on any watch (D7 open).
- Whether the glance can call `Position.getInfo()` (D6).

---

## 6. Accent colour setting: implementation pattern and rules

### Takeaway
Accent is a list setting with append-only integer ids, stored as one `Properties` key `Accent` (type number), rendered by `settings.xml` for Garmin Connect and by an on-watch `getSettingsView` menu that writes the same key. For a single setting, **DayArc's** root-menu pattern (`getSettingsView` builds a `Menu2` list directly, one delegate) is the minimum; TwoSuns' root-menu + sub-list pair is for several settings. Every precedent is a **watch face** (Customize in the face picker); there is no in-repo evidence of `getSettingsView` on a widget or watch-app.

### Cited Findings
- Properties (one key): `<property id="Accent" type="number">0</property>` — [TwoSuns/resources-free/settings/properties.xml](TwoSuns/resources-free/settings/properties.xml). Settings list: `<setting propertyKey="@Properties.Accent" title="@Strings.setting_accent"><settingConfig type="list"><listEntry value="0">@Strings.accent_sky</listEntry> ...` ids 0–5 — [TwoSuns/resources-accent-free/settings/settings.xml](TwoSuns/resources-accent-free/settings/settings.xml).
- Reading: `TwoSunsSettings.load()` reads each key via `Application.Properties.getValue` in try/catch for `InvalidKeyException`; `within(values, key, last, fallback)` accepts only a Number in 0..last, else the default — [TwoSuns/source/TwoSunsSettings.mc:20-75](TwoSuns/source/TwoSunsSettings.mc). Palette lookup clamps index — [TwoSuns/source/TwoSunsPalette.mc:23-26](TwoSuns/source/TwoSunsPalette.mc).
- On-watch Customize, single setting (DayArc): `getSettingsView()` returns `[Menu2 of accent labels with item id = value, new DayArcAccentDelegate()]`, `setFocus(current)`, wrapped in try/catch returning null, returns null on 1-bit (`MONO`) — [DayArc/source/DayArcApp.mc:17-40](DayArc/source/DayArcApp.mc). Delegate writes `Properties.setValue(KEY, clamp(value))` in try/catch, `requestUpdate`, `popView` — [DayArc/source/DayArcAccentDelegate.mc:5-31](DayArc/source/DayArcAccentDelegate.mc). DayArc's own comment: Days To Go's FR965 verification "does not cover this select-then-exit path" — [DayArcAccentDelegate.mc:6-9](DayArc/source/DayArcAccentDelegate.mc).
- On-watch Customize, multi-setting (TwoSuns): `TwoSunsSettingsMenu` (root) + `TwoSunsListMenu`/`TwoSunsListDelegate` (sub-list, item id = stored value) — [TwoSuns/source/settings/TwoSunsListMenu.mc](TwoSuns/source/settings/TwoSunsListMenu.mc), [TwoSuns/source/settings/TwoSunsListDelegate.mc](TwoSuns/source/settings/TwoSunsListDelegate.mc), [TwoSuns/source/settings/TwoSunsSettingsDelegate.mc](TwoSuns/source/settings/TwoSunsSettingsDelegate.mc). `onSettingsChanged()` → `WatchUi.requestUpdate()` — [TwoSuns/source/TwoSunsApp.mc:40-42](TwoSuns/source/TwoSunsApp.mc).
- Why on-watch Customize exists: "a sideloaded (non-Store) app gets no settings route at all from the phone's Garmin Connect app"; [FR965 wear 2026-09-27] "Customize appears next to Apply, and all five settings round-trip" — [TwoSuns/docs/decisions.md:243-248](TwoSuns/docs/decisions.md). Every `getSettingsView` in the repo is in a watch face (DaysToGo, DayArc, TwoSuns); HeroSet (the only watch-app) has none — [rg getSettingsView](DaysToGo/source/DaysToGoApp.mc).
- Settings generation: `TwoSuns/tools/gen_settings.py` writes settings/properties from a table, `--check` verifies files and `KEY_*` constants; "A Monkey C test cannot see a changed default in `properties.xml`: the simulator keeps the last saved settings" — [TwoSuns/tools/gen_settings.py:1-25](TwoSuns/tools/gen_settings.py), [TwoSuns/docs/development.md:90](TwoSuns/docs/development.md). Lists only, never `date`/`numeric` (rival failures) — [TwoSuns/docs/decisions.md:234-238](TwoSuns/docs/decisions.md).
- Roster rules: append-only ids; each colour 64-colour-safe (channels 00/55/AA/FF) and ≥3:1 on black; dimmed form ≥3:1 and ≠ muted `#AAAAAA`; a colour must not depend on the value it decorates; lists only — [research_notes/Free and Pro ladder/accent_roster.md:17-23](research_notes/Free%20and%20Pro%20ladder/accent_roster.md). Family Free six: Sky `#55AAFF`, Mint `#55FFAA`, Amber `#FFAA00`, Pink `#FF55AA`, Violet `#AA55FF`, White `#FFFFFF` (white's dim collides with muted) — [accent_roster.md:27-34](research_notes/Free%20and%20Pro%20ladder/accent_roster.md). Each face admits a subset after checking its own reserved role colours; "Check every roster change with a unit test ...: 64-safe, ≥3:1 on black, dimmed ≥3:1, not equal to MUTED, not equal to any reserved role colour" — [accent_roster.md:46-89](research_notes/Free%20and%20Pro%20ladder/accent_roster.md). Studio direction: accent in the Free tier, lists only, checked against the face's own reserved roles — [CLAUDE.md "Studio direction"](CLAUDE.md).
- Test to copy: `(:test) class TwoSunsAccentCheck` computes WCAG contrast on black for each shipped accent and checks 64-colour channels — [TwoSuns/source/test/TwoSunsAccentTest.mc:1-40](TwoSuns/source/test/TwoSunsAccentTest.mc).
- Instinct 1-bit: the accent setting is removed (palette `MONO`, settings folder left out of the Instinct resourcePath) — [TwoSuns/monkey.free.jungle](TwoSuns/monkey.free.jungle), [TwoSuns/source/TwoSunsApp.mc:28-33](TwoSuns/source/TwoSunsApp.mc).
- SunWindow `DESIGN.md` is an unfilled template; no reserved role colours are defined yet — [SunWindow/DESIGN.md](SunWindow/DESIGN.md). Spec: "No colour keyed to a reading ... The accent colour is a user choice, never a status colour" — [SunWindow/docs/spec.md](SunWindow/docs/spec.md).

### Inferences
- **Copy** DayArc's `getSettingsView` + `DayArcAccentDelegate` (single setting, root list) → `SunWindowApp.getSettingsView` + `SunWindowAccentDelegate`; **copy** `TwoSunsSettings.within/read` → `SunWindowSettings`; **copy** `TwoSunsAccentCheck` → `SunWindowAccentTest`; one `resources/settings/{properties,settings}.xml` (TwoSuns' "no settings in shared resources/" rule is a tier-split rule and does not apply).
- Use the family Free six as candidates, ids 0–5 in TwoSuns order unless the design lead picks otherwise; drop any that collide with SunWindow's OPEN/CLOSED shapes' reserved colours once DESIGN.md names them.
- `gen_settings.py` is optional for one setting (YAGNI); hand-write the two XML files plus a `KEY_ACCENT` constant.
- `getSettingsView` must be `(:typecheck(disableGlanceCheck))` or otherwise kept out of the glance closure.

### Gaps
- **Where `getSettingsView` surfaces for a widget/app on the watch** (vs a face's Customize button) is unverified in this repo; it is a device check the spec does not yet list.

---

## 7. Test and screenshot tooling: what each does and what a new project needs

### Takeaway
Simulator runs go through `docker/run.sh` (container per run). A project plugs in by having `monkey.jungle` at its root and a `tools/run_tests.sh` that `exec`s `../../docker/run.sh <project> /ciq-docker/ciq-test.sh "$@"`. `docker/shot.sh` needs only the project folder and a jungle. The other TwoSuns scripts are copyable with small edits; several hardcode TwoSuns specifics.

### Cited Findings
- `TwoSuns/tools/run_tests.sh <device> [jungle] [testName]`: line 12 re-execs into the container unless `CIQ_DOCKER=0`; host path builds `monkeyc -t ... -w --typecheck 3` and runs `monkeydo`, trusting only a `PASSED` line — [TwoSuns/tools/run_tests.sh:1-48](TwoSuns/tools/run_tests.sh).
- `docker/run.sh <project-dir> <cmd>` mounts the project at `/work`, `docker/` at `/ciq-docker`, keys at `/keys`; image `verden-ciq:9.2.0` (sim) or `verden-ciq-build:9.2.0` (compile only) — [docker/run.sh:1-14](docker/run.sh).
- `docker/ciq-test.sh`: copies the project to a private dir (excluding bin/gen/mir/dist/.git), **defaults to `monkey.jungle`, falling back to `monkey.simple.jungle`**, builds with `MC_FLAGS` default `-w --typecheck 3` and `-y /keys/developer_key`, starts Xvfb + simulator, exit codes 0 pass / 1 fail / 2 compile / 3 no result / 4 count mismatch (`EXPECT=n`) — [docker/ciq-test.sh:1-44](docker/ciq-test.sh).
- `docker/shot.sh <project> <jungle> <device>...` → `<project>/bin/shot-<device>-face.png` (3x) and the whole window (status bar shows memory); reads the display box from `~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/simulator.json`; env `FAKETIME`, `WAIT`, `FLAGS="-r -w"` for store-like memory, `PREP`, `CIQ_TZ` — [docker/shot.sh:1-27](docker/shot.sh), [docker/SIMULATOR.md §1](docker/SIMULATOR.md). "Devices with a glance (Instinct E, 3 Solar) open on the glance in the simulator" — [docker/SIMULATOR.md "Scenario scripts"](docker/SIMULATOR.md). Listing captures use `docker/capture.sh <project> tools/listing_shots.sh` — [docker/SIMULATOR.md](docker/SIMULATOR.md).
- Rule: "A layout change is not done until you have looked at a screenshot (`docker/shot.sh`)" — [CLAUDE.md "House rules"](CLAUDE.md); simulator weather, sun times and Body Battery are canned, never a claim about real readings — [docker/SIMULATOR.md "What the simulator's data is"](docker/SIMULATOR.md). Simulator has no GPS position — [TwoSuns/docs/development.md:144](TwoSuns/docs/development.md).
- `TwoSuns/tools/compile_sweep.sh`: compiles every manifest product per jungle at `-w --typecheck 3`, fails on any warning except the launcher-icon notice; **lines 15–18 diff `manifest.xml` vs `manifest.free.xml` and exit 2 if different** — [TwoSuns/tools/compile_sweep.sh:1-42](TwoSuns/tools/compile_sweep.sh). Run in the build image: `CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh <Project> tools/compile_sweep.sh` — [docker/README.md](docker/README.md).
- `TwoSuns/tools/fit_all.sh`: runs `run_tests.sh` on ten hardcoded devices `fr255s fenix7s fenix7 fenix7x fr265s fr165 epix2 fr965 venusq2 fenix9pro51mm` — [TwoSuns/tools/fit_all.sh:7](TwoSuns/tools/fit_all.sh). `fit_products.sh` runs the suite on every manifest product into `bin/fit-products.txt` — [TwoSuns/tools/fit_products.sh](TwoSuns/tools/fit_products.sh).
- `TwoSuns/tools/fit_languages.sh [-l "..."] <product>`: overlays each language's strings in a throwaway jungle and runs the fit tests; has TwoSuns-specific resource paths and TIER logic — [TwoSuns/tools/fit_languages.sh:1-30](TwoSuns/tools/fit_languages.sh). HeroSet's equivalent is `HeroSet/tools/fit-sweep.sh` — [docker/SIMULATOR.md §2](docker/SIMULATOR.md).
- `TwoSuns/tools/check_strings.py`: same ids/placeholders in every language, manifests and jungles list the same languages, AppName only in tier folders, no "Pro" in Free; **hardcodes TwoSuns string ids** (`SINGLE_WORDING`, `LADDERS`, `LAST_RESORT`) — [TwoSuns/tools/check_strings.py:1-30](TwoSuns/tools/check_strings.py).
- Screen-fit test pattern: `(:test) everyStateFitsThisDisplay` draws every state from a shared `(:test)` states class into a `createBufferedBitmap` at the device resolution and fails on text outside the display, overlaps, or a stack taller than the span; `TwoSunsDraw.misfits/boxes` collect the evidence; helpers are `(:debug)` so a release export drops them — [TwoSuns/source/test/TwoSunsScreenFitTest.mc:1-50](TwoSuns/source/test/TwoSunsScreenFitTest.mc), [TwoSuns/docs/development.md:100](TwoSuns/docs/development.md).
- Known SDK quirks: private instance method called from a static method crashes `monkeyc`; `hidden` is a keyword; `Test.assertEqual` needs non-null args; the runner treats every `(:test)` function as a test (shared helpers go in a `(:test)` class or `(:debug)` functions) — [TwoSuns/docs/development.md:126-140](TwoSuns/docs/development.md).
- Test counts and evidence level at last run: all [sim] — [docker/SIMULATOR.md §2](docker/SIMULATOR.md).

### Inferences
- **Must exist for the tooling to work:** `SunWindow/monkey.jungle`, `SunWindow/manifest.xml`, `resources/drawables/drawables.xml` + `launcher_icon.svg` (copy `TwoSuns/resources/drawables/`), `source/test/*.mc` with at least one `(:test)` function, and the dev key at `~/.garmin-connectiq/keys/developer_key`.
- **Copy verbatim:** `TwoSuns/tools/run_tests.sh` (paths are relative, works from `SunWindow/tools/`).
- **Copy and edit:** `compile_sweep.sh` (delete the two-manifest diff, lines 15–18; default jungle list `monkey.jungle`); `fit_all.sh` (replace the device list with API 5.1+ ids from SunWindow's manifest covering each screen size plus `instincte40mm`); `fit_products.sh` (as is); `check_strings.py` (strip the TwoSuns id lists and tier rules; keep id/placeholder parity); `fit_languages.sh` (drop TIER; single resource path) only once translations exist; `glance-scope-check.sh` (section 5).
- **Not needed:** `check_free_package.sh`, `gen_settings.py`, `weather_conditions.sh`.
- Widget screenshots: `shot.sh` should be tried on a widget; whether the simulator opens a widget on its glance or full view on round devices is unrecorded (only Instinct glances are noted).

### Gaps
- No record of `shot.sh`/`ciq-test.sh` run against a `widget` type.

---

## 8. Translations

### Takeaway
English lives in `resources/strings/strings.xml`; each language is `resources-<lang>/strings/strings.xml` with identical ids and placeholders, 15 languages (eng plus dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr). All translations are machine drafts no native speaker has read, and shipping them is an owner decision. DayArc ships English only.

### Cited Findings
- Language list, manifest `<iq:language>` lines and jungle `base.lang.<l>` lines; `check_strings.py` enforces parity; machine-drafted, not read by a native speaker — [TwoSuns/docs/development.md:120-124](TwoSuns/docs/development.md), [TwoSuns/manifest.free.xml `<iq:languages>`](TwoSuns/manifest.free.xml).
- Pixel fit per language: `fit_languages.sh` — "Not run yet, in any language" for TwoSuns — [TwoSuns/docs/development.md:124](TwoSuns/docs/development.md); HeroSet's 15-language sweep found Italian and Portuguese wider than the Instinct glance row — [HeroSet/docs/decisions.md:455](HeroSet/docs/decisions.md).
- New strings get unreviewed machine drafts recorded as an open owner gate (TwoSuns F11) — [TwoSuns/docs/status.md:110](TwoSuns/docs/status.md). "Never decide alone: names, prices, icons, looks, uploads, translations" — [ROADMAP.md:14](ROADMAP.md). DayArc is English only — [docker/SIMULATOR.md §2](docker/SIMULATOR.md). SunWindow lists translations as open — [SunWindow/CLAUDE.md "Open owner decisions"](SunWindow/CLAUDE.md).
- Glance strings need `scope="glance"` in every language file — [HeroSet/docs/decisions.md:361](HeroSet/docs/decisions.md).
- AppName in a single-tier app: in TwoSuns AppName sits only in tier folders because a language does not inherit the default's strings ("the compiler warns 'String id AppName undefined for language ...'") — [TwoSuns/monkey.free.jungle](TwoSuns/monkey.free.jungle).

### Inferences
- v1: ship English only (DayArc precedent), add languages after the owner decides; when added, AppName must be present in each `resources-<lang>` (single tier) or the compiler warns, and the glance strings carry `scope="glance"`.
- Keep the state words short and give each a shorter fallback (HeroSet longest-first list), because the glance row is narrow (90 px beside the Instinct window).

### Gaps
- No per-language pixel run exists for TwoSuns; the widths of state words like OPEN / CLOSED / NONE TODAY in 15 languages are unknown.

---

## 9. Shared code-quality rules a new project must follow

### Takeaway
The binding rules are the per-project house rules (already copied into `SunWindow/CLAUDE.md`) plus the root `CLAUDE.md` house rules; the code quality review lives in `reports/archive/` and covers HeroSet, HeroFace and the site only, with a transferable lesson: harden the places the platform can throw or return null (Storage value types, permissioned calls), and keep docs and public copy in step with the shipped build.

### Cited Findings
- Report location: `reports/archive/Verden code quality review.md` (the path `reports/Verden code quality review.md` does not exist) — [reports/archive/Verden code quality review.md](reports/archive/Verden%20code%20quality%20review.md).
- Transferable patterns it says must not be churned: storage/clock seams with injection for tests, fixed key spellings and no Symbols in Storage, Number/Float narrowing on read, Readings → State → draw split for fit tests, one build with every newer API behind `has`, tolerant settings reader, `Draw.text` as the only draw path — [reports/archive/Verden code quality review.md:96-126](reports/archive/Verden%20code%20quality%20review.md). Conclusion: "harden the few places where the platform can throw or return null ... and to leave the rest alone"; weak point is the seam between code and docs/public pages — [same file:147](reports/archive/Verden%20code%20quality%20review.md).
- Root rules: signing key outside the repo, never commit `.der`/`.pem`; don't stage/commit unless asked; simulator passing is not device proof; screenshot every layout change; container simulator by default; behaviour change → doc same session, durable decision → ADR; every store publication → CHANGELOG + What's New; user-facing claims also in `site/src/apps/<slug>/`, never change a published URL — [CLAUDE.md "House rules everywhere", "Cross-folder rules"](CLAUDE.md).
- Zero-warning build at `-w --typecheck 3` — [TwoSuns/CLAUDE.md "House rules"](TwoSuns/CLAUDE.md); test helpers `(:debug)` so release exports drop them — [TwoSuns/docs/development.md:100](TwoSuns/docs/development.md).
- Do not invent evidence; say "simulator only" wherever a claim rests on the simulator — [TwoSuns/CLAUDE.md "House rules"](TwoSuns/CLAUDE.md).

### Inferences
- New-project checklist from these rules: one `Sources` class touches the watch (Position, Storage, Weather, clock), each call guarded by `has` + try/catch; pure classes (Sun, Place, Calendar, window rule) are unit-tested; all drawing from a State object; zero warnings at `--typecheck 3`; doc + ADR updates in the same session; site pages under `site/src/apps/sun-window/` only once the slug (ADR-001) is decided.

### Gaps
- None beyond those listed in sections 1–8.

---

## 10. Reuse inventory: copy X from Y, adapt Z

### Takeaway
Most of Sun Window is a recombination of TwoSuns (sun maths, place, time, weather, settings, fit tests, tools), HeroSet (glance) and DayArc (single-setting Customize); the new code is the window rule, `elevationAt`, the uvIndex/cloudCover demotion and the two views.

### Cited Findings
Each row's source is cited in sections 1–8 above.

| Sun Window file | Copy from | Adapt |
|---|---|---|
| `source/SunWindowSun.mc` | `TwoSuns/source/TwoSunsSun.mc` | Double; drop civil/golden; add `elevationAt`, per-instant days (`-0.5 + (min-offset)/1440`); zenith 45 geometric; ceil/floor edges; `(:glance)` |
| `source/SunWindowCalendar.mc`, `SunWindowLocalTime.mc` | `TwoSuns/source/TwoSunsCalendar.mc`, `TwoSunsLocalTime.mc` | prefix; `(:glance)` |
| `source/SunWindowPlace.mc` | `TwoSuns/source/TwoSunsPlace.mc` | drop `(:pro)`; `(:glance)` for `fromStorage` |
| `source/SunWindowSources.mc` | `TwoSunsSources.updatePlace/positionLocation` | Position only + saved place; foreground only |
| `source/SunWindowWeather.mc` | `TwoSuns/source/TwoSunsWeatherSource.mc` | add `uvIndex`/`cloudCover`, age rule; plain `import` OK |
| `source/SunWindowApp.mc`, `SunWindowGlanceView.mc` | `HeroSet/source/app/HeroSetApp.mc`, `HeroSet/source/ui/glance/HeroSetGlanceView.mc` | `(:glance)`, empty `onStart`, `disableGlanceCheck` on foreground methods |
| `getSettingsView` + `SunWindowAccentDelegate.mc` | `DayArc/source/DayArcApp.mc:17-40`, `DayArc/source/DayArcAccentDelegate.mc` | single list; MONO → null |
| `source/SunWindowSettings.mc` | `TwoSuns/source/TwoSunsSettings.mc` (`read`, `within`) | Accent only |
| `resources/settings/*.xml` | `TwoSuns/resources-free/settings/properties.xml`, `resources-accent-free/settings/settings.xml` | one folder |
| `source/test/SunWindowAccentTest.mc` | `TwoSuns/source/test/TwoSunsAccentTest.mc` | own reserved colours |
| `source/test/*FitTest.mc` | `TwoSunsScreenFitTest.mc`, `HeroSetGlanceFitTest.mc` | full view + glance |
| `tools/run_tests.sh` | `TwoSuns/tools/run_tests.sh` | verbatim |
| `tools/compile_sweep.sh`, `fit_all.sh`, `fit_products.sh` | `TwoSuns/tools/` | drop manifest diff; own device list |
| `tools/glance-scope-check.sh` | `HeroSet/tools/glance-scope-check.sh` | jungle `monkey` only |
| `tools/gen_sun_tests.py` | `TwoSuns/tools/gen_sun_tests.py` | read fixtures (TSV export); 1 min / 0.02 deg |
| D6 / D2 probes | `research_notes/Body Battery and sun face research/probe/on-watch/`, `research_notes/Two Suns temperature research/probe/` | `type="widget"`; add glance + uvIndex/cloudCover |
| `resources/drawables/` | `TwoSuns/resources/drawables/` | placeholder icon until owner's |
