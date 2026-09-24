# Distribution and marketing for Connect IQ watch faces

> **⚠ CORRECTED 2026-09-24.** Later research found several claims here wrong. The most
> important: **store ranking is NOT sticky lifetime installs.** `mostPopular` depends
> heavily on recent downloads (rank #1 has 100k downloads, rank #2 has 5M). Also, the paid share of
> top faces is 34/120, not 51/120, and `/apps?searchTerm=` is ignored (real search is
> `/apps/keywords`, which scores descriptions too and isn't weighted by installs).
> See the corrections section of `Selling HeroSet and HeroFace.md`.


Scope note on dating: the assignment prioritises 2025-09 → 2026-09. In-window
sources used here: the5krunner's Top 100 CIQ list (2026-01-15), the 2026 "best
watch faces" roundups, the live Connect IQ store listing for GLANCE (fetched
2026-09), Garmin developer docs (undated, current). Explicitly **historical**:
the Aug 2024 premium-apps press release, GLANCE's 2022 Connect IQ Developer
Award, and the Connect IQ store-quality forum thread (posts dated "over 2 years
ago", i.e. ~2023). Historical items are labelled inline.

Install counts on the Connect IQ store are displayed as buckets ("1M+
Downloads", "100,000"), never exact figures — every install number below is a
bucket, not a count.

Source-quality notes for the report writer:

- Two Garmin developer documentation pages (`publishing-to-the-store`,
  `app-review-guidelines`) returned JS navigation shells on fetch; anything
  attributed to them here is search-snippet-sourced and flagged as such.
- `myday24.com` and `wristtale.com` are **vendor-owned** roundups. Treat their
  recommendations as marketing evidence, not independent evaluation. Their
  figures for third-party faces (Crystal, Segment34, GLANCE, Rondo) are
  secondhand.
- Tom's Guide article bodies could not be fetched (truncated content); face
  names, prices and review counts from those articles are search-snippet-level.
- The main Connect IQ store-quality forum thread is ~2023 and its participants
  (`jim_m_58`, `myaro`, `PeterDedecker`, `Gerard`) are developers, not Garmin
  employees. No statement in it should be attributed to Garmin.
- Reddit could not be searched (no results returned for `site:reddit.com`
  queries), so the Reddit channel is untested in this research.



## How do Garmin users actually discover watch faces? What signals drive store ranking?

### Takeaway
Discovery is dominated by the Connect IQ store's own browse/search surfaces
(which developers describe as shallow and winner-take-all), supplemented by
enthusiast tech press and developer-run forum threads; Garmin has published no
description of its ranking algorithm, and I found no primary source for one.

### Cited Findings
- The Connect IQ store exposes only a limited number of browsable pages per
  category; a developer (PeterDedecker) states the store was restricted to four
  browsable pages per category, so apps outside that set are reachable only by
  direct search — [Garmin Forums, Connect IQ Store Discussion](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669) (**historical**, ~2023)
- In the same thread, developer "Gerard" states: "Good new watch faces never
  have a fair chance to make it or being noticed because they will be only
  visible in the store for maybe a week or two" — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669) (**historical**)
- The same thread reports developers uploading 10+ watch faces weekly and
  operating multiple publisher accounts, and one developer with 782 bundled
  watch faces — attributed to forum participant "myaro" — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669) (**historical**)
- A forum participant posting as `jim_m_58` (a forum regular, **not** identified
  as Garmin staff) characterised the Connect IQ team as too small to curate at
  Apple/Google scale, and pointed to the "Hot & Fresh" category as the intended
  home for new apps — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669) (**historical**; treat as a developer's characterisation, not a Garmin statement)
- Garmin operates a "Hot & Fresh Apps" browse surface as a distinct store
  category — [apps.garmin.com/apps/hotFresh](https://apps.garmin.com/apps/hotFresh)
- the5krunner's Top 100 Connect IQ list is built from "a combination of installs
  per week, retention and review frequency", sourced from "Garmin's Connect IQ
  Store API and its public-facing web index". This is **the author's own ranking
  construction, not Garmin's algorithm** — [the5krunner, 2026-01-15](https://the5krunner.com/2026/01/15/top-100-garmin-connect-iq-apps/)
- That list is dominated by music/brand apps and Garmin-native apps (Spotify
  10M+, Deezer 5M+, Amazon Music 5M+, Komoot 1M+), with **Crystal** (a watch
  face) at 1M+ appearing among the high-download third-party entries the article
  lists; the fetched excerpt gave a partial "other notable" list, not an
  exhaustive one — [the5krunner](https://the5krunner.com/2026/01/15/top-100-garmin-connect-iq-apps/)
- Enthusiast tech press is a visible discovery channel: Tom's Guide runs
  repeated dedicated watch-face pieces, e.g. "This is the most popular free
  Garmin watch face" — [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/this-is-the-most-popular-free-garmin-watch-face-heres-4-things-i-like-and-3-i-dislike),
  "I review Garmins for a living and these are my 6 favorite watch faces" — [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/i-review-garmin-for-a-living-and-these-are-my-5-favorite-watch-faces),
  "I test Garmins for a living and this $5 watch face is a gamechanger" — [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/i-test-garmins-for-a-living-and-this-usd5-watch-face-is-a-gamechanger)
- Third-party catalogue/aggregator sites index Connect IQ faces independently of
  Garmin's store and rank for face names in search, e.g. GarminHub's page for
  GLANCE — [GarminHub](https://garminhub.com/en/watch-faces/glance-watch-face) and
  [GarminHub, Glance Ultra](https://garminhub.com/en/watch-faces/glance-ultra)
- Wareable maintains an evergreen roundup, "Best Garmin watch faces: 16 epic
  faces to download" — [Wareable](https://www.wareable.com/features/best-garmin-watch-faces-to-download-7227)
- Garmin-side promotion demonstrably drives press coverage: the Pokémon Sleep
  watch-face collaboration was covered by both Tom's Guide and Notebookcheck —
  [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/pokemon-sleep-watch-faces-are-now-available-for-free-on-your-garmin-its-my-dream-collab);
  [Notebookcheck](https://www.notebookcheck.net/Garmin-unveils-surprising-Pokemon-watch-faces-free-for-smartwatches-including-Fenix-8-and-Forerunner-970.1249875.0.html)
- Garmin's limited rollout of some watch faces drew user criticism reported in
  press — [Notebookcheck](https://www.notebookcheck.net/Garmin-attracts-criticism-from-fans-after-limited-watch-face-rollout.1251279.0.html)

### Inferences
- Ranking appears to be cumulative-install-weighted: the top of the store looks
  stagnant while lower positions churn, which is the signature of a
  lifetime-downloads sort rather than a velocity sort. (This characterisation
  came to me via a search-engine summary of the forum thread and was not found
  verbatim in the fetched thread text — treat as my reading of the evidence.)
  Faces with millions of installs (Crystal, GLANCE) hold position for years,
  including Crystal whose original was last updated 2018.
- Because browse depth is capped, the practical acquisition funnel for a new
  face is: (a) the short "Hot & Fresh" / new-release window, (b) exact-name
  search driven by off-store mentions, (c) press/roundup coverage. Only (b) and
  (c) are controllable by the developer.
- The presence of independent catalogue sites (GarminHub) means a face's name is
  an SEO asset outside Garmin's store; distinctive, searchable names beat generic
  ones ("Segment34", "GLANCE", "Rondo" vs. "Digital Watch Face 7").

### Gaps
- **No primary source describes Garmin's store ranking algorithm.** Garmin has
  not published ranking signals, and I found no Garmin statement on it.
- I could not retrieve r/Garmin threads directly: `site:reddit.com` searches
  returned no Reddit results (search index restriction). So the claim "Reddit is
  a discovery channel" is **unverified** here — plausible but unsourced in this
  research.
- No data on the split between the Connect IQ phone app, the Garmin Connect
  mobile app's face picker, and the web store as discovery entry points.
- No 2025-26 evidence on whether the four-page browse cap still applies; the
  source for it is ~2023.

## What does the Connect IQ store listing allow as a marketing surface?

### Takeaway
The listing surface is narrow — title, developer name, icon, category, price,
description, screenshots, version string and rating — and Garmin's own written
publishing guidance is thin and largely unretrievable; the strongest verified
guidance is "be very specific in your description."

### Cited Findings
- Garmin's submission guidance: the developer exports a `.iq` file, then adds a
  description and screenshots after upload; Garmin instructs developers to be
  "very specific in your description. This is your chance to get people
  interested in getting your app" — [Garmin Developers, Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/)
- The app manifest must specify all products the developer wishes to support,
  and the export wizard allows updating supported languages before export —
  [Garmin Developers, Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/)
- Review process: binary validation runs first, the app stays hidden from the
  store during review, and the developer is notified on approval, at which point
  it becomes publicly visible — [Garmin Developers, Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/)
- Observed live listing fields (GLANCE watch face, fetched 2026-09): app title,
  developer name (MobileDriveway), category ("Watch face"), price (Free), rating
  (4.9), install bucket ("1M+ Downloads"), version string (4.26.2), and a link to
  the developer's profile/portfolio page — [Connect IQ Store, GLANCE](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae)
- The same fetch found **no** developer website field, no direct support contact,
  no changelog/"what's new" entries and no related-app rail rendered in the
  server-delivered HTML — [Connect IQ Store, GLANCE](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae)
- Every developer gets a store profile page aggregating their apps, e.g.
  [apps.garmin.com/en-US/developer/3f92e7e2-…/apps](https://apps.garmin.com/en-US/developer/3f92e7e2-c9da-49e0-882b-ae68b23f7b84/apps)
- Brand-guideline constraint: developers may use Connect IQ imagery to promote
  their app's availability in the store and its compatibility with Garmin
  products, but may not market using Garmin's name, logo or trademarks without
  prior written consent — [Garmin Brand Guidelines, Connect IQ](https://developer.garmin.com/brand-guidelines/connect-iq/)
- Icon guidance (500 × 500 px, sRGB; ~10 px padding; centred; not stretched;
  simple designs preferred because detail is lost at small sizes) appears in
  Garmin's developer documentation, but I obtained it **only via search-engine
  summary**, not by fetching the page — treat as snippet-sourced — [Garmin Developers, Publishing to the Store](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/)
- Garmin maintains an App Review Guidelines document — [Garmin Developers](https://developer.garmin.com/connect-iq/app-review-guidelines/)

### Inferences
- The icon is the highest-leverage listing asset, because it is what appears in
  every browse list and search result row, and the listing page itself carries
  very little else.
- Approval gating means launch timing is not fully under developer control;
  a seasonal or device-launch-timed release needs slack for review.

### Gaps
- **Garmin's written listing constraints could not be verified.** Two fetches on
  `developer.garmin.com` (`/connect-iq/core-topics/publishing-to-the-store/` and
  `/connect-iq/app-review-guidelines/`) returned JavaScript navigation shells
  with no body content. Character limits for title/description, screenshot
  counts and formats, keyword/tag fields, and category rules are therefore
  **unverified**.
- I found no evidence that the Connect IQ store has a keywords/tags field at all.
- The GLANCE listing fetch returned metadata only (title, developer, category,
  price, rating, install bucket, version, profile link). That is the signature of
  client-side rendering — the same domain returned an empty shell for
  `apps.garmin.com/en-US/apps?tab=watchFaces` — so the description, screenshot
  and changelog surfaces **could not be inspected** and must not be assumed
  absent. The rendered version string (4.26.2) shows versioning is surfaced in
  some form.
- Rules on duplicate/bundled listings (relevant given the spam complaints above)
  are in the App Review Guidelines, which I could not read.

## What do top watch-face developers do off-store?

### Takeaway
The observable pattern is: an own website that acts as documentation plus SEO
surface, a developer-run support thread on the Garmin forum, and a product
ladder (free face → Pro/Ultra paid variants) rather than paid marketing; several
top developers also publish their own "best watch faces" roundups that feature
their own catalogue.

### Cited Findings
- **MobileDriveway (GLANCE)** runs its own product site with per-face pages —
  [mobiledriveway.com/glance.html](https://www.mobiledriveway.com/glance.html) and
  [mobiledriveway.com/glance_dual.html](https://www.mobiledriveway.com/glance_dual.html)
- MobileDriveway runs a developer-owned support/feedback thread in the Connect
  IQ App Showcase forum, described as created "to answer questions, gather
  feedback and suggestions" — [Garmin Forums, Watchface: Glance](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance)
- MobileDriveway operates a product ladder of related faces: Glance, Glance Pro,
  Glance Ultra, HANDY IQ, EASY+, EASY Round, BIG EASY IQ, with colour themes
  shared between Glance and Glance Pro — [Garmin Forums, Watchface: Glance](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance)
- GLANCE holds a 4.9 rating; review counts reported vary by source and date
  (53K per Tom's Guide via search summary; 67,000+ per a 2026 roundup) — sources
  disagree, and the store listing fetch did not render a review count —
  [Connect IQ Store](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae); [Tom's Guide](https://www.tomsguide.com/wellness/smartwatches/this-is-the-most-popular-free-garmin-watch-face-heres-4-things-i-like-and-3-i-dislike); [myday24 roundup](https://www.myday24.com/blog/best-garmin-watch-faces/)
- Other developers use the App Showcase forum the same way, e.g. the long-running
  thread for the M2 watch face — [Garmin Forums, Watchface: M2](https://forums.garmin.com/developer/connect-iq/f/showcase/213203/watchface-m2/1122971)
- **Tomas Slavicek** runs a branded developer site (tomasslavicek.cz), publishes
  a per-face catalogue (My Day 24, Colorama, Half Time, Skeleton Tourbillon,
  Regulator, Skeleton Bridge, Smoked Crystal, Activity Graph, Stardome, Avionis,
  Auralis, Mandalis, Daedal), states he has been active since 2017 with 100,000+
  installs across apps, and publishes a direct support email —
  [myday24.com/blog/best-garmin-watch-faces](https://www.myday24.com/blog/best-garmin-watch-faces/)
- That "best Garmin watch faces" roundup is **the developer's own promotional
  blog**: the page discloses that many of the recommended faces are the author's
  own creations. It is strong evidence of a self-authored-SEO-roundup tactic and
  is **not** independent evaluation — [myday24.com](https://www.myday24.com/blog/best-garmin-watch-faces/)
- Similar third-party/adjacent-product roundups exist as acquisition surfaces,
  e.g. WristTale (a Connect IQ app vendor) publishing "Best Garmin Watch Faces
  2026" — [wristtale.com](https://wristtale.com/en/blog/best-garmin-watch-faces),
  and WatchFaceKit — [watchfacekit.com](https://watchfacekit.com/best-garmin-watch-faces/)
- Open source as a distribution/credibility tactic: **Crystal** (1M+ installs) is
  open source, with the developer's rewrite "Crystal Reborn" where new
  development happens — [myday24 roundup, snippet](https://www.myday24.com/blog/best-garmin-watch-faces/);
  GitHub hosts many public face repos under the `garmin-watch-face` topic —
  [GitHub topic](https://github.com/topics/garmin-watch-face); Garmin publishes
  official sample faces — [garmin/connectiq-apps](https://github.com/garmin/connectiq-apps/tree/master/watchfaces)
- A demo/free-tier variant as a funnel: Rondo Analog ships a free demo version
  alongside the paid face (snippet-sourced from the myday24 roundup) —
  [myday24.com](https://www.myday24.com/blog/best-garmin-watch-faces/)
- Garmin's developer program itself points developers to the forums for
  community, and a Discord channel is referenced in monetization discussion —
  [Garmin Forums, Monetization of watch faces](https://forums.garmin.com/developer/connect-iq/f/discussion/6907/monetization-of-watch-faces)

### Inferences
- The forum App Showcase thread is the closest thing Connect IQ has to a
  developer-owned community surface, and the top faces use it as a de facto
  support desk, changelog and roadmap channel — filling the gap left by the
  store listing's missing changelog/support fields.
- The ladder pattern (free flagship → Pro/Ultra paid siblings) converts the free
  face's store ranking into distribution for paid SKUs; the free face is the
  marketing channel.
- Self-published "best of" roundups are cheap and evidently common: of the top
  search results for "best Garmin watch faces 2026", two are verifiably owned by
  parties selling Connect IQ products (myday24 = Tomas Slavicek, self-disclosed;
  wristtale = a Connect IQ app vendor). WatchFaceKit's ownership was not checked.
  This is the most replicable off-store tactic observed.

### Gaps
- **No verified evidence of Discord or Patreon communities run by top watch-face
  developers.** Searches returned generic Discord/Patreon/itch.io noise. Do not
  assert this channel.
- No verified examples of developer YouTube demo channels, Instagram accounts or
  newsletters for Connect IQ faces. I found none.
- Crystal's and Segment34's developer identities and their own sites were not
  confirmed by a fetched primary source.

## Paid advertising, influencer and press routes

### Takeaway
There is visible, repeated editorial coverage of individual watch faces by
enthusiast press (Tom's Guide most consistently, plus the5krunner for
store-level analysis), but I found **no evidence of any paid advertising or
influencer-payment route** operating in this niche.

### Cited Findings
- Tom's Guide publishes recurring single-face and roundup articles, including a
  piece on a $5 paid face and a review of the most popular free face —
  [Tom's Guide, $5 face](https://www.tomsguide.com/wellness/smartwatches/i-test-garmins-for-a-living-and-this-usd5-watch-face-is-a-gamechanger);
  [Tom's Guide, most popular free face](https://www.tomsguide.com/wellness/smartwatches/this-is-the-most-popular-free-garmin-watch-face-heres-4-things-i-like-and-3-i-dislike);
  [Tom's Guide, one face I always install](https://www.tomsguide.com/wellness/fitness-trackers/i-review-garmin-watches-for-a-living-and-this-is-the-watch-face-i-always-install)
- Faces named in that coverage (snippet-sourced, article bodies not fetched):
  GLANCE (free, 4.9 from ~53K reviews), Rondo ($4.99), Iron Grit, Portal Hybrid —
  [Tom's Guide search summary](https://www.tomsguide.com/wellness/smartwatches/i-review-garmin-for-a-living-and-these-are-my-5-favorite-watch-faces)
- the5krunner covers Connect IQ at the ecosystem level with an annual-style Top
  100 — [the5krunner, 2026-01-15](https://the5krunner.com/2026/01/15/top-100-garmin-connect-iq-apps/)
- Wareable maintains both a faces roundup and a broader Connect IQ apps roundup —
  [Wareable, faces](https://www.wareable.com/features/best-garmin-watch-faces-to-download-7227);
  [Wareable, apps](https://www.wareable.com/garmin/garmin-connect-iq-guide-best-apps-122)
- Notebookcheck covers Garmin watch-face news events (Pokémon collab; watch-face
  rollout criticism) — [Notebookcheck, Pokémon](https://www.notebookcheck.net/Garmin-unveils-surprising-Pokemon-watch-faces-free-for-smartwatches-including-Fenix-8-and-Forerunner-970.1249875.0.html);
  [Notebookcheck, rollout criticism](https://www.notebookcheck.net/Garmin-attracts-criticism-from-fans-after-limited-watch-face-rollout.1251279.0.html)

### Inferences
- The press route that visibly works is earned, not paid: outlets pick faces that
  are already store-popular or newsworthy (a brand collab, a controversy). That
  makes press a second-order amplifier of store rank, not a way to bootstrap it.
- The "most popular free face" framing used by Tom's Guide means store rank is
  itself the pitch hook — the story is written because the install bucket is
  large, which is circular for a new entrant.

### Gaps
- **DC Rainmaker**: I found no evidence in this research that DC Rainmaker covers
  individual watch faces. Unverified either way.
- **Gadgets & Wearables**: no sources surfaced.
- **No evidence of any paid ad channel, sponsored post, or affiliate programme**
  for Connect IQ faces. Absent, not disproven.
- No named YouTube reviewer specialising in Connect IQ watch faces was found.

## Bundles, catalogue breadth, seasonal releases, device-launch timing

### Takeaway
Catalogue breadth is demonstrably used as an acquisition strategy — both
legitimately (product ladders, 13–20-face catalogues) and abusively (mass
uploads, multiple accounts) — but I found **no source on seasonal release or
device-launch timing** as a tactic.

### Cited Findings
- Mass-upload breadth is an observed store behaviour: developers uploading 10+
  faces weekly, multiple publisher accounts, and one case of 782 bundled watch
  faces — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669) (**historical**, ~2023)
- A proposal in that thread argued ranking should account for device-platform
  breadth, so that faces supporting many devices do not compete on equal footing
  with niche products at equal download counts (developer "myaro") — [Garmin Forums](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/351765/the-connect-iq-store-is-getting-worse-by-the-day-by-a-few-developers-who-dump-a-shitload-of-watch-faces/1707669) (**historical**; a proposal, not implemented policy)
- Garmin instructs developers to declare all supported products in the manifest
  at export time, making device breadth an explicit publishing decision —
  [Garmin Developers, Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/)
- Legitimate breadth: MobileDriveway ships at least seven related faces
  (Glance, Glance Pro, Glance Ultra, HANDY IQ, EASY+, EASY Round, BIG EASY IQ) —
  [Garmin Forums showcase](https://forums.garmin.com/developer/connect-iq/f/showcase/279043/watchface-glance);
  Tomas Slavicek ships ~17 named faces across free and paid tiers —
  [myday24.com](https://www.myday24.com/blog/best-garmin-watch-faces/)
- Update cadence is used as a differentiator in coverage: Rondo Analog is
  described as "updated almost monthly", while Crystal (1M+ installs) and
  Infocal (100,000) are noted as last updated 2018 and 2019 respectively
  (snippet-sourced) — [myday24.com](https://www.myday24.com/blog/best-garmin-watch-faces/)
- Garmin's own high-profile face releases cluster around brand events and
  collaborations (Disney/Marvel/Lucasfilm, Porsche, TaylorMade in Aug 2024;
  Pokémon Sleep more recently) — [Garmin newsroom, 2024-08-06](https://www.garmin.com/en-US/newsroom/press-release/wearables-health/garmin-enables-premium-app-purchases-in-the-connect-iq-store-and-unveils-fun-new-watch-faces-and-apps/) (**historical**);
  [Tom's Guide, Pokémon](https://www.tomsguide.com/wellness/smartwatches/pokemon-sleep-watch-faces-are-now-available-for-free-on-your-garmin-its-my-dream-collab)
- Device support matters to coverage: Notebookcheck's Pokémon piece foregrounds
  which devices are included (Fenix 8, Forerunner 970) —
  [Notebookcheck](https://www.notebookcheck.net/Garmin-unveils-surprising-Pokemon-watch-faces-free-for-smartwatches-including-Fenix-8-and-Forerunner-970.1249875.0.html)

### Inferences
- Device breadth is the clearest lever an indie developer controls: every
  supported device is an additional store-search surface and an additional
  "compatible" filter match, and the store makes breadth a manifest-time choice.
- Mass-upload spam competes for exactly the "Hot & Fresh" window a legitimate new
  face needs, which is why that window is unreliable as a launch plan.
- Stale top-ranked incumbents (Crystal 2018, Infocal 2019) suggest rank is sticky
  and not decayed by inactivity — which is bad for new entrants but means a face
  that reaches rank keeps it cheaply.

### Gaps
- **No source found on seasonal (holiday/New Year) release timing** for Connect
  IQ faces, nor on whether a release timed to a device launch (e.g. a new Fenix
  or Forerunner) measurably boosts installs. This is an open question.
- No source quantifying whether a broad-device face actually outranks a
  narrow one, only the developer proposal that it should be handicapped.

## Garmin's own promotional surfaces and how to get featured

### Takeaway
Garmin runs a "Hot & Fresh" browse surface, a developer award, a developer
newsletter/"Stay Informed" channel and brand-partner face launches, but
**Garmin publishes no documented process for getting an app featured**, and I
found no 2025-26 primary source on how selection happens.

### Cited Findings
- "Hot & Fresh Apps" exists as a Garmin-curated/automatic store surface —
  [apps.garmin.com/apps/hotFresh](https://apps.garmin.com/apps/hotFresh)
- Garmin runs a Connect IQ Developer Award: GLANCE "won THE BEST WATCH FACE APP
  OF 2022 award by Garmin" — [mobiledriveway.com](https://www.mobiledriveway.com/glance.html) (**historical**, 2022); corroborated in a 2026 roundup which calls it the "Connect IQ Developer Award for best new face 2022" — [myday24.com](https://www.myday24.com/blog/best-garmin-watch-faces/)
- Garmin runs a "Stay Informed" developer channel that notifies members about new
  SDK versions and features and provides "tips and tricks from the experts" —
  [Garmin Developers, Stay Informed](https://developer.garmin.com/connect-iq/stay-informed/)
- Garmin posts platform news in a forum News & Announcements blog —
  [Garmin Forums](https://forums.garmin.com/developer/connect-iq/b/news-announcements)
- Program positioning: apps "will be exposed to millions of customers who rely on
  Garmin purpose-driven devices"; the program is framed as rewarding developers
  for innovative designs — [Garmin Developers, Connect IQ](https://developer.garmin.com/connect-iq/)
- Garmin enabled premium (paid) app purchases in the Connect IQ Store via Garmin
  Pay on 2024-08-06, with products starting at $4.99, stating "Enabling premium
  apps allows third-party developers to be rewarded for their hard work" —
  [Garmin newsroom](https://www.garmin.com/en-US/newsroom/press-release/wearables-health/garmin-enables-premium-app-purchases-in-the-connect-iq-store-and-unveils-fun-new-watch-faces-and-apps/) (**historical**)
- That launch was headlined by brand partners (Disney/Grogu, Tony Stark, Mickey,
  Minnie; Porsche ×3; TaylorMade; GoPro; space-themed faces Moonwalker, Ad Astra,
  All-Day Astronaut) — i.e. Garmin's featuring slots went to named brands —
  [Garmin newsroom](https://www.garmin.com/en-US/newsroom/press-release/wearables-health/garmin-enables-premium-app-purchases-in-the-connect-iq-store-and-unveils-fun-new-watch-faces-and-apps/) (**historical**)
- Garmin documents app-sales/monetization mechanics separately —
  [Garmin Developers, App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Garmin promotes its own first-party face-customisation product, Face It, which
  competes for the same user intent — [Garmin blog](https://www.garmin.com/en-US/blog/general/announcement-face-custom-watch-face-app-connect-iq-devices/) (**historical**, announcement-era)

### Inferences
- Garmin's marquee promotional slots in the last documented cycle went to
  licensed IP and large brands, not indie developers; the realistic Garmin-side
  route for an indie is the Developer Award and the automatic Hot & Fresh
  surface, neither of which has a published application process.
- Joining the developer mailing list and being visible/helpful on the CIQ forum
  is the only observable way to be known to the (self-described small) Connect IQ
  team — which matches the award-winning developer's own behaviour (a
  long-running public showcase thread).

### Gaps
- **No documented "get featured" process.** Garmin publishes no editorial
  submission path, nomination form, or featuring criteria that I could find.
- I could not verify whether the Connect IQ Developer Awards still run in
  2025-26; the only award evidence is from 2022.
- Whether "Hot & Fresh" is algorithmic or curated is unconfirmed.
- Whether a consumer-facing Connect IQ newsletter exists (as opposed to the
  developer-facing "Stay Informed") is unconfirmed.
