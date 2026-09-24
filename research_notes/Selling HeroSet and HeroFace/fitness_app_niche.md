# Connect IQ WATCH APP market — strength / rep-counting / bodyweight niche

All store-API snapshots taken **2026-09-22** (UTC), `countryCode=US`, prices returned in EUR
by the endpoint. Download counts from this API are **bucketed** on a 1/5 ladder (1, 10, 50, 100,
500, 1000, 5000, 10000, 50000, 100000, 500000, 1000000, 5000000, 10000000) — every `dl` figure
below is a bucket floor, never an exact install count.

Base URL used throughout: `https://apps.garmin.com/api/appsLibraryExternalServices/api/asw`

---

## Q1. Most popular WATCH APPS: profile, 120-cap, paid share

### Takeaway
The 120-item paging cap applies to watch apps exactly as it does to faces, but the paid share is
radically different: **103 of the top 120 watch apps are paid (86%)** versus 51/120 (43%) for
faces, and **2,49€ is the modal price (58 of 103 paid apps, 56%)** — i.e. HeroSet is priced
exactly on the mode of the category.

### Cited Findings
- `appType` values: the endpoint **rejects** `WATCHAPP`/`MUSIC`-style upper-case tokens with
  `IllegalArgumentException: Invalid app-type! Only these app-types are valid:
  audio-content-provider-app, background, datafield, watch-app, watchface, widget`. The working
  value for apps is **`watch-app`** (hyphenated, lower-case). — [apps.garmin.com API, 2026-09-22](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=5&sortType=mostPopular&countryCode=US&appType=WATCHAPP)
- `sortType=mostPopular&appType=watch-app` returns 30 rows at offsets 0/30/60/90 and an **empty
  array at offset 120** — same hard cap as faces. — API, 2026-09-22
- Top 20 most-popular watch apps, 2026-09-22 (name | download bucket | rating / review count | appId):
  1. Connect IQ™ Store | 10,000,000+ | 4.6 / 29,964 | `7cd38736-510a-4480-8801-0dfe2f5944af`
  2. Women's Health Tracking | 10,000,000+ | 2.6 / 690 | `18b4e2cd-fadd-4ab0-bead-1a62987b9065`
  3. Garmin Connect™ Challenges | 5,000,000+ | 3.7 / 405 | `57c2c92a-4fb8-4c63-8d3b-d906bd720c82`
  4. Hydration Tracking | 5,000,000+ | 2.7 / 1,005 | `d41f9afa-500a-4b58-819f-f418fffd782e`
  5. komoot | 1,000,000+ | 4.2 / 15,655 | `d918ae1e-9e7b-4fdf-b336-46141a0ccd6a`
  6. Maps4Garmin | 1,000,000+ | 4.7 / 139,043 | `f2cde121-a834-4718-a4ba-bf79d28a4e27`
  7. Google Maps | 500,000+ | 4.4 / 6,824 | `f140ff7f-d19e-49f1-b851-01c7e0009d6c`
  8. **Push-Up Hero | 10,000+ | 4.3 / 898 | `787e795f-2426-4e41-b172-9a197d5f0f68`**
  9. Wikiloc | 1,000,000+ | 3.8 / 2,299 | `54505088-813d-4700-afea-a3105366ec6b`
  10. WhatsApp | 100,000+ | 2.6 / 1,277 | `be8115a2-a4e0-49b7-9ed5-8851d5f648cc`
  11. Calculator | 500,000+ | 4.2 / 356 · 12. HYDRATE+ | 10,000+ | 4.7 / 2,700 ·
  13. Holy Bible | 10,000+ | 4.8 / 2,327 · 14. dwMap | 1,000,000+ | 4.3 / 1,344 ·
  15. WHM breathing | 50,000+ | 4.8 / 1,716 · 16. Crossy Road 3D | 10,000+ | 4.6 / 214 ·
  17. WHM breathing+ | 1,000+ | 4.9 / 559 · 18. GoPolar Cold Plunge | 1,000+ | 4.2 / 122 ·
  19. CamCtrl for iOS | 1,000+ | 4.2 / 60 · 20. Sauna tracker PRO | 10,000+ | 3.7 / 124
  — API ranking sweep, 2026-09-22
- Also inside the top 40: **Plank Hero (#36)**, **Sit-Up Hero (#38)**, RuckTrack (#35),
  Hybrid Smash for Hyrox (#31). Four of the top 40 watch apps are strength/bodyweight apps,
  three of them from the same developer. — API, 2026-09-22
- Paid/free split of the top 120 watch apps: **103 paid, 17 free**. — per-app `pricing.salePrice`
  sweep over all 120 ranked ids, 2026-09-22
- Price histogram of those 103 paid apps (EUR): 2,49 ×58 · 3,49 ×10 · 2,99 ×9 · 2,69 ×5 ·
  4,69 ×4 · 5,99 ×3 · 6,99 ×3 · 9,99 ×3 · 3,29 ×2 · 11,49 ×2 · 6,49 ×1 · 5,49 ×1 · 5,29 ×1 ·
  40,29 ×1. — API, 2026-09-22
- Category distribution of the top 120 watch apps (`categoryId`): GAMES(206) 39 ·
  SPORTS(212) 13 · 213 (unnamed) 13 · **HEALTH_AND_FITNESS(219) 9** · NAVIGATION(210) 8 ·
  WELLNESS(254) 6 · **STRENGTH_TRAINING(277) 6** · LIFESTYLE(208) 4. — API, 2026-09-22

### Inferences
- Watch apps are a genuinely *paid* market in a way faces are not. Free is the exception (17/120),
  and most of the free slots are Garmin's own first-party apps or big brands (Google Maps,
  WhatsApp, komoot). An indie paid app is the norm here, not a handicap.
- 2,49€ is not just "a" price point, it is the convention. Pricing above it is a deviation that
  needs a justification (Hybrid Smash at 9,99€ and RuckTrack at 3,49€ are the exceptions).
- Push-Up Hero sitting at #8 overall — above Wikiloc, WhatsApp and Calculator, with only a
  10,000+ bucket against their 100,000–1,000,000+ — is strong evidence the blended
  velocity+rating "most popular" score rewards recent momentum, and that a small, focused,
  fast-updating fitness app can out-rank mass-install utilities. That is the single most
  encouraging structural fact for HeroSet.

### Gaps
- Category IDs 213, 200, 205 could not be resolved to names (see Q6 for the enum names that did
  resolve). Not decision-critical.

---

## Q2. Direct competitors to a bodyweight rep counter

### Takeaway
The competitive set is not diffuse — it is **one dominant incumbent (Strafe's "Hero" family,
5 apps, all 2,49€)**, **one spam-volume shovelware publisher (bikintulis.de, ~25 near-identical
"Power Pro" apps)**, and **a wave of ~15 brand-new free entrants that all landed in the last
five weeks**. HeroSet's name is a near-collision with the incumbent's brand.

### How the set was derived (API limitation worth recording)
- **The ranking endpoint has no working search parameter.** `searchTerm`, `searchWord`, `search`,
  `q`, `query`, `keyword`, `keywords`, `name`, `text`, `filter`, `searchString`, `appName` were
  all probed and all returned byte-identical result sets to the unfiltered call. Any apparent
  search hit is coincidence of default ordering. — API probe, 2026-09-22
- **A working category endpoint exists and is the right browse surface:**
  `GET /asw/apps/categories?categoryNames=<ENUM>&startPageIndex=<offset>&pageSize=30&countryCode=US&appType=watch-app&sortType=mostPopular`.
  `categoryNames` takes an upper-snake enum, not an id and not a display name; invalid values
  return `CategoryName=<x> not found/valid!`. Confirmed-valid enums and their ids:
  HEALTH_AND_FITNESS=219, RUNNING=220, GOLF=278, CYCLING=216, SWIMMING=221, GAMES=206,
  LIFESTYLE=208, WEATHER=215, NAVIGATION=210, SOCIAL=211, SPORTS=212, TRAVEL=214, FINANCE=204,
  EDUCATION=202, MEDICAL=209, WELLNESS=254, **STRENGTH_TRAINING=277**, plus TOOLS,
  ENTERTAINMENT, HIKING, BUSINESS, COMMUNICATION (ids not captured). — API, 2026-09-22
- `STRENGTH_TRAINING` + `watch-app` returns **100 distinct apps** and then stops. **This is a real
  count, not a cap** — the same sweep run against `GAMES` and `HEALTH_AND_FITNESS` each returned
  exactly **120** and then an empty page, i.e. the category endpoint carries the same 120 cap as
  the global ranking and STRENGTH_TRAINING simply falls short of it. 100 is therefore the whole
  addressable shelf HeroSet should be on. — API, 2026-09-22
- **Paid share inside STRENGTH_TRAINING is the inverse of the top-120 overall: 27 paid / 73 free.**
  Paid prices: 2,49€ ×16 · 2,69€ ×5 · 2,99€ ×4 · 4,69€ ×1 · 4,99€ ×1. Almost all the paid ones are
  Strafe (5) and bikintulis.de (~18). — API full-category price sweep, 2026-09-22

### Cited Findings — the incumbent: Strafe's "Hero" family (all 2,49€, no trial)
| App | appId | dl bucket | rating / reviews | version | first approved | last changed |
|---|---|---|---|---|---|---|
| Push-Up Hero | `787e795f-2426-4e41-b172-9a197d5f0f68` | 10,000+ | 4.3 / 898 | v1.7.3 | 2025-03-06 | 2026-09-10 |
| Pull-Up Hero | `c21775bc-6c3b-41bb-b2d4-364c46278283` | 1,000+ | **3.4 / 45** | v1.3.2 | 2025-04-11 | 2026-08-31 |
| Sit-Up Hero | `093aa044-f08f-428b-ad87-c748a16679c9` | 1,000+ | 4.9 / 40 | v1.3.2 | 2025-09-15 | 2026-08-26 |
| Plank Hero | `ed655523-fc72-4025-a8b2-783f295258b1` | 1,000+ | 4.8 / 48 | v1.1.4 | 2026-02-23 | 2026-08-26 |
| Squat Hero | `f3fd0a70-74fd-425a-84f6-1d02d66d93ae` | 100+ | 4.6 / 27 | v1.1.3 | 2026-04-24 | 2026-08-31 |
— all rows: per-app API detail calls, 2026-09-22

All five are **actively maintained** (every one changed within the last 4 weeks; Push-Up Hero has
shipped 27 internal versions since March 2025). Strafe monetises by one-exercise-per-app:
five separate 2,49€ purchases, ~12,45€ to cover push-up + pull-up + sit-up + plank + squat.

### Cited Findings — the shovelware publisher: bikintulis.de
~25 apps in STRENGTH_TRAINING alone, all first-approved between 2026-06-08 and 2026-09-16, all
bulk-updated on the same dates (2026-08-24, 2026-09-06/08). Representative rows (2026-09-22):
Push-Up Workout Pro `b8ebe15a-…` 2,49€ dl10+ 4.0/4 · Sit-Up Workout Pro `6c0b9d2d-…` 2,49€ dl10+ 5.0/2 ·
Pull-Up Workout Pro `6cde37cd-…` 2,49€ dl1+ 5.0/2 · Bodyweight Workout Pro `1fab5642-a950-474a-a4e6-1bba7f530872`
2,49€ dl10+ 5.0/2 · Dips Workout Pro `8cccfed8-…` 2,49€ · GYM Power Pro `79b17871-…` 2,69€ dl10+ 4.7/7 ·
Kettlebell Power Pro `8bd89689-…` 2,99€ dl10+ 4.4/7 · CrossFit Power Pro `6d7488e5-…` 2,49€ dl10+ 4.4/7 ·
CROSSFIT COACH PRO `bf3aa6a8-…` 4,99€ dl1+ · Deadlift/Squats/Tabata/Ironman/Powerlifting/Hyrox "Power Pro"
variants 2,49–2,99€, all dl1–10+. Several are paired with a FREE "trial" twin
(Kettlebell Power `e493e5e0-…` dl100+, SQUATS POWER `5abaa39d-…`, Deadlift Power `94c658bc-…`,
CrossFit Coach Trial `a134a354-…` dl100+, Home Trainer Trial `fff6ef33-…`).
— API category sweep, 2026-09-22

### Cited Findings — the September-2026 free wave (all first-approved 2026-08-27 → 2026-09-22)
DechFit `4dced9aa-…` (2026-09-22, dl0) · FitnessRec `6406ecd8-…` (09-21) · ReplayFIT `c2312370-…` (09-21) ·
Plates – Barbell maths `787aaac9-…` (09-18, dl10+) · Hangboard – Finger Training `a19df664-…` (09-17) ·
Last Set `c25c3605-…` (09-15) · **Push-Up Counter (Deyve) `e4d8897c-d0f2-4bef-a0af-58653bf010ff` 2,49€ (09-15)** ·
PT Training `6c1309ee-…` (09-14) · **Rep Counter (Janssenhidal) `2d4b2b8f-6c93-40e6-b4dc-f2fddf95a451` FREE (09-08, 5.0/1)** ·
Recover – HR Rest Timer `cbbd7d39-…` (09-08) · Rest Timer `909d6468-…` (09-02, dl100+) ·
IronDesk `bee610d4-…` (08-31) · Gym Timer `0aa9cd4d-…` (08-27) · Alke `ad9f10f7-…` (09-08) ·
Fitless `5b33f0d7-…` (08-18) · MoonGym `76b6a75e-…` (08-17) · EMOM Kettlebell `369e67ae-…` (08-17).
Also **Pull-Up Counter (Deyve) `26ed0a36-2692-4109-bb6d-3690195000bc` 2,49€ (2026-08-06)** and
**Push Up Master (Warien) `1dcc5fa6-8f2f-4cb8-abe7-9ca74e27b6a1` FREE, dl1,000+, 4.7/15 (2026-05-18)**.
— API category sweep + per-app detail, 2026-09-22

### Adjacent, not direct
RuckTrack `201e9e43-f33c-4b56-b3f5-8a67184e3d1c` 3,49€ dl1,000+ 4.6/20, cat SPORTS, updated 2026-09-08 ·
Hybrid Smash for Hyrox `c127ac62-342e-4995-a7b0-b091a3c2334b` 9,99€ dl1,000+ 4.1/40, cat SPORTS,
updated 2026-09-16 · Smash Coach `2ebfc2b8-…` FREE dl100+. — API, 2026-09-22

### Abandoned vs maintained (all 100 apps profiled, not just the top of the list)
**94 of 100 were changed within the last ~6 months; only 6 are stale (>180 days):**
Set Counter (Instinct) `jimmychong_92` 233d · Musculamento 240d · Workout Timer (`Mr_Confuzed`,
first approved 2023-06-12) 1,175d · JumpJump Pro Instinct2 1,162d · Workout Timer (`StarGW`,
dl 1,000+, 4.3/13) 1,108d · **InstaHiiT SE (Gym Hiit CrossFit Strength) `YamilGV`, FREE,
dl 50,000+, 3.7/89, last touched 2023-10-25 — 1,062 days stale**. — API, 2026-09-22
This is a category being actively contested right now, not a neglected shelf.

**The tail of the category contains two large free apps the top-of-list view hides:**
- **F3b Strength Training+ `f3b`, FREE, dl 100,000+, 4.0/367, first approved 2018-01-15, updated
  2026-08-31** — ranks *last* (#100) on `mostPopular` despite the largest install base in the
  category. The single biggest free incumbent in strength tracking on Connect IQ.
- **InstaHiiT SE, FREE, dl 50,000+, 3.7/89** — abandoned since 2023 but still installed widely.
- Other notable free mid-tail: Gravl: Personal Trainer `julian-gravl` dl 1,000+ **2.8/36** ·
  Gym Workout Timer `MonkiAppps` dl 1,000+ 4.4/8 · Strength Tracker `breakfinder.surf` dl 1,000+
  4.4/7 · CrossFit Power (bikintulis, free twin) dl 1,000+ · Pull Up Master (Warien) dl 1,000+
  4.8/4 · Gym Workout Tracker `Eduard2004` dl 1,000+ 2.0/1. — API, 2026-09-22
- That F3b sits at rank #100 with 100,000+ installs while Push-Up Hero sits at rank #1 with
  10,000+ is direct confirmation that `mostPopular` for apps is a **velocity+rating blend, not
  lifetime installs** — the same finding already verified for faces.

### Inferences
- The "abandoned incumbent you can out-maintain" thesis does not apply here. Strafe ships
  constantly and answers reviews (visible in review replies, Q3).
- **Naming is a live problem.** HeroSet vs Push-Up Hero / Sit-Up Hero / Plank Hero / Squat Hero /
  Pull-Up Hero: a store browser reading "HeroSet" next to five "* Hero" apps will read it as
  either a Strafe product or a knock-off. That cuts both ways (free association with a 4.3/898
  brand, but no differentiation and possible trademark friction).
- The genuine structural gap: **Strafe sells one exercise per app; nobody sells one app covering
  all bodyweight movements well.** "Bodyweight Workout Pro" (bikintulis) nominally occupies that
  slot but is shovelware at dl10+. That is the wedge HeroSet's positioning should use, and it is
  the only clearly unoccupied position found.
- 17+ new entrants in five weeks, mostly free, is a crowding signal: the window to establish
  the multi-exercise position is closing, and price pressure toward free is arriving.

---

## Q3. What reviews say — accuracy is the category's open wound

### Takeaway
**Rep-count accuracy is the dominant, near-universal complaint**, and it is severe enough that
users call the category a scam. Push-Up Hero has **50+ one-star reviews with text** despite a
4.3 average, and essentially every one of them is an accuracy complaint. Accuracy is not a
technical risk for this product category — it is *the* product.

### Cited Findings — Push-Up Hero 1-star reviews (sorted ascending by rating, text-only, 2026-09-22)
Endpoint: `/asw/apps/<appId>/reviews?startPageIndex=<row offset>&pageSize=25&sortType=Rating&ascending=true&withReviewTextOnly=true`
(fields are `rating`, `text`, `date`, `upvotes`, `appExternalVersion`, `replies`).
Paging `ascending=true` until the rating flipped off 1 gives an **exact baseline of 63 one-star
text reviews** (offsets 0 and 25 are pure 1-star, offset 50 is mixed 1★/2★). 63 of 898 total
reviews — and 63 is only the subset that bothered to write text.
- "Counts exactly 1/10th of the pushups." — 2026-09-18, 6 upvotes, v1.7.3
- "Counts 1 push-up for every 10 I did. I even calibrated it in the settings." — 2026-09-14, 10 upvotes, v1.7.3
- "Do NOT purchase! The app is great if you can only do 3 or less pushups… the 2nd and 3rd times it would not count more than 3 pushups." — 2026-08-12, **27 upvotes**, v1.7.2
- "An absolutely terrible app. The design is ugly and it doesn't work at all." — 2026-08-28, 14 upvotes
- "Poor counter during push up…" — 2026-05-24, 13 upvotes
- "Registriert Liegestütze schlecht… Die Bestenliste funktioniert nicht mit Freunden." — 2026-07-23, 11 upvotes
- "Doesn't count the push ups properly at all, how do you use this app if it shows you did 5 when you did 30?" — 2026-06-08
- "Waste of coin. Leaderboard does not track adjusted number of pushups correctly, and no matter how much you calibrate or have auto calibration on, it never tracks correctly." — 2026-06-03
- "Literally a scam… You get numbers all over the map. And yes I calibrated." — 2026-03-26
- "I did 10 pushups, but the app recorded 25!" — 2026-02-24 (over-count, not just under-count)
- "This is a joke. Was walking and moving my arms and captured 36 pushups. Never even got on the ground." — 2026-01-05 (**false positives from arm swing**)
- "I do sets of 15 pushups and get anything from 0 to 17 back as the count" — 2026-03-09
- "Off like 70% which is huge." — 2026-01-06
— all: reviews API, 2026-09-22

### Cited Findings — the secondary complaint clusters
1. **Manual correction is crippled.** "Count is off and can't be manual adjusted past 1 rep, no way
   to remove sessions that didn't log properly" (2026-01-02); "It counts 5 when you do 15 and you
   can only add 1" (2025-12-18); "after I finish my session I can't fix my rep counter" (2025-12-22).
2. **Doesn't land in Garmin Connect as a real activity.** "Doesn't include number of pushups in the
   Garmin activity" (2026-03-17); "does not show at Garmin activity summary what is the trening and
   the count of repetitives and series" (2025-11-26); "no aparece como actividad en la aplicación
   original de Garmin" (2026-01-06); Plank Hero: "Jammer dat je workout niet terug te zien is in
   Garmin Connect" (2026-04-06). Strava sync mislabels: "it stores them on Strava as 'A workout'
   and not push-ups" (2026-02-24).
3. **Battery drain.** "This app used 80% of the watch's battery in 12 hours" (2025-09-03);
   "Battery issues, goes down like crazy" (2025-11-26); "It consumes a lot of battery and the
   counting is not good" (2025-09-11).
4. **Calibration is the advertised fix and it does not work.** At least 12 of the 50 one-stars
   explicitly say "even after calibration" / "calibrated multiple times".
5. **Layout on round/small screens.** Plank Hero: "Poor layout on instinct 3 due to the circular
   data field blocking the information on the app" (2026-03-24, dev replied).
— reviews API, 2026-09-22

### Cited Findings — what 5-star users value
- Accuracy, when it happens to work: "Super accurate for me! 10/10" (2026-09-22); "counter is
  accurate and seeing overall stats motivates me to do more push ups" (2026-04-16);
  "Works great for me, very accurate and helpful!" (2026-06-09).
- **Leaderboards / competition** — repeatedly the reason for purchase: "Rating back to five stars
  now that the weekly and monthly league tables have reset properly — thanks dev" (2026-08-01,
  28 upvotes); "got it for the leaderboard as an incentive" (a 1-star, 2026-03-06).
- **Motivation and streaks / daily goal**: "Great motivational" (2026-06-06); "when i count it
  gives me motivation" (2026-05-15); Plank Hero "Easy and great to motivate and keep track".
- **Responsive developer**: "I had a problem and the app dev responded quick and fixed it"
  (2026-03-05); Sit-Up Hero "Within one day the developer fixed the problem" (2025-09-30).
- **Zero-setup counting** is prized over calibration: Sit-Up Hero, "Worked straight away without
  the need for a set up, just counted the correct number of sit ups which is great" (2026-07-06).
- Localisation: "Special thanks for the opportunity to select my language" (2026-06-10).
— reviews API, 2026-09-22

### Inferences
- Push-Up Hero's 4.3/898 is a *bimodal* rating, not a good one: a large satisfied cohort plus a
  63-deep bloc of "it counts 1 in 10" one-stars. The distribution says the detector works for
  some body/form/device combinations and fails catastrophically for others.
- The two failure modes reported are opposite (gross under-count *and* arm-swing false positives),
  which points at a fixed-threshold peak detector with no per-user adaptation — exactly the thing
  a better algorithm can beat. This is the clearest product opening in the whole brief.
- **An accurate counter with a working manual correction, a real Garmin Connect strength activity
  with reps, and low battery cost would address every top complaint cluster at once.** Note that
  HeroSet's current feature set (daily goal, complication) addresses the *motivation* cluster,
  which users like, but not the *accuracy* / *Connect activity* clusters, which are what generate
  refund-anger and one-stars.
- Leaderboards are load-bearing for the incumbent's appeal and HeroSet has no equivalent social
  hook. That is a real deficit, not a nice-to-have.

---

## Q4. Observable demand

### Takeaway
Demand for better bodyweight/calisthenics tracking on Garmin is clearly documented on Garmin's
own forums and in the incumbent's install base — but it is demand for *accuracy and a real
activity type*, not for "a rep counter" per se. **Reddit remained unreachable.**

### Cited Findings
- "Automatically track sets, reps, and rests for strength training?" — user wants "set it and
  forget it… not have to click a button to indicate when I'm done with a set"; community reply is
  a manual lap-button workaround; **no Garmin staff reply; thread locked**. —
  [Garmin Forums](https://forums.garmin.com/apps-software/mobile-apps-web/f/garmin-connect-mobile-ios/287125/automatically-track-sets-reps-and-rests-for-strength-training)
- "Why is there no activity for Calisthenics?" — users request Calisthenics as its own activity
  heading. — [Garmin Forums](https://forums.garmin.com/apps-software/mobile-apps-web/f/garmin-connect-mobile-ios/253178/why-is-there-no-activity-for-calisthenics)
- "Can you add a way to track pushups in Garmin Connect?" — [Garmin Forums](https://forums.garmin.com/apps-software/mobile-apps-web/f/garmin-connect-web/229267/can-you-add-a-way-to-track-pushups-in-garmin-connect)
- "apply calisthenics" (Connect IQ Bug Reports) — user asks for dragon flag, human flag, front
  lever, planche in the exercise database; a Connect IQ developer redirects it as a feature
  request. — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/i/bug-reports/apply-calisthenics)
- "Feature Request: Add Advanced Push-Up Variations to Garmin Strength Library" — framed as
  serving "users who follow bodyweight strength progressions and calisthenics routines". —
  [Garmin Forums](https://forums.garmin.com/apps-software/mobile-apps-web/f/garmin-connect-mobile-andriod/436847/feature-request-add-advanced-push-up-variations-to-garmin-strength-library)
- "What activity to use for calisthenics?" (Epix Gen 2) — [Garmin Forums](https://forums.garmin.com/outdoor-recreation/outdoor-recreation/f/epix-2/297980/what-activity-to-use-for-calisthenics)
- A developer in the same threads reports building "CaliMaster Pro… the first Garmin app designed
  specifically for calisthenics", explicitly citing limitations of the native Strength profile for
  calisthenics. (Not found in the STRENGTH_TRAINING category listing as of 2026-09-22.)
- Revealed demand, strongest single datapoint: **Push-Up Hero reached a 10,000+ install bucket and
  898 reviews in ~18 months at 2,49€ with a demonstrably broken counter.** — API, 2026-09-22

### Inferences
- People will pay 2,49€ for a bodyweight rep counter on a Garmin even when it barely works.
  Demand exists; the incumbent is monetising it badly.
- The recurring forum ask is for an *activity profile* and an *exercise library*, i.e. a
  first-class Connect record — which maps directly onto review complaint cluster #2.

### Gaps
- **Reddit could not be reached.** `WebFetch` on `https://www.reddit.com/r/Garmin/search/…`
  returned "Claude Code is unable to fetch from www.reddit.com"; the same block reported in the
  prior watch-face research still applies. No Reddit sentiment in this note.
- `support.garmin.com` FAQ pages return **HTTP 403** to WebFetch; the Garmin *manual* host
  (`www8.garmin.com/manuals/…`) is reachable and was used instead.
- Absolute size of the Garmin bodyweight-training audience is not obtainable — Garmin publishes no
  per-activity user counts, and the store gives only buckets.

---

## Q5. Garmin's own first-party rep counting — the blunt answer

### Takeaway
**Garmin's native rep counting exists on essentially every current watch, is free, and is bad —
peer-reviewed error up to 67.5% MAPE, and Garmin's own manual admits it only works for a single
arm-driven movement per set.** It does *not* make a third-party rep counter redundant; what it
does make redundant is a third-party counter that is merely *as accurate as Garmin's*. Being
"a rep counter for Garmin" is not a product. Being "the rep counter that actually counts" is.
HeroSet's entire case rests on accuracy it can demonstrate, and on producing a proper Connect
activity that the native Strength profile already gives users for free.

### Cited Findings
- Native behaviour (Venu 3 / vívoactive 5 / vívoactive 6 owner's manuals, "Recording a Strength
  Training Activity"): the watch counts reps automatically; "Your rep count appears when you
  complete **at least four reps**"; rep counting is **on by default** and can be disabled; reps
  are "counted when the arm wearing the watch **returns to the starting position**"; "the watch can
  only count reps of a **single move for each set** — when you want to change moves, you should
  finish the set and start a new one"; best results need "consistent, wide range of motion" and not
  looking at the watch mid-rep; users can **edit rep count and add weight** after each set. —
  [Venu 3 Owner's Manual](https://www8.garmin.com/manuals/webhelp/GUID-9CC4A873-E034-4A06-B2E0-636DCFE760EE/EN-US/GUID-49D892BF-429E-454D-B0C6-D4AE07E9D4A0.html)
- Devices: a Gym Activities / Strength profile with rep counting is documented across the current
  vívoactive 5/6 and Venu 3 lines, and Garmin publishes both an "Improving the Accuracy of the Rep
  Counting Feature on a Garmin Watch" and an "Editing the Reps Manually on a Strength Workout"
  support article — i.e. Garmin itself ships documentation for the feature being wrong.
  ([support FAQ ziQyOH7oYa2MrsQFReusJ6](https://support.garmin.com/en-US/?faq=ziQyOH7oYa2MrsQFReusJ6),
  [kX0jWHmOBT8w6xIn8Ali48](https://support.garmin.com/en-US/?faq=kX0jWHmOBT8w6xIn8Ali48),
  [xEPSpxE3j27gpEsiq8K9o8](https://support.garmin.com/en-GB/?faq=xEPSpxE3j27gpEsiq8K9o8) — titles
  from search index; page bodies returned 403.)
- **Peer-reviewed accuracy (2023):** four wrist-worn Garmins (two Instinct, Fenix 6 Pro,
  vívoactive 3) tested over front squat, reverse lunge, push-ups and shoulder press.
  Twenty participants (10F/10M, mean age 23.2 ± 7.7) did 4 circuits of 4 exercises, 1 set of 10
  reps each, dumbbells at light intensity.
  **Mean Absolute Percent Error 3.0–67.5%; Lin's Concordance Coefficient 0.10–0.68.** Conclusion:
  "The wearable wrist-worn devices were **not considered accurate for repetition counts** and thus
  manual counting should be utilized." —
  [Int. J. Exercise Science (Abstracts), vol 14 iss 3, art 143](https://digitalcommons.wku.edu/ijesab/vol14/iss3/143)
  — **publication year not independently confirmed.** An automated fetch summary reported 2023;
  IJES volume numbering (vol 10 = 2017) suggests vol 14 is more likely ~2021–2022, and the full
  PDF host returns HTTP 403. Cite the study as "IJES Abstracts vol 14" and do not assert a year
  without re-checking.
- A second literature finding in the same vein: users of free weights "will need to wait for either
  improved repetition counting algorithms or increased sensitivity of devices before this measure
  can be obtained with confidence." — surfaced via search of the same research corpus
- Press criticism: TechRadar, "Why Garmin's strength training mode needs to be improved – or
  scrapped", reports the built-in tech "consistently failed to record the right number of reps".
  — [TechRadar](https://www.techradar.com/features/why-garmins-strength-training-mode-needs-to-be-improved-or-scrapped)
  (headline and search-index summary only; the article body was behind a signup wall on fetch —
  treat the quote as second-hand.)

### Inferences — stated bluntly, as the brief asks
1. **Garmin natively does what HeroSet does, for free, on the same watches.** Any user who has not
   tried it will reasonably ask "why pay?". That is a permanent, structural headwind on conversion
   and it will show up as "why is this not free" in reviews.
2. **But Garmin does it badly, publicly, and by its own documentation.** Push-ups are specifically
   one of the exercises the 2023 study measured, and the arm-returns-to-start heuristic Garmin
   documents is exactly the heuristic that fails on push-ups (where the arm angle barely changes
   relative to the torso). The 67.5% worst-case MAPE is not a marginal deficiency.
3. **The competitor evidence says third-party does not automatically do better.** Push-Up Hero's
   50+ "counts 1 in 10" one-stars are the same failure mode as Garmin's. So the market is: a free
   bad option and a paid bad option, both leaving the same complaint trail.
4. Therefore the honest read: **the opportunity is real but it is entirely an accuracy
   opportunity.** If HeroSet cannot demonstrate materially better counting than both the native
   Strength profile and Push-Up Hero — with evidence a buyer can see before paying — then yes, it
   is redundant for most users and 2,49€ is unjustifiable. If it can, the free native feature
   actually *helps*, because it has already taught a large audience that they want rep counting and
   that the one they have is broken.
5. Concrete implication: **a trial mode matters more here than anywhere else.** No competitor in
   the Hero family offers one (`hasTrialMode: false` on all five, and on HeroSet). An accuracy
   claim that a buyer can verify for free before paying is the one thing that defeats both "Garmin
   does it free" and "the last one I bought was a scam".
6. Second concrete implication: **write a real Connect strength activity with the rep count in it.**
   That is a capability the native profile has and both Hero and HeroSet are criticised for lacking
   — it is a parity gap, not a differentiator, and it is the #2 complaint cluster.

### Gaps
- No exhaustive device list for native rep counting; Garmin's support pages (which would give it)
  are 403 to fetch. Confirmed present on vívoactive 5, vívoactive 6, Venu 3 series from the
  manuals; the 2023 study also exercised Instinct 2X, Fenix 6 Pro, vívoactive 3.
- No 2025–2026 re-test of native accuracy on current hardware was found. The 67.5% figure is from
  hardware/firmware of roughly 2021–2023 (Instinct 2X, Fenix 6 Pro, vívoactive 3) and may
  overstate present-day error on a vívoactive 6 / Venu 3. Flag this when citing it.
- The study's exact publication year could not be verified (see above).

---

## Q6. Discovery: do watch apps get found differently from faces?

### Takeaway
Same ranking machinery and same 120 cap, but apps have a **real category taxonomy that works as a
browse surface** — and **HeroSet is filed in the wrong category**. Every single rep-counting
competitor sits in `STRENGTH_TRAINING` (277); HeroSet sits in `HEALTH_AND_FITNESS` (219). That is
a free, immediate, high-leverage fix.

### Cited Findings
- HeroSet detail, 2026-09-22: `categoryId: "219"` (HEALTH_AND_FITNESS), price 2,49€, dl 0,
  0 reviews, v1.1.0, created 2026-09-19, first approved 2026-09-21, `hasTrialMode: false`.
  — API `/asw/apps/54bbf625-82af-4715-8af0-f2f16a5d1377`
- Push-Up Hero, Sit-Up Hero, Plank Hero, Squat Hero, Pull-Up Hero, all bikintulis.de bodyweight
  apps, Pull-Up Counter, Push-Up Counter, Rep Counter, Push Up Master: **all `categoryId: "277"`
  (STRENGTH_TRAINING)**. — API, 2026-09-22
- The `STRENGTH_TRAINING` watch-app shelf is **100 apps deep**; `HEALTH_AND_FITNESS` is the
  generic bucket. — API category sweep, 2026-09-22
- The store front end exposes these browse surfaces (from `apps.garmin.com` page markup):
  `category_tree_all`, `category_tree_viewByCategory`, `category_hotFresh`, `category_mostPopular`,
  `category_newAndUpdated`, `category_trending`. — page source, 2026-09-22
- The ranking API honours `sortType=mostPopular`, `sortType=highestRated` and `sortType=trending`
  (each returns a different ordering: mostPopular→Connect IQ Store, highestRated→WHM breathing,
  trending→Google Maps). `newest`, `relevance`, `mostDownloaded` error out. — API, 2026-09-22
- Device-scoped browse pages exist and are indexed by search engines, e.g.
  `https://apps.garmin.com/en-US/devices/venu3/appTypes/watch-app/apps` and
  `.../devices/vivoactive5/appTypes/watch-app/apps` — meaning `compatibleDeviceTypeIds` breadth
  directly determines how many browse pages an app appears on. — search index + page fetch, 2026-09-22
- `applicationTypes`, `developerId`, `locale` and every search parameter tried are silently
  ignored by the ranking endpoint; `appType` and `sortType` and `categoryNames` are honoured;
  `pageSize > 25` on the reviews endpoint returns HTTP 400; `startPageIndex` is a row offset
  everywhere. — API probes, 2026-09-22

### Inferences
- **Fix the category first.** Costs nothing, is a metadata change, and moves HeroSet from a
  generic bucket onto the exact 100-app shelf where every buyer with intent is browsing. This is
  the highest-ROI action identified in this research.
- `highestRated` and `trending` are separate, honoured ranking surfaces. A brand-new app with a
  handful of 5-star reviews can chart on `highestRated` long before it can chart on `mostPopular`
  (cf. the bikintulis.de apps sitting at #5–#18 in STRENGTH_TRAINING on 5.0/1–3 reviews). Early
  reviews therefore buy visibility disproportionately.
- Device compatibility breadth is a discovery lever, not just a support decision.

### Gaps
- Could not verify how the **Garmin Connect mobile app** surfaces watch apps versus faces — that
  UI is not reachable via the web API and no primary Garmin documentation of its ranking was
  found. The Connect IQ Store mobile app is documented as showing "popular and highly rated apps"
  and allowing sort by category, which is consistent with the web surfaces, but this is a store
  listing description, not a spec. —
  [Connect IQ Store on Google Play](https://play.google.com/store/apps/details?id=com.garmin.connectiq)

---

## Q7. Price distribution: paid apps vs paid faces

### Takeaway
Apps are far more monetised than faces (86% vs 43% paid in the top 120) but cluster on an even
tighter price band, with 2,49€ taking a clear majority of all paid apps.

### Cited Findings
- Top 120 watch apps, 2026-09-22: **103 paid / 17 free (85.8% paid)**. Prior verified figure for
  faces: 51/120 paid (42.5%).
- Paid watch-app price distribution (EUR, n=103): **2,49 → 58 apps (56.3%)**; 3,49 → 10 (9.7%);
  2,99 → 9 (8.7%); 2,69 → 5; 4,69 → 4; 5,99 → 3; 6,99 → 3; 9,99 → 3; 3,29 → 2; 11,49 → 2;
  6,49/5,49/5,29 → 1 each; 40,29 → 1 (single outlier). Median 2,49€; 78% of paid apps at ≤2,99€.
  Prior verified band for faces: 2,49–5,99€.
- In the STRENGTH_TRAINING category specifically, paid apps run 2,49€–4,99€ with the sole
  exception of Hybrid Smash for Hyrox at 9,99€ (cat SPORTS). — API, 2026-09-22

### Inferences
- Faces compete on being free; apps compete on being worth 2,49€. HeroSet is correctly priced and
  there is no evident room to price above 2,49€ without a materially differentiated offer.
- The pricing headroom that does exist (3,49€ RuckTrack, 9,99€ Hybrid Smash) belongs to apps with
  a *programme/coaching* dimension rather than a single sensor feature.

### Gaps
- Prices returned in EUR regardless of `countryCode=US`; the USD list price is separately
  visible on store pages (Push-Up Hero is listed at **$1.99 USD** / 2,49€). No systematic USD
  distribution was collected.

---

## MEASUREMENT: appIds to track monthly, and what movement means

Snapshot all of these on the 22nd of each month via
`GET /asw/apps/<appId>?countryCode=US` (fields: `downloadCount`, `averageRating`, `reviewCount`,
`latestInternalVersion`, `changedDate`, `categoryId`) plus a
`GET /asw/apps/categories?categoryNames=STRENGTH_TRAINING&appType=watch-app&sortType=mostPopular`
sweep to capture rank and new entrants. Baseline below = 2026-09-22.

**Tier 1 — the incumbent (watch every month, without fail)**

| appId | App | Baseline 2026-09-22 |
|---|---|---|
| `787e795f-2426-4e41-b172-9a197d5f0f68` | Push-Up Hero | dl 10,000+ · 4.3 · 898 rev · v1.7.3 (int 27) · #8 all watch apps · #1 STRENGTH_TRAINING |
| `c21775bc-6c3b-41bb-b2d4-364c46278283` | Pull-Up Hero | dl 1,000+ · **3.4** · 45 rev · v1.3.2 |
| `093aa044-f08f-428b-ad87-c748a16679c9` | Sit-Up Hero | dl 1,000+ · 4.9 · 40 rev · v1.3.2 |
| `ed655523-fc72-4025-a8b2-783f295258b1` | Plank Hero | dl 1,000+ · 4.8 · 48 rev · v1.1.4 |
| `f3fd0a70-74fd-425a-84f6-1d02d66d93ae` | Squat Hero | dl 100+ · 4.6 · 27 rev · v1.1.3 |

- **Opportunity signal:** Push-Up Hero's `averageRating` falling below ~4.1, or its 1-star text
  review count (rows returned at `ascending=true`; **baseline 63 on 2026-09-22**) passing ~80, or its `latestInternalVersion`
  going 60+ days unchanged. Any of these means the accuracy problem is outrunning the developer and
  the incumbent brand is turning liability.
- **Threat signal:** Push-Up Hero rating rising past ~4.5 **and** the top-of-`ascending=true`
  reviews stopping being accuracy complaints. That means Strafe fixed the detector, and HeroSet's
  differentiator is gone. Also a threat: Strafe shipping a *combined* multi-exercise app — that
  occupies the one clear gap identified here. Watch for a new `Strafe` appId in the
  STRENGTH_TRAINING sweep.
- **Threat signal:** any Hero app dropping to FREE (check `pricing.salePrice`) — price war.

**Tier 2 — the nearest direct clones (cheap to watch, high early-signal value)**

| appId | App | Baseline |
|---|---|---|
| `2d4b2b8f-6c93-40e6-b4dc-f2fddf95a451` | Rep Counter (Janssenhidal) — FREE, generic name | dl 1+ · 5.0 · 1 rev · first approved 2026-09-08 |
| `e4d8897c-d0f2-4bef-a0af-58653bf010ff` | Push-Up Counter (Deyve) — 2,49€ | dl 1+ · 0 rev · 2026-09-15 |
| `26ed0a36-2692-4109-bb6d-3690195000bc` | Pull-Up Counter (Deyve) — 2,49€ | dl 1+ · 5.0 · 1 rev · 2026-08-06 |
| `1dcc5fa6-8f2f-4cb8-abe7-9ca74e27b6a1` | Push Up Master (Warien) — FREE | dl 1,000+ · 4.7 · 15 rev · 2026-05-18 |
| `1fab5642-a950-474a-a4e6-1bba7f530872` | Bodyweight Workout Pro (bikintulis.de) — 2,49€, occupies the multi-exercise slot | dl 10+ · 5.0 · 2 rev |

**Tier 2b — the large free incumbents hiding in the category tail (added after full 100-app sweep)**

| appId | App | Baseline 2026-09-22 |
|---|---|---|
| (see STRENGTH_TRAINING sweep, ranks #96–100) | **F3b Strength Training+** (`f3b`) — FREE | dl **100,000+** · 4.0 · 367 rev · live since 2018-01-15 · updated 2026-08-31 · ranked **#100** on mostPopular |
| (same sweep) | InstaHiiT SE (`YamilGV`) — FREE | dl **50,000+** · 3.7 · 89 rev · **abandoned since 2023-10-25** |
| (same sweep) | Gravl: Personal Trainer (`julian-gravl`) — FREE | dl 1,000+ · **2.8** · 36 rev · updated 2026-09-03 |

- **Threat signal:** F3b adding automatic rep counting. It is free, has 10× Push-Up Hero's install
  base, and is actively maintained after 8 years — it is the one existing app that could take the
  whole niche without anyone noticing. Check its description/changelog monthly for "rep".
- **Opportunity signal:** InstaHiiT SE staying abandoned while holding a 50,000+ bucket at 3.7 —
  that install base is up for grabs by anything that shows up in the same category browse.

- **Threat signal:** any *free* counter (Rep Counter, Push Up Master) crossing the 10,000+ bucket
  or passing 100 reviews. A free accurate counter kills the 2,49€ price point outright.
  Push Up Master already at dl 1,000+ on 4.7 with no price is the most under-rated threat in this
  table.
- **Opportunity signal:** these staying at dl 1–100 buckets through Q4 2026 — confirms that
  shipping an app is not the same as being discovered, and that rank (not existence) is the
  constraint.

**Tier 3 — category health (one sweep, not per-app)**

- STRENGTH_TRAINING watch-app count: **100 on 2026-09-22**, against a **120 endpoint cap**
  (verified: GAMES and HEALTH_AND_FITNESS both return exactly 120). So this metric has only
  20 units of headroom before it saturates and stops being informative.
  - Hitting 120 = the category is flooded *and* the count metric is dead; switch to tracking the
    **composition of the top 30** instead: free share, count of appIds that were not present the
    previous month, and whether any Strafe app has left the top 5.
  - Flat or shrinking = the September 2026 wave was a blip and the shelf is stable.
- Share of STRENGTH_TRAINING apps that are FREE: **73 of 100 on 2026-09-22** (paid: 2,49€ ×16,
  2,69€ ×5, 2,99€ ×4, 4,69€ ×1, 4,99€ ×1). Note this inverts the 86%-paid figure for the top 120
  watch apps overall — **strength training is a predominantly free shelf**, so the 2,49€ ask is
  already the harder sell here than the headline app-market figure suggests. If the free share of
  the *top 20 of the category* rises above ~40%, the 2,49€ position is under real pressure.
- bikintulis.de app count in the category (~25 on 2026-09-22): if it keeps climbing, expect the
  category ranking to be progressively gamed and organic discovery to degrade.

**Tier 4 — the self-measurement that actually decides this**

- `54bbf625-82af-4715-8af0-f2f16a5d1377` (HeroSet) baseline 2026-09-22: dl 0, 0 reviews, v1.1.0,
  **categoryId 219 — wrong shelf**, `hasTrialMode: false`.
  - First thing to re-measure after re-categorising to STRENGTH_TRAINING (277): whether the
    download bucket moves off 0 within 30 days. If a correct category placement plus 2,49€ still
    yields zero installs by 2026-10-22, the constraint is not discovery and the positioning needs
    to change, not the metadata.
  - Track HeroSet's rank position inside the STRENGTH_TRAINING `mostPopular` sweep — that is the
    only number that correlates with being found.

**Non-store signals worth a monthly glance (cheap, no API)**

- New replies on the locked/open Garmin forum threads in Q4 above — sustained calisthenics/rep
  requests = demand is still unmet natively.
- Any Garmin firmware release note mentioning strength/rep-detection improvements. **A native
  accuracy improvement is the single biggest existential risk to this product**, larger than any
  competitor listed above.
