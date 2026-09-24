# Smartwatch / Wearable Watch-Face Trends, 2025-09 → 2026-09 (Garmin Connect IQ emphasis)

Scope note: findings below are dated. Anything before 2025-09 is explicitly marked
**[historical]**. Some `developer.garmin.com` pages (Complications core topic, watch-face
UX guidelines, AMOLED FAQ) are client-side rendered and returned only navigation chrome to
the fetch tool — those are recorded as gaps rather than paraphrased from memory.

**Provenance warning.** Only five pages were individually retrieved and read: the Connect IQ
News & Announcements feed, the Connect IQ SDK page, the `Toybox.Complications` API reference,
the Garmin fēnix 9 newsroom press release, and the5krunner's Q2-2026 shipments post. **Every
other URL cited below came from a search-result summary and the page itself was not fetched.**
Treat those as second-hand until verified.

## Q1. Dominant visual/design trends in watch faces right now

### Takeaway
The strongest documented shift is AMOLED-first design with an explicit always-on/low-power
second design pass, plus a platform-level move to on-device *configurable* faces (one face,
many user-selected layouts) rather than many fixed faces. In the adjacent Apple ecosystem the
dominant 2025-26 aesthetic is translucent "Liquid Glass" with fluid numerals and dynamic
colour orbs.

### Cited Findings
- **[historical, but the defining current platform capability]** Connect IQ **System 8**
  (announced 2025-01-07 beta, shipped with **SDK 8.1.0 on 2025-03-04** — just before the window,
  so its market effects land inside it)
  brought "native watch face editor integration" / **Watch Face Configurations**, i.e.
  on-device editing of a single face's layout and colours — plus extended code space (16 MB),
  a VS Code extension, native pairing flow and a notifications API —
  [Connect IQ News & Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements);
  feature page: [Watch Face Configurations](https://developer.garmin.com/connect-iq/core-topics/editing-watch-faces-on-device/)
- Garmin publishes a dedicated **"Always On (AMOLED)"** section inside its official watch-face
  UX guidelines, and a separate FAQ **"How Do I Make a Watch Face for AMOLED Products"** —
  evidence that the AMOLED always-on second state is treated as a first-class design surface
  by the platform owner —
  [UX guidelines](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/),
  [FAQ](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)
- Developer-community output reflects the same split: an "AMOLED-optimized analog" face
  (SteelMaster) posted to the CIQ showcase, and a minimal digital face targeted specifically
  at the fēnix 8 AMOLED family —
  [CIQ showcase thread](https://forums.garmin.com/developer/connect-iq/f/showcase/377992/steelmaster---new-amoled-optimized-analog-watch-face),
  [Garmin_Watchface repo](https://github.com/stevensT/Garmin_Watchface)
- Apple **watchOS 26** (released 2025-09-15; Liquid Glass design language) shipped **67 total
  faces**, including *Flow* (colour orb + Liquid Glass numerals) and *Exactograph* (separate
  hour/minute/second dials, tap-to-zoom), and redesigned the Face Gallery into categories:
  Health and Fitness, Photos, Colorful, Clean, **Data Rich**, Nike, Pride, Tool, Bold —
  [MacRumors watchOS 26 roundup](https://www.macrumors.com/roundup/watchos-26/),
  [the5krunner watchOS 26 face guide, 2025-11-03](https://the5krunner.com/2025/11/03/watchos-26-apple-watch-faces-guide/),
  [MacDailyNews 2025-09-15](https://macdailynews.com/2025/09/15/apple-releases-watchos-26/)
- Apple continued adding faces mid-cycle: a new colourful face in **watchOS 26.5** (2026-05) —
  [9to5Mac 2026-05-05](https://9to5mac.com/2026/05/05/watchos-26-5-adds-a-colorful-new-apple-watch-face-with-these-customization-options/)
- Garmin itself shipped **seasonal/event faces** (World Sleep Day 2026 set) but restricted the
  rollout; high-end models including **Venu X1 and fēnix 8 Solar were ineligible**, which drew
  public criticism —
  [Notebookcheck](https://www.notebookcheck.net/Garmin-attracts-criticism-from-fans-after-limited-watch-face-rollout.1251279.0.html)
  (headline/summary only; the article itself returned HTTP 403 to the fetch tool)
- Review coverage of popular Garmin faces clusters into three recognisable buckets:
  **data-rich sport/cycling**, **clean AMOLED digital**, and **minimal analog** —
  [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/i-review-garmin-for-a-living-and-these-are-my-5-favorite-watch-faces)
  (treat as opinion/listicle-grade, not primary)

### Inferences
- The Watch Face Configurations mechanism makes "one configurable face" a better product shape
  than a family of near-identical fixed faces: a developer shipping fixed variants is now
  competing against a platform feature.
- Garmin's own restricted seasonal rollout leaves an unserved, visible demand (seasonal/event
  faces on flagship devices) that a third-party face can fill without platform conflict.
- Apple's "Data Rich" being a first-class gallery category alongside "Clean" suggests both
  poles are live simultaneously; the market is not converging on minimalism alone.

### Gaps
- No primary-source numbers on which *aesthetic* categories sell best in the Connect IQ Store;
  Garmin publishes no store-level download or category analytics I could find.
- Could not retrieve Garmin's actual AMOLED design rules (lit-pixel budget, burn-in
  protection, `requiresBurnInProtection`, refresh cadence) — both relevant developer.garmin.com
  pages are JS-rendered and returned navigation only. These need a browser fetch.
- No credible source found for a "retro/pixel" or "hyper-data-dense" trend in the window;
  only listicles, which were excluded per constraints.

## Q2. Health/fitness metrics users want at a glance; what is newly exposed to developers

### Takeaway
**Sleep Score is the newest health complication** (`COMPLICATION_TYPE_SLEEP_SCORE`, value 42,
**since API level 6.0.2**), and Connect IQ SDK 9.2.0 (2026-06-09) added SDK-side support for it
in watch faces. The full complication set was verified against the API reference: **Body
Battery, Stress, Recovery Time, Pulse Ox, Respiration Rate, VO2 max and Training Status have
all existed since API 4.2.0 [historical]**, while **HRV and Training Readiness have no
complication at all**.

### Cited Findings
- **Connect IQ SDK 9.2 (2026-06-09)**: "bug fixes, adds support for the **Sleep Score
  complication for watch faces**, and introduces support for bonded connections in the
  Bluetooth LE driver" —
  [Connect IQ News & Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements)
- Verified against the API reference (fetched and read), the health/recovery complications and
  their introducing API levels are —
  [Toybox.Complications API reference](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html):
  - `COMPLICATION_TYPE_SLEEP_SCORE` (42) — **since 6.0.2** — "non-negative number from 0 to 100"
  - `COMPLICATION_TYPE_LAST_GOLF_ROUND_SCORE` (41) — since 5.0.0
  - `COMPLICATION_TYPE_WHEELCHAIR_PUSHES` (40) — since 4.2.3
  - **[historical], all since 4.2.0**: `BODY_BATTERY` (23), `STRESS` (22), `RECOVERY_TIME` (21,
    minutes remaining), `PULSE_OX` (35), `RESPIRATION_RATE` (36), `HEART_RATE` (18),
    `TRAINING_STATUS` (26), `VO2MAX_RUN`/`VO2MAX_BIKE` (24/25), `INTENSITY_MINUTES` (5),
    `WEEKLY_RUN_DISTANCE`/`WEEKLY_BIKE_DISTANCE` (19/20), the four `RACE_PREDICTOR_*` (27-30)
    and four `RACE_PACE_PREDICTOR_*` (31-34), `STEPS`, `CALORIES`, `FLOORS_CLIMBED`, `BATTERY`,
    `SOLAR_INPUT` (37), weather/temperature/sunrise/sunset/calendar/notification types.
- **Absent from the complication list entirely** (verified, same reference): **Training
  Readiness**, **HRV / nightly HRV status**, sleep stages or sleep duration (only Sleep Score),
  Endurance Score, Hill Score, Acute Load / Training Load.
- Community confirmation of the Training Readiness gap: there is a
  `COMPLICATION_TYPE_TRAINING_STATUS` but no training-readiness complication, and developers
  ask for it to be added —
  [Garmin Forums thread](https://forums.garmin.com/developer/connect-iq/f/discussion/348762/how-do-i-include-the-training-readiness-value-in-my-own-watch-face)
  (search-summary sourced, but corroborated by the API reference above)
- Garmin's server-side **Health API** exposes a broader set than the on-watch API — Body Battery
  (0-100, derived from HRV, stress and sleep), daily stress score, resting HR, nightly HRV and
  sleep data — i.e. a metric being computed by Garmin does not imply on-device availability to
  a watch face —
  [Open Wearables, Garmin Connect API developer guide](https://openwearables.io/blog/garmin-connect-api-developer-guide-activities-health-metrics)
  (search-summary sourced)
- **[historical]** Complications as a mechanism (system + user complications, `getType()`
  returning `COMPLICATION_TYPE_INVALID` for user complications) dates to API 4.2.0 —
  [Complications core topic](https://developer.garmin.com/connect-iq/core-topics/complications/),
  [Complication API reference](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications/Complication.html)
- Sleep is a visible user pain point beyond the API: Garmin built a seasonal **World Sleep Day
  2026** face set, and there are active user threads on sleep-face behaviour when sleep mode is
  off —
  [fēnix 7 forum thread](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-7-series/435245/sleep-watchface-when-the-sleep-mode-is-off/2053711)
- Adjacent signal: Apple's redesigned Face Gallery makes **Health and Fitness** its own
  top-level face category —
  [MacRumors watchOS 26 roundup](https://www.macrumors.com/roundup/watchos-26/)

### Inferences
- Sleep Score (API 6.0.2, SDK support 2026-06) is the only genuinely *new* health surface in
  the window; most published faces predate it, so surfacing it natively is currently a
  differentiator — but only on devices/firmware at API 6.0.2 or above.
- The Training Readiness and HRV omissions are the clearest *unfillable* demands: a face
  promising either must approximate from exposed components (Body Battery + Sleep Score +
  Recovery Time + Stress) and say so, or wait on Garmin.
- Because recovery-flavoured metrics (Body Battery, Stress, Recovery Time) have been available
  since 4.2.0, "we expose Body Battery" is not a differentiator — presentation is. The gap is
  in how these are composed/visualised, not in access.

### Gaps
- No quantitative ranking of which metrics users most want on the face (no survey, no poll data
  found in the window). Claims about user interest here are qualitative/forum-level only.
- Which shipping devices/firmware actually reach API 6.0.2 (and therefore expose Sleep Score)
  is not established here — needs the device compatibility matrix in the SDK.

## Q3. Garmin hardware/software shifts that change what a watch face should look like

### Takeaway
Two hard facts dominate: **fēnix 9 / 9 Pro (2026-08-25) with a 3,000-nit AMOLED**, and the
System 8 / SDK 8.x-9.x line that added configurable faces, 16 MB code space and Sleep Score.
Separately, Garmin moved store purchase/management into the mobile app and the developer
dashboard to a new domain.

### Cited Findings
- **fēnix 9 and fēnix 9 Pro, announced 2026-08-25, "available now"** — verified directly from
  the press release (fetched and read):
  - Both lines in **43 / 47 / 51 mm**. fēnix 9 from **$999.99**, fēnix 9 Pro from **$1,099.99**.
  - **fēnix 9: AMOLED, "twice as bright as its predecessor."**
  - **fēnix 9 Pro: AMOLED "up to 3,000 nits of brightness."**
  - **fēnix 9 Pro 51 mm: "first 1.5-inch AMOLED display, extending the display by 15%"** — the
    largest CIQ watch-face canvas Garmin has shipped.
  - Battery: fēnix 9 Pro up to 31 days smartwatch mode; solar models up to 57 days; largest
    fēnix 9 up to 29 days. Satellite + LTE built into fēnix 9 Pro across all three sizes
    (plan required, not all regions). Solar on select Pro models.
  - **No mention of MIP anywhere in the press release** — the pre-launch "MIP is back" leak is
    therefore unsupported by the official announcement.
  — [Garmin newsroom press release](https://www.garmin.com/en-US/newsroom/press-release/outdoor/garmin-expands-its-flagship-performance-smartwatch-lineup-with-fenix9-and-fenix9-pro/),
  [Wareable](https://www.wareable.com/garmin/garmin-fenix-9-pro-launch-announcement-release-date-price-features),
  [TechRadar live coverage](https://www.techradar.com/news/live/garmin-play-harder-fenix-9-live-event-august-2026)
- Same date appears on the Connect IQ announcements feed as new **device support for fēnix 9 /
  fēnix 9 Pro**, and the SDK page shows **Connect IQ 9.2.0, last updated 2026-08-25** —
  [Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements),
  [SDK page](https://developer.garmin.com/connect-iq/sdk/)
- SDK timeline in the window (all from the official announcements feed, same URL as above):
  - **8.3 — 2025-09-25**: activity filters for data fields; developer dashboard relocation
  - **9.2 — 2026-06-09**: Sleep Score complication; bonded BLE connections
  - **[historical]** 8.1.0 — 2025-03-04 (System 8); 8.2.1 — 2025-06-19 (data field setup flow,
    `SensorDelegate`, high-frequency sensor sync)
- **[historical] vívoactive 6 (2025-04-01)**: AMOLED, and a **modified action-view pattern —
  notch on the right side** — i.e. a layout constraint a face must respect; still current
  hardware —
  [Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements)
- **Store / distribution change**: the Connect IQ **mobile app becomes the sole route** for
  purchasing, installing or managing apps; the developer dashboard moved to
  **apps-developer.garmin.com**. **Date conflict, unresolved**: the announcements feed dates
  this **2025-11-20**, while a search-result summary of the same feed reported it as **June
  2026**. Neither source states an enforcement date separate from the announcement date —
  [Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements)
- **[historical] Trader Verification (2025-02-17)**: apps requiring payment are hidden until
  verification completes — a gate on any paid or IAP watch face, still in force — same source.
- Platform stability is a live issue: Garmin watch faces have been **crashing across an
  increasing number of models over recent months**, and Garmin has acknowledged it —
  [TechRadar](https://www.techradar.com/health-fitness/smartwatches/if-your-garmin-watch-faces-keep-crashing-youre-not-alone-and-garmin-is-working-on-it)
  (headline-level only; article body was behind a paywall/interstitial for the fetch tool)
- **[historical] Edge MTB (2025-06-17)** added as a CIQ target (5 Hz GPS, timing gates) — not a
  watch-face surface, listed for completeness — same announcements feed.

### Inferences
- A 3,000-nit AMOLED flagship raises the ceiling for colour and contrast design but makes the
  always-on/low-power state *more* consequential for burn-in and battery, not less.
- 16 MB code space (System 8) removes the historical size ceiling that forced faces to strip
  fonts and bitmaps; richer typography and animation are now mechanically affordable.
- The mobile-app-only store route means discovery happens on a phone screen, so store
  screenshots and the face's appearance at thumbnail size carry more weight than before.

### Gaps
- **No figure found for AMOLED vs MIP share of the active Garmin installed base.** Analyst
  reports in the window (Counterpoint, Omdia) break down by brand, not by display technology.
  A leak suggested MIP returning in part of the fēnix 9 line
  ([TechRadar leak coverage](https://www.techradar.com/health-fitness/fitness-trackers/garmin-fenix-9-details-leak-and-if-true-were-getting-three-new-watches-but-the-most-interesting-part-of-this-reveal-is-about-garmins-screen-technology)),
  but that is pre-announcement rumour and is not confirmed by the Garmin press release above —
  treat as unverified.
- Could not map **SDK versions to API levels** in general (per-symbol API levels are in the API
  reference — e.g. Sleep Score = 6.0.2 — but there is no published SDK-version ↔ API-level
  table, and no device list per API level was retrieved), and
  a developer thread specifically asks where to find release notes for non-latest major versions
  ([forum thread](https://forums.garmin.com/developer/connect-iq/f/discussion/287180/where-to-find-connect-iq-api-release-notes-what-is-new-for-non-latest-major-version)).
- The watch-face crash issue's scope (which models, which firmware, whether third-party faces
  specifically) is unconfirmed — only the headline was retrievable.

## Q4. Adjacent-ecosystem trends Garmin users are asking for

### Takeaway
Apple's watchOS 26 Liquid Glass (translucency, fluid numerals, dynamic colour) is the loudest
adjacent aesthetic, and Wear OS moved to version 7 (Android 17) in June 2026. Direct evidence
of *Garmin users specifically requesting* these is thin in what I could retrieve.

### Cited Findings
- **watchOS 26** (2025-09-15; a search-result summary instead gave "June 2026" — 2025-09-15 is
  the better read, corroborated by 9to5Mac covering watchOS **26.5** in May 2026, but the
  conflict is noted): Liquid Glass design language — translucent, glass-like elements,
  "most visible with select watch faces, the Smart Stack, and Control Center"; fluid numerals,
  dynamic colour orbs, location-aware transitions —
  [MacDailyNews](https://macdailynews.com/2025/09/15/apple-releases-watchos-26/),
  [MacRumors 26 new features](https://www.macrumors.com/guide/watchos-26-new-features/),
  [the5krunner face guide](https://the5krunner.com/2025/11/03/watchos-26-apple-watch-faces-guide/)
- **Wear OS 7, based on Android 17, released 2026-06-16** —
  [Wear OS (Wikipedia)](https://en.wikipedia.org/wiki/Wear_OS)
- Third-party watch faces on **Pixel and Galaxy** watches were broken by a display bug —
  a cross-ecosystem reminder that always-on/ambient handling is where third-party faces fail —
  [PhoneArena](https://www.phonearena.com/news/display-bug-breaking-third-party-watch-faces-on-pixel-and-galaxy-watches_id176990)
- Samsung's **Watch Face Studio 1.7.9** continues as the no-code Wear OS face authoring tool —
  [Samsung developer forum](https://forum.developer.samsung.com/t/watch-face-studio-1-7-9/34169)
- Market context for "what Garmin users are coming from / comparing to" — **Q2 2026**
  (Counterpoint, reported 2026-09-09): Huawei 22% (record), Apple 20.1% (+14%), imoo 7.8%,
  Xiaomi 6.1% (-38%), **Garmin 5.6% (+11%)**, others 38.5%; total market **-4%**, the first
  quarterly fall in a year; 2026 forecast +1%, then ~3%/yr to 2030 —
  [the5krunner, 2026-09-09](https://the5krunner.com/2026/09/09/smartwatch-shipments-q2-2026/),
  [Counterpoint tracker](https://counterpointresearch.com/en/insights/global-smartwatch-shipments-market-share),
  [Android Headlines](https://www.androidheadlines.com/2026/09/global-smartwatch-sales-q2-2026-counterpoint-report-huawei-apple.html)
  — **note the methodology conflict**: Omdia puts Garmin at ~15% for the same period because it
  categorises budget/basic devices differently (per the5krunner). Do not quote either number as
  "Garmin's share" without the source attached.
- Counterpoint attributes Garmin's growth to "strong demand for its **high-end outdoor and
  sports watches**" — same sources.

### Inferences
- Garmin growing 11% while the overall market fell 4%, driven by high-end outdoor/sport models,
  means the addressable audience for a paid Garmin face is skewing toward expensive AMOLED
  flagships — consistent with prioritising AMOLED-first design.
- Liquid Glass translucency is largely unusable as-is on a Garmin always-on state (it depends on
  layered blur that costs pixels and power); the transferable parts are fluid/oversized numerals
  and dynamic colour, not the glass effect.

### Gaps
- I found **no reliable primary source** (r/Garmin thread, Garmin forum wishlist thread) in the
  window documenting Garmin users explicitly asking for Apple/Wear OS face features. Searches
  returned listicles and affiliate pages, which were excluded per the constraints. This is a
  real gap, not an absence of demand — it needs direct Reddit/forum browsing rather than search.
- No Fitbit-specific findings in the window; Fitbit's face ecosystem did not surface in any
  retrieved source.
- No data on paid-vs-free conversion or pricing norms for third-party faces on any platform.

## Source-quality notes for the report writer
- **Pages actually fetched and read (5):** Connect IQ News & Announcements feed;
  developer.garmin.com SDK page (9.2.0 / 2026-08-25); `Toybox.Complications` API reference
  (full constant table with API levels); Garmin newsroom fēnix 9 press release; the5krunner
  Q2-2026 shipments. **All other citations are URLs taken from search-result summaries and were
  not individually retrieved** — verify before quoting.
- Secondary but reputable: the5krunner, Wareable, MacRumors, 9to5Mac, Android Headlines.
- Retrieval failures (claims flagged inline, not built upon): Notebookcheck (403), TechRadar
  crash article (body not retrieved), developer.garmin.com Complications / UX-guidelines /
  AMOLED-FAQ pages (JS-rendered, nav only).
- Deliberately excluded per constraints: "best Garmin watch faces 2026" listicles
  (watchfacekit.com, gelberhut.com, alibaba buying guide, Tom's Guide round-up used only as
  labelled opinion).
