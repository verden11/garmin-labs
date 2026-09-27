# HeroSet glance: what it should show and how it should look (design, UX, precedent)

As of 2026-09-26. Round watches only. **Simulator numbers below are simulator-only; nothing here has run on a wrist.** "Inference" marks my reasoning, not a sourced fact.

Path shorthand used in links: **SDK** = `file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs`, **DEV** = `file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Devices`, **HS** = `file:///Users/mbp/dev/garmin/HeroSet`, **HF** = `file:///Users/mbp/dev/garmin/HeroFace`.

Method notes (so the writer can judge weight): I read the local SDK docs and the per-device `compiler.json` / `simulator.json` for all 80 store-manifest products; compiled a throwaway stub watch-app (in the scratchpad, not the repo) with a `(:glance)` `GlanceView` and ran it with `monkeydo` on `fr965`, `fenix7`, `fr255s`, `venu3`, `fenix847mm`, `fr70` to read `dc` size and `FONT_GLANCE` metrics; queried the public Connect IQ store API for widget descriptions that mention "glance" (238 apps de-duplicated across 12 queries; 82 mention it); read open-source glance code found through `gh search code`; read Garmin forum threads. **I could not see store screenshots or a native Garmin glance on a wrist**, so "how native glances look" rests on manual text and third-party descriptions only (see Gaps).

---

## Overall: read-only status, or status + hint?

### Takeaway
Ship a **read-only status glance**: one text line (streak, or the done state) over **one row of three side-by-side pill bars** (push-ups, sit-ups, squats in the fixed ADR-044 order), drawn from existing strings only. Research does not support a text hint: it adds 15 translations, does not fit the 63 px glances, and duplicates what the app already does when launched (the main menu opens on the first exercise not at goal). If a hint is ever wanted, make it a drawn marker on the first unfinished pill, not words.

### Cited Findings
- Selecting a glance launches the app; the glance itself is a summary "canvas" ("executive summary from your widget"), and the launched base page has no widget input restrictions. — [SDK Glances](SDK/Core_Topics/Glances.html) and [SDK Entry Points](SDK/User_Experience_Guidelines/Entry_Points.html) (URLs use the SDK prefix above)
- Garmin's stated principle for apps: "key information ... quickly and with minimal interaction. Save deep dives for mobile apps or the web." — [SDK Understanding What You Are Building](SDK/User_Experience_Guidelines/Understanding_What_You_Are_Building.html)
- The HeroSet main menu already "open[s] focused on Start item of first exercise not yet at goal (top of list when all done) — next set usually one START." — [HS/docs/input-and-ux.md](HS/docs/input-and-ux.md)
- Store precedent for habit/goal glances is status only (n done, percent + bar, streak, amount); no glance description among the ones I read offers a prescriptive hint, except "Challenge Counter" (a weekly rep-target glance: what week it is and how many reps you *should* be doing). — [Habit Streaks](https://apps.garmin.com/en-US/apps/aff13c0b-f975-4206-b4a5-9d3373152b3f), [Challenge Counter](https://apps.garmin.com/en-US/apps/44f853a7-ea15-455f-b4eb-dc8ac7a2b392), [Drink Water](https://apps.garmin.com/en-US/apps/f7ca63e4-4f0e-4e89-b28b-599b81f0237b)

### Inferences
- "Let research decide" resolves to status-only: the hint's information is already one press away inside the app, and its cost (new strings in 15 unreviewed locales, a third text row on 63 px glances) is paid on every draw.
- The "next exercise" answer can ride on the bars for free: the first pill that is not full *is* the next exercise, because order is fixed.

### Gaps
- No user research exists on whether HeroSet users want a hint; this is design reasoning plus precedent, not user evidence.

---

## Q1. Garmin's own guidance and platform limits for glances

### Takeaway
Garmin gives almost no visual design rules for glances (no text-size, line-count or colour prescriptions in the SDK 9.2.0 docs or the UX guidelines). What it does give is hard platform limits: which products get a glance, the content-area size (as small as 63 px tall), the glance memory cap, and dedicated fonts. Treat those as the design brief.

### Cited Findings
**What the docs say**
- Glances exist since API 3.1.0. On API 4.0.0+ device apps ("watch-app", which HeroSet is) may have a glance and **must implement a glance view to appear in the glance list**. — [SDK Glances](SDK/Core_Topics/Glances.html)
- The glance is "a small canvas to present an executive summary"; the `dc` is "bounded by glance area rather than a full screen dc"; no `Layer`/page APIs. — [GlanceView API](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/WatchUi/GlanceView.html)
- Glance mode runs with limited memory; the docs say "32KB for most devices" and use `:glance` annotations to choose what loads. The per-device files disagree with "most": **65,536 bytes on 63 of HeroSet's 80 products and 32,768 on 17** (list below). Update model: "live" devices keep the glance alive and honour `requestUpdate()` (keep updates under 1 Hz); non-live devices start the app only when the glance is shown and at least 30 s since last update, and **cache whatever was drawn**. — [SDK Glances](SDK/Core_Topics/Glances.html); [DEV/fr965/compiler.json](DEV/fr965/compiler.json)
- Best practice: make the glance quick to load; heavy work goes to a background service. — [SDK Glances](SDK/Core_Topics/Glances.html)
- UX guidelines: "If your app has a trackable metric, consider creating a glance for it"; design both the full-screen launch and the launch-from-glance; localization: "Leave enough space for translated text", "Supporting only English is not a localization strategy". — [SDK Entry Points](SDK/User_Experience_Guidelines/Entry_Points.html), [SDK Localization](SDK/User_Experience_Guidelines/Localization.html)
- Fonts: `FONT_GLANCE` ("Glance text font") and `FONT_GLANCE_NUMBER` ("Glance number only font"), both since API 3.1.8. Sizes vary by device "so CIQ can use the same fonts as the native ones". — [Graphics API](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/Graphics.html); [forum 348347](https://forums.garmin.com/developer/connect-iq/f/discussion/348347/device-info-glance-yes-no-and-size-and-font-size-width-in-pixel)
- `AppBase.getGlanceTheme()` and `AppBase.GlanceTheme` (DEFAULT, BLUE, GOLD, GREEN, LIGHT_BLUE, RED, WHITE, PURPLE) exist since API 4.0.0: an app can choose its glance card colour theme. — [AppBase API](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/Application/AppBase.html)
- Background must not be painted opaque: calling `super.onUpdate()` (and layouts) loses the device's gradient card on FR965/vívoactive 5; the workaround is to draw manually with `COLOR_TRANSPARENT`. — [forum 368041](https://forums.garmin.com/developer/connect-iq/f/discussion/368041/glance-background-gradient). An independent developer's code comment says clearing to `COLOR_BLACK` "painted a flat black rectangle over the themed card" on Forerunner 70/265, Venu 3 and fēnix 8. — [trainbud TrainBudGlanceView.mc](https://github.com/Zsadigzade/trainbud/blob/cf22892f67b81529b07b71302dd8e6316e4e24c4/ciq/source/TrainBudGlanceView.mc)
- A launcher icon is drawn by the system at the left of the glance; the content area excludes it. `simulator.json` gives `iconArea` and `contentArea` per device. — [DEV/fr965/simulator.json](DEV/fr965/simulator.json)

**Which HeroSet products get a glance (from `compiler.json` and a compile test)**
- Compiling a stub `watch-app` for `fenix6` gave: "Glance applications are not supported for app type 'watch-app' on device 'fenix6' with minimum API Level 3.4.5. The (:glance) annotation will be ignored." Build succeeded. `Device_Reference/fenix6.html` says Glance "Build as Widget"; `fenix7`/`fr955`/`fr255s`/`venu3` say "Build as Watch App or Widget". — [SDK fenix6](SDK/Device_Reference/fenix6.html), [SDK fenix7](SDK/Device_Reference/fenix7.html) (my compile test; reproducible with a 10-line stub)
- The 17 products with 32,768-byte glance memory are exactly HeroSet's wave 4 (CIQ 3.4 MIP): `fenix6`, `fenix6s`, `fenix6pro`, `fenix6spro`, `fenix6xpro`, `marqadventurer`, `marqathlete`, `marqaviator`, `marqcaptain`, `marqcommander`, `marqdriver`, `marqexpedition`, `marqgolfer`, `descentmk2`, `descentmk2s`, `fr945lte`, `enduro`. — [HS/docs/compatibility.md](HS/docs/compatibility.md) wave 4 vs `compiler.json` `appTypes`. **I compiled only `fenix6`; the other 16 are inference.**
- The other **63 products** have 65,536-byte glance memory (FR965/970, FR165/265/570/955/255, fēnix 7/8/9, epix 2, Venu 2/3/4, etc.).
- `liveUpdates: false` occurs only on products inside the 17 (`fenix6`, `fenix6s`, 8 MARQ Gen 1, `enduro`), so all 63 glance-capable products have live updates. — `simulator.json` per device (my table)

**Glance content area per device (from `simulator.json`; width × height in px, excluding the icon area)**

| Screen | Products (in HeroSet's 63) | Content area |
|---|---|---|
| 218 MIP | `fr255s`, `fr255sm` | 140 × 79 |
| 240 MIP | `fenix7s`, `fenix7spro` | 151 × 63 |
| 260 MIP | `fenix7`, `fenix7pro`, `fenix7pronowifi` | 171 × 63 |
| 260 MIP | `fr955`, `fr255`, `fr255m` | 176 × 93 |
| 280 MIP | `fenix7x`, `fenix7xpro`, `fenix7xpronowifi` | 191 × 63 |
| 260/280 MIP | `fenix8solar47mm` / `fenix9prosolar47mm` / `fenix9prosolar51mm` / `fenix8solar51mm`, `enduro3` | 198–199 × 81, 216–217 × 88 |
| 360 AMOLED | `fr265s` / `venu2s` | 240 × 104 / 249 × 115 |
| 390 AMOLED | FR165, FR170/70, FR570 42, epix 2 Pro 42, MARQ 2, Descent Mk3 43/G2, Venu 3S/vívoactive 5/6, Venu 4 41, Approach S50 | 248–274 × 103–146 |
| 416 AMOLED | FR265, epix 2 / Pro 47, D2 Mach 1, Venu 2/2 Plus, D2 Air X10, fēnix 8 43 / 9 43 / 9 Pro 43, fēnix E | 274–325 × 103–133 |
| 454/466 AMOLED | FR965 299 × 148; FR970/570 47 299 × 130; Venu 3 303 × 164; Venu 4 45 318 × 150; fēnix 8/9 47 349 × 130; epix 2 Pro 51 312 × 103; fēnix 9 Pro 51 (466) 359 × 130 | up to 359 × 164 |

  So the design must work from **140 × 79 and 151/171/191 × 63** (MIP) to about 300 × 150 (AMOLED). Icon areas are 30–40 px on MIP, 45–65 px on AMOLED.
- FR965 glance is 299 × 148 at content offset (132, 2), icon 65 × 65 at (59, 43). — [DEV/fr965/simulator.json](DEV/fr965/simulator.json)

**Measured glance fonts (simulator, throwaway probe; simulator fonts are not device fonts, ADR-034 says so for the app too)**

| Product | dc | `FONT_GLANCE` px | `FONT_GLANCE_NUMBER` px | "MISSION COMPLETE" w (glance font) | "PUSH-UPS DONE" w | "3 DAY STREAK" w |
|---|---|---|---|---|---|---|
| fr255s (218) | 140 × 79 | 19 | 23 | 135 | 111 | 96 |
| fenix7 (260 MIP) | 171 × 63 | 22 | 37 | 141 | 116 | 100 |
| fr70 (390) | 257 × 125 | 35 | 45 | 281 | 227 | 199 |
| fenix847mm | 349 × 130 | 42 | 53 | 335 | 274 | 237 |
| fr965 | 299 × 148 | 42 | 53 | 335 | 274 | 237 |
| venu3 | 303 × 164 | 45 | 45 | 356 | 290 | 252 |

  Also on `fenix7`: translated done strings at `FONT_GLANCE` measured 109 to 146 px (`МІСІЯ ВИКОНАНА` 126, `TEHTÄVÄ VALMIS` 125, `UŽDUOTIS ATLIKTA` 136, `AUFGABE ERLEDIGT` 137, **`MISJA ZAKOŃCZONA` 146**) against a 171 px area, and `365 DAGEN OP RIJ` 129, `365 PÄIVÄN PUTKI` 133. On `fr255s` (140 px wide) the English "MISSION COMPLETE" is already 135. The `fr255s` translation run printed nothing (a gap).
- `FONT_GLANCE_NUMBER` behaves as a digit font: a developer reports missing-glyph boxes for "mg" on fēnix 7S and draws units in `FONT_GLANCE`; my probe's letter widths in the number font on `fenix7` (e.g. 276 vs 141 px for "MISSION COMPLETE") point the same way. — [HalfLifeCaffeine GlanceView.mc](https://github.com/jame581/HalfLifeCaffeine/blob/554b1c41da157e45643fefb8bdce7585b475cf28/source/GlanceView.mc)
- Real-device round-edge clipping happens inside glance rows: a developer reports that on fēnix 8's 130 px glance three 40 px lines fit with 5 px to spare and a title near the top "lost the left of its 'T'" under the round case, and that the fēnix 8 glance starts about 82 px in on a 454 px screen. — [trainbud TrainBudGlanceView.mc](https://github.com/Zsadigzade/trainbud/blob/cf22892f67b81529b07b71302dd8e6316e4e24c4/ciq/source/TrainBudGlanceView.mc) (single developer, comment text, not Garmin)
- Early Garmin post (fēnix 6 era): canvases 151/171/191 × 63; "a picture is worth a thousand words": a simplified graphic beats cramming text; use a few meaningful text elements; render graphics once to a `BufferedBitmap` to avoid scroll lag. — [Garmin forum news post](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/widget-glances---a-new-way-to-present-your-data)
- Glance dark card: the bundled theme art for the FR965 shows a dark teal gradient with a coloured left stripe; the "White" theme on `fenix843mm` samples `#525252` at left, `#2D2D2D` mid, `#161616`, then `#000000` at right (my BMP sampling of `nwidget_White.png`). — [DEV/fenix843mm/nwidget_White.png](DEV/fenix843mm/nwidget_White.png)

### Inferences
- No Garmin rule caps lines or text size; the practical cap is height: at 63 px only two `FONT_GLANCE` lines (2 × 22 = 44) plus a thin graphic fit; at 79 px two lines of 19 px plus a graphic; at 100+ px AMOLED three rows are possible.
- **Only 63 of 80 products can show a glance.** The other 17 (CIQ 3.4 MIP) silently ignore it; nothing breaks, but the listing/`compatibility.md` must not claim a glance there, and the 32 KB tier is moot.
- The `dc` is a rectangle inside a round watch: `HeroSetLayout` chord maths (built for the full round display) does not transfer; the glance needs its own rectangle-based fit (still measured, ADR-018) with a safety margin at the rounded corners. Where the slot sits on screen (first/last list position) is not documented, so keep top and bottom padding.
- `HeroSetPalette.BACKGROUND` plus `dc.clear()` (the app's pattern) must not be used in the glance: draw with transparent background. `HeroSetPalette.TRACK` (`#555555`) is nearly the same as the card's `#525252` on the White theme, so an unfilled track can vanish there; a 1 px muted outline on the track, or `getGlanceTheme()`-aware colours, would be needed (not tested).
- The house rule "Draw text via `HeroSetDraw.text`, never `dc.drawText`" ([HS/CLAUDE.md](HS/CLAUDE.md), ADR-034) needs a glance variant because `HeroSetLayout(dc)` assumes the whole round display, and `everyScreenFitsThisDisplay` cannot see the glance dc size (it is only exposed in glance mode; I found no runtime API for it).

### Gaps
- No Garmin document states glance text sizes, maximum lines or colour rules; the "Widget Glances" post is fēnix 6 era.
- Not verified on device: the other 16 of the 17 unsupported products; real `FONT_GLANCE` glyph shapes and widths; where the slot sits vertically on the round screen; whether a live glance re-reads Storage after the full app writes (assume nothing: read in `onUpdate`).
- The developer.garmin.com glance design pages returned no separate design guidance in search; I did not find a "glance style guide".

---

## Q2. Precedents: how do native and store glances present goal progress?

### Takeaway
The dominant store pattern for a "n of a daily goal" glance is **title or value line + one thin progress bar** (often percent and amounts as text). Streak glances add a "not done today yet" state, mostly by colour alone. I found **no glance with three separate bars** in ~80 glance-mentioning store descriptions, so the three-pill row is a novel but HeroFace-consistent choice, not a proven one.

### Cited Findings
**Store descriptions (developer claims from the public store API, 2026-09-26; download counts are buckets; no screenshots seen)**
- Water / hydration: Remindrate glance = "percent, progress bar, and amount"; Drink Water = "today's total, your goal and your percentage"; Water Tracker PRO = "Glance view with color progress bar" (bar goes white to orange to green to blue); FlexHydrate = "percent + volume"; Hydration PRO (100,000+ download bucket) = "handy glance view". — [Remindrate](https://apps.garmin.com/en-US/apps/c904849d-842a-41af-a131-b56a752146ec), [Drink Water](https://apps.garmin.com/en-US/apps/f7ca63e4-4f0e-4e89-b28b-599b81f0237b), [Water Tracker PRO](https://apps.garmin.com/en-US/apps/6dbe1d32-245c-46b1-9f38-0cc80f8931b2), [FlexHydrate](https://apps.garmin.com/en-US/apps/7f4b58d6-b447-49f8-9beb-ad15e6e77d91), [Hydration PRO](https://apps.garmin.com/apps/c5d8063b-a8a2-4b09-9d38-a1b2639ec1f9)
- Habit / streak: Habit Streaks glance "shows 'done today' progress without opening the app"; HabitLoop "progress ring shows your day at a glance"; Current Streak (1,000+ downloads, 5.0): "A yellow/orange bar in the glance indicates that you have not run today yet ... enjoy seeing the progress bar turn fully green!"; Run Streak: streak number changes colour with streak length and a "Run today!" text shows when the streak is alive but today not done. — [Habit Streaks](https://apps.garmin.com/en-US/apps/aff13c0b-f975-4206-b4a5-9d3373152b3f), [HabitLoop](https://apps.garmin.com/en-US/apps/91607ebd-ad3c-4c34-a2b4-832b20f27485), [Current Streak](https://apps.garmin.com/en-US/apps/775440ef-2548-4eb7-ba1f-bf0393c0a055), [Run Streak](https://apps.garmin.com/en-US/apps/a4caeaa8-eaf0-4d74-ba51-7b022d403b30)
- Weekly Steps glance: total with progress toward the weekly goal, "progress is blue if meeting daily average to achieve weekly goal, green if weekly goal achieved". Hourly Steps glance: steps this hour against the hourly goal and hours that met it (two figures). Mission Tracker: "Overall mission progress percentage on your glance". — [Weekly Steps](https://apps.garmin.com/en-US/apps/37189374-e62f-4718-af78-528fbee66ab1), [Hourly Steps](https://apps.garmin.com/en-US/apps/51125abb-3c56-4fb0-81e2-7edced38bcb2), [Mission Tracker](https://apps.garmin.com/en-US/apps/4391972d-4e3b-413b-825d-9278456d023e)
- Creatine Tracker: glance answers "have I taken it today" — a yes/no. — [Creatine Tracker](https://apps.garmin.com/en-US/apps/3dba64ac-5a2c-4f6d-9435-d1ee3a37dd59)
- Two-line glances are common: Zeeland OWS "summarized in two lines"; Finnish weather "pick two values". — store descriptions via [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=habit&startPageIndex=0&pageSize=30&countryCode=US&appType=WIDGET)

**Open-source glance code (structure and fonts)**
- Title (small, muted `FONT_GLANCE`) over a value in `FONT_GLANCE_NUMBER` over a 3-5 px bar, block centred vertically; switches to a compact spacing when `height < 85`; draws with `COLOR_TRANSPARENT`; keeps dictionaries and formatting out of the glance to save memory. — [garmin-ring-tracker GlanceView.mc](https://github.com/BarishNamazov/garmin-ring-tracker/blob/e46267a97a587ba5071d47c92155917f026725a0/source/GlanceView.mc)
- Text row(s) in `FONT_GLANCE` plus an 8 px bar, falling back to `FONT_XTINY` when the text does not fit; content block centred. — [Hydrafull HydrationGlanceView.mc](https://github.com/RodrigoNaguel/Hydrafull_Dani/blob/563149f9d2e4f8687e2deffd396d3c925c5737ea/source/HydrationGlanceView.mc)
- "name / current/goal ml (percent%) / 4 px bar" (fixed offsets, no measuring). — [water-tracker WaterTrackerGlance.mc](https://github.com/ince01/water-tracker/blob/cb967b6c8622a29622a4d051501083a9ae5253bb/source/WaterTrackerGlance.mc)
- A fitness glance that picks 1, 2 or 3 lines by measured height and keeps 20 px margin on round screens. — [trainbud](https://github.com/Zsadigzade/trainbud/blob/cf22892f67b81529b07b71302dd8e6316e4e24c4/ciq/source/TrainBudGlanceView.mc)
- Glance reads the clock: HalfLifeCaffeine calls `Time.now()` inside its glance `onUpdate`. — [HalfLifeCaffeine](https://github.com/jame581/HalfLifeCaffeine/blob/554b1c41da157e45643fefb8bdce7585b475cf28/source/GlanceView.mc)

**Garmin native glances**
- fēnix 7 manual lists 60+ preloaded glances including Steps, Floors Climbed, Intensity Minutes, Body Battery, Calories; some hidden by default, added to the loop manually. — [fēnix 7 manual, Glances](https://www8.garmin.com/manuals/webhelp/GUID-C001C335-A8EC-4A41-AB0E-BAC434259F92/EN-US/GUID-97EA1540-A780-480F-BA4D-9A9E147FB225.html)
- Search summaries (not the manual text) say the Steps glance shows step count and goal, and the Body Battery glance the current level plus a graph. — search summary of [FR265 manual](https://www8.garmin.com/manuals/webhelp/GUID-F41EAFB3-6CC9-42DE-9C6C-9E358DBB0671/EN-US/GUID-97EA1540-A780-480F-BA4D-9A9E147FB225.html) and [fēnix 7 manual](https://www8.garmin.com/manuals/webhelp/GUID-C001C335-A8EC-4A41-AB0E-BAC434259F92/EN-US/GUID-87E1392B-2C55-40B7-A1FF-3AB9252DA0A0.html) (the Body Battery page I fetched did not contain the glance description)
- Users complain that glances are "black background and white text" hard to read on FR255 (one locked thread). — [forum thread](https://forums.garmin.com/sports-fitness/running-multisport/f/forerunner-255-series/331679/can-you-reverse-colours-of-glances-so-that-text-is-black-and-background-is-white)

### Inferences
- Reading across precedents: "one metric, one bar, one line of context" is the norm; percent is the common text form for a bar; a done state is shown by colour change (green) far more often than by wording, which is the accessibility hole ADR-049 already closed on the dashboard.
- Three exercises with a shared goal is a three-metric glance; the closest analogues (Hourly Steps, trainbud) show two figures, not three graphics. A three-pill row is the smallest way to keep per-exercise truth without three rows of text (HeroFace already draws three columns, so it is on-brand).
- Percent is a familiar, zero-translation text form, but a combined percent is ambiguous for a three-goal mission unless defined as the capped average (only 100% when all three are done), as HeroFace's ring is defined ([HF/DESIGN.md](HF/DESIGN.md): "Fill is average progress across the goal-bearing missions, so it is only full when every one is done").

### Gaps
- No native glance seen visually (no screenshots readable from the store or manual PDFs in this environment; `pdftotext` not installed). Native layout conventions (title case, bar vs ring) are unverified.
- Store popularity is by download bucket only; I could not tie a glance style to ratings.
- No open-source glance with three goal bars found; absence in ~82 descriptions is not proof none exist.

---

## Q3. Content options, ranked, with trade-offs

### Takeaway
Rank: **1. (a) three pills + streak, with (d) as its terminal state (recommended); 2. (b) combined percent + streak; 3. (c) reps left; 4. (e) next-up text hint.** (d) is not an alternative; it is the state every option must have. The recommended design needs **zero new strings**, no colour-only state, and fits 63 px because the three bars share one row.

### Cited Findings
Facts used for scoring (design conclusions are under Inferences):
- Existing strings that a glance can reuse with no new translation: `AppName`, `exercise_pushups/situps/squats`, `dashboard_streak` ("$1$ DAY STREAK"), `dashboard_streak_short` ("STREAK $1$"), `dashboard_streak_none`, `dashboard_mission_complete`; `dashboard_mission_done` needs an argument. There are 15 locale resource folders. — [HS/resources/strings/strings.xml](HS/resources/strings/strings.xml); [ADR-049](HS/docs/decisions.md#adr-049)
- Translations are not native-reviewed. — [HS/docs/release-contract.md](HS/docs/release-contract.md) (Languages row) and [ADR-049](HS/docs/decisions.md#adr-049)
- Done must not rely on colour alone (ADR-049; PRODUCT.md accessibility). Where a translated `DONE` label cannot fit "the rows drop the word and the full bar + count at goal carry it." — [ADR-049](HS/docs/decisions.md#adr-049), [HS/PRODUCT.md](HS/PRODUCT.md)
- HeroFace's done signal is three-fold: green label plus a **drawn check** plus a full bar; "Audit test: render the face in greyscale — every state must still be nameable." — [HF/DESIGN.md](HF/DESIGN.md)
- Palette: every colour uses 00/55/AA/FF channels so MIP renders exactly (`HeroSetPalette`: EFFORT `#55AAFF`, DONE `#00FF00`, GOLD `#FFAA00`, MUTED `#AAAAAA`, TRACK `#555555`). — [HS/source/ui/HeroSetPalette.mc](HS/source/ui/HeroSetPalette.mc), [ADR-035](HS/docs/decisions.md#adr-035)
- Fixed field/exercise order (push-ups, sit-ups, squats) is a contract for the complication. — [ADR-044](HS/docs/decisions.md#adr-044)
- XP does not follow the goal; rank reflects reps done, not goals hit; the glance may show goal-based progress but must not imply a higher goal earns rank faster. — [HS/docs/release-contract.md](HS/docs/release-contract.md)

**Scoring table (fit numbers are simulator measurements from Q1; the rest is my judgement, see Inferences)**

| Option | Fits 63 px (fenix7, 171×63) | Fits 79 px (fr255s, 140×79) | Fits ~150 px AMOLED | 1-second read | New strings x 15 | Colour-blind / done not by colour | MIP 64-colour |
|---|---|---|---|---|---|---|---|
| (a) three pills + streak line, (d) terminal | Yes: 22 px text + about 8 px bars + gaps ≈ 40 | Yes | Yes (thicker bars) | Bar lengths | 0 | Full pill + drawn check + word or streak text | Existing palette |
| (b) combined % + streak | Yes | Yes | Yes | Number, fastest | 0 ("%") | Number; done = "100%" plus check | Yes |
| (c) "N reps left" | Yes (one line) | Yes | Yes | Number plus word | 1 (word order, plural), unreviewed | Number, not colour | Yes |
| (d) done state | Text "MISSION COMPLETE" 141 of 171 px; 135 of 140 px at fr255s (English) | Overflows in long locales (146 px Polish on fenix7) | Yes | Yes | 0 (reuse) | Needs check mark plus full bars, not colour | Yes |
| (e) next-up hint | 3rd row does not fit at 63 px | Tight | Yes | Word to read | 1+ ("NEXT"), unreviewed | Text | Yes |

### Inferences
- **Recommended layout (inference, not tested on a device):**
  - Row 1, `FONT_GLANCE`, left-aligned at the content edge: streak line via a longest-first candidate list measured against the glance width (`N DAY STREAK`, then `STREAK N`, then drop it); `NO STREAK YET` at 0. Muted while today is open, gold when today's mission is complete (same rule as the dashboard, [input-and-ux.md](HS/docs/input-and-ux.md)).
  - Row 2: three equal pills side by side (HeroFace mission-column proportions, half-height corner radius, track drawn first). Fill = count / goal in EFFORT blue; a done pill is full and DONE green. Height about `min(w,h)/10` (5–8 px on MIP, 10–14 px on AMOLED).
  - When all three are done: row 1 becomes a drawn check plus `MISSION COMPLETE` if it measures to fit (green), else the streak text with the check (gold), else the check alone. The word is optional because the full green pills and the check carry it (ADR-049 precedent).
  - Vertical stack centred as a block with top/bottom padding for the round corners; no title row when height < about 85 px; on AMOLED 100+ px glances, thicker bars and a bit more air, same design (fewer layouts to fit-test).
  - Draw with transparent background; use `FONT_GLANCE_NUMBER` only for digits.
- **Why (a) beats (b):** (b) is the least text and fastest number, but loses which exercise is behind, invents a "combined %" unit the app does not have, and "100%" can only be honest if defined as the capped sum. (a) shows the same fact as shape, needs no unit, and copies the face. If the row-of-three proves too small on a wrist, fall back to (b) with the same streak line, no new strings.
- **Why not (c):** the only option that says how much is left in words, but it costs a new plural-sensitive string in 15 unreviewed locales, and the number (sum of remaining across three exercises, up to 1,500) is not a thing the app shows elsewhere.
- **Why not (e) as text:** redundant with the menu's focus-on-next-exercise behaviour, costs a string, and does not fit 63 px. A drawn marker under the first unfinished pill would cost zero strings; defer it (clutter risk at 5–8 px).
- **Three stacked labelled bars do not fit** at 63 px (3 labelled rows need at least 3 × 22 px of text); even three unlabelled full-width bars plus a text line is possible (about 45 px) but is cramped; the side-by-side row is the smaller and more face-like choice.
- **Accessibility:** blue vs green plus full-vs-partial length plus the drawn check: greyscale-legible. No red in the glance (`ALERT` is reserved). On the White theme the track may be invisible (Q1); outline it.
- **i18n:** with (a), the worst case is measuring; no new copy. Translated `MISSION COMPLETE` will not fit 140 px in several languages (Polish 146 px on fenix7's font), which is why the word must be droppable.
- **MIP colour limits:** already satisfied (palette is 64-colour exact); risk is contrast on the card, not palette.
- **Update / memory:** annotate as `(:glance)` only what the glance needs (a small reader plus `HeroSetRules.activeStreak`, `HeroSetCalendar`, `HeroSetConfig`, palette); do not annotate `HeroSetStore` (its constructor writes and it pulls in sync coordinator wiring). Measure memory in the simulator per device family before claiming support (glance limit 64 KB on 63 products versus a 786 KB app).

### Gaps
- Nothing here was seen on a wrist or drawn on the real `dc`; a first task is a stub render at 140×79, 171×63, 299×148 to check pill widths and corner clipping.
- Memory cost of the glance build of HeroSet is unmeasured.
- Whether `getGlanceTheme()` is worth using (for example GOLD when the streak is alive) is untested and would be colour-only information.

---

## Q4. Consistency with HeroSet and HeroFace design docs

### Takeaway
The glance should reuse the same colour roles, pill bars, order and wording as the dashboard and HeroFace so the three read as one family; it differs only where the platform forces it: system glance fonts instead of `FONT_XTINY`, a rectangle instead of a round chord, a transparent instead of black ground.

### Cited Findings
- Colour roles: gold = what the user keeps (rank, XP, streak), blue = today's effort under way, green = a finished goal, gray = secondary, red = alert; blue vs gold survives red/green colour blindness. — [HeroSetPalette.mc](HS/source/ui/HeroSetPalette.mc), [ADR-031](HS/docs/decisions.md#adr-031)
- Dashboard mission bars: thick pill bars, label + count on one line, blue in progress, full + green + `PUSH-UPS DONE` label at goal, label dropped when it cannot fit. — [HeroSetMissionBars.mc](HS/source/ui/dashboard/HeroSetMissionBars.mc), [ADR-049](HS/docs/decisions.md#adr-049)
- Streak line: `N DAY STREAK` (`STREAK N` if no fit), muted while today is open, gold once today's mission is complete, `NO STREAK YET` at 0; a missed day shows 0 immediately. — [input-and-ux.md](HS/docs/input-and-ux.md), [ADR-031](HS/docs/decisions.md#adr-031)
- HeroFace: "Mission Column": value, pill bar, label; done turns fill and label green and prepends a drawn check; gold only for something kept; "A zero streak is muted grey, not gold"; "The Shorter-Wording Rule: ... picks a shorter wording, never a smaller font"; hides an element that has no honest value; every dimension a ratio of `min(width,height)/10`. — [HF/DESIGN.md](HF/DESIGN.md)
- HeroFace draws the streak from HeroSet's private complication when available; goal falls back to 100 when field 10 is absent or 0. — [ADR-044](HS/docs/decisions.md#adr-044), [ADR-045](HS/docs/decisions.md#adr-045)
- Glance memory constraint conflicts with the house rule that `HeroSetDraw.text` be the only text path (needs `HeroSetLayout`, round chord). — [HS/CLAUDE.md](HS/CLAUDE.md), [ADR-034](HS/docs/decisions.md#adr-034), [ADR-036](HS/docs/decisions.md#adr-036)
- Idea #1 already scopes the glance as "today's three mission bars and the streak, no app launch", small cost, no new permission or storage key or contract change, per-device sweep required before claiming it, and warns that glances "run on the system's schedule, so they must not assume `ensureCurrentDay` ran recently". — [HS/docs/ideas.md](HS/docs/ideas.md)

### Inferences
- The glance can share `HeroSetPalette`, the pill proportions, the fixed order and the string ids; it should not share `HeroSetMissionBars` (chord-based, needs `HeroSetLayout`, labelled rows) but reimplement a small horizontal-segment drawer.
- The drawn check from HeroFace (two lines, pen about one fifth of the label size) is the natural non-colour done mark; HeroSet's dashboard has none, so the check would be new to HeroSet's app but already in the family.
- Do not show rank or XP in the glance: XP is the gold ring on the dashboard and does not follow the goal, and adding it competes for height with the streak; glance = today plus streak only (matches idea #1).

### Gaps
- No decision record exists for glance visual language; a new ADR would be needed on graduation ([ideas.md](HS/docs/ideas.md)).
- HeroSet `docs/architecture.md` / `testing-plan.md` were not read; how the fit test would cover the glance is open (Q1).

---

## Q5. Empty and edge states

### Takeaway
The glance must be **strictly read-only and self-contained**: compute "today" and the streak from raw stored keys without constructing `HeroSetStore`. Each edge below maps to the same wording the dashboard already uses, so no new strings are needed except (optionally) none.

### Cited Findings
- `HeroSetApp.initialize` builds `HeroSetStore` and the sync coordinator; the `HeroSetStore` constructor writes `hero_schema` and runs `ensureCurrentDay()`, which writes `hero_day` and **zeroes the day's counts and credit keys** when the stored day differs from today; `HeroSetApp.onStart` calls `ensureCurrentDay()` and publishes the complication. — [HeroSetApp.mc](HS/source/app/HeroSetApp.mc), [HeroSetStore.mc](HS/source/data/HeroSetStore.mc)
- Glance-mode lifecycle runs `AppBase.onStart()`, `getGlanceView()`, then the view's `onLayout/onShow/onUpdate/onHide`, then `onStop()`; on non-live devices the result is cached. — [SDK Glances](SDK/Core_Topics/Glances.html)
- Reading a missing key already yields 0 (`readNumber` falls back to 0) and a missing or corrupt goal yields the default 100 (`getGoal`). — [HeroSetStore.mc](HS/source/data/HeroSetStore.mc)
- `HeroSetRules.activeStreak(lastDay, today, stored)` is a pure function: returns 0 unless the last completion was today or yesterday. `HeroSetRules.missionComplete` and `crossedGoal` are pure. — [HeroSetRules.mc](HS/source/domain/HeroSetRules.mc)
- The storage-failure flag `_writeFailed` is an in-memory field of the store, sticky until the next user save; it is not persisted. — [HeroSetStore.mc](HS/source/data/HeroSetStore.mc)
- Lowering the goal below today's counts completes the mission at once, and `setGoal` re-runs `updateCompletion`; a goal raised later is accepted (ADR-045 "Streak vs a mid-day goal change, accepted"). — [ADR-045](HS/docs/decisions.md#adr-045)
- Storage is shared across the app's launch modes (same app id); glance may read Storage (SDK: "accessing application storage ... still supported"). — [SDK Glances](SDK/Core_Topics/Glances.html)
- The complication publisher already carries the same reasoning: HeroFace needs day keys "to tell today's counts from yesterday's and to break a streak HeroSet has not yet seen expire." — [ADR-044](HS/docs/decisions.md#adr-044)

### Inferences
| State | What the glance should show | Why |
|---|---|---|
| **Fresh install / never launched** | Three empty tracks, `NO STREAK YET`. Not "--", not an error | The glance can appear in the list before the app ever ran; no keys exist; zeros and default goal 100 are already the store's own defaults |
| **Day rollover not processed** (app not launched since yesterday) | Compare `hero_day` to today's key; if different, treat counts as 0 (all tracks empty), and compute the streak with `activeStreak(lastDay, today, stored)`. **Do not write.** | Otherwise 08:00 shows yesterday's "MISSION COMPLETE" until the app is launched; and glance-mode `onStart` plus `HeroSetStore` construction would write from a process that shares storage with the full app (concurrency not documented) |
| **Goal changed** | Read `hero_goal` on every draw (not in `initialize`), clamp like `clampGoal`; pills rescale; done = count ≥ goal | Live glances stay alive; a value cached at construction could go stale after the app changes it; unverified on device |
| **Goal lowered so today is complete** | "Complete" is computed from counts ≥ goal, same as the app; streak comes from the stored key the app already updated | `setGoal` re-runs `updateCompletion` in the app |
| **Streak broken (missed a day)** | `NO STREAK YET`, same as dashboard (0 shown immediately); at 00:00 after an unmet day it shows 0 | ADR-031 "Honest streak"; wording is imperfect for a *broken* streak but matches the app; changing it is a separate copy decision |
| **Streak alive, today open** | Streak line muted, pills partly filled | Same as the dashboard |
| **Storage error** | Cannot show the dashboard's `! COULD NOT SAVE` (flag is not persisted). On unreadable or wrong-typed values show zeros; on a thrown exception wrap the read and fall back to empty tracks | Glance-side reads must not crash; a dashboard-only warning is acceptable |
| **Long translations** | Drop words before shrinking (`MISSION COMPLETE` to streak+check to check only); measure with `dc.getTextWidthInPixels` at the glance's own width | HeroFace Shorter-Wording Rule; Polish `MISJA ZAKOŃCZONA` 146 px on 171 px area (fenix7 font) |
| **Unsupported glance (17 products)** | Nothing (no glance in list; app launches from Activities list) | Compile warning confirmed for fenix6 |

### Gaps
- Whether the glance process and the full app can run at the same time and race on Storage is not documented; a read-only glance avoids the question.
- Whether a live glance re-reads changed Storage without being torn down after the app exits is not verified (no device run).
- The stored-value type quirk (Numbers and Floats both come back) means a glance reader needs the same `asNumberOrNull` narrowing; copying it is a duplication cost.

---

## Q6. Streak-at-risk cue: feasible in a glance, and within the release contract?

### Takeaway
Feasible and cheap **without** the `Background` permission (unlike idea #4's nudge), because the cue only draws when the glance is viewed and can read the clock. It does not touch any forbidden claim, provided copy never says "reminder", "notification" or "alert". Precedent shows two ways to do it; the colour-only way is barred by ADR-049. Recommendation: **v1 needs no time-of-day cue**, because "open" versus "kept" (muted versus gold streak, partial versus full pills) already signals risk; add a time-gated cue only after real use asks for it.

### Cited Findings
- `System.getClockTime()` exists and glance code can read the clock (HalfLifeCaffeine uses `Time.now()` in its glance). — [System API](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/Toybox/System.html), [HalfLifeCaffeine](https://github.com/jame581/HalfLifeCaffeine/blob/554b1c41da157e45643fefb8bdce7585b475cf28/source/GlanceView.mc)
- The nudge with a notification needs a background temporal event and the `Background` permission, which changes the listing permission line, privacy page and `release-contract.md`; background processes get small memory and minimum interval; "A nagging fitness app gets deleted: default off". — [HS/docs/ideas.md](HS/docs/ideas.md) #4
- Streak Saver (open-source) warns before midnight when steps are short: default 23:00, user-adjustable, up to 3 repeat alerts 20 minutes apart, and the developer says background services are unreliable, so it re-arms itself on every launch; no glance mentioned. — [ricksy/streak_saver](https://github.com/ricksy/streak_saver)
- Run Streak: "Haven't run yet today? A clear 'Run today!' reminder tells you the streak is still alive but waiting on you." Current Streak: yellow/orange bar until done, then green. — [Run Streak](https://apps.garmin.com/en-US/apps/a4caeaa8-eaf0-4d74-ba51-7b022d403b30), [Current Streak](https://apps.garmin.com/en-US/apps/775440ef-2548-4eb7-ba1f-bf0393c0a055)
- Release contract forbidden claims: medical/exact calories, universal support, touch-first tested beyond simulator, every listed watch tested on a wrist, accuracy numbers, Connect/Strava sync or effect on Training Status/Readiness/Load, GPS/distance, a higher goal earning XP or rank faster. Data leaving watch: none; permission `Sensor` only. Nothing in that list concerns a glance cue; a glance adds no permission. — [release-contract.md](HS/docs/release-contract.md)
- Brand voice: "game coach ... never cheesy, never medical, never overpromising"; alert red is reserved (HeroFace: "Never a progress colour"). — [HS/PRODUCT.md](HS/PRODUCT.md), [HF/DESIGN.md](HF/DESIGN.md)
- ADR-031: the streak line is already muted while today is open and gold once complete, "until then it is a muted reminder of what is at stake." — [HeroSetView.mc](HS/source/ui/dashboard/HeroSetView.mc) comment, [ADR-031](HS/docs/decisions.md#adr-031)

### Inferences
- The dashboard already contains the at-risk cue, without time: streak muted plus incomplete bars. The glance inherits it for free.
- If a time-gated cue is added later: after a configured hour (a `HeroSetConfig` constant; there is **no evidence for the right hour**, 23:00 is one developer's default for a notification), when the streak is above 0, today is not complete, show the streak text with a drawn "!" or the word for TODAY (would be one new string x 15) or pulse the open pill outlines, never red and never colour only. Time-of-day is read at draw time, so it costs no permission; on live glances it may lag until the next update.
- Copy risk: the listing/site can say "see your streak status from the glance list"; it must not say the glance reminds or alerts. It also should not claim glance support for all 80 watches (only 63) and should cite simulator-only evidence until a wrist check (release contract: "only FR965 on a wrist").
- Hazard: a streak-at-risk cue shown at 23:59 that turns to `NO STREAK YET` at 00:00 is harsh but consistent with ADR-031's honest streak; no reason to soften only in the glance.

### Gaps
- No evidence on whether at-risk cues raise retention for this audience; only competing apps' feature lists.
- Best evening threshold unknown; would need user testing.
- I did not check `docs/go-to-market.md` or the site pages for any claim that mentions glances.
