# Indie Connect IQ Case Studies — Zero to Traction

*Research date: 2026-09-22. All store-API figures pulled this date.*

**Methodological warning up front.** Two things constrain everything below:

1. **Download counts are bucketed floors.** The store API returns `downloadCount`
   values only from the set {1, 10, 100, 1000, 10000, 50000, 100000, 500000,
   1000000, 5000000}. A value of `100000` means "at least 100k, less than 500k."
   Never present one as a precise figure.
2. **`reviewCount` and `downloadCount` do not cohere.** Across the top 120 faces
   the ratio runs from 0.4% (PixelPathos *Crystal*: 1M bucket / 3,998 reviews) to
   77% (VAW.BE *Goals Pro*: 1,000 bucket / 767 reviews) — a ~190x spread. Worse,
   the fields are non-monotonic: *Goals Pro* shows 767 reviews at bucket 1,000
   while SPWatch *Outerfield* shows 143 reviews at bucket 10,000. If both fields
   meant what their names say that ordering is impossible. The most defensible
   reading is that `reviewCount` is a star-rating count whose prompt exposure
   varies enormously per app, making it an **engagement proxy, not an install
   proxy**. Do not build a conversion model on it.

**Survivorship bias is severe and I want it stated plainly.** Nearly every
usable data point below comes from a developer who is *currently ranked*. The
Connect IQ store publishes no graveyard. I searched explicitly for failure and
quit narratives (see "Failures and quitters") and found forum complaints and one
documented payment failure, but **no indie developer who has publicly written up
a full revenue/download postmortem of a Connect IQ business in 2025–2026**. The
absence is itself the finding.

---

## Q1. Developers who have publicly written about their Connect IQ experience — revenue, downloads, marketing

### Takeaway

First-hand, quantified public disclosures barely exist. The only explicit
earnings statement I could find anywhere is an ~8-year-old forum line — "don't
expect more than a beer or so a month" — and no developer in the 2025–2026
window has published revenue or download numbers. What *does* exist is
observable behaviour: named developers with public sites, Ko-fi pages and social
accounts whose catalogue structure reveals their strategy.

### Cited Findings

- **The only quantified earnings statement found.** In the Garmin forum thread
  "Monetization of watch faces," a developer responding to a monetization
  question advised that when charging for apps or requesting donations you should
  "don't expect more than a beer or so a month." Thread participants include
  `agsurf5` (OP) and `jim_m_58`; the exchange is over 8 years old — **label this
  historical**. — [Garmin Forums, Monetization of watch faces](https://forums.garmin.com/developer/connect-iq/f/discussion/6907/monetization-of-watch-faces)
- **KiezelPay's co-founder posted in that same thread.** Kristof Verpoorten,
  co-founder of KiezelPay, identified himself as having "several years experience
  with selling watchfaces and apps for pebble and fitbit smartwatches" (~6 years
  ago). He gave no numbers. — [Garmin Forums, Monetization of watch faces](https://forums.garmin.com/developer/connect-iq/f/discussion/6907/monetization-of-watch-faces)
- **Garmin's forum rules suppress the very discussion we're looking for.** Per
  that thread, developers may discuss "pay versions/donations in the app store
  within the description, but not in the forums." This is a *structural* reason
  the case-study cupboard is bare — business talk is off-topic where the
  developers actually congregate. — [Garmin Forums, Monetization of watch faces](https://forums.garmin.com/developer/connect-iq/f/discussion/6907/monetization-of-watch-faces)
- **VAW.BE = Wim Van Aerschot, Antwerp, Belgium.** The single most legible indie
  case study on the platform. The store record for *Goals* exposes
  `supportEmailAddress: wim.van.aerschot@gmail.com` and
  `hardwareProductUrl: instagram.com/vawbe`. He describes himself as an
  "Independent Garmin developer, watch tester, and creator of Garmin School," and
  runs a content property ("Garmin School") publishing guides on watch
  comparisons, training metrics, navigation and app recommendations — explicitly
  as a support-and-acquisition channel. He maintains Instagram, TikTok, YouTube,
  X and Threads under @vawbe, plus a Linktree. He sells a **bundle deal
  advertising up to 90% savings** across his apps via KiezelPay. **His site lists
  88 total items across apps, watchfaces, widgets and data fields** — only 15 of
  which appear in the top 120 faces — and he gives no account anywhere of his own
  history or of a free-then-paid strategy. No user,
  download or revenue figures are published on his site. — [About Wim Van Aerschot, VAW.BE](https://garmin.vaw.be/en/about); [vaw.be](https://vaw.be/); [@vawbe Instagram](https://www.instagram.com/vawbe/); [Linktree](https://linktr.ee/vawbe); [X/@VAW](https://x.com/VAW)
- **frinkr monetizes 14 free faces entirely through Ko-fi tips.** Every one of
  frinkr's 14 listings in the top 120 is FREE, and each carries a *distinct*
  per-face Ko-fi product link (`ko-fi.com/s/45b7c33d8d` for *Black Grid*,
  `ko-fi.com/s/3b58e829de` for *Futura*, etc.). This is a fully-observable
  alternative monetization strategy: zero paid listings, donation capture
  off-platform. — Garmin store API, 2026-09-22; e.g. [Black Grid Ko-fi](https://ko-fi.com/s/45b7c33d8d)
- **TitanicTurtle runs its own web property.** 19 of the top 120 faces, with
  per-face pages at `gapps.orcatec.net/<name>` (zenith, mission, vega, horizon,
  io, victus, centurion, dinstinct, tactical). — Garmin store API, 2026-09-22
- **PixelPathos (`warmsound`) ships Crystal fully open-source on GitHub** — a
  1M-bucket face, first approved 2018-03-12, still in the top 20 in 2026. Its
  companion paid face *Lumeo* (€2.99, launched 2024-08-05) sits at bucket 10,000.
  — [github.com/warmsound/crystal-face](https://github.com/warmsound/crystal-face); Garmin store API
- **Other named indie publishers with public presence**: ManuelB
  (`apps.bliemel.net`, 3 listings), GreenBlack (`watchface.io/fenix8v3`,
  `watchface.io/datadash`, 5 listings), ReedWorks (`reed.works`, 2 listings),
  TheMagician (`magicdustwatchface.wordpress.com`), Petr.Koula
  (`actiface.blogspot.com`), Timefy-Dials (`timefy.us`), Stash.Digitale
  (`stashdigitale.com/ciq/modello`), VeshchiyOleg (`p2u.io`). — Garmin store API, 2026-09-22

### Inferences

- The developers who succeed here are **content-and-community operators, not just
  coders**. VAW.BE's Garmin School and frinkr's per-face Ko-fi pages are both
  off-platform infrastructure built *around* the listings. Nobody in the top 120
  with a visible strategy is relying on store discovery alone.
- Garmin's forum rule banning monetization discussion plausibly explains why no
  CIQ equivalent of an Indie Hackers revenue thread exists. The community that
  would write it is told not to.

### Gaps

- **No 2025–2026 first-hand revenue disclosure found**, from any Connect IQ
  developer, anywhere (forums, blogs, Indie Hackers, HN, Reddit, Medium). I
  consider this a genuine negative finding rather than a search failure — I ran
  site-restricted forum queries and chased named identities directly.
- No developer publishes download *trajectories* (day-over-day or month-over-month
  curves). The store gives only a current bucket.
- Whether VAW.BE, TitanicTurtle or frinkr do this full-time is undisclosed.
  VAW.BE's own site elsewhere describes app-making as "a hobby project," which
  conflicts with the "independent Garmin developer" framing on his About page;
  I could not resolve which is current.

---

## Q2. Reconstructing the large publishers' trajectories from store data

### Takeaway

Publisher concentration in the top 120 faces is extreme — three independent
publishers hold 48 of 120 slots — and every one of them got there by **publishing
many listings over multiple years**, not by one hit. The median top-120 face is
roughly two years old; the oldest still-ranking faces date to 2015.

### Cited Findings

All figures in this section: Garmin Connect IQ store API, WATCHFACE /
MOST_POPULAR / countryCode=US, pulled 2026-09-22. Launch dates are the
`firstApprovalDate` field on the single-app endpoint. **Note: the `releaseDate`
field on the *list* endpoint is a last-updated timestamp, not a launch date** —
it shows 2026-08/09 for almost everything and is useless for trajectory work.

**Publisher concentration in top 120 faces:**

| Publisher | Listings in top 120 | Paid listings | Own web presence |
|---|---|---|---|
| TitanicTurtle | 19 | 5 | gapps.orcatec.net |
| VAW.BE | 15 | 4 | vaw.be + Instagram/TikTok/YT/X/Threads |
| frinkr | 14 | 0 | Ko-fi (per-face product links) |
| Garmin (first-party) | 9 | 4 | — |
| MobileDriveway | 5 | 1 | — |
| GreenBlack | 5 | 3 | watchface.io |
| MarekSoso, ManuelB, TomekCz | 3 each | 0 | apps.bliemel.net (ManuelB) |

- **34 of the top 120 faces are paid; 86 are free.** Paid listings are a
  minority but a substantial one, and paid faces occupy ranks 1, 3, 4, 5, 6, 8,
  9, 12, 13, 15, 20, 21 — i.e. they are *not* excluded from the top. — Garmin store API
- **#1 face overall is paid at exactly €2.49.** VAW.BE *Goals* — first approved
  **2025-04-04** (535 days old), €2.49, bucket 100,000, 29,861 ratings, 4.9 avg.
  — [Goals listing](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)
- **TitanicTurtle's trajectory is legible and instructive.** Free flagships
  launched early and grew huge: *Instinct Mission* (2022-06-29, bucket 1M),
  *Zenith* (2024-09-25, 500k), *Vega* (2023-12-12, 500k), *Tomahawk VX*
  (2025-09-08, 500k). The **paid "Elite" line came later and sits an order of
  magnitude lower**: *Black Hawk Elite* (2026-03-13, €3.49, 100k), *Vanguard
  Elite* (2026-01-15, €3.49, 50k), *Tactical Elite* (2025-03-06, €4.69, 10k),
  *Tomahawk Elite* (2025-09-08, €3.99, 10k), *Fletcher Elite* (2025-12-01, €3.49,
  10k). — Garmin store API
- **GreenBlack runs the cleanest free/paid A-B in the store.** Same face,
  two listings: *Fenix 8 V2 - GB* (free, 2024-11-22, bucket **100,000**) vs
  *Fenix 8 V2 - PRO - GB* (€5.99, 2024-11-26, bucket **50,000**). And
  *Fenix8 V3 - GB* (free, 2024-08-29, **100,000**) vs *Fenix 8 V3 PRO - GB*
  (€5.99, same launch date, **10,000**). — Garmin store API
- **frinkr: 14 listings, all free, launched 2023-12 through 2026-05**, ranging
  bucket 50k to 500k. Newest (*Helix*, 2026-05-19, 125 days old) already at bucket
  100,000 — an established publisher's new release starts hot. — Garmin store API
- **Oldest survivors still ranking:** HermoT *NoFrills* (2015-09-09, 4,030 days,
  1M), Petr.Koula *ActiFace* (2015-02-25, 4,226 days, 1M), Stanislav.Bures *SC8*
  (2016-01-10, 3,907 days, 500k), _MASHAKE_ *GearMin* (2016-04-07, 3,819 days,
  1M), ReedWorks *Time Flies* (2016-10-19, 3,624 days, 500k), peterdedecker *Data
  Lover* (2018-03-23, 3,104 days, 1M). — Garmin store API
- **Age distribution of the top 120: only 3 faces are ≤90 days old, 5 are ≤180
  days, and 21 are ≤365 days. 99 of 120 are over a year old.** — Garmin store API

### Inferences

- The concentration is **catalogue-driven, not hit-driven**. TitanicTurtle, VAW.BE
  and frinkr each have 14–19 ranked listings. No single-listing independent
  publisher appears anywhere near the top. A developer with two listings is
  competing against portfolios of fifteen.
- The three ≤90-day-old entries in the top 120 are revealing: two are
  **established publishers' new releases** (TitanicTurtle *Mission Zero*, 68 days,
  bucket 100k; VAW.BE *Goals Pro*, 75 days, bucket 1,000) and one is a smaller
  publisher (GetWatchFaces *Quipu*, 70 days, €2.69, bucket 10,000). **An
  established catalogue transfers rank to new listings; a cold start does not.**
- Big publishers appear to run a deliberate **free-flagship / paid-premium
  split**, where the free face is the funnel and the paid variant monetizes a
  fraction of it.

---

## Q3. How long does a new listing take to accumulate meaningful downloads?

### Takeaway

I pulled the MOST_RECENT watch-face feed (n=90 distinct listings, fetched
individually for launch dates) and this is the most directly relevant evidence in
the whole file: **at 5–14 days old, 30 of 52 newly-published faces sit at download
bucket 1 and 20 sit at bucket 10.** Two sit at 100. Bucket 1 means "at least one
download." A new listing from an unknown publisher starts at effectively zero and
stays there for weeks.

### Cited Findings

Source for this entire section: Garmin store API, WATCHFACE / MOST_RECENT /
countryCode=US, 90 listings fetched individually for `firstApprovalDate`,
2026-09-22.

**Download-bucket distribution of newly published watch faces.** Read this as a
**snapshot, not a cohort aging over time.** The MOST_RECENT feed is dominated by
listings published in the last 7 days, so the rows below are nested subsets that
barely grow: the bucket-1 count is **30 at every horizon from 14 to 90 days** —
that is the same 30 listings throughout, with nothing new entering, not a flat
growth curve. The ≤90-day row adds only 7 listings over the ≤14-day row. The feed
cannot show a cohort maturing; it can only show where listings of each age
currently sit.

| Age | n | bucket 1 | bucket 10 | bucket 100 | bucket 1,000 |
|---|---|---|---|---|---|
| ≤14 days | 52 | 30 | 20 | 2 | 0 |
| ≤30 days | 55 | 30 | 20 | 4 | 1 |
| ≤60 days | 58 | 30 | 21 | 6 | 1 |
| ≤90 days | 59 | 30 | 22 | 6 | 1 |

**Paid listings only, within that cohort:**

| Age | n paid | buckets |
|---|---|---|
| ≤14 days | 7 | four at 1, two at 10, one at 100 |
| ≤90 days | 8 | four at 1, two at 10, two at 100 |

- **Rating counts for paid listings under 90 days old: 0, 0, 0, 0, 0, 2, 2, 31.**
  Five of eight new paid faces have zero ratings. — Garmin store API
- **Named examples at 5–6 days old, all at bucket 1:** LCD_DESIGN *Gatsby: Art
  Deco AMOLED*, JamesKwak *Runner Face: Weekly*, PawDan *Meadow Fawn*, FitDav
  *Violet Bridge*, Awooche *Autumn is Here*, Emer75x *Jupiter*, GreenPoint
  *Modern Analog Steel* (€2.49, bucket 1), GreenPoint *Modern Analog Orange*
  (€2.49, bucket 1). — Garmin store API
- **Fastest observed independent climb to a meaningful bucket:** GetWatchFaces
  *Quipu - Data Watch Face*, launched 2026-07-13 (70 days), €2.69 → bucket 10,000,
  176 ratings, 4.6. This is the single best-case new-paid-listing data point I
  found. — Garmin store API
- **Nimble_Wings *Octo***: launched 2026-02-27 (206 days), €3.49 → bucket **1,000**,
  756 ratings, 4.9. Seven months at €3.49 to reach bucket 1,000. Its sibling
  *Rondo* (2025-04-23, 516 days, €3.49) sits at bucket 10,000 with 5,418 ratings.
  — Garmin store API
- **A paid face can rank in the store's top 120 on roughly 1,000–10,000 lifetime
  installs.** The lowest bucket anywhere in the top 120 is 1,000, held by two paid
  faces: VAW.BE *Goals Pro* (rank ~115) and Nimble_Wings *Octo* (rank ~119). —
  Garmin store API
- **Developers confirm newness is the visibility mechanism, and it is short.**
  `Gerard`: "Good new watch faces never have a fair chance to make it or being
  noticed because they will be only visible in the store for maybe a week or two."
  `myaro`: "newness is the best way to get noticed" — describing this as the
  "trick" that high-volume publishers exploit. — [Garmin Forums, "The Connect IQ Store is getting worse by the day"](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669)
- **Browse depth is capped at four pages per category**; below that, search is the
  only discovery path. — [same thread](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669)

### Inferences

- The MOST_RECENT feed is visibly dominated by **template/volume farms** — PawDan,
  FitDav, Douglas341, Vista, GreenPoint, Madeline and Awooche each shipped
  multiple faces within the same 6-day window, with generic names (*Coral Arches*,
  *Segment Pulse*, *Amber Record*, *Pale Breeze*). This is the "newness" exploit
  Gerard and myaro describe, running at scale in 2026. HeroFace is competing for
  the new-release slot against dozens of same-day listings.
- The bucket-1 cohort and the bucket-1,000 cohort are separated by **months, not
  weeks**. Nothing in the data shows a new independent listing crossing 1,000
  installs inside 90 days.
- HeroSet and HeroFace at 0 downloads are **statistically unremarkable, not
  broken**. That is the baseline, not a failure signal.

### Gaps

- The MOST_RECENT feed is heavily weighted to the last week, so the ≤90-day
  cohort above (n=59) is really an "in the last two weeks" cohort with a thin
  tail. I cannot compute a clean day-30/60/90 *cohort curve* — I can only show
  where listings of each age currently sit.
- I could not find a single developer statement giving a time-to-N-downloads
  figure. The timing evidence is entirely observational.

---

## Q4. Free listings vs paid listings in the same catalogue

### Takeaway

Every large independent publisher runs both, and the structure is consistent: a
**free face carries the reach and a paid sibling monetizes a slice of it**, with
the paid variant typically one to two download buckets below the free one. VAW.BE
cross-links the two directly from the store description — the clearest documented
funnel on the platform.

### Cited Findings

- **VAW.BE cross-links free and paid variants inside the store listing itself.**
  The *Goals* description opens with: *"Free trial and availability with other
  payment methods here: https://apps.garmin.com/apps/0a933f67-c349-4efa-ad46-29384852649e
  — Or check Goals Pro for more features and options here:
  https://apps.garmin.com/apps/efe68843-c9ca-4ef0-afa7-5081b92e7875"* — i.e. the
  #1-ranked paid face is used as a hub pointing at both a trial/KiezelPay variant
  and a higher-priced Pro tier. — [Goals listing](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)
- **The full VAW.BE "Goals" family, with launch dates and buckets:**
  *Goals - with trial* (free, 2021-11-29, 100k) → *Goals V* (free, 2023-01-12,
  100k) → *Goals VII* (free, 2024-03-22, 100k) → *Goals 8* (free, 2024-11-12,
  100k) → *Goals VI* (free, 2023-08-30, 100k) → ***Goals*** (€2.49, 2025-04-04,
  100k, rank #1) → *Goals Pro* (€5.99, 2026-07-08, bucket 1,000). **Five years of
  free versions preceded the paid flagship.** — Garmin store API
- **GreenBlack's paired listings** (same face, free and €5.99, launched days
  apart): free *Fenix 8 V2 - GB* at 100k vs paid *PRO* variant at 50k; free
  *Fenix8 V3 - GB* at 100k vs paid *V3 PRO* at 10k. The free/paid bucket ratio is
  2x in one case and 10x in the other. — Garmin store API
- **TitanicTurtle's free flagships outrank its paid Elite line by 10–100x in
  bucket terms** (see Q2 table). — Garmin store API
- **MobileDriveway**: free *GLANCE watch face* (2021-10-27, bucket 1M, 68,861
  ratings — the highest rating count in the top 120) alongside paid *Glance Ultra*
  (2025-01-08, €5.99, bucket 10,000) and free *Glance Pro* (2022-01-13, 50k).
  Free flagship to paid tier is a **100x bucket gap**. — Garmin store API
- **frinkr is the counter-example: zero paid listings across 14 ranked faces**,
  monetizing entirely through per-face Ko-fi links. — Garmin store API
- **KiezelPay is the third-party trial/payment layer indies use**, and it takes
  **27% per purchase, minimum $0.27 USD** — versus Garmin's own 15%. A KiezelPay
  listing is free in the store with a time-limited trial (commonly 24 hours)
  before payment. One source states KiezelPay's "purchase rate and income is
  significantly higher than standalone donation rates," but gives no figure. —
  [KiezelPay FAQ](https://kiezelpay.com/faq/); [Garmin FAQ, awesomeclockfaces.com](https://awesomeclockfaces.com/garmin-frequently-asked-questions/)
- Listings visibly named for this pattern exist in the store: *Lumeo (KiezelPay)*,
  *Crystal Reborn (KiezelPay)*, VAW.BE's *Tones - with trial & kpay* and
  *Butterflies - with trial*. — [Lumeo (KiezelPay)](https://apps.garmin.com/apps/22bb01ba-ace2-4662-8690-f4e56d0bdeb9); [Crystal Reborn (KiezelPay)](https://apps.garmin.com/apps/111ed5fc-c61f-47ec-b05d-aac856024d06)

### Inferences

- Two paid listings with no free counterpart — HeroSet and HeroFace's current
  configuration — matches **no successful publisher's structure in the top 120**.
  Every ranked independent either has a free flagship funnelling a paid tier, or
  is free-only with off-platform tipping.
- The GreenBlack pairs suggest a rough **free-to-paid capture of 10–50%** at the
  bucket level when the paid variant is genuinely differentiated and launched
  simultaneously. The MobileDriveway and TitanicTurtle gaps (10–100x) suggest
  far lower capture when the paid tier launches years later at a higher price.
  These are bucket ratios, not measured conversion rates — treat as order of
  magnitude only.
- VAW.BE's *Goals* family shows **five years of free listings preceding the €2.49
  flagship**. Important qualification: this is an **observed ordering with no
  stated intent behind it.** I fetched both his site and his About page looking
  for him describing a free-then-paid strategy and **he describes no such
  strategy anywhere** — no history, no explanation of why paid versions exist, no
  hobby-vs-business statement. It is equally consistent with retroactive
  pattern-matching on a hobbyist's back catalogue as with a deliberate funnel.
  Do not present it as a documented playbook. — [garmin.vaw.be/en](https://garmin.vaw.be/en); [About page](https://garmin.vaw.be/en/about)

### Gaps

- No publisher discloses an actual free→paid conversion percentage.
- I could not determine whether *Goals*' #1 rank is *because* of the free
  predecessors or independent of them.

---

## Q5. Which channel actually brought users — first-hand statements

### Takeaway

The only first-hand mechanism developers name is **store newness**, and they
describe it as lasting a week or two. Beyond that, the observable behaviour of
successful publishers points to owned channels (own website, Instagram/TikTok,
Ko-fi, a content property), but **no developer has stated on record that a
specific external channel drove installs**.

### Cited Findings

- **Newness, stated first-hand.** `myaro`: "Gross downloads are a major factor in
  the rankings, yet this disincentivizes the development of watch faces that can
  only target modern devices," and separately, on volume publishers: "They seem to
  have discovered the 'trick' to the Garmin store that I've also recently learned:
  newness is the best way to get noticed." — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669)
- **The visibility window is short.** `Gerard`: new faces "will be only visible in
  the store for maybe a week or two." — [same thread](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669)
- **Store browse is capped and search is the fallback.** Users can see only four
  pages of results per category; outside that, search is the sole discovery path.
  `peterdedecker` explains the cap was likely imposed because deep paging "was
  very slow to load the connect iq app." — [same thread](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669)
- **Featured placement is described as brief and unreliable.** Developer `9164742`
  (≈May 2026): "Just be happy to get promoted for one day or so in top paid apps,"
  and: "I wouldn't expect apps to even appear in Hot and Fresh, since this
  category is not apparently not for Hot and Fresh but for a random mix of not new
  and not fresh apps." — [Garmin Forums, "Apps just disappeared from the Connect IQ Store"](https://forums.garmin.com/developer/connect-iq/i/bug-reports/apps-just-disappeared-from-the-connect-iq-store-450043715)
- **Owned-channel behaviour, observed not stated:** VAW.BE runs Garmin School
  (guides on watch comparisons, training metrics, navigation, app
  recommendations) plus Instagram/TikTok/YouTube/X/Threads, and uses a YouTube
  video on the *Goals* listing itself (`videoUrl` is populated on the #1 face).
  frinkr attaches a unique Ko-fi product link per face. TitanicTurtle runs
  per-face pages on its own domain. — [garmin.vaw.be/en/about](https://garmin.vaw.be/en/about); Garmin store API
- **Garmin removed web-store purchasing in November 2025, making the mobile app
  mandatory**, which drew user backlash over the mobile browsing experience. This
  narrows the discovery surface further. — [the5krunner, 2025-11-22](https://the5krunner.com/2025/11/22/garmin-shuts-down-connect-iq-web-store-mobile-app-mandatory/)

### Inferences

- Because rank responds to recent movement (see Q6) and store visibility for a new
  listing lasts "a week or two," **external traffic has to be timed to the launch
  window to compound into rank** rather than being spent later.
- Nobody in the ranked set relies on store discovery alone. Every top independent
  has an owned channel. That is circumstantial but unanimous.

### Gaps

- **No first-hand statement anywhere attributing installs to Reddit, YouTube,
  press, or any named external channel.** I looked specifically for this. The
  brief's note that press is earned off existing rank is consistent with what I
  found, but I found no developer confirming it either way.

---

## Q6. A finding that contradicts the brief's stated premise

### Takeaway

I was told not to re-derive that "store rank appears sticky lifetime-installs."
I did not re-derive it — I tripped over direct counter-evidence, and it is the
most decision-relevant thing in this file.

### Cited Findings

- **Rank #1 (VAW.BE *Goals*) sits at download bucket 100,000. Rank #2 (Garmin
  *Face It®*) sits at bucket 5,000,000.** Lifetime installs cannot produce that
  ordering. — Garmin store API, 2026-09-22
- More of the same inversion throughout the top 30: rank 4 (Nimble_Wings *Rondo*)
  at bucket 10,000 outranks rank 17 (PixelPathos *Crystal*) at bucket 1,000,000,
  and rank 9 (GreenBlack *Fenix 8 V3 PRO*) at bucket 10,000 outranks rank 10
  (peterdedecker *Data Lover*) at bucket 1,000,000. — Garmin store API
- **TitanicTurtle *Mission Zero*, 68 days old, is already at bucket 100,000 and
  ranked 90th** — while 3,000+ day old faces at bucket 1,000,000 rank below it.
  — Garmin store API
- A developer's own model of ranking is the opposite: `myaro` states "Gross
  downloads are a major factor in the rankings." — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669)

### Inferences

- Whatever `MOST_POPULAR` sorts on has a **large recency or velocity component**,
  not pure lifetime installs. Developer folk-knowledge ("gross downloads") and
  the observed ordering disagree, and the observed ordering is primary evidence.
- This **flips the strategic picture** from "rank is unwinnable because incumbents
  have lifetime-install moats" to "**rank responds to recent movement**." A burst
  of installs concentrated in a short window is worth materially more than the
  same installs spread thin — which is exactly consistent with the volume-farm
  "newness" exploit and with frinkr's 125-day-old *Helix* already at bucket 100k.

### Gaps

- I cannot determine the exact ranking formula, the lookback window, or how price
  and rating weight into it. This is an inference from ordering, not a
  reverse-engineered algorithm.

---

## Q7. Failures, quitters, and the honest downside

### Takeaway

I hunted for these explicitly. There is no published indie CIQ postmortem. What
exists is a documented, still-unresolved payment failure that cost a developer
months, and a body of forum complaint about structural unfairness to new
publishers — including one blunt statement that a newcomer cannot reach the top.

### Cited Findings

- **`li2niu`: got paid by users, could not get the money out — a 7+ month
  ordeal.** Thread title, verbatim: **"Earning money on Connect IQ is easy.
  Actually getting paid is not."** Timeline: paid the $99 fee; **September 2025**
  transfer loop began (Adyen portal indicated GBP payouts supported, but the
  system forcibly attempts USD transfers to a GBP account, rejected by the bank);
  **2026-03-03** Garmin Support attempted a manual transfer; **2026-03-16 / 04-01**
  final solution offered; **April 2026** money confirmed bounced back. The
  developer's summary of Garmin's resolution: *"Their payment system has a bug,
  and their official solution is to tell developers to go open a new bank
  account."* No revenue figure disclosed. — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/discussion/436946/earning-money-on-connect-iq-is-easy-actually-getting-paid-is-not)
- **A new developer cannot reach the top, stated flatly.** `9164742` (≈May 2026):
  *"If you're not already among the top 10 developers from the day 1 (which is
  impossible), you won't likely get there."* and *"Your apps are destined to get
  lost among billions of others, it's only a matter of time."* — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/i/bug-reports/apps-just-disappeared-from-the-connect-iq-store-450043715)
- **Listings disappearing from the store, costing sales.** `Silvero Studios`
  (2026-05-11): *"Thing is the Store is just buggy and I'm missing out on sales
  because my apps have disappeared everywhere"* and *"my apps Blackjack, Chess,
  and Poker apps, my Highest Selling apps, legit just disappeared from the mobile
  store."* — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/i/bug-reports/apps-just-disappeared-from-the-connect-iq-store-450043715)
- **The $100/yr fee is a real objection for small developers.** From the
  monetization thread: *"100 USD per year is a lot if compared to other companies
  (google and apple both only want a one time payment)."* Another developer noted
  the monetization system supports only newer Garmin devices, speculating Garmin
  uses paid apps as a hardware-upgrade incentive. — [Garmin Forums, Garmin CIQ Monetization](https://forums.garmin.com/developer/connect-iq/f/discussion/380040/garmin-ciq-monetization)
- **Evidence of abandonment is visible but unattributed.** Among newly published
  paid faces under 90 days old, five of eight have **zero ratings**. Within the
  top 120, several paid faces from small publishers sit at low buckets with poor
  ratings — SPWatch *Outerfield* (508 days, €2.69, 10k, **3.8**), ECOWatch
  *Heritage Watch* (402 days, €2.49, 10k, **2.7**), Stanislav.Bures *Style 7*
  (951 days, €3.49, 10k, **3.6**), timwatch *Pure Harmony TiM* (423 days, €2.49,
  50k, **3.3**). — Garmin store API

### Inferences

- The failure mode here is likely **quiet attrition, not a written postmortem**.
  Developers stop renewing the $100 fee and their listings vanish; nobody writes
  it up because the forum bans the business conversation and because a zero-revenue
  result is not a story people publish.
- **The $100/yr fee sets a hard break-even.** At €2.49 with Garmin's 15% cut,
  net is ~€2.12 per sale; roughly **48 sales per year across both listings** just
  to cover the merchant fee. Both listings at 0 downloads means the programme is
  currently running at a loss of $100/yr plus the time.
- `li2niu`'s case is a live risk worth planning for: **payout currency mismatch**.
  If HeroSet/HeroFace ever do sell, having a bank account that accepts USD
  matters before the first payout, not after.

### Gaps

- **No named developer has published a full quit-and-why narrative with numbers.**
  I searched forums, blogs, Indie Hackers, HN, Reddit and Medium. This is the
  largest gap in the assignment and I believe it reflects reality rather than
  search failure — the incentive to publish a zero-revenue postmortem is nil and
  the main venue forbids the topic.
- No data on developer-account churn or listing-delisting rates.

---

## Q8. Realistic revenue scale

### Takeaway

The only public, quantified statement on CIQ earnings is "a beer or so a month,"
and it is ~8 years old and about donations. Nothing in 2025–2026 contradicts or
confirms it. Everything below is bounded inference from bucket data and should be
labelled as such.

### Cited Findings

- **Garmin's cut is 15%; the developer programme fee is $100/yr, non-refundable.
  Garmin absorbs credit-card fees; digital service taxes and currency-conversion
  costs are withheld from payouts.** — [Connect IQ Monetization](https://developer.garmin.com/connect-iq/monetization/); [Merchant Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/)
- **KiezelPay, the indie alternative, takes 27% per purchase (min $0.27 USD)** —
  nearly double Garmin's rate, in exchange for trial mechanics and broader device
  support. — [KiezelPay FAQ](https://kiezelpay.com/faq/); [awesomeclockfaces.com](https://awesomeclockfaces.com/garmin-frequently-asked-questions/)
- **"Don't expect more than a beer or so a month"** — the sole quantified
  community statement, **historical (~8 years old)**, in the context of paid apps
  and donations. — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/discussion/6907/monetization-of-watch-faces)
- **I deliberately decline to convert download buckets into euro figures, and the
  report-writer should too.** Worked example of why: GetWatchFaces *Quipu*
  (€2.69, 70 days old) sits at bucket 10,000. Multiplying that floor by price and
  Garmin's 85% would imply five figures of gross revenue in ten weeks — which is
  **incompatible with my own Day-90 cohort, where 1 of 59 listings reached even
  bucket 1,000**. Two readings explain the anomaly and both invalidate the
  arithmetic: either `downloadCount` counts store acquisitions/installs across a
  user's multiple devices rather than paid sales, or *Quipu* ran free before
  switching to paid. I cannot distinguish them from the API, so the
  multiplication is meaningless. Report *Quipu* as a **bucket observation with an
  unexplained anomaly**, not as revenue. — Garmin store API, 2026-09-22
- **The same caution applies at the low end.** Nimble_Wings *Octo* (€3.49, 206
  days) sits at bucket **1,000** — between 1,000 and 10,000. That is a 10x range
  on the download count *before* any assumption about what a "download" is. No
  monthly revenue figure derived from it would be credible. — Garmin store API

### Inferences

- The honest summary is that **no defensible revenue figure for a Connect IQ paid
  face can be constructed from public data.** The bucket floors span an order of
  magnitude each, the definition of a "download" is unverified, and the only
  first-hand number in existence is an ~8-year-old "a beer a month." Anyone
  quoting a confident monthly figure for this platform is guessing.
- The €2.49 price point is not the problem — the **#1 ranked face in the entire
  store is €2.49**. Price is not what separates HeroFace from *Goals*; catalogue
  depth, a free funnel, five years of listings and an owned audience are.

### Gaps

- **No developer has ever published actual CIQ revenue.** Every number in this
  section is derived from bucket floors, not from disclosure.
- Bucket floors likely overstate paid sales, because `downloadCount` may include
  installs across a user's multiple devices, reinstalls, or free-trial
  acquisitions. I could not verify what Garmin counts as a "download."

---

## MEASUREMENT: realistic 30 / 60 / 90-day expectation for a new paid listing

Derived from the MOST_RECENT cohort (n=90 listings fetched individually,
2026-09-22), cross-checked against the top-120 age distribution. Applies to a
**cold-start publisher with no existing catalogue, no owned audience, one or two
paid listings** — i.e. precisely HeroSet and HeroFace today.

The euro column is **arithmetic on the download range at €2.49 net of Garmin's
15%, assuming every download is a paid sale.** That assumption is unverified (see
Q8) but is far less distorting at 1–100 installs than at bucket scale. Treat it
as an order-of-magnitude ceiling, not a forecast.

| Horizon | Downloads (modal / plausible range) | Arithmetic at €2.49, net of Garmin's 15% | Ratings expected |
|---|---|---|---|
| **Day 30** | **1–10** installs. In the observed cohort, 30 of 55 listings ≤30 days sat at bucket 1 and 20 at bucket 10; only 4 reached bucket 100. | **€2 – €21** | **0.** Five of eight new paid faces under 90 days had zero ratings. |
| **Day 60** | **1–100** installs. The ≤60-day cohort shifts only marginally: 30 still at bucket 1, 21 at 10, 6 at 100. | **€2 – €212** | 0–2 |
| **Day 90** | **10–100** installs, with bucket 1,000 reachable but rare (1 of 59 in the cohort). | **€21 – €212**; upside case ~€2,100 if the rare bucket-1,000 outcome hits | 0–5 |

**Break-even context:** the $100/yr merchant fee needs ~48 sales/yr at €2.49 net.
On the modal path above, **two listings do not clear the merchant fee in year
one**. Expect a net loss of roughly $80–100 in the first twelve months, excluding
time.

**Timeline to something that resembles traction.** The evidence points to
**6–24 months, not 90 days**:

- 99 of the top 120 faces are over a year old; only 3 are under 90 days, and two
  of those three are established publishers' releases.
- The fastest cold-start independent paid face observed reached bucket 10,000 in
  **70 days** (GetWatchFaces *Quipu*) — a single outlier I could not corroborate.
- A more typical independent paid trajectory: **~7 months to bucket 1,000**
  (Nimble_Wings *Octo*), **~17 months to bucket 10,000** (Nimble_Wings *Rondo*).
- VAW.BE ran **five years of free listings before the €2.49 flagship**, which is
  now #1.

**Confidence levels, stated honestly:**

- **Day-30 expectation of near-zero: HIGH confidence.** Directly observed across
  55 listings; the distribution is tight and unambiguous. Both current listings at
  0 downloads is the *expected* outcome, not evidence of a defect.
- **Day-60/90 ranges: MEDIUM confidence.** The cohort thins out past two weeks
  (the MOST_RECENT feed skews to the last 7 days), so the 60- and 90-day rows are
  built on fewer listings than the 30-day row.
- **Revenue conversion of those downloads: LOW confidence.** Bucket floors are
  not sale counts, `reviewCount` is incoherent as an install proxy (see the
  warning at the top), and no developer has ever published a real figure. The
  euro columns above should be read as arithmetic on bucket floors, not as
  forecasts.
- **The 6–24 month traction timeline: MEDIUM-HIGH confidence.** It is supported
  independently by the top-120 age distribution, by individual publisher
  trajectories, and by the forum consensus that a new listing's visibility lasts
  "a week or two."

**One structural caveat that cuts the other way.** Because rank appears to carry a
recency/velocity component rather than being a pure lifetime-install moat (Q6),
these baselines describe listings that received *no external traffic*. A launch
burst timed into the store's short newness window is the one lever the data
suggests is not already closed — but I found **no first-hand developer account of
anyone successfully pulling that off**, so its effect size is unmeasured.
