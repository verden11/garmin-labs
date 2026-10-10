# Platform findings: Body Battery, sun times, location

Snapshot 2026-09-26, SDK 9.2.0, simulator only unless stated. Logs, probe sources in `probe/`. **Nothing here has run on a wrist.**

## 1. Which calls need which permission

**Compiler** (`monkeyc -w --typecheck 3` on throwaway watch face, `probe/ProbeApp-permission-and-sources.mc`, built with **no** permissions):

| Call | Compiler says | Needs |
|---|---|---|
| `Position.getInfo()` | error "Permission 'Positioning' required" | **Positioning** |
| `Activity.getActivityInfo().currentLocation` | no error | nothing |
| `Weather.getCurrentConditions()`, `.observationLocationPosition` | no error | nothing (**see runtime, below**) |
| `Weather.getSunrise(loc, moment)`, `getSunset(...)` | no error | nothing |
| `new Position.Location({:latitude, :longitude, :format})` | no error | nothing |
| `Complications.*` | error | **ComplicationSubscriber** (or Publisher) |
| `SensorHistory.getBodyBatteryHistory`, `SensorHistoryIterator.next`, `SensorSample.data/when` | error | **SensorHistory** |

**Runtime, simulator (fr965). Compiler does not tell whole story:**

- No permission: first `Position.getInfo()` call ends app with `Error: Permission Required`; **not** catchable with `try/catch`. Every permissioned call must sit behind manifest declaring permission.
- **`Weather.getCurrentConditions().observationLocationPosition` non-null only when Positioning declared.** Same source, same run order, alternating with/without Positioning: **3 of 3 with, 0 of 3 without** (`probe/sim-weather-location-vs-positioning.log`; earlier runs agree: 4 of 4 with, 0 of 2 without). `getCurrentConditions()` itself non-null in both, with temperature, observation time; only location withheld. Without location, `Weather.getSunrise` has nothing to be called with. **My first reading ("flaky") wrong: tracks permission exactly.**
- **Consequence:** without Positioning, face may have **no location source at all in simulator** (`Activity.currentLocation` null here for lack of activity, so its permission behaviour untested). Whether *real watch* behaves same, and whether `Activity.currentLocation` also needs permission at runtime, is what two on-watch probes answer (`LocationProbe-P.prg` with Positioning, `LocationProbe-N.prg` without).

Docs: `Position.getInfo()` "Using this API requires enabling the Positioning Permission" (SDK `Toybox/Position.html`).

## 2. Simulator runtime results (fr965, API 5.2)

| Source | Simulator value | Meaning |
|---|---|---|
| `Position.getInfo().position` (with Positioning) | `null`, accuracy 0 | No fix in simulator; says nothing about watch |
| `Activity.getActivityInfo().currentLocation` | `null` (with and without Positioning) | No activity in simulator |
| `Weather...observationLocationPosition` | `38.86,-94.80` **with** Positioning, `null` without | Canned simulator weather location; see §1 |
| `Complications` SUNRISE (13) / SUNSET (14) / BODY_BATTERY (23) | `54535` / `11599` / varies | Seconds since local midnight, **sunset 03:13 earlier than sunrise 15:08** (canned; see rule in `spec.md`); no permission other than ComplicationSubscriber |
| `SensorHistory.getBodyBatteryHistory({:period => Duration(24h)})` | 480 samples, 60 s apart, **`oldest-first`, 478 of them dated in future** (newest sample 26/16:32, last 27/00:31) | Simulator data synthetic, runs forward in time; do not read its cadence or order as watch's. Probe prints `n`, smallest gap (absolute), order, future count so watch's own values unambiguous |

SDK facts (docs): `Complications` since API 4.2.0: `COMPLICATION_TYPE_SUNRISE` = "non-negative Number representing **seconds since midnight local time** of the sunrise or null"; `SUNSET` likewise; `BODY_BATTERY` = "Number representing your current body battery or null"; `STRESS`, `SLEEP_SCORE` (6.0.2), `SOLAR_INPUT` also exist. `SensorHistory.getBodyBatteryHistory` since 3.3.0; options `:period` (Number = last N entries, or Duration), `:order`; "the time between each SensorSample in the iterator may be device dependent." `Weather` since 3.2.0; `getSunrise/getSunset` since 3.3.0, take `Position.Location` and `Time.Moment`, return `Moment or Null`. **No** dawn, dusk, twilight, golden-hour call.

## 3. `Weather.getSunrise/getSunset` return the events of the **watch's local calendar day** (simulator)

`probe/ProbeApp-sun-date-sweep-hourly.mc`, log `probe/sim-sun-date-sweep-hourly.log`. Simulator clock UTC+3. Asking every hour from 26th 18:00Z to 27th 02:00Z, for Hawaii, Sydney, London, returned pair **flips at 26th 21:00Z (= 00:00 on watch's clock), not 00:00Z**:

| Place | Asked (UTC) | Sunrise returned (UTC) | Sunset returned (UTC) |
|---|---|---|---|
| Sydney | 26th 18:00 to 20:00 | 26th 19:40 | 26th 07:53 |
| Sydney | 26th 21:00 to 27th 02:00 | 27th 19:38 | 27th 07:54 |
| London | 26th 20:00 / 21:00 | 26th 05:50 / **27th 05:52** | 26th 17:53 / **27th 17:51** |
| Hawaii | 26th 20:00 / 21:00 | 26th 16:20 / **27th 16:20** | 26th 04:26 / **27th 04:25** |

(Events returned fall on watch's local day: person at own location gets matching sunrise and sunset; for place in very different time zone, "sunset" on watch's day can be previous local evening of that place. Property of asking about far-away place, not bug.)

**Correction of earlier reading (2026-09-26, same session).** First sweep in 6-hour steps spanned both local and UTC midnight, read as "UTC date". Hourly sweep shows local-day rule. **Rival bugs ("shows UTC", "off by an hour in Hawaii", "randomly switches") therefore not explained by this API**; quotes describe formatting and DST mistakes in rivals' own code (converting to UTC, assuming DST), which review cannot tell apart from API. Still simulator only: on watch same rule would mean API usable; on-watch probe logs it (`A` line across local midnight).

**Consequence for design:** `Weather.getSunrise` *valid* source (needs location, only appears with Positioning at runtime in simulator). **Complications remain first choice**: Garmin's own numbers, local seconds, no location; API is fallback for tier B, and cross-check.

## 4. Polar cases (simulator)

Tromsø (69.65 N, 18.96 E): `getSunrise` and `getSunset` both return **null** on 2026-12-21 (polar night) and 2026-06-21 (midnight sun). Nulls also on transition days, when only one of two events exists. Face must have state for "sun does not set/rise today", not blank field.

## 5. Own solar calculation vs the API vs an independent reference

Independent reference: **US Naval Observatory** rise/set/twilight service (`aa.usno.navy.mil/api/rstt/oneday`, free, returns events for **local** calendar day of given UTC offset). `reference_sun_times.tsv` holds 27 place/date cases: UTC+4 (Dubai), Hawaii (UTC−10, no DST), Kathmandu (UTC+5:45), Sydney AEST and AEDT, London and New York on/around DST changes, Reykjavik and Tromsø at solstices, Tromsø on days sun returns and midnight sun starts, Ushuaia, Singapore. `probe/sun_reference_check.py` fetches them and runs calculation below.

**NOAA sunrise equation** (zenith 90.833°, equation of time, declination), evaluated at **local noon** of local date, in Python (prototype for Monkey C version):

- Sunrise, sunset, solar noon: within **1 minute** of USNO on every non-polar case, apart from rounding (2 minutes at Tromsø on equinox).
- Civil twilight (zenith 96°): within 1 minute, 2 at Tromsø on equinox.
- **Edge cases calculation must handle**: sunset after local midnight (Reykjavik 21 June: USNO set 00:04); polar-circle transition days (Tromsø 18 May: USNO lists set 00:28 and rise 00:53 on day calculation, taking one noon declination, calls "no set"); two days a year sun returns or leaves. Accept ±1 day at transitions and say so in test.

**Simulator `Weather.getSunrise/getSunset`** (London, 27 September, UTC): USNO 05:55 / 17:47; API 05:52 / 17:51. API day **7 minutes longer** than USNO here (rise 3 early, set 4 late), 0 to 8 minutes over other places. Which zenith Garmin uses undocumented; simulator may not match real firmware.

Reviewers compare face against native Sunrise/Sunset glance (HandsFive: "Today by Garmin: Sunrise 5:36, sunset 20:52; Today by HandsFive: ..."). So **Garmin's own numbers are what face shows for sunrise and sunset** (via Complications); calculation only for what Garmin does not give (tomorrow, dawn, dusk, golden hour, solar noon, sun height) and, later, for watches without Complications. Tomorrow's sunrise = calculated tomorrow + (Garmin today − calculated today): one line, keeps two sources consistent.

## 6. Body Battery data

- Forum (Connect IQ developer, "Display Body Battery"): fetch with `{:period => 1}` for one sample; "I've seen 127 on a device if it wasn't being worn"; reject values outside 0 to 100; check null; cache `has` check.
- Forum bug reports: `getOldestSampleTime()` / `getNewestSampleTime()` "do not relate to the times of returned samples"; do not use them, use each sample's `when`.
- Practical app (body_battery_alert, GitHub) polls every 300 seconds.
- Complication gives **current** value only; history needs `SensorHistory`.

## 7. Devices

145 products in SDK 9.2.0 can run watch face. By `deviceGroup` API level (from `Devices/*/compiler.json`):

| Tier | Products | Display | Has Complications | Notes |
|---|---|---|---|---|
| A: API ≥ 4.2 | 72 | 51 AMOLED, 21 MIP | yes | includes 3 rectangular (Venu Sq 2, Sq 2 Music, Venu X1) and 3 Instinct (64 KB; Days To Go excluded Instinct) |
| B: 3.4 to 4.1 | 23 | MIP | no | fēnix 6 family, FR55, FR945 LTE, MARQ Gen 1, Enduro, Descent Mk2, Instinct 2 |
| C: 3.3 | 16 | 13 MIP, 1 AMOLED (Venu), 2 LCD (Venu Sq, Sq Music) | no | FR245, FR745, FR945, vívoactive 4, Venu, fēnix 5 Plus family (**no Body Battery** in SDK list), Venu Sq/Sq Music |
| D: < 3.3 | 34 | | no | no `Weather.getSunrise`, no Body Battery history |

SDK supported-devices lists for `getBodyBatteryHistory`, `Weather.getSunrise`, `Complications` (matched by name for 120 Days To Go products) show 62 with all three, 28 with first two only (API 3.3 to 4.1: fēnix 6, FR245/945, MARQ Gen 1, vívoactive 4), 4 with sun only (fēnix 5 Plus family), 26 with none. **The 26 include fēnix 9 family, FR70, FR170 (API 6.0): docs lag; not evidence those watches lack API.** Decide by API level and `has` guards, as Days To Go did for settings.
Paid apps sold only on CIQ 3.4+ products (SDK `Monetization/App_Sales`); Tier C and D never get paid face.
Watch-face memory limit 64 KB on three Instinct products in tier A and some tier B products (Instinct 2 family), 96 KB or more elsewhere (Days To Go's smallest, excluding Instinct, was 96 KB).

## 8. Facts about the platform that shape the face

- Watch faces cannot start GPS (forum: "CIQ Watch faces themselves cannot start up GPS. However, widgets can"); face reads **cached** location; community advice for blank sun times: "start any activity, wait for GPS, discard it".
- Renders: `onUpdate` once a minute in low-power mode; always-on rules (10% lit pixels, pixel on for at most three updates) from Days To Go ADR-007 (always-on rules).
- **App trials not supported for watch faces** (SDK `Core_Topics/Trial_Apps`): rivals' "- with trial" listings are separate free twins, not Garmin feature.
- Connect IQ App Review Guidelines: "seek permission from users prior to collecting location data or data that may be considered sensitive"; medical-claim app needs regulatory documentation, "otherwise you must update the app's description ... to ensure it does not indicate any use for the diagnosis, cure, mitigation, treatment or prevention of disease". Body Battery is wellness estimate: describe what face shows, never what it means for health.