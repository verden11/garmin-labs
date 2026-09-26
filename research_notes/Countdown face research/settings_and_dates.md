# Settings and dates

## 1. The `date` setting type is unreliable in Garmin Connect (why rivals broke)

- SDK `docs/Core_Topics/Properties_and_App_Settings.html`: `settingConfig type` may be `list, boolean, numeric, alphaNumeric, phone, email, url, date or password`;
  a `date` setting maps to a `number` property; "times are stored in UTC and `Gregorian.utcInfo()` should be used in place of `Gregorian.info()`". Simulator test tool: File > Edit Persistent Storage > Edit Application.Properties data.
- Countdown!'s developer (forum showcase thread `forums.garmin.com/developer/connect-iq/f/showcase/2204/watchface-countdown/17073`, no posts from 2023–2026 visible):
  **iOS**: "the Event Date picker most of the times displays an empty value, or sometimes 1 Jan 1970", so the date must be re-picked every time settings open, even to change only a colour;
  **Android**: the picker "may display an old value, like 17 Jan 1970"; a valid date must be between now and **18 Jan 2038**; Garmin Express (v4.1.11.0+) is the recommended way. He blamed Garmin Connect Mobile.
- Forum thread "Date picker in settings issue (UTC?) or my mistake?" (`.../discussion/215934`): what the picker stores was never confirmed by Garmin staff; a poster with a non-UTC offset saw
  errors "matching their UTC offset" in the simulator but not on a device; another poster: the date type "has been odd since the day it was introduced".
- A bug report titled "DateTime app settings date picker in GCM iOS does not set the correct time" exists on the forum (`forums.garmin.com/forum/developers/connect-iq/connect-iq-bug-reports/154442-…`); **the page could not be fetched, so only its title is known**.
- General settings-not-saving threads (Connect IQ mobile apps on iOS and Android; workaround "change the settings via Garmin Express"; iOS thread 407851 "CIQ watch face settings can not be saved", locked, about 2023): the failure is
  in the phone app, silent, and outside the developer's control.
- Numeric settings also failed for a rival (time2race "between 0 and 0", see `rival_reviews.md`); a developer thread reports an array setting not saved by the Android app.

**Decision:** never use `type="date"`; never rely on `numeric` min/max. Use **`list`** settings for month, day, year and hour (a list has nothing to validate),
`alphaNumeric maxLength=16` for the name, and give the wearer a second way to set the date **on the watch** (section 3). The face must also tolerate settings that never arrive: it ships with a working default event.

## 2. Beta Apps: test settings before release (SDK `docs/Core_Topics/Beta_Apps.html`)

"Connect IQ beta apps allows developers to test app settings and Garmin Connect integration in production without releasing the app." Create an **alternate app id** (a new UUID) in the manifest,
upload with the "Beta App" checkbox, download it to the watch from "uploaded apps", then edit settings in Garmin Connect and Garmin Express. Update the beta as often as needed; to release, put the
production id back and upload without the checkbox. "The app will have a separate store identifier from your final app, and URLs to the beta will not be visible outside of your account."

This removes the constraint recorded in memory (a sideloaded watch face shows no settings UI at all): the phone round-trip **can** be tested before the store release, on the FR965, with a beta build.

## 3. Settings on the watch (`AppBase.getSettingsView`)

- SDK `Toybox/Application/AppBase.html`: `getSettingsView()` since API 2.3.0, "only applicable to watch faces and data fields", with a device list. Matching that list against HeroFace's **117** products by display name: **94 listed, 23 not**. The 9 unlisted among the 84 round products at CIQ 3.4+ are the newest (fēnix 9 family, FR70, FR170, FR170 Music), probably doc lag; the other 14 are older CIQ 3.x products (D2 Charlie, Delta, Delta PX, Delta S, Descent Mk1, vívoactive 3 / 3 Music / 3 Music LTE / 3 Mercedes-Benz, FR645, FR645 Music, FR935, fēnix Chronos, Approach S62), where the route is probably really absent. Verify on hardware before claiming it for any of them.
- Forum (`.../discussion/406806`, about 2022–23): for watch faces the user holds UP and chooses **Customize**; in the simulator use Settings > Trigger App Settings. A face with only phone settings shows just "Apply".
- Forum answers say on-device settings work on CIQ 3.0+ for watch faces; on fēnix 8 and newer the native editor (`WatchFaceConfig`, API 5.1) offers styles, complications and colours only, **not a date**, so a Picker inside `getSettingsView` is the way.
- SDK `WatchUi.Picker` (API 1.2.0), `PickerFactory`, `PickerDelegate`; `Menu2` (3.0). A three-column Picker (month, day, year) compiles under strict type checking for fr965, fenix7, fenix6pro, fr255s and venu2s (`DaysToGo/docs/reference/source/settings/`). **Not yet run on a device or in the simulator's settings trigger.**
- Not documented anywhere found: whether a value the watch writes with `Properties.setValue` shows up in Garmin Connect, or is overwritten by the phone's stale copy on the next phone save. **Must be observed in the beta test** (plan phase 3).

## 4. Time and date semantics

- SDK `Toybox/Time/Gregorian.html`: `info(moment, format)` = **local** time, `utcInfo` = UTC, `moment(options)` builds a Moment; a forum search result reports a bug where the time-zone offset used by `moment()` comes from the current date rather than the date passed (an hour off across DST).
- Consequence: **no Moment arithmetic.** Read local y/m/d and seconds-of-day once with `Gregorian.info(Time.now(), Time.FORMAT_SHORT)`, and count whole calendar days with integer arithmetic (`dayNumber`, days since 1970-01-01). DST and travel then cannot change the count; it flips at local midnight.
- Verified: `DaysToGo/docs/reference/` compiles under `--typecheck 3` for fr965 and passes **15 of 15** unit tests in the SDK 9.2.0 simulator on 2026-09-26 (fr965 AMOLED, fenix6pro MIP, venu2s), including every day of 1970–2100 advancing by exactly 1, leap days, year and month boundaries, every day of 2026 against a day-by-day walk to 2028-03-01, and each rival bug above.
- Two tests failed first and each found a real bug: a specific 29 Feb 2027 was clamped to 28 Feb instead of being reported invalid, and an every-year 31 April was silently counted to 1 May (found by review, then covered by a test that fails without the fix). That is why the tests exist.
- Limit: a timed event's last-24-hours display uses wall-clock seconds, so on a DST-change day it can be an hour off. Documented, not fixed.

## 5. Storage crash class

Forum reporting (Garmin Rumors, 2 Dec 2024, "many Garmin watches crashing with ConnectIQ watch faces"; `Storage.setValue` bug, Garmin investigating; resolution not verified). The face uses `Application.Properties` only and never `Application.Storage`.
