# Two Suns temperature research: sourced notes (2026-10-03)

Behind [`../../reports/Two Suns temperature research.md`](../../reports/Two%20Suns%20temperature%20research.md). Evidence level each line: **docs** (SDK 9.2.0 HTML docs, read locally), **forum** (secondhand), **repo** (this repo's files), **geometry** (computed from `TwoSunsLayout`), **unverified**.

## Data sources the SDK offers

| Source | What it gives | Evidence |
|---|---|---|
| `Weather.getHourlyForecast()` | `HourlyForecast` array or null: `forecastTime` (UTC Moment), `temperature` (Celsius, Numeric or null), condition, precipitation chance, wind. Since API 3.2.0. | docs, `Toybox/Weather/HourlyForecast.html` |
| Length, start of that array | 12 entries, start at current hour (08:00: 08:00 to 19:00). **Not stated in SDK docs.** | forum: https://forums.garmin.com/developer/connect-iq/f/discussion/424814/how-can-we-get-the-weather-condition-after-12h (unverified on a watch) |
| Past hours of today | None. Forecast starts now. | docs (no field), forum |
| `Weather.getCurrentConditions()` | `temperature`, `highTemperature`, `lowTemperature`, `feelsLikeTemperature`, observation time; Celsius. | docs, `Weather/CurrentConditions.html` |
| `Weather.getDailyForecast()` | per day `highTemperature`, `lowTemperature`. | docs |
| Null cases | Methods can return null; forum: Garmin weather widget must exist on watch, "only available on some 3.2 devices". | forum: https://forums.garmin.com/developer/connect-iq/f/discussion/254157/accessing-daily-and-hourly-forecast-in-wf |
| `Complications` CURRENT_TEMPERATURE (38) | Float, Celsius, API 4.2.0 (Number before 5.0.0). HIGH_LOW_TEMPERATURE (39) preformatted String "H x / L y". **No hourly series.** | docs, `Toybox/Complications.html` |
| `SensorHistory.getTemperatureHistory` | Watch's own sensor temperature history. Pro already holds `SensorHistory`. **Not ambient air**: worn watch reads warmed by wrist. Warming widely reported, not measured here. Rejected. | docs (method exists), unverified (bias) |
| Unit | `System.getDeviceSettings().temperatureUnits` (metric or statute). API Celsius only, so Fahrenheit = conversion. | docs |
| Permission | None for `Weather` (compiler probe, no manifest permissions). Pro build already calls `Toybox.Weather.getCurrentConditions()` in `TwoSunsSources` (line ~173). On-watch behaviour of `Weather` module not tested here. | repo: `research_notes/Body Battery and sun face research/platform.md` section 1; `TwoSuns/source/TwoSunsSources.mc` |
| Reach | `Weather` in tier A for all 69 products. | repo: `TwoSuns/docs/compatibility.md:41` |

## Repo constraints that bind this feature

- `docs/spec.md:183` lists **weather** under non-goals; `CLAUDE.md`: do not add anything from non-goals. Needs owner decision + ADR.
- `Application.Storage` holds only rounded place. Storing temperatures (past hours) needs second ADR.
- Studio direction (root `CLAUDE.md`): never colour keyed to reading; one decisive move; mockup, browser screenshot, owner look-approval before Monkey C.
- `Weather` not imported; named in full inside `(:pro)` functions (`CLAUDE.md` Fast facts).

## Geometry (integer maths, as `TwoSunsLayout`: Monkey C Number division truncates)

Ring width `D*25/1000`, ring gap `D*10/1000`, text margin `D*20/1000`; ring radius = D/2 - width/2 - gap; inner edge = ring radius - width/2; content circle = ring radius - width/2 - margin. Room = inner edge - content circle; usable = room - 2 px pad.

| Screen | Ring radius | Inner edge | Content circle | Room | Usable |
|---|---|---|---|---|---|
| 454 (fr965) | 218 | 213 | 204 | 9 | 7 |
| 416 | 199 | 194 | 186 | 8 | 6 |
| 390, 360 | 188, 173 | 184, 169 | 177, 162 | 7 | 5 |
| 280, 260 (MIP) | 135, 125 | 132, 122 | 127, 117 | 5 | 3 |
| 218 (fr255s, MIP) | 105 | 103 | 99 | 4 | 2 |

454 matches fr965 sample in `DESIGN.md` (ring 218, content 204). Others computed by hand from code, not read from `twoSunsLayoutReport`; 240 px not computed. Room about 2% of D.

## Mockup

`TwoSuns/docs/temperature-mockup.html`, screenshot in this folder (Chrome at 1500 px, scaled; sample data only). Findings: A (inward ticks) reads as dial hour-track, never touches text circle; B (hairline) wanders, merges with ring at night; at 218 px room too small for either.

## Precedent (inspiration only, no compatibility claim)

Search found third-party Apple Watch (hourly chart complications), Wear OS or Facer faces with temperature trend graphs, mostly separate graph panels. None opened or evaluated in depth; no source found for ring-integrated hourly temperature mark. Treat "nothing found" as "not searched deeply".

## Probe run in the simulator (2026-10-03, container, canned weather, fr965; not a watch)

`probe/` = throwaway watch face (`WeatherProbe-fr965.prg`, no permissions) printing weather lists. Simulator: `getHourlyForecast()` returned **12 entries**, 60 minutes apart, first at **next** full hour (18:00 at 17:47, so not current hour); `getDailyForecast()` returned **5 entries** stamped **00:00 UTC** each day (today first); current conditions observation time 2 minutes old. Canned data: wrist run (`device-test/TwoSuns-weather-CHECKLIST.md`) answers Q1 and Q2 for real.

## Probe on the FR965 (2026-10-03, real watch, session A started)

Photos of probe **log page** (odd minute; line cut at both edges by round screen): `21:07 o3/20:50 h12 3/21:00 d5 3/00:0…`. Read as: logged 21:07; current conditions observed 20:50 (17 minutes old); hourly list **12 entries, first at 21:00 (current hour, unlike simulator's next hour)**; daily list **5 entries, first stamped 3/00:00 local** (local-midnight stamp, unlike simulator's UTC midnight). Second photo set (live page, log page, live page again, 21:08 to 21:10): hourly `n=12`, `step 60m`, `h0` 3/21:00 `c=1 t=14.444445`, `h11` 4/08:00 `c=20 t=11.111111`, `h0 UTC 3T18:00Z`; daily `n=5` stamps `2T21:00Z`, `3T21:00Z`, `4T21:00Z`, `5T21:00Z` (local midnights, UTC+3); current `t=15.000000 f=15.?` (cut); `obs` age 18 then 20 minutes. Log page showed four entries identical key at 21:07, 21:07, 21:08, 21:08: probe bug (logs although nothing changed), harmless, nothing in face. Earlier, not seen yet: live (even-minute) page: last hourly entry, step, daily `k` values, `t` and `f` vs Garmin's Weather widget, Bluetooth-off behaviour. Evidence level: one photo of truncated log line.

Third photo set (about 22:22): observation 20:50 became 21:50, hourly list start 21:00 became 22:00 in one log entry (22:21), n=12 throughout; daily conditions changed with it. Weather re-issued about hourly; list starts at full hour after observation. No log entries between 21:17 and 22:21 (screen off), so clock-hour move between syncs not shown.