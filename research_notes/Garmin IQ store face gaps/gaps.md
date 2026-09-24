# Garmin IQ store face gaps (as of September 2026)

Research notes, not a report. Independent redo. Store catalog pages at apps.garmin.com are JS-rendered and returned empty HTML in this pass — live store search counts could not be enumerated. Evidence is from Garmin developer docs, Garmin forums, Garmin Rumors (May 2025), Tom’s Guide (1 Mar 2026), GarminHub aggregator listings, Reddit/forum threads, and device manuals. Do not treat download buckets on GarminHub as exact counts.

**How to use this file:** each `##` is one key question. Cited Findings are sourced. Inferences are labeled as such. Gaps are unanswered. Ranked opportunities sit last.

**Date hygiene:** material from 2020–2024 is labeled older. May 2025 policy change is still binding as of this research (no reversal found). Tom’s Guide Glance review is 1 Mar 2026. Training-readiness API request still open as of ~Mar 2026 (forum “6 months ago” relative to fetch).

---

## What do Garmin users repeatedly ask for that the store does not serve well?

### Takeaway
Repeated demand clusters around: (1) native-quality data on a custom face without battery tax, (2) stock/Garmin-look faces that Garmin now either sells itself or rejects from third parties, (3) training-readiness and recovery metrics on the face, (4) on-watch customization. High-data dashboards are *served* (Glance) but users still complain they look dated, miss training stats, or cost money.

### Cited Findings
- Glance (free) is still the most-visible free face in 2026: 4.9/5 from 53K reviews; Tom’s Guide (1 Mar 2026) calls it the popular free option because “most of the watch faces I’ve tried cost $2–$5” and free faces are “becoming increasingly rare.” — [Tom’s Guide via Yahoo, 1 Mar 2026](https://tech.yahoo.com/wearables/articles/most-popular-free-garmin-watch-064500755.html)
- Same review: Glance is clear and AOD-readable, but looks dated on AMOLED, lacks weekly run distance / recovery time, and cannot be customized on-watch (Connect IQ app only). Portal Hybrid cited as more elegant paid alternative. — [same](https://tech.yahoo.com/wearables/articles/most-popular-free-garmin-watch-064500755.html)
- Glance Pro ($3.95) is a default “best faces” pick for large AMOLED (Venu 3, Fenix 7 Pro, Epix Pro): touch, extra metrics, AOD. — [Android Authority, 31 Jan 2025](https://www.androidauthority.com/garmin-watch-faces-3063702/)
- Glance won Garmin “best new watch face” 2022 (older). Free Glance; paid Glance Pro / Dual Screen add OpenWeather, Body Battery, Stress, graphs. Developer stated Body Battery/Stress were *not* available to 3rd parties at launch; hydration “even worse.” — [Garmin forums, Glance showcase](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance)
- Body Battery on the watch face was a multi-year native-face request (Fenix 6 thread, older, +15): users said even Garmin’s own faces omitted it; a reply claimed FirstBeat metrics were then unavailable to CIQ. — [Garmin forums, Body Battery on watch face](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/178925/body-battery-on-watch-face)
- Training Readiness on a custom face: developer thread, 5,023 views, still unanswered. jim_m_58: `COMPLICATION_TYPE_TRAINING_STATUS` exists; **no training-readiness complication**. Follow-ups “over 1 year ago” and “6 months ago” (~Mar 2026) still asking Garmin to add it. — [Garmin CIQ forum](https://forums.garmin.com/developer/connect-iq/f/discussion/348762/how-do-i-include-the-training-readiness-value-in-my-own-watch-face)
- Garmin’s own $4.99 FR970/570 replica face (May 2025): reviews cited no training readiness, no Body Battery even on supported devices, no on-watch edit, weak localization, one gradient. ~1K downloads, 3.2 stars at time of article. — [Garmin Rumors, 29 May 2025](https://garminrumors.com/garmin-selling-5-forerunner-970-570-watch-faces-while-rejecting-third-party-versions/)
- May 2025: Garmin rejected GreenBlack’s 970/570-inspired faces; “Future watchfaces can not use the original designs anymore.” Official Garmin All Stars – Instinct 3 Console still in store. — [Garmin Rumors, 27 May 2025](https://garminrumors.com/garmin-tightens-watch-face-policy-on-connectiq-store-dev-creations-rejected/); [Connect IQ listing](https://apps.garmin.com/en-US/apps/4385bccf-6ad4-44f4-b491-d2d41cedc9c5)
- Backlash that stock/Garmin-look faces are moving paid: Gadgets & Wearables (15 Dec 2025) “What used to be free is increasingly trickling into the paid tier”; Reddit thread exists (`r/Garmin` “Garmin stock watch faces are becoming mostly paid”). Full Reddit body not fetchable this pass. — [Gadgets & Wearables](https://gadgetsandwearables.com/2025/12/15/garmin-stock-watch-faces/); [Reddit](https://www.reddit.com/r/Garmin/comments/1pmh8is/garmin_stock_watch_faces_are_becoming_mostly_paid/)
- Tactix 8 owners (2025): built-in faces “colourfull but not usefull”; want Tactix 7 analog with many data fields; Fenix faces on Tactix “not looking tactical”; refuse to pay for Tactix faces they already “own.” Portal Pro named as CIQ stand-in. — [Garmin forums, Tactix 8](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/tactix-8/406443/tactix-7-watch-face-for-tactix-8)
- Instinct 3 Solar Tactical (2026 thread, “3 months ago”): cannot get dual time in the mini-window; UTC and Zulu both offered (redundant); Instinct 2 was easier. Later: *some* built-in faces can show alt time, default cannot. — [Garmin forums, Instinct 3 dual time](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-3/434978/dual-time-using-mini-window)
- Compass on a watch face: outdoor users want time + battery + date + elevation + heading + HR without leaving the face. Compass not available to watch faces except background (~every 5 min). GPS-on compass kills battery. — [Garmin CIQ forums](https://forums.garmin.com/developer/connect-iq/f/app-ideas/226886/how-come-no-watch-face-around-that-includes-compass-data)
- CIQ faces drain more than stock: FR945 thread (older, locked) ~1%/hr vs <0.5%/hr stock. Facebook Garmin Forum (26 Dec 2024): Venu 3 “Falcon X” 0.6%/hr vs 0.4–0.5%. — [FR945 forums](https://forums.garmin.com/sports-fitness/running-multisport/f/forerunner-945/241612/best-garmin-watch-faces); [Facebook group post](https://www.facebook.com/groups/garminforum/posts/2326208424405745/)
- CIQ watch-face crashes (“IQ!”) across Venu 3, FR965, Fenix 7/8 (Dec 2024 reporting; Storage.setValue bug; Garmin investigating). Unclear if fully closed by Sep 2026. — [Garmin Rumors, 2 Dec 2024](https://garminrumors.com/many-garmin-watches-crashing-with-connectiq-watch-faces)
- Developer privacy note (older): CIQ faces cannot read notification *content*, GPS tracks, name; alarm times only as count. — [r/GarminWatches](https://www.reddit.com/r/GarminWatches/comments/urgfkf/connectiq_watchface_privacy)

### Inferences
- “I want the new Garmin face on my old watch, with more fields and better AOD” is the loudest *commercial* request — and Garmin closed it to third parties in May 2025 while selling a weaker official clone. White space is **original** faces that *feel* native (data density, on-watch editor, AOD) without copying Garmin art.
- Training readiness on-face is still a live ask into 2026; if the API is still missing, this is a **true impossibility**, not an unbuilt product.
- Free + huge-type data dashboards are saturated at the Glance/Goals layer; the residual ask is *modern AMOLED aesthetics + training stats + on-device config*, not another Glance clone.

### Gaps
- Could not scrape Connect IQ store search result quality for “training readiness,” “dual time,” “G-Shock,” etc. (JS store).
- Could not read the Dec 2025 Reddit paid-faces thread body (blocked).
- Unknown whether `COMPLICATION_TYPE` for training readiness was added after ~Mar 2026; last public ask still negative.
- Crash-bug resolution status as of Sep 2026 not verified.

---

## Which aesthetics are saturated vs empty?

### Takeaway
Saturated: high-data digital dashboards, Garmin-stock clones (now policy-blocked for new submissions), generic analog. Thin/empty in *quality*, not always in listing count: dress/fashion, Bauhaus, cute/character (except official licensed $5 Disney/Marvel), Casio/G-Shock language, aviation/dive as *faces* (vs native Descent/D2 hardware), Apple-Watch-clone layouts on the new rectangular Venu X1.

### Cited Findings
- GarminHub “top/newest” mix (undated scrape in this research): Seasons (VAW.BE) 500,000-download bucket, 41,698 reviews; Chrono Collection I 500,000 bucket; Goals V/VII and Goals-with-trial 100,000 buckets; Glance Ultra 4.9 (1,298 reviews); Tactical Elite 10,000 bucket / 1,248 reviews; GreenBlack Fenix 8 V2 100,000 bucket / 2,163 reviews. Fashion-named paid faces (Moonlit Path, Lilac Whisper, Whisper Wreath, Golden Pride, Sky Whale, Reef Fish) show 0–10 download buckets and 0.0 ratings. — [GarminHub watch faces](https://garminhub.com/en/watch-faces)
- Analog is a first-class store category. — [Connect IQ analogWatchFaces](https://apps.garmin.com/en-US/apps/metaCategory/analogWatchFaces)
- GreenBlack built a business cloning Instinct 3 Tactical, Fenix, Epix, tactix looks; May 2025 policy killed *new* Garmin-design clones. Existing approved clones remain. Garmin sells official “All Stars” replicas ($4.99). — [Garmin Rumors 27 May 2025](https://garminrumors.com/garmin-tightens-watch-face-policy-on-connectiq-store-dev-creations-rejected/); [29 May 2025](https://garminrumors.com/garmin-selling-5-forerunner-970-570-watch-faces-while-rejecting-third-party-versions/)
- Garmin launched paid Disney/Marvel-style faces (~$5); Rumors framed user friction (“would you pay $5 for Darth Vader or Spider-Man”). — [linked from 27 May 2025 article](https://garminrumors.com/garmin-tightens-watch-face-policy-on-connectiq-store-dev-creations-rejected/)
- Reddit Jul 2025 “show me your face”: Fine O'Clock “[This is fine, animated]”; Easy+ for Venu 3 (two views, hold-for-second-screen). Character/animated exists but is novelty, not a category leader. — [r/Garmin](https://www.reddit.com/r/Garmin/comments/1mcccmk/show_me_your_awesome_watch_face_on_your_garmin)
- Indie WC2026 Live Pro (World Cup schedule face) posted on r/Garmin; comments note AMOLED AOD cannot be “full screen, just dimmed” because of Garmin’s pixel cap. — [r/Garmin WC2026](https://www.reddit.com/r/Garmin/comments/1txrj36/new_watch_face_wc2026_live_pro)
- Tom’s Guide 2026: Glance “reminds me of stock faces from older Garmin watches like the Forerunner 245 and doesn't suit the bright AMOLED displays, which are now standard.” Implies AMOLED-native *design language* is still behind hardware. — [Tom’s Guide, 1 Mar 2026](https://tech.yahoo.com/wearables/articles/most-popular-free-garmin-watch-064500755.html)
- Casio/G-Shock dual-time + sunrise/sunset is a *hardware* category (Casio manuals, Pro Trek sunrise/sunset). No Connect IQ G-Shock/Casio hit appeared in this search pass (results were Casio’s own sites). — [Casio dual time](https://support.casio.com/global/en/wat/manual/3567_en/NHCXSYmdubmtnn.html); [Casio Pro Trek sunrise](https://www.casio.com/intl/watches/protrek/technology/sunrisesunset)
- Facade (n0ano) is a dual-timezone *analog* CIQ face (327 cities, moon, HR, steps). Exists; not a store-category leader in aggregator lists. — [Facade](http://www.n0ano.com/garmin/facade.html)
- GitHub DualTime face: Fenix 6 battery-saver-inspired, two zones, on-device settings. 3 stars — hobby, not market. — [kolitiri/garmin-DualTime-app](https://github.com/kolitiri/garmin-DualTime-app)

### Inferences
- **Saturated (high evidence):** Glance-style infographic dashboards; Goals-style; Garmin-clone analogs (legacy listings); generic analog “sports watch.”
- **Policy-empty going forward:** new Fenix/FR/Instinct-stock clones. That is not a niche to enter.
- **Aesthetically empty or low-quality (medium evidence):** dress/fashion (tiny GarminHub buckets), Bauhaus/minimal analog that is not a Fenix clone, Casio/G-Shock digital-ana language, aviation/dive *as CIQ faces* (hardware SKUs exist; store faces not visible in aggregator top 100), Apple-like modular rectangles for Venu X1.
- Cute/character is not empty (Disney official + novelty) but is either licensed-paid or low-status. Competing with Disney on IP is a non-starter.

### Gaps
- No systematic tagging of store faces by aesthetic. GarminHub is a biased sample (English, ranked lists).
- No 2026 store search for “Bauhaus,” “G-Shock,” “dive,” “golf,” “hunter.”
- Instinct 3 AMOLED “Console” (Garmin All Stars) shows Garmin occupying retro-futurist / device-unique looks themselves.

---

## Which user segments are underserved?

### Takeaway
Strongest *watch-face* underservice: non-clone tactical/outdoor (Tactix, Instinct dual-time), Apple-switchers on Venu X1 (rectangular AMOLED, short AOD battery), and anyone who wants recovery/readiness on-wrist without a glance. Women, golfers, hunters, swimmers, climbers, parents, shift workers: Garmin sells *hardware or glances* for several of these; watch-face-specific demand is thin in public sources.

### Cited Findings
- **Women:** Lily (2021) and Lily 2 (2024) are Garmin’s fashion/small-wrist SKUs; women’s health is a *glance + Connect app*, not a watch-face metric. NYT (2021, older): “well over 50% of Lily customers are new to Garmin”; women buy more than half of Garmin’s generic wellness watches (Garmin statement, not independently audited). Pregnancy tracking shipped as a Connect IQ *app* (2020), not a face. — [NYT, 18 Jun 2021](https://www.nytimes.com/2021/06/18/fashion/watches-women-garmin-lily.html); [Garmin pregnancy PR, 10 Nov 2020](https://www.garmin.com/en-US/newsroom/press-release/sports-fitness/2020-garmin-delivers-pregnancy-tracking-feature); [Lily 2 PR, 8 Jan 2024](https://www.garmin.com/en-US/newsroom/press-release/wearables-health/garmin-brings-big-updates-to-its-small-stylish-lily-2-smartwatch-series); [Garmin women’s health tech page](https://www.garmin.com/en-US/garmin-technology/health-science/womens-health/)
- **Non-athletes who own Garmin:** r/Garmin Venu X1 thread (15 Jun 2025): “I’m a very active person, but I don’t run, cycle, or swim”; Venu line drew them in; X1 price/positioning confusion. Another user: square thin watch is “what I have wanted… a long, long time” — growth from Apple Watch switchers. — [r/Garmin Venu X1](https://www.reddit.com/r/Garmin/comments/1lc4712/my_thoughts_on_the_venu_x1_as_a_longterm_venu_user)
- **Tactical/outdoor:** Tactix 8 face complaints (above). Instinct 3 dual-time (above). Compass-on-face (above).
- **Golf:** Venu X1 manual lists Garmin Golf app; Approach line exists. No watch-face golf-demand thread found this pass. — [Venu X1 OM](https://www8.garmin.com/manuals/webhelp/GUID-C144B465-A0C8-4FE9-AFE6-41A3FE3F1D9A/EN-US/Venu_X1_OM_EN-US.pdf)
- **Shift workers / dual-life:** Instinct 3 dual-time thread; Garmin Alternate Time Zones is a *glance/widget*, not a default face field. — [Garmin support, alt time zones](https://support.garmin.com/en-US?faq=LgaK7iSBI87Njy0rRnkpd6); [Instinct 3 dual time](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-3/434978/dual-time-using-mini-window)
- **Older users / large type:** Glance’s whole pitch is large fonts (“visible at a glance”). That segment is *served* by Glance, not empty. — [Glance showcase](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance)
- **Hunters, swimmers, climbers, parents:** no watch-face-specific 2025–2026 threads found in this pass. Instinct moon/sunrise widgets exist as *glances*. — [Instinct moon/sunrise support](https://support.garmin.com/en-US?faq=12qlaFwRh6AaTwijC9rnnA)

### Inferences
- Do not build a “women’s health watch face” on blog-post vibes. Demand for *Lily-like dress faces on Fenix/Venu* is plausible but **thinly evidenced** in CIQ discussions (which skew male/athlete).
- Better-evidenced segments: Instinct/Tactix functional analog; Venu X1 Apple-switcher rectangular; recovery-focused athletes blocked by API; travelers/shift workers who want dual time *on the face*.
- Parents: notification *count* is possible; notification *content* is not (privacy). A “parent glance face” cannot show the text of the SMS.

### Gaps
- No gender/age breakdown of CIQ downloads.
- No hunter/golf/swim/climb face wishlist threads found — absence of evidence, not evidence of absence.
- Lily CIQ face catalog not inspected (store JS).

---

## Device gaps (MIP, Instinct, Venu X1, solar, AMOLED AOD)

### Takeaway
Two real hardware gaps: (1) **Venu X1 448×486 rectangle AMOLED, CIQ 6.0** (Jun 2025) — new canvas, Apple-Watch-like, 2-day AOD vs 8-day gesture; (2) **Instinct 3 Solar MIP** — unique bezel, solar, dual-time complaints, tactical exclusive faces. MIP always-active seconds are *possible* (partial update, 20 ms) but constrained. AMOLED AOD is a hard 10% pixel budget — that *is* the product constraint, not a missing face.

### Cited Findings
- Venu X1: 448×486, rectangle, AMOLED, CIQ 6.0. — [Garmin compatible devices](https://developer.garmin.com/connect-iq/compatible-devices?cve=title)
- Venu X1: 2" square AMOLED, $799.99, titanium, maps, flashlight, **no ECG, no multi-band GPS**; AOD ~2 days vs ~8 days AOD off; compared to Apple Watch Ultra 2. Manual (Jun 2026) documents Connect IQ watch faces. — [The Verge, 12 Jun 2025](https://www.theverge.com/news/686325/garmin-venu-x1-smartwatch-display-specs-pricing); [TechRadar, 12 Jun 2025](https://www.techradar.com/health-fitness/smartwatches/garmin-venu-x1-revealed-meet-the-surprise-new-apple-watch-ultra-2-rival-with-garmins-biggest-display-yet); [Forbes, 12 Jun 2025](https://www.forbes.com/sites/andrewwilliams/2025/06/12/garmin-venu-x1-takes-smartwatches-in-an-unexpected-direction); [Venu X1 OM v4, Jun 2026](https://www8.garmin.com/manuals/webhelp/GUID-C144B465-A0C8-4FE9-AFE6-41A3FE3F1D9A/EN-US/GUID-53DA7C2F-0B9F-497D-81F7-BE4CC06983BB.html)
- Instinct 3 AMOLED 45/50 mm listed on compatible-devices page; Instinct 3 50 mm Solar has a store watch-face URL. Instinct 3 AMOLED review: shipped with two un-editable faces until firmware. MIP glance-without-wrist-raise missed by some AMOLED buyers. — [Instinct 3 Solar store](https://apps.garmin.com/en-US/devices/Instinct3-50mm-s/appTypes/watchface/apps); [r/Garmin Instinct 3 review](https://www.reddit.com/r/Garmin/comments/1i58u3j/my_honest_review_after_a_few_days_with_the); [the5krunner: 10 built-in faces](https://the5krunner.com/2025/02/11/garmin-instinct-3-review-amoled-solar-e-compared/)
- **MIP always-active:** default 1/min; high-power ~10 s for seconds; always-active = partial update every second, **must finish in 20 ms**, not full redraw. — [UX guidelines: Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces) (content also in search excerpt of same URL)
- **AMOLED AOD:** update 1/min; **≤10% of pixels**; burn-in prevention; some devices disable gesture-to-high-power so AOD support is *expected*. Shift static pixels up to 4 px/min. — [same UX guidelines](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces)
- Watch faces have the **least API access**: graphics, bitmaps, fonts, activity tracker, battery, profile. **Cannot access compass, GPS, or other sensors.** Sleep mode: 1/min, no timers/animations. Raise-to-wake exits sleep. Poorly designed faces degrade battery. — [App types](https://developer.garmin.com/connect-iq/connect-iq-basics/app-types)
- Older Garmin comment (still the architecture): stock analog seconds can run on a low-power coprocessor; CIQ cannot. Low-power mode cannot be disabled. — [CIQ forum, watch hands](https://forums.garmin.com/developer/connect-iq/f/discussion/1289/watch-hands-disappear-after-10-seconds)
- Native on-device editor for CIQ faces: API 5.1.0 (Fenix 8+). Styles, data, data color, accent; **up to 4 saved configs**; `allowAny` complications including CIQ-published. — [Editing watch faces on device](https://developer.garmin.com/connect-iq/core-topics/editing-watch-faces-on-device)
- Instinct is **not** a rectangular display in Garmin’s device table (AMOLED 45/50 listed; Venu Sq / Sq 2 / X1 are the rectangles). User prompt “Instinct rectangular” is likely mixing Instinct’s octagonal bezel with Venu Sq/X1 rectangles. — [compatible devices](https://developer.garmin.com/connect-iq/compatible-devices?cve=title)

### Inferences
- **Venu X1-native layouts** (use the extra vertical pixels, Apple-like modular, AOD within 10%) are a time-limited opening: new SKU, expensive, Apple-switcher narrative, most round faces will look wrong if letterboxed.
- **MIP/solar Instinct** still wants always-readable, low-power, dual-time, outdoor fields — not AMOLED showpieces. Partial-update seconds are a differentiator *if* kept inside 20 ms.
- A “full-brightness always-on AMOLED face” is **impossible** under current rules. Marketing that implies it will fail review or battery.

### Gaps
- Live count of Venu X1–compatible faces: store page empty.
- Live count of Instinct 3 Solar faces: store page empty.
- Whether Fenix 9 / Enduro 4 / Tactix 9 (Sep 2026 rumors) change CIQ face requirements: not researched beyond Rumors homepage noise.
- Solar-specific drawing constraints (beyond MIP) not documented in fetched UX page.

---

## Feature gaps (sunrise/sunset, Body Battery + HRV, training readiness, women’s health, live activities, dual time, complications, weather radar, calendar, notification glance, data from other IQ apps)

### Takeaway
Split into **API-possible but rare**, **API-possible and common**, and **API-blocked / glance-only**. Training readiness and live compass/GPS are the clearest blocked-or-missing APIs. Body Battery moved from blocked (older) to available in paid Glance-class faces. Dual time, sunrise/sunset, calendar *counts*, CIQ-to-CIQ complications are possible. Weather radar and notification *content* are not realistic on a face.

### Cited Findings
**Possible / documented**
- Complications: publish/subscribe; **only watch faces subscribe**; device apps and audio providers may publish **up to 4**; Face It consumes CIQ complications; hold-to-press can `Complications.exitTo`. — [Complications](https://developer.garmin.com/connect-iq/core-topics/complications)
- Example native types in editor docs: `COMPLICATION_TYPE_STEPS`, `HEART_RATE`, `CURRENT_WEATHER`. Forum: `COMPLICATION_TYPE_TRAINING_STATUS`. **No training-readiness type** as of last forum confirmation. — [on-device editor](https://developer.garmin.com/connect-iq/core-topics/editing-watch-faces-on-device); [training readiness thread](https://forums.garmin.com/developer/connect-iq/f/discussion/348762/how-do-i-include-the-training-readiness-value-in-my-own-watch-face)
- Sunrise/sunset: first-party *glance* on compatible watches (dawn/sunrise/sunset/dusk; location-based). Not inherently blocked on faces if the complication/user/location API exposes it; many older faces compute it (Yet-Another-WatchFace changelog added sunrise/sunset). — [Garmin support sunrise glance](https://support.garmin.com/en-US?faq=jI2sb8OuP77rHLmrrKx2K6); [Laverlin/Yet-Another-WatchFace](http://168.138.51.227:8088/Laverlin/Yet-Another-WatchFace)
- Dual time: first-party alt-time *glance* (up to four zones on Fenix). Face field support is inconsistent (Instinct 3). Third-party DualTime/Facade exist. — [Fenix 8 alt time](https://www8.garmin.com/manuals/webhelp/GUID-EECCAC99-90D6-4AB1-9A3A-EC433D3365E2/EN-US/GUID-947DC68E-34C2-4B67-84B6-5A2BF7A0032F.html); [Instinct 3 thread](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-3/434978/dual-time-using-mini-window)
- Body Battery: older (Fenix 6) “not in CIQ”; later Glance Pro lists Body Battery/Stress as paid extras. Garmin’s $4.99 970 face still dinged for omitting it (May 2025). HRV is a Body Battery input (manuals) but not clearly a face complication in fetched docs. — [Fenix 6 thread](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/178925/body-battery-on-watch-face); [Glance showcase](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance); [Garmin Rumors 29 May 2025](https://garminrumors.com/garmin-selling-5-forerunner-970-570-watch-faces-while-rejecting-third-party-versions/)
- Notifications: count/icons appear on some faces (YAWF). Content blocked (privacy). — [YAWF](http://168.138.51.227:8088/Laverlin/Yet-Another-WatchFace); [r/GarminWatches privacy](https://www.reddit.com/r/GarminWatches/comments/urgfkf/connectiq_watchface_privacy)
- Weather: OpenWeather via Glance Pro (phone/background). Current weather complication exists. Radar imagery not mentioned in CIQ face APIs. — [Glance showcase](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance)
- Unofficial Training Readiness *app* exists for FR165 (not a face). — [Connect IQ CN listing](https://apps.garmin.cn/apps/b794406e-33b0-440d-b69a-a5160c96dde6)

**Blocked or glance-only**
- Compass/GPS/sensors on watch faces: no. Compass in background ~5 min. — [App types](https://developer.garmin.com/connect-iq/connect-iq-basics/app-types); [compass thread](https://forums.garmin.com/developer/connect-iq/f/app-ideas/226886/how-come-no-watch-face-around-that-includes-compass-data)
- Women’s health: glance + Connect; Garmin Connect *cloud* Women’s Health API is a separate enterprise program, not CIQ faces. — [Garmin women’s health](https://www.garmin.com/en-US/garmin-technology/health-science/womens-health/); [GC developer program](http://developer.garmin.com/gc-developer-program/program-faq)
- Apple-style Live Activities: no CIQ equivalent found. Garmin uses glances/widgets/activities. Watch faces don’t take input / no traditional UI flow. — [UX watch faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces)
- Calendar: no CIQ calendar-event API found this pass. Next-meeting is a Wear OS complication type, not evidenced on Garmin CIQ.

### Inferences
| Feature | Status | Why the gap |
|---|---|---|
| Body Battery + stress on face | Possible now (paid dashboards) | Older API lock; still omitted by Garmin’s own $5 clones |
| Body Battery + HRV together | HRV as face field: unconfirmed | May still be glance-only |
| Training readiness | Likely **still impossible** via CIQ | No complication type; 2026 forum asks |
| Training status | Possible via complication | Underused vs readiness demand |
| Sunrise/sunset on face | Possible | Often left to glances; not a store hole so much as a layout choice |
| Dual time on face | Possible | Native faces inconsistent; Casio-like analog dual-time still thin |
| Women’s health on face | Data probably not in CIQ | Glance exists; building a face may be blocked |
| Live activities | Architecture mismatch | Not a face job on Garmin |
| Dual time | Possible | Instinct 3 default gap |
| Complications from other IQ apps | **API exists** (4 pubs, watch face sub, Face It) | Adoption unknown — competitive opening if nobody consumes well |
| Weather radar | Almost certainly impossible | No map/radar in face APIs; HTTPS + 1/min + memory |
| Calendar events | No evidence of API | Glance/phone |
| Notification glance (content) | Impossible | Privacy policy |
| Notification count | Possible | Common |

### Gaps
- Full `Toybox.Complications.ComplicationType` enum not fetched (docs JS). Cannot confirm presence/absence of sunrise, HRV, cycle, calendar types without the enum.
- Whether System 6 / Venu X1 / Fenix 9 added training-readiness complications: not verified.
- Face It as a consumer of third-party complications: documented, usage not measured.

---

## What would be a defensible niche vs a me-too analog clone?

### Takeaway
Me-too analog clones of Garmin stock are now **rejectable**. Defensible: original design + a constraint the giants ignore (AOD 10% done well, MIP 20 ms seconds, Venu X1 rectangle, Instinct dual-time, on-watch editor API 5.1, CIQ complication subscriber). Do not compete with Glance on “more fields, free, huge font” unless the aesthetic is clearly post-2024 AMOLED.

### Cited Findings
- Policy: “Future watchfaces can not use the original designs anymore.” Garmin sells the clone itself. Commenters: official paid faces are “crippled” vs stock. — [Garmin Rumors 27 & 29 May 2025](https://garminrumors.com/garmin-tightens-watch-face-policy-on-connectiq-store-dev-creations-rejected/)
- Glance saturates free high-data; Tom’s Guide 2026 still uses it because it’s free, then criticizes dated look and missing training stats / on-watch edit. — [Tom’s Guide](https://tech.yahoo.com/wearables/articles/most-popular-free-garmin-watch-064500755.html)
- On-device CIQ editor exists (API 5.1) and is exactly the convenience users praise in native faces and miss in Glance. — [editor API](https://developer.garmin.com/connect-iq/core-topics/editing-watch-faces-on-device)
- Tactix/Instinct users will pay (or already pay Portal Pro) for *functional* analog, not colorful Fenix skins. — [Tactix 8](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/tactix-8/406443/tactix-7-watch-face-for-tactix-8)
- Venu X1 is explicitly an Apple Watch Ultra-shaped Garmin. Rectangle faces that ape Apple Infograph without Garmin metrics would be me-too; rectangle faces that keep Garmin recovery/training data in an Apple-legible layout would not. — [The Verge](https://www.theverge.com/news/686325/garmin-venu-x1-smartwatch-display-specs-pricing)

### Inferences
Defensible (if executed):
1. **Venu X1-first** modular rectangle, AOD-legal, on-watch config — window while round ports look bad.
2. **Instinct/Tactix MIP analog** — dual time in the inset, solar-friendly, not a Garmin bitmap clone.
3. **Recovery dashboard** that is *not* Glance: Body Battery + stress + training *status* (readiness only if API lands), modern AMOLED type, on-watch editor.
4. **Complication hub face** — `allowAny` slots that actually launch other IQ apps (documented, under-marketed).
5. **Casio language without Casio IP** — dual time + sun + battery as the *design*, original geometry.

Not defensible:
- Another Fenix 8 / FR970 lookalike (reject).
- Another Glance with slightly different fonts (saturated; VAW.BE already owns Goals/Seasons at 100k–500k buckets).
- Licensed character (Garmin/Disney already there).
- “Always-on full AMOLED analog with seconds” (API/battery lie).

### Gaps
- No pricing elasticity data beyond anecdotal $2–$5 resistance and 3.2★ on Garmin’s $4.99 face.
- No proof that Venu X1 owners actually search the IQ store (they may stick to built-in).

---

## Store policy, CIQ API, and battery constraints: true impossibility vs nobody built it?

### Takeaway
Several “gaps” are **impossibilities** (sensors on faces, AMOLED >10% AOD, notification content, Garmin-stock clones going forward, likely training readiness). Several are **choices** (dual time, sunrise, on-watch editor, CIQ complications, Venu X1 layouts). Battery complaints are structural: CIQ faces cannot match coprocessor stock seconds.

### Cited Findings
- Least APIs of any app type; no compass/GPS/sensors on faces. — [App types](https://developer.garmin.com/connect-iq/connect-iq-basics/app-types)
- AMOLED AOD 10% pixels, 1/min; MIP partial update 20 ms. — [UX watch faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces)
- Stock seconds on separate MCU (older Garmin engineer comment; architecture unchanged in later docs). — [forum](https://forums.garmin.com/developer/connect-iq/f/discussion/1289/watch-hands-disappear-after-10-seconds)
- May 2025 design-clone rejection; Garmin sells official replicas. — [Garmin Rumors](https://garminrumors.com/garmin-tightens-watch-face-policy-on-connectiq-store-dev-creations-rejected/)
- App review guidelines page fetched as nav-only (JS); **cannot quote current review text**. Brand guidelines exist as a separate Garmin developer section. — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Paid store enabled 2024; Garmin charges ~$4.99–$6 for own faces. — [Garmin Rumors 29 May 2025](https://garminrumors.com/garmin-selling-5-forerunner-970-570-watch-faces-while-rejecting-third-party-versions/)
- CIQ face crash class (Storage.setValue) late 2024. — [Garmin Rumors 2 Dec 2024](https://garminrumors.com/many-garmin-watches-crashing-with-connectiq-watch-faces)

### Inferences
True impossibility (do not product-plan as a face):
- Live compass, GPS map, weather radar, ECG, notification text, women’s-health logging UI, Apple Live Activities, full-screen AMOLED AOD, continuous CIQ second hand on all devices.

Nobody-built / undershipped (buildable):
- Venu X1-native rectangle; Instinct dual-time analog; on-watch editor (5.1) on a modern AMOLED dashboard; CIQ complication subscriber; MIP always-active seconds done within 20 ms; original (non-clone) dress analog.

Ambiguous (need enum check before building):
- Training readiness, HRV as complication, cycle phase as complication, calendar next-event.

### Gaps
- Current App Review Guidelines body not retrieved.
- SDK 6.x / 2026 complication additions not retrieved.
- Whether clone policy is written or only applied in review.

---

## Ranked opportunities by evidence strength

Evidence scale: **A** = repeated 2025–2026 user/reviewer complaints + API allows it; **B** = clear constraint/policy creating a hole, demand inferred; **C** = plausible, thin public demand.

| Rank | Opportunity | Evidence | Why not already done | Risk |
|---|---|---|---|---|
| 1 | Modern AMOLED data face: on-watch editor (API 5.1), training stats Glance lacks, legal AOD | **A** — Tom’s Guide 2026; Glance dated; paid $2–$5 fatigue | Glance frozen in 2022 look; many faces skip native editor | Saturated category; must not look like Glance/Goals |
| 2 | Original analog that *behaves* like stock (fields, AOD, battery) without copying Garmin art | **A** — clone ban + 3.2★ Garmin $5 clone + Tactix thread | Policy + Garmin occupying the replica SKU | Review rejection if too close to Fenix/FR |
| 3 | Venu X1 rectangle-native face (448×486, AOD 10%, Apple-switcher layout + Garmin data) | **B** — new Jun 2025 SKU, Ultra comparisons, CIQ 6.0; store counts unknown | Most faces are round ports | Small installed base, $800 watch, 2-day AOD |
| 4 | Instinct 3 Solar/MIP: dual time in inset + outdoor fields, solar-safe | **A/B** — 2026 dual-time forum; MIP always-on preference | Native default omits alt time; CIQ battery fear | Instinct users hate battery hits |
| 5 | Recovery pair on face: Body Battery + stress (+ HRV if API) | **A** for BB history; **C** for HRV-together | Older API lock; Garmin $5 face still omits BB | May already be table stakes on Glance Pro |
| 6 | Complication-subscriber / hold-to-launch hub | **B** — API documented, Face It consumes | Most faces hardcode Garmin metrics | Need partner apps publishing 4 complications |
| 7 | Casio-like dual time + sun (original geometry) | **B** — Instinct dual-time; Casio analog is a known language; few CIQ hits | Dual time buried in glances | IP if too G-Shock |
| 8 | Training readiness on face | **A** demand, **blocked?** | No complication type as of ~Mar 2026 | Do not start until enum confirms |
| 9 | Tactix-functional analog (not Fenix-colorful) | **B** — Tactix 8 thread | Garmin shipped Fenix faces on Tactix | Niche SKU; clone-policy if too Tactix 7 |
| 10 | Free high-quality face as acquisition | **A** — 53K Glance reviews because free | Monetization push 2024–2026 | Revenue vs distribution tradeoff |
| 11 | Dress/fashion/Bauhaus on sport watches | **C** — GarminHub fashion faces ~0 downloads | Athlete-heavy CIQ audience | Thin demand |
| 12 | Women’s health on face | **C** — health is glance/app | Likely no CIQ data | Build as glance/app, not face |
| 13 | Cute/character | **C** — Disney official $5; novelty faces exist | Licensing | Don’t |
| 14 | Golf / hunt / swim / climb / parent faces | **C** — no 2025–26 face threads found | Verticals live in apps/activities | Guess |
| 15 | Weather radar / live compass / notification text / full AOD | — | **Impossible** under current CIQ | Don’t |

**If building one thing:** original (non-Garmin-clone) face with native-editor support, honest AOD, and a device-shaped layout (X1 rectangle *or* Instinct dual-time MIP) — not another analog Fenix or another Glance.

**Do not invent TAM.** Public numbers that *were* found: Glance 53K reviews (Mar 2026); Garmin $4.99 970 face ~1K downloads / 3.2★ (May 2025); GarminHub download *buckets* up to 500,000 for Seasons/Chrono (aggregator, not audited).
