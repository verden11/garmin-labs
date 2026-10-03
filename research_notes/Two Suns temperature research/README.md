# Two Suns temperature research: sourced notes (2026-10-03)

Behind [`../../reports/Two Suns temperature research.md`](../../reports/Two%20Suns%20temperature%20research.md). Evidence level on every line: **docs** (SDK 9.2.0 HTML docs, read locally), **forum** (secondhand), **repo** (this repo's files), **geometry** (computed from `TwoSunsLayout`), **unverified**.

## Data sources the SDK offers

| Source | What it gives | Evidence |
|---|---|---|
| `Weather.getHourlyForecast()` | Array of `HourlyForecast` or null: `forecastTime` (UTC Moment), `temperature` (Celsius, Numeric or null), condition, precipitation chance, wind. Since API 3.2.0. | docs, `Toybox/Weather/HourlyForecast.html` |
| Length and start of that array | 12 entries, starting at the current hour (at 08:00: 08:00 to 19:00). **Not stated in the SDK docs.** | forum: https://forums.garmin.com/developer/connect-iq/f/discussion/424814/how-can-we-get-the-weather-condition-after-12h (unverified on a watch) |
| Past hours of today | None. The forecast starts now. | docs (no field), forum |
| `Weather.getCurrentConditions()` | `temperature`, `highTemperature`, `lowTemperature`, `feelsLikeTemperature`, observation time; Celsius. | docs, `Weather/CurrentConditions.html` |
| `Weather.getDailyForecast()` | per day `highTemperature`, `lowTemperature`. | docs |
| Null cases | Methods can return null; forum says the Garmin weather widget must exist on the watch, and "only available on some 3.2 devices". | forum: https://forums.garmin.com/developer/connect-iq/f/discussion/254157/accessing-daily-and-hourly-forecast-in-wf |
| `Complications` CURRENT_TEMPERATURE (38) | Float, Celsius, API 4.2.0 (Number before 5.0.0). HIGH_LOW_TEMPERATURE (39) is a preformatted String "H x / L y". **No hourly series.** | docs, `Toybox/Complications.html` |
| `SensorHistory.getTemperatureHistory` | Watch's own sensor temperature history. Pro already holds `SensorHistory`. **Not ambient air**: a worn watch reads warmed by the wrist. Warming is widely reported, not measured here. Rejected. | docs (method exists), unverified (bias) |
| Unit | `System.getDeviceSettings().temperatureUnits` (metric or statute). The API is Celsius only, so Fahrenheit is a conversion. | docs |
| Permission | None for `Weather` (compiler probe, no manifest permissions). The Pro build already calls `Toybox.Weather.getCurrentConditions()` in `TwoSunsSources` (line ~173). On-watch behaviour of the `Weather` module is not tested here. | repo: `research_notes/Body Battery and sun face research/platform.md` section 1; `TwoSuns/source/TwoSunsSources.mc` |
| Reach | `Weather` is in tier A for all 69 products. | repo: `TwoSuns/docs/compatibility.md:41` |

## Repo constraints that bind this feature

- `docs/spec.md:183` lists **weather** under non-goals; `CLAUDE.md` says do not add anything from the non-goals. Needs an owner decision and an ADR.
- `Application.Storage` holds only the rounded place. Storing temperatures (for past hours) needs a second ADR.
- Studio direction (root `CLAUDE.md`): never a colour keyed to a reading; one decisive move; mockup, browser screenshot, owner look-approval before Monkey C.
- `Weather` is not imported; named in full inside `(:pro)` functions (`CLAUDE.md` Fast facts).

## Geometry (integer maths, as `TwoSunsLayout`: Monkey C Number division truncates)

Ring width `D*25/1000`, ring gap `D*10/1000`, text margin `D*20/1000`; ring radius = D/2 - width/2 - gap; inner edge = ring radius - width/2; content circle = ring radius - width/2 - margin. Room = inner edge - content circle; usable = room - 2 px pad.

| Screen | Ring radius | Inner edge | Content circle | Room | Usable |
|---|---|---|---|---|---|
| 454 (fr965) | 218 | 213 | 204 | 9 | 7 |
| 416 | 199 | 194 | 186 | 8 | 6 |
| 390, 360 | 188, 173 | 184, 169 | 177, 162 | 7 | 5 |
| 280, 260 (MIP) | 135, 125 | 132, 122 | 127, 117 | 5 | 3 |
| 218 (fr255s, MIP) | 105 | 103 | 99 | 4 | 2 |

454 matches the fr965 sample in `DESIGN.md` (ring 218, content 204). Others computed by hand from the code, not read from `twoSunsLayoutReport`; 240 px not computed. Room is about 2% of D.

## Mockup

`TwoSuns/docs/temperature-mockup.html`, screenshot in this folder (taken in Chrome at 1500 px, scaled; sample data only). Findings: A (inward ticks) reads as a dial hour-track and never touches the text circle; B (hairline) wanders and merges with the ring at night; at 218 px the room is too small for either.

## Precedent (inspiration only, no compatibility claim)

Search found third-party Apple Watch (hourly chart complications) and Wear OS or Facer faces with temperature trend graphs, mostly as separate graph panels. None was opened or evaluated in depth; no source for a ring-integrated hourly temperature mark was found. Treat "nothing found" as "not searched deeply".

## Probe run in the simulator (2026-10-03, container, canned weather, fr965; not a watch)

`probe/` is a throwaway watch face (`WeatherProbe-fr965.prg`, no permissions) that prints the weather lists. In the simulator: `getHourlyForecast()` returned **12 entries**, 60 minutes apart, the first at the **next** full hour (18:00 at 17:47, so not the current hour); `getDailyForecast()` returned **5 entries** stamped at **00:00 UTC** of each day (today first); the current conditions had an observation time 2 minutes old. This is canned data: the wrist run (`device-test/TwoSuns-weather-CHECKLIST.md`) is what answers Q1 and Q2 for real.

## Probe on the FR965 (2026-10-03, real watch, session A started)

Photos of the probe's **log page** (odd minute; the line is cut at both edges by the round screen): `21:07 o3/20:50 h12 3/21:00 d5 3/00:0…`. Read as: logged 21:07; current conditions observed 20:50 (17 minutes old); hourly list **12 entries, first at 21:00 (the current hour, unlike the simulator's next hour)**; daily list **5 entries, first stamped 3/00:00 local** (a local-midnight stamp, unlike the simulator's UTC midnight). Second set of photos (live page, log page, live page again, 21:08 to 21:10): hourly `n=12`, `step 60m`, `h0` 3/21:00 `c=1 t=14.444445`, `h11` 4/08:00 `c=20 t=11.111111`, `h0 UTC 3T18:00Z`; daily `n=5` with stamps `2T21:00Z`, `3T21:00Z`, `4T21:00Z`, `5T21:00Z` (local midnights, UTC+3); current `t=15.000000 f=15.?` (cut); `obs` age 18 then 20 minutes. The log page showed four entries with an identical key at 21:07, 21:07, 21:08, 21:08: a probe bug (it logs although nothing changed), harmless, nothing in the face. Earlier, not seen yet: the live (even-minute) page: last hourly entry, step, the daily `k` values, `t` and `f` against Garmin's Weather widget, and the Bluetooth-off behaviour. Evidence level: one photo of a truncated log line.

Third photo set (about 22:22): observation 20:50 became 21:50 and the hourly list start 21:00 became 22:00 in one log entry (22:21), n=12 throughout; daily conditions changed with it. The weather is re-issued about hourly; the list starts at the full hour after the observation. No log entries between 21:17 and 22:21 (screen off), so the clock-hour move between syncs is not shown.
