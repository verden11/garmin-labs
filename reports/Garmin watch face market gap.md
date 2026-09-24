# Garmin watch face market gap

> **⚠ CORRECTED 2026-09-24.** Later research found several claims here wrong. The most
> important: **store ranking is NOT sticky lifetime installs.** `mostPopular` depends
> heavily on recent downloads (rank #1 has 100k downloads, rank #2 has 5M). Also, the paid share of
> top faces is 34/120, not 51/120, and `/apps?searchTerm=` is ignored (real search is
> `/apps/keywords`, which scores descriptions too and isn't weighted by installs).
> See the corrections section of `Selling HeroSet and HeroFace.md`.


Research snapshot: **2026-09-22**. All store figures were pulled from the Connect IQ
store's own backend API on that date; all platform claims were verified against
Garmin-owned pages rendered in a browser on that date.

---

## What's in which file

The underlying research lives in `research_notes/Garmin watch face market gap/`.
Seven files, ~2,400 lines, every substantive claim carrying a source URL.

| File | What it holds |
|---|---|
| `trends.md` | SDK release timeline, the Complications API surface (what health data is exposed and since when), fēnix 9 launch, analyst market-share figures, adjacent-ecosystem trends |
| `popular_faces.md` | The authoritative top-120 popularity ranking pulled from the store's backend, with price, rating, review count, download bucket and device count per face; publisher concentration; the feature formula from the top 100 descriptions |
| `low_star_reviews.md` | 2,544 unique 1★/2★ reviews across the top 30 faces, clustered into 14 complaint themes with volumes, per-face normalised rates, verbatim quotes, and a 2025→2026 temporal shift table |
| `marketing_channels.md` | How discovery actually works on the store, what the listing surface allows, three verifiable off-store tactics with URLs, and an explicit list of channels that could NOT be verified |
| `platform_constraints_monetization.md` | The "what a watch face cannot do" feasibility filter (20 sourced bullets), API-level fragmentation, data access, and Garmin's monetization rules |
| `verification.md` | Browser-rendered verification of 14 Garmin-owned pages, marking each prior claim CONFIRMED / REFUTED / UNVERIFIABLE. **Supersedes the other files on conflict.** |
| `gaps_unmet_demand.md` | Forum-sourced unmet demand. **Read with care — its headline finding was later refuted by store data.** See "Corrections" below. |

**Authority order when files disagree:** `verification.md` and `low_star_reviews.md`
outrank the rest. Both are built on primary sources (Garmin's own rendered pages;
the store's own API) rather than on forums or search results.

---

## Executive summary

The obvious gaps are not gaps. Accessibility/low-vision looked like the strongest
opening from forum evidence and is **refuted** by store data (1.45% of complaint
volume, zero colour-blindness mentions, niche already held by a 1M-download
incumbent). "Calm/minimal is whitespace" is also **refuted** — the clean, legible
face is the category *winner*, not the gap.

What the 2,544-review corpus actually says is that the top complaints are about
**how a watch face is acquired, licensed and fitted to hardware** — commerce and
compatibility — not about what it draws. Two of the top three themes never touch
pixel rendering:

| Theme | Share of complaint volume |
|---|---|
| Device support / fit / non-touch navigation | **14.8%** |
| Paywall / trial / unlock-key | **14.4%** |
| Settings not saving / resetting | **8.4%** |
| Battery drain | 4.5% |
| Always-on display | 1.6% |

Battery and AOD — the themes most people would design against — are the 7th and
11th largest. The opening is **execution, not category**: a legible face, sold at
one honest Garmin-store price with no developer unlock key, laid out per-device
across the newest hardware, with settings that survive a reboot.

The device fleet is mid-transition (fēnix 9 Pro, Venu 4, Instinct 3 all recent),
incumbents are not keeping layouts current, and the four *rising* complaint themes
are all consistent with that transition. That window is the entry point.

---

## 1. What has been trending

**Hardware: the canvas got bigger and brighter.** fēnix 9 / 9 Pro launched
2026-08-25 (43/47/51 mm, $999.99 / $1,099.99). The 9 Pro 51 mm is the first
1.5-inch AMOLED Garmin ships, with the display extended 15% and up to 3,000 nits.
No MIP variant was announced — the pre-launch "MIP is back" leak is unsupported.
*(Confirmed: Garmin press release.)*

**Software: one genuinely new health surface.** `COMPLICATION_TYPE_SLEEP_SCORE`
(type 42) arrived at API 6.0.2, with watch-face support added in the SDK released
2026-06-09. It is the only new health complication in the window.

Everything else developers reach for is old news: **Body Battery (23), Stress (22),
Recovery Time (21), Pulse Ox (35), Respiration (36), Training Status (26), VO2max
and race predictors have all been available since API 4.2.0.** "We show Body
Battery" is table stakes, not a differentiator — presentation is.

Notably **absent from the complication list entirely**: Training Readiness, HRV,
sleep stages/duration, Endurance Score, Hill Score, Training Load. Training
Readiness is an active, unmet developer request. HRV and sleep detail live in the
server-side Health API (a separate partner program), not the on-device SDK.

**Body Battery and stress are the exception worth knowing:** both are directly
readable via `SensorHistory` since **API 3.3.0** — no complication subscription
needed. They are the only "Garmin-special" metrics a broadly-compatible face can
rely on across old and new devices alike.

**Market context.** Counterpoint put Garmin at **5.6%** share in Q2 2026, +11% in a
market that fell 4% — the first quarterly fall in a year — with growth attributed to
"strong demand for its high-end outdoor and sports watches." *Recorded conflict:
**Omdia puts Garmin at ~15%** for the same period, because it categorises budget/basic
devices differently. Do not quote either number as "Garmin's share" without the source
attached.*

**Adjacent ecosystems.** watchOS 26 (2025-09-15) brought Liquid Glass and 67
faces; its gallery categorises faces as both "Clean" and "Data Rich" — the same
two poles the Garmin store splits on. Wear OS 7 landed 2026-06-16.

---

## 2. What is actually popular

Pulled directly from the store's ranking endpoint, not from listicles:

```
GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps
    ?startPageIndex=<n>&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE
```

**Top five (2026-09-22):** Goals (VAW.BE, €2.49, 4.9★, 29,826 reviews) · Face It®
(Garmin, free, 5M downloads) · Pure Harmony TiM (timwatch, €2.49, 3.3★) · Rad-Lad
(MarekSoso, €2.99) · Rondo (Nimble_Wings, €3.49, 4.9★).

**Three caveats that change how you read that list:**

1. `downloadCount` is **bucketed** (10k / 50k / 100k / 500k / 1M / 5M), never exact.
2. "Most Popular" is **not download-sorted**. Rank 1 has 100k downloads; rank 2 has
   5M. It is a blended velocity-plus-rating score that Garmin does not document.
3. Paging **caps at 120 unique faces**. That is the entire addressable popular set —
   a small, knowable market.

**Paid share is unusually high: 51 of 120** carry a Garmin-native price. Band is
€2.49–€5.99 with €5.99 a hard ceiling, including on Garmin's own dials. A paid
watch face is normal here, not a barrier.

**Publisher concentration is severe:** Garmin 17, TitanicTurtle 17, VAW.BE 11,
frinkr 11, MobileDriveway 6 — out of only 120 slots. Two visible strategies:
broad-compatibility free-with-key flagships (200+ device types) versus
device-targeted paid variant farming (fēnix 8-specific, €5.99, 60–90 device types).
**Listing duplication is a deliberate ranking tactic** — each trial/pro/paid
listing occupies its own slot in a 120-slot list.

**The feature formula**, from the top 100 descriptions: configurability 80,
weather 67, themes 61, sunrise/sunset 47, Body Battery 38, AOD 35. Animation only
10, seasonal art only 3. Permissions tell a harder story: `ComplicationSubscriber`
is declared by **83 of 100** though only 19 advertise it.

**Ratings are useless as a discriminator** — 4.7–4.9★ is the norm across the board.
**Review volume is the real signal.** And the dominant praise phrasing is
*subtractive*: "exactly what I wanted and nothing I didn't." Users are buying
**control over density**, not density itself.

Day-one support for a new device is a ranking lever: users file a missing device
as a 5★ feature request, not a 1★ complaint.

---

## 3. What is marketed, and how

**Store discovery is close to a dead channel for a new entrant.** Browse depth is
capped (a developer reports four pages per category), so anything outside the top
slots is reachable only by exact-name search. Garmin publishes nothing about its
ranking algorithm — no primary source exists.

The evidence points to a **sticky, lifetime-installs sort**: Crystal (1M+ installs,
last updated 2018) and Infocal (100k, 2019) still rank while being years stale.
A new face cannot out-rank that quickly, whatever its quality. *(Inference from
observed ranking behaviour, not a Garmin statement.)*

**"Hot & Fresh" is the only new-release surface** — and it is the same window mass
uploaders flood, 10+ faces a week across multiple accounts, one case of 782 bundled
faces. Whether it is algorithmic or curated is unknown.

**The listing surface is narrow.** Verified from Garmin's *Submit an App* page:
description and screenshots are added after the `.iq` upload, device support is
declared in the manifest at export time, and the app is hidden until approved.
Garmin's own instruction: *"be very specific in your description. This is your
chance to get people interested."* Character limits, screenshot specs and
keyword/tag fields could not be retrieved — those pages returned JS nav shells.

**Three off-store tactics that are verifiable with URLs:**

1. **Own site plus a product ladder.** MobileDriveway (mobiledriveway.com) ships
   Glance / Pro / Ultra / HANDY IQ / EASY+ / EASY Round / BIG EASY IQ — a free
   flagship funnelling paid siblings.
2. **A developer-run forum showcase thread** as de facto support desk and
   changelog (`forums.garmin.com/.../showcase/279043/watchface-glance`). Same
   pattern on other successful faces.
3. **Self-authored SEO roundups.** myday24.com is Tomas Slavicek's own blog
   recommending his own ~17 faces (self-disclosed); wristtale.com is a Connect IQ
   vendor doing the same. The "best watch faces" listicle layer is substantially
   vendor-owned.

**Press is earned, not paid — and it is circular.** Tom's Guide runs recurring
watch-face pieces; the5krunner does ecosystem analysis. But the hook is almost
always *existing store rank* ("the most popular free face"), which a new entrant
by definition does not have.

**Garmin's own promotional surfaces have no published route in.** Hot & Fresh, the
Connect IQ Developer Award (GLANCE won best watch face in 2022; unverified whether
it still runs) and the "Stay Informed" developer newsletter. The 2024 premium-apps
launch gave its marquee slots to Disney/Marvel/Lucasfilm, Porsche, TaylorMade and
GoPro — not to indies.

**Four channels we could NOT verify, in either direction:** Reddit (search returned
zero Reddit results — index restriction, not absence), Discord/Patreon communities,
paid advertising or sponsorship, and seasonal/device-launch release timing. These
are open questions, not proven-ineffective channels.

---

## 4. The gap

### First, two gaps that are not gaps

**Accessibility / low vision — REFUTED.** Forum evidence made this look like the
strongest opening: independent complaints across Epix Gen 2, Venu 2 Plus, FR35 and
FR45, an itemised Garmin-unanswered request for font-size and colour-blind modes,
and on FR45 the community's own answer was "go find a third-party face."

Store data does not support it. Of 2,544 low-star reviews: **37 (1.45%)** mention
low vision or font size, **5 (0.20%)** mention contrast/sunlight/glare, and
**zero** mention colour blindness. Adjusting for the 18.6% non-English share raises
the ceiling only to ~1.8%. Most "too small" hits turn out to be device-fit bugs,
not eyesight. And the residual niche already has an incumbent: **Simply Large, 1M
downloads**.

*Why the forums misled:* forum threads over-select for the articulate, motivated
complainant. A person who will write eleven replies about font sizes is not
representative of install-base demand. The store review corpus is the better
instrument because it samples everyone who bothered to rate.

**"Minimal/calm is whitespace" — REFUTED.** We hypothesised that everyone builds
data-dense sport faces, leaving calm/minimal open. The opposite is true: GLANCE —
clean, legible, information-efficient — is the category winner (68,814 reviews,
1M+ downloads, 4.9★). Minimal is not whitespace; minimal is where the incumbent
already sits. The contested axis is **execution quality within the legible
category**.

### What the data actually points at

Three defects in the incumbents, all large, all fixable, all within platform limits:

**1. Device fit — 14.8% of all complaint volume, and industry-wide.** Normalised
per-face rates are remarkably flat: Rad-Lad 31%, Pure Harmony TiM 26%, Crystal 25%,
Lachesis 25%, Instinct Mission 24%, Outerfield 23%. Six unrelated developers, same
failure. This is not one bad actor — it is a category-wide standard nobody meets.

> "The Watch face is too small for 51mm fenix 8 its like having a 43mm watch face
> how do i fix that?" — *Vanguard Elite*, 1★, 2026-09-05, 28 upvotes

> "I had this on my 8 Pro and loved it. Now on my 9 Pro 51mm, the data is all
> swished into the upper left portion of the watch dial." — *Data Lover*, 1★, 2026-09-01

> "although it is listed as compatible with the Garmin Forerunner 255, the
> experience on non-touch devices is very frustrating." — *Rad-Lad*, 2★, 2026-05-27

**2. Licensing pain — 14.4%, and self-inflicted.** Concentration is extreme:
Black Hawk Elite 16/34 = **47%**, Zenith 78/193 = **40%**, Outerfield 36%, Black
Grid 34%. Four in ten of Zenith's low-star reviews are about its pro key. Store
metadata confirms these are *developer-side* unlock keys — Zenith, Black Grid,
Instinct Mission and Data Lover all report `pricing: null` and `hasTrialMode: false`
while their reviews describe pro keys and trial expiry.

> "It says it's free, but after 3 days it becomes paid and asks for a key. This is
> a very disappointing situation. Some things shouldn't be about money, and it
> feels very misleading." — *Zenith*, 1★, 2026-05-27

> "Forever having to uninstall and reinstall because of it resetting to trial mode"
> — *Black Hawk Elite*, 1★, 2026-08-25, 34 upvotes

This is a competitor's *business model* generating their own worst reviews. It is
not something to fix — it is something to sidestep.

**3. Settings that silently reset — 8.4%, flat year-over-year, unfixed.** This
produced the single most-upvoted low-star review in the entire 2,544-review corpus:

> "Watch face constantly loses data fields through the day until pretty much just
> the time is showing and eventually resets itself at some point. Had to stop using
> it." — *Black Hawk Elite*, 1★, 2026-08-27, **49 upvotes** (the runners-up, at 46
> and 38, are the same face's settings-reset and payment-failure complaints)

Black Hawk Elite sits at 4.8★ with a **12.0% low-star rate in the last four months**
— a live, unresolved incident completely invisible in its star average.

### The recommendation

**Build a legible, configurable, per-device-tuned watch face; sell it at one
Garmin-store price with no unlock key; guarantee settings persistence; and ship
day-one layouts for the newest hardware.**

Concretely, the four things that differentiate it, in priority order:

1. **Per-device layout, not one scaled layout.** Hand-tuned for each screen size
   and shape, explicitly including fēnix 9 Pro 51mm (1.5", the largest canvas
   Garmin ships), fēnix 8 51mm, Venu 4 and Instinct 3. Non-touch devices get a
   button-navigable settings path. This alone addresses the largest complaint
   cluster.
2. **One price, no key, no trial theatre.** €2.99–€3.99 through Garmin's merchant
   system. No PayPal, no emailed unlock code, no 5-day timer. The listing says what
   it costs and the purchase is final. This removes 14.4% of the category's
   complaint volume by construction.
3. **Settings that survive.** Persistence tested across reboot, firmware update and
   phone re-sync — the failure mode behind the corpus's top three most-upvoted
   complaints.
4. **Subtractive configurability.** The winning praise is "exactly what I wanted and
   nothing I didn't." Let users *remove* elements, not just add them. This is the
   execution axis GLANCE already won on, and where the fight actually is.

### Feasibility check

Filtered against the platform's hard limits, the recommendation is clean — it asks
for nothing the platform forbids:

- No animation, no sub-minute updates, no live data → **within** the once-per-minute
  low-power constraint.
- No network dependency beyond cached weather → **within** the background-service
  limits (≤1 request per 5 min, ~32 KB, killed after ~30 s; no foreground network at all).
- No 6.0-only API required → **runs on API 5.2 and up**.

**Device targeting.** Baseline **API 5.2**, which covers Forerunner 965 and 265,
fēnix 7 / 7 Pro, Venu 3 and vívoactive 5, while still including the full
Complications subscribe/publish surface (4.2.0), watch-face config mode and
`getComplicationDrawable` (5.1.0). Instinct 3 and newer sit at 6.0 and are
additive targets.

**Can the FR965 run it? Yes** — and it can be sold there. Garmin's monetized-device
list has a tier literally headed "API Level 5.2" containing Forerunner 965, FR265,
fēnix 7, Venu 3 and vívoactive 5. Paid apps sell to the FR965 today.

**One thing the FR965 cannot do:** `COMPLICATION_TYPE_SLEEP_SCORE` is API 6.0.2, so
it cannot be dogfooded on that device. Given this repo's own house rule —
*simulator passing is not device proof* — anything gated on sleep score should be
treated as untestable on your wrist and scoped out of v1. Body Battery and stress
are unaffected: both read directly from `SensorHistory` at API 3.3.0.

**AOD design constraints to build against** (these are exact, and commonly
mis-stated):

- Since the Venu 2, the rule is **"less than 10% of the screen's luminance"** — not
  10% of pixels. The FR965 is post-Venu-2, so luminance is the budget that applies.
- **No pixel may stay lit more than 3 consecutive minute-updates.** Violating
  *either* rule turns off all screen pixels until the device returns to high power.
- **`onPartialUpdate` does not apply to AMOLED at all** — Garmin: *"With AMOLED
  screen, this is no longer allowed."* The ~20 ms budget and `onPowerBudgetExceeded`
  are the **MIP path only**. Do not design as though both apply.
- Garmin's own guidance: avoid white and bright blue, prefer light grey, minimise
  static elements, shift them up to 4 px per minute for burn-in. Check
  `DeviceSettings.requiresBurnInProtection`.
- The simulator ships a test tool: **File → View Screen Heat Map** simulates a
  24-hour run in minutes.

### Why this window is open now

The four complaint themes that are *rising* 2025→2026 — install/download (+1.3pp),
broken-after-update (+0.5pp), AOD (+0.5pp), readability (+0.4pp) — are all
consistent with a device-fleet transition: fēnix 9 Pro, Venu 4 and Instinct 3 are
shipping faster than incumbent faces are being updated for them. Incumbents that
last shipped in 2018 still hold rank, which means they are **not** going to fix
their 51mm layouts quickly. Day-one support for new hardware is the one ranking
lever a newcomer can actually pull.

---

## 5. Marketing plan

### The strategic constraint

Three research findings, taken together, dictate the shape of this plan:

1. Store ranking looks like sticky lifetime installs, so **a new entrant cannot win
   store discovery quickly**. Stale 2018 faces still outrank fresh ones.
2. Browse depth is capped at roughly four pages, so **off-rank means invisible to
   browsing**. Only exact-name search reaches you.
3. Press coverage is earned off existing rank, which is **circular for a newcomer**.

So the plan cannot be "launch and climb." It has to be: **enter on a query nobody
owns, convert on the defect the incumbents are generating, and let device-specific
demand do the discovery work.**

### The wedge: device-specific search

Incumbents are generating fresh 1★ reviews naming exact devices — "fenix 8 51mm",
"9 Pro 51mm", "Venu 4", "Forerunner 255 non-touch". Those users are actively
searching. Exact-name search is the one store surface not gated on rank.

**So the listing is built around device names.** The title and description name
supported devices explicitly, including the newest. Screenshots are rendered per
device at true resolution — not one image scaled. Garmin's own instruction is *"be
very specific in your description"*; here specificity means device model numbers,
because that is what the underserved user types.

### Day 0–30: ship the thing that earns the review

- **Submit early and expect nothing.** There is **no published review SLA**. Garmin
  commits only to "as thoroughly and promptly as possible" and reserves the right to
  remove apps with no prior notice. Developer reports range from hours to 10+ days.
- **Price it at submission, not after.** Confirmed from Garmin's docs: *"If you are
  setting a price for an app that has already been approved, the app is temporarily
  removed from the store so it can be reviewed again."* Re-pricing costs you a second
  review window and pulls the listing meanwhile.
- **Budget the merchant onboarding:** **$100 USD annual, non-refundable**, plus
  Garmin's **15% of the tax-exclusive price**. Garmin covers credit-card fees; DST
  and FX conversion are withheld on top of the 15%. Payouts monthly, $10 minimum,
  48-hour return window before funds are captured.
- **Review is not content-moderation only.** Performance, crash frequency and
  battery drain are separately enumerated rejection grounds. Whether Garmin actually
  profiles is undocumented — it states the standard and pushes testing to you. Run
  the Screen Heat Map before submitting.
- **Do not plan a trial.** Garmin states verbatim: *"The app trials feature is not
  supported for watch faces."* That is a platform exclusion, not an oversight —
  which is precisely why every paid competitor hand-rolls one and collects 1★
  reviews for it. Your "no trial, honest price" position is only credible because
  the alternative is visibly broken.

### Day 30–60: own the support surface

- **Open a forum showcase thread on day one** and run it as changelog plus support
  desk. This is a verified tactic (GLANCE's thread is the model) and it costs
  nothing. It also builds the searchable corpus that answers "does X face support
  my watch."
- **Answer every store review, especially the bad ones.** The corpus shows
  developer replies are visible and read. A settings-reset complaint answered within
  a day is the cheapest possible differentiation from Black Hawk Elite's 12%
  low-star rate.
- **Ship a device-support update the week any new Garmin hardware lands.** Users
  file missing-device requests as 5★ feature requests, not 1★ complaints — so this
  is a ranking lever with no downside. It is also the single thing incumbents
  demonstrably do not do.

### Day 60–90: the ladder, if v1 holds

- **Only after the flagship has traction**, consider the verified
  MobileDriveway pattern: one strong free or low-priced entry funnelling paid
  siblings. Note the honest read — **listing duplication is itself a ranking tactic**
  in a 120-slot market, since each listing occupies its own slot. Decide deliberately
  whether to play that game; it is effective and it is part of why the store looks
  the way it does.
- **Do not chase press in the first 90 days.** The hook journalists use is existing
  rank. Revisit once you have a number worth quoting.

### Channels flagged UNVERIFIED — treat as experiments, not plan

Research could not confirm these work, in either direction. They are not in the plan
above because there is no evidence for them, not because they were ruled out:

- **Reddit** — `site:reddit.com` queries returned zero results (index restriction).
  Completely untested. Plausibly valuable, genuinely unknown.
- **Discord / Patreon communities** — searches returned only generic noise.
- **Paid advertising, sponsored posts, affiliate programmes** — no evidence found
  in either direction. No YouTube reviewer specialising in Connect IQ faces was
  identified.
- **Seasonal timing and device-launch timing** — no source at all. The
  "ship on hardware launch" advice above is inferred from the device-fit complaint
  data, not from any observed marketing outcome.

### What success looks like

Review *volume*, not star average. Ratings cluster at 4.7–4.9★ across the whole
category and discriminate nothing — Black Hawk Elite holds 4.8★ while 12% of its
recent reviews are 1★ or 2★. Track low-star rate on recent reviews
(`sortType=CreatedDate&ascending=false`) as the real health metric, because that is
the instrument that exposes what the average hides.

---

## Corrections: where later research overturned earlier research

Recorded so that anyone picking up the notes does not resurrect a refuted claim.

| Claim | Status | Correct version |
|---|---|---|
| Accessibility/low-vision is the strongest gap (`gaps_unmet_demand.md`) | **REFUTED** | 1.45% of 2,544 store reviews; zero colour-blindness mentions; Simply Large (1M downloads) already serves the niche. Forum evidence over-selected for articulate complainants. |
| Calm/minimal is market whitespace | **REFUTED** | GLANCE, a clean legible face, is the category winner. The contested axis is execution quality *within* the legible category. |
| FR965 supports API 6.0 / sleep score | **REFUTED** | FR965 is **API Level 5.2**. `COMPLICATION_TYPE_SLEEP_SCORE` (6.0.2) is unavailable on it. |
| API 6.0 excludes Instinct 3 | **REFUTED** | All three Instinct 3 variants are **API 6.0**. |
| API 6.0 excludes FR965, FR265, fēnix 7 / 7 Pro, Venu 3 | **CONFIRMED** | All are 5.2. |
| "Connect IQ 9.x requires API 6.0" | **UNVERIFIABLE** | No Garmin page uses a "9.x" label anywhere. Garmin's published versioning is API Level. Claim originated from the5krunner/forums. **Drop it.** |
| Monetization requires API 6.0 | **REFUTED** | Garmin's monetized-device list has an "API Level 5.2" tier including FR965. Paid apps sell there today. |
| AOD budget is "10% of pixels" | **SUPERSEDED** | 10% of pixels applies to the *original* Venu. Since the Venu 2 it is **"less than 10% of the screen's luminance"**. Plus: no pixel lit more than 3 consecutive minute-updates. |
| `onPartialUpdate` / 20 ms budget applies to AMOLED | **REFUTED** | *"With AMOLED screen, this is no longer allowed."* That path is **MIP-only**. `WatchFacePowerInfo` reports `executionTimeAverage` / `executionTimeLimit` per device rather than a fixed 20 ms constant. |
| Nobody uses `hasTrialMode` because developers neglect it | **REFUTED** | *"The app trials feature is not supported for watch faces."* Platform exclusion. |
| Store review is content-moderation only | **REFUTED** | Performance, crash frequency and battery drain are enumerated rejection grounds. (Whether Garmin *measures* them is undocumented.) |
| Store review has a published SLA | **REFUTED** | None published. "As thoroughly and promptly as possible." |

---

## Confidence and caveats

**Confirmed** — from a Garmin-owned page rendered in a browser, or from the store's
own backend API: the monetization figures (15%, $100/yr, country list, $2.00–$100.00
in 16 currencies); the API-level device table; the AOD luminance and 3-minute-pixel
rules; the trial-mode exclusion; the top-120 ranking with prices and review counts;
the 2,544-review complaint clusters.

**Inferred** — reasoning from observed data, not stated by Garmin: that ranking is
sticky lifetime-installs (inferred from stale faces holding rank); that the device
transition creates a window (inferred from the rising complaint themes); that
listing duplication is a deliberate ranking tactic.

**Unverified** — could not be established in either direction: Reddit, Discord/
Patreon, paid advertising, seasonal timing, whether the Connect IQ Developer Award
still runs, whether Hot & Fresh is algorithmic or curated.

**Measurement caveats that matter, preserved rather than laundered:**

- **Download counts are buckets** (10k/50k/100k/500k/1M/5M), never exact. No exact
  download, revenue or active-install figure is exposed by Garmin.
- **18.6% (473/2,544) of low-star reviews are non-English** and the API's `locale`
  param is silently ignored, so English-keyword clustering **under-counts every
  theme by roughly that fraction**. Theme percentages are floors.
- **94% of low-star reviews were filed against a superseded version.** The
  rating-sorted pull spans 2018–2026 and skews historical. The `CreatedDate` pass is
  the honest instrument for current state, and it covers only 5 faces.
- **Face It® and Crystal hit the 250-row collection cap**, so their theme counts are
  floors, not totals.
- **Review text is thin**: median 72 characters, only 24% exceed 130.
- **The `CreatedDate` low-star base rates cover 5 faces only** and should not be
  extrapolated to the other 25.
- **Two methodology traps**, both found and corrected mid-research, both worth
  knowing before repeating this work:
  - `startPageIndex` in the reviews API is a **row offset, not a page index**. A
    first pass using `0..5` pulled 3,464 rows that deduped to 776. Correct usage is
    `startPageIndex = page * pageSize`. `popular_faces.md`'s review sampling may be
    affected by this.
  - **Garmin forum listings sort by last activity, not post date.** A thread
    displaying "1 month ago" was dated over four years old on its own page. Do not
    read forum listing timestamps as recency.
- The store API silently ignores `applicationTypes`, `developerId` and `locale`.
  Per-developer catalogue totals are therefore lower bounds (share of the popular
  list only). Prices return in EUR regardless of `countryCode`, so USD price points
  are unconfirmed.
- API level is a live, firmware-driven table value, not a documented ceiling. The
  per-device reference pages publish no API level at all — the Compatible Devices
  table is the single authority, and it can change.
