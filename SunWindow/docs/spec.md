# Sun Window — spec

Name: Sun Window, slug `sun-window` ([ADR-001](decisions.md#adr-001-name-and-slug), name and slug; trademark check before listing work).

Written from [`reports/Vitamin D window.md`](../../reports/Vitamin%20D%20window.md)
(sourced notes: `research_notes/Vitamin D window/`) and the task plan
[`reports/Sun Window build plan.md`](../../reports/Sun%20Window%20build%20plan.md).
Where this spec and the reports differ, this spec wins. The owner narrowed v1 on 2026-10-04 to a **Free, widget-style** build
([ADR-002](decisions.md#adr-002-v1-is-widget-style-no-watch-face-no-nudge), widget-style only;
[ADR-003](decisions.md#adr-003-v1-is-free-only-no-pro), Free only) and approved
the plan's recommendations on 2026-10-05.

## What it does

A Connect IQ **app with a glance** and a full-screen view (the studio calls
it a widget; the manifest type is `watch-app`, per
[ADR-008](decisions.md#adr-008-manifest-type-watch-app-with-a-glance-not-widget), manifest type). It
answers one question: is the sun above a fixed height right now. Three
states:

- **OPEN**: the sun is at or above 45 degrees now and the sky filter passes.
- **CLOSED**: today's highest sun reaches 45 degrees, but not right now
  (before opening, after closing, or the sky filter fails).
- **NONE TODAY**: today's highest sun stays below 45 degrees (northern
  winter; about 7.5 months a year in Vilnius).

The full view also shows when the window opens and closes today, as clock
times. NONE TODAY shows a sentence only, with no return date or other
number ([ADR-006](decisions.md#adr-006-clock-times-in-the-full-view-only-none-today-is-a-sentence-only), times and NONE TODAY). The glance shows the
state word and a shape mark only. Sun height is computed on the watch from
the date, the time and a stored location, so the app needs no background
process.

The only weather input is the watch's own
`Weather.getCurrentConditions()`, read fresh at each draw with no cache, by
the glance and the full view alike. It can only demote OPEN to CLOSED:
`uvIndex` below 3 demotes, and a null means no demotion. `cloudCover` of 90
or more is a fallback, used only if device check D2 shows `uvIndex` is null
or does not fall with cloud
([ADR-004](decisions.md#adr-004-window-rule-one-45-degree-display-constant), window rule). The cut-offs are starting values to tune on a wrist, not sourced
numbers.

The app is reachable from the glance list and from the app launcher, so the
full view must work when opened cold.

## What it explicitly does not do

- **No notification or nudge** in v1: no `Background` or `Notifications`
  permission and no background code
  ([ADR-002](decisions.md#adr-002-v1-is-widget-style-no-watch-face-no-nudge)). Nothing in v1 touches a watch face.
- No minutes, dose, IU, "burn time", goal or streak. No health claim, and no
  state is labelled good, bad, safe or enough.
- No colour keyed to a reading: OPEN and CLOSED differ by word and shape.
  The accent colour is a user choice, never a status colour, and the glance
  theme is fixed, never chosen by state.
- No network calls, no phone companion, no account.
- No Pro build and no upgrade text anywhere
  ([ADR-003](decisions.md#adr-003-v1-is-free-only-no-pro)).
- No "vitamin D" anywhere: title, description, screenshots, watch UI or site
  ([ADR-005](decisions.md#adr-005-wording-rules-no-vitamin-d-anywhere), option A).
- No staleness rule for the place: it updates whenever the full view opens,
  so after travel the glance may be wrong until then. The support page says
  so.

## Data sources

| Source | Used for | Permission |
|---|---|---|
| Computed solar elevation (NOAA formulas, `Double`, days since 2000, geometric, no refraction) | The window rule | none |
| `Position.getInfo()` in the full view only; `enableLocationEvents(LOCATION_ONE_SHOT)` when no usable place is stored. Rounded to 0.1 degree, stored as `[lat, lon]` (key `place`) | Location for the sun maths | `Positioning` |
| `Weather.getCurrentConditions()`: `uvIndex` (`cloudCover` only as the D2 fallback), API 5.1.0+ | Demote OPEN only | none |
| `Storage` | The place only | none |
| `Application.Properties` | The accent id | none |

- Not used: `Activity.currentLocation` and the Weather observation location
  (both null on the owner's FR965, TwoSuns ADR-005 (location probes on FR965));
  the hourly forecast; `Notifications`, `Background`, `ActivityMonitor`,
  `SensorHistory`, `Communications`.
- The glance never writes Storage and never calls `Position`
  ([ADR-010](decisions.md#adr-010-glance-recomputes-each-draw-reads-weather-never-writes-storage-or-calls-position), glance). If the app has
  never been opened there is no stored place, and the glance shows a plain
  "open once" sentence.
- While `Positioning` is declared, no store or site copy may say "no location".
- Solar tolerances: a `Double` port of the full NOAA formulas must match
  [`solar_elevation_fixtures.md`](../../research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md)
  to 0.02 degrees and 1 minute on window edges (2026 values only; never assert
  exact edge dates, e.g. Sydney 2026-04-19).

## Settings

| Setting | Type | Reaches the watch via |
|---|---|---|
| Accent colour | list, append-only ids: the roster's Free six, default Sky `#55AAFF`, checked against this app's reserved roles and the glance card grey ([ADR-013](decisions.md#adr-013-store-and-release-answers)) | both: Garmin Connect (Properties) and an in-app `Menu2` opened from `onMenu` ([ADR-009](decisions.md#adr-009-accent-setting-through-onmenu--menu2-not-getsettingsview), on-watch settings) |

`getSettingsView` applies only to watch faces and data fields, so it is not
used. Sideloaded builds get no phone settings, but the in-app menu works
there. On 1-bit Instinct the menu is hidden (`onMenu` returns `false`).
Accent colour is in the Free tier by studio rule.

## Device reach

- **v1 target: API 5.1 and newer watches**, 66 products in SDK 9.2.0 (the
  upload form's Compatible Devices list is the final check). Out: the 8 Edge
  units and `etrextouch` (not watches; eTrex Touch has no glance).
- The three Instinct ids with 32 KB glance memory (`instincte40mm`,
  `instincte45mm`, `instinct3solar45mm`) are included, lean
  ([ADR-012](decisions.md#adr-012-instinct-e-4045-and-instinct-3-solar-45-included-lean)), and dropped if the glance
  memory or fit tests fail. The 1-bit display needs its own look pass.
- Deferred: API 3.2 to 5.0 (Venu 2, FR945/745/245, fēnix 6), which have no
  `uvIndex` or `cloudCover` (elevation rule works, weather demotion does
  not). See `docs/compatibility.md`.

## Success and stop test

- **Worked:** the three states match the sky and the fixtures on a real wrist
  for a full day. The owner accepted FR965-only (AMOLED) evidence at
  submission; MIP and Instinct are labelled "simulator only"
  ([ADR-013](decisions.md#adr-013-store-and-release-answers)). After release: no review complaints about a
  wrong state or a lost location.
- **Honest expectation:** the paid sun niche is a few hundred people (report);
  this is a small free build, sized accordingly.
- **Stop:** the device spike yields no place on the watch
  ([ADR-007](decisions.md#adr-007-go-to-the-device-spike-build-only-if-the-watch-yields-a-place), conditional go). The
  weather filter is dropped, not the app, if `uvIndex` and `cloudCover` are
  always null.

## Device checks still required

None of these can be settled in the simulator; simulator is not device proof.

| # | Check | Pass condition |
|---|---|---|
| D2 | `uvIndex` and `cloudCover` on a real watch, current conditions (hourly logged by the spike for information) | Non-null, plausible, change with the sky |
| D6 | `Position.getInfo()` and `LOCATION_ONE_SHOT` from the full view, cold-launched and glance-launched; optionally `getInfo()` from a glance, for information only | A fix, or a clean fallback; no uncatchable crash |
| D7 | Glance render and memory (64 KB, 32 KB on three Instinct ids), no stale state across midnight | Correct state on three screens, clipped bezels checked |
| D9 | Monkey C `Double` solar maths against the fixtures | Within 0.02 degrees and 1 minute |
| D11 | Which gesture triggers `onMenu` (FR965; touch models where reachable) | The accent menu opens |
| D12 | Idle timeout of the app when launched from the glance (undocumented) | Measured; the full view stays usable |

The report's D1, D3, D4, D5, D8 and D10 covered the background nudge and
return only if a nudge is added later.
