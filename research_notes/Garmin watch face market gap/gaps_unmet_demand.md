# Unmet demand in the Garmin Connect IQ watch face market

> **⚠ HEADLINE FINDING REFUTED.** This file's central claim — that accessibility /
> low vision is the strongest unmet gap — was **refuted** by store-review data in
> `low_star_reviews.md`: of 2,544 low-star reviews, 1.45% mention low vision or font
> size, 0.20% mention contrast/glare, and **zero** mention colour blindness. The niche
> already has a 1M-download incumbent (Simply Large). The forum evidence below is real
> but over-selects for articulate, motivated complainants and is not representative of
> install-base demand.
>
> The file remains useful for its verbatim forum quotes, the MIP/Solar contrast finding,
> the device-porting demand, and the AOD low-power bug. **Read `low_star_reviews.md` and
> `verification.md` alongside it; both win on conflict.** Correction summary:
> `../../reports/Garmin watch face market gap.md`.
>
> Also note the methodology trap recorded in this file: **Garmin forum listings sort by
> last activity, not post date** — a thread showing "1 month ago" was over four years old.


**Scope note / methodological warning, read this first.** Two of the assignment's
primary evidence channels turned out to be **mechanically unreachable** from this
environment, and this materially limits the confidence of the findings below:

1. **Connect IQ store reviews could not be retrieved.** `apps.garmin.com` is a
   Next.js client-rendered app. A direct `curl` of an app page
   (`https://apps.garmin.com/apps/41216af0-baf4-4252-a173-2495388a4710`) returns
   130 KB of HTML in which the strings `Review`, `reviewCount`, `ratingValue`
   appear only as UI component/schema labels — **no review bodies, no star
   ratings, no review dates are in the served HTML**. Four candidate JSON
   endpoints were probed
   (`/api/appsLibraryExternal/rest/apps/{uuid}/comments`, `.../reviews`,
   `.../apps/{uuid}`, and `services.garmin.com/appsLibraryExternalServices/...`);
   the first three returned the SPA shell HTML, the fourth returned
   `{"status":404,"error":"Not Found"}`. **Key question 1 (low-star review
   clustering) and key question 6 (quality gaps) therefore have no store-review
   evidence base.** They are answered below only from adjacent forum evidence and
   one secondary source, and this is flagged in each section's Gaps.
2. **Reddit was unreachable.** Both `old.reddit.com` and `www.reddit.com` search
   URLs returned "Claude Code is unable to fetch from…". WebSearch queries
   targeting Reddit returned only SEO aggregator articles (Tom's Guide,
   Notebookcheck), no actual threads. **No r/Garmin, r/GarminFenix or r/running
   evidence is present in these notes.**
3. **Date constraint largely unmet.** The assignment asked to prioritise
   2025-09 → 2026-09. Garmin's forum software renders relative dates only ("over
   3 years ago"), and the recency-filtered searches surfaced mostly older
   threads. **Most findings below are labelled historical.** Only three items are
   within or near the target window (Venu X1 firmware 15.52/16.28, the 2026
   Connect IQ download-blocking thread, and two 2026-08 app-idea threads).

The report writer should treat this file as **partial coverage with honest
gaps**, not as a complete market scan. Nothing below is extrapolated from memory;
every claim carries a URL.

---

## Q1. What do 1-star and 2-star reviews on top-ranked Garmin watch faces complain about?

### Takeaway
**Not answerable with the intended evidence** — Connect IQ store reviews are
client-side rendered and could not be retrieved (see scope note). The one usable
proxy is a secondary source aggregating user comments, which points to
battery drain, missing complication support and paywalled/limited customisation
as the dominant complaint themes; forum threads independently corroborate the
battery-drain and AOD themes.

### Cited Findings
- Secondary source aggregating user comments on Garmin watch faces: "CIQ does have
  lots of faces. In fact, too many. Many are quite frankly, poor, don't support
  complications" — [Garmin Rumors, "Garmin's Watch Face Problem: A Call for Better
  Options"](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical — comments dated October 2024; this is a secondary source quoting
  users, not a primary review**)
- Same source: pre-installed faces are "overly complicated, too limited, or not
  useful in always-on mode"; "many third-party faces drain battery excessively";
  most customisation requires the Connect IQ *mobile app* rather than on-device
  editing — [Garmin Rumors](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical, 2024**)
- Fenix 8 specific complaint from the same source: "fancy fonts" obscure the time
  display, and there is no white-background option —
  [Garmin Rumors](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical, October 2024**)
- Battery drain from third-party faces is a *structurally* acknowledged problem, not
  just user perception: a Garmin representative in the Connect IQ developer forum
  confirmed store submission review "focus[es] on content moderation rather than
  performance review" — i.e. **nobody checks whether a published watch face is a
  battery hog** — [Connect IQ discussion 676](https://forums.garmin.com/developer/connect-iq/f/discussion/676/can-a-misbehaving-watch-face-cause-a-battery-drain)
  (**historical — thread is ~2013/2014, devices cited are Vivoactive and Fenix**)
- Developers in that thread named the specific mechanisms: drawing arcs via polygons
  costing "20-100 calls" instead of one or two; a "500ms timer that always runs,
  even in low power"; an app calling "up to 5x300 circles to draw each second" —
  [Connect IQ discussion 676](https://forums.garmin.com/developer/connect-iq/f/discussion/676/can-a-misbehaving-watch-face-cause-a-battery-drain)
  (**historical**)
- AOD misbehaviour is a concrete, reproducible complaint cluster: "Watch face
  installed via the connect iq store does not automatically go to low power mode
  again after incoming message displayed or after returning from sleep mode." A
  second participant: "This problem still persists even in software version 11.2x.
  For me this is the main reason of battery drain and possibly screen burn-in."
  4 participants (Harald_C, if, Jinsuu, RandyPenn1). **Affects Connect IQ faces
  only — built-in faces are unaffected.** Device: Epix Gen 2 (AMOLED) —
  [Epix 2 thread 300282](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/epix-2/300282/connect-iq-watch-faces-don-t-go-to-low-power-mode-after-message-arriving)
  (**historical — original report ~4 years ago, confirmations ~3 years ago;
  unresolved as of firmware 11.2x**)
- "Broken after update" is a recurring, multi-device thread genre across the
  forums: Fenix 6 ("Firmware v25.00 Broke Connect IQ Custom Watch Faces"),
  Vivoactive 3, Forerunner 230/235 ("Garmin, your Connect IQ 'fixes and updates'
  broke my Simple Watch IQ watch face"), plus an open developer bug report "Connect
  IQ causes watch face to crash" — [Fenix 6 thread 324077](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/324077/firmware-v25-00-broke-connect-iq-custom-watch-faces/1572699),
  [FR230/235 thread 121245](https://forums.garmin.com/sports-fitness/sports-fitness/f/forerunner-230-235/121245/garmin-your-connect-iq-fixes-and-updates-broke-my-simple-watch-iq-watch-face),
  [CIQ bug report](https://forums.garmin.com/developer/connect-iq/i/bug-reports/connect-iq-causes-watch-face-to-crash)
  (**historical, device families span Fenix 6, Vivoactive 3, FR230/235**)
- Settings-sync failure is a confirmed (if closed) defect class: watch face settings
  "not updated/synced correctly in the Connect(IQ) mobile apps after performing
  settings change", filed 2020-03-12, confirmed by at least 2 other developers
  (TheMagician, tomulli), one reporting it across 280+ settings. Affects Garmin
  Connect iOS/Android, Connect IQ iOS/Android, and Garmin Express. **Garmin closed
  it "Cannot Reproduce".** —
  [CIQ bug report, settings sync](https://forums.garmin.com/developer/connect-iq/i/bug-reports/watch-face-settings-not-updated-synced-correctly-in-the-connect-iq-mobile-apps-after-performing-settings-change)
  (**historical, 2020 — status "Cannot Reproduce / Complete", may or may not still
  occur**)

### Inferences
- The assignment's hypothesised complaint clusters — battery drain, AOD behaviour,
  broken-after-firmware, settings not syncing, poor readability — all have at least
  one documented primary instance in the Garmin forums, so the clustering hypothesis
  is directionally supported even without review data. **What is missing is volume:
  I cannot say which cluster dominates, or what fraction of low-star reviews each
  represents.**
- Because store submission is content-moderated and not performance-reviewed
  ([discussion 676](https://forums.garmin.com/developer/connect-iq/f/discussion/676/can-a-misbehaving-watch-face-cause-a-battery-drain)),
  there is no systemic filter preventing battery-hostile faces from ranking highly
  on downloads. A face that is *provably* power-frugal has no way to signal that in
  the store — which is itself a positioning opportunity rather than a product gap.
- The AOD low-power-mode bug affecting **only** Connect IQ faces and not built-in
  ones is the single most actionable technical finding here: it implies a
  third-party face that provably re-enters low-power mode correctly after a
  notification would beat the field on the #1 stated drain cause on AMOLED.

### Gaps
- **The core question is unanswered.** No star ratings, no review text, no review
  dates, no per-face complaint distribution. Retrieving this needs a JS-capable
  browser (`mcp__claude-in-chrome__read_page` on an `apps.garmin.com` app page,
  scrolling the review pane, or `read_network_requests` to discover the real
  reviews XHR endpoint). Recommend this as the single highest-value follow-up.
- No download counts were obtained, so "top-ranked / high-download" faces could not
  even be *identified* reliably, let alone sampled. Names surfacing in secondary
  coverage were Glance, Segment 34, Crystal and Konatsu, but I did not verify
  their rankings — treat those names as unverified.
- Whether the Epix AOD low-power bug persists in 2025/2026 firmware is unknown; the
  last confirmation is ~3 years old at firmware 11.2x.

---

## Q2. What watch faces do users explicitly ask for and say don't exist?

### Takeaway
The Connect IQ **"Third-Party App Ideas" forum is a literal, still-active request
board** and is the best available substitute for the unreachable Reddit channel —
it contains explicit "can someone make this?" posts with view counts and
subscriber counts as demand proxies. The dominant recent pattern, however, is not
*new face concepts* but **requests to port an existing face to a device it does
not support**.

### Cited Findings
- The app-ideas forum is active. Threads at the top of the listing as sampled
  2026-09: "Digitron/Nixie Watch Face" (**last active 1 month ago**; 7 replies,
  **3,327 views**, 16 subscribers), "Sugar Sense – Real-Time CGM Glucose Display for
  Garmin Watches" (1 month ago, 0 replies), "Freediving/Spearfishing app" (19 days,
  4 replies), "Add Cold-plunge to Activities List" (13 days, 2 replies) —
  [Connect IQ Third-Party App Ideas forum](https://forums.garmin.com/developer/connect-iq/f/app-ideas)
  (**IMPORTANT: the listing sorts by LAST ACTIVITY, not post date. The Digitron
  thread's own page shows the original post is over 4 years old with identical reply
  and view counts — its "1 month ago" is a new reply, not a new thread. Do not read
  any of these timestamps as post dates unless reply count is 0.**)
- The canonical explicit-request phrasing, from that forum: *"is there any watch
  face lookalike with digitron numbers? Or can someone make it?"* This request was
  **fulfilled** by a community developer ("nonparametric"), who built a Nixie face —
  [Digitron/Nixie thread 279627](https://forums.garmin.com/developer/connect-iq/f/app-ideas/279627/digitron-nixie-watch-face)
  (**historical — original post over 4 years ago**)
- **The demand that persisted after fulfilment was device-porting demand, and it is
  still unmet.** The same thread accumulated unfulfilled device requests over years:
  Venu 1 (4+ yrs ago), Fenix 5X (4+ yrs ago), Forerunner 955 (3+ yrs ago, +1
  upvote), **Forerunner 965 (1+ yr ago)**, **D2 Mach 2 Pro (1 month ago — recent)** —
  [Digitron/Nixie thread 279627](https://forums.garmin.com/developer/connect-iq/f/app-ideas/279627/digitron-nixie-watch-face)
- The developer's stated blocker is an **API-level** one: *"It looks like the Venu 1
  does not support Connect API version 4.0, so it would require some code changes."* —
  [Digitron/Nixie thread](https://forums.garmin.com/developer/connect-iq/f/app-ideas/279627/digitron-nixie-watch-face)
  (**CIQ API 4.0 is the named cutoff — this is the one API-level data point in these
  notes**)
- The shipped Nixie face is **AMOLED-only and AOD-optimised**: *"In low-power mode,
  the neon tubes dim but remain visible."* It shows time, date, heart rate, steps and
  battery. Its showcase thread (post over 4 years ago, 2 replies, 8 subscribers,
  **2,041 views**) contains two further unanswered porting requests — Forerunner 965
  and Epix 2 Pro (416x416) — with **no developer response visible** —
  [Nixie showcase thread 288069](https://forums.garmin.com/developer/connect-iq/f/showcase/288069/watchface-nixie)
  (**historical post, porting requests span into recent years; corroborates the
  device-porting gap from a second thread**)
- Long-standing request-board titles showing the recurring shape of unmet demand:
  "Simple Digital Watch Face with Readable Steps" (thread 968), "Business Like
  Watchface" (thread 683), "Visual Watch Face Builder" (thread 6040) —
  [app-ideas 968](https://forums.garmin.com/developer/connect-iq/f/app-ideas/968/simple-digital-watch-face-with-readable-steps),
  [app-ideas 683](https://forums.garmin.com/developer/connect-iq/f/app-ideas/683/business-like-watchface),
  [app-ideas 6040](https://forums.garmin.com/developer/connect-iq/f/app-ideas/6040/visual-watch-face-builder)
  (**historical — low thread numbers indicate old posts; recurrence over a decade is
  itself the signal**)

### Inferences
- **The highest-volume unmet demand in this channel is not "a face that doesn't
  exist" but "the face I want doesn't run on my watch."** Three-plus years of
  accumulating unanswered port requests on a single thread, with the newest one
  a month old, is a clean signal. The commercial read: **breadth of device support
  is a differentiator, not a chore** — most community faces are built for one
  display technology and abandoned for the rest.
- "Business Like Watchface" and "Simple Digital Watch Face with Readable Steps"
  recurring as request-board titles is weak but real evidence for the
  calm/professional/non-sport whitespace hypothesis (see Q5).
- **Speculative:** 3,327 views on a single niche aesthetic request (Nixie) suggests
  aesthetic-niche faces have far more latent audience than their thread reply counts
  imply. Views-to-replies ratio of ~475:1 means lurker demand vastly exceeds vocal
  demand. Marked speculative — view counts are not intent.

### Gaps
- **Zero Reddit evidence.** The assignment's specific query forms ("is there a watch
  face that…", "looking for a watch face", "wish there was a face") could not be run
  against r/Garmin, r/GarminFenix or r/running. This is the largest coverage hole in
  these notes and the second-highest-value follow-up after store reviews.
- Garmin forum search does not expose absolute post dates, so I cannot count how
  many such requests were filed within 2025-09 → 2026-09.

---

## Q3. What underserved user segments show up?

### Takeaway
**Accessibility / low vision is the best-evidenced underserved segment**, with
independent complaints across at least three device families and an explicit,
unanswered feature request naming font-size modes and colour-blind schemes.
**Medical / CGM (diabetes) is the second**, where the gap is structural: Connect IQ
data fields only run during workouts, so glucose on a *watch face* requires a
bespoke face, not a plug-in field.

### Cited Findings

**Accessibility / low vision / colour blindness**
- Explicit, itemised feature request on Epix Gen 2, 11 replies, no Garmin response:
  users asked for **font size/type options (3-5 modes)**, **colour scheme options
  (2-3 schemes)**, and **colour-blind accessibility settings**. Quote: *"I can't
  find another Garmin I can read without glasses"* (user 3461197). Another: *"It is
  not only about the activities interface… But this is related to general interface
  — reading messages, notifications"* (bgrenda). Another cites market size: *"up to
  around 500 million people on this planet have a red-green disability"* (Matt.47).
  Devices discussed: Epix Gen 2, Venu 2 Plus, Forerunner 35 (plus comparisons to
  Galaxy Watch 5, Apple Watch Ultra, Suunto 7) —
  [Epix 2 thread 314687](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/epix-2/314687/any-chance-to-introduce-a-setting-that-respect-people-with-weak-eyesight-or-difficulties-to-see-all-colors)
  (**historical — over 3 years ago; unanswered by Garmin**)
- Independent instance on a **cheap Forerunner**: a user asked how to increase font
  size, needing glasses to read notifications. There is **no native font-size control
  on the FR45**. The community answer was explicitly to work around it with
  third-party faces: *"You'll have to experiment, but I found a couple of 'large
  print' faces that suit my fading eyesight"* (Chazzo) —
  [FR45 thread 251869](https://forums.garmin.com/sports-fitness/sports-fitness/f/forerunner-45-series/251869/watch-face-font-size)
  (**historical — over 5 years ago, 1 reply**)
- Garmin has since shipped a native **"Large Fonts"** display setting on some
  devices (Vivoactive 5 documented) — so the *system* gap is partly closed on newer
  hardware, but the *watch face* gap is not, since Large Fonts does not govern
  third-party face rendering —
  [Vivoactive 5 owner's manual, Customizing the Display Settings](https://www8.garmin.com/manuals/webhelp/GUID-5D183A14-BB43-4A9B-B441-5F824214CE40/EN-US/GUID-24A772E9-96DD-4B65-AC8E-42853AA2C676.html);
  [Garmin support, Accessibility Features on My Garmin Watch](https://support.garmin.com/en-US/?faq=RLIAQG0Y2Z6K240aQGlP68)
- The segment is **partially served already** — large-font faces exist in the store,
  e.g. "MegaTime – Large font watchface" and a "Simple digital face, large font and
  touch screen" —
  [MegaTime](https://apps.garmin.com/en-US/apps/d2cd8f44-7845-41b4-9c45-1342f20444ed),
  [Simple digital face, large font](https://apps.garmin.com/apps/21008b21-8cb9-4a34-8a0e-db08208af277).
  **Whether they are any good is unknown — see Q6 Gaps.**

**Medical / diabetes / CGM**
- Structural API limitation, stated on the forums: *"If it's a data field it will
  only work during a workout and there is no way to add it to a watch face or a
  glance. There is no way to use any other Data Fields in a 3rd party app — only
  Garmin apps can do it."* This means **CGM-on-watch-face can only be solved by
  building the whole face**, not by a complication —
  [Venu 3 thread 345567, data fields on watch face](https://forums.garmin.com/sports-fitness/healthandwellness/f/venu-3-series/345567/data-fields-on-watch-face-no-alarm-dnd)
- Community workarounds exist but are chained and fragile: glucose on a watch face
  via the 'Kerfstok' Connect IQ face plus Juggluco on the phone (same author);
  Dexcom's own widget/data field was updated for G7 —
  [Dexcom G7 thread 329932](https://forums.garmin.com/apps-software/mobile-apps-web/f/connect-iq-store-ios/329932/dexcom-g7-not-working-with-existing-gc-dexcom-data-field-and-glance-app),
  [Fenix 6 CGM thread 194135](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/194135/continuous-glucose-monitoring)
- Demand is recurring and multi-vendor: Medtronic pump integration requested on the
  app-ideas board; blood glucose / blood pressure requested on Instinct Solar; a
  glucose log requested in Garmin Connect mobile; and an app-idea post **"Sugar Sense
  – Real-Time CGM Glucose Display for Garmin Watches", last active ~1 month ago with
  0 replies — with no replies to bump it, that is also its post date, so ~2026-08** —
  [Medtronic app idea 263731](https://forums.garmin.com/developer/connect-iq/f/app-ideas/263731/app-to-transmit-information-from-medtronic-pump-app-to-garmin-wearables),
  [Instinct Solar thread 328041](https://forums.garmin.com/outdoor-recreation/outdoor-recreation-archive/f/instinct-solar/328041/blood-glucose-levels-blood-pressure/1592636),
  [app-ideas forum listing](https://forums.garmin.com/developer/connect-iq/f/app-ideas)
  (**Sugar Sense post is recent — ~2026-08**)

**Niche sports**
- Swimming data is explicitly absent from the watch-face API: a developer feature
  request notes that for high-end Connect IQ watch faces, **pool swimming activity
  data is not available in the Connect IQ API**. The underlying complaint is broader
  — no weekly/monthly totals by sport (run/bike/swim), no individual activity
  entries; `ActivityMonitor` gives only "daily total distance combined across all
  activity types including walking" —
  [CIQ discussion 4698](https://forums.garmin.com/developer/connect-iq/f/discussion/4698/feature-request-more-data-available-to-watch-faces)
  (**historical — over 9 years old; Garmin's Coleman submitted it formally, tonix76
  seconded it a year later. Whether it has since been addressed in later CIQ API
  levels is UNVERIFIED — do not assume it is still true without checking current
  CIQ API docs.**)
- Freediving/spearfishing (**last active 19 days ago**, 4 replies) and cold-plunge
  (**last active 13 days ago**, 2 replies) both appear near the top of the app-ideas
  board as of 2026-09 — [app-ideas forum](https://forums.garmin.com/developer/connect-iq/f/app-ideas)
  (**these are last-activity timestamps, NOT post dates — Garmin's forum listing sorts
  by last activity, so a thread with replies may be much older than it appears. Also
  note these are activity-app requests, not watch-face requests.**)

### Inferences
- **Accessibility is the strongest gap in this set** because it has three
  independent characteristics of real unmet demand: multiple unrelated users, across
  multiple device families and price tiers, over multiple years, with the community's
  own answer being "go find a third-party face" — i.e. **the store is already the
  designated solution channel, and users report it is hard to find a good one.**
- The colour-blindness angle (Matt.47's 500M figure) is essentially **untouched** in
  everything I surfaced — I found the request but found no evidence of any face
  marketing itself on deuteranopia-safe palettes. Marked as a **likely gap, evidence
  is one forum post**.
- The CGM gap is real but **hard to capture**: the winning product is a full watch
  face, and it depends on a phone-side bridge (Juggluco/Dexcom) outside the
  developer's control. High support burden.

### Gaps
- **No evidence found at all** for several segments the assignment named: night
  shift workers, parents, medication reminders, and non-fitness professionals. I
  did not find forum threads for these. Absence of evidence here is weak evidence
  of absence — my searches were forum-restricted and Reddit was unavailable, and
  these segments are more likely to voice themselves on Reddit than on Garmin's
  developer forums.
- **No evidence found** for cultural/calendar segments (Islamic/Hijri calendar,
  Hebrew calendar, lunar calendar, prayer times). I did not search these
  specifically — budget was consumed elsewhere. **This is an untested hypothesis,
  not a negative finding**, and is a strong follow-up candidate given that prayer-time
  faces are a known category on other platforms.
- Older users as a distinct segment overlap heavily with low vision; I have no
  evidence separating them.

---

## Q4. Which device families are underserved?

### Takeaway
Two device-side gaps are evidenced: **MIP/Solar Fenix models get worse
customisation options than their AMOLED siblings within the same product line**,
and **older/cheaper devices get dropped by developers at Connect IQ API version
boundaries**. A third, recent, and severe issue is that on some devices **users
cannot install watch faces at all.**

### Cited Findings
- **MIP vs AMOLED within the same line.** On Fenix 8 Solar (MIP), users can only get
  grey tones for data-field accent colours; pure black and pure white are
  unavailable. Quote: *"The lack of pure White and pure Black Accent colors
  available on Fenix 8 Solar models is very frustrating."* A respondent notes AMOLED
  Fenix models **do** offer these colours and calls the disparity problematic. 2
  replies; **thread is locked with no Garmin staff response** —
  [Fenix 8 thread 397637](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-8-series/397637/feature-request-watch-face-customization-suggestion/1909788)
  (**historical — over 1 year ago, i.e. ~2025-mid; close to the target window**)
- **API-level abandonment of older devices.** A developer declined to port a face to
  Venu 1 because *"the Venu 1 does not support Connect API version 4.0, so it would
  require some code changes"* — and Fenix 5X, FR955, FR965 and D2 Mach 2 Pro
  requests on the same thread also went unfulfilled —
  [Digitron/Nixie thread 279627](https://forums.garmin.com/developer/connect-iq/f/app-ideas/279627/digitron-nixie-watch-face)
  (**CIQ API 4.0 is the explicit boundary named**)
- **Venu X1: watch faces cannot be added at all.** *"After update 15.52, the option
  to add new watch faces is missing at the bottom of the list."* Same user 1 month
  later: *"I still have the same problem after installing the 16.28 software."*
  Unresolved across two firmware releases; only 1 reply —
  [Venu X1 thread 430215](https://forums.garmin.com/sports-fitness/healthandwellness/f/venu-x1/430215/missing-add-watch-face-feature/2014210)
  (**recent — posts ~7 and ~6 months ago, i.e. roughly 2026-02 to 2026-03**)
- **Install blocked by a false "software not up to date" error, 2026.** Thread title
  explicitly dated: "IQ wont download faces as it falsely reports software not up to
  date 2026". User: *"I have updated the software multiple times, I have reset the
  watch and reset my phone be still it reports that watch software needs to be
  update."* Garmin support suggested deleting `GarminDevice.xml`; no confirmed
  resolution in thread —
  [Connect IQ Store iOS thread 435783](https://forums.garmin.com/apps-software/mobile-apps-web/f/connect-iq-store-ios/435783/iq-wont-download-faces-as-it-falsely-reports-software-not-up-to-date-2026)
  (**recent — ~4 months ago, i.e. ~2026-05**)
- Related install/visibility failures across device families: Vivoactive 3 ("Can't
  Find New Watch Faces on Watch"), FR230/235 ("Watch faces not showing up"), Fenix 6
  ("Watch Face option missing in menu"), and a developer-side bug report that a
  published face does not appear in the Connect IQ app or on apps.garmin.com —
  [Vivoactive 3 thread 147484](https://forums.garmin.com/sports-fitness/sports-fitness/f/vivoactive-3-3-music/147484/can-t-find-new-watch-faces-on-watch),
  [FR230/235 thread 104994](https://forums.garmin.com/sports-fitness/sports-fitness/f/forerunner-230-235/104994/watch-faces-not-showing-up),
  [Fenix 6 thread 224504](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/224504/watch-face-option-missing-in-menu),
  [CIQ bug report, face not appearing in store](https://forums.garmin.com/developer/connect-iq/i/bug-reports/bug-report---connect-iq---my-watch-face-does-not-appear-in-the-connect-iq-app-nor-can-i-download-it-from-the-apps-garmin-com-website)
  (**historical, mixed dates**)
- Garmin does not let users carry faces between their own devices: each model has
  its own exclusive set, unlike Apple's universal approach. User quote: *"I request
  Garmin to provide better or more faces, at least include the Epix AMOLED faces
  from earlier watches"* —
  [Garmin Rumors](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical, secondary source, October 2024**)

### Inferences
- **Fenix Solar / MIP is the clearest device-family gap with a product answer.** The
  complaint is precisely that MIP owners are denied high-contrast pure black/white
  accents that AMOLED owners get. A third-party face is not bound by Garmin's
  built-in colour palette — **this gap is directly addressable by a Connect IQ
  developer today**, and it stacks with the low-vision finding in Q3: the same fix
  (pure white on pure black, maximum contrast) serves both.
- **Instinct's monochrome MIP screens, Vivoactive and kids' devices produced no
  direct evidence** in my searches. I would not claim them as gaps.
- The Venu X1 and 2026 install-failure threads are about **Garmin platform
  reliability**, not a face-design gap — a developer cannot fix them. They matter as
  context (they suppress store conversion for everyone) rather than as opportunity.

### Gaps
- **No Connect IQ API level could be attached to most gaps.** Only CIQ API 4.0 (the
  Venu 1 cutoff) is directly evidenced. I deliberately did not infer API levels
  from device names. Mapping gaps to API levels needs the Connect IQ device
  reference / compatible-devices matrix, which I did not fetch.
- No device install-base or download-share data was obtained, so I cannot weight any
  of these families by "how many people own one" — which the assignment explicitly
  asked for ("a gap on a device nobody owns is not a gap"). **All device-family
  findings below are unweighted.**
- Instinct (monochrome MIP), Vivoactive generally, and kids' devices (Bounce/vívofit
  jr) returned no relevant results. Untested rather than disproven.

---

## Q5. Where do popular faces cluster, leaving whitespace?

### Takeaway
The Connect IQ **showcase forum** (where developers announce faces) shows attention
concentrating overwhelmingly on a small number of faces, with the single most-viewed
being a *clean, information-efficient* face rather than a data-dense sport one —
which **cuts against** the assumption that calm/minimal is the whitespace. The
better-evidenced gap is structural: **store search is broken**, so whitespace may
exist but be undiscoverable.

### Cited Findings

**What developers actually ship, and what draws attention (showcase forum)**
- View counts on the Connect IQ App Showcase forum are extremely top-heavy:
  **"Glance" — 938,511 views, 3,151 replies**; "Digital for TactixD" — 348,701
  views, 894 replies; "Connect IQ Benchmark v2" — 49,681 views. The #1 face has
  ~2.7x the views of #2 and ~19x the views of #3 —
  [Connect IQ App Showcase forum](https://forums.garmin.com/developer/connect-iq/f/showcase)
  (**recent listing, sampled 2026-09; individual thread post dates not captured**)
- The announced faces span several styles: data-dense/sport ("Digital for TactixD",
  tactical-watch focused), minimal/aesthetic ("Glance"; "DayBear and Day Mood", which
  use illustrated aesthetics with minimal always-on screens), analog/traditional
  ("GMT", dual time zones with celestial indicators), and gamified concepts
  ("Bloomagotchi", a growing-flower fitness mechanic) —
  [Connect IQ App Showcase forum](https://forums.garmin.com/developer/connect-iq/f/showcase)
- For scale contrast, a niche-aesthetic face in the same forum drew **2,041 views**
  against Glance's 938,511 — roughly a 460x spread —
  [Nixie showcase thread 288069](https://forums.garmin.com/developer/connect-iq/f/showcase/288069/watchface-nixie)

**Discovery and quality framing**
- Oversupply framing, user comment: *"CIQ does have lots of faces. In fact, too many.
  Many are quite frankly, poor, don't support complications"* —
  [Garmin Rumors](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical, 2024, secondary source**)
- **Discovery is structurally broken, and this is a named, filed complaint.** Store
  search for watch faces is a *global* search returning every occurrence of a term
  rather than filtering by face name or developer, making it hard to find a specific
  face — [Connect IQ app-ideas thread 357181, "Search feature request for Watch
  faces"](https://forums.garmin.com/developer/connect-iq/f/app-ideas/357181/search-feature-request-for-watch-faces)
- Demand for the *opposite* of data-dense exists in the request board's own history:
  "Simple Digital Watch Face with Readable Steps" and "Business Like Watchface" —
  [app-ideas 968](https://forums.garmin.com/developer/connect-iq/f/app-ideas/968/simple-digital-watch-face-with-readable-steps),
  [app-ideas 683](https://forums.garmin.com/developer/connect-iq/f/app-ideas/683/business-like-watchface)
  (**historical — low thread IDs, likely 2014-2016**)
- Complaints that *built-in* faces err toward decoration over legibility: Fenix 8
  "fancy fonts" obscuring the time, no white-background option; pre-installed faces
  "overly complicated, too limited, or not useful in always-on mode" —
  [Garmin Rumors](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical, October 2024**)
- Demand for tooling, not just faces: "Visual Watch Face Builder" —
  [app-ideas 6040](https://forums.garmin.com/developer/connect-iq/f/app-ideas/6040/visual-watch-face-builder)
  (**historical**)

### Inferences
- **The strongest inference available: distribution, not design, may be the binding
  constraint.** With search broken and thousands of faces, a well-designed face has
  no reliable discovery path. This reframes "whitespace" — the gap may be
  *findability of quality*, not absence of quality.
- **The assignment's "who does calm/minimal?" hypothesis is weakened by the showcase
  data.** The single most-attended face in the developer community is Glance, a
  clean/information-efficient design, by a very wide margin. Minimal is not
  whitespace — **minimal is where the winner already is.** The report writer should
  not treat "nobody does calm/minimal" as an established gap.
- **Reframed inference:** the showcase view distribution is a power law, and the
  head is occupied by a legibility-first design, not a data-dense one. That implies
  the contested axis is *execution quality within the minimal/legible category*,
  not category choice. This aligns with Q6's finding shape.
- The "too many, mostly poor, don't support complications" characterisation plus
  the explicit calm/simple/business request titles remains **consistent with** a
  general quality deficit. **But I did not verify this by sampling the store's
  top-ranked faces** (blocked by the same client-rendering problem as Q1). Marked
  **speculative.**
- Complication support being called out as commonly *missing* suggests it is a
  cheap differentiator. **Speculative** — one secondary-source comment.

### Gaps
- **I could not observe the actual store at all** — no category listings, no
  download counts, no ranking. The showcase-forum view counts above are a *proxy for
  developer-community attention*, not for store downloads or installed base. This
  section would be transformed by a single browser-driven pass over the Connect IQ
  store's watch-face category sorted by downloads.
- Showcase thread **post dates were not captured**, so I cannot say whether the
  style mix has shifted in the 2025-09 → 2026-09 window.
- No data on paid vs free split, paywall/unlock patterns, or pricing — the
  assignment named paywalls as a complaint theme and I found **no evidence either
  way**.

---

## Q6. Are there quality gaps rather than category gaps?

### Takeaway
**Cannot be answered.** Identifying "a common category where every existing option
is poorly rated" requires per-face star ratings, which are exactly what the store's
client-side rendering withheld. The one adjacent signal is a secondary-source claim
of systemic low quality, plus a structural reason to expect it (no performance
review at submission).

### Cited Findings
- Systemic quality claim (secondary source, user comment): the store has "too many"
  faces and "many are quite frankly, poor, don't support complications" —
  [Garmin Rumors](https://garminrumors.com/garmins-watch-face-problem-a-call-for-better-options/)
  (**historical, 2024**)
- **Structural cause, from Garmin itself:** store submission review covers content
  moderation, not performance. A Garmin representative confirmed this and said they
  rely on community reports to flag problematic apps. Developers in the same thread
  complained of **no profiling tools in the simulator to measure power consumption**,
  limited hardware access for testing, and no "API calls per minute" metric —
  [CIQ discussion 676](https://forums.garmin.com/developer/connect-iq/f/discussion/676/can-a-misbehaving-watch-face-cause-a-battery-drain)
  (**historical, ~2013/2014 — whether the simulator has since gained power profiling
  is UNVERIFIED and should be checked against current Connect IQ SDK docs**)
- Candidate category to test the hypothesis on, from Q3: large-font/accessibility
  faces demonstrably exist (MegaTime; "Simple digital face, large font and touch
  screen") and were recommended by the community as the workaround for a native gap —
  [MegaTime](https://apps.garmin.com/en-US/apps/d2cd8f44-7845-41b4-9c45-1342f20444ed),
  [Simple digital face, large font](https://apps.garmin.com/apps/21008b21-8cb9-4a34-8a0e-db08208af277),
  [FR45 thread 251869](https://forums.garmin.com/sports-fitness/sports-fitness/f/forerunner-45-series/251869/watch-face-font-size)

### Inferences
- If the "no performance review at submission" finding still holds, then **quality
  gaps should be expected to be the default state of the store, not the exception** —
  there is no mechanism selecting against bad faces except user reviews, and reviews
  are the very signal a prospective buyer cannot easily search (Q5). This is a
  coherent mechanism for "every option in a category is poorly rated" but is **not
  itself evidence that it is true.**
- The accessibility/large-font category is the **best candidate to test the
  quality-gap hypothesis against**: demonstrated recurring demand (Q3), an official
  community-recommended workaround pointing at the store, and at least two
  incumbents whose ratings are unknown. If those incumbents are poorly rated, that
  is a category-with-demand-and-no-good-option — the most valuable finding shape in
  this whole brief. **Currently untested.**

### Gaps
- **The question's entire evidence base (per-face star ratings by category) was
  unobtainable.** See scope note. Required follow-up: browser-rendered pass over
  `apps.garmin.com` capturing, per face: download count, average rating, rating
  count, and the text of 1-2 star reviews, for the top N faces in each category.
- I have no evidence on whether the Connect IQ simulator gained power/performance
  profiling in the decade since the cited thread. If it did, the "no way to build a
  provably efficient face" premise weakens considerably. **Must be checked.**
