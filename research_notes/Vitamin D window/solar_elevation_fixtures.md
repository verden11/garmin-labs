# Solar elevation reference fixtures for the Vitamin D sun window (2026)

Generated 2026-10-04 by `solar_elevation_fixtures.py` (same folder; Python 3.9 stdlib only, nothing installed; `astral`, `pvlib` and `ephem` are not installed on this machine, so the NOAA formulas were implemented directly). Re-run: `python3 solar_elevation_fixtures.py > tables.md` (needs network for the two reference services; responses are cached in the system temp dir). Every table below is that script's output, pasted unedited.

## Fixture values: algorithm, conventions and independent cross-check

### Takeaway
The reference algorithm is the NOAA Solar Calculator spreadsheet formulas (Meeus), implemented in Double precision, geometric elevation (no refraction). It agrees with NASA/JPL Horizons (DE441, topocentric, airless) to within 0.0061 deg over 36 place/date days x 1441 one-minute samples (51,876 samples; NOAA reads 0.0002-0.0044 deg high on average), and with MET Norway's published solar-noon elevation to within 0.008 deg (MET rounds to 0.01) for all 36 place/dates. Whole-minute 45 deg and 30 deg windows from NOAA and Horizons are identical in 71 of 72 place/date/threshold cases (one differs by +1 minute). Use the tables below as fixtures; a Double-precision port of the same algorithm should match them to about 0.01 deg.

### Cited Findings
- NOAA's calculators are "based on equations from Astronomical Algorithms, by Jean Meeus"; sunrise/sunset results are "theoretically accurate to within a minute for locations between +/- 72 deg latitude, and within 10 minutes outside of those latitudes" — [NOAA GML Solar Calculator technical details](https://gml.noaa.gov/grad/solcalc/calcdetails.html)
- NOAA: the calculator assumes "0.833 deg of atmospheric refraction" for sunrise/sunset, and atmospheric effects "vary with atmospheric pressure, humidity and other variables. Therefore the solar position calculations presented here are approximate." — [NOAA GML Solar Calculator technical details](https://gml.noaa.gov/grad/solcalc/calcdetails.html)
- JPL Horizons API (ephemeris DE441, target Sun, `CENTER=coord@399` user-defined geodetic site, `QUANTITIES=4` azimuth/elevation, `APPARENT=AIRLESS` = no refraction, site altitude 0 km, UTC times) was used as the independent reference. The API output header confirms "Target body name: Sun (10) {source: DE441}" and "Atmos refraction: NO (AIRLESS)" — [JPL Horizons API](https://ssd.jpl.nasa.gov/api/horizons.api) (docs: [ssd-api.jpl.nasa.gov/doc/horizons.html](https://ssd-api.jpl.nasa.gov/doc/horizons.html), not re-read this session)
- MET Norway sunrise API v3 (`/weatherapi/sunrise/3.0/sun`) returns solar noon time with `disc_centre_elevation` plus sunrise/sunset (minute resolution, elevation to 2 decimals); used as a second independent source. Result: noon elevation max |dev| 0.008 deg, noon time identical to the minute in 36/36, sunrise/sunset within 1 minute in 72/72 (Table D) — [MET Norway Sunrise API](https://api.met.no/weatherapi/sunrise/3.0/sun?lat=54.687&lon=25.28&date=2026-06-21&offset=%2B03:00)
- Conventions in every table: latitude N positive, longitude E positive (Vilnius 54.687, 25.280; London 51.507, -0.128; Phoenix 33.448, -112.074; Reykjavik 64.147, -21.940; Singapore 1.352, 103.820; Sydney -33.868, 151.209). Elevation = degrees above the horizon, geometric (refraction not added), sea level, centre of the solar disc. Times are 24 h clock; UTC offsets are fixed per date and printed in each table. DST assumed (checked with Python `zoneinfo`): Vilnius +2 winter / +3 summer (EU DST 2026-03-29 to 2026-10-25), London 0 / +1, Phoenix -7 all year, Reykjavik 0 all year, Singapore +8, Sydney +11 (AEDT) on Jan 15, Mar 20, Dec 21 and +10 (AEST) on Jun 21, Jul 15, Sep 23 (AEDT ended 2026-04-05, restarts 2026-10-04). Fixture dates: 2026-01-15 (mid-winter north / mid-summer south), 03-20, 06-21, 07-15 (mid-summer north / mid-winter south), 09-23, 12-21.
- Algorithm as implemented (NOAA spreadsheet): Julian Date -> T (Julian centuries from J2000) -> geometric mean longitude L0, anomaly M, eccentricity e, equation of centre C -> apparent longitude (nutation term 0.00569 + 0.00478 sin omega) -> mean + corrected obliquity (+0.00256 cos omega) -> declination = asin(sin obl * sin app_long); equation of time from the y = tan^2(obl/2) series; true solar time = UTC minutes + EoT + 4*lon; hour angle = TST/4 - 180; elevation = 90 - acos(sin lat sin dec + cos lat cos dec cos HA). The formulas were written from the NOAA spreadsheet/Meeus formulas as known, not diffed line-by-line against the downloaded spreadsheet; the numeric agreement with Horizons is the validation.
- Definitions: "solar noon" = hour angle 0 (transit); "max elevation" = true maximum within the local day (differs from the transit value by < 0.001 deg); ">=45 first/last" = first / last WHOLE MINUTE whose geometric elevation is >= 45 deg (first = ceil of the crossing, last = floor), same for 30 deg; "day length" = time with geometric elevation >= -0.833 deg (standard sunrise/sunset definition, includes refraction and solar semi-diameter). "never" = daily max below the threshold.

### C0. Ten named spot checks (elevation in degrees, geometric/airless)

| Place | Date | Local time (UTC off) | UTC | NOAA algorithm | JPL Horizons | NOAA - Horizons | Spencer simplified | Cooper+EoT simplified |
|---|---|---|---|---|---|---|---|---|
| Vilnius | 2026-12-21 | 12:00 (+2) | 2026-12-21 10:00 | 11.791 | 11.790 | +0.0019 | 11.812 | 11.768 |
| London | 2026-03-20 | 12:00 (+0) | 2026-03-20 12:00 | 38.422 | 38.418 | +0.0041 | 38.000 | 37.856 |
| Phoenix | 2026-12-21 | 12:00 (-7) | 2026-12-21 19:00 | 32.765 | 32.763 | +0.0014 | 32.787 | 32.726 |
| Reykjavik | 2026-07-15 | 12:00 (+0) | 2026-07-15 12:00 | 44.565 | 44.563 | +0.0013 | 44.764 | 44.550 |
| Singapore | 2026-03-20 | 13:00 (+8) | 2026-03-20 05:00 | 86.588 | 86.586 | +0.0017 | 86.227 | 86.184 |
| Sydney | 2026-09-23 | 10:00 (+10) | 2026-09-23 00:00 | 47.752 | 47.754 | -0.0014 | 47.389 | 48.755 |
| Vilnius | 2026-09-23 | 09:00 (+3) | 2026-09-23 06:00 | 15.220 | 15.219 | +0.0013 | 15.596 | 14.517 |
| Phoenix | 2026-06-21 | 08:00 (-7) | 2026-06-21 15:00 | 30.780 | 30.779 | +0.0008 | 30.888 | 30.830 |
| Sydney | 2026-12-21 | 17:00 (+11) | 2026-12-21 06:00 | 35.632 | 35.628 | +0.0044 | 35.574 | 35.872 |
| Reykjavik | 2026-06-21 | 21:00 (+0) | 2026-06-21 21:00 | 11.788 | 11.785 | +0.0032 | 11.757 | 11.777 |

### A. Per place and date: solar noon, maximum elevation, windows, day length (NOAA algorithm, geometric)

Local = UTC + offset shown. `>=45` / `>=30` columns are the first and last WHOLE MINUTE with geometric elevation >= threshold (first = ceil, last = floor). Day length = time with geometric elevation >= -0.833 deg (standard sunrise/sunset).

| Place | Date (2026) | UTC off | Noon local | Noon UTC | Max elev (deg) | >=45 first | >=45 last | >=30 first | >=30 last | Day length |
|---|---|---|---|---|---|---|---|---|---|---|
| Vilnius | 2026-01-15 | +2 | 12:28:16 | 10:28:16 | 14.233 | never |  | never |  | 7h51 |
| Vilnius | 2026-03-20 | +2 | 12:26:20 | 10:26:20 | 35.244 | never |  | 10:28 | 14:26 | 12h11 |
| Vilnius | 2026-06-21 | +3 | 13:20:41 | 10:20:41 | 58.751 | 10:26 | 16:16 | 08:38 | 18:03 | 17h18 |
| Vilnius | 2026-07-15 | +3 | 13:24:53 | 10:24:53 | 56.796 | 10:43 | 16:07 | 08:53 | 17:56 | 16h45 |
| Vilnius | 2026-09-23 | +3 | 13:11:18 | 10:11:18 | 35.150 | never |  | 11:13 | 15:09 | 12h10 |
| Vilnius | 2026-12-21 | +2 | 12:16:55 | 10:16:55 | 11.876 | never |  | never |  | 7h14 |
| London | 2026-01-15 | +0 | 12:09:55 | 12:09:55 | 17.427 | never |  | never |  | 8h21 |
| London | 2026-03-20 | +0 | 12:07:57 | 12:07:57 | 38.452 | never |  | 09:43 | 14:34 | 12h10 |
| London | 2026-06-21 | +1 | 13:02:20 | 12:02:20 | 61.931 | 09:58 | 16:06 | 08:20 | 17:45 | 16h38 |
| London | 2026-07-15 | +1 | 13:06:32 | 12:06:32 | 59.964 | 10:13 | 16:00 | 08:33 | 17:39 | 16h11 |
| London | 2026-09-23 | +1 | 12:52:54 | 11:52:54 | 38.303 | never |  | 10:29 | 15:17 | 12h09 |
| London | 2026-12-21 | +0 | 11:58:35 | 11:58:35 | 15.056 | never |  | never |  | 7h50 |
| Phoenix | 2026-01-15 | -7 | 12:37:49 | 19:37:49 | 35.544 | never |  | 10:53 | 14:23 | 10h11 |
| Phoenix | 2026-03-20 | -7 | 12:35:38 | 19:35:38 | 56.634 | 10:28 | 14:44 | 09:03 | 16:08 | 12h08 |
| Phoenix | 2026-06-21 | -7 | 12:30:11 | 19:30:11 | 79.989 | 09:09 | 15:51 | 07:57 | 17:04 | 14h22 |
| Phoenix | 2026-07-15 | -7 | 12:34:21 | 19:34:21 | 77.974 | 09:17 | 15:51 | 08:05 | 17:03 | 14h09 |
| Phoenix | 2026-09-23 | -7 | 12:20:35 | 19:20:35 | 56.241 | 10:14 | 14:27 | 08:49 | 15:52 | 12h06 |
| Phoenix | 2026-12-21 | -7 | 12:26:32 | 19:26:32 | 33.114 | never |  | 11:07 | 13:46 | 9h56 |
| Reykjavik | 2026-01-15 | +0 | 13:37:11 | 13:37:11 | 4.798 | never |  | never |  | 5h25 |
| Reykjavik | 2026-03-20 | +0 | 13:35:10 | 13:35:10 | 25.836 | never |  | never |  | 12h15 |
| Reykjavik | 2026-06-21 | +0 | 13:29:36 | 13:29:36 | 49.291 | 11:33 | 15:26 | 08:53 | 18:06 | 21h09 |
| Reykjavik | 2026-07-15 | +0 | 13:33:47 | 13:33:47 | 47.315 | 12:08 | 14:59 | 09:14 | 17:54 | 19h43 |
| Reykjavik | 2026-09-23 | +0 | 13:20:08 | 13:20:08 | 25.639 | never |  | never |  | 12h12 |
| Reykjavik | 2026-12-21 | +0 | 13:25:52 | 13:25:52 | 2.416 | never |  | never |  | 4h07 |
| Singapore | 2026-01-15 | +8 | 13:14:02 | 05:14:02 | 67.528 | 10:35 | 15:53 | 09:27 | 17:01 | 12h03 |
| Singapore | 2026-03-20 | +8 | 13:12:14 | 05:12:14 | 88.493 | 10:13 | 16:12 | 09:13 | 17:12 | 12h06 |
| Singapore | 2026-06-21 | +8 | 13:06:29 | 05:06:29 | 67.914 | 10:25 | 15:48 | 09:16 | 16:57 | 12h12 |
| Singapore | 2026-07-15 | +8 | 13:10:42 | 05:10:42 | 69.835 | 10:26 | 15:56 | 09:19 | 17:03 | 12h11 |
| Singapore | 2026-09-23 | +8 | 12:57:13 | 04:57:13 | 88.570 | 09:58 | 15:57 | 08:58 | 16:57 | 12h06 |
| Singapore | 2026-12-21 | +8 | 13:02:39 | 05:02:39 | 65.212 | 10:29 | 15:37 | 09:18 | 16:47 | 12h03 |
| Sydney | 2026-01-15 | +11 | 13:04:25 | 02:04:25 | 77.276 | 09:48 | 16:21 | 08:36 | 17:33 | 14h10 |
| Sydney | 2026-03-20 | +11 | 13:02:43 | 02:02:43 | 56.339 | 10:56 | 15:10 | 09:30 | 16:35 | 12h09 |
| Sydney | 2026-06-21 | +10 | 11:56:54 | 01:56:54 | 32.694 | never |  | 10:43 | 13:11 | 9h54 |
| Sydney | 2026-07-15 | +10 | 12:01:08 | 02:01:08 | 34.594 | never |  | 10:25 | 13:37 | 10h06 |
| Sydney | 2026-09-23 | +10 | 11:47:42 | 01:47:42 | 56.159 | 09:42 | 13:54 | 08:16 | 15:19 | 12h08 |
| Sydney | 2026-12-21 | +11 | 12:53:02 | 01:53:02 | 79.567 | 09:32 | 16:14 | 08:19 | 17:27 | 14h25 |

### B. Elevation at local whole hours (NOAA algorithm, geometric, degrees; negative = below horizon)

Each cell is for that place's civil local hour using the offset in the header; UTC = local hour - offset.

**Vilnius** (lat +54.687, lon +25.280)

| Local hour | 2026-01-15 (UTC+2) | 2026-03-20 (UTC+2) | 2026-06-21 (UTC+3) | 2026-07-15 (UTC+3) | 2026-09-23 (UTC+3) | 2026-12-21 (UTC+2) |
|---|---|---|---|---|---|---|
| 04:00 | -38.25 | -20.35 | -4.74 | -6.86 | -25.39 | -38.50 |
| 05:00 | -29.77 | -12.45 | 1.10 | -1.04 | -18.30 | -29.93 |
| 06:00 | -21.12 | -3.95 | 8.15 | 6.02 | -10.24 | -21.31 |
| 07:00 | -12.68 | 4.71 | 16.07 | 13.96 | -1.70 | -13.01 |
| 08:00 | -4.80 | 13.15 | 24.53 | 22.42 | 6.93 | -5.38 |
| 09:00 | 2.16 | 20.94 | 33.19 | 31.07 | 15.22 | 1.25 |
| 10:00 | 7.85 | 27.55 | 41.63 | 39.49 | 22.73 | 6.55 |
| 11:00 | 11.90 | 32.42 | 49.30 | 47.13 | 28.94 | 10.15 |
| 12:00 | 13.99 | 34.97 | 55.33 | 53.16 | 33.25 | 11.79 |
| 13:00 | 13.93 | 34.82 | 58.51 | 56.47 | 35.10 | 11.33 |
| 14:00 | 11.74 | 31.99 | 57.90 | 56.14 | 34.23 | 8.81 |
| 15:00 | 7.60 | 26.90 | 53.70 | 52.28 | 30.76 | 4.43 |
| 16:00 | 1.84 | 20.14 | 47.05 | 45.89 | 25.17 | -1.49 |
| 17:00 | -5.18 | 12.27 | 39.06 | 38.06 | 18.06 | -8.61 |
| 18:00 | -13.08 | 3.81 | 30.50 | 29.55 | 9.98 | -16.57 |
| 19:00 | -21.53 | -4.83 | 21.87 | 20.90 | 1.41 | -25.05 |
| 20:00 | -30.18 | -13.25 | 13.54 | 12.49 | -7.24 | -33.70 |
| 21:00 | -38.62 | -21.00 | 5.86 | 4.66 | -15.57 | -42.11 |
| 22:00 | -46.29 | -27.59 | -0.86 | -2.23 | -23.12 | -49.71 |

**London** (lat +51.507, lon -0.128)

| Local hour | 2026-01-15 (UTC+0) | 2026-03-20 (UTC+0) | 2026-06-21 (UTC+1) | 2026-07-15 (UTC+1) | 2026-09-23 (UTC+1) | 2026-12-21 (UTC+0) |
|---|---|---|---|---|---|---|
| 04:00 | -36.42 | -19.41 | -5.53 | -7.68 | -25.29 | -36.40 |
| 05:00 | -27.14 | -10.62 | 1.20 | -0.94 | -17.19 | -27.09 |
| 06:00 | -17.87 | -1.36 | 9.09 | 6.97 | -8.26 | -17.91 |
| 07:00 | -8.96 | 7.95 | 17.80 | 15.70 | 1.02 | -9.20 |
| 08:00 | -0.76 | 16.90 | 26.97 | 24.89 | 10.25 | -1.29 |
| 09:00 | 6.37 | 25.04 | 36.29 | 34.20 | 19.02 | 5.46 |
| 10:00 | 12.03 | 31.79 | 45.32 | 43.19 | 26.84 | 10.66 |
| 11:00 | 15.81 | 36.47 | 53.41 | 51.24 | 33.11 | 13.96 |
| 12:00 | 17.39 | 38.42 | 59.47 | 57.30 | 37.12 | 15.06 |
| 13:00 | 16.61 | 37.31 | 61.93 | 59.94 | 38.28 | 13.85 |
| 14:00 | 13.53 | 33.32 | 59.82 | 58.21 | 36.38 | 10.46 |
| 15:00 | 8.46 | 27.07 | 53.98 | 52.75 | 31.74 | 5.17 |
| 16:00 | 1.78 | 19.26 | 45.99 | 45.02 | 25.02 | -1.64 |
| 17:00 | -6.10 | 10.50 | 37.01 | 36.16 | 16.90 | -9.59 |
| 18:00 | -14.80 | 1.27 | 27.70 | 26.87 | 7.96 | -18.33 |
| 19:00 | -23.98 | -8.01 | 18.50 | 17.61 | -1.34 | -27.53 |
| 20:00 | -33.28 | -16.94 | 9.75 | 8.74 | -10.61 | -36.84 |
| 21:00 | -42.29 | -25.05 | 1.78 | 0.61 | -19.42 | -45.83 |
| 22:00 | -50.39 | -31.77 | -5.06 | -6.44 | -27.28 | -53.84 |

**Phoenix** (lat +33.448, lon -112.074)

| Local hour | 2026-01-15 (UTC-7) | 2026-03-20 (UTC-7) | 2026-06-21 (UTC-7) | 2026-07-15 (UTC-7) | 2026-09-23 (UTC-7) | 2026-12-21 (UTC-7) |
|---|---|---|---|---|---|---|
| 04:00 | -43.84 | -31.66 | -14.31 | -16.40 | -28.84 | -42.50 |
| 05:00 | -31.34 | -19.81 | -4.25 | -6.25 | -16.83 | -30.06 |
| 06:00 | -19.00 | -7.46 | 6.83 | 4.93 | -4.42 | -17.89 |
| 07:00 | -7.03 | 5.06 | 18.58 | 16.77 | 8.07 | -6.17 |
| 08:00 | 4.34 | 17.46 | 30.78 | 29.02 | 20.38 | 4.86 |
| 09:00 | 14.78 | 29.45 | 43.22 | 41.50 | 32.15 | 14.84 |
| 10:00 | 23.81 | 40.51 | 55.71 | 53.96 | 42.81 | 23.28 |
| 11:00 | 30.75 | 49.76 | 67.86 | 65.95 | 51.31 | 29.50 |
| 12:00 | 34.80 | 55.59 | 78.00 | 75.78 | 55.90 | 32.76 |
| 13:00 | 35.29 | 56.15 | 78.04 | 76.70 | 54.98 | 32.56 |
| 14:00 | 32.14 | 51.21 | 67.94 | 67.58 | 48.92 | 28.92 |
| 15:00 | 25.88 | 42.48 | 55.79 | 55.72 | 39.57 | 22.40 |
| 16:00 | 17.33 | 31.69 | 43.30 | 43.29 | 28.46 | 13.75 |
| 17:00 | 7.20 | 19.84 | 30.86 | 30.79 | 16.46 | 3.63 |
| 18:00 | -3.96 | 7.51 | 18.66 | 18.48 | 4.05 | -7.50 |
| 19:00 | -15.79 | -4.99 | 6.90 | 6.56 | -8.46 | -19.28 |
| 20:00 | -28.05 | -17.37 | -4.18 | -4.75 | -20.81 | -31.49 |
| 21:00 | -40.52 | -29.32 | -14.25 | -15.09 | -32.64 | -43.94 |
| 22:00 | -52.98 | -40.34 | -22.80 | -23.99 | -43.40 | -56.43 |

**Reykjavik** (lat +64.147, lon -21.940)

| Local hour | 2026-01-15 (UTC+0) | 2026-03-20 (UTC+0) | 2026-06-21 (UTC+0) | 2026-07-15 (UTC+0) | 2026-09-23 (UTC+0) | 2026-12-21 (UTC+0) |
|---|---|---|---|---|---|---|
| 04:00 | -40.89 | -20.78 | 2.35 | 0.25 | -19.59 | -42.12 |
| 05:00 | -35.57 | -16.01 | 6.61 | 4.47 | -14.58 | -36.55 |
| 06:00 | -29.43 | -10.27 | 11.86 | 9.71 | -8.69 | -30.27 |
| 07:00 | -22.93 | -3.94 | 17.85 | 15.69 | -2.30 | -23.75 |
| 08:00 | -16.46 | 2.60 | 24.26 | 22.10 | 4.21 | -17.36 |
| 09:00 | -10.36 | 8.99 | 30.78 | 28.61 | 10.47 | -11.42 |
| 10:00 | -4.95 | 14.85 | 37.02 | 34.84 | 16.11 | -6.23 |
| 11:00 | -0.50 | 19.81 | 42.52 | 40.34 | 20.75 | -2.07 |
| 12:00 | 2.72 | 23.47 | 46.71 | 44.56 | 23.99 | 0.83 |
| 13:00 | 4.49 | 25.50 | 49.00 | 46.95 | 25.54 | 2.27 |
| 14:00 | 4.68 | 25.68 | 48.98 | 47.09 | 25.21 | 2.16 |
| 15:00 | 3.30 | 23.99 | 46.66 | 44.96 | 23.05 | 0.51 |
| 16:00 | 0.43 | 20.62 | 42.45 | 40.92 | 19.28 | -2.57 |
| 17:00 | -3.73 | 15.89 | 36.94 | 35.54 | 14.24 | -6.89 |
| 18:00 | -8.93 | 10.18 | 30.69 | 29.36 | 8.32 | -12.20 |
| 19:00 | -14.88 | 3.88 | 24.18 | 22.85 | 1.91 | -18.22 |
| 20:00 | -21.28 | -2.63 | 17.77 | 16.40 | -4.63 | -24.65 |
| 21:00 | -27.79 | -8.99 | 11.79 | 10.34 | -10.93 | -31.16 |
| 22:00 | -34.04 | -14.82 | 6.54 | 4.97 | -16.61 | -37.37 |

**Singapore** (lat +1.352, lon +103.820)

| Local hour | 2026-01-15 (UTC+8) | 2026-03-20 (UTC+8) | 2026-06-21 (UTC+8) | 2026-07-15 (UTC+8) | 2026-09-23 (UTC+8) | 2026-12-21 (UTC+8) |
|---|---|---|---|---|---|---|
| 04:00 | -44.94 | -48.08 | -41.08 | -42.73 | -44.32 | -41.68 |
| 05:00 | -31.51 | -33.08 | -28.12 | -29.55 | -29.32 | -28.46 |
| 06:00 | -17.70 | -18.08 | -14.64 | -15.87 | -14.32 | -14.86 |
| 07:00 | -3.74 | -3.08 | -0.94 | -1.99 | 0.68 | -1.12 |
| 08:00 | 10.23 | 11.92 | 12.82 | 11.96 | 15.67 | 12.60 |
| 09:00 | 24.06 | 26.91 | 26.45 | 25.82 | 30.67 | 26.12 |
| 10:00 | 37.55 | 41.91 | 39.75 | 39.41 | 45.67 | 39.19 |
| 11:00 | 50.27 | 56.90 | 52.23 | 52.32 | 60.66 | 51.23 |
| 12:00 | 61.14 | 71.87 | 62.66 | 63.48 | 75.63 | 60.91 |
| 13:00 | 67.27 | 86.59 | 67.86 | 69.67 | 88.41 | 65.20 |
| 14:00 | 64.88 | 77.96 | 64.39 | 66.54 | 74.23 | 61.56 |
| 15:00 | 55.72 | 63.02 | 54.73 | 56.62 | 59.26 | 52.21 |
| 16:00 | 43.65 | 48.03 | 42.54 | 44.14 | 44.27 | 40.30 |
| 17:00 | 30.44 | 33.03 | 29.37 | 30.73 | 29.27 | 27.30 |
| 18:00 | 16.73 | 18.04 | 15.78 | 16.93 | 14.28 | 13.81 |
| 19:00 | 2.80 | 3.04 | 2.04 | 2.99 | -0.72 | 0.10 |
| 20:00 | -11.18 | -11.96 | -11.69 | -10.94 | -15.72 | -13.65 |
| 21:00 | -25.10 | -26.96 | -25.24 | -24.73 | -30.72 | -27.27 |
| 22:00 | -38.77 | -41.95 | -38.34 | -38.15 | -45.72 | -40.53 |

**Sydney** (lat -33.868, lon +151.209)

| Local hour | 2026-01-15 (UTC+11) | 2026-03-20 (UTC+11) | 2026-06-21 (UTC+10) | 2026-07-15 (UTC+10) | 2026-09-23 (UTC+10) | 2026-12-21 (UTC+11) |
|---|---|---|---|---|---|---|
| 04:00 | -20.85 | -36.22 | -36.40 | -36.46 | -22.17 | -17.46 |
| 05:00 | -11.42 | -24.88 | -24.12 | -24.11 | -9.95 | -7.97 |
| 06:00 | -0.74 | -12.80 | -12.19 | -12.05 | 2.50 | 2.71 |
| 07:00 | 10.77 | -0.41 | -0.82 | -0.50 | 14.88 | 14.19 |
| 08:00 | 22.80 | 12.00 | 9.69 | 10.25 | 26.91 | 26.19 |
| 09:00 | 35.14 | 24.15 | 18.93 | 19.79 | 38.13 | 38.51 |
| 10:00 | 47.58 | 35.63 | 26.31 | 27.53 | 47.75 | 50.95 |
| 11:00 | 59.79 | 45.76 | 31.12 | 32.71 | 54.34 | 63.22 |
| 12:00 | 70.93 | 53.28 | 32.69 | 34.59 | 56.04 | 74.40 |
| 13:00 | 77.24 | 56.33 | 30.76 | 32.86 | 52.16 | 79.46 |
| 14:00 | 72.32 | 53.74 | 25.65 | 27.80 | 44.13 | 72.03 |
| 15:00 | 61.52 | 46.52 | 18.04 | 20.15 | 33.74 | 60.41 |
| 16:00 | 49.38 | 36.55 | 8.65 | 10.68 | 22.13 | 48.06 |
| 17:00 | 36.95 | 25.14 | -1.97 | -0.03 | 9.93 | 35.63 |
| 18:00 | 24.57 | 13.03 | -13.40 | -11.56 | -2.50 | 23.37 |
| 19:00 | 12.47 | 0.61 | -25.38 | -23.60 | -14.87 | 11.47 |
| 20:00 | 0.85 | -11.82 | -37.68 | -35.94 | -26.87 | 0.15 |
| 21:00 | -9.99 | -23.96 | -50.12 | -48.38 | -38.05 | -10.29 |
| 22:00 | -19.66 | -35.44 | -62.42 | -60.59 | -47.62 | -19.43 |

### C. Full-day cross-check against JPL Horizons (1-minute samples, local civil day)

For every place/date: 1441 one-minute samples (local 00:00 to 24:00 inclusive) of NOAA-algorithm elevation vs Horizons topocentric airless elevation. Window columns: first/last whole minute >= threshold from Horizons samples minus the same from NOAA (minutes; 0 = identical).

| Place | Date | max abs dev (deg) | mean dev (deg) | max elev NOAA | max elev Horizons | d>=45 first/last (min) | d>=30 first/last (min) |
|---|---|---|---|---|---|---|---|
| Vilnius | 2026-01-15 | 0.0052 | +0.0028 | 14.233 | 14.230 | never/never | never/never |
| Vilnius | 2026-03-20 | 0.0045 | +0.0042 | 35.244 | 35.240 | never/never | +0/+0 |
| Vilnius | 2026-06-21 | 0.0035 | +0.0022 | 58.751 | 58.750 | +0/+0 | +0/+0 |
| Vilnius | 2026-07-15 | 0.0026 | +0.0018 | 56.796 | 56.795 | +0/+0 | +0/+0 |
| Vilnius | 2026-09-23 | 0.0056 | +0.0033 | 35.150 | 35.147 | never/never | +0/+0 |
| Vilnius | 2026-12-21 | 0.0036 | +0.0017 | 11.876 | 11.874 | never/never | never/never |
| London | 2026-01-15 | 0.0053 | +0.0027 | 17.427 | 17.423 | never/never | never/never |
| London | 2026-03-20 | 0.0044 | +0.0041 | 38.452 | 38.448 | never/never | +0/+0 |
| London | 2026-06-21 | 0.0036 | +0.0022 | 61.931 | 61.930 | +0/+0 | +0/+0 |
| London | 2026-07-15 | 0.0026 | +0.0018 | 59.964 | 59.963 | +0/+0 | +0/+0 |
| London | 2026-09-23 | 0.0057 | +0.0032 | 38.303 | 38.300 | never/never | +0/+0 |
| London | 2026-12-21 | 0.0038 | +0.0017 | 15.056 | 15.054 | never/never | never/never |
| Phoenix | 2026-01-15 | 0.0058 | +0.0024 | 35.544 | 35.541 | never/never | +0/+0 |
| Phoenix | 2026-03-20 | 0.0042 | +0.0034 | 56.634 | 56.630 | +0/+0 | +0/+0 |
| Phoenix | 2026-06-21 | 0.0037 | +0.0020 | 79.989 | 79.989 | +0/+0 | +0/+0 |
| Phoenix | 2026-07-15 | 0.0026 | +0.0017 | 77.973 | 77.973 | +0/+0 | +0/+0 |
| Phoenix | 2026-09-23 | 0.0061 | +0.0027 | 56.241 | 56.238 | +0/+0 | +0/+0 |
| Phoenix | 2026-12-21 | 0.0044 | +0.0017 | 33.114 | 33.112 | never/never | +0/+0 |
| Reykjavik | 2026-01-15 | 0.0047 | +0.0029 | 4.798 | 4.795 | never/never | never/never |
| Reykjavik | 2026-03-20 | 0.0046 | +0.0044 | 25.836 | 25.831 | never/never | never/never |
| Reykjavik | 2026-06-21 | 0.0033 | +0.0023 | 49.291 | 49.289 | +0/+0 | +0/+0 |
| Reykjavik | 2026-07-15 | 0.0024 | +0.0019 | 47.315 | 47.313 | +1/+0 | +0/+0 |
| Reykjavik | 2026-09-23 | 0.0051 | +0.0034 | 25.639 | 25.636 | never/never | never/never |
| Reykjavik | 2026-12-21 | 0.0032 | +0.0018 | 2.416 | 2.413 | never/never | never/never |
| Singapore | 2026-01-15 | 0.0060 | +0.0018 | 67.528 | 67.526 | +0/+0 | +0/+0 |
| Singapore | 2026-03-20 | 0.0029 | +0.0016 | 88.492 | 88.489 | +0/+0 | +0/+0 |
| Singapore | 2026-06-21 | 0.0041 | +0.0017 | 67.914 | 67.913 | +0/+0 | +0/+0 |
| Singapore | 2026-07-15 | 0.0031 | +0.0016 | 69.835 | 69.834 | +0/+0 | +0/+0 |
| Singapore | 2026-09-23 | 0.0061 | +0.0017 | 88.569 | 88.568 | +0/+0 | +0/+0 |
| Singapore | 2026-12-21 | 0.0050 | +0.0018 | 65.212 | 65.211 | +0/+0 | +0/+0 |
| Sydney | 2026-01-15 | 0.0051 | +0.0014 | 77.276 | 77.276 | +0/+0 | +0/+0 |
| Sydney | 2026-03-20 | 0.0014 | +0.0002 | 56.339 | 56.340 | +0/+0 | +0/+0 |
| Sydney | 2026-06-21 | 0.0037 | +0.0017 | 32.694 | 32.692 | never/never | +0/+0 |
| Sydney | 2026-07-15 | 0.0032 | +0.0020 | 34.594 | 34.592 | never/never | +0/+0 |
| Sydney | 2026-09-23 | 0.0048 | +0.0011 | 56.158 | 56.158 | +0/+0 | +0/+0 |
| Sydney | 2026-12-21 | 0.0048 | +0.0022 | 79.567 | 79.567 | +0/+0 | +0/+0 |

Worst single-sample |NOAA - Horizons| over all 36 days x 1441 samples: **0.0061 deg**.

### D. Solar-noon cross-check against MET Norway (api.met.no sunrise v3), disc-centre elevation

Sunrise/sunset: NOAA = geometric elevation -0.833 deg crossing (rounded to nearest minute); MET = its published sunrise/sunset (minute).

| Place | Date | UTC off | NOAA noon local | MET noon local | NOAA max elev | MET noon elev | dev elev (deg) | sunrise NOAA / MET | sunset NOAA / MET |
|---|---|---|---|---|---|---|---|---|---|
| Vilnius | 2026-01-15 | +2 | 12:28 | 12:28 | 14.233 | 14.23 | +0.003 | 08:33 / 08:33 | 16:24 / 16:23 |
| Vilnius | 2026-03-20 | +2 | 12:26 | 12:26 | 35.244 | 35.24 | +0.004 | 06:22 / 06:21 | 18:32 / 18:32 |
| Vilnius | 2026-06-21 | +3 | 13:20 | 13:20 | 58.751 | 58.75 | +0.001 | 04:42 / 04:41 | 22:00 / 21:59 |
| Vilnius | 2026-07-15 | +3 | 13:24 | 13:24 | 56.796 | 56.79 | +0.006 | 05:02 / 05:01 | 21:47 / 21:46 |
| Vilnius | 2026-09-23 | +3 | 13:11 | 13:11 | 35.150 | 35.15 | +0.000 | 07:06 / 07:06 | 19:15 / 19:15 |
| Vilnius | 2026-12-21 | +2 | 12:16 | 12:16 | 11.876 | 11.87 | +0.006 | 08:40 / 08:39 | 15:54 / 15:53 |
| London | 2026-01-15 | +0 | 12:09 | 12:09 | 17.427 | 17.42 | +0.007 | 07:59 / 07:59 | 16:21 / 16:20 |
| London | 2026-03-20 | +0 | 12:07 | 12:07 | 38.452 | 38.45 | +0.002 | 06:03 / 06:03 | 18:14 / 18:13 |
| London | 2026-06-21 | +1 | 13:02 | 13:02 | 61.931 | 61.93 | +0.001 | 04:43 / 04:43 | 21:22 / 21:21 |
| London | 2026-07-15 | +1 | 13:06 | 13:06 | 59.964 | 59.96 | +0.004 | 05:01 / 05:00 | 21:11 / 21:11 |
| London | 2026-09-23 | +1 | 12:52 | 12:52 | 38.303 | 38.30 | +0.003 | 06:48 / 06:48 | 18:57 / 18:56 |
| London | 2026-12-21 | +0 | 11:58 | 11:58 | 15.056 | 15.05 | +0.006 | 08:04 / 08:03 | 15:53 / 15:53 |
| Phoenix | 2026-01-15 | -7 | 12:37 | 12:37 | 35.544 | 35.54 | +0.004 | 07:32 / 07:32 | 17:44 / 17:43 |
| Phoenix | 2026-03-20 | -7 | 12:35 | 12:35 | 56.634 | 56.63 | +0.004 | 06:32 / 06:31 | 18:40 / 18:40 |
| Phoenix | 2026-06-21 | -7 | 12:30 | 12:30 | 79.989 | 79.99 | -0.001 | 05:19 / 05:19 | 19:41 / 19:41 |
| Phoenix | 2026-07-15 | -7 | 12:34 | 12:34 | 77.974 | 77.97 | +0.004 | 05:30 / 05:29 | 19:39 / 19:38 |
| Phoenix | 2026-09-23 | -7 | 12:20 | 12:20 | 56.241 | 56.24 | +0.001 | 06:17 / 06:17 | 18:23 / 18:23 |
| Phoenix | 2026-12-21 | -7 | 12:26 | 12:26 | 33.114 | 33.11 | +0.004 | 07:28 / 07:28 | 17:25 / 17:24 |
| Reykjavik | 2026-01-15 | +0 | 13:37 | 13:37 | 4.798 | 4.79 | +0.008 | 10:55 / 10:54 | 16:20 / 16:20 |
| Reykjavik | 2026-03-20 | +0 | 13:35 | 13:35 | 25.836 | 25.83 | +0.006 | 07:29 / 07:28 | 19:43 / 19:43 |
| Reykjavik | 2026-06-21 | +0 | 13:29 | 13:29 | 49.291 | 49.29 | +0.001 | 02:55 / 02:55 | 00:04 / 00:03 |
| Reykjavik | 2026-07-15 | +0 | 13:33 | 13:33 | 47.315 | 47.31 | +0.005 | 03:41 / 03:40 | 23:24 / 23:24 |
| Reykjavik | 2026-09-23 | +0 | 13:20 | 13:20 | 25.639 | 25.64 | -0.001 | 07:14 / 07:13 | 19:25 / 19:25 |
| Reykjavik | 2026-12-21 | +0 | 13:25 | 13:25 | 2.416 | 2.41 | +0.006 | 11:22 / 11:22 | 15:29 / 15:29 |
| Singapore | 2026-01-15 | +8 | 13:14 | 13:14 | 67.528 | 67.53 | -0.002 | 07:12 / 07:12 | 19:16 / 19:15 |
| Singapore | 2026-03-20 | +8 | 13:12 | 13:12 | 88.493 | 88.49 | +0.003 | 07:09 / 07:09 | 19:15 / 19:15 |
| Singapore | 2026-06-21 | +8 | 13:06 | 13:06 | 67.914 | 67.91 | +0.004 | 07:00 / 07:00 | 19:13 / 19:12 |
| Singapore | 2026-07-15 | +8 | 13:10 | 13:10 | 69.835 | 69.83 | +0.005 | 07:05 / 07:04 | 19:16 / 19:16 |
| Singapore | 2026-09-23 | +8 | 12:57 | 12:57 | 88.570 | 88.57 | +0.000 | 06:54 / 06:53 | 19:00 / 19:00 |
| Singapore | 2026-12-21 | +8 | 13:02 | 13:02 | 65.212 | 65.21 | +0.002 | 07:01 / 07:01 | 19:04 / 19:04 |
| Sydney | 2026-01-15 | +11 | 13:04 | 13:04 | 77.276 | 77.28 | -0.004 | 05:59 / 05:59 | 20:09 / 20:08 |
| Sydney | 2026-03-20 | +11 | 13:02 | 13:02 | 56.339 | 56.34 | -0.001 | 06:58 / 06:57 | 19:07 / 19:06 |
| Sydney | 2026-06-21 | +10 | 11:56 | 11:56 | 32.694 | 32.69 | +0.004 | 07:00 / 06:59 | 16:54 / 16:53 |
| Sydney | 2026-07-15 | +10 | 12:01 | 12:01 | 34.594 | 34.59 | +0.004 | 06:58 / 06:58 | 17:04 / 17:04 |
| Sydney | 2026-09-23 | +10 | 11:47 | 11:47 | 56.159 | 56.16 | -0.001 | 05:44 / 05:43 | 17:52 / 17:51 |
| Sydney | 2026-12-21 | +11 | 12:53 | 12:53 | 79.567 | 79.57 | -0.003 | 05:41 / 05:40 | 20:05 / 20:05 |

Max |NOAA - MET| elevation deviation: **0.008 deg** (MET prints 2 decimals; noon time printed to the minute).

### Inferences
- A Double-precision port of the NOAA formulas should reproduce Tables A and B to better than 0.01 deg and the whole-minute windows to +/-1 minute; assert with +/-0.02 deg and +/-1 minute on window edges. Reykjavik 2026-07-15 first >=45 minute already differs by 1 minute between NOAA and Horizons (shallow crossing).
- The small positive NOAA-minus-Horizons bias (0.0002-0.0044 deg mean) is far below any useful tolerance; likely the low-precision series versus Horizons' apparent-place corrections, not investigated.
- Table B is per whole local clock hour; for a `(lat, lon, UTC date-time)` test convert local hour minus offset to UTC (e.g. Vilnius 2026-06-21 12:00 local at +3 = 09:00 UTC = 55.33 deg).
- The Singapore equinox rows pass within about 1.5 deg of the zenith (max 88.49 on Mar 20, 88.57 on Sep 23); a Float32 `acos` near 1 is ill-conditioned (one Float32 ulp is about 0.02 deg there), so keep these as numerical edge fixtures. Not tested in Float32.

### Gaps
- The interactive NOAA web calculator, timeanddate.com and suncalc.org are JavaScript front ends and were not queried; the NOAA web calculator runs the same formulas as the reference implementation, so it would not be an independent check. JPL Horizons and MET Norway were used instead (36 + 36 independent comparisons, plus 10 named spot checks, versus the 6 requested).
- No Garmin Float32/Monkey C math results; simulator or device behaviour is untested.
- Observer altitude and local horizon (terrain, buildings) are not modelled; sea level, flat horizon.

## Which place/date pairs have no 45 degree window (2026, every day scanned)

### Takeaway
Daily max elevation >= 45 deg occurs only in these 2026 date ranges: Vilnius Apr 15 - Aug 27 (135 days); London Apr 6 - Sep 5 (153); Phoenix Feb 18 - Oct 22 (247); Reykjavik May 16 - Jul 26 (72); Singapore all year; Sydney Jan 1 - Apr 18 and Aug 25 - Dec 31 (237). So there is NO 45 deg window in Vilnius Aug 28 - Apr 14, London Sep 6 - Apr 5, Reykjavik Jan 1 - May 15 and Jul 27 - Dec 31, Phoenix Oct 23 - Feb 17, Sydney Apr 19 - Aug 24 (southern winter). For 30 deg: Vilnius Mar 7 - Oct 6, London Feb 27 - Oct 14, Reykjavik Mar 31 - Sep 11; Phoenix, Singapore and Sydney reach 30 deg every day (lowest daily maxima 33.11 Phoenix 2026-12-21, 32.69 Sydney 2026-06-21).

### Cited Findings
- All numbers are computed by `solar_elevation_fixtures.py` from the NOAA algorithm; every edge day was re-checked with JPL Horizons 1-minute samples around noon (max elevation agrees to 0.0001-0.005 deg; identical in/out verdict on every edge day except the knife-edge Sydney 2026-04-19) — [JPL Horizons API](https://ssd.jpl.nasa.gov/api/horizons.api)
- A "day" is the civil date at the place's standard offset (Vilnius +2, London 0, Phoenix -7, Reykjavik 0, Singapore +8, Sydney +10). Max elevation is geometric; adding refraction would raise a 45 deg reading by at most 0.016 deg, which would move no boundary except the knife-edge Sydney dates.
- Knife-edge dates: Sydney 2026-04-19 max = 44.9995 deg (NOAA) vs 45.0000 (Horizons); 2026-08-24 = 44.9949 / 44.9941; "in or out" at exactly 45 deg is not decidable at this algorithm's precision. Thin margins elsewhere (NOAA, deg relative to 45): Reykjavik 2026-05-16 +0.037 (in) and 2026-07-27 -0.024 (out); London 2026-04-06 +0.058; Vilnius 2026-08-28 -0.062; Phoenix 2026-10-23 -0.058. Do not use these dates as exact boundary assertions with a tight tolerance.

### E. 2026 scan: days whose maximum elevation >= threshold (NOAA algorithm, every day of 2026)

A day is the civil date at the place's STANDARD offset (Vilnius +2, London 0, Phoenix -7, Reykjavik 0, Singapore +8, Sydney +10); the daily maximum does not depend on that choice to within 0.001 deg.

| Place | threshold | date ranges with max >= threshold | days | lowest margin inside (deg) | highest max just outside (deg) |
|---|---|---|---|---|---|
| Vilnius | 45 | Apr 15 - Aug 27 | 135 | +0.162 | -0.062 |
| Vilnius | 30 | Mar 07 - Oct 06 | 214 | +0.111 | -0.262 |
| London | 45 | Apr 06 - Sep 05 | 153 | +0.058 | -0.182 |
| London | 30 | Feb 27 - Oct 14 | 230 | +0.242 | -0.111 |
| Phoenix | 45 | Feb 18 - Oct 22 | 247 | +0.139 | -0.058 |
| Phoenix | 30 | all year | 365 | - | - |
| Reykjavik | 45 | May 16 - Jul 26 | 72 | +0.037 | -0.024 |
| Reykjavik | 30 | Mar 31 - Sep 11 | 165 | +0.148 | -0.110 |
| Singapore | 45 | all year | 365 | - | - |
| Singapore | 30 | all year | 365 | - | - |
| Sydney | 45 | Jan 01 - Apr 18; Aug 25 - Dec 31 | 237 | +0.338 | -0.000 |
| Sydney | 30 | all year | 365 | - | - |

Edge days (max elevation in deg; NOAA, then JPL Horizons sampled at 1-minute steps within +/-15 min of NOAA noon):

| Place | threshold | edge | date | NOAA max | Horizons max | in/out |
|---|---|---|---|---|---|---|
| Vilnius | 45 | first in | 2026-04-15 | 45.1619 | 45.1574 | in |
| Vilnius | 45 | day before | 2026-04-14 | 44.8037 | 44.7990 | out |
| Vilnius | 45 | last in | 2026-08-27 | 45.2901 | 45.2879 | in |
| Vilnius | 45 | day after | 2026-08-28 | 44.9379 | 44.9359 | out |
| Vilnius | 30 | first in | 2026-03-07 | 30.1264 | 30.1214 | in |
| Vilnius | 30 | day before | 2026-03-06 | 29.7378 | 29.7329 | out |
| Vilnius | 30 | last in | 2026-10-06 | 30.1113 | 30.1091 | in |
| Vilnius | 30 | day after | 2026-10-07 | 29.7285 | 29.7262 | out |
| London | 45 | first in | 2026-04-06 | 45.0585 | 45.0534 | in |
| London | 45 | day before | 2026-04-05 | 44.6802 | 44.6751 | out |
| London | 45 | last in | 2026-09-05 | 45.1902 | 45.1887 | in |
| London | 45 | day after | 2026-09-06 | 44.8182 | 44.8165 | out |
| London | 30 | first in | 2026-02-27 | 30.2652 | 30.2617 | in |
| London | 30 | day before | 2026-02-26 | 29.8895 | 29.8861 | out |
| London | 30 | last in | 2026-10-14 | 30.2419 | 30.2387 | in |
| London | 30 | day after | 2026-10-15 | 29.8716 | 29.8684 | out |
| Phoenix | 45 | first in | 2026-02-18 | 45.1387 | 45.1354 | in |
| Phoenix | 45 | day before | 2026-02-17 | 44.7851 | 44.7817 | out |
| Phoenix | 45 | last in | 2026-10-22 | 45.2921 | 45.2895 | in |
| Phoenix | 45 | day after | 2026-10-23 | 44.9419 | 44.9396 | out |
| Phoenix | 30 | first in | 2026-01-01 | 33.6028 | 33.6010 | in |
| Phoenix | 30 | last in | 2026-12-31 | 33.5011 | 33.4987 | in |
| Reykjavik | 45 | first in | 2026-05-16 | 45.0368 | 45.0334 | in |
| Reykjavik | 45 | day before | 2026-05-15 | 44.8053 | 44.8018 | out |
| Reykjavik | 45 | last in | 2026-07-26 | 45.2019 | 45.2000 | in |
| Reykjavik | 45 | day after | 2026-07-27 | 44.9764 | 44.9745 | out |
| Reykjavik | 30 | first in | 2026-03-31 | 30.1476 | 30.1431 | in |
| Reykjavik | 30 | day before | 2026-03-30 | 29.7602 | 29.7558 | out |
| Reykjavik | 30 | last in | 2026-09-11 | 30.2709 | 30.2681 | in |
| Reykjavik | 30 | day after | 2026-09-12 | 29.8898 | 29.8868 | out |
| Singapore | 45 | first in | 2026-01-01 | 65.6479 | 65.6472 | in |
| Singapore | 45 | last in | 2026-12-31 | 65.5520 | 65.5506 | in |
| Singapore | 30 | first in | 2026-01-01 | 65.6479 | 65.6472 | in |
| Singapore | 30 | last in | 2026-12-31 | 65.5520 | 65.5506 | in |
| Sydney | 45 | first in | 2026-01-01 | 79.1429 | 79.1416 | in |
| Sydney | 45 | last in | 2026-04-18 | 45.3473 | 45.3479 | in |
| Sydney | 45 | day after | 2026-04-19 | 44.9995 | 45.0000 | out |
| Sydney | 45 | first in | 2026-08-25 | 45.3379 | 45.3369 | in |
| Sydney | 45 | day before | 2026-08-24 | 44.9949 | 44.9941 | out |
| Sydney | 45 | last in | 2026-12-31 | 79.2376 | 79.2372 | in |
| Sydney | 30 | first in | 2026-01-01 | 79.1429 | 79.1416 | in |
| Sydney | 30 | last in | 2026-12-31 | 79.2376 | 79.2372 | in |

### H. How far the date ranges move if the elevation is off by +/-0.5 or +/-1.0 deg (NOAA daily maxima, 2026)

Range of dates whose daily max >= (threshold + shift). shift -0.5 = an implementation that reads 0.5 deg too HIGH counts a day as in-window when the true max is 0.5 deg lower.

| Place | thr | shift -1.0 | shift -0.5 | shift 0 | shift +0.5 | shift +1.0 |
|---|---|---|---|---|---|---|
| Vilnius | 45 | Apr 12-Aug 30 | Apr 14-Aug 29 | Apr 15-Aug 27 | Apr 16-Aug 26 | Apr 18-Aug 24 |
| Vilnius | 30 | Mar 05-Oct 08 | Mar 06-Oct 07 | Mar 07-Oct 06 | Mar 08-Oct 04 | Mar 10-Oct 03 |
| London | 45 | Apr 04-Sep 08 | Apr 05-Sep 06 | Apr 06-Sep 05 | Apr 08-Sep 04 | Apr 09-Sep 02 |
| London | 30 | Feb 24-Oct 17 | Feb 25-Oct 16 | Feb 27-Oct 14 | Feb 28-Oct 13 | Mar 01-Oct 11 |
| Phoenix | 45 | Feb 15-Oct 25 | Feb 17-Oct 24 | Feb 18-Oct 22 | Feb 20-Oct 21 | Feb 21-Oct 20 |
| Phoenix | 30 | all year | all year | all year | all year | all year |
| Reykjavik | 45 | May 12-Jul 31 | May 14-Jul 29 | May 16-Jul 26 | May 19-Jul 24 | May 21-Jul 22 |
| Reykjavik | 30 | Mar 29-Sep 14 | Mar 30-Sep 13 | Mar 31-Sep 11 | Apr 01-Sep 10 | Apr 03-Sep 09 |
| Singapore | 45 | all year | all year | all year | all year | all year |
| Singapore | 30 | all year | all year | all year | all year | all year |
| Sydney | 45 | Jan 01-Apr 21; Aug 22-Dec 31 | Jan 01-Apr 20; Aug 23-Dec 31 | Jan 01-Apr 18; Aug 25-Dec 31 | Jan 01-Apr 17; Aug 26-Dec 31 | Jan 01-Apr 16; Aug 27-Dec 31 |
| Sydney | 30 | all year | all year | all year | all year | all year |

### Inferences
- With +/-0.5 deg elevation error a range boundary moves 1-3 days (Reykjavik 2-3, where declination changes slowly near the solstice); with +/-1.0 deg 3-5 days. A boundary-date test needs a tolerance in days (e.g. +/-2 days at 0.5 deg elevation tolerance) or dates well inside/outside the range (e.g. Vilnius 2026-05-15 inside; 2026-03-20 and 2026-10-15 outside).
- Vilnius and London lack a 45 deg window for about 7.5 months a year (Aug 28 - Apr 14; Sep 6 - Apr 5), so the "no window" state is the common state there; the October-to-March expectation holds with margin (on Mar 20 the max is only 35.2 deg in Vilnius and 38.5 deg in London).

### Gaps
- 2026 only; range edges shift by about a day between years (leap-year cycle), not computed for other years.
- Ranges ignore observer altitude and horizon profile.

## Accuracy limits and suggested tolerances

### Takeaway
Full NOAA formulas are reference-grade for this purpose (<= 0.006 deg vs JPL Horizons; refraction, not modelled, is <= 0.03 deg above 30 deg elevation). Simplified formulas, measured over all six places and every day of 2026: Spencer (1971) Fourier series max 0.46 deg elevation error (RMS 0.25), Cooper declination + EoT approximation max 1.19 deg (RMS 0.42), Cooper with the equation of time ignored max 4.1 deg. A +/-0.5 deg tolerance only just covers Spencer and fails for the cruder variants.

### Cited Findings
- NOAA states the solar position calculations are approximate because the atmosphere varies with pressure, humidity and other variables — [NOAA GML Solar Calculator technical details](https://gml.noaa.gov/grad/solcalc/calcdetails.html)
- Measured here, not cited: NOAA vs Horizons max deviation 0.0061 deg (Table C); vs MET 0.008 deg (Table D); simplified-formula errors in Table F. The Spencer 1971 and Cooper formulas were implemented as commonly published (from memory; coefficients not re-fetched this session).
- Spencer's declination differs from NOAA's by up to about 0.4 deg on 2026 dates (e.g. 2026-03-17: -1.65 deg vs -1.23 deg), about one day of declination motion near the equinoxes; its equation of time was within about 0.8 minute of NOAA's on the dates sampled (every 15th day).
- Ignoring the equation of time (up to about +/-16 minutes = up to 4 deg of hour angle) costs up to 4.1 deg elevation and shifts the 45 deg crossing by up to 43 minutes; it is the dominant simplification error.

### F. Accuracy of simplified formulas versus the NOAA algorithm (all 6 places, every day of 2026)

Elevation error: every 10 minutes over the whole UTC day, only samples with NOAA elevation >= 10 deg (the region the app cares about). Max-elevation error: daily max (sampled at NOAA transit). Crossing error: shift of the 45-deg and 30-deg crossing times in minutes (days where both define one).

| Formula | max abs elev err (deg) | RMS elev err (deg) | 99th pct abs (deg) | max abs daily-max err (deg) | max abs 45-deg crossing shift (min) | max abs 30-deg crossing shift (min) | days where >=45 yes/no verdict differs (of 2190) |
|---|---|---|---|---|---|---|---|
| Spencer | 0.457 | 0.254 | 0.446 | 0.441 | 9.7 | 12.5 | 12 |
| Cooper+EoT | 1.185 | 0.422 | 1.144 | 1.164 | 28.1 | 40.5 | 13 |
| Cooper, EoT=0 | 4.101 | 1.292 | 3.714 | 1.766 | 42.8 | 50.5 | 13 |

### G. Refraction (NOAA spreadsheet approximation) and parallax

| True elevation (deg) | refraction added (deg) | (arcmin) |
|---|---|---|
| 0 | 0.4819 | 28.92 |
| 5 | 0.1596 | 9.58 |
| 10 | 0.0881 | 5.29 |
| 15 | 0.0592 | 3.55 |
| 20 | 0.0439 | 2.64 |
| 30 | 0.0279 | 1.67 |
| 45 | 0.0161 | 0.97 |
| 60 | 0.0093 | 0.56 |
| 80 | 0.0028 | 0.17 |

Solar parallax: 8.794 arcsec x cos(elevation) = 0.0024 deg at the horizon, 0.0017 deg at 45 deg (negligible).

### Inferences
- Suggested test tolerances: Double-precision NOAA port +/-0.02 deg and +/-1 minute on window edges. Spencer-based routine: observed max 0.457 deg leaves no headroom at +/-0.5, so use +/-0.6 deg, +/-10 minutes on 45/30 deg window edges, +/-2 days on date ranges. Cooper-style: +/-1.3 deg and +/-30 minutes, which is too loose for a 45 deg rule. Prefer the full NOAA formulas (or Spencer with a declination phase correction).
- Spencer's error looks like a calendar-phase effect (series fitted to a mean year, not leap-corrected): inferred from the pattern of declination offsets, not verified; check other years (e.g. 2027-2029) before relying on the 0.46 deg figure.
- Refraction is irrelevant for the 30 / 45 deg thresholds (0.028 / 0.016 deg). It matters for sunrise/sunset (0.833 deg total including semi-diameter) and at or below 10 deg elevation (0.09 deg or more; 0.48 deg at the horizon). The fixtures are geometric, so do not add refraction in the routine under test. Parallax (<= 0.0024 deg) and the Earth's ellipsoid are negligible.
- Float32 (Monkey C `Float`) effect not measured: a Julian date near 2.46e6 cannot be held in Float32 (resolution about 0.25 day), so compute from days since 2000 or day-of-year, in `Double` where available.

### Gaps
- Monkey C `Float`/`Double` math on real devices was not tested.
- Simplified-formula accuracy for years other than 2026 was not computed.
