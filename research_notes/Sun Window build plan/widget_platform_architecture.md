# Sun Window: Connect IQ widget platform architecture (app type, glance, full view, settings, Position, Weather, devices, solar maths, tests)

Research date 2026-10-04. SDK 9.2.0 (`connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2`, "System 9, API 9.2.0"), the only SDK installed. Builds on `research_notes/Vitamin D window/platform_and_permissions.md` (cited below as **[VDW platform]**) and does not repeat its weather, background and permission findings.

**Evidence grades used in every bullet:**
- **[SDK doc]** Garmin docs read from the local SDK 9.2.0 copy (`…/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/`). Public URL given is the same page on developer.garmin.com; the core-topic pages there are JS-rendered, so the `file://` copy is the one read.
- **[SDK data]** machine files shipped with the SDK or device packs: `bin/projectInfo.xml`, `bin/api.mir`, `Devices/<id>/compiler.json`, `Devices/<id>/simulator.json`.
- **[Compile probe]** a throwaway project built today in the scratchpad (not in the repo): manifest `type="widget"`, `minApiLevel="5.1.0"`, `Positioning`, a `(:glance)` `AppBase` + `GlanceView` that calls `Position.getInfo()`, `Weather.getCurrentConditions().uvIndex`, `Storage.getValue`, `Math.sin(0.5d)`; built with `monkeyc -w -l 2` and `-l 3` for `fr965`, `instincte40mm`, `etrextouch`. Compile result only; nothing was run in the simulator or on a watch.
- **[Studio code/doc]** existing code and decisions in this repo (HeroSet, TwoSuns, DayArc).
- **[Forum]** Garmin developer forum, summarised by a fetch tool (paraphrase risk, never treated as verified).
- **Nothing in this file is device proof.** Simulator and compile results are not device proof.

## 1. Widget app type on API 5.1+: is "widget" still distinct, what is the manifest, what does the store see, which type to declare

### Takeaway
On every API 5.1+ watch, "widget" no longer exists as a runtime type: the device data lists no `widget` app type, and the compiler has since SDK 4.0.0 "automatically switch[ed] app type to watch-app when compiling a widget and targeting a 4.x device"; a widget is now a **watch-app with a glance** (Garmin's own sample calls the class `MySuperApp`). Sun Window should declare `type="watch-app"` with `getGlanceView()`: it builds the same binary as `type="widget"` on these watches, matches HeroSet's shipped pattern, and keeps the `watch-app` permission map (the `widget` map is a strict subset).

### Cited Findings
- SDK 4.0.0 compiler change: "Automatically switch app type to watch-app when compiling a widget and targetting a 4.x device." Same release: "Add support for glances in watch-app types." [SDK doc: Release Notes (History)](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Core topic: "On devices with API level 4.0 and below, there is the widget app type … On devices after API 4.0.0, widgets are now from the app launcher, and apps can have glances. The glance list is accessible to the user while they are in an activity … Widgets still build and run for API level 4.0 products without modification. However, you now must create a glance if you want the widget to show in the glance list." The lifecycle example class is named `MySuperApp`. [SDK doc: Application and System Modules](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Application_and_System_Modules.html)
- "In API level 4.0.0 and above, apps and widgets must implement a glance view to appear in the glance list." [SDK doc: Glances](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Glances.html)
- Device data: for 74 of the 75 API 5.1+ device ids (all but `etrextouch`), `compiler.json` `appTypes` lists `background, datafield, glance, watchApp, watchFace` (plus `audioContentProvider` on music models) and **no `widget`**. Only `etrextouch` (handheld, 5.1.1) lists `widget` (and no `glance`). [SDK data: Devices/fr965/compiler.json](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/fr965/compiler.json); same for every other 5.1+ id (script over `Devices/*/compiler.json`).
- Compile probe: a `type="widget"` manifest built clean for `fr965` and `instincte40mm`; for `etrextouch` the compiler said "Glance applications are not supported for app type **'watch-app'** on device 'etrextouch' with minimum API Level 5.1.1. The (:glance) annotation will be ignored", i.e. the compiler treats the widget manifest as `watch-app` even there. [Compile probe]
- Permission maps: `widget` allows Ant, Background, BluetoothLowEnergy, Communications, PersistedContent, Positioning, PushNotification, Sensor, SensorHistory, UserProfile; `watch-app` allows all of those plus ComplicationPublisher, Fit, FitContributor, Notifications, PersistedLocations, SensorLogging. `projectInfo.xml` still lists five app types (`watchface`, `datafield`, `widget`, `watch-app`, `audio-content-provider-app`). [SDK data: projectInfo.xml](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/bin/projectInfo.xml)
- Forum bug report CIQQA-3061 (2025-03-22, acknowledged, no staff reply in fetched text): "When building an app with 'widget' in the manifest, the output type is actually 'watch-app' (device app)" on CIQ 4 devices; the glance appears only if `getGlanceView` is explicitly overridden. [Forum: CIQQA-3061](https://forums.garmin.com/developer/connect-iq/i/bug-reports/when-app-type-is-widget-in-manifest-xml-and-getglanceview-is-not-overridden-compiler-should-automatically-provide-default-glance-view-for-ciq-4-devices-for-max-portability)
- Forum (community, not staff, about 2026-01): selecting a glance loads the full app and shows `getInitialView`; eTrex Touch and GPSMAP H1 are CIQ 4+ but list widget and watchApp without glance. [Forum: glance without widget](https://forums.garmin.com/developer/connect-iq/f/discussion/427253/glance-without-widget)
- Store listing type: a search-engine summary says widget-type apps show as "Device App" in the store on CIQ 4+ devices; I could not open a primary page that says so. [Forum search result: Super apps and widgets in CIQ 4.0](https://forums.garmin.com/developer/connect-iq/f/discussion/245387/super-apps-and-widgets-in-ciq-4-0) (snippet-grade)
- Studio precedent: HeroSet is `type="watch-app"` with a `(:glance)` `HeroSetApp`, `getGlanceView()`, and `(:typecheck(disableGlanceCheck))` on `getInitialView`; its research rejected a separate widget app partly because "on CIQ 4+ a manifest `widget` is built as a watch-app anyway". [Studio code: HeroSet/manifest.xml](file:///Users/mbp/dev/garmin/HeroSet/manifest.xml); [Studio doc: HeroSet glance view research](file:///Users/mbp/dev/garmin/reports/HeroSet%20glance%20view%20research.md)

### Inferences
- **Declare `type="watch-app"`, `minApiLevel="5.1.0"`, permission `Positioning` only**, entry `SunWindowApp` with `getInitialView()` and `getGlanceView()`. Declaring `widget` gains nothing on these watches and would confuse the docs; `watch-app` is what the binary is.
- User-facing name for the feature is "glance" (Garmin's current term); the product can still be called a widget in studio docs, but the store/upload form will most likely treat it as a device app (snippet-grade; confirm on the upload form, which is the final word on type and devices).
- Exclude `etrextouch` (no glance, handheld) and, by owner scope, the 8 Edge units; they are not watches.
- The app-type field of a published app is hard to change later (a forum thread exists on exactly that: [Forum: change the app type of a released app](https://forums.garmin.com/developer/connect-iq/f/discussion/351754/is-it-possible-to-change-the-app-type-of-a-released-app)), so pick `watch-app` before the first upload.

### Gaps
- No Garmin primary text on how the store/upload form labels a `watch-app` with a glance (category "Device App" vs "Widget"). Check on the upload form.
- Whether a `watch-app` with a glance is reachable from the app launcher *and* the glance list on every 5.1+ watch is documented in prose only; not device-checked for this studio beyond HeroSet's plan.

## 2. Glance: API, annotation, memory per device, allowed modules, refresh, theme

### Takeaway
`AppBase.getGlanceView()` returns `[GlanceView]` or `[GlanceView, GlanceViewDelegate]`; code that runs in the glance must be `(:glance)` and the whole `AppBase` class is loaded into the glance process. Glance memory is 64 KB on 71 of the 74 API 5.1+ ids with a glance, 32 KB on the three 1-bit Instinct ids. The compiler's scope model closes no needed module to the glance: the probe called `Position.getInfo()`, `Weather`, `Storage` and `Math` from glance code with zero scope warnings at `-l 3`. `getGlanceTheme()` (API 4.0) sets a system tint from eight fixed constants.

### Cited Findings
- `getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView , WatchUi.GlanceViewDelegate ] or Null` — "Override to provide the WatchUi.GlanceView and WatchUi.GlanceViewDelegate for the glance preview." [SDK doc: AppBase](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html)
- `GlanceView` (API 3.1.0) "behaves mostly like a regular WatchUi.View … however, the dc object passed … will be bounded by glance area rather than a full screen dc"; no Layers; "prohibited from using page control functionality, as there is only one view allowed". `GlanceViewDelegate.onGlanceEvent` exists but fires "when certain glance event occurs, none for now". [SDK doc: GlanceView](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/GlanceView.html); [SDK doc: GlanceViewDelegate](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/GlanceViewDelegate.html)
- `getGlanceTheme() as AppBase.GlanceTheme` with `GLANCE_THEME_DEFAULT 0, _BLUE 1, _GOLD 2, _GREEN 3, _LIGHT_BLUE 4, _RED 5, _WHITE 6, _PURPLE 7`, all API 4.0. The doc gives no further description of what the theme changes. [SDK doc: AppBase](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html)
- Glance mode: "it will be started in Glance mode with limited memory allocated (32KB for most devices)"; "use the :glance annotation to indicate which modules and / or classes are necessary"; "There is no guarantee that a widget will always start in glance mode". Two update models: **live** ("devices that have ample resources" — footnote: music-capable) where `WatchUi.requestUpdate()` works and the update rate "should be kept under 1HZ"; **background UI update** ("devices that have less memory", footnote: non-music) where `requestUpdate()` has no effect, the app runs a full lifecycle (`onStart`, `getGlanceView`, `onLayout`, `onShow`, `onUpdate`, `onHide`, `onStop`) when visible "and at least 30 seconds since last update", and the drawn result is cached. "Most functionality supported in Widget is still supported when running as a Glance, such as accessing application storage and making web requests … moving CPU intensive work to a Background service." [SDK doc: Glances](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Glances.html)
- SDK 7.2.0: "Call AppBase.onStop() for glances that do not support live updates." SDK 8.2.0: "Fix widget app types not launching in glance mode" (subsection not checked; likely simulator). [SDK doc: Release Notes](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Memory (device data beats the "32KB" prose): `compiler.json` glance limit 65,536 bytes on every API 5.1+ watch id except `instincte40mm`, `instincte45mm`, `instinct3solar45mm` (32,768; watch-app limit 131,072 on those three, 786,432 on most others, 524,288 on `fr255`/`fr255s`). [SDK data: Devices/*/compiler.json, e.g. instincte40mm](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/instincte40mm/compiler.json); [VDW platform §6]
- Live updates: `simulator.json` `liveUpdates: true` for all 66 watch ids at API 5.1+ (so all use the live model, despite the "music" footnote). [VDW platform §6](file:///Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake/research_notes/Vitamin%20D%20window/platform_and_permissions.md)
- Scope model: `api.mir` has flags `disableBackground`, `disableWidget`, `disableWatchApp`, `disableWatchFace`, `disableDataField`, `disableAudioContentProvider`, but **no glance flag at all**; `Position`, `Weather`, `Application.Storage`, `Application.Properties`, `Math`, `Time`, `Timer` carry no `disableWidget`/`disableWatchApp` flag. `Timer` and `Menu2` pages list "Glance" among their runtime contexts. [SDK data: api.mir](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/bin/api.mir); [SDK doc: Toybox.Timer](https://developer.garmin.com/connect-iq/api-docs/Toybox/Timer.html)
- Compile probe: glance code calling `Position.getInfo()`, `Weather.getCurrentConditions()`, `Storage.getValue`, `Math.sin(0.5d)` and `Graphics.FONT_GLANCE` produced no scope message at `-l 3`. The only scope messages were "Value 'ProbeView' not available in all function scopes" on `getInitialView()` inside the `(:glance)` AppBase: a **warning at `-l 2`, an error at `-l 3`, silent at `-l 0`** (`BUILD SUCCESSFUL`, no message). [Compile probe]; HeroSet found it silent at the default level and `-l 1` too ([Studio doc: HeroSet glance view research](file:///Users/mbp/dev/garmin/reports/HeroSet%20glance%20view%20research.md)).
- HeroSet's fix for the same message is `(:typecheck(disableGlanceCheck))` on `getInitialView`, empty `onStart`, lazy construction of foreground objects, and `tools/glance-scope-check.sh` (builds at `-l 3`, fails on "not available in all function scopes"). [Studio code: HeroSet/source/app/HeroSetApp.mc](file:///Users/mbp/dev/garmin/HeroSet/source/app/HeroSetApp.mc); [Studio code: HeroSet/tools/glance-scope-check.sh](file:///Users/mbp/dev/garmin/HeroSet/tools/glance-scope-check.sh)
- String resources used by the glance need `scope="glance"`; the compiler warns when a glance-scoped resource targets a device without glances. [Compile probe]; [Studio doc: HeroSet glance view research](file:///Users/mbp/dev/garmin/reports/HeroSet%20glance%20view%20research.md)
- Glance fonts: `Graphics.FONT_GLANCE` (18) and `FONT_GLANCE_NUMBER` (19) exist in the API model. [SDK data: api.mir](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/bin/api.mir)

### Inferences
- Glance architecture: `(:glance)` on `SunWindowApp`, `SunWindowGlanceView`, the solar maths class, the state class, the stored-location reader and `SunWindowConfig`/`SunWindowPalette`; the full view, delegate, menu and location fetcher stay un-annotated. Reuse HeroSet's `glance-scope-check.sh` pattern as a build gate.
- Because the scope model allows `Position`/`Weather` in the glance, D6 ("may a glance call Position?") is a **runtime** question only (does it return a fix, does it cost time), not a compile question. Recommended default regardless: the glance reads the stored location only and never calls `Position`, which keeps it cheap and makes the "open once" state honest.
- The glance can compute the state itself on every `onUpdate` (sun maths is cheap, see §8), so the spec's "last-known state for the glance" in Storage is only needed as a fallback; computing live avoids the stale-midnight bug class (D7). Under the live model, a `Timer` in the glance calling `requestUpdate()` once a minute is allowed (Timer has the Glance context) but not documented as needed: the system redraws "as needed".
- `getGlanceTheme()` could carry the accent if one of the eight theme colours fits; otherwise draw the accent yourself. Its visual effect per device is undocumented (look at screenshots).
- 32 KB Instinct ids: the probe's glance plus app class built fine; real fit needs the simulator memory view or a sweep, but a text-only glance with Float/Double maths is far from 32 KB (HeroSet's whole glance closure measured about 6.9 KB).

### Gaps
- What `GlanceTheme` actually changes on a watch (bar colour, text colour?) is not documented; screenshot needed.
- Whether a live glance keeps running across midnight without `onShow` being called again (D7) is undocumented.
- No primary source on the glance's real CPU/time budget versus the full app's.

## 3. Full view: View/BehaviorDelegate, onShow/onHide, a one-minute Timer, exit and timeout

### Takeaway
The full view is a normal `WatchUi.View` returned from `getInitialView()` with a `WatchUi.BehaviorDelegate`; refresh with one repeating `Timer.Timer` started in `onShow()` and stopped in `onHide()`, calling `WatchUi.requestUpdate()`. An app launched from the glance list gets a system timeout of undocumented length; launched from the launcher it does not. Back on the base view exits; `System.exit()` is allowed.

### Cited Findings
- `getInitialView()` "The primary method for app startup. Return the base view for your watch face, data field, widget, or device app"; all view getters return `[View]` or `[View, InputDelegate]`. Do not push views in `onStart`. [SDK doc: Application and System Modules](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Application_and_System_Modules.html)
- "If an app is launched from the glance list, a timeout will be applied to the app. If the user does not exit the app within a given time frame, the system will terminate the app and return to the home screen. If an app is launched from the activity menu, however, it will not time out." Detect with `state.get(:launchedFromGlance)` in `onStart`. Lifecycle also has `onActive`/`onInactive` and `onStop(:suspend)` / `onStart(:resume)` (API 4.2.0). [SDK doc: Application and System Modules](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Application_and_System_Modules.html)
- SDK 4.0.6: "Enable System.exit() for widget apps launched from glance mode". [SDK doc: Release Notes](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- `Timer.Timer.start(callback as Method() as Void, time as Number, repeat as Boolean)`, `stop()`. "The number of available timers (default 3) and the minimum time value (default 50 ms) depends on the host system. An error will occur if too many timers are set." "If a repeating Timer fails to run before its next execution time, then any missed executions will be skipped." [SDK doc: Timer.Timer](https://developer.garmin.com/connect-iq/api-docs/Toybox/Timer/Timer.html)
- `BehaviorDelegate`: `onBack`, `onMenu`, `onNextPage`, `onPreviousPage`, `onSelect` (API 1.0.0), mapped per device to buttons or touch. [SDK doc: Input Handling](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Input_Handling.html)
- `Position.getInfo()` doc itself suggests polling "on demand or periodically within a Timer". [SDK doc: Toybox.Position](https://developer.garmin.com/connect-iq/api-docs/Toybox/Position.html)

### Inferences
- One timer, 60,000 ms, repeat, aligned is unnecessary (state changes are minute-grained; an up-to-59-second lag at the window edge is acceptable, or start a one-shot to the next minute boundary, then repeat). Stop it in `onHide` so it never runs behind a pushed menu.
- Full view recomputes state from `Time.now()` in `onUpdate` (render only there, per project convention); the timer only calls `requestUpdate()`.
- Timeout length matters little: Sun Window has no unsaved state. Nothing to persist on `onStop` except the location already in Storage.

### Gaps
- The glance-launch timeout duration is not documented anywhere I found.

## 4. Settings: getSettingsView vs an in-app Menu2, Properties vs Storage

### Takeaway
**The spec's "on-watch `getSettingsView` (Customize)" does not apply to this app type.** Garmin documents `getSettingsView()` as "only applicable to watch faces and data fields"; apps and widgets are expected to build their own on-device settings from their own input (e.g. a `Menu2` pushed from `BehaviorDelegate.onMenu()`). The accent setting should live in `Application.Properties` (so Garmin Connect can edit it for store installs) and be written by the in-app `Menu2` too.

### Cited Findings
- `getSettingsView() as [ WatchUi.Views ] or [ WatchUi.Views , WatchUi.InputDelegates ] or Null` — "Override to provide the settings View and Input Delegate of the application. **This function is only applicable to watch faces and data fields.**" [SDK doc: AppBase](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html)
- "Device applications, widgets, and audio content providers all accept user input that allow them to implement on-device settings in the app. Watch faces and data fields are not allowed to accept input … If you want to provide an on-device settings user interface for your watch face or data field, you can implement AppBase.getSettingsView()." [SDK doc: Properties and App Settings](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Properties_and_App_Settings.html)
- Forum (community): long-pressing the menu button while a watch app or widget runs opens a menu "as long as you have coded a menu and pushed this in the onMenu() function of a delegate"; the simulator's "Trigger App Settings" is greyed out unless the app is a watch face or data field with `getSettingsView`. [Forum: on-watch screen menus](https://forums.garmin.com/developer/connect-iq/f/discussion/348162/documentation-or-example-for-on-watch-screen-menus/1710960); [Forum: Access to Settings/Menu from widget](https://forums.garmin.com/developer/connect-iq/f/discussion/4113/access-to-settings-menu-from-connect-iq-widget)
- `Menu2` (API 3.0.0) runs in Glance, Watch App, Widget (and other) contexts; `onSelect()` is called on the registered delegate. [SDK doc: Menu2](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/Menu2.html)
- `onSettingsChanged()` "Called when the application settings have been changed by Garmin Connect Mobile (GCM) while the app is running." [SDK doc: AppBase](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html)
- Properties vs Storage: `Application.Properties` (API 2.4.0) backs `settings.xml` and is what Garmin Connect edits; `Application.Storage` is app-private key/value; "Background processes cannot save Application Properties" (irrelevant here, no background). Sideloaded builds get no phone settings. [SDK doc: Properties](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/Properties.html); [Studio doc: platform-facts.md, Settings](file:///Users/mbp/dev/watch-design-kit/knowledge/platform-facts.md)
- Studio precedent for faces: DayArc uses `getSettingsView` with one `Menu2` list, and returns null on mono Instinct so no "Customize" shows. That precedent is for a **face**. [Studio doc: DayArc decisions.md](file:///Users/mbp/dev/garmin/DayArc/docs/decisions.md)

### Inferences
- Build: `resources/settings/properties.xml` + `settings.xml` (one list, append-only ids) for Garmin Connect; in the app, `SunWindowDelegate.onMenu()` pushes a `Menu2` (one item "Accent" → a list) whose delegate writes `Properties.setValue` and calls `requestUpdate`. `onSettingsChanged()` just requests a redraw. Reading Properties in the glance is allowed (no scope flag).
- Watches without a dedicated menu key (e.g. the two-button Venu and vívoactive models) map `onMenu` to a long press or gesture. Confirm per device in the simulator; consider also offering the menu from `onSelect` if the full view has no other select action.
- Spec/kit text that says "`getSettingsView` is required" is correct for faces only; the planner should change the spec's Settings table for Sun Window (owner/PM doc fix, not a code task).

### Gaps
- No Garmin text names the gesture that triggers `onMenu` on each touch device; simulator check needed.
- Whether newer firmware exposes a system "Settings" entry for apps in the glance/app long-press menu is undocumented (I found no source either way).

## 5. Position: getInfo vs enableLocationEvents, accuracy and age, no fix, permission

### Takeaway
`Position.getInfo()` returns an `Info` immediately (cached, may be stale or empty); `Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition))` turns the GPS on and calls back once with a fresh fix, which widgets/apps (not faces) may use. `Info.accuracy` is a non-null `QUALITY_*` (0 not available, 1 last known, 2 poor, 3 usable, 4 good), `Info.when` is the fix's GPS timestamp, `Info.position` may be null. Permission `Positioning` is granted at install; calling `getInfo` without it killed the app uncatchably in the simulator.

### Cited Findings
- `getInfo() as Position.Info` "Get the current Position.Info. Using this API requires enabling the Positioning Permission. This is useful for retrieving the current position info either on demand or periodically within a Timer." `enableLocationEvents(options as { :acquisitionType … } or Position.LocationAcquisitionType, listener as Method(…) or Null)`; `LOCATION_ONE_SHOT 0`, `LOCATION_CONTINUOUS 1`, `LOCATION_DISABLE 2`. [SDK doc: Toybox.Position](https://developer.garmin.com/connect-iq/api-docs/Toybox/Position.html)
- `Info.accuracy as Position.Quality` "good, usable, poor, or not available … This cannot be null"; constants `QUALITY_NOT_AVAILABLE 0`, `QUALITY_LAST_KNOWN 1`, `QUALITY_POOR 2`, `QUALITY_USABLE 3`, `QUALITY_GOOD 4`. `Info.position as Location or Null` ("If no GPS is available or is between GPS fix intervals … propagated (dead-reckoned) … After a short period of time, the position will cease to be propagated"). `Info.when as Time.Moment or Null` "The GPS time stamp of the obtained Location fix." [SDK doc: Position.Info](https://developer.garmin.com/connect-iq/api-docs/Toybox/Position/Info.html); [SDK doc: Toybox.Position](https://developer.garmin.com/connect-iq/api-docs/Toybox/Position.html)
- "Only widgets and apps are allowed to call Position.enableLocationEvents()". [SDK doc: Manifest and Permissions](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Manifest_and_Permissions.html)
- In the inactive state, "If the app is not recording an activity, it is blocked from modifying the GPS state"; in the active state "GPS access may be denied if another app is recording an activity." [SDK doc: Application and System Modules](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Application_and_System_Modules.html)
- Owner FR965 (device, 2026-09-27): `Position.getInfo()` with Positioning returned a cached location immediately; `Activity.currentLocation` and the Weather observation location stayed null. [VDW platform §5 and §8, citing TwoSuns ADR-005](file:///Users/mbp/dev/garmin/TwoSuns/docs/decisions.md)
- Simulator: `Position.getInfo()` without the permission "killed the app uncatchably". [Studio doc: platform-facts.md](file:///Users/mbp/dev/watch-design-kit/knowledge/platform-facts.md)
- TwoSuns already has `TwoSunsPlace.isUsable(lat, lon)` (rejects "null island" near 0,0 and out-of-range values) and `TwoSunsPlace.round` (0.1 degree), plus a reader that converts `Position.getInfo().position` to degrees. [Studio code: TwoSuns/source/TwoSunsPlace.mc](file:///Users/mbp/dev/garmin/TwoSuns/source/TwoSunsPlace.mc); [Studio code: TwoSuns/source/TwoSunsSources.mc](file:///Users/mbp/dev/garmin/TwoSuns/source/TwoSunsSources.mc)
- Forum: "position 180 180" placeholder values are said to appear with no fix (search snippet only, not confirmed). [Forum: How can I indicate the GPS status/fix](https://forums.garmin.com/developer/connect-iq/f/discussion/399614/how-can-i-indicate-the-gps-status-fix)

### Inferences
- Flow for the full view: on `onShow`, read `getInfo()`; if `position != null`, `accuracy >= QUALITY_LAST_KNOWN` (or `>= QUALITY_POOR`, tune) and `isUsable`, round to 0.1 degree and store it with a timestamp. If nothing usable is stored, call `enableLocationEvents(LOCATION_ONE_SHOT, …)` and show a "finding location" state; disable on `onHide`. A 0.1-degree place moves the 45-degree crossing by well under a minute, so one fix lasts until the user travels.
- Port `TwoSunsPlace` (isUsable, round) rather than writing new guards; also reject exact ±180 to cover the placeholder report.
- The glance should not call `Position` (see §2); first-run glance shows the "open once" state.

### Gaps
- Real behaviour of `LOCATION_ONE_SHOT` from a glance-launched app on a watch (time to fix, battery, interaction with the glance timeout) is unmeasured.
- Whether `getInfo()` in a glance returns a cached fix on a watch (D6) is unmeasured; the compiler allows it.
- The exact install-time permission UI text is not documented (see VDW platform §5).

## 6. Weather: getCurrentConditions / getHourlyForecast, uvIndex, cloudCover, nulls, observation time

### Takeaway
Covered in [VDW platform §1]; the build facts are: `Weather.getCurrentConditions()` returns `CurrentConditions or Null`, `Weather.getHourlyForecast()` returns `Array<HourlyForecast> or Null`; `uvIndex` (`Float or Null`, 0–10) and `cloudCover` (`Number or Null`, 0–100) on both at API 5.1.0; `CurrentConditions.observationTime` and `HourlyForecast.forecastTime` are `Moment`s. Every field can be null, no permission is needed, and the call only reads a cache.

### Cited Findings
- `getHourlyForecast() as Lang.Array<Weather.HourlyForecast> or Null` "An array of hourly forecasts or null if no data is available", API 3.2.0. [SDK doc: Toybox.Weather](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html)
- `uvIndex`/`cloudCover` fields, types and the 5.1.0 floor; nullability; FR965 hourly list of 12 entries, 60 minutes apart, first at the current hour; observation 18–20 min old. [VDW platform §1](file:///Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake/research_notes/Vitamin%20D%20window/platform_and_permissions.md)
- No glance scope restriction on `Weather` (no flag in `api.mir`; probe compiled `cc.uvIndex` in glance code at `-l 3`). [SDK data: api.mir](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/bin/api.mir); [Compile probe]
- DayArc already guards UV with `has :uvIndex` and hides it when null. [Studio doc: DayArc ADR-005](file:///Users/mbp/dev/garmin/DayArc/docs/decisions.md)

### Inferences
- Weather filter rule: pick the hourly entry whose `forecastTime` covers now (fall back to current conditions); if the entry or the field is null, **do not demote** (state follows geometry alone). With `minApiLevel 5.1.0` no `has` check is needed, but a null check is.
- Keep weather reads out of the glance if fit is tight on the 32 KB Instinct ids (the array of HourlyForecast objects is the largest allocation in the app).

### Gaps
- Same as VDW platform: no device evidence that `uvIndex`/`cloudCover` are non-null (D2).

## 7. Device list: API 5.1+ ids with glances, display types, resolutions, memory

### Takeaway
SDK 9.2.0 has 74 API 5.1+ ids with a `glance` app type (66 watches, 8 Edge) plus `etrextouch` (no glance). Among the 66 watches: AMOLED 16-bit (390, 416, 454, 466 round; 448×486 Venu X1; 360 FR265S), MIP 8-bit (218–280 round: fēnix 7 family, FR255 family, FR955, Enduro 3, fēnix 8 Solar, fēnix 9 Pro Solar), and three 1-bit semi-octagon Instincts (166×166, 176×176) with 32 KB glance / 128 KB app.

### Cited Findings
Table built from `Devices/*/compiler.json` (`partNumbers[0].connectIQVersion`, `displayType`, `deviceFamily`, `bitsPerPixel`, `appTypes`) and `simulator.json` (`watchdogCount`). [SDK data: Devices/*/compiler.json](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/fr965/compiler.json)

| Group | Device ids | Display | Glance KB | App KB |
|---|---|---|---|---|
| AMOLED 360 | fr265s | amoled 16 bpp | 64 | 768 |
| AMOLED 390 | approachs50, approachs7042mm, descentmk343mm, descentg2, epix2pro42mm, fr165, fr165m, marq2, marq2aviator, venu3s, vivoactive5, fr170, fr170m, fr70, fr57042mm, venu441mm, vivoactive6, instinct3amoled45mm, instinctcrossoveramoled | amoled 16 bpp | 64 | 768 |
| AMOLED 416 | d2mach1, epix2, epix2pro47mm, fr265, fenix843mm, fenixe, instinct3amoled50mm, fenix943mm, fenix9pro43mm | amoled 16 bpp | 64 | 768 |
| AMOLED 454 | approachs7047mm, descentmk351mm, d2mach2, d2mach2pro, epix2pro51mm, fr965, venu3, fenix847mm, fenix8pro47mm, fr57047mm, fr970, venu445mm, fenix947mm, fenix9pro47mm | amoled 16 bpp | 64 | 768 |
| AMOLED 466 | fenix9pro51mm | amoled 16 bpp | 64 | 768 |
| AMOLED rect | venux1 (448×486) | amoled 16 bpp | 64 | 768 |
| MIP 218 | fr255s, fr255sm | mip 8 bpp | 64 | 512 (fr255s) / 768 |
| MIP 240 | fenix7s, fenix7spro | mip 8 bpp | 64 | 768 |
| MIP 260 | fr255, fr255m, fenix7, fenix7pro, fenix7pronowifi, fr955, fenix8solar47mm, fenix9prosolar47mm | mip 8 bpp | 64 | 512 (fr255) / 768 |
| MIP 280 | fenix7x, fenix7xpro, fenix7xpronowifi, enduro3, fenix8solar51mm, fenix9prosolar51mm | mip 8 bpp | 64 | 768 |
| 1-bit Instinct | instincte40mm (166), instincte45mm (176), instinct3solar45mm (176), semioctagon | mip 1 bpp | **32** | **128** |
| Not watches | edgeexplore2, edge540/550/840/850/1040/1050, edgemtb (glance 64); etrextouch (widget, no glance) | lcd | — | — |

- API levels: 5.1 (approachs50, approachs70 42/47, descentmk3 43/51, descentg2, edgeexplore2, etrextouch), 5.2 (fēnix 7 family, epix 2 family, FR165/255/265/955/965, MARQ 2, Venu 3, vívoactive 5, D2 Mach 1/2), 6.0 (FR70/170/570/970, Venu 4/X1, vívoactive 6, Instinct 3/E/Crossover AMOLED, fēnix 8/9/E, Enduro 3, D2 Mach 2 Pro, Edge 540–1050). [SDK data: compiler.json `deviceGroup`]
- Simulator watchdog counts (`simulator.json` `watchdogCount`): 240,000 on 64 of the API 5.1+ ids, 120,000 on `fr255`/`fr255s`, 250,000 on `etrextouch`, 2,500,000 on the Edges. [SDK data: Devices/fr965/simulator.json](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices/fr965/simulator.json)

### Inferences
- Three design targets cover the range: AMOLED round (most ids), MIP 8-bit round (64-colour, sunlight-readable), 1-bit semi-octagon Instinct (own look pass, accent hidden like DayArc). Venu X1 is the only rectangle.
- 32 KB Instinct ids: either a lean glance (state word only, no weather in the glance) or exclusion; they also have the smallest app memory (128 KB), which a text widget should still clear.

### Gaps
- The upload form's Compatible Devices list is the final word; the `.iq` export count has differed from the manifest before (studio note in VDW platform).
- Real glance pixel area per device (the clipped rectangle) is not in `compiler.json`; measure with screenshots.

## 8. Solar maths on device: Double, Math, watchdog, closed form vs bisection

### Takeaway
`Lang.Double` is 64-bit (literal suffix `d`), and every `Math` trig function returns **Double only if the input is Long or Double, Float otherwise**, so the port must feed Doubles end to end. The 45-degree crossing has a **closed form** (hour angle from `cos H = (sin 45° − sin φ sin δ) / (cos φ cos δ)`), so no bisection is needed; TwoSuns already ships the same structure in Float (`declinationAndEquationOfTime`, `cosHourAngle`, `halfDay(zenith, …)`). The watchdog is a bytecode count (simulator: 240,000 on most ids, 120,000 on FR255/255S), and the unit-test runner disables it, so tests cannot catch a trip.

### Cited Findings
- "Double represents a 64-bit floating point number. To use a double in Monkey C add 'd' to the end of the number." [SDK doc: Lang.Double](https://developer.garmin.com/connect-iq/api-docs/Toybox/Lang/Double.html)
- `Math.sin/cos/tan/asin/acos/atan/atan2/sqrt/pow/ln/log(x as Lang.Numeric) as Lang.Decimal` — "Returns: Lang.Float, Lang.Double … Float if input is Number or Float, Double if input is Long or Double". Also `floor`, `ceil`, `round`, `toRadians`, `toDegrees`. `Lang.Decimal` = Float or Double. [SDK doc: Toybox.Math](https://developer.garmin.com/connect-iq/api-docs/Toybox/Math.html); [SDK doc: Toybox.Lang](https://developer.garmin.com/connect-iq/api-docs/Toybox/Lang.html)
- Watchdog: "Watchdog Tripped — A Monkey C function has executed for too long; watchdogs prevent a Monkey C program from hanging the system via an infinite loop." [SDK doc: Exceptions and Errors](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Monkey_C/Exceptions_and_Errors.html)
- SDK 2.3.1: "Disabled watchdog timer for the RunNoEvil Test Framework to allow for more complex tests." [SDK doc: Release Notes](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Forum: the watchdog counts bytecodes executed without returning to the VM, not time; sim and hardware limits differ; "if you trip it on the simulator you'll be tripping it on hardware as well"; `watchdogCount` in `simulator.json` (240,000 fēnix 7X, 80,000 FR235). [Forum: Watchdog time limit knowable?](https://forums.garmin.com/developer/connect-iq/f/discussion/327072/watchdog-time-limit-knowable); [Forum: WatchDog and Sys.getTimer()](https://forums.garmin.com/developer/connect-iq/f/discussion/275876/watchdog-and-sys-gettimer-in-the-simulator-and-in-real-devices-how-do-they-really-work/1322430)
- `Math.PI` and `Math.E` are Float constants: `const PI as $.Toybox.Lang.Float = 3.1415927f;`. [SDK data: api.mir](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/bin/api.mir)
- Studio: HeroSet 1.0.0 shipped a `Watchdog Tripped Error` on a real FR965 (181 ms of learning) that the simulator never showed. [Studio doc: HeroSet decisions.md ADR-046](file:///Users/mbp/dev/garmin/HeroSet/docs/decisions.md)
- TwoSuns `TwoSunsSun` (114 lines, Float): `compute(year, month, day, lat, lon, offset)`, `declinationAndEquationOfTime(days)`, `cosHourAngle(zenith, lat, decl)`, `halfDay(zenith, lat, decl) as Float or Null`, with a 338-line reference test. [Studio code: TwoSuns/source/TwoSunsSun.mc](file:///Users/mbp/dev/garmin/TwoSuns/source/TwoSunsSun.mc); [Studio code: TwoSunsSunReferenceTest.mc](file:///Users/mbp/dev/garmin/TwoSuns/source/test/TwoSunsSunReferenceTest.mc)
- Compile probe: `Math.sin(0.5d)` compiled in glance scope; a `(:test)` checking `Math.sin(0.5d) instanceof Double` and `Math.sin(0.5) instanceof Float` was written but **not run** (no simulator run in this task). [Compile probe]

### Inferences
- Algorithm: per day compute declination δ and equation of time once (NOAA, Double); state now = elevation from hour angle; NONE TODAY iff noon elevation `90 − |φ − δ| < 45`; window edges = solar noon ∓ H₄₅ where `cos H₄₅ = (sin 45° − sin φ sin δ)/(cos φ cos δ)`, converted to local clock with `System.getClockTime().timeZoneOffset` (or `Gregorian.info`). That is a few dozen trig calls, orders of magnitude under a 120,000-bytecode watchdog. Declination changes slightly over the day; one refinement pass (recompute δ at the edge time) is enough to hit the 1-minute fixture tolerance, still closed form.
- Port TwoSuns' structure to Double (`0.0d` constants, `Math.PI` is a Float constant (above), so define a Double π in `SunWindowConfig`) rather than writing new maths; extend its reference-test style against `solar_elevation_fixtures.md`.
- Watchdog risk is only real for loops (e.g. a bisection over 1,440 minutes with full NOAA each step); the closed form avoids it. Still run a sim timing check on `fr255s` (the lowest count).

### Gaps
- Device watchdog limits are not published; only simulator counts exist.
- Double arithmetic speed on device is unmeasured.

## 9. Unit testing with Toybox.Test

### Takeaway
Tests are `(:test)` functions taking a `Test.Logger` and returning `Boolean`, compiled with `monkeyc -t` (`--unit-test`) and run with `monkeydo <prg> <device> -t` in the simulator only; test code is stripped from release builds, the watchdog is off during tests, and the studio runs this through its Docker simulator (`<Project>/tools/run_tests.sh`). Glance code is testable as plain functions; drawing is not.

### Cited Findings
- "Tests methods must be marked with the :test annotation; Test methods must take a Test.Logger object; Tests methods that are not global … must be static methods"; return true for pass; `Logger.debug/warning/error`; `Test.assert`, `assertEqual`, `assertNotEqual`, `…Message` variants; "build the app with the --unit-test flag … use the monkeydo script … with the /t flag"; "Run No Evil operates only within the Connect IQ simulator"; test code "automatically removed at compile time when your app is exported". [SDK doc: Unit Testing](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Unit_Testing.html)
- Watchdog disabled in the test framework since SDK 2.3.1. [SDK doc: Release Notes](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html)
- Studio rule: simulator runs go through the container (`<Project>/tools/run_tests.sh`, `fit-sweep.sh`); HeroSet's `glance-scope-check.sh` also builds the test jungle at `-l 3`. [Studio doc: docker/SIMULATOR.md](file:///Users/mbp/dev/garmin/docker/SIMULATOR.md); [Studio code: HeroSet/tools/glance-scope-check.sh](file:///Users/mbp/dev/garmin/HeroSet/tools/glance-scope-check.sh)
- TwoSuns tests inject a fixed `NOW = 1800000000` epoch and test pure static functions (`TwoSunsSunReferenceTest`, `TwoSunsPlaceTest`). [Studio code: TwoSuns/source/test](file:///Users/mbp/dev/garmin/TwoSuns/source/test/TwoSunsPlaceTest.mc)

### Inferences
- Test plan shape: pure `SunWindowSun` (fixtures within 0.02° / 1 min), `SunWindowState` (OPEN/CLOSED/NONE TODAY from elevation, window and a weather tuple incl. nulls), place guard/rounding, accent id → colour mapping (append-only ids). Inject time and location; never call `Time.now()` or `Position` inside tested functions.
- Because the watchdog is off in tests, add one timing assertion (e.g. `System.getTimer()` delta for a full-day compute) and a manual sim run on `fr255s` without `-t`.
- Copy TwoSuns' `tools/run_tests.sh` ([Studio code](file:///Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake/TwoSuns/tools/run_tests.sh); `gen_sun_tests.py` sits next to it) and HeroSet's `glance-scope-check.sh` into `SunWindow/tools/` rather than writing new ones.

### Gaps
- The probe's Double/Float type test was not executed (no simulator run in scope); it is a 5-line first test for the build.
