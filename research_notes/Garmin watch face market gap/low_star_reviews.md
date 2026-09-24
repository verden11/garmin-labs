# Low-Star Reviews on Top Connect IQ Watch Faces — Complaint Mining

**Observation date: 2026-09-22.** All data pulled directly from the Connect IQ store
backend JSON API (`apps.garmin.com/api/appsLibraryExternalServices/api/asw/...`), not
from HTML or listicles.

## Method and corpus (read this before trusting any count)

Ranking pull: `GET /apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE`
→ top 30 most-popular watch faces, observed 2026-09-22.

Review pull per face: `GET /apps/<appId>/reviews?startPageIndex=<offset>&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true`,
paging until a review with rating ≥ 3 appeared, or 10 pages (250 reviews).

**Correction to the carried-over notes — important for anyone repeating this.**
`startPageIndex` is a **row offset, not a page index**. `startPageIndex=1` returns the
window starting at review #2, not reviews 26–50. A first pass using `startPageIndex=0..5`
returned 3,464 rows that deduped to **776 unique** reviews (~30 per face). Re-running with
`startPageIndex = page * pageSize` yielded **2,544 unique low-star reviews, zero duplicates,
zero HTTP errors**. Everything below is from the corrected pull.

Corpus: **2,544 unique reviews at 1★ or 2★** (1,700 × 1★, 844 × 2★) across 30 faces.
Two faces hit the 250-review collection cap (Face It®, Crystal) — their true low-star
volume is higher than reported.

| Face | appId | Avg★ | Total reviews | Downloads | Low-star pulled |
|---|---|---|---|---|---|
| Goals | c4d24b8d-ecc2-4436-b14e-ce75b462e425 | 4.9 | 29,826 | 100k | 67 |
| Face It® | c33a05fa-bb7b-46a4-87b4-482a3e726a11 | 4.6 | 29,925 | 5M | 250 (capped) |
| Pure Harmony TiM | ce4b5593-c8b6-43d3-9702-11dad57ef491 | 3.3 | 602 | 50k | 192 |
| Rad-Lad Watch Face | 640309de-3f18-402b-a654-bfb769dfd485 | 4.4 | 1,059 | 50k | 70 |
| Rondo | e55067c1-0bc4-4ca8-96bc-bed2c83f5498 | 4.9 | 5,397 | 10k | 14 |
| GLANCE watch face | 07ae0f49-7240-4475-a229-4507e8035fae | 4.9 | 68,814 | 1M | 116 |
| Fenix 8 V3 PRO - GB | 844f8455-c828-489d-b94a-a72416ee7df6 | 4.9 | 2,000 | 10k | 28 |
| Black Hawk Elite | ce3bf722-6f14-4890-8e2f-8ac23a438994 | 4.8 | 4,095 | 100k | 34 |
| Vanguard Elite | 68e85cf4-2308-40c7-9ea1-0e762cbd29a6 | 4.8 | 2,747 | 50k | 28 |
| Fenix 8 V2 - PRO - GB | 98767971-d0f8-4e45-b3f1-1f1b4c0e3037 | 4.7 | 752 | 50k | 28 |
| Data Lover | bcb58298-3e71-4d9a-9084-169e581df99c | 4.7 | 13,612 | 1M | 230 |
| Tactical Elite | 874aecfe-b441-4ad0-a581-b8505f929a5f | 4.8 | 1,537 | 10k | 35 |
| Fenix7 Pro Analog OWM MB | 39e068a5-c8c0-4600-ad55-587d246c3336 | 4.8 | 37,391 | 1M | 103 |
| Tomahawk Elite | a7c9fa45-c9c8-47bb-9374-15105a7d348b | 4.8 | 977 | 10k | 12 |
| Black Grid | d87b23bb-ec6d-47f3-82ea-d133f5dfb356 | 4.9 | 35,593 | 500k | 87 |
| SURGE Full Data - Fenix 8 | 799d3e06-b086-486d-8d26-e89062d7db20 | 4.5 | 1,681 | 10k | 115 |
| Outerfield | feee5b06-f020-4831-89dd-1a042e0a176e | 3.8 | 143 | 10k | 22 |
| Crystal | 9fd04d09-8c80-4c81-9257-17cfa0f0081b | 4.4 | 3,997 | 1M | 250 (capped) |
| Circles 2 | bba6fa8b-72a6-41d5-83f9-e08b74d0fa42 | 4.8 | 1,687 | 10k | 5 |
| Simply Large | a94f8711-50f3-424c-a867-43ace7c699eb | 4.3 | 914 | 1M | 70 |
| Zenith | 2120f6b9-97d3-4014-8062-576f8516b7d4 | 4.8 | 44,008 | 500k | 193 |
| Instinct Mission | 6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d | 4.8 | 15,321 | 1M | 106 |
| Lachesis (Light) | fa9c2fd6-cce0-49a0-aa94-20a129623164 | 3.7 | 829 | 1M | 160 |
| Style 7 | 42ca648f-0779-4a72-a4f1-9ab3d381456c | 3.6 | 337 | 10k | 97 |
| Seasons | 0e3f0c70-f038-4867-a3a4-167a288d666f | 4.8 | 51,357 | 500k | 93 |
| Simple 2 | 9d62ccde-e6e8-44ba-bf4e-24cd7e38d3e6 | 4.7 | 1,649 | 1M | 33 |
| Nexus TiM | 4cdc316b-6341-470d-b888-fef069508a9e | 4.1 | 213 | 10k | 22 |
| Quipu - Data Watch Face | e4f08276-7c26-46d9-9409-91f945527ab1 | 4.6 | 176 | 10k | 6 |
| Simple TDB | 4db3d6ae-569b-4435-a7a2-67a2978c04f0 | 4.7 | 2,963 | 1M | 67 |
| Fletcher Elite | e1c93f85-9c60-4e61-a7dc-c4f46215a144 | 4.7 | 401 | 10k | 11 |

Classification was regex clustering over the review `text` field only. Developer `replies`
were **excluded** — they contain words like "reboot", "sync", "Garmin Connect" and would
have inflated every theme. Themes are non-exclusive: one review can hit several.

---

## Key Question 1 — What do users actually complain about? (themes, volume, quotes)

### Takeaway
Across 2,544 low-star reviews on the 30 most-popular watch faces, the dominant complaints
are **not** the expected battery/AOD/weather set. The two largest clusters by a wide margin
are **device-fit and device-support failures (376 / 14.8%)** and **paywall/trial-key
frustration (366 / 14.4%)**. Battery (4.5%), AOD (1.6%) and weather (6.6%) are real but
comparatively small. Text is very thin: median review length is **72 characters**, and only
**610 of 2,544 (24.0%)** exceed 130 characters.

### Cited Findings

All quotes below are verbatim from the reviews endpoint for the named appId, observed
2026-09-22. Source URL pattern for every quote:
`https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<appId>/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true`

**Theme volumes (n = 2,544 unique low-star reviews, review dates spanning 2018–2026;
74% of the corpus is 2024 or later, see Key Question 3 for the 2025→2026 breakdown).**

**Read the "faces most hit" column with care:** those are raw counts, and pull depth per face
ranges from 5 to 250 reviews, so a deeply-pulled face will top a theme on volume alone.
Normalised rates (theme hits ÷ that face's low-star reviews pulled, restricted to faces with
≥20 pulled) are given below the table for the six largest themes, and they are the better
discriminator.

| Theme | Count | % of corpus | Faces most hit (count) |
|---|---|---|---|
| Device support / fit / non-touch navigation | 376 | 14.8% | Crystal (63), Pure Harmony TiM (49), Lachesis (40), Data Lover (28), Instinct Mission (25) |
| Paywall / trial / unlock-key | 366 | 14.4% | Zenith (78), Black Grid (30), Instinct Mission (29), SURGE (25), Pure Harmony TiM (24) |
| Settings not saving / not syncing / resetting | 213 | 8.4% | Crystal (24), Pure Harmony TiM (17), Data Lover (15), Goals (14), SURGE (14), Style 7 (14) |
| Bugs: wrong, stuck, frozen, laggy, crashing | 188 | 7.4% | Crystal (35), Data Lover (27), Pure Harmony TiM (19), Face It® (11) |
| Install / download / won't load | 177 | 7.0% | Face It® (35), Crystal (25), Lachesis (13), Pure Harmony TiM (12) |
| Weather wrong / not updating / wrong units | 167 | 6.6% | Data Lover (54), Crystal (30), GLANCE (20), Zenith (10) |
| Battery drain | 114 | 4.5% | Data Lover (21), Lachesis (20), Crystal (10), Black Grid (7) |
| Missing / limited data fields | 109 | 4.3% | Data Lover (16), Crystal (14), Lachesis (10), Pure Harmony TiM (8) |
| Readability / font / size / contrast | 105 | 4.1% | Pure Harmony TiM (19), Lachesis (16), Face It® (10), SURGE (9), Style 7 (9) |
| Broken after a firmware / app update | 63 | 2.5% | Crystal (17), Lachesis (8), Instinct Mission (7), Data Lover (6) |
| Always-on-display behaviour | 40 | 1.6% | Pure Harmony TiM (6), Simply Large (6), Data Lover (5), Outerfield (5) |
| "Doesn't look like the screenshots" | 31 | 1.2% | SURGE (5), Lachesis (5), Style 7 (4), Pure Harmony TiM (3) |
| Wrong time / date / 24h / timezone | 22 | 0.9% | Data Lover (3), Zenith (3), Instinct Mission (3) |
| Connect IQ "IQ!" error icon | 16 | 0.6% | Crystal (11), then singletons across 5 faces |

**Normalised per-face rates (hits ÷ low-star reviews pulled for that face; faces with ≥20 pulled):**

- **Paywall / trial** — Black Hawk Elite 16/34 = **47%**, Zenith 78/193 = **40%**, Outerfield 8/22 = 36%, Black Grid 30/87 = 34%, Vanguard Elite 9/28 = 32%, Fenix 8 V2 - PRO - GB 9/28 = 32%. *This is the strongest single-face concentration in the whole corpus: four in ten of Zenith's low-star reviews are about its pro key.*
- **Device support / fit** — Rad-Lad 22/70 = 31%, Pure Harmony TiM 49/192 = 26%, Crystal 63/250 = 25%, Lachesis 40/160 = 25%, Instinct Mission 25/106 = 24%, Outerfield 5/22 = 23%. *Remarkably flat across faces — this is an industry-wide failure, not one bad developer. Data Lover's raw count of 28 normalises to only 12%, i.e. it was inflated by pull depth.*
- **Weather** — Data Lover 54/230 = 23%, Tactical Elite 8/35 = 23%, Simple 2 7/33 = 21%, GLANCE 20/116 = 17%, Crystal 30/250 = 12%, Instinct Mission 7/106 = 7%.
- **Settings not saving** — Goals 14/67 = 21%, Black Hawk Elite 7/34 = 21%, Rad-Lad 13/70 = 19%, Style 7 14/97 = 14%, SURGE 14/115 = 12%, Tactical Elite 4/35 = 11%.
- **Battery** — Fenix 8 V2 - PRO - GB 4/28 = 14%, Lachesis 20/160 = 12%, Simple TDB 7/67 = 10%, Data Lover 21/230 = 9%, Outerfield 2/22 = 9%, Tactical Elite 3/35 = 9%. *No face exceeds 14% — battery is diffuse, not concentrated.*
- **Readability** — Lachesis 16/160 = 10%, Pure Harmony TiM 19/192 = 10%, Style 7 9/97 = 9%, SURGE 9/115 = 8%, Vanguard Elite 2/28 = 7%, Simple 2 2/33 = 6%.

**Verbatim quotes, device support / fit (376 reviews):**
- "The Watch face is too small for 51mm fenix 8 its like having a 43mm watch face how do i fix that ?" — *Vanguard Elite*, 1★, 2026-09-05, 28 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/68e85cf4-2308-40c7-9ea1-0e762cbd29a6/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Great design and graphics… However, although it is listed as compatible with the Garmin Forerunner 255, the experience on non-touch devices is very frustrating." — *Rad-Lad Watch Face*, 2★, 2026-05-27, 12 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/640309de-3f18-402b-a654-bfb769dfd485/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "I had this on my 8 Pro and loved it. Now on my 9 Pro 51mm, the data is all swished into the upper left portion of the watch dial." — *Data Lover*, 1★, 2026-09-01 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/bcb58298-3e71-4d9a-9084-169e581df99c/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)

**Verbatim quotes, paywall / trial key (366 reviews):**
- "Forever having to uninstall and reinstall because of it resetting to trial mode" — *Black Hawk Elite*, 1★, 2026-08-25, 34 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "It says it's free, but after 3 days it becomes paid and asks for a key. This is a very disappointing situation. Some things shouldn't be about money, and it feels very misleading." — *Zenith*, 1★, 2026-05-27, 5 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/2120f6b9-97d3-4014-8062-576f8516b7d4/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Was great until they pulled it from my watch and put up a pay wall. Spent a good amount of time getting the settings right just to do that out of nowhere." — *Black Hawk Elite*, 1★, 2026-06-18, 17 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

**Verbatim quotes, settings not saving / resetting (213 reviews):**
- "Watch face constantly loses data fields through the day until pretty much just the time is showing and eventually resets itself at some point. Had to stop using it." — *Black Hawk Elite*, 1★, 2026-08-27, **49 upvotes — verified as the single most-upvoted low-star review across all 2,544; the runners-up are Black Hawk Elite's own settings-reset review at 46 and its payment failure at 38** — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Why are the color settings constantly resetting? It happens gradually: first the icons revert to default, followed by the bottom circle and the clock digits." — *Black Hawk Elite*, 2★, 2026-08-14 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)
- "Works well untill you want to safe them on your watch. Constantly need to install them all the time from the phone app. Real shame" — *Face It®*, 1★, 2026-04-22, 9 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c33a05fa-bb7b-46a4-87b4-482a3e726a11/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

**Verbatim quotes, weather (167 reviews):**
- "Was great until I moved. Following everything in the FAQ but it's stuck on my previous home across the country. Deleting today because I'm tired of trying to fix it." — *Data Lover*, 1★, 2026-08-20 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/bcb58298-3e71-4d9a-9084-169e581df99c/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)
- "It was alright until it started showing the weather for a location on the other side of the world. Nothing I do will keep it from changing to the city I've never been to." — *Data Lover*, 1★, 2026-08-18, 2 upvotes — same source
- "Temperature is in Farenheit by default. Lame" — *Simple 2*, 1★, 2026-05-23 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/9d62ccde-e6e8-44ba-bf4e-24cd7e38d3e6/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

**Verbatim quotes, battery (114 reviews):**
- "Ate my battery from 80% to 21% just overnight with default settings. Normally my buttery lasts for 14-28 days :(" — *Goals*, 1★, 2025-05-26 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Made my Fenix8 REALLY SLUGGISH. You press the light (or any button) and it comes up 3-8\" later. As soon as I swap to other faces, watch is fast again. It also drain the battery 2 times faster!" — *Tactical Elite*, 1★, 2026-06-27, 4 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/874aecfe-b441-4ad0-a581-b8505f929a5f/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Great but sucks out my fenix's 6 pro battery like a baby momma's titts 😆 The watch is dead after 2.5 days, instead of 7-10 days on a default one." — *Data Lover*, 2★, 2026-07-28 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/bcb58298-3e71-4d9a-9084-169e581df99c/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)

**Verbatim quotes, always-on display (40 reviews — the smallest of the "expected" themes):**
- "AOD data fields are always set to heart rate and steps, even if you change them on the main display. Severely laking customization options and extremely limited data options for the data fields." — *Outerfield*, 2★, 2026-04-28, 3 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/feee5b06-f020-4831-89dd-1a042e0a176e/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Looks great but too slow - takes a few seconds to leave sleep mode and show the actual watch face." — *Pure Harmony TiM*, 2★, 2026-06-16, 9 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce4b5593-c8b6-43d3-9702-11dad57ef491/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Does not work with always on. Makes the nice custom face made useless!" — *Face It®*, 1★, 2026-06-12, 2 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c33a05fa-bb7b-46a4-87b4-482a3e726a11/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

**Verbatim quotes, bugs / wrong / stuck / frozen / laggy (188 reviews — the 4th-largest theme):**
- "I was so happy with this app and was almost level 40 but suddenly the lad at the time stopped showing. Nothing worked to get it back so I tried reinstalling and it worked, but now I'm level 1." — *Rad-Lad Watch Face*, 1★, 2026-04-29, 20 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/640309de-3f18-402b-a654-bfb769dfd485/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Looks good, but it's glitchy and not all fields work well. Will uninstall if the bugs are not fixed soon." — *Pure Harmony TiM*, 2★, 2026-04-26, 14 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce4b5593-c8b6-43d3-9702-11dad57ef491/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Just downloaded on my venu4. Managed to switch from time to stars once and now its frozen on zmstats and I can't switch it back. Thanks for the wasted money for 10 secs of excitement!" — *Rad-Lad Watch Face*, 1★, 2026-06-07, 4 upvotes — same Rad-Lad source

**Verbatim quotes, missing / limited data fields (109 reviews):**
- "Great layout but it caused my watch step history to lose count" — *Simply Large*, 2★, 2026-08-21, 9 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/a94f8711-50f3-424c-a867-43ace7c699eb/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Calories burned part sucks, I want total cals not just active cals....watch face is worthless without it" — *Face It®*, 1★, 2026-06-16 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c33a05fa-bb7b-46a4-87b4-482a3e726a11/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "The work done seems great, but the body metrics, stress, sunrise/sunset etc.. don't always work well, they don't update. It's not a good face, it doesn't work well" — *Quipu - Data Watch Face*, 1★, 2026-09-09, 1 upvote — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/e4f08276-7c26-46d9-9409-91f945527ab1/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

**Verbatim quotes, wrong time / date / units (22 reviews — the smallest theme):**
- "I find 2 things wrong with the weather doesn't work and yes my Fenix 8 gets weather and second the sunset shows maybe in a 24hr format not 12. Lacking instructions on how to fix." — *Fenix7 Pro Analog OWM MB*, 2★, 2025-09-28 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/39e068a5-c8c0-4600-ad55-587d246c3336/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "I can change the weather to Celsius but not miles to km any help ?" — *Goals*, 2★, 2026-03-02 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

**Signal quality, measured not estimated:**
- Median low-star review length: **72 characters**. Mean 102.3. Only **24.0% (610/2,544)** exceed 130 characters — close to the prior researcher's 39/900 (4.3%) but notably higher, because filtering to low-star selects for people who had something to say. — measured over the corpus described above
- **18.6% (473/2,544)** of low-star reviews are non-English (Spanish, German, French, Polish, Portuguese, Italian, Russian, Ukrainian, Japanese observed). The `locale` param is ignored by the API, so these cannot be filtered out and were classified in place. English-keyword clustering under-counts every theme by roughly this fraction.

### Inferences
- The expected theme list was built around *what a watch face does*. The data says the top
  complaints are about *how a watch face is acquired, licensed and fitted to hardware* —
  commerce and compatibility, not horology. Two of the top three themes (device support,
  paywall) never touch pixel rendering.
- Weather complaints concentrate overwhelmingly on **Data Lover (54 of 167, 32%)**, which is
  a data-dense face. This looks face-specific (a bad location-caching implementation), not a
  platform-wide weather problem.
- Battery complaints are real but are the **7th** theme, not the first. At 4.5% they are a
  tail risk, not the defining gripe. Several battery reviews (Tactical Elite, Pure Harmony)
  co-occur with lag/sluggishness complaints, suggesting an expensive per-minute draw loop
  rather than AOD pixel cost.

### Gaps
- Two faces (Face It®, Crystal) hit the 250-row collection cap, so their true low-star volume
  is unknown and their theme counts are floors, not totals.
- Non-English reviews were classified by a keyword net that includes only a handful of
  non-English stems. Themes in the 473 non-English reviews are systematically under-counted;
  I have not quantified by how much.
- The API exposes no per-star histogram, so I cannot state what fraction of each face's
  *total* reviews are low-star except via the sampling in Key Question 3.

---

## Key Question 2 — Accessibility, low vision, font size, contrast, colour blindness

### Takeaway
**The prior researcher's "strongest gap" claim is NOT corroborated by store review data — it
is weakly refuted.** A tight net finds only **37 of 2,544 low-star reviews (1.45%)** touching
low vision, font size or readability-by-eyesight, and only **5 reviews (0.20%)** mention
contrast, dimness, glare or sunlight. Zero reviews in the entire 2,544-review corpus mention
colour blindness. This is a genuine but small complaint pocket, not a dominant unmet need.
**The refutation survives the known bias in the instrument:** the net is English-only and
18.6% of the corpus is not English, so even assuming non-English reviews hit low-vision
language at the same rate, the adjusted ceiling is only ~1.8% for low vision and ~0.25% for
contrast — still an order of magnitude below the top themes.

### Cited Findings
- Tight low-vision/font net (`too small`, `small text/font/numbers`, `font size`, `bigger/larger font`, `can't read`, `hard to read`, `unreadable`, `illegible`, `eyesight`, `without glasses`, `colour blind`, `low vision`): **37 hits / 2,544 = 1.45%**, concentrated in Pure Harmony TiM (13), Style 7 (6), Face It® (3), Vanguard Elite (2), SURGE (2), Lachesis (2) — measured over the corpus described in Method
- Tight contrast/sunlight net (`contrast`, `washed out`, `too dim`, `too dark`, `too bright`, `sunlight`, `in the sun`, `glare`): **5 hits / 2,544 = 0.20%**, one each on Face It®, Rad-Lad, Fenix7 Pro Analog OWM MB, Lachesis, Style 7 — same corpus
- **Zero** occurrences of "colour blind" / "color blind" / "colorblind" in 2,544 low-star reviews — same corpus
- "Not for me. If the date was displayed in large format instead of the digital time it would have been perfect. I cant read the date without glasses." — *Pure Harmony TiM*, 1★, 2026-07-16, **13 upvotes** — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce4b5593-c8b6-43d3-9702-11dad57ef491/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Face is too small and low quality. Why is there no dark mode? I'd avoid this." — *Pure Harmony TiM*, 2★, 2026-07-24, 10 upvotes — same source
- "This is a very poor watch face you can't adjust the settings and the face is difficult to read going to try and get my money back" — *Style 7*, 1★, 2026-05-22, 2 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/42ca648f-0779-4a72-a4f1-9ab3d381456c/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "Can't see the time or anything else outside in natural light boor contrast" — *Face It®*, 1★, 2026-08-06 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c33a05fa-bb7b-46a4-87b4-482a3e726a11/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "The display is very blur and, especially in sunlight, hardly readable. Not even remotely as the pictures suggest" — *Style 7*, 2★, 2025-03-06 — same Style 7 source
- **Crucially, most "too small" complaints are about device-fit, not eyesight.** The highest-upvoted one in the whole net — "The Watch face is too small for 51mm fenix 8 its like having a 43mm watch face" (*Vanguard Elite*, 1★, 2026-09-05, 28 upvotes) — is a rendering-scale bug on a large bezel, not an accessibility request — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/68e85cf4-2308-40c7-9ea1-0e762cbd29a6/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- Note the broader "readability" theme in KQ1 counts **105 reviews (4.1%)**, but inspecting the
  hits shows the majority are *font-doesn't-match-the-screenshot* complaints (heavy on
  Lachesis: "The font is not the same as the one shown, which is a shame", 2★, 2026-05-20, 6
  upvotes), i.e. a marketing-accuracy problem, not a legibility one — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/fa9c2fd6-cce0-49a0-aa94-20a129623164/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)

### Inferences
- If accessibility were a large unmet need, it should surface in 1★/2★ reviews of the most
  popular faces — those are exactly the users who tried a face and rejected it. At 1.45% it
  does not. The prior "strongest gap" finding most likely came from a source that selects for
  articulate, long-form complaint (forums, Reddit), where low-vision users are over-represented
  relative to their share of store reviewers.
- The near-total absence of contrast/sunlight complaints (0.20%) is itself informative:
  Garmin's MIP displays are genuinely good in sunlight, and OLED users complain about AOD
  behaviour rather than brightness. This retires "unreadable in sunlight" as a target.
- A residual, real, small niche exists: "large date / large numerals, readable without
  glasses". Pure Harmony TiM's 13-upvote review is the clearest single statement of it. But
  the market already has an answer — *Simply Large* (a94f8711, 1M downloads, 4.3★) is
  literally that product, and its own low-star reviews are about AOD and step-count bugs, not
  about size. The niche is served.

### Gaps
- Store reviews are a biased instrument for accessibility: a user who cannot read a face may
  uninstall without reviewing, and may not frame the problem in the vocabulary I searched for.
  A 1.45% store-review rate is a floor on true prevalence, not a measurement of it.
- I found no way via this API to query reviews by reviewer demographics or device display
  type (MIP vs OLED), which would separate contrast complaints properly.

---

## Key Question 3 — Which complaints are UNFIXED, and has the mix shifted 2025→2026?

### Takeaway
Three complaints recur across multiple recent reviews on still-highly-ranked faces and are
therefore durable, unfixed gaps: **settings/state silently resetting**, **licence-key and
trial-reset failures**, and **device-fit breakage on new hardware**. A second pass using
`sortType=CreatedDate&ascending=false` on five faces confirms the low-star base rate is
2.5–4.5% of recent reviews on most faces but **12.0% on Black Hawk Elite**, which is
licence-reset driven.

### Cited Findings

**Version recency.** Only **153 of 2,544 (6.0%)** low-star reviews were filed against the
face's *current* `latestExternalVersion`; 2,391 (94.0%) were filed against an older version.
Ratings-sorted pulls therefore skew historical, and version-matching alone cannot prove a
complaint is unfixed. — measured by joining review `appExternalVersion` to the app list's
`latestExternalVersion`

**Temporal shift within the low-star corpus (2025 n=745, 2026 n=955):**

| Theme | 2025 share | 2026 share | Direction |
|---|---|---|---|
| paywall_unlock | 21.5% | 15.2% | ↓ down 6.3pp |
| device_support | 14.8% | 11.5% | ↓ down 3.3pp |
| weather | 5.2% | 3.0% | ↓ down 2.2pp |
| battery | 3.6% | 2.4% | ↓ down 1.2pp |
| install_download | 6.2% | 7.5% | ↑ up 1.3pp |
| readability | 4.4% | 4.8% | ↑ up 0.4pp |
| settings_sync | 8.2% | 8.4% | ~ flat |
| broken_after_update | 1.2% | 1.7% | ↑ up 0.5pp |
| aod_alwayson | 1.3% | 1.8% | ↑ up 0.5pp |
| inaccurate_wrong | 6.0% | 6.0% | ~ flat |

**CreatedDate second pass, 2026-09-22** (`sortType=CreatedDate&ascending=false`, 200 most
recent text reviews per face, low-star filtered client-side):

| Face | Recent reviews sampled | Date range covered | 1★/2★ among them | Low-star rate |
|---|---|---|---|---|
| Goals | 200 | 2026-07-31 → 2026-09-21 | 7 | 3.5% |
| Zenith | 200 | 2026-08-24 → 2026-09-21 | 5 | 2.5% |
| Data Lover | 200 | 2026-05-21 → 2026-09-21 | 9 | 4.5% |
| Black Hawk Elite | 200 | 2026-05-23 → 2026-09-20 | 24 | **12.0%** |
| GLANCE watch face | 200 | 2026-09-02 → 2026-09-21 | 5 | 2.5% |

**Durable gap 1 — settings and state silently reset.** Flat at ~8.4% and still producing the
corpus's highest-upvoted complaint in the last 30 days:
- "Watch face constantly loses data fields through the day until pretty much just the time is showing and eventually resets itself at some point. Had to stop using it." — *Black Hawk Elite* (ce3bf722), 1★, 2026-08-27, 49 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "The screen doesn't stay and keeps having me set it over and over after a few days. Annoying ." — *Goals* (c4d24b8d), 1★, 2026-09-02 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)

**Durable gap 2 — trial/licence key resets on paid faces.** Zenith (44,008 reviews, 4.8★, still
rank 21) and Black Hawk Elite are both producing this complaint in September 2026:
- "Pourquoi le cadran indique « this view requires a pro key after trial select another view or check app info» le cadran et soit disant gratuit…." — *Zenith* (2120f6b9), 2★, 2026-09-21 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/2120f6b9-97d3-4014-8062-576f8516b7d4/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)
- "Сначала они дают бесплатно скачать циферблат а через время блокируют некоторые функции. Скам" ("First they let you download the face for free, then after a while they block some functions. Scam.") — *Zenith*, 1★, 2026-08-28 — same source
- "正常に使えていましたが、急に Trial over. Check app info.と表示され、日の出 日の入り 天気 が表示されなくなりました。もちろん、代金は払っております。" ("It was working normally, then suddenly 'Trial over. Check app info.' appeared and sunrise/sunset/weather stopped showing. Of course, I have paid.") — *Black Hawk Elite*, 2★, 2026-08-03 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)
- Store metadata corroborates that these are *developer-side* unlock keys, not Garmin store purchases: Zenith, Black Grid, Instinct Mission and Data Lover all report `pricing: null` and `hasTrialMode: false` in the app list, yet their reviews describe pro keys and trial expiry — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE)

**Durable gap 3 — layout breaks on new hardware.** Complaints name the newest devices
(Fenix 8 51mm, Fenix 9 Pro, Venu 4, Instinct 3), meaning these are fresh, not legacy:
- "Now on my 9 Pro 51mm, the data is all swished into the upper left portion of the watch dial." — *Data Lover* (bcb58298), 1★, 2026-09-01 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/bcb58298-3e71-4d9a-9084-169e581df99c/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)
- "Doesn't fit the watch face properly on the Venu 4 41mm" — *Pure Harmony TiM* (ce4b5593), 2★, 2026-05-03, 14 upvotes — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce4b5593-c8b6-43d3-9702-11dad57ef491/reviews?startPageIndex=0&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true)
- "I am using the Tactix 8, and this watch face causes significant lag. When I press a button, it takes about 2 to 3 seconds to respond." — *Black Hawk Elite*, 1★, 2026-09-19 — [Source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994/reviews?startPageIndex=0&pageSize=25&sortType=CreatedDate&ascending=false&withReviewTextOnly=true)

### Inferences
- The **Rating-ascending pull is not date-truncated** — it spans 2018 to 2026 — but it *is*
  heavily historical (94% against superseded versions). The CreatedDate pass is the more
  honest instrument for "what is broken now", and it is the pass that isolates Black Hawk
  Elite's 12% low-star rate as a live, unresolved incident rather than an artefact.
- Paywall complaints fell 6.3pp from 2025 to 2026 in the aggregate — but that aggregate hides
  that the decline is spread across faces while *concentrating* on the two faces running
  aggressive trial resets. This is not "the industry fixed it"; it is a few developers
  creating most of the pain.
- The four themes that are *rising* (install/download, broken-after-update, AOD, readability)
  are all consistent with a device-fleet transition: new hardware (Fenix 9 Pro, Venu 4,
  Instinct 3) shipping faster than incumbent faces are being updated for it. That transition
  window is the opening for a new entrant.
- Black Hawk Elite at 4.8★ / 12% recent low-star is the clearest example of why star averages
  are not a discriminator, exactly as the constraint anticipated: the average is anchored by
  years of history while the current experience is materially worse.

### Gaps
- I sampled only 5 faces for the CreatedDate pass (5 × 200 reviews). The low-star base rates
  above should not be extrapolated to the other 25 faces.
- Only the 200 most recent text reviews per face were pulled, so for high-volume faces like
  GLANCE the window is under three weeks. A longer window per face would firm up the rates.
- I cannot distinguish "developer fixed it and users stopped complaining" from "users gave up
  and uninstalled without reviewing". Falling theme share is ambiguous evidence.

---

## Key Question 4 — Which themes could a new competing watch face actually fix?

### Takeaway
Only about **a third of low-star complaint volume is addressable by a better-built competing
watch face.** The two largest themes split cleanly: device-fit (14.8%) is largely fixable by a
developer who actually tests on the hardware, while paywall/trial (14.4%) is a business-model
choice a competitor can sidestep entirely rather than fix. Battery and AOD — the themes the
brief expected to dominate — are partly platform-bounded and are small anyway.

### Cited Findings

**Bucket A — Fixable by a competing developer (≈ 36% of low-star volume).**

| Theme | Volume | Why it is fixable | Evidence |
|---|---|---|---|
| Device support / fit | 376 (14.8%) | Layouts break on new bezels because devs ship a scaled layout, not a per-device one. Testing on the device fixes it. | "The Watch face is too small for 51mm fenix 8" — *Vanguard Elite*, 1★, 2026-09-05, 28 upvotes |
| Paywall / trial | 366 (14.4%) | Not a bug to fix — an opening to exploit. A flat one-time Garmin-store price with no developer key removes the entire theme. | "It says it's free, but after 3 days it becomes paid and asks for a key… it feels very misleading." — *Zenith*, 1★, 2026-05-27 |
| Non-touch navigation | subset of 376 | Devs build touch-first and ship to button-only devices untested. | "although it is listed as compatible with the Garmin Forerunner 255, the experience on non-touch devices is very frustrating." — *Rad-Lad*, 2★, 2026-05-27, 12 upvotes |
| "Doesn't look like the screenshots" | 31 (1.2%) | Purely a listing-honesty problem: render screenshots from the actual device. | "I regret this purchase because the watch face is ugly and doesn't match the images shown by the seller." — *Pure Harmony TiM*, 1★, 2026-05-22, 24 upvotes |
| AOD data-field customisation | subset of 40 | The AOD variant simply wasn't wired to the user's field choices. Pure implementation. | "AOD data fields are always set to heart rate and steps, even if you change them on the main display." — *Outerfield*, 2★, 2026-04-28 |
| Weather location caching | subset of 167 | Data Lover's location pinning is a bug in one face, not a platform limit. | "it's stuck on my previous home across the country." — *Data Lover*, 1★, 2026-08-20 |

**Bucket B — Mitigable but rooted in the platform (≈ 19.5%: settings 8.4% + weather 6.6% + battery 4.5%).**

| Theme | Volume | The platform part | The mitigable part |
|---|---|---|---|
| Settings not saving / resetting | 213 (8.4%) | Connect IQ settings sync is phone-mediated and lossy; `Storage`/`Properties` can be dropped on app update or watch reset. | Ship **on-watch settings** so the phone is not in the loop, and re-validate state on every `onSettingsChanged`. Several complaints ("Constantly need to install them all the time from the phone app" — *Face It®*, 1★, 2026-04-22) are specifically about the phone round-trip. |
| Weather not updating | 167 (6.6%) | Garmin's weather comes from the phone/watch weather service; a face cannot force a refresh. | Show a staleness indicator and the resolved location name, so a wrong city is visible rather than silent. Unit defaults (Celsius/Fahrenheit) are fully in the developer's control — "Temperature is in Farenheit by default. Lame" — *Simple 2*, 1★, 2026-05-23. |
| Battery drain | 114 (4.5%) | Per-second updates and AOD refresh are governed by the CIQ watch-face lifecycle and device power budget. | Very much reducible: the Tactical Elite review pairs 2× drain with 3–8s button lag, which is an expensive `onUpdate`, not a platform floor. A face that does its work in `onPartialUpdate` and caches will beat this. |

**Bucket C — Platform-level, no developer can solve (≈ 10%).**

| Theme | Volume | Why it is out of reach |
|---|---|---|
| Install / download / won't load | 177 (7.0%) | Connect IQ store delivery, app-size limits and Garmin Connect app failures. "Impossible à installer, pourtant ma montre apparaît bien dans la liste des appareils compatibles." — *Goals*, 1★, 2026-08-28 |
| "IQ!" error icon | 16 (0.6%) | Usually device memory exhaustion or a CIQ runtime fault. "Immediately after activation, only the Connect IQ error icon (IQ with an exclamation mark) is displayed." — *Circles 2*, 1★, 2026-07-12, 8 upvotes |
| Broken after firmware update | 63 (2.5%) | Garmin ships firmware that changes CIQ behaviour; devs can only react. "Since the last update Vivoactive 5 It doesn't work." — *Simple 2*, 1★, 2026-05-21 |
| AOD gesture/wake behaviour | subset of 40 | Wake-on-gesture and AOD timing are system-owned. "My always on display doesnt maintain this watch face for some reason" — *Pure Harmony TiM*, 1★, 2026-09-19, 4 upvotes |

All quotes above are from the reviews endpoint for the appId named in the corpus table,
observed 2026-09-22 — [Ranking source](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE)

### Inferences
- **The single highest-leverage differentiator is not a feature, it is a licensing promise.**
  14.4% of all low-star volume is trial/key frustration, and it is entirely self-inflicted by
  incumbents. A face that is priced once in the Garmin store with no developer-side key, and
  says so in the listing, removes a sixth of the market's complaint volume without writing a
  line of rendering code.
- **The second is per-device layout discipline.** 14.8% of complaints are fit and navigation on
  specific hardware, and the named devices are the newest ones. Shipping correct layouts for
  Fenix 8 51mm / Fenix 9 Pro / Venu 4 / Instinct 3, and button-only navigation that does not
  collide with the system UI, addresses complaints incumbents are visibly not addressing.
- **Settings persistence is the sleeper.** At 8.4% it is flat year over year, it produced the
  most-upvoted complaint in the corpus, and its mitigation (on-watch settings) is a known,
  bounded engineering choice rather than a platform wall. It sits in Bucket B but behaves like
  Bucket A for anyone willing to do the work.
- Conversely, **battery and AOD are poor differentiators**. Combined they are 6.1% of low-star
  volume, both are partly platform-bounded, and competing on them is competing on a dimension
  users rarely complain about.

### Gaps
- The Bucket A/B/C percentages are my classification of theme volume, not a measured property
  of the reviews; themes overlap, so the buckets do not sum to 100% and should be read as
  proportions of complaint *attention*, not disjoint counts.
- I decoded `settingsAvailabilityInfo.availabilityByDeviceTypeId` and it does **not** answer
  whether settings are on-watch or phone-side — it is a boolean per device type for "this face
  exposes configurable settings at all". It is near-universally `true` (Goals 221/221 devices,
  GLANCE 217/217, Black Hawk Elite 219/219). The one exception is informative and worth
  recording: **Face It® reports `false` on all 76 of its device types**, i.e. it exposes no
  Connect IQ settings whatsoever and is configured entirely from the phone app. That
  co-occurs with Face It® topping the install/download theme (35 hits) and with its
  "Constantly need to install them all the time from the phone app" review — but co-occurrence
  is all I can claim: no-CIQ-settings and installs-failing are different mechanisms and I have
  no evidence linking them causally. The on-watch-vs-phone distinction itself is not exposed
  by this API and would need the app manifests to confirm.
- No cost or conversion data is available from this API, so the commercial upside of the
  no-developer-key positioning is an inference from complaint volume alone.
