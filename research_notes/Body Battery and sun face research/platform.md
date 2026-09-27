# Platform findings: Body Battery, sun times, location

Snapshot 2026-09-26, SDK 9.2.0, simulator only unless stated. Logs and probe sources are in `probe/`. **Nothing here has run on a wrist.**

## 1. Which calls need which permission

**Compiler** (`monkeyc -w --typecheck 3` on a throwaway watch face, `probe/ProbeApp-permission-and-sources.mc`, built with **no** permissions):

| Call | Compiler says | Needs |
|---|---|---|
| `Position.getInfo()` | error "Permission 'Positioning' required" | **Positioning** |
| `Activity.getActivityInfo().currentLocation` | no error | nothing |
| `Weather.getCurrentConditions()`, `.observationLocationPosition` | no error | nothing (**see runtime, below**) |
| `Weather.getSunrise(loc, moment)`, `getSunset(...)` | no error | nothing |
| `new Position.Location({:latitude, :longitude, :format})` | no error | nothing |
| `Complications.*` | error | **ComplicationSubscriber** (or Publisher) |
| `SensorHistory.getBodyBatteryHistory`, `SensorHistoryIterator.next`, `SensorSample.data/when` | error | **SensorHistory** |

**Runtime, simulator (fr965). The compiler does not tell the whole story:**

- With no permission, the first `Position.getInfo()` call ends the app with `Error: Permission Required`; it is **not** catchable with `try/catch`. Every permissioned call must sit behind a manifest that declares the permission.
- **`Weather.getCurrentConditions().observationLocationPosition` was non-null only when Positioning was declared.** Same source, same run order, alternating with and without Positioning: **3 of 3 with, 0 of 3 without** (`probe/sim-weather-location-vs-positioning.log`; earlier runs agree: 4 of 4 with, 0 of 2 without). `getCurrentConditions()` itself is non-null in both, with a temperature and an observation time; only the location is withheld. Without a location, `Weather.getSunrise` has nothing to be called with. **My first reading of this ("flaky") was wrong: it tracks the permission exactly.**
- **Consequence:** without Positioning, a face may have **no location source at all in the simulator** (`Activity.currentLocation` is null here for lack of an activity, so its permission behaviour is untested). Whether a *real watch* behaves the same, and whether `Activity.currentLocation` also needs the permission at runtime, is what the two on-watch probes answer (`LocationProbe-P.prg` with Positioning, `LocationProbe-N.prg` without).

Docs: `Position.getInfo()` "Using this API requires enabling the Positioning Permission" (SDK `Toybox/Position.html`).

## 2. Simulator runtime results (fr965, API 5.2)

| Source | Simulator value | Meaning |
|---|---|---|
| `Position.getInfo().position` (with Positioning) | `null`, accuracy 0 | No fix in the simulator; says nothing about a watch |
| `Activity.getActivityInfo().currentLocation` | `null` (with and without Positioning) | No activity in the simulator |
| `Weather...observationLocationPosition` | `38.86,-94.80` **with** Positioning, `null` without | Canned simulator weather location; see §1 |
| `Complications` SUNRISE (13) / SUNSET (14) / BODY_BATTERY (23) | `54535` / `11599` / varies | Seconds since local midnight, and **sunset 03:13 is earlier than sunrise 15:08** (canned; see the rule in `spec.md`); no permission other than ComplicationSubscriber |
| `SensorHistory.getBodyBatteryHistory({:period => Duration(24h)})` | 480 samples, 60 s apart, **`oldest-first`, and 478 of them dated in the future** (newest sample 26/16:32, last 27/00:31) | Simulator data is synthetic and runs forward in time; do not read its cadence or order as the watch's. The probe prints `n`, the smallest gap (absolute), the order and the future count so the watch's own values are unambiguous |

SDK facts (docs): `Complications` since API 4.2.0: `COMPLICATION_TYPE_SUNRISE` = "non-negative Number representing **seconds since midnight local time** of the sunrise or null"; `SUNSET` likewise; `BODY_BATTERY` = "Number representing your current body battery or null"; `STRESS`, `SLEEP_SCORE` (6.0.2), `SOLAR_INPUT` also exist. `SensorHistory.getBodyBatteryHistory` since 3.3.0; options `:period` (Number = last N entries, or Duration), `:order`; "the time between each SensorSample in the iterator may be device dependent." `Weather` since 3.2.0; `getSunrise/getSunset` since 3.3.0, take a `Position.Location` and a `Time.Moment`, return `Moment or Null`. There is **no** dawn, dusk, twilight or golden-hour call.

## 3. `Weather.getSunrise/getSunset` return the events of the **watch's local calendar day** (simulator)

`probe/ProbeApp-sun-date-sweep-hourly.mc`, log `probe/sim-sun-date-sweep-hourly.log`. The simulator's clock is UTC+3. Asking for every hour from 26th 18:00Z to 27th 02:00Z, for Hawaii, Sydney and London, the returned pair **flips at 26th 21:00Z (= 00:00 on the watch's clock), not at 00:00Z**:

| Place | Asked (UTC) | Sunrise returned (UTC) | Sunset returned (UTC) |
|---|---|---|---|
| Sydney | 26th 18:00 to 20:00 | 26th 19:40 | 26th 07:53 |
| Sydney | 26th 21:00 to 27th 02:00 | 27th 19:38 | 27th 07:54 |
| London | 26th 20:00 / 21:00 | 26th 05:50 / **27th 05:52** | 26th 17:53 / **27th 17:51** |
| Hawaii | 26th 20:00 / 21:00 | 26th 16:20 / **27th 16:20** | 26th 04:26 / **27th 04:25** |

(The events returned are those that fall on the watch's local day: a person at their own location gets a matching sunrise and sunset; for a place in a very different time zone, the "sunset" on the watch's day can be the previous local evening of that place. That is a property of asking about a far-away place, not a bug.)

**Correction of an earlier reading (2026-09-26, same session).** A first sweep in 6-hour steps spanned both the local and the UTC midnight and was read as "UTC date". The hourly sweep shows the local-day rule. **The rival bugs ("shows UTC", "off by an hour in Hawaii", "randomly switches") are therefore not explained by this API**; the quotes describe formatting and DST mistakes in the rivals' own code (converting to UTC, assuming DST), which a review cannot tell apart from the API. Still simulator only: on a watch the same rule would mean the API is usable; the on-watch probe logs it (`A` line across local midnight).

**Consequence for the design:** `Weather.getSunrise` is a *valid* source (it needs a location, and only appears with Positioning at runtime in the simulator). **Complications remain first choice** because they are Garmin's own numbers, in local seconds, with no location; the API is the fallback for tier B, and a cross-check.

## 4. Polar cases (simulator)

Tromsø (69.65 N, 18.96 E): `getSunrise` and `getSunset` both return **null** on 2026-12-21 (polar night) and 2026-06-21 (midnight sun). Nulls also occur on transition days, when only one of the two events exists. A face must have a state for "sun does not set/rise today", not a blank field.

## 5. Own solar calculation vs the API vs an independent reference

Independent reference: the **US Naval Observatory** rise/set/twilight service (`aa.usno.navy.mil/api/rstt/oneday`, free, returns events for the **local** calendar day of a given UTC offset). `reference_sun_times.tsv` holds 27 place and date cases: UTC+4 (Dubai), Hawaii (UTC−10, no DST), Kathmandu (UTC+5:45), Sydney AEST and AEDT, London and New York on and around DST changes, Reykjavik and Tromsø at the solstices, Tromsø on the days the sun returns and the midnight sun starts, Ushuaia, Singapore. `probe/sun_reference_check.py` fetches them and runs the calculation below.

**NOAA sunrise equation** (zenith 90.833°, equation of time, declination), evaluated at the **local noon** of the local date, in Python (the prototype for the Monkey C version):

- Sunrise, sunset, solar noon: within **1 minute** of USNO on every non-polar case, apart from rounding (2 minutes at Tromsø on the equinox).
- Civil twilight (zenith 96°): within 1 minute, 2 at Tromsø on the equinox.
- **Edge cases the calculation must handle**: sunset after local midnight (Reykjavik 21 June: USNO set 00:04); the polar-circle transition days (Tromsø 18 May: USNO lists a set at 00:28 and a rise at 00:53 on a day the calculation, taking one noon declination, calls "no set"); the two days a year the sun returns or leaves. Accept ±1 day at the transitions and say so in a test.

**Simulator `Weather.getSunrise/getSunset`** (London, 27 September, UTC): USNO 05:55 / 17:47; API 05:52 / 17:51. The API's day is **7 minutes longer** than USNO's here (rise 3 early, set 4 late), 0 to 8 minutes over the other places. Which zenith Garmin uses is undocumented and the simulator may not match real firmware.

Reviewers compare a face against the native Sunrise/Sunset glance (HandsFive: "Today by Garmin: Sunrise 5:36, sunset 20:52; Today by HandsFive: ..."). So **Garmin's own numbers are what the face shows for sunrise and sunset** (via Complications), and the calculation is only for what Garmin does not give (tomorrow, dawn, dusk, golden hour, solar noon, sun height) and, later, for watches without Complications. Tomorrow's sunrise = calculated tomorrow + (Garmin today − calculated today): one line, and it keeps the two sources consistent.

## 6. Body Battery data

- Forum (Connect IQ developer, "Display Body Battery"): fetch with `{:period => 1}` for one sample; "I've seen 127 on a device if it wasn't being worn"; reject values outside 0 to 100; check null; cache the `has` check.
- Forum bug reports: `getOldestSampleTime()` / `getNewestSampleTime()` "do not relate to the times of returned samples"; do not use them, use each sample's `when`.
- A practical app (body_battery_alert, GitHub) polls every 300 seconds.
- The complication gives the **current** value only; history needs `SensorHistory`.

## 7. Devices

145 products in SDK 9.2.0 can run a watch face. By `deviceGroup` API level (from `Devices/*/compiler.json`):

| Tier | Products | Display | Has Complications | Notes |
|---|---|---|---|---|
| A: API ≥ 4.2 | 72 | 51 AMOLED, 21 MIP | yes | includes 3 rectangular (Venu Sq 2, Sq 2 Music, Venu X1) and 3 Instinct (64 KB; Days To Go excluded Instinct) |
| B: 3.4 to 4.1 | 23 | MIP | no | fēnix 6 family, FR55, FR945 LTE, MARQ Gen 1, Enduro, Descent Mk2, Instinct 2 |
| C: 3.3 | 16 | 13 MIP, 1 AMOLED (Venu), 2 LCD (Venu Sq, Sq Music) | no | FR245, FR745, FR945, vívoactive 4, Venu, fēnix 5 Plus family (**no Body Battery** in the SDK list), Venu Sq/Sq Music |
| D: < 3.3 | 34 | | no | no `Weather.getSunrise`, no Body Battery history |

The SDK's supported-devices lists for `getBodyBatteryHistory`, `Weather.getSunrise` and `Complications` (matched by name for the 120 Days To Go products) show 62 with all three, 28 with the first two only (API 3.3 to 4.1: fēnix 6, FR245/945, MARQ Gen 1, vívoactive 4), 4 with sun only (fēnix 5 Plus family), and 26 with none. **The 26 include the fēnix 9 family, FR70 and FR170 (API 6.0): the docs lag; they are not evidence those watches lack the API.** Decide by API level and `has` guards, as Days To Go did for settings.
Paid apps are sold only on CIQ 3.4+ products (SDK `Monetization/App_Sales`); Tier C and D never get a paid face.
The watch-face memory limit is 64 KB on the three Instinct products in tier A and on some tier B products (Instinct 2 family), 96 KB or more elsewhere (Days To Go's smallest, excluding Instinct, was 96 KB).

## 8. Facts about the platform that shape the face

- Watch faces cannot start GPS (forum: "CIQ Watch faces themselves cannot start up GPS. However, widgets can"); a face reads a **cached** location, and the community advice for blank sun times is "start any activity, wait for GPS, discard it".
- Renders: `onUpdate` once a minute in low-power mode; always-on rules (10% lit pixels, a pixel on for at most three updates) come from Days To Go ADR-007.
- **App trials are not supported for watch faces** (SDK `Core_Topics/Trial_Apps`): rivals' "- with trial" listings are separate free twins, not a Garmin feature.
- Connect IQ App Review Guidelines: "seek permission from users prior to collecting location data or data that may be considered sensitive"; a medical-claim app needs regulatory documentation, "otherwise you must update the app's description ... to ensure it does not indicate any use for the diagnosis, cure, mitigation, treatment or prevention of disease". Body Battery is a wellness estimate: describe what the face shows, never what it means for health.
