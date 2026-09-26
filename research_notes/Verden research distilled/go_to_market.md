# Go-to-market for HeroSet and HeroFace on the Connect IQ store: distilled, graded, re-verified (2026-09-25)

**Scope and method.** Re-read in full: `reports/Selling HeroSet and HeroFace.md` (the report) and its five notes in `research_notes/Selling HeroSet and HeroFace/` (`listing_and_organic.md` = LO, `free_vs_paid_funnel.md` = FP, `indie_case_studies.md` = IC, `fitness_app_niche.md` = FN, `micro_budget_ads.md` = MA). Grounded against `HeroSet/docs/go-to-market.md`, `HeroFace/docs/go-to-market.md`, both `listing/README.md`, root `README.md`, HeroSet ADR-039. Re-verified on 2026-09-25: the live store API for both apps, a search-rank basket, top-120 free/paid counts, the Strength Training shelf, and Garmin developer docs and forum announcements (fetched, not from memory). No repo file was modified.

**Grades.** **V** verified: I re-checked it today against a primary source (Garmin doc or live store API). **V-local** verified in the local notes to a primary source, not re-checked by me. **P** plausible: inference or one secondary source. **U** unverified: no usable source. **S** stale or contradicted: a re-check disagrees.

**Snapshot of "now" (store API, 2026-09-25).**

| | HeroSet | HeroFace |
|---|---|---|
| Live version | 1.1.1 (released 2026-09-24 15:32 UTC) | 1.0.1 (released 2026-09-24 15:41 UTC; the GTM doc still says "not live yet", so it is stale on that point) |
| First approval | 2026-09-21 09:46 UTC | 2026-09-22 |
| Download bucket / reviews | bucket 1 (was 0 on 09-22; probably the owner's own install or the Venu 4 buyer, so exclude it from the day-30 delta) / 0 | 0 / 0 |
| `categoryId` | **219 Health & Fitness** (not on the 101-app Strength Training shelf) | 168 (listing README says Digital; id not mapped by me) |
| Title | "HeroSet - Bodyweight Rep Counter" (32/50) | "HeroFace" (8/50) |
| Live description | 1,227 chars (old pre-review text; the reviewed 1,345-char block is not pasted) | **166 chars** (the reviewed 1,822-char block is not pasted) |
| Locales | 1 (`en`), 15 ship in the app | 1 |
| `hasTrialMode` | false | false |

Search-rank basket today, `/apps/keywords`, `mostRelevant`: HeroSet "rep counter" **#3 of 982** (#2 of 342 with `watch-app`), "bodyweight" #3/966, "reps" #14/515, "sit-ups" #20/735, "push-ups" #31/998, "squat" #47/572, "pushup" **not in the first 210 of 228**. HeroFace: "heroface" #1, "streak" #59/990, "watch face", "fenix 8", "51mm" and "daily goals" all beyond row 180-300. The API rank data matches the report, so the rank-basket method works and the listings are unchanged.

---

## Q1. What are the strongest, best-evidenced findings?

### Takeaway
The best-evidenced facts are Garmin's own money rules, the store search mechanics, the "zero at day 3 is normal, traction takes 6-24 months" baseline, and the accuracy-is-the-category's-open-wound finding. Everything about conversion, revenue and ad ROI is **weak or absent**: no indie has published revenue, and every conversion figure is a ratio of quantized buckets.

### Cited Findings

**A. Money and policy (Garmin primary sources)**

| Finding | Provenance | Grade |
|---|---|---|
| Garmin takes **15% of the tax-exclusive price point**; card fees are Garmin's; digital service taxes and FX conversion are withheld from payouts; payouts monthly on the 1st; **$10 USD minimum balance**; funds captured only after the **48-hour return window**; last 5 days of a month may roll over | [App Sales](https://developer.garmin.com/connect-iq/articles/monetization/App_Sales.html), fetched 2026-09-25 | **V** |
| Program fee is **annual, non-refundable, $100**. Merchant countries are limited (US, CA, AU, SG, most EU, UK, CH, NO...). Termination immediately demonetizes all your paid apps and you repay the fee to return | [Merchant Onboarding](https://developer.garmin.com/connect-iq/articles/monetization/Merchant_Onboarding.html), [Account Management](https://developer.garmin.com/connect-iq/articles/monetization/Account_Management.html), fetched today | **V** |
| **Paid apps are offered only on an allow-list of products** (API 6.0, 5.2, 5.1, 5.0 and a 3.4 set) and **only buyers in listed countries can purchase**. "This list is subject to change." A free listing has no such restriction. The list omits fēnix 5 family, FR245/645/745/935/945, vívoactive 3/4, Venu 1, Descent MK1, fēnix 6S (non-Pro), Enduro 1 and more | Same App Sales page, today | **V** (new, not in the local research) |
| Setting a price on an already-approved app removes it from the store for re-review, and existing users must then buy it. **Garmin is silent on paid to free.** | App Sales, today | **V** (doc) / paid to free = **U** |
| Web purchasing and installs ended **2025-11-20**. The Connect IQ Store mobile app is the "sole source of purchasing, installing or managing"; apps.garmin.com is a promo hub whose links deep-link into the app; developer uploads moved to apps-developer.garmin.com | [Garmin forum announcement by AlphaMonkeyC](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/changes-to-the-connect-iq-store), today | **V** |
| Trials: "App Trials" exist since API 2.3.0, **not for watch faces**, and work through a **developer-run HTTPS unlock URL with a callback**, i.e. your own unlock backend. Nothing on combining it with Garmin-monetized purchase | [Trial Apps](https://developer.garmin.com/connect-iq/articles/core-topics/Trial_Apps.html), today | **V** |
| Dashboard: Merchant Account tab has sales reports (CSV by request) and tax forms; per-device install stats exist. No referrer or funnel data | Garmin Account Management doc; forum ([sales dashboard thread](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/433333/connect-iq-sales-dashboard), [stats thread](https://forums.garmin.com/developer/connect-iq/f/discussion/381824/detailed-statistics-for-app-download-and-usage/1867902)) via search summary | V (sales) / P (install stats detail) |

**Break-even correction.** The report's "~48 sales/year to clear the $100 fee" and "about five sales a month to reach $10" use 2,49 € (which includes VAT) x 0.85. Garmin's split is on the tax-exclusive price point, so it is **$2.00 x 0.85 = $1.70 before FX/DST**: **~59 sales/year** and **~6 sales for a first $10 payout**. Grade **S** for the 48; corrected figure is derived from **V** rules. Two apps at 2,49 € net ≈ -$100 in year one on any modal path (IC).

**B. Store discovery mechanics**

| Finding | Provenance | Grade |
|---|---|---|
| Search is a separate endpoint, `/apps/keywords`, relevance-scored token match over title and description, **install-blind** on `mostRelevant`; title outweighs description by ~2 orders of magnitude; hyphen/space and diacritics fold; **plurals are not stemmed, typos not corrected**; `totalCount` caps at 1000; `pageSize` max 30; depth works past row 268 | LO (store bundle + API), 2026-09-22; my basket re-run today matches (#3 "rep counter" at 0-1 installs; "pushup" vs "push-ups" pools differ) | **V** for the web endpoint |
| Browse/rank lists are capped at exactly 120 rows (4 x 30) | LO, FN, FP; my sweeps today | **V** |
| `mostPopular` is **not lifetime installs**: #1 face Goals is bucket 100,000, #2 Face It is 5,000,000; Push-Up Hero (10,000) is #1 on Strength Training, F3b (100,000+) is last. Formula undocumented, recency/velocity-like | FP, IC, FN; Push-Up Hero still #1 today | **V** (ordering) / **U** (formula) |
| "Hot & Fresh" sorts by latest release date x scale; every approved version re-enters it, but a 100-download app lands on pages 2-3 | LO | V-local / P (mechanism) |
| Highest-rated is a separate sort, so a few 5★ reviews chart a new app in Strength Training (bikintulis apps at #5-#18 on 5.0/1-3 reviews) | FN | V-local / P |
| Top listings: 5 screenshots, cumulative changelog in What's New (up to 4,000), 1,000-3,900 char description, 8-28 locales; locale count is the clearest scale correlate | LO table of 12 faces + 7 apps | V-local / P (correlation only) |
| Forum: promotion allowed **only** in Connect IQ Showcase + signature links | LO (quotes the Forum Rules wiki) | V-local |

**C. Baselines and case studies**

| Finding | Provenance | Grade |
|---|---|---|
| 0 downloads at day 3 is normal: of new faces 5-14 days old, 30/52 at bucket 1, 20 at 10, 2 at 100 (feed skews to last week, so it is a snapshot, not a maturing cohort) | IC (2026-09-22) | V-local |
| 99 of the top-120 faces are >1 year old; 3 are <90 days, 2 of those from big publishers | IC | V-local |
| Independent paid trajectories: Octo ≈7 months to bucket 1,000; Rondo ≈17 months to 10,000; Quipu 70 days to 10,000 (unexplained outlier) | IC | V-local / traction timeline "6-24 months" = P (medium-high in the note) |
| No published indie CIQ revenue anywhere; only "a beer or so a month" (~8 years old); forum rules push paid-version talk out of the forums; sales-dashboard thread has no figures | IC; I confirmed the dashboard thread has none | **V** (negative finding) |
| Nobody in the top 120 runs two paid listings with no free counterpart; every publisher has a free flagship or free-only + Ko-fi | IC, FP | V-local (n = a handful of publishers) |
| Face to *separate app* attach: 0.2-10% even when the app is free (Universal App off GLANCE; HYDRATE+ off BIG EASY) | FP (bucket ratios) | **P** (ranges, not rates) |
| Same-face free to paid ladders: 0.2-5% pessimistic to 10-100% optimistic (TitanicTurtle, GreenBlack, MobileDriveway) | FP | **P** |
| Free faces out-reach paid faces ~10x median (bucket 100k vs 10k) but **do not rank better**: 7 of ranks 1-10 paid; #1 face is paid 2,49 € | FP; **34/120 paid faces reproduced today** | **V** |
| Payout failure: one developer could not withdraw for ~7 months (USD to GBP account) | IC, forum thread | V-local (n = 1 anecdote) |

**D. Fitness niche**

| Finding | Provenance | Grade |
|---|---|---|
| Push-Up Hero (Strafe) is the incumbent: bucket 10,000, **4.3★ / 905 reviews today (898 on 09-22)**, 2,49 €, actively maintained; 63 one-star text reviews, nearly all accuracy ("counts 1/10th", 25 for 10, 36 from arm swing); ≥12 say calibration didn't help | FN via reviews API | **V-local**; today's count moved 898 to 905 |
| Strafe sells one exercise per app (5 apps x 2,49 €); no one sells one multi-exercise app that counts well | FN | V-local / P (position "unoccupied" only as of 09-22; bikintulis "Bodyweight Workout Pro" is a shovelware occupant) |
| Strength Training shelf: 101 apps today (100 on 09-22), **27 paid / 74 free**, top-20 has 7 paid, i.e. **13 of 20 (65%) free**; ~15+ new mostly free entrants in 5 weeks; F3b Strength Training+ (free, 100,000+) is a dormant threat. **FN's own pressure signal ("free share of the category top 20 above ~40% = real pressure on 2,49 €") has already fired** (65% today; the top 4 are the paid Strafe Hero apps, then free/zero-install entrants at #5-#8) | Re-swept today (URLs in the appendix) | **V** |
| Native Garmin rep counting: free, on current watches; Garmin's own manual admits it counts only one move per set, needs ≥4 reps, arm-return heuristic; a peer-reviewed study of 4 older wrist Garmins (Instinct, fēnix 6 Pro, vívoactive 3) measured MAPE 3.0-67.5% | FN (manual + IJES abstracts vol 14 art 143); **study year unconfirmed (2021-23), current-hardware error unknown** | manual = V-local; study = **P** for today's watches |
| Watch apps are "a paid market: 103 of top-120 paid" | FN, report | **S: does not reproduce.** Today `appType=watch-app` top 120: **54 paid / 66 free**, modal price 2,49 € = 27 of 54. Per-app detail sweep of all 120 gives the same 54. Price *convention* (2,49 € modal) holds; "86% paid" does not. |

### Inferences
- The defensible core of the whole research is: **(1)** search is install-blind so listing text is the only lever a zero-install newcomer controls, **(2)** every lever costs nothing, **(3)** cold-start revenue is likely below the $100/yr fee for 12+ months, **(4)** HeroSet sells only if it visibly counts better than free native + Push-Up Hero.
- The "paid share of watch apps" claim is wrong by 2x; the pricing recommendation survives (2,49 € is still modal), but "paid is the norm here, not a handicap" loses half its support. On the actual target shelf 73% is free (V).

### Gaps
- No conversion, impression or referrer data exists; buckets cannot be converted to revenue. The definition of a "download" is undocumented.
- Whether search rank can be gamed by tokens in the **mobile app** (see Q3) is unverified.

---

## Q2. Which recommendations are already done, open, or in conflict with product decisions?

### Takeaway
The docs already handled the *product* side of the research (accurate claims, privacy promise, device wave, release cadence, HeroFace link mechanics, no-trial ADR) but **almost none of the listing fixes are live**. Two of the research's core steps (accuracy proof, on-site measurement) **conflict with existing decisions** and need an owner call.

### Cited Findings: recommendation vs state

| Research recommendation | State today | Status |
|---|---|---|
| HeroSet category 219 to **Strength Training 277** ("highest-return action") | `HeroSet/listing/README.md` says Category = Strength Training. **Live API still 219 on 2026-09-25 after 1.1.1**; app is not on the Strength Training shelf. Category is either not editable per version or was not saved. | **OPEN, README and live disagree** |
| Extend HeroSet title with exercise nouns | Title unchanged, 32/50 | OPEN |
| Add singular and plural surface forms to HeroSet copy | Description has "push-ups", "sit-ups", "squats" only; no "push-up", "pushups", "situps", "pushup". "pushup" search: not in top 210 | OPEN |
| HeroSet cumulative What's New (was 166 chars) | Live What's New now 583 chars (1.1.1 block); not cumulative | PARTIAL |
| HeroSet reviewed description pasted | GTM A1 still unchecked; live still old (1,227 chars) | OPEN (already tracked) |
| HeroFace description 1,500-3,900 chars, device tokens in title, link to HeroSet | Draft is 1,822 chars (good), **not pasted** (live 166). Draft has **no device tokens, title stays "HeroFace", and no `apps.garmin.com/apps/<id>` link** to HeroSet | OPEN and the draft itself omits two of the three |
| HeroFace What's New filled | Live 376 chars | DONE |
| Localise both listings (`appLocalizations` x 15) | Not started; HeroFace has `listing/descriptions.md` (opening only, old text) | OPEN |
| Showcase thread per app, signature link | Not mentioned in either GTM doc | OPEN |
| Real version bump with each listing change (Hot & Fresh) | 1.1.1 and 1.0.1 both shipped 2026-09-24; consistent | DONE by cadence |
| Stage 0: findable in on-device search | Not listed in either "Next session" list | OPEN |
| Stage 0: USD-capable payout account | Not mentioned; merchant approved 2026-09-18 | **U** (ask owner) |
| Stage 0: email Garmin about paid to free; device gap | A4 asks Garmin about the 14/80 and 48/117 missing devices, not paid to free | PARTIAL |
| Start a daily poll of appIds + ~20-term rank basket | Not mentioned | OPEN (30 min) |
| Reply to every review, ask for reviews | No review yet; Venu 4 buyer email (A3) is the first buyer contact | OPEN, tiny |
| Sales report monthly (Merchant tab) | Not mentioned | OPEN |
| Accuracy proof on wrist before selling (stage 1b) | **ADR-042 waived gate 2**; only one 35-rep set (-4) of current data; docs list known risks (push-ups over-count 15-25 reps, squats "3-for-10" twice, fast squats). Marketing has not stopped | **CONFLICT** |
| Publish accuracy method/results on verden.watch and in listing | "Never promise ... perfect or measured counting accuracy" (`release-contract.md`); landing copy was already stripped of "gets closer with every set" | **CONFLICT** |
| Trial for HeroSet | **ADR-039: no trial**, because `iq:trialMode` needs a developer-run HTTPS unlock backend (my fetch of Garmin's Trial Apps page confirms exactly that) | **Report's "unconfirmed inference" resolved: trial exists for apps but only via your own unlock server. ADR-039 stands.** |
| UTM links, tracked outbound click, landing to store handoff >=10% gate | `site` promises **zero client JS, no analytics, host analytics off, privacy page says none**. UTMs alone measure nothing | **CONFLICT** |
| Keep both paid; no free face yet | Consistent with GTM (no free twin planned). Hero/complication design assumes paid | ALIGNED |
| Connect activity sync (parity gap, #2 complaint cluster) | HeroSet 1.2.0 (ADR-043), already the next submission | ALIGNED |
| Monthly threat watch (Garmin firmware, Strafe combined app, F3b, Push Up Master) | Not in docs | OPEN, 15 min/month |
| Don't demonetize by cancelling merchant account | Not addressed but nothing contradicts | ALIGNED |
| HeroFace positioning: "HeroSet gets one line" | Research wants the HeroSet link at description **line 1** (as top ladders do). Draft mentions HeroSet in one paragraph | Mild tension; see Inferences |

### Inferences
- **Category conflict.** The live category is the truth. README's "Strength Training" row is either an unexecuted plan or unsaved. Check the dashboard; if it is not editable in place, put it in the next real upload. The 101-app shelf and the highest-rated sort (a few 5★ reviews chart) are the whole point.
- **Accuracy vs marketing.** The research's stop-rule ("HeroSet doesn't beat native, stop all marketing") is currently unevaluated, because gate 2 was waived. This is the biggest single risk in the plan; the listing text promises only "counting depends on how you wear the watch". A measured comparison can go on the site only if `release-contract.md` is amended, or as a method-only post without accuracy claims. Owner call.
- **Measurement vs privacy.** Options that keep the promise: (a) attribute by ad-platform click counts and store-dashboard install timing only; (b) a redirect per channel with no analytics is countable only in the platform's own dashboard; (c) amend the privacy page for privacy-friendly server-side stats. The "landing to store handoff" gate is only available under (c).
- **First-line link.** Whether the store's list card shows the first line is **U**. Big ladders put a sibling link first, but with web purchasing gone the mobile app renders the description and forum posters say its description text cannot even be selected, so whether links are tappable is **U**. Cheap compromise: keep HeroFace line 1 as the pitch, put the HeroSet `apps.garmin.com/apps/54bbf625-...` URL in the "With HeroSet" paragraph and in HeroSet's What's New.

### Gaps
- Whether the dashboard edits category, title or description without a new binary is unknown and the docs do not say.
- The 1.1.1 "Compatible Devices" count (66 of 80) and 69 of 117 for HeroFace are only partly explained by Garmin's allow-list (see Q3).

---

## Q3. Which claims look weak, stale or wrong (spot-checks)

### Takeaway
Five local claims were wrong, stale or missing something material: the 103/120 paid apps figure, the 48-sales break-even, the "search is winnable" thesis (measured on a web endpoint after Garmin removed web search and purchasing), the unresolved device-gap question (partly answered by an allow-list), and the trial "inference". Ad-channel numbers remain secondary-source only.

### Cited Findings

| # | Claim | Check | Result |
|---|---|---|---|
| 1 | 103 of the top-120 watch apps are paid; 58 at 2,49 € (FN, report) | Re-swept top 120 `appType=watch-app`, then all 120 per-app details, 2026-09-25 | **S**: 54 paid / 66 free; 27 at 2,49 €. The report already flagged this figure as method-dependent |
| 2 | 51/120 faces paid (older report, repeated in FN) | Re-swept | **S**: 34/120 (matches report's correction) |
| 3 | Break-even 48 sales/yr and ~5 sales to $10 | Garmin doc: split on tax-exclusive price point | **S**: ~59 and ~6 at $1.70 net (before FX/DST). Payouts come separately from Garmin International (US/CA) and Garmin Europe (rest), so the $10 minimum may apply **per entity** (P), making the first payout later than 6 sales for a mostly-EU buyer base |
| 4 | "Off-rank listings reachable only by exact name" | Search API re-run today | **Refuted**, as the report says (rank basket) |
| 5 | Search-rank thesis: "the one surface a newcomer can win" | Web store search was **removed** in Nov 2025 | **Conflicting evidence, unresolved.** For: one forum poster (trudelta, ~9 months ago, via a fetch summary) says "they removed the ability to search apps"; a search-engine summary repeats it. Against: LO found a live `apps.garmin.com/en-US/search?keywords=` page and its `_app` bundle default `MOST_RELEVANT` on 2026-09-22, and the `/apps/keywords` API still answers today. Purchase/install is mobile-app-only (Garmin announcement, **V**). My attempt to re-fetch the search page and bundle failed on tooling errors, so re-check with `curl -sI` of that URL. | **Endpoint V, applicability to the mobile app U** (same backend likely, P). The mobile search is scoped to the selected watch (a poster describes disabling Bluetooth to see all-device results), so device filtering applies. Most decision-relevant unverified item. |
| 6 | Missing devices (14/80 HeroSet, 48/117 HeroFace) are an unexplained "store-side policy" (GTM, A4) | Garmin's paid-app product allow-list | **Largely explained, not fully**: HeroFace's missing families (fēnix 5, FR245/645/745/935/945, vívoactive 3/4, Venu 1, Descent MK1, D2 Charlie/Delta, Legacy) and HeroSet's fēnix 6S non-Pro, Enduro 1, FR945 LTE are not on the list. But Descent MK2/MK2S, MARQ Gen 1 and D2 Air X10 **are** on the list yet missing, so ask Garmin about those only. (By-name comparison from the GTM lists; not machine-diffed.) |
| 7 | "Watch apps can use trial mode" (report: inference) | Garmin Trial Apps doc | **Resolved**: yes for apps, but via your own unlock server; not documented for Garmin-monetized purchases. Report wording "a HeroSet trial is the app-side funnel" is not achievable cheaply |
| 8 | Web purchasing ended Nov 2025 | Garmin announcement 2025-11-20 | **V** |
| 9 | Reddit Ads min $5/day, $25 lifetime | Search today returned three different lifetime minima ($20, $25, $50) across agency blogs; no Reddit doc reachable | **U**; confirm in ads.reddit.com |
| 10 | Reddit CPC $0.40-1.50, 50-185 clicks for $75 | Agency blogs contradict each other ($0.20-0.60 vs $0.75-2.00) | **P/U**; the same blogs note $5/day gives ~2-7 clicks/day and "you will learn almost nothing" |
| 11 | TikTok floor >$50/day, Demand Gen $5/day | Local, primary help center for TikTok; MediaPost for Google | V-local |
| 12 | Native accuracy 67.5% MAPE | Older watches, year unconfirmed; no current-hardware test found | **P**; do not quote as "today's watches" |
| 13 | Payout GBP/USD failure risk | Single forum thread | P; the precaution (USD-capable account) is cheap anyway |
| 14 | "Free flip cheapest at 0 installs" (FP inference) | Garmin silent on paid to free, and HeroSet now has ≥1 install bucket; HeroFace 0 | Timing argument still valid for HeroFace only; needs Garmin's answer first |
| 15 | Forum promotion rule, Reddit rules, brand rules, dashboard details | Not re-fetched; Reddit blocked in every prior pass | V-local / U |

### Inferences
- **Free HeroFace has a reach argument the research missed.** A paid listing is limited to the allow-listed products, while a free listing is not. HeroFace supports 117 products and is shown on 69. A free twin (same face, no HeroSet dependency) would reach the 48 excluded products and all countries, at the cost of being a separate listing that restarts reviews. Grade **P** (inference from the doc; the mapping of excluded products to reach is unmeasured). This does not change "keep paid for 30 days", but it changes the *shape* of the later free-twin question from "funnel" to "coverage".
- The "buyer-facing surface" is now the mobile app, so screenshot quality and the first lines of description matter more than web-era research assumed, and off-store links (site to `apps.garmin.com/apps/<id>`) work only when the phone has the app installed. The report does list a phone tap test (stage 0), good.

### Gaps
- Not checked: Meta "Garmin" interest, Google Keyword Planner volume for "garmin rep counter", Garmin brand rules for ad copy, r/Garmin rules, exact `hotFresh` weights, whether text-only listing edits trigger re-review or reset the release date, the `fullInstalls` endpoint shape.
- Not re-verified: IJES study year, TechRadar quote (paywalled), Forum Rules wiki text.
- **Garmin App Review Guidelines were not read** (my fetch failed on a tooling error; HeroFace's own checklist still has "Read Garmin's App Review Guidelines" unticked). Action #1 stuffs device names (fēnix, Forerunner, Venu) and exercise nouns into titles, and the HeroFace GTM doc says a keyword the build does not deliver reads as a false claim in review. Whether titles may carry Garmin device names or trademarks is **U**. Top-listing titles already do (LO: "Fenix 8 V3 PRO - GB", "Uncharted PRO - fēnix 9"), which is P evidence that it passes review. Read the guidelines before submitting; a rejection costs ~72 h.

---

## Q4. Prioritized 30-day playbook (solo studio, 2026-09-25 to 2026-10-25)

### Takeaway
Fix the listings first (free, hours of work), prove or disprove the accuracy claim on the wrist in parallel, do the zero-cost prechecks, then seed organic channels and read the ΔHeroSet ÷ ΔHeroFace ratio. **No ads this month.** Realistic outcome: bucket 1-10 installs on the correct shelf, first reviews, a decision on the year-one merchant fee at month 12 (annual fee, so renewal ≈ September 2027, date to be confirmed from the dashboard).

### Top-5 ordered actions

| # | Action | Effort | Why now / evidence | Stop or continue |
|---|---|---|---|---|
| **1** | **Listing repair, one bundled submission per app** (with a real version bump: HeroSet 1.1.2 or fold into 1.2.0 only if that ships within 2 weeks; HeroFace 1.0.2). **HeroSet:** check the dashboard for Category (219 to 277 Strength Training; if not editable, do it in the upload form); paste the reviewed description; retitle to include exercise nouns, e.g. `HeroSet - Rep Counter: Push-Up Sit-Up Squat` (43) or, keeping "bodyweight", `HeroSet Bodyweight Rep Counter: Push-Up, Squat` (46); add singular and plural forms (`push-up`, `pushups`, `sit-up`, `situps`) in the description; cumulative What's New with support route and review ask. **HeroFace:** paste the 1,822-char block, add device tokens to the title (`HeroFace - fēnix Forerunner Venu 51mm Watch Face`, 48, only for devices it truly fits; check the compatibility doc), put the HeroSet listing URL in the "With HeroSet" paragraph, fill What's New. Localise both after (separate submission) | 3-5 h + 44-72 h review each (**first read Garmin's App Review Guidelines on titles/trademarks; unread, see Q3 Gaps; a rejection costs ~72 h**) | Free levers with the best evidence (LO, FN). Day 0 of the exposure test = approval date of this submission | Rank basket 24-48 h after approval: HeroSet top 10 for `pushup`, `squat`, `sit-ups`, `rep counter`; HeroFace ranks for device tokens. If ranks don't move, the index behaves differently from the notes; retest by hand before editing further |
| **2** | **Accuracy proof on the FR965** (waived gate 2, now the plan's load-bearing claim). Decide the bar first: HeroSet median error per 10-rep set must beat the native Strength profile on the same sets; 3 x 10 reps per exercise at slow/medium/fast, one 30+ rep set, hand-counted; ideally Push-Up Hero as third arm. Log in `validation-log.md`. **Owner decision:** whether `release-contract.md` may state measured results (publish method + numbers on verden.watch) | 3-4 h of wear-and-test, spread over a week | The whole differentiation rests on it (FN Q3, Q5). Both incumbents get 1-star reviews for exactly this | **If HeroSet does not beat native, stop marketing and fix the detector (a 1.1.x item).** If it does, add a one-line, contract-compliant claim and a screenshot/video to the listing |
| **3** | **Stage 0 prechecks and instrumentation.** (a) Find both apps by keyword in the **Connect IQ Store mobile app** on the FR965-paired phone and on a second device model (the mobile search is device-scoped). (b) Tap an `apps.garmin.com/apps/<id>` link with the app installed. (c) Email Garmin developer support: paid to free consequences (reviews, rating, downloads), why Descent MK2/MARQ Gen 1/D2 Air X10 are missing although on the allow-list, and category editing. (d) Confirm a USD-capable payout account. (e) Daily poll of both appIds + a fixed ~20-term rank basket (curl in LO appendix); pull the first Merchant sales report. (f) Look at what the developer dashboard install stats show | 2-3 h once, ~10 min/week after | €0; removes the biggest unknowns in Q3 (#5, #6, #14) | If either app is unfindable in the mobile app, fix that before anything else (trader verification, listing fields) |
| **4** | **Organic seeding, no spend.** After #1 approves: one Connect IQ Showcase thread per app; signature link on every helpful technical reply; answer every review and email (the Venu 4 buyer, A3); post the accuracy method as a technical write-up (Showcase or Garmin dev forum where allowed); read r/Garmin, r/bodyweightfitness, r/running sidebars and modmail before any post (base rate: 61% of promotion-adjacent subs ban self-promotion). One small real release mid-window (Hot & Fresh re-entry) | 3-4 h + ~15 min per reply | Showcase audience is developers/enthusiasts: realistic yield is early reviews and bug reports, not volume (LO). First 3-5 reviews buy disproportionate visibility on the highest-rated sort (FN) | Continue if reviews appear; drop any venue whose rules bar it |
| **5** | **Day-30 readout and decision, and defer paid.** Compute ΔHeroSet ÷ ΔHeroFace downloads, review count, HeroSet rank on the Strength Training shelf, the Garmin answers from #3. Then decide: (i) HeroFace at bucket 0-1 = discoverability, not price (keep paid); (ii) HeroSet still 0 on the correct shelf = positioning problem; (iii) HeroFace moves but HeroSet doesn't = funnel doesn't carry, no free face; (iv) both move = compare a free HeroFace twin (coverage argument, Q3 inference). Ads only from month 2 and only if #2 passed and the measurement policy question (Q2) is resolved: one channel, ≤ ~$75, Reddit community targeting (verify minima at signup), stop on 100 sessions/≤$85 or gate failure | 1-2 h | Sequential attribution is the only kind available at these volumes | See gates in the row itself |

### Explicit do-nots this month
- Do not flip either listing to free, build a new free face, rename HeroSet, or cancel the merchant account (demonetizes both apps; refee to return).
- Do not spend on ads before #1 has approved and #2 has a result; a $75 test buys ~2-9 installs at best and cannot tell you the product sells.
- Do not convert buckets to revenue or quote the 103/120 or 48-sales figures.

### Watch monthly (15 min, 22nd)
Garmin firmware release notes for rep-count accuracy (the existential risk); Push-Up Hero rating and 1-star text count (63 baseline; 905 reviews today), version freshness, any Strafe combined app; F3b and Push Up Master (free, 1,000+); free share of the Strength Training top-20 (13 of 20 free today, already past FN's ~40% pressure bar, so track direction, not the threshold); Garmin's allow-list page for product changes.

### Inferences
- Expected day-30 outcome is HIGH-confidence near zero (IC cohort); a good outcome is bucket 10 and 1-3 reviews. Break-even is ~59 sales/yr per merchant year; the realistic year-one result is a small loss, so keep the fee renewal a deliberate decision.
- The plan's value is the listing repair plus the accuracy result; ads and funnel builds are conditional on both.

### Gaps
- No Connect IQ case study proves any external channel (Reddit, YouTube, press) drove installs; none was found.
- Effort estimates are mine, not from the sources; they assume the reviewed copy in the two `listing/README.md` files is used as the base.

---

## Appendix: endpoints and pages used for the 2026-09-25 re-verification

Store API base `https://apps.garmin.com/api/appsLibraryExternalServices/api/asw` (undocumented; described in `listing_and_organic.md`).

- Live app state: `/apps/54bbf625-82af-4715-8af0-f2f16a5d1377?countryCode=US` (HeroSet), `/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116?countryCode=US` (HeroFace). Fields read: `categoryId`, `downloadCount`, `latestExternalVersion`, `releaseDate`, `appLocalizations[].name/description/whatsNew`, `hasTrialMode`.
- Search rank: `/apps/keywords?keywords=<term>&startPageIndex=<0,30,...>&pageSize=30&sortType=mostRelevant[&appType=watch-app]`, paged until the appId appears (capped at row ~300 in my run).
- Top-120 free/paid: `/apps?startPageIndex=<0|30|60|90>&pageSize=30&sortType=mostPopular&countryCode=US&appType=watch-app` (and `appType=WATCHFACE`); paid = non-null `pricing` in the list item, cross-checked with per-app `/apps/<id>?countryCode=US` for all 120 watch apps (54 paid).
- Strength Training shelf: `/apps/categories?categoryNames=STRENGTH_TRAINING&startPageIndex=<0..120>&pageSize=30&countryCode=US&appType=watch-app&sortType=mostPopular` (101 rows, 27 paid, HeroSet absent).
- Push-Up Hero: `/apps/787e795f-2426-4e41-b172-9a197d5f0f68?countryCode=US` (10,000 bucket, 4.3, 905 reviews).
- Garmin docs fetched: `https://developer.garmin.com/connect-iq/articles/monetization/App_Sales.html`, `.../monetization/Merchant_Onboarding.html`, `.../monetization/Account_Management.html`, `https://developer.garmin.com/connect-iq/articles/core-topics/Trial_Apps.html`.
- Garmin announcement: `https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/changes-to-the-connect-iq-store` (2025-11-20). Other forum/secondary: `.../f/connect-iq-web-store/427593/is-the-web-version-of-connect-iq-gone`, `https://the5krunner.com/2025/11/22/garmin-shuts-down-connect-iq-web-store-mobile-app-mandatory/`, `.../f/connect-iq-web-store/433333/connect-iq-sales-dashboard`, Stackmatix/RECHO Reddit-ads blogs (secondary).
- Not reached this run (tooling errors, transient): Garmin App Review Guidelines, the live `apps.garmin.com/en-US/search` page.

## Owner calls needed (three)
1. **Accuracy claims vs `release-contract.md`:** may measured results be published, given gate 2 was waived (ADR-042)?
2. **Measurement vs the no-analytics promise:** keep click-count-only attribution, or amend the privacy page for privacy-friendly stats.
3. **Category 219 still live** on HeroSet although its listing README says Strength Training: check the dashboard, decide whether to fix in place or in the next upload.
