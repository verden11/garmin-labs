# Connect IQ listing optimisation (ASO) and free organic channels

All API observations below were run live on **2026-09-22** against
`apps.garmin.com`. Every query and result is reproducible with the endpoints
documented in the first section.

---

## How does Connect IQ store search work?

### Takeaway

Store search is a **separate endpoint from the browse/ranking endpoint**:
`GET /api/appsLibraryExternalServices/api/asw/apps/keywords`. It is a
**relevance-scored token search over BOTH the title and the description**,
default sort `mostRelevant`, and — critically — **`mostRelevant` is not
weighted by install count**. HeroSet, at 0 lifetime downloads, ranks **#3 of
983** for `rep counter` and **#2 of 347** for `rep counter` filtered to
watch-apps. Search is the one surface a newcomer can win outright, and it is
won with title tokens.

### Cited findings

**The endpoint (undocumented; extracted from the store's own JS bundle).**
The search page is `https://apps.garmin.com/en-US/search?keywords=<q>`. Its
RTK Query definition, in
`https://apps.garmin.com/_next/static/chunks/pages/_app-ef4d22bb97f1fc26.js`,
reads verbatim:

```js
getAppsByKeywords: e.query({query:e=>{let{keywords:t,startPageIndex:r,pageSize:n,sortType:i,appType:l}=e;
  return{url:"/apps/keywords",method:"GET",params:{keywords:t,startPageIndex:r,pageSize:n,sortType:i,appType:l}}}})
```

So the working call is:

```
GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords
    ?keywords=<query>&startPageIndex=<row offset>&pageSize=<=30&sortType=mostRelevant[&appType=watch-app]
```

- Response shape is `{"totalCount": N, "apps": [...], "appTypeNames": [...]}` —
  unlike `/apps`, which returns a bare array. Verified 2026-09-22.
- `pageSize` **> 30 returns HTTP 400**. `startPageIndex` is a row offset, same
  as `/apps`. Verified 2026-09-22 (pageSize=100 → 400; pageSize=30 → 200).
- `appType` accepts the values in the response's own `appTypeNames`:
  `watchface`, `watch-app`, `widget`, `datafield`,
  `audio-content-provider-app`. `WATCHAPP` (the value `/apps` takes) → HTTP 400.
- `searchTerm`, `searchQuery`, `keyword`, `q` on `/apps` are **silently
  ignored** — `/apps?searchTerm=rep+counter` returned the unfiltered
  most-popular list. Any prior research that "searched" via `/apps` was
  reading noise.
- Source: the live API, and the store bundle
  [pages/_app chunk](https://apps.garmin.com/_next/static/chunks/pages/_app-ef4d22bb97f1fc26.js).

**Matching is token-based, OR-combined, not exact-substring.** Query
`push up` → total 997, top results `Push-Up Hero`, `Push-Up Counter`,
`Push-Up Workout Pro`, then `Summit Push` (matches "Push" alone). Query
`workout counter` → top results `WorkoutDatafield`, `Workout`, `Workout`,
`Gym Workout Tracker`, `Counter` — i.e. apps matching only one of the two
tokens. There is no phrase requirement.

**Hyphens and spaces are normalised.** `pushup` (one token, 225 results)
returns `Push-Up Counter` and `Push-Up Hero`; `push up` returns the same apps.
`sit-ups` (727) returns `Sit-Up Workout`, `Sit-Up Hero`. So `push-up`,
`push up` and `pushup` are the same token to the index.

**Plurals are NOT stemmed; unknown tokens degrade into fuzzy noise.**
- `bodyweight` → 969 results, top 3 `Bodyweight Workout`, `Bodyweight Workout
  Pro`, `HeroSet - Bodyweight Rep Counter`. Correct.
- `bodyweights` → 975 results, top 5 are `BrightSide-IOV Big and Easy to Read
  for Seniors`, `Feast of Lights`, `RTW DARKNIGHT D`, `EDGE - Nightawk`,
  `Core (Body) Temperature 2`. **Total garbage** — no bodyweight app in the
  top 5.
- `situps` → 308, top results `Seasons Premium`, `Titan`, `Goals Pro` — garbage,
  while `sit-ups` works.
- `pushup` (225) and `pushups` (234) both work, so plural handling is
  inconsistent — it appears the index holds whatever literal tokens the
  listings contain, and an unmatched token falls back to a fuzzy/partial
  scorer that returns near-random results.

**Typos are NOT tolerated.**
- `puchup` → 138 results, top: `ChileWatchUp`, `Catchup`,
  `1DayNavi35_YAMAGUCHI`, `Sleek Font Simple FREE version`, `AR Bucharest`.
- `bodywieght` → 979 results, top: `Core (Body) Temperature 2`, `Bodysurfing`,
  `A2 Body Battery`, `Watch4Everybody`, `Cave Body Metrics`.
- No did-you-mean, no edit-distance correction. A misspelled search finds
  nothing useful.

**Nonsense returns zero, so it is a real index, not a fuzzy-match-everything.**
`zzzqxwv` → `totalCount: 0`.

**`totalCount` is capped at 1000.** `gym` → exactly 1000. Most multi-token
queries land at 960–998, so totals near 1000 are meaningless as a difficulty
signal; only sub-1000 totals (`pushup` 225, `51mm` 194, `situps` 308, `reps`
510, `squat` 571, `bezel` 621, `sit-ups` 727) are real counts.

**The description IS indexed and IS ranked — but far below the title.**
Controlled test, scanning the ranked result list for HeroSet:

| Query | Where the term appears in HeroSet's listing | HeroSet rank | total |
|---|---|---|---|
| `rep counter` | title + description | **3** | 983 |
| `bodyweight` | title + description | **3** | 969 |
| `Ukrainian` | description only (once, in the languages line) | 14 | 978 |
| `push-ups` | description only | 29 | 998 |
| `counter` | title + description | 84 | 997 |
| `motion sensor` | description only | 126 | 988 |
| `bezel` | description only | 268 | 621 |

A word that appears **once, in the last third of the description** ("Ukrainian")
puts HeroSet at rank 14 of 978 — because almost nothing else in the store
contains that word. Common words in the description only ("bezel", "counter")
bury it. **Title tokens are worth roughly two orders of magnitude more than
description tokens.**

**Relevance ranking ignores installs and ratings; the other sorts ignore
relevance.** For `rep counter`:

- `sortType=mostRelevant`: Rep Counter | Swim Rep Counter | **HeroSet -
  Bodyweight Rep Counter** | Stairs — Stair & Hill Rep Counter | Reps Counter |
  Challenge Counter | Rep Coach | Gym sets counter
- `sortType=mostPopular`: YouTube Music | Amazon Music | Push-Up Hero |
  Pokémon Sleep | FORESTER - 8 | Calculator | FORESTER 7.5 | F3b Dozen Walk
- `sortType=highestRated`: FORESTER 7.5 | FORESTER - 8 | Amazon Music |
  classic-remake-9 | WORLD - X | YouTube Music | Push-Up Hero | Pokémon Sleep
- `sortType=mostRecent`: Ruck Tracker | KiloDelta Effort | Gravid | Finnish
  weather | FitnessRec | Padel counter | Endyoro | Fractal Studios: Fitness

`mostPopular` and `highestRated` return globally popular apps that do not match
the query at all — those sort modes are effectively broken as search refinements
and nobody sane uses them. **`mostRelevant` is the default the search page
sets** (`v(l.ER.MOST_RELEVANT)` in the search chunk, and it is re-set to
MOST_RELEVANT on every new keyword). So the default search experience is
install-blind.

**Search depth is not capped at 4 pages.** I paged `mostRelevant` results to
row 268 without error. The UI is infinite-scroll ("load more"), not the
4-page browse cap. Off-rank in *browse* is not the same as off-rank in
*search* — search is genuinely deep and genuinely winnable.

**Search appears to be a single global index, not per-locale-filtered.**
Queries without a `countryCode`/locale param returned English names and hit
English descriptions. HeroSet has **only one `appLocalizations` entry
(`locale: "en"`)**, so it is currently invisible to any token a German, Polish
or Spanish user would type, even though the app ships 15 UI languages.

### Inferences

- The lever with the highest return is the **title**, at 32/50 chars today.
  18 unused characters are 18 characters of free, top-weighted index.
- Because matching is OR-token, every extra distinct word in the title is an
  extra query the app can rank for. `HeroSet - Bodyweight Rep Counter` already
  owns `heroset`, `bodyweight`, `rep`, `counter`. Adding tokens like
  `Push-Up`, `Sit-Up`, `Squat`, `Calisthenics` would put it into those result
  sets at title weight rather than description weight.
- Because plurals and typos are not handled, the listing must contain **both
  surface forms** of anything that matters: `push-up` *and* `pushups`,
  `sit-up` *and* `situps`. The hyphen/space normalisation means `push-up`
  already covers `push up` and `pushup`, but **not** `pushups`.
- Rare words are cheap high ranks. Any distinctive term the description owns
  (a brand word, an unusual feature word) will rank near the top for that term
  because the denominator is tiny.
- Adding `appLocalizations` for the 15 languages the app already supports would
  multiply the indexed surface at near-zero cost. This is the single largest
  untapped ASO lever on both listings.

### Gaps

- I could not determine the exact scoring function (BM25? Elasticsearch
  multi_match with field boost?) — only that title ≫ description and that
  unmatched tokens fall back to something fuzzy.
- I could not confirm whether the developer name is indexed.
- I could not confirm whether the `appType` filter is applied before or after
  the 1000-row cap.

---

## Which search terms can a bodyweight rep counter win, and who owns them?

### Takeaway

The rep-counter niche is crowded with title-exact competitors but the
**competition is weak in relevance terms** — nobody has an optimised
multi-exercise title. HeroSet already sits top-3 for its two title phrases at
zero installs. The winnable terms are specific exercise names and combined
phrases; the unwinnable ones are single generic words like `counter`.

### Cited findings

Queries run 2026-09-22, `sortType=mostRelevant`, top results:

| Query | total | Who ranks (top 5) |
|---|---|---|
| `rep counter` | 983 | Rep Counter; Swim Rep Counter; **HeroSet**; Stairs — Stair & Hill Rep Counter; Reps Counter |
| `rep counter` + `appType=watch-app` | **347** | Rep Counter; **HeroSet (#2)**; Stairs; Reps Counter; Rep Coach |
| `bodyweight` | 969 | Bodyweight Workout; Bodyweight Workout Pro; **HeroSet (#3)**; Torque Data Field; SQUATS POWER PRO |
| `pushup` | **225** | Tabata+; Push-Up Counter; Push-Up Hero; Cardio Class 1; Samurai Dusk |
| `push up` | 997 | Push-Up Hero; Push-Up Counter; Push-Up Workout Pro; Push-Up Workout Trial; Summit Push |
| `pushups` | 234 | Tabata+; Cardio Class 1; Seasons Premium; Push-Up Counter; Push-Up Hero |
| `pull up` | 985 | Pull-Up Counter; Pull-Up Workout; Key Pull Up; Pull-Up Hero; Pull-Up Workout Pro |
| `sit-ups` | 727 | Pulse Pull-Ups; Sit-Up Workout; Sit-Up Hero; Sit-Up Workout Pro; Two Cups Coffee Sit Window |
| `squat` | **571** | Squat Hero; SQUATS POWER; Leg Master; SQUATS POWER PRO; Cardio Class 2 |
| `calisthenics` | 964 | Calisthenics; Aphrodite Workout; CaliMaster Pro; Dead Hang Pro; MET |
| `reps` | **510** | Reps Counter; Swim Interval Reps; Reps to reap; Repsy; IronLog |
| `counter` | 997 | five apps literally named `Counter` |
| `gym` | 1000 (capped) | Gym; Gym; Gym Workout Tracker; Chrono Gym; GYM Power |

Notable competitors and their scale (from `/apps/<id>`, 2026-09-22):
- **Push-Up Hero** — 10,000 downloads, 4.3★ / 898 reviews, 14 locales,
  2,601-char description, 1,845-char What's New. This is the incumbent for the
  whole `*-Hero` family (`Push-Up Hero`, `Pull-Up Hero`, `Sit-Up Hero`,
  `Squat Hero` — one developer blanketing every exercise noun with its own
  listing).
- **Push-Up Counter** — description is a plain-prose paragraph; manual entry
  only ("Manually entering your push-ups ensures accurate tracking"). It does
  not auto-count.
- **Calisthenics** — a markdown-structured description with bolded feature
  headings; guided-workout positioning, not counting.

### Inferences

- **The `*-Hero` developer's strategy is the store-native one**: one listing
  per exercise noun, because search is OR-token over titles and a title
  containing the noun wins that noun. HeroSet cannot replicate that (one app)
  but can put several nouns in one title.
- **`counter`, `gym`, `workout` alone are unwinnable** — dozens of apps are
  literally named that. Don't chase them.
- **Real winnable terms**, by low total and weak incumbents: `pushup`/`pushups`
  (225/234), `squat` (571), `reps` (510), `sit-ups` (727), plus anything
  describing the *automatic* angle — no competitor's title claims automatic
  counting. `Push-Up Counter` explicitly says it is manual; HeroSet's
  sensor-based counting is an undefended differentiator.
- The three-exercise framing ("100 push-ups, 100 sit-ups, 100 squats") maps
  exactly onto three separately-winnable search terms. Get all three nouns into
  the title.

### Gaps

- Download counts are **bucketed to powers of ten** (`100`, `1000`, `10000`,
  `100000`) in the API, so competitor install counts are only order-of-magnitude.
- I did not test non-English competitor terms.

---

## Do device names in the title or description affect search?

### Takeaway

Yes, strongly — but **only in the title**. Device names are the single most
contested token space in the store, and a device name in the description
alone buys roughly rank 46, i.e. nothing.

### Cited findings

Query `Forerunner 255` (2026-09-22), first 15 results, flagged for whether
"255" appears in the title vs the description:

| # | 255 in title | 255 in desc | Name |
|---|---|---|---|
| 1 | yes | yes | TrailPulse 255 |
| 2 | yes | yes | PaceGrid 255 |
| 3 | yes | yes | Pomodoro 255 |
| 4 | no | no | Forerunner |
| 5 | yes | yes | TrailPulse Pro 255 |
| 6 | yes | yes | Tactical Field 255 |
| 7–15 | no | no | Forerunner large / goals / stats / Throwback / 55 / 645 / 745 / Clear Forerunner 45 / Basic Forerunner 645 |

Deep scan of the same result list: the **first app with "255" in its
description but not its title appears at rank 46** (`Hybrid Face — HERITAGE`).
Meanwhile apps whose title contains only the token "Forerunner" — and a
*different* model number — outrank it from rank 4 onward.

Query `fenix 8 51mm` (total 981), top 10: `Horizont 51mm`, `Fenix 8 Nixie`,
`FENIX 8 RINGS`, `MONSTER Fenix 8`, `NightRIDER 51mm`, `Multi Watchface for
Fenix 8 47mm and 51mm AMOLED`, `Ultra Fenix`, `ELITE CHRONOGRAPH - Fenix 8`,
`Fenix 8 MAVERICK Night`, `Fenix 8 - SURGE NIGHT`. Only one of those ten has
"51mm" in the description; all the rest score purely on title tokens.

Query `51mm` alone → **194 total** — a genuinely small, genuinely winnable
pool: `Horizont 51mm`, `NightRIDER 51mm`, `Nizam 1 (51mm)`, `Batman Watch
51mm`, `PWF DOME - 51mm`.

Query `fenix 9 pro` (total 993) top 5 are all watch faces with the device in
the title: `Uncharted PRO - fēnix 9`, `Vertical Segment PRO - fēnix 9`, `Alpha
Pilot GMT Pro - fēnix 9`, `NXT.01 Modernist PRO - fēnix 9`, `Goals Pro 9`.
Note the ASCII `fenix` query matched the `fēnix` titles — **diacritics are
folded**.

Query `venu 4` (total 991) top 5: `Venu`, `Venu`, `Garmin All Stars – Venu 4
Headline`, `Venu Large`, `Venu skin`.

### Inferences

- **Watch faces live or die on device names in the title.** The entire
  watch-face top of `hotFresh` and every device query is title-stuffed with
  `fēnix 8`, `fēnix 9`, `51mm`, `Venu`, `255`. For **HeroFace**, a title of
  bare "HeroFace" (matched only by people who already know the name) is
  leaving the whole device-name term space on the table. HeroFace has 50 title
  characters and uses 8 (verified 2026-09-22).
- `51mm` at 194 total results is the cheapest device token I found — a
  HeroFace variant title carrying `51mm` would enter a 194-app pool rather
  than a 1000-capped one.
- For **HeroSet** (a watch app, not a face) device tokens are lower value —
  users search device names looking for faces. Don't spend HeroSet's title on
  them; spend it on exercise nouns.
- Because diacritics fold, writing `fenix` or `fēnix` is equivalent. Because
  hyphens fold, `Fenix 8` covers `Fenix-8`. Because plurals don't stem, list
  both `51mm` and `51 mm` if you care (untested, but consistent with the
  tokenisation observed).

### Gaps

- I did not test whether the store's `compatibleDevicePartNumbers` /
  `compatibleDeviceTypeIds` metadata feeds search (it very likely drives the
  per-device browse pages at `/en-US/devices/<slug>/...`, a separate surface I
  did not profile).

---

## What do high-converting listings do with description, first line, screenshots, What's New?

### Takeaway

Top listings converge on a recognisable shape: **max out the 5 screenshots,
max out or near-max the 4,000-char What's New as a full changelog, write
1,000–3,900 chars of description, and localise into 8–28 languages**. The
first line is used by the biggest sellers for a **cross-sell link, a social
link, or a review plea** — not for a pitch — which suggests the first line is
*not* what list views surface.

### Cited findings

Profiled 2026-09-22 via `/apps?sortType=mostPopular&appType=...`.

**Top watch faces:**

| App | dl | rating/reviews | shots | locales | desc len | What's New len | First line |
|---|---|---|---|---|---|---|---|
| Goals | 100,000 | 4.9 / 29,862 | 5 | 15 | 3,524 | 732 | "Free trial and availability with other payment methods here: https://apps.garmin.com/apps/0a933f67-…" |
| Face It® | 5,000,000 | 4.6 / 30,079 | 2 | 27 | 149 | 0 | "Give your wrist a fresh look. Create a unique watch face with new data views and color combinations…" |
| GLANCE watch face | 1,000,000 | 4.9 / 68,861 | 5 | 1 | 3,774 | 2,572 | "THE BEST WATCH FACE APP OF 2022 (Garmin rating)." |
| Data Lover | 1,000,000 | 4.7 / 13,614 | 4 | 1 | 466 | 3,020 | "• Like it? Support it! Visit https://buymeacoffee.com/peterdd" |
| Fenix7 Pro Analog OWM MB | 1,000,000 | 4.8 / 37,444 | 5 | 1 | 1,821 | 211 | "If you like the app PLEASE LEAVE A REVIEW ⭐️⭐️⭐️⭐️⭐️." |
| Rondo | 10,000 | 4.9 / 5,420 | 5 | 11 | 3,405 | **3,956** | cross-sell link to Rondo Analog |
| Rad-Lad Watch Face | 50,000 | 4.4 / 1,060 | 4 | 1 | 3,972 | **4,000 (max)** | "Rad-Lad is a watch face with a retro-futuristic vibe, customizable data fields, and a unique character…" |
| Pure Harmony TiM | 50,000 | 3.3 / 602 | 5 | 1 | 1,416 | **4,000 (max)** | "NEW! Check out my latest watch face — Elion TiM" |
| Black Hawk Elite | 100,000 | 4.8 / 4,096 | 4 | 16 | 948 | 1,493 | "Black Hawk Tactical – a watch face for tactical enthusiasts." |
| Fenix 8 V3 PRO - GB | 10,000 | 4.9 / 2,008 | 5 | **28** | 2,355 | 3,899 | "Data Rich watchface inspired by Fenix 8 Iron Grid" |
| Vanguard Elite | 50,000 | 4.8 / 2,747 | 5 | 13 | 1,693 | 2,088 | "Hi, this is the Vanguard watchface." |

**Top watch apps (third-party, excluding Garmin's own):**

| App | dl | rating/reviews | shots | locales | desc len | What's New len |
|---|---|---|---|---|---|---|
| komoot | 1,000,000 | 4.2 / 15,656 | 5 | 10 | 2,905 | 384 |
| Maps4Garmin | 1,000,000 | 4.7 / **139,043** | 4 | 8 | 2,590 | **3,885** |
| Push-Up Hero | 10,000 | 4.3 / 898 | 5 | 14 | 2,601 | 1,845 |
| Wikiloc | 1,000,000 | 3.8 / 2,299 | 4 | 17 | 1,146 | 31 |
| Calculator | 500,000 | 4.2 / 356 | 5 | 13 | 2,032 | 0 |
| HYDRATE+ | 10,000 | 4.7 / 2,700 | 3 | 1 | 3,303 | 1,007 |
| WhatsApp | 100,000 | 2.6 / 1,277 | 4 | **28** | 467 | 116 |

Concrete structural patterns observed:
- **5 screenshots is the ceiling and the majority hit it.** 8 of the 12 top
  watch faces and 4 of the top third-party apps carry exactly 5. HeroSet
  already carries 5 (`screenshotFileIds` length = 5, verified 2026-09-22).
- **What's New is used as a full, cumulative, version-by-version changelog,
  not a one-release note.** Maps4Garmin: "9.2.0: Add support for several new
  devices… 9.0.5: Fix large download size / 9.0…". Push-Up Hero: "v1.7.3 -
  Adds Fenix9 support (SDK9.2.0)\nv1.7.2 - Adds D2Mach2 Pro, fixes complication
  daily values…". Several hit exactly 4,000 characters — they are truncating
  against the limit. HeroSet's What's New is **166 characters** — two bullets
  for 1.1.0 only.
- **What's New is also used as an off-store channel.** Rondo's begins "FOLLOW
  US ON SOCIAL MEDIA\nInstagram: … YouTube: … TikTok: …". Goals' begins
  "Follow for tips, updates and promotions: • Instagram … • TikTok …".
  Fenix 8 V3 PRO uses it for support routing: "*** If you encounter any bugs
  or issues, please reach out to me by pressing \"Contact Developer\" instead
  of using the review section".
- **Review solicitation is explicit and normalised.** Fenix7 Pro Analog OWM MB
  (37,444 reviews) opens *both* description and What's New with "If you like
  the app PLEASE LEAVE A REVIEW ⭐️⭐️⭐️⭐️⭐️. Your review contributes to the
  development of this app…".
- **Social proof in line 1 when they have it.** GLANCE: "THE BEST WATCH FACE
  APP OF 2022 (Garmin rating)." komoot: "…the Garmin Connect IQ™ App of the
  Year 2023." Both are Garmin award references (see the promotional-surfaces
  section).
- **Feature-bulleted, heading-structured descriptions** are the newer style —
  `Calisthenics` uses markdown-ish bold headings ("**Guided Workout Phases**",
  "**Heart Rate Zone Tracking**") with a `---` rule. HeroSet already uses a
  dash-bullet list.
- **Localisation count is the clearest correlate of scale** among third-party
  apps: 28 locales (Fenix 8 V3 PRO, WhatsApp), 27 (Face It®), 17 (Wikiloc),
  16 (Black Hawk Elite), 14 (Push-Up Hero), 13 (Vanguard Elite, Calculator).
  HeroSet and HeroFace have **1**.

**The two subject listings against that benchmark** (fetched 2026-09-22):

| | HeroSet (`54bbf625-…`) | HeroFace (`ad04d1e1-8e30-45cb-bbd6-82374f77b116`) | top-listing norm |
|---|---|---|---|
| title chars | 32 / 50 | **8 / 50** | device/exercise-noun stuffed |
| description chars | 1,122 / 4,000 | **166 / 4,000** | 1,000–3,900 |
| What's New chars | 166 / 4,000 | **0 / 4,000** | 1,500–4,000 |
| screenshots | 5 / 5 ✓ | 5 / 5 ✓ | 5 |
| locales | 1 | 1 | 8–28 |
| downloads / rating | 0 / 0★ | 0 / 0★ | — |
| `markedAsNew` | true | true | — |

HeroFace's entire description is **166 characters**, one sentence: "The time
first, today's goals right under it. Three bars you choose, a ring…". Against
a store where the median successful watch face runs 1,700–3,900 characters and
title-stuffs device names, HeroFace is currently reachable by exact-name search
and nothing else. It has 42 unused title characters, 3,834 unused description
characters and 4,000 unused What's New characters — all of them indexed.

### Inferences

- The million-download faces putting a buymeacoffee link or a cross-sell in
  line 1 is strong indirect evidence that **the first line is not the list-card
  snippet** — nobody with 68,861 reviews would burn the card headline on a
  donation link. Treat "first line = list view" as unconfirmed (see Gaps) and
  optimise the first line for the *detail page* reader instead: the first line
  is what a person sees above the fold after they tap through.
- The correct move for What's New is to **stop treating it as release notes
  and start treating it as a second description**: cumulative changelog
  (signals active maintenance, which is the #1 thing Connect IQ reviewers
  complain about), plus device-support announcements, plus support routing,
  plus links. It is 4,000 free characters currently 96% unused on HeroSet.
- Explicit review-asking is standard practice here, not spam. With 0 reviews,
  the first 5–10 reviews are worth more than any copy change, because
  `averageRating`/`reviewCount` are the only two social-proof fields on the card.

### Gaps

- **I could not confirm what the search/list card actually renders.** The
  search page (`/en-US/search?keywords=…`) is client-rendered; the server HTML
  contains no result cards, so I could not read the card template. The API
  returns the *full* description to the client, so a truncated snippet is
  possible but unproven. This should be checked by eye in a browser before
  rewriting a first line on the "list view" theory.
- Conversion rate itself is not observable — I used downloads and review counts
  as a proxy, which conflates conversion with traffic.

---

## What exactly is "Hot & Fresh"?

### Takeaway

**"Hot & Fresh" is not a new-app list.** It is `sortType=hotFresh` on the
normal `/apps` endpoint, and it ranks on **recency of the latest release
combined with install/rating scale** — established apps re-enter it by
shipping an update. A 0-install launch cannot win it, but a *maintained* app
can keep re-appearing indefinitely.

### Cited findings

The sort exists as a literal string `"hotFresh"` in the store bundle, and
`GET /apps?startPageIndex=0&pageSize=30&sortType=hotFresh&countryCode=US`
returns the list (verified 2026-09-22). Public URL:
[apps.garmin.com/en-US/apps/hotFresh](https://apps.garmin.com/en-US/apps/hotFresh).

Top of Hot & Fresh on 2026-09-22, with each app's `firstApprovalDate` (when
it first entered the store), `releaseDate` (latest version) and bucketed
`downloadCount`:

| # | App | first approved | latest release | downloads | rating/reviews |
|---|---|---|---|---|---|
| 1 | Helix | 2026-05-19 | 2026-09-09 | 100,000 | 4.9 / 5,392 |
| 2 | Quipu - Data Watch Face | 2026-07-13 | 2026-09-02 | 10,000 | 4.6 / 176 |
| 3 | Mission Zero | 2026-07-15 | 2026-09-21 | 100,000 | 4.9 / 2,639 |
| 4 | Vanguard VX | **2026-04-08** | 2026-09-19 | 100,000 | 4.8 / 1,891 |
| 5 | Goals Pro | 2026-07-08 | 2026-08-28 | 1,000 | 4.9 / 767 |
| 6 | array3 | **2026-04-13** | 2026-09-21 | 1,000 | 4.8 / 1,874 |
| 18 | Segment34 MkIII | **2026-04-06** | 2026-09-02 | 50,000 | 5.0 / 433 |
| 23 | Raptor M1 | **2026-03-31** | 2026-09-19 | 10,000 | 4.9 / 557 |
| 37 | Carbon Command Quartet - Analog | 2026-09-17 | 2026-09-22 | 100 | 5.0 / 3 |
| 52 | Aurum Nexus Hybrid | 2026-09-14 | 2026-09-14 | 100 | 5.0 / 1 |
| 58 | PrismPulse Hybrid Watch face | 2026-09-15 | 2026-09-15 | 100 | 5.0 / 2 |

Two things fall straight out of that table:

1. **Age is irrelevant; latest-release date is what counts.** Raptor M1 first
   entered the store on 2026-03-31 — nearly six months old — and sits at rank
   23 because it shipped a version on 2026-09-19. Vanguard VX (April) is at
   rank 4. Roughly a third of the top 60 first-approved in March–May 2026.
2. **Within the recently-released pool, ranking is download-weighted.** The
   top ~20 are 10,000–100,000-download apps; the 100-download apps (Carbon
   Command Quartet, Aurum Nexus, PrismPulse) sit at ranks 37–58, i.e. pages
   2–3. Genuinely brand-new tiny listings are present but buried.

It is **algorithmic, not curated** — there is no editorial field in the app
record and the composition is mechanically explainable by (release recency ×
scale). Separately, the app record carries a boolean **`markedAsNew`** and a
boolean **`trending`**; HeroSet has `markedAsNew: true`, `trending: false`
(verified 2026-09-22, app id `54bbf625-82af-4715-8af0-f2f16a5d1377`).

The mass-upload problem is acknowledged on Garmin's own forum: ["The Connect
IQ Store is getting worse by the day by a few developers who dump a shitload of
*** watch faces"](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669).

### Inferences

- **A launch cannot be "timed" for Hot & Fresh in any useful sense** — there is
  no window to hit. What there is, is a **repeatable re-entry**: every approved
  version release resets `releaseDate` and re-enters the pool. A cadence of
  small releases keeps a listing cycling through Hot & Fresh forever, which is
  how the March/April apps are still there in September.
- But re-entry lands you at rank ~37–58 (page 2–3) at 100 downloads, and the
  browse depth cap means that is close to invisible. Hot & Fresh is a
  **retention** surface for apps that already have installs, not an
  acquisition surface for apps that don't.
- `trending: false` on HeroSet implies a separate trending flag exists that is
  presumably velocity-based — another download-gated surface.
- The one honest tactic: since re-entry is free and the shipping cadence is
  under your control, **bundle any listing change with a real version bump** so
  the mandatory re-review also buys a Hot & Fresh re-entry.

### Gaps

- I could not determine the exact hotFresh scoring weights, nor whether there
  is a hard recency cut-off (the oldest `releaseDate` in the top 60 was
  2026-08-03, suggesting a window of roughly **50 days**, but that could be an
  artefact of scale rather than a cut-off).
- `markedAsNew` and `trending` semantics are undocumented; I did not find where
  they surface in the UI.

---

## Free organic channels: the Connect IQ developer forum

### Takeaway

There is exactly one sanctioned self-promotion venue inside Garmin's own
community: the **Connect IQ App Showcase** subforum. Promotion anywhere else
on forums.garmin.com violates the Terms of Use. Showcase posts plus signature
links are explicitly permitted.

### Cited findings

- The subforum is **Connect IQ App Showcase**, at
  **https://forums.garmin.com/developer/connect-iq/f/showcase** — described as
  a forum "for showcasing and supporting Connect IQ content that has already
  been released to the App Store" —
  [Connect IQ App Showcase](https://forums.garmin.com/developer/connect-iq/f/showcase).
- The forum rules state verbatim: **"Advertising, spamming, solicitation, and
  commercial self-promotion are not allowed per Garmin's Terms of Use"**, with
  the explicit carve-out: **"Developers are allowed to promote their Connect IQ
  apps in the Connect IQ Showcase and may link to their app store listings in
  posts and in their signatures."** —
  [Forum Rules wiki](https://forums.garmin.com/developer/connect-iq/w/wiki/2/forum-rules).
- Key constraint in that description: **already released**. A Showcase thread
  is a post-launch move, not a pre-launch teaser.
- Sibling subforums in the same community, none of which permit promotion:
  [Connect IQ App Development Discussion](https://forums.garmin.com/developer/connect-iq/f/discussion),
  [Connect IQ Bug Reports](https://forums.garmin.com/developer/connect-iq/i/bug-reports),
  [Connect IQ Store Discussion](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store),
  [News & Announcements](https://forums.garmin.com/developer/connect-iq/b/news-announcements),
  [New Developer FAQ wiki](https://forums.garmin.com/developer/connect-iq/w/wiki/4/new-developer-faq).
- The forum index is [forums.garmin.com/developer/connect-iq/f](https://forums.garmin.com/developer/connect-iq/f).

### Inferences

- The **signature link is the compounding asset**, not the thread. Every
  technical answer given in the Development Discussion subforum carries the
  store link in the signature, legitimately — that converts ordinary helpful
  participation into permanent, rule-compliant distribution. This is
  underrated relative to a single Showcase thread that scrolls away.
- One Showcase thread per app, kept alive by replying with each release (which
  bumps it), mirrors the Hot & Fresh re-entry cadence — same release, two
  surfaces.
- Because the Showcase audience is *developers and enthusiasts*, not general
  Garmin users, its realistic value is early reviews and bug reports from a
  technically competent audience — which is precisely what a 0-review listing
  needs most.

### Gaps

- I did not retrieve individual Showcase thread bodies, so I have **no
  evidence-based template** for what a high-engagement Showcase thread
  contains (post length, images, GIFs, changelog-in-thread). The convention
  should be read directly off the subforum before posting. I am flagging this
  rather than guessing.
- I found no stated rule on thread-bumping frequency or on posting the same
  app twice.

---

## Other Garmin-adjacent communities

### Takeaway

Beyond the Showcase subforum I could not verify self-promotion rules for
general fitness/calisthenics communities or Strava/Garmin Connect groups from
primary sources within this research pass. What I can state with sources is
limited to Garmin's own forum, and I am deliberately not inventing rules for
communities I did not check.

### Cited findings

- forums.garmin.com's developer community is segmented at
  [forums.garmin.com/developer/connect-iq/f](https://forums.garmin.com/developer/connect-iq/f);
  only the Showcase subforum permits promotion, per the
  [Forum Rules](https://forums.garmin.com/developer/connect-iq/w/wiki/2/forum-rules).
- Garmin also runs product-owner subforums at forums.garmin.com (outside the
  `/developer/` tree), and the same Garmin Terms of Use advertising ban applies
  across the whole site per that rules wiki — the Showcase carve-out is scoped
  to Showcase specifically, so product subforums are **not** a promotion venue.

### Inferences

- The carve-out's wording ("in the Connect IQ Showcase") reads as narrow and
  venue-specific. Posting "I made this app" in, say, the Forerunner or fēnix
  product subforum is against the stated rule even though that is where the
  actual users are.

### Gaps

- **Reddit (r/Garmin, r/GarminWatches, r/bodyweightfitness), Strava clubs and
  Garmin Connect groups: not verified.** Their self-promotion rules change and
  I did not fetch them in this pass. They should be checked individually
  against each community's current sidebar/rules before posting — a reflexive
  "post it on Reddit" recommendation is exactly the kind of generic advice this
  brief excludes.
- I found no evidence of an official Connect IQ Discord or Slack.

---

## Routes into Garmin's own promotional surfaces

### Takeaway

Garmin does run editorial award programmes, and winners advertise it in line 1
of their listings — but I found the awards referenced only second-hand, inside
listing copy, and could not locate a submission or nomination process.

### Cited findings

- **komoot**'s description opens: "Turn your next ride, hike, or run into an
  adventure with komoot, the **Garmin Connect IQ™ App of the Year 2023**"
  (retrieved from the live listing, 2026-09-22).
- **GLANCE watch face** (1,000,000 downloads, 68,861 reviews) opens with "THE
  BEST WATCH FACE APP OF 2022 (Garmin rating)." and **HYDRATE+** opens "From
  the developer of the **Best Garmin Watch Face apps of 2022 and 2023** -
  GLANCE and EASY ROUND" (live listings, 2026-09-22).
- Garmin's own publishing page's only listing guidance is: **"Be very specific
  in your description. This is your chance to get people interested in getting
  your app."** —
  [developer.garmin.com/connect-iq/submit-an-app](https://developer.garmin.com/connect-iq/submit-an-app/).
  That page carries no information on featuring, newsletters or awards.
- The [Connect IQ FAQ](https://developer.garmin.com/connect-iq/connect-iq-faq/)
  likewise contains nothing on featuring, awards, newsletters or promotion —
  it is purely technical.

### Inferences

- An "App of the Year" / "Best Watch Face" programme demonstrably exists and is
  worth enough that winners lead their listings with it years later — but it
  appears to be **Garmin-initiated and metrics-driven** (GLANCE calls it a
  "Garmin rating"), not application-based. A 0-install app has no route in.
- The absence of any documented featuring process on developer.garmin.com means
  the realistic "Garmin surface" strategy is indirect: get the metrics that
  feed the awards, don't chase the award.
- The single documented instruction — "be very specific in your description" —
  aligns exactly with what search rewards: specific, rare tokens outrank
  generic ones, as the `Ukrainian` (rank 14) vs `counter` (rank 84) test shows.

### Gaps

- I found **no** page describing Connect IQ Developer Award criteria,
  nomination, or a Garmin developer newsletter sign-up. Either it is not
  public or it lives behind the developer dashboard. Flagged as unverified.

---

## What can actually be measured or A/B tested

### Takeaway

Connect IQ gives you **no A/B testing and no impression data**, and every
listing change costs a re-review. But the search endpoint is free, deterministic
and install-blind — which makes **search rank itself a measurable, same-day
metric that responds to listing changes**. That is the test loop to build.

### What is genuinely testable

**1. Search rank is a direct, cheap, deterministic metric.** Because
`mostRelevant` is install-blind (proven: HeroSet at #3 with 0 installs), a
title/description change moves rank *immediately on re-approval*, independent
of any download effect. Build a rank tracker:

```bash
curl -s "https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords\
?keywords=<term>&startPageIndex=<offset>&pageSize=30&sortType=mostRelevant&appType=watch-app"
```

Page until your `appId` appears; record `(term, rank, totalCount, date)`.
Run it against a fixed basket of ~20 terms (`rep counter`, `pushup`,
`pushups`, `push-up`, `sit-ups`, `squat`, `bodyweight`, `calisthenics`,
`reps`, `counter`, plus HeroFace's device terms `51mm`, `fenix 8`, `venu`,
`forerunner`). Baseline it **before** the next submission. This is the closest
thing to a controlled experiment available, because the only variable that
changed is your text.

**2. Install count is a coarse but real outcome metric** — but
`downloadCount` in the public API is **bucketed to powers of ten** (`0`, `100`,
`1000`, `10000`…), so it is useless for detecting small changes. Use the
developer dashboard's own install stats instead; the store bundle exposes
`getStatsFullInstalls: {url: "/{appId}/fullInstalls", params:{start, end,
locale, temporalLevel}}` (from the `_app` chunk), i.e. **Garmin does serve
time-bucketed install series to the authenticated developer**. That is the
conversion metric. It requires developer auth, so it is a dashboard read, not
an anonymous curl.

**3. Ratings and reviews are public and unbucketed** — `averageRating` and
`reviewCount` are exact integers in the API, so a daily poll of your own app
record gives a precise review-velocity series.

**4. Off-store attribution is fully measurable and is the only true A/B.**
The store gives no referrer data, but verden.watch does. Use distinct
destination URLs per channel (the `/heroset/` and `/heroface/` pages with
per-channel UTM or per-channel short paths), and measure click-through from
site → store listing. A Showcase-thread link versus a site-ladder link is a
real, attributable comparison; nothing inside the store is.

### What is NOT testable, and why

- **No true A/B on the listing.** One listing, one text, served to everyone.
  Any comparison is sequential (before/after), so it is confounded by time,
  seasonality and the Hot & Fresh re-entry that every re-submission triggers.
- **No impression or conversion-rate data.** There is no "views" field
  anywhere in the app record (verified: the full key list is `additionalAndroidAppUrls,
  additionalIosAppUrls, appLocalizations, authFlowSupport, averageRating,
  betaApp, categoryId, changedDate, childSafe, compatibleDevicePartNumbers,
  compatibleDeviceTypeIds, countryLimits, creationDate, developer, developerId,
  downloadCount, downloadProtected, fileSizeInfo, firstApprovalDate,
  hardwareProductUrl, hasTrialMode, hasVersionPendingScan, iconFileId, id,
  lastApprovalDate, latestExternalVersion, latestInternalVersion,
  latestVersionAutoMigrated, markedAsNew, migrated, paymentModel, permissions,
  releaseDate, requiringExternalSubscription, reviewCount, screenshotFileIds,
  settingsAvailabilityInfo, status, supportEmailAddress,
  trending, typeId`). You cannot separate "nobody saw it" from "people saw it
  and didn't buy".
- **Screenshot and icon changes are effectively unmeasurable** — they affect
  conversion, not rank, and conversion is unobservable. Change them on
  judgement, not on data.

### The experiment design this implies

Because re-submission triggers re-review anyway, **change one category of thing
per submission** and let the rank basket read it out:

1. **Submission A — title only.** Expand the title from 32 to near 50 chars,
   adding exercise nouns. Leave description and What's New untouched.
   Prediction, from the measured title≫description weighting: large rank gains
   on the added nouns (`pushup`, `squat`, `sit-ups`), no change elsewhere.
   Read the basket 24h after approval. This isolates title weight cleanly.
2. **Submission B — description + What's New only.** Leave the title frozen at
   whatever A produced. Fill What's New to a cumulative changelog, add the
   missing plural surface forms (`pushups`, `situps`) and the differentiator
   language. Prediction: modest rank gains on long-tail terms only.
   **Bonus check:** if `pushups` rank improves after adding the literal token
   `pushups`, that independently confirms the no-stemming finding.
3. **Submission C — localisations.** Add `appLocalizations` for the 15 shipped
   languages. Measure by running the rank basket in the *target* languages'
   terms. This is the one change with a plausible step-change in reachable
   audience.

Keep the basket fixed across all three, record the date of each approval
(`releaseDate` in the API tells you exactly when a version went live, to the
second — HeroSet's was `2026-09-21T15:59:53`), and treat installs as a lagging
secondary metric that only becomes readable once it crosses a bucket boundary.

### Gaps

- I could not verify the `/‌{appId}/fullInstalls` stats endpoint's response
  shape or granularity, because it requires developer authentication.
- Review re-review turnaround time is unknown to me; HeroSet's record shows
  `creationDate 2026-09-19T13:28:21` → `firstApprovalDate 2026-09-21T09:46:12`,
  i.e. **about 44 hours** for the initial review. One data point, not a rule.
- Whether a listing-text-only edit (no binary change) requires re-review, and
  whether it resets `releaseDate` (and thus Hot & Fresh), is **untested** —
  and it matters a lot for experiment cadence. Worth confirming on the next
  submission by watching whether `releaseDate` moves.

---

## Appendix: verified API reference (2026-09-22)

```
# Search (undocumented; the real one)
GET /api/appsLibraryExternalServices/api/asw/apps/keywords
    ?keywords=<q>&startPageIndex=<row offset>&pageSize=<=30>
    &sortType=mostRelevant|mostPopular|mostRecent|highestRated
    [&appType=watchface|watch-app|widget|datafield|audio-content-provider-app]
→ {"totalCount": n (capped at 1000), "apps": [...], "appTypeNames": [...]}

# Browse / ranking
GET /api/appsLibraryExternalServices/api/asw/apps
    ?startPageIndex=<row offset>&pageSize=30&countryCode=US
    &sortType=mostPopular|hotFresh|mostRecent|highestRated[&appType=WATCHFACE]
→ bare array

# Single app
GET /api/appsLibraryExternalServices/api/asw/apps/<appId>

# Developer install stats (requires auth)
GET /api/appsLibraryExternalServices/api/asw/<appId>/fullInstalls
    ?start=&end=&locale=&temporalLevel=
```

Host base: `https://apps.garmin.com`. `appType` values differ between the two
endpoints (`watch-app` on `/apps/keywords`, `WATCHAPP`/`WATCHFACE` on `/apps`)
— mixing them returns HTTP 400.

HeroSet app id: `54bbf625-82af-4715-8af0-f2f16a5d1377`.
