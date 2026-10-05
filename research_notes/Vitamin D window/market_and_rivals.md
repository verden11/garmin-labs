# Vitamin D sun window: market and rival apps (research as of 2026-10-04)

Method note: apps.garmin.com is JS-rendered. WebFetch returns only headers (name, developer, type, rating, download band). I read the SunIQ listing in full through a real browser; later listing loads in the browser stalled on a spinner (store search is not URL-addressable and redirects to the home page). "Store version 4.26.2" shown by WebFetch on every listing is the store site build, not the app version, so it is ignored. Forum thread ages are given as the forum showed them ("over N years ago") at fetch time, not as exact dates.

## Which Connect IQ store apps, widgets, faces and data fields exist for UV, sun exposure, vitamin D, "go outside"?

### Takeaway
There is a live, directly competing vitamin D widget on the store (SunIQ, paid, first released 2026-02-10, v2.5 released 2026-10-02 adding a "best and safest time to go outside" window screen). A free sunburn-timer (SunAlert) also logs a vitamin D estimate. Plain UV-index widgets exist and are free (the largest has 50K+ downloads). I could not enumerate the store exhaustively, so more may exist.

### Cited Findings
- **SunIQ: Vitamin D Tracker, UV & Sunburn Alerts** — widget, developer "3303", store type "Payment" (exact price not displayed in the text I could read), 4.3 stars from 10 reviews, "100+ Downloads", initial release 2026-02-10, latest release 2026-10-02 (v2.5), 57 KB, developer in Lviv UA. Permissions: communication, background activity, location, fitness and sensor data, saved information, user profile. — [Garmin store listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891) (read in browser)
- SunIQ description says it "estimates your Vitamin D synthesis in real-time based on environmental data, sun position, and your personal stats", "Powered by a realistic biological algorithm based on peer-reviewed clinical research" (the developer's review reply cites "Dr. Holick's clinical research"). Uses Garmin Weather data, manual UV override, auto skin type from GPS latitude, three temperature "clothing" modes, off-wrist detection by heart rate, a red DANGER state at over 400% of metabolic baseline, and a "Vitamin D Bank" (5,000 IU starting reserve, 50,000 IU cap) and 10-day history in a PRO tier priced "$1.99" in the description. — [same listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891)
- SunIQ v2.5 (2026-10-02) "New Daily Analytics Screen... recommends the best and safest time to go outside to get Vitamin D", evaluating cloud cover, UV index and temperature; green column = "Optimal and safest time", red = "Dangerous UV levels (avoid)", gray = cloudy or minimal UV; also a daily reminder that fires in a "CRITICAL" zone. Not supported on Fenix 6 series and Enduro 1. This is the same OPEN/CLOSED idea as the studio concept, shipped two days before this research. — [same listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891)
- SunIQ reviews (3 of 10 visible): 2026-08-22 v2.1 positive, asks for an SPF/sunscreen reminder page (developer says SPF mode in progress); 2026-06-21 v1.8 positive, asks for a more visible progress-bar position on MIP displays; 2026-06-07 v1.8 "Useless" (no reason given; the developer asked what was useless). Star ratings per review not captured. — [same listing, reviews tab](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891?tab=reviews)
- **SunAlert** — free Connect IQ app; sunburn risk and time-to-burn from the UV index in the watch's own weather forecast, Fitzpatrick skin type (six types), planned activity, SPF 15-100; also "logs how much vitamin D it thinks you have taken in" with a daily target; works as a widget; on most watches but not e.g. Forerunner 170. Tom's Guide, 2026-06-23. I did not obtain the store listing (price, rating, reviews unverified beyond "free" per the article). — [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/this-smart-garmin-app-is-helping-me-avoid-sunburn-during-the-heatwave-and-its-completely-free) (read in browser)
- **UV-Index** (laufschnauff) — widget, free, 3.9 stars, 50K+ downloads. Uses last outdoor-activity GPS position (per search snippet, unverified), needs Garmin Connect Mobile as web proxy. Forum thread (about 9 years old, 10 replies): frequent timeouts if no GPS fix, settings reset on GCM iOS update, caching requested, ozone requested. — [store](https://apps.garmin.com/en-US/apps/b0776624-e65c-4be1-8854-2cd5c00030ce), [forum](https://forums.garmin.com/developer/connect-iq/f/showcase/4876/widget-uv-index)
- **UV Index Widget. Forecast at a Glance** (Oleksiy) — widget, free, 3.8 stars, 10K+ downloads; review count not obtained. — [store](https://apps.garmin.com/en-US/apps/5f49fe00-d193-4cf8-ae4c-b47a13c6b9ad?tab=reviews&criteria=rating&ascending=true&displayCurrentVersion=false)
- **UV Index Data Field** (MoistMollusc) — data field, free, 4.3 stars, 1K+ downloads; per a search snippet (unverified) current and max UV with background colour by UV class, data from Visual Crossing API, 15-minute refresh. — [store](https://apps.garmin.com/apps/5a1434b1-9374-41e3-bd45-b944e360755d)
- Sunrise/sunset widgets exist (Garmin's own blog promotes "Sun & Moon Times", forum "SunCalc" and "Sun Times" widgets); these give times, not UV or vitamin D. — [Garmin blog](https://www.garmin.com/en-US/blog/outdoor/connect-iq-sun-moon-times/), [SunCalc thread](https://forums.garmin.com/developer/connect-iq/f/showcase/3082/widget-suncalc---sunrise-sunset-blue-hour-golden-hour/33353)
- Enabler: Connect IQ `Weather.CurrentConditions.uvIndex` and `Weather.HourlyForecast.uvIndex` ("UV index [0-10]", Float or Null) both need API level 5.1.0, so only newer devices get UV from the on-watch weather cache; older watches fall back to a phone web call (the old UV-Index widget pattern). — [CurrentConditions](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/CurrentConditions.html), [HourlyForecast](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/HourlyForecast.html)
- Other store items surfaced only as names with no data: a Samsung Magazine piece (2026-02-28) lists a vitamin D app among "6 of the strangest apps for Garmin watches"; page text could not be fetched, so which app is unverified. — [Samsung Magazine](https://samsungmagazine.eu/en/2026/02/28/6-nejpodivnejsich-aplikaci-pro-garmin-hodinky/) (search snippet only)

### Inferences
- The "window" concept is no longer unclaimed: SunIQ 2.5 already draws an optimal/avoid timeline. The remaining differentiation is simplicity (a binary OPEN/CLOSED read, no IU numbers or "bank"), low-claim wording, and a smart nudge. SunIQ's complexity (IU, bank, DANGER at 400% baseline) and its first-person medical-sounding claims leave room for a calmer, safer product.
- Install base of the paid direct rival is tiny (100+ after eight months), while free UV widgets reach 10K to 50K. Free UV is saturated; the paid vitamin D niche is small and unproven.
- SunIQ's own reviewers ask for sunscreen/SPF and MIP legibility, not more vitamin D precision.

### Gaps
- Exact SunIQ price (only "Payment" and a "PRO $1.99" mention; unclear if $1.99 is the app price or an in-app unlock), full device list, and the other 7 reviews' text.
- SunAlert store listing (price, rating, review count, devices) and any other vitamin D / sun apps: store search could not be driven. A manual search for "vitamin", "UV", "sun" in the Connect IQ mobile app is still worth doing.
- Last-update dates for the UV widgets.

## Phone and other-watch rivals: price, rating, complaints, native Garmin UV

### Takeaway
Phone rivals are subscription-heavy ($10 to $60 per year or lifetime $25 to $40) with ratings of 4.0 to 4.8. Garmin shows UV index natively in the weather glance, but has no native vitamin D or sunlight metric; a "Nature Minutes" feature was only ever a leak. Apple tracks "Time in Daylight" natively; Wear OS shows UV in the weather app and as a complication.

### Cited Findings
- **D Minder Pro** (iOS/Mac/Apple Watch, Android exists; developed with Dr. Michael Holick) — free with IAP: Pro annual $9.99, lifetime $24.99; 4.0 stars from 714 ratings (search snippet via an aggregator; the store page itself said insufficient reviews for overview in my fetch, so unverified); description: "track and manage your Vitamin D", stopwatch-style sun sessions timed on Apple Watch, daily forecasts from location and solar position, supplement logging. Last update "5 days ago" at fetch (v100.11.7, fixed a coastal timer issue). — [App Store](https://apps.apple.com/me/app/id547102495), [price snippet](https://apppricinglab.com/app/apple/547102495)
- D Minder complaints in 23 analysed reviews (3.9 stars): vitamin D estimate does not update in a session, location defaults to the wrong country (e.g. Saudi Arabia for North Carolina), Apple Watch "allegedly broken", sync failures, billing confusion over a "free upgrade", poor developer support. Praise: it "teaches you the best time to get sun exposure" around solar noon, supplement tracking. Small sample, aggregator source. — [JustUseApp](https://justuseapp.com/en/app/547102495/d-minder-pro/reviews)
- **UV Index Widget - Worldwide** (iOS, Apple Watch) — free with IAP: Pro $4.99/month or $24.99/year, Pro widget $59.99; 4.8 stars from about 15K ratings; v14.0.1, 2025-09-15. Tracks "your Vitamin D production from sunlight", "time to burn" estimates, sunscreen reminders. Vendor site cites 46,000+ users and a note to consult health professionals. — [App Store](https://apps.apple.com/us/app/uv-index-widget-worldwide/id1100568288), [vendor](https://uv-index-worldwide.web.app/)
- **Sola: Sun UV & Vitamin D Timer** (iOS, Apple Watch) — free tier; monthly $3.99, 3-month $6.99, annual $12.99, lifetime $39.99, 3-day trial; 4.6 stars from 98 reviews; Apple Watch complications for UV and vitamin D; uses Time in Daylight. States "This is not medical advice and should not replace professional healthcare guidance or common sense." — [App Store](https://apps.apple.com/us/app/sola-%ED%83%9C%EC%96%91-%EC%9E%90%EC%99%B8%EC%84%A0-%EB%B9%84%ED%83%80%EB%AF%BC-d-%ED%83%80%EC%9D%B4%EB%A8%B8/id1454332188?l=ar)
- "Vitamin D (Sun AI)" iOS: free with IAP, premium subscriptions listed from $4.99 to $149.99 (search snippet, unverified). — [App Store](https://apps.apple.com/us/app/sun-ai-uv-index-tanning-app/id6470038527)
- Names "Vitamin D Sun", "Sun Day" (a wearable UV monitor product), "Sunsprite", "QSun": I found no usable store data (Sun Day appears only as a hardware wearable in a search snippet). Not verified.
- **Garmin native**: the Instinct 2 Solar forum thread (about 4 years old, 8 replies) states "There is a uv index in glances>weather". No Garmin-native vitamin D or sunburn alert. — [Garmin forum](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-2-series/299942/new-feature-wish-sun-burn-prevention-alarm/1451387)
- Garmin "Nature Minutes": an unconfirmed rumour dated 2024-02-05 from The5krunner via reader tip-offs, possibly GPS-activity-based or solar-sensor-based; I found no evidence of release. — [Advnture](https://www.advnture.com/news/garmin-watch-time-outdoors)
- **Wear OS**: UV index added to the Weather app and as a watch-face complication in April 2021 rollout; no sunscreen reminders or sensor-based UV. — [TechRadar](https://www.techradar.com/news/wear-os-has-a-useful-new-weather-app-feature), [Droid Life](https://droid-life.com/2021/04/08/pixel-watch-lol-wear-os-uv/amp)
- **Apple Watch** "Time in Daylight" is automatic from the ambient light sensor; can be switched off in Privacy & Security > Health. — [Apple support](https://support.apple.com/guide/watch/apd3ab22534c)

### Inferences
- Phone price anchors are far above the studio's $2.50 tier; SunIQ's $1.99 and free UV widgets are the realistic Garmin anchors.
- Recurring complaint themes across rivals: wrong location, stale or non-updating estimates, watch companion broken, billing/subscription confusion, weak support. A widget using the watch's own cached weather avoids the location and phone-proxy failure modes that sank the older UV-Index widget.

### Gaps
- Review complaints for Sola, UV Index Widget Worldwide and Vitamin D (Sun AI) were not read. No Reddit complaint threads were retrievable (see demand section).
- D Minder Android and Wear OS or Samsung watch status unverified.

## How rivals word health claims, and what looks risky

### Takeaway
Rivals range from soft ("estimate", "not medical advice") to risky (outcome numbers, "optimal and safest", "DANGER", "metabolic baseline", "80% of Americans are vitamin D deficient"). Garmin's store rules push apps with medical claims toward an "educational purposes only" statement and bar anything needing FDA clearance.

### Cited Findings
- Garmin's Connect IQ "App approval exceptions" wiki: apps that may be regulated as medical devices need FDA clearance; those without it should state the app "is not intended to be used for the purposes of medical treatment and is intended for educational purposes only"; Garmin will not list apps requiring FDA approval, though developers may distribute them elsewhere. — [Garmin developer wiki](https://forums.garmin.com/developer/connect-iq/w/wiki/10/app-approval-exceptions)
- A developer in a "Getting Approval for 'Medical App'" thread (about 1 month old at fetch) asked about Garmin's requirement; the only replies were from a hobbyist, none from Garmin staff, so the real review practice is unconfirmed. — [forum](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/442110/getting-approval-for-medical-app)
- SunIQ wording: "Vitamin D synthesis" estimated "in real-time", "realistic biological algorithm based on peer-reviewed clinical research", "Optimal and safest time to go out", "Dangerous UV levels (avoid)", "DANGER Zone", "Vitamin D synthesis realistically drops by 80%", "Vitamin D Bank... 5,000 IU reserve", "Autonomy in Days". It passed Garmin approval and has been live since 2026-02-10, so these claims are tolerated in practice. — [SunIQ listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891)
- DMinder site: "notify you to get your sun exposure at the optimal time of day", "get Vitamin D without burning your skin", "80% of Americans are vitamin D deficient", "Developed with world authority on Vitamin D, Dr. Michael Holick"; no medical disclaimer visible on the homepage (my fetch). — [DMinder](https://dminder.ontometrics.com/)
- UV Index Widget Worldwide: "your Vitamin D production from sunlight", "time to burn", "tailored safety tips"; vendor page advises consulting health professionals. — [App Store](https://apps.apple.com/us/app/uv-index-widget-worldwide/id1100568288)
- Garmin forum users flagged liability in a sunburn-alarm request: one responder said Garmin may avoid such a feature to sidestep legal problems; another noted solar-panel light is not UV, and burn susceptibility varies by person. — [Garmin forum](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-2-series/299942/new-feature-wish-sun-burn-prevention-alarm/1451387)

### Inferences (not legal advice)
- Riskier claim types: numeric outcomes (IU, "minutes needed"), "optimal", "safe"/"safest", deficiency statistics, "dangerous", expert endorsements, anything implying diagnosis or supplement replacement. Lower-risk: "estimate", "UV is high enough for skin to make vitamin D", "window", generic educational disclaimer.
- Worth treating the Garmin wiki wording as the minimum: put "educational, not medical advice" in the listing. Existing live competitors show the review is not strict, but a single rejection or takedown is a cost the studio's "no accuracy claims" stance (see ladder report, HeroSet accuracy gate) already avoids.
- I did not research the regulators' or dermatology bodies' stance on sun-exposure advice (skin cancer messaging); sunburn-safety framing may matter more than vitamin D framing.

### Gaps
- No Garmin Connect IQ Faceit/brand/review guideline text specific to health wording other than the wiki above was found.
- No evidence of any Connect IQ vitamin D app being rejected or pulled.

## Gap a window-only (OPEN/CLOSED) plus smart-nudge widget would fill

### Takeaway
Existing Garmin options are either raw UV numbers (free, and old ones unreliable), a burn timer (SunAlert), or a complex vitamin D simulator (SunIQ, now with a timeline). Nobody ships a one-glance, no-numbers "is the sun window open now" read with a quiet nudge; SunIQ 2.5 is the closest and moving in this direction.

### Cited Findings
- Free UV widgets show an index number and colour; the older one needs a GPS fix and a phone proxy and "frequently times out". — [forum](https://forums.garmin.com/developer/connect-iq/f/showcase/4876/widget-uv-index)
- SunAlert targets burn time and SPF and adds a vitamin D log. — [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/this-smart-garmin-app-is-helping-me-avoid-sunburn-during-the-heatwave-and-its-completely-free)
- SunIQ now offers a green/red/gray hourly "best and safest time" screen plus a reminder, alongside IU numbers. — [SunIQ listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891)
- Apple (Time in Daylight) and Wear OS (UV complication) give a basic passive read natively; Garmin has only the weather-glance UV figure. — see sources above.

### Inferences
- Differentiation candidates: (1) binary state readable in under a second, glance/complication friendly; (2) no IU or minutes numbers; (3) built on `Weather` UV from the on-watch cache (API 5.1.0 devices), no phone proxy; (4) a nudge that fires at most once per window and respects quiet hours; (5) honest "estimate/educational" wording; (6) works on MIP (SunIQ reviewer asked for MIP visibility).
- Risk: SunIQ 2.5 shows the incumbent is converging on the window idea; a lean widget competes on clarity and trust, not on a feature checklist.
- Device reach: UV from on-watch weather requires API 5.1.0, which excludes older watches (SunIQ itself excludes Fenix 6 and Enduro 1 for its new screen); studio device-list work is separate.

### Gaps
- Which Garmin products support API 5.1.0 not checked.
- No evidence yet on whether users prefer binary vs numeric views (no user research found).

## Garmin user demand signals

### Takeaway
Demand is real but small and old. Found: a vitamin D tracker idea (about 7 years old, 11 subscribers, 1,022 views, zero replies), UV/air-quality widget requests (8 and 7 years old), a sunburn alarm request (4 years old, 8 replies), and 50K+ downloads of a free UV widget. No Reddit threads were retrievable.

### Cited Findings
- "Vitamin D Tracker APP idea" in Connect IQ app-ideas: about 7 years old, 0 replies, 11 subscribers, 1,022 views; asker already uses a similar phone app. — [forum](https://forums.garmin.com/developer/connect-iq/f/app-ideas/164465/vitamin-d-tracker-app-idea)
- "Air Quality and UV Index for the FR945": about 7 years old, 7 replies, 13 subscribers, 2,677 views; resolved when Garmin added its own air-quality widget; shows people asking for UV and AQI together. — [forum](https://forums.garmin.com/developer/connect-iq/f/app-ideas/164941/air-quality-and-uv-index-for-the-fr945)
- "Air Quality and UV Index Widget" (Vivoactive 3): over 8 years old, 1 reply, 463 views, 11 subscribers; "a must for anyone who does outdoor activities". — [forum](https://forums.garmin.com/developer/connect-iq/f/app-ideas/6281/air-quality-and-uv-index-widget)
- "New feature wish: Sun burn prevention alarm" (Instinct 2 Solar): about 4 years old, 8 replies. — [forum](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-2-series/299942/new-feature-wish-sun-burn-prevention-alarm/1451387)
- A forum comment suggested using solar-watch insolation to compute vitamin D, with the caveat it would be "wildly inaccurate" (from a search-engine summary, unverified). — [search summary of Garmin thread](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/instinct-2-series/345973/instinct-2-2x-solar-is-not-always-solar-charging-when-it-should-be/1687018)
- Downloads: UV-Index widget 50K+, UV Index Widget Forecast at a Glance 10K+, UV Index Data Field 1K+, SunIQ 100+ (store bands, links above).
- Media pull: Tom's Guide wrote up SunAlert (2026-06-23) during a UK heatwave. — [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/this-smart-garmin-app-is-helping-me-avoid-sunburn-during-the-heatwave-and-its-completely-free)
- Other-platform demand: Fitbit "UV Exposure Tracker" product feedback thread and Cronometer "add vitamin D from sunlight" requests exist (search results only; not read). — [Fitbit](https://community.fitbit.com/t5/Product-Feedback/UV-Exposure-Tracker/m-p/4538684), [Cronometer](https://forums.cronometer.com/discussion/23/please-add-sunlight-vitamin-d)

### Inferences
- Demand for a UV read is proven by downloads; demand for vitamin D specifically is anecdotal (one idea thread with zero replies, tiny SunIQ base). Sunburn-avoidance, not vitamin D, seems to be the larger motive in Garmin-side mentions.
- Forum "app ideas" threads have low view counts (hundreds to low thousands) and cannot be read as market size.

### Gaps
- Reddit r/Garmin was not retrievable via search; no counts or dates. Garmin forum search for "UV index" feature requests on Garmin Connect (not Connect IQ) not exhausted. Exact thread dates not captured (forum only showed "over N years ago").
- No data on how many Connect IQ users have UV-capable devices.

## Notification and nudge precedent, and user annoyance

### Takeaway
Nudges are accepted when rare and controllable and resented when they misfire or cannot be turned off. Garmin's move alert is the best-documented annoyance; Apple's Time in Daylight is passive.

### Cited Findings
- Garmin forum threads on the move bar/alert: complaints that it clears while sitting or in bed, long walks do not clear it, it is harder to clear than before, vibration is annoying at work, and it keeps turning back on after being disabled; threads titled "can't turn off move alert" and "move alert keeps turning on". — [move bar issues](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/fenix-6-series/191645/move-bar-issues), [can't turn off](https://forums.garmin.com/sports-fitness/sports-fitness/f/forerunner-935/135896/can-t-turn-off-move-alert), [keeps turning on](https://forums.garmin.com/sports-fitness/sports-fitness/f/forerunner-735xt/119283/move-alert-keeps-turning-on) (search summary of thread titles and snippets)
- Apple Time in Daylight is automatic and has an off switch in Privacy & Security > Health. — [Apple support](https://support.apple.com/guide/watch/apd3ab22534c/11/watchos)
- SunIQ added a daily reminder in 2.5 (CRITICAL zone) and a reviewer is asking for an SPF reminder: users of this category do ask for sun-related alerts. — [SunIQ listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891)

### Inferences
- Nudge design that avoids the move-alert failure modes: fire at most once per window, never when the watch is off wrist or asleep (SunIQ already detects off-wrist by heart rate), obey quiet hours, an in-app off switch that persists across updates (the old UV widget lost settings on GCM iOS updates), and no repeat if dismissed.
- I found no data on Samsung nudge annoyance.

### Gaps
- No quantified annoyance data (counts); the forum evidence is anecdotal and via search snippets. No Reddit or Apple Time in Daylight complaint threads were retrieved.

## Pricing context (studio and comparable apps; no price decision made)

### Takeaway
The studio's price tier for paid apps is the $2.50 tier of Garmin's price points (US $2.49, eurozone 2,99 EUR, set per the owner on 2026-10-04); no price number goes into site or listing text. Comparable Garmin items: SunIQ is paid with a PRO figure of "$1.99" in its text; SunAlert and UV widgets are free; phone rivals charge $10 to $60 a year or $25 to $40 once.

### Cited Findings
- Studio decision: every paid app takes the $2.50 tier; free apps stay free; Free = clean name, Pro = "<Name> Pro"; no price numbers in site or listing text. — `/Users/mbp/dev/garmin/CLAUDE.md` (Studio direction, owner 2026-10-04); ladder mechanics in `/Users/mbp/dev/garmin/reports/Free and Pro ladder.md`
- Ladder report market survey (measured 2026-09-28): paid top faces sit at 2,49 to 5,99 EUR, 3,49 EUR most common; Pro twins sell 10,000 to 50,000 at 3,49 to 5,99 EUR; the studio sits at the floor tier. That report's earlier recommendation of a $3.00 tier was superseded by the owner's $2.50 decision. — `/Users/mbp/dev/garmin/reports/Free and Pro ladder.md` (E6, lines ~48 and ~144) and `/Users/mbp/dev/garmin/research_notes/Free and Pro ladder/same_face_pairs.md`
- `/Users/mbp/dev/garmin/reports/Opportunities backlog.md` has no vitamin D, UV or outdoor-reminder item (searched for vitamin, UV, sun, daylight, outdoor); its sun content concerns sunrise/sunset via `Toybox.Weather.getSunrise/getSunset` for faces.
- External prices: D Minder Pro $9.99/yr or $24.99 lifetime ([App Store](https://apps.apple.com/me/app/id547102495)); UV Index Widget Worldwide $24.99/yr, $4.99/mo, $59.99 widget pack ([App Store](https://apps.apple.com/us/app/uv-index-widget-worldwide/id1100568288)); Sola $3.99/mo, $12.99/yr, $39.99 lifetime ([App Store](https://apps.apple.com/us/app/sola-%ED%83%9C%EC%96%91-%EC%9E%90%EC%99%B8%EC%84%A0-%EB%B9%84%ED%83%80%EB%AF%BC-d-%ED%83%80%EC%9D%B4%EB%A8%B8/id1454332188?l=ar)); SunIQ PRO "$1.99" ([listing](https://apps.garmin.com/en-US/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891)); SunAlert and the three UV widgets/fields free.

### Inferences
- A free UV baseline is saturated on Garmin; a paid sun widget has to be justified by clarity and nudge quality. Whether the concept fits the studio Free/Pro ladder (what is Free, what is Pro) is a PM decision, not made here.

### Gaps
- Studio revenue model was not re-derived; SunIQ's actual price and sales are unknown beyond the "100+ downloads" band.
