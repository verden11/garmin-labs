# Garmin Connect IQ Platform Constraints and Monetization Rules (watch faces)

> **⚠ PARTIALLY SUPERSEDED.** Several claims in this file were later refuted or
> corrected by browser-rendered verification against Garmin's own pages. **Read
> `verification.md` alongside this file; it wins on conflict.** Superseded claims are
> flagged inline below. A summary table of every correction is in
> `../../reports/Garmin watch face market gap.md`.

Research date: 2026-09-22. Version-dependent facts are tagged with the SDK version they come from.

---

## What a watch face cannot do

Feasibility filter. Every bullet is sourced in the sections below.

- **Cannot animate or update continuously while worn.** In low-power mode (entered ~10 s after the user stops interacting) `onUpdate()` is called **once per minute**; timers and animations are unavailable. Per-second drawing only exists in the ~10 s high-power window after a raise-to-wake or app exit. — [WatchFace class docs](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html)
- **Cannot redraw the whole screen every second.** The per-second `onPartialUpdate()` path is budgeted (community-reported ~20 ms of execution and a device power budget); exceeding it causes the system to call `onPowerBudgetExceeded()` instead of drawing, and repeated overruns disable partial updates. — [WatchFace class docs](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html); [forum](https://forums.garmin.com/developer/connect-iq/f/discussion/233662/watch-face-advice-desired-for-several-topics-layout-partial-update-resource-handling)
  > **SUPERSEDED (verification.md):** this path is **MIP-only**. Garmin: "With AMOLED screen,
  > this is no longer allowed." The ~20 ms figure is forum-sourced; `WatchFacePowerInfo` reports
  > `executionTimeAverage` / `executionTimeLimit` per device instead.
- **Cannot light more than ~10% of pixels on AMOLED always-on.** In AMOLED always-on (AOD) mode the face updates only once per minute and **each update may use at most 10% of available pixels**. — [Garmin UX guidelines: Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
  > **SUPERSEDED (verification.md):** 10% of *pixels* applies to the original Venu only.
  > **Since the Venu 2 the rule is "less than 10% of the screen's luminance".** Also: no pixel
  > may stay lit more than 3 consecutive minute-updates; violating either blanks the screen.
- **Cannot use bright/white-heavy AOD designs.** Garmin's own guidance is light grey over white/bright blue, thin fonts, and shifting static elements up to 4 px per minute for burn-in. Practically a design constraint, but store review and user complaints enforce it. — [UX guidelines](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- **Cannot make a web request from the watch-face (foreground) process.** Network access is only possible from a **background service**, with `Communications` permission, HTTPS only (unless the server is the paired phone). — [forum: Watch Face, Background makeWebRequest](https://forums.garmin.com/developer/connect-iq/f/discussion/194104/watch-face-background-makewebrequest); [Garmin FAQ: background service](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-create-a-connect-iq-background-service/)
- **Cannot poll the network often.** Background temporal events for a watch face fire **at most once every 5 minutes**, the background process gets ~32 KB of memory and is killed after ~30 s. So: no live/streaming data, no sub-5-minute freshness. — [forum](https://forums.garmin.com/developer/connect-iq/f/discussion/194104/watch-face-background-makewebrequest)
- **Cannot rely on a phone being reachable.** Requests only succeed when the paired phone has Garmin Connect running and BLE is up; a watch face must degrade gracefully to cached values.
- **Cannot exceed the per-device memory ceiling** (code + all loaded resources, fonts, strings and settings count against it). Watch-face budgets are per-device and far smaller than phone-app expectations — e.g. fēnix 5 = **92 KB** for a watch face. Authoritative value is per device in the SDK's device XML / `compiler.json`. — [Garmin blog: improve your app performance](https://www.garmin.com/en-US/blog/developer/improve-your-app-performance/)
- **Cannot run heavy computation.** There is an execution watchdog; long-running `onUpdate` work triggers a watchdog/"code executed too long" termination, and on partial updates the budget mechanism above applies.
- **Cannot ship one binary for every device.** Each target device must be listed in the manifest and built/tested; screen shape, resolution, colour depth and memory all differ (see device landscape).
- **Cannot use newer APIs on older watches.** API level gating is hard: Connect IQ 9 features require **API level 6.0**, which excludes Forerunner 965/265, fēnix 7/7 Pro, Venu 3, Instinct 3. Complications need **4.2.0+**; the Sleep Score complication needs **6.0.2**. — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html); [the5krunner CIQ 9 (secondary)](https://the5krunner.com/2026/06/11/garmin-connect-iq-9/)
  > **SUPERSEDED (verification.md):** the "Connect IQ 9" framing is UNVERIFIABLE — no
  > Garmin page uses a 9.x label. **Instinct 3 is API 6.0 and is NOT excluded.** FR965/265,
  > fēnix 7/7 Pro and Venu 3 at 5.2 is correct. Monetization is NOT gated on 6.0: Garmin's
  > monetized-device list has an "API Level 5.2" tier including FR965.
- **Cannot read the training/performance metrics directly.** Sleep score, recovery time, training status, VO2 max and race predictors are exposed **only through the Complications subscription API** (API 4.2.0+, sleep score 6.0.2+); on older devices they are simply unavailable. Training readiness is **not** in the published complication list. (Body Battery and stress are the exception — they *are* directly readable via `SensorHistory` since API 3.3.0.) — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html); [Toybox.SensorHistory](https://developer.garmin.com/connect-iq/api-docs/Toybox/SensorHistory.html)
- **Cannot get raw/historical sleep or HRV on-watch.** Sleep and HRV detail live in the Garmin **Health API** (server-side, separate partner program), not in the on-device SDK. — see Q4 below.
- **Cannot sell itself in-app.** There is no documented in-app purchase / paywall API; monetization is a store-level price on the app listing (see Q5).
  > **CLARIFIED (verification.md):** Garmin states verbatim: "The app trials feature is not
  > supported for watch faces." The absence is a platform exclusion, not an undocumented gap.
- **Cannot be distributed outside the Connect IQ Store** for normal users — the developer agreement has Garmin act as the developer's agent for CIQ Store distribution; sideloading is a developer/dev-key path only. — [Garmin Connect IQ Agreement §II.b](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Cannot show ads or paid push.** Push notifications that require payment, advertise, or carry sensitive info are prohibited. — [Agreement, Exhibit A.IV](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Cannot collect location by default.** Location data collection requires explicit user opt-in. — [Agreement, Exhibit A.I.c](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Cannot count on being published.** Garmin "may refuse to upload or remove your Application for any reason", even if all requirements are met. — [Agreement §II.a.5](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)

---

## Q1: Hard technical limits on a Connect IQ watch face

### Takeaway
A watch face is a once-per-minute, few-kilobyte, no-network foreground process with an optional 1 Hz clipped partial-update path under a strict power budget, plus a separate ≤5-minute, ~32 KB background service that is the only place network access happens.

### Cited Findings
- High power mode: entered on wrist raise or on returning from an app; `onUpdate()` called **every second**; timers and animations allowed. Low power mode begins after ~10 s; `onUpdate()` **once per minute**, `onPartialUpdate()` for the other 59 s if supported; timers and animations unavailable. — [Toybox.WatchUi.WatchFace](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html)
- `onEnterSleep()` must terminate timers; `onExitSleep()` may start them. The app's initial view **must extend `WatchFace`**. — [WatchFace docs](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html)
- If a partial update exceeds the device power budget, the system calls **`onPowerBudgetExceeded()`** instead of drawing; developers should set a clipping region to minimise the updated area. — [WatchFace docs](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html)
- Partial updates "must operate under a 20-millisecond time frame", which does not allow updating the whole screen. — [Garmin forum discussion](https://forums.garmin.com/developer/connect-iq/f/discussion/233662/watch-face-advice-desired-for-several-topics-layout-partial-update-resource-handling) *(forum, not formal docs — the formal doc states only the budget mechanism)*
- AMOLED always-on: "the watch face will only update every minute, and each update is limited to using 10% of the available pixels of the display." Burn-in guidance: light grey rather than white/bright blue, thin fonts, shift static elements up to 4 px per minute. — [UX guidelines: Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- Memory ceiling is per-device and per-app-type; the compiled app **plus all loaded resources** counts. Example: fēnix 5 = 92 KB watch face / 28 KB data field; limits live in the device `.xml` in the SDK folder. Custom fonts, localisation strings and settings can push you over on smaller devices. — [Garmin developer blog](https://www.garmin.com/en-US/blog/developer/improve-your-app-performance/)
- Order of magnitude on newer devices: developer discussion of fēnix 8 reports *data field* budgets dropping from 262144 B (fēnix 7) to 131072 B on fēnix 8 43 mm, while allowing 4 simultaneous data fields instead of 2 — i.e. budgets are in the 100–250 KB range on flagship hardware, not megabytes. — [forum: Fenix 8 data field](https://forums.garmin.com/developer/connect-iq/f/discussion/382120/fenix-8-data-field) *(developer-reported, data-field figures; see Gaps — I could not verify a watch-face-specific number for fēnix 7/8)*
- Network from a watch face: `makeWebRequest` can **only** be called from the background process, not the foreground; needs the Communications permission; HTTPS required unless the server is the phone. Background runs at most every **5 minutes**, has ~**32 KB** memory and is killed after ~**30 s**. — [forum thread](https://forums.garmin.com/developer/connect-iq/f/discussion/194104/watch-face-background-makewebrequest); [Garmin FAQ: How do I create a Connect IQ background service](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-create-a-connect-iq-background-service/)
- Device-level install limits exist (number of CIQ apps/faces per device varies by model). — [Garmin support: Connect IQ App Limits on a Garmin Device](https://support.garmin.com/en-US/?faq=tFmJJnTfs83yuPc8kttAh7)

### Inferences
- The 10%-pixel AOD rule plus once-per-minute redraw means an always-on face is effectively a sparse, mostly-dark layout; "rich dashboard always visible" is not achievable on AMOLED.
- The 5-minute background floor + 32 KB + no foreground networking means any product idea requiring live external data (messages, live scores, streaming prices) is out; cached-and-stale is the only shape.
- Memory is the binding constraint for feature-rich faces: images and custom fonts, not logic, are what blow the budget.

### Gaps
- The 20 ms partial-update figure is forum-sourced; I did not find it stated as a number in current Garmin documentation (docs describe the budget qualitatively via `onPowerBudgetExceeded`). Treat the exact millisecond value as unverified.
- I did not find a single authoritative published table of per-device watch-face memory ceilings; Garmin's own answer is "read the device XML in your SDK version". The only Garmin-published watch-face figure I have is fēnix 5 = 92 KB. A widely repeated "128 KB watch-face RAM on fēnix 7/7 Pro/8" figure appeared only in a search-engine synthesis that was visibly conflating watch-face and data-field budgets — **treat it as unverified**.
- Exact foreground watchdog timeout value: not verified from Garmin docs.

---

## Q2: API level fragmentation and current SDK

### Takeaway
As of 2026-09 the current line is **Connect IQ 9.x** (9.2.0, 9 June 2026); its headline features require **API level 6.0**, which large installed-base watches (FR965, FR265, fēnix 7/7 Pro, Venu 3, Instinct 3) do **not** have. Broad device support means coding to roughly API 3.x–4.2 and treating everything newer as optional.

### Cited Findings
- **Connect IQ 9.2.0** is available via SDK Manager; adds bug fixes, **Sleep Score complication support for watch faces**, and bonded BLE connections. Reported release date **9 June 2026**; initial 9.1.0 in **March 2026**, and CIQ 9 was not formally announced on the forum. — [the5krunner, 2026-06-11 (secondary source)](https://the5krunner.com/2026/06/11/garmin-connect-iq-9/); corroborated by search snippets of [Garmin forum News & Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements)
- Connect IQ 9 requires **API level 6.0**. Supported: fēnix 8 (all variants), fēnix E, Enduro 3, Forerunner 570/970, Venu 4/X1, vívoactive 6, D2 Mach 2 Pro, plus Edge 540/840/1040/1050/550/850/MTB. Excluded: **Forerunner 965, Forerunner 265, fēnix 7/7 Pro, Venu 3, Instinct 3**. — [the5krunner (secondary)](https://the5krunner.com/2026/06/11/garmin-connect-iq-9/)
- Prior releases: **8.3.0 — 25 Sep 2025** (data-field activity filter, API 5.2 devices); **8.2.1 — 19 Jun 2025** (System 8 devices, SensorDelegate pairing, high-frequency accel/gyro/mag); **8.1.0 — 4 Mar 2025**; **8.1.1 — 1 Apr 2025** (vívoactive 6); **8.4.0 — 3 Dec 2025**. — [Garmin forum News & Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements); [forum: Connect IQ SDK 8.4.0](https://forums.garmin.com/developer/connect-iq/f/discussion/427394/connect-iq-sdk-8-4-0)
- Device families span API levels **1.4 → 6.0** (fēnix, Forerunner), 3.3–6.0 (Venu), 3.4–6.0 (Instinct), 2.4–5.1 (Approach), 3.1–5.1 (Descent), 1.4–5.2 (D2). — [Connect IQ compatible devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- Complications API exists **since API 4.2.0**; sleep score complication needs **6.0.2**; wheelchair pushes 4.2.3. — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html)

### Inferences
- The fragmentation cost is concrete: supporting FR965/fēnix 7-class watches (huge installed base, and the user's own FR965 test device) rules out every CIQ 9 / API 6.0 feature and the Sleep Score complication.
- A "broad support" watch face realistically targets API ~3.x baseline with 4.2 complications behind capability checks — i.e. ship the same visual design with feature detection, not two codebases.

### Gaps
- Garmin's own CIQ 9 release-note page was not retrievable in this session; the 9.x version/date/device-list facts rest on the5krunner plus forum snippets. **Verify the exact current SDK version and API-6.0 device list against developer.garmin.com/connect-iq/sdk before relying on them.**
- No public data on installed-base share per API level; Garmin does not publish it.

---

## Q3: Device landscape

### Takeaway
Two display worlds (MIP and AMOLED), round dominant, resolutions from 166×166 to 486×448, with fēnix / Forerunner / Venu / Instinct / vívoactive carrying the volume. AMOLED is where the newer devices and the AOD constraints are.

### Cited Findings
- Families and specs: **fēnix** API 1.4–6.0, MIP (16/64 colour) or AMOLED, 218×218 → 466×466 round; **Forerunner** API 1.4–6.0, MIP or AMOLED, 208×208 → 454×454; **Venu** API 3.3–6.0, AMOLED or transflective LCD, 240×240 → 486×448 (rectangle and round); **Instinct** API 3.4–6.0, MIP 2-colour, 166×166 → 416×416; **Descent** API 3.1–5.1, incl. 176×176 semi-octagon; **Approach** API 2.4–5.1; **D2** API 1.4–5.2. — [Connect IQ compatible devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- Garmin's own guidance: pick priority devices early, "not all designs can scale to all devices"; displays range from 8-colour to 64-colour to AMOLED, and "you can choose to only support the devices that use the technology that works best for your watch face." — [UX guidelines: Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- Newest-generation AMOLED devices (fēnix 8, FR570/970, Venu 4/X1, vívoactive 6) are the API 6.0 tier. — [the5krunner (secondary)](https://the5krunner.com/2026/06/11/garmin-connect-iq-9/)

### Inferences
- Highest-leverage target set: fēnix 7/8, Forerunner 2xx/9xx (both MIP and AMOLED generations), Venu 3/4, vívoactive 5/6 — this spans both display technologies and requires two visual treatments (AOD-safe sparse for AMOLED, full-detail for MIP).
- Instinct's 2-colour MIP and the semi-octagon Descent shapes are effectively separate design projects; skip unless the concept is monochrome-native.

### Gaps
- No per-model sales/installed-base numbers from Garmin; "worth targeting" is inference from family breadth, not from published volume data.
- Per-device memory tiers are not in the compatible-devices table; they must be read from the SDK device XML.

---

## Q4: Data available to a watch face vs restricted

### Takeaway
Steps/calories/HR-class data is directly available on-device; the premium Garmin metrics (Body Battery, stress, sleep score, recovery time, training status, VO2 max, race predictors) are reachable only via the **Complications API (4.2.0+)**, and deeper sleep/HRV analytics live in the server-side **Health API**, not the watch SDK.

### Cited Findings
- `Toybox.Complications` (since **API 4.2.0**) exposes types covering: **body battery, stress level, sleep score, heart rate, pulse ox, respiration rate**, steps, calories, floors, intensity minutes, wheelchair pushes, weekly run/bike distance, **recovery time, training status**, VO2 max (run/bike), 5K/10K/half/marathon race predictors and race paces, weather (current + 3-day forecast, high/low temp), sunrise/sunset, altitude, sea-level pressure, solar input, battery %, calendar events, notification count, date formats, last golf round score. — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html)
- Sleep score complication requires **API 6.0.2**; CIQ 9.2.0 added "support for the Sleep Score complication for watch faces". — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html); [forum News & Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements)
- **`Toybox.SensorHistory` gives direct, non-complication access** to: `getHeartRateHistory()`, `getPressureHistory()`, `getElevationHistory()`, `getTemperatureHistory()` (all **API 2.1.0**), `getOxygenSaturationHistory()` (**3.2.0**), **`getBodyBatteryHistory()` and `getStressHistory()` (both API 3.3.0)**. Each takes `:period` and `:order`; "the amount of information that is available is device dependent." — [Toybox.SensorHistory](https://developer.garmin.com/connect-iq/api-docs/Toybox/SensorHistory.html)
- `ActivityMonitor.Info` exposes at least `steps` and `calories` in Garmin's own example; the full field list is on the `ActivityMonitor.Info` sub-page, which I did not retrieve. — [Toybox.ActivityMonitor](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityMonitor.html)
- Sleep score/quality, and health-snapshot data (HR, **HRV**, Pulse Ox, respiration, stress) are available through Garmin's **Health API** — a separate, server-side/partner API, not the on-device Connect IQ SDK. — [DC Rainmaker, Garmin Connect IQ platform round-up (secondary)](https://www.dcrainmaker.com/2021/10/garmins-connect-platform.html)
- Connect IQ 9 adds read access to stored **heart rate zones, power zones, FTP and sport profiles** without user re-entry (API 6.0). — [the5krunner (secondary)](https://the5krunner.com/2026/06/11/garmin-connect-iq-9/)
- Location data collection requires explicit user opt-in; unauthorised retention or sale of user data is prohibited; developers must publish a privacy policy and store user data only on servers they own/control. — [Agreement, Exhibit A.I–II](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)

### Inferences
- **Body Battery and stress are the two premium-feeling metrics available without complications** (SensorHistory, API 3.3.0) — that makes them the only "Garmin-special" data a broadly-compatible watch face can build on. Everything else premium (sleep score, recovery time, training status, VO2 max, race predictors) is complication-gated at 4.2.0+.
- **Training readiness is not in the published complication type list** — any product idea depending on it should be treated as not available to a watch face until proven otherwise.
- Anything requiring longitudinal health analytics (trends over weeks, HRV baselines) needs a companion/server leg via the Health API and a background service, which collides with the 5-minute/32 KB background limits.
- Because complications are 4.2.0+, a face built around Body Battery/stress silently loses its core feature on older devices — capability checks and a fallback layout are mandatory.

### Gaps
- The complete `ActivityMonitor.Info` field list (floors, intensity minutes, distance, active minutes, HR) and the `UserProfile` field list were not retrieved — the parent pages don't enumerate them. Steps and calories are confirmed; the rest is unverified.
- Whether "training readiness" is exposed anywhere in the on-device SDK: unverified (absent from the complication list I retrieved).
- Health API terms, eligibility and cost: not researched here.

---

## Q5: Monetization — Garmin's own documentation

### Takeaway
**Yes — Garmin runs a first-party Connect IQ monetization system.** Developers onboard as merchants for a **$100/yr non-refundable fee**, must have a legal entity in the **US, Canada, Australia, Singapore or most of the EU**, and **Garmin takes 15% of the tax-exclusive price**. External payment processors are contemplated (and constrained) by the developer agreement rather than banned outright. **No in-app-purchase API was found; treat IAP as unavailable/unverified.**

### Cited Findings
- **Revenue share: Garmin retains 15% of the tax-exclusive price point.** Garmin adds sales tax on top, handles credit-card fees, and withholds digital service taxes and currency conversion costs from payouts. — [Garmin: Monetization — App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- **Buyer regions:** Americas (US, Canada, Latin America), Africa, Europe, APAC; "This list is subject to change." — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- **Payouts:** first day of every month; separate payouts from Garmin International (US/Canada sales) and Garmin Europe (other regions); **$10 USD minimum balance**; funds not captured until 48 h after purchase; purchases in the last five days of a month roll into the next month's payout. — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- **Price points:** tiers run from **USD $2.00 to USD $100.00**, published in **16 currencies** (ARS, AUD, CAD, CHF, CZK, DKK, EUR, GBP, MXN, NOK, NZD, RON, SEK, THB, USD, VND), localised rather than converted (e.g. the $5.00 tier is €5.99 and NZ$8.75), with some territory splits (Greenland vs Denmark for DKK; Gibraltar vs UK for GBP). The page does **not** mention free tiers or trial periods. — [Garmin: Monetization — Price Points](https://developer.garmin.com/connect-iq/monetization/price-points/)
- **Price changes trigger a new review cycle.** Promo codes for migrating existing users from other systems are requested via Garmin's marketing form. — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- **Seller eligibility:** "United States, Canada, Australia, Singapore, and most of the European Union." Developers outside these regions cannot enroll. — [Garmin: Merchant Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/)
- **Program fee:** "an annual, non-refundable fee of $100 USD", paid during onboarding, via the developer dashboard's Merchant Account tab. Individuals supply photo ID + proof of address; organisations supply registration documents and tax info. Verification "can take several days". Changing entity type (individual ↔ organisation) after payouts start requires Garmin support and has tax consequences. — [Merchant Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/)
- **Agreement, "Monetizing" definition (§II.c.1):** collecting money or anything of monetary value connected to your app — for download access, feature use, **tips, donations**, or other reasons. Developers must accurately disclose payment requirements, fulfil all purchases, and **if using external payment processors must ensure the payment method is secure** (§II.c.1.A–C). — [Garmin Connect IQ Agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Agreement, Garmin merchant service (§II.c.2):** annual non-refundable fee plus percentage service fee; earnings subject to return policies with possible withholding/offset; documented payout schedule and minimum thresholds; tax documentation required, withholding taxes deducted, sales/VAT may be added. — [Agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Distribution (§II.b):** apps distribute through the CIQ Store with Garmin acting as the developer's agent. — [Agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Prohibited:** push notifications that require payment, advertise, or contain sensitive information (Exhibit A.IV); unauthorised Garmin branding or false affiliation claims; interfering with Garmin devices/platforms. — [Agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- **Store listing flag:** the app details page has a checkbox declaring whether the app "requests or requires payment"; historically (pre-monetization-system) developers used free apps + external donation links (e.g. a PayPal link in the description) or their own external payment mechanisms. Garmin staff in that thread noted user confusion when an app is flagged as paid but has no in-app way to pay. — [Garmin forum: App Monetization Guidelines](https://forums.garmin.com/developer/connect-iq/f/discussion/249835/app-monetization-guidelines) *(forum thread; predates the current monetization system — use only as context for the external-payment route)*
- Developers must be **at least 18** (age of majority). — [Agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html) (via search snippet)

### Inferences
- The 15% cut is materially better than Apple/Google's standard 30%, but the **$100/yr fee plus $10 payout minimum plus monthly payout lag** means low-volume faces can net nothing; break-even at a ~$2–3 price point is roughly 40–60 sales/yr before tax effects.
- Seller-country eligibility (US/CA/AU/SG/most EU) is a real filter for a solo developer — Lithuania is in the EU, so likely eligible, but "most of the European Union" is not an explicit list; **confirm the country list in the dashboard before planning on it**.
- External unlock/licence-key monetization is not forbidden by the agreement text retrieved — it is regulated (disclose, fulfil, secure the payment method). It remains the only route for a developer outside the eligible seller countries. This is an inference from §II.c.1's wording, not an explicit Garmin permission statement.

### Gaps
- **In-app purchase / trial periods: unverified, and probably absent.** I found no Garmin documentation describing an IAP API, a free-trial mechanism, or a refund/trial window. The Monetization section contains only Merchant Onboarding, App Sales, Account Management and Price Points, and the Price Points page mentions no free or trial tier. Do not assume IAP or trials exist. (Note the minimum price point is $2.00 — there is no $0.99 tier.)
- Whether Garmin's monetization system applies to **watch faces specifically** (vs apps only) was not explicitly confirmed on the App Sales page — it is written generically as "apps". Worth confirming.
- The 15% / $100 / country-list facts came through a text-extraction proxy of Garmin's own pages (the pages are JS-rendered and return only navigation to a plain fetch). The values are consistent across the proxy and independent search snippets, but a human should eyeball the live pages before making a business decision on them.
- Garmin's developer agreement was read in summarised form; exact clause wording on external payment is paraphrased, not quoted verbatim. **Read §II.c.1 in full before relying on the external-payment route.**

---

## Q6: Store submission and review

### Takeaway
Submission is via the developer dashboard; Garmin reviews before publication, reserves absolute discretion to refuse, and gives **no published SLA**. Real-world times range from a couple of hours to 10+ days.

### Cited Findings
- After upload, Garmin reviews the app; while pending, the app does not appear in the store; on approval the developer is notified and it appears for all users. — [Garmin: Submit an app](https://developer.garmin.com/connect-iq/submit-an-app/)
- "Garmin may, but is not obligated to, review your Application before it is uploaded to the CIQ Store, and Garmin may determine that your Application does not meet requirements or refuse to upload or remove your Application for any reason" (§II.a.5). Apps must comply with the Developer Guidelines and Application Requirements in Exhibit A. — [Agreement](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)
- Developers report non-beta updates approving in a couple of hours, but also **10+ day** waits, including beta submissions stuck ~11 days. — [forum: App approval process taking longer than usual (10+ days)](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/428068/app-approval-process-taking-longer-than-usual-10-days)
- **A price change re-triggers review.** — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Compliance obligations that gate review: privacy policy disclosing data practices; data retention limits and honouring deletion requests; user data stored only on developer-controlled servers; FDA/FCC/FTC compliance; no unauthorised regulatory/medical claims. — [Agreement, Exhibit A](https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html)

### Inferences
- Plan releases assuming a worst case of ~2 weeks, not hours — particularly around price changes and any listing that touches health claims.
- The "for any reason" clause plus health-claim restrictions means any face marketing a health interpretation (e.g. "recovery advice") carries real rejection risk.

### Gaps
- Garmin publishes no target or guaranteed review time; the timeline range here is developer-reported, not official.
- I did not retrieve a formal, itemised app-review checklist (screenshots, icon sizes, description rules) — the UX guidelines and Exhibit A are the closest published surfaces.
