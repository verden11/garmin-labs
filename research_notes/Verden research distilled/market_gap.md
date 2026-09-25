# Garmin Connect IQ watch-face market gap: distilled and re-graded (2026-09-25)

Scope: re-review of the studio's two local note sets plus the report, deduplicated, contradictions resolved, load-bearing claims graded, spot-checked on the web and against the live store API on 2026-09-25.

**Grades used on every claim**
- **[V25]** re-verified by me on 2026-09-25 (live store API pull, rendered Garmin page, or fetched forum/announcements page).
- **[V22]** verified against a Garmin-owned page or the store API on 2026-09-22 in the local notes; not re-rendered by me (today's fetches of developer.garmin.com monetization and trial pages returned JS navigation shells).
- **[P]** plausible: inference, or a secondary/press source.
- **[U]** unverified.
- **[S]** stale or superseded.

**Provenance keys** (reference links at end of file): `R` = [reports/Garmin watch face market gap.md]; `A/*` = `research_notes/Garmin watch face market gap/*` (trends, popular, lowstar, gaps, mkt, plat, verif); `B/*` = `research_notes/Garmin IQ store face gaps/*` (gaps, trends, mkt, popular); `S` = [reports/Selling HeroSet and HeroFace.md] (corrections section); `GTM`/`PLAN` = HeroFace docs.

Overlap between the note sets: `A/popular` and `B/popular`, `A/trends` and `B/trends`, `A/mkt` and `B/mkt` cover the same ground with different methods. **A is API-derived and larger-n; B is press/forum/listing-derived.** Where they conflict, A wins on store data and API level; B adds 2025-26 press color, the clone policy, and the paid-listing search bug. `R` is a summary of A and inherits A's stale parts (see Q3).

---

## Q1. What are the 5-8 strongest, best-evidenced findings about the market?

### Takeaway
The market is a small, top-heavy, mostly-free shelf where the best-evidenced pain is commerce and hardware fit (paywall keys, per-device layout, settings that reset), not rendering; and the platform (no watch-face trials, Garmin IP policy, mobile-only store since Nov 2025) shapes what an indie can do more than taste does.

### Cited Findings
1. **Complaint mix is commerce and fit, not pixels.** 2,544 unique 1★/2★ reviews across the top 30 faces: device support/fit/non-touch 14.8% (376), paywall/trial/unlock key 14.4% (366), settings not saving 8.4% (213), bugs 7.4%, install 7.0%, weather 6.6%, battery 4.5%, missing fields 4.3%, AOD 1.6%. Per-face device-fit rates are flat across six unrelated developers (25-31%), so it is category-wide; paywall concentrates (Black Hawk Elite 47%, Zenith 40%). **[V22]** [A/lowstar]. *Limits stated by the source:* 94% of reviews are against superseded versions, 18.6% non-English (theme % are floors), two faces hit the 250-row cap, median review is 72 characters. *2026-only shares* (n=955) are device support 11.5% and paywall 15.2% vs 14.8%/14.4% all-years [A/lowstar]; quote the 2026 numbers as "current".
2. **Popular set structure (re-pulled today).** The store's `mostPopular` watch-face list pages out at **120 unique faces**; **34 are paid** (12 of the top 30, 16 of the top 60); paid price tiers are €2.49-€5.99 with €5.99 the most common (14 of 34); `hasTrialMode` is **false on 120/120**; **99 of 120 are more than a year old, 3 are under 90 days**. Download buckets: every paid face is at or below the 100k bucket (2 at 100k, 4 at 50k, 26 at 10k, 2 at 1k); free faces hold 500k+ (38 of them; 15 at 1M, one at 5M). **[V25]** [store API pull, 2026-09-25].
3. **Rank is not lifetime installs.** Today #1 Goals is in the 100k bucket and #2 Face It in the 5M bucket; Crystal (1M) sits at #17 below several 10k-50k paid faces; order moved between 09-22 and 09-25 (Rondo 5→4, Black Hawk Elite 8→5, Rad-Lad 4→6). **[V25]** [store API pull]; `S` corrections table agrees and refutes `R`/`A/mkt`. Formula undocumented **[U]**.
4. **Monetization rules.** Garmin keeps 15% of the tax-exclusive price; $100 USD/yr non-refundable merchant fee; sellers need a legal entity in US/CA/AU/SG or listed European countries (incl. UK, CH, NO); price points $2.00-$100.00 in 16 currencies ($2.00 point retails $1.99 US / 2.49 EUR); payouts monthly, $10 minimum, funds captured after the 48-hour return window; re-pricing an approved app pulls it for re-review; DST and FX withheld. **[V22]** [A/verif]. Today: search snippet of the merchant-onboarding page corroborates $100 non-refundable and 15% **[P/V25 partial]** [WebSearch 09-25]; the pages themselves would not render for my fetch tool.
5. **Trials are not a platform feature for watch faces.** Garmin: "The app trials feature is not supported for watch faces." **[V22]** [A/verif]; corroborated by forum discussion "Watch Face trial mode" (developers use self-issued keys) **[P]** [search 09-25]. Consequence: every hybrid (5-day trials, pro keys, KiezelPay, separate trial listings) is hand-rolled and is what generates finding 1's paywall theme.
6. **Distribution changed on 2025-11-20.** The Connect IQ mobile app is the sole route to purchase/install/manage; web listings are view-only and deep-link into the app. Trader verification (2025-02-17) hides paid apps until complete. **[V25]** [Connect IQ announcements feed]; [the5krunner 2025-11-22]. `A/trends` recorded a June-2026 date from a search summary: wrong, discard.
7. **Garmin IP enforcement.** Since May 2025 new faces that copy native Garmin designs are rejected; a Garmin staff member later stated enforcement was tightened (policy "has always" protected Garmin IP), older apps are not removed retroactively, and "similar" is undefined. Garmin sells its own $4.99-$5 "All Stars" ports. Existing clones still rank (GreenBlack Fenix 8 V3/V2 at #9/#12 today). **[V25]** [forum thread 413172]; [B/gaps]; [store API pull].
8. **Hardware/API state.** FR965 = API 5.2 (so no Sleep Score, complication 42 needs 6.0.2); fēnix 9 / 9 Pro, Venu 4, FR570, FR70 = API 6.0; fēnix 9 launched 2026-08-25, SDK 9.2.0 (2026-06-09) added Sleep Score for watch faces. Training Readiness, HRV, sleep stages, Endurance/Hill score, Training Load are **not** complications. **[V25 for API levels/dates]** [rendered compatible-devices page, announcements feed]; **[V22 for the absent-complication list]** [A/verif], [A/trends]. Body Battery and stress are readable via `SensorHistory` from API 3.3.0 **[V22]** [A/plat].

Supporting context (grade lower):
- Paid unlock price band $2-$5 in 2026 press: Rondo $5, Goals ~$2, GreenBlack $5. **[P]** [B/popular].
- Free-hero → paid-sibling ladder: GLANCE free 1M+ vs Glance Pro 50K+ vs Dual/Ultra 10K+ (different listings; not a conversion rate). **[P]** [B/mkt].
- Market: Counterpoint Q2 2026 Garmin 5.6% share, +11% while the market fell 4% (Huawei 22%, Apple 20.1%); Omdia says ~15% for the same quarter by a different definition. **[V25 via search results, secondary reporting]** [Garmin Rumors], [the5krunner]. Do not quote a single "Garmin share".

### Inferences
- Complaint data shows what to avoid, not what people will pay for; no source has conversion, ARPU or revenue [A/popular, B/popular gaps].
- A paid face is structurally a 10k-bucket product (26 of 34 paid faces); only 2 of 34 reached 100k. Whether paid-listing download buckets count only purchases is unknown **[U]**.
- Break-even on the $100 fee at the $2.00 point: net ≈ $1.70 per sale after Garmin's 15%, so **≈60 sales/yr** before FX/DST (`A/verif` gives ~60; `S` says ~48: source of the difference not reconciled, use 60 as the conservative number).

### Gaps
- Live top-120 publisher counts (Garmin 17, TitanicTurtle 17, VAW.BE 11, frinkr 11, MobileDriveway 6 in `A/popular`): the `developer` field returned null in today's pull, so **not re-verified [V22 only]**.
- Exact downloads, revenue, refund rates: not published anywhere found.

---

## Q2. Which gaps are real and actionable for a small studio, ranked by evidence and effort?

### Takeaway
Real: per-device layout on newest hardware, settings that persist, honest single-price commerce, and truthful device-specific listings, all of which are execution, not category. Not real: accessibility, "calm/minimal whitespace", training readiness/HRV, women's health, cloning Garmin faces.

### Cited Findings
Ranked (evidence grade = quality of the evidence for the *gap*, not for revenue):

| # | Gap | Evidence | Grade | Effort | Source |
|---|---|---|---|---|---|
| 1 | **Per-device layout on new hardware** (fēnix 9 Pro 51 mm 1.5" AMOLED, fēnix 8 51 mm, Venu 4, FR70/170, non-touch button navigation). "Too small for 51mm fenix 8", "swished into the upper left on 9 Pro". | 14.8% all-years, 11.5% in 2026; flat 25-31% per face; newest devices named in Sep-2026 reviews | **V22** (complaints); "transition window" claim **P-weak** (rising themes move only +0.4 to +1.3 pp) | Medium; ongoing per new SKU | [A/lowstar], [B/trends] |
| 2 | **Day-one device support**: users file a missing device as a 5★ request; Black Grid XT added FR70/170 only in v1.4.0 on 2026-08-25 though those watches shipped in May | Anecdotal listing/changelog evidence | **P** | Low-medium | [A/popular], [B/trends] |
| 3 | **Settings persistence** ("loses data fields", "keeps having me set it again"); most-upvoted low-star review (49 upvotes, Black Hawk Elite); Black Hawk at 4.8★ with 12.0% recent low-star (5-face sample) | 8.4%, flat 2025→2026 | **V22** | Low (test, on-watch settings where allowed) | [A/lowstar] |
| 4 | **One honest price, no key, no trial theatre** | 14.4% all-years (15.2% in 2026); concentrated in two faces; platform bars trials so competitors improvise | complaint **V22**; commercial payoff **U** (free+key faces hold the 500k-1M installs) | Zero (already HeroFace's model) | [A/lowstar], [A/verif] |
| 5 | **Truthful screenshots per device** ("doesn't look like the screenshots") | 1.2% | **V22**, small | Low | [A/lowstar] |
| 6 | **Stats stock faces omit** (active calories, weekly distance, recovery time; Glance lacks them) with modern AMOLED type | Tom's Guide 2026-02/03 reviews; r/Garmin 2025-06 | **P** (reviewer opinion) | Medium; limited by API level on FR965 | [B/trends], [B/popular] |
| 7 | **Subtractive configurability** ("exactly what I wanted and nothing I didn't"); "lots of data but clean" (r/GarminFenix 2024) | 900-review sample, only 39 long-form; forum | **P** | Medium | [A/popular], [B/trends] |
| 8 | **Original AMOLED-native data face** (B's rank 1) | Glance called dated; Crystal 2.0 "world has moved on" | **P**; saturated (VAW.BE, frinkr, MobileDriveway hold the head) | High | [B/gaps] |
| 9 | Venu X1 rectangle-native; Instinct 3 dual-time | Thin, single threads; 5 rectangle products | **P/C** | High (new layouts) | [B/gaps] |

**Refuted or blocked, do not pursue**
- **Accessibility/low vision**: forum-derived headline refuted: 37/2,544 (1.45%) mention low vision/font, 5 (0.20%) contrast, 0 colour-blindness; Simply Large (1M bucket) already serves it. **[V22]** [A/lowstar]. Forum evidence over-selects articulate complainants.
- **"Calm/minimal is whitespace"**: refuted; GLANCE (clean, legible) is the category winner. **[V22]** [A/gaps], [R].
- **Training Readiness / HRV on face**: no complication type exists; developer thread 5,023 views still unanswered (as of ~Mar 2026); absent from the API reference on 2026-09-22 **[V22]** [A/trends], [B/gaps].
- **Cloning Garmin stock faces**: rejected for new submissions **[V25]** (Q1 #7).
- **Live compass/GPS/radar/notification text, full-brightness AOD**: platform-blocked **[V22]** [A/plat], [A/verif].
- **CGM, women's health, golf/hunt/swim/parent faces**: thin or no watch-face demand evidence; CGM needs a phone bridge, high support burden **[P/U]** [A/gaps], [B/gaps].
- **Sleep Score / anything API 6.0.x** cannot be dogfooded on the FR965 (API 5.2) **[V25]**.

### Inferences
- All top-ranked gaps are execution gaps inside the "legible, configurable" category the incumbents already own; the only differentiation lever a small studio controls quickly is device fit + persistence + listing accuracy.
- Effort ranking favors 3, 4, 5, 2 (cheap) before 1 (per-size design), and 1 is partly done for HeroFace (see Q4).

### Gaps
- No install-base by device family (fēnix vs Forerunner vs Venu vs Instinct): "a gap on a device nobody owns" cannot be excluded [A/gaps, B/trends].
- Reddit and TikTok evidence for 2025-26 essentially absent in both note sets (search blocked); r/Garmin citations in `B` are from search snippets.

---

## Q3. Which claims are weak, contradicted between docs, or outdated? What did spot-checks confirm?

### Takeaway
`R`'s header correction is incomplete: its sections 3 and 5 (discovery "dead channel", "sticky lifetime installs" ranking, "exact-name only", 51/120 paid) still rest on premises that `S` and today's pull refute. Several `B` claims about API access and AOD rules are older than `A/verif` and lose.

### Cited Findings
**Contradictions resolved (winner and why)**

| Topic | Losing claim | Winning claim | Basis |
|---|---|---|---|
| Rank | "Sticky lifetime-installs sort", stale 2018 faces hold rank ([R], [A/mkt]) | Velocity/recency-weighted; #1 at 100k, #2 at 5M | **V25** store pull; `S` corrections |
| Paid share | 51/120; 17/30; 29/60 ([R], [A/popular]) | 34/120; 12/30; 16/60 | **V25** store pull; `S` |
| Discovery | "Off-rank only reachable by exact-name search"; "four-page browse cap (~2023)" ([R], [A/mkt]) | Token-based relevance search on title+description, installs ignored (`/apps/keywords`) | `S` [V22]; four-page claim is a 2023 developer remark **[S]** |
| AOD rule | "≤10% of pixels" ([B/gaps], [B/trends], `A/plat` original text) | Since Venu 2: <10% of screen **luminance**; plus no pixel lit >3 consecutive minute updates; breaking either blanks the screen | [A/verif] **V22** (three Garmin sources) |
| Partial update | "20 ms partial update / MIP seconds ok" applied to AMOLED ([B/gaps]) | `onPartialUpdate` is MIP-only; on AMOLED "no longer allowed" | [A/verif] **V22** |
| Face data access | "Watch faces cannot access sensors/calendar/sunrise" ([B/gaps]) | Faces read `SensorHistory` (HR, pressure, elevation, temperature, SpO2, Body Battery, stress), calendar-event and sunrise/sunset complication types exist; Positioning permission declared by 79/100 top faces. Live foreground sensors/compass are the blocked part | [A/plat], [A/trends], [A/popular] **V22** |
| API 6.0 exclusions | "CIQ 9 needs API 6.0, excludes Instinct 3, FR965..." ([A/plat]) | FR965/265, fēnix 7/7 Pro, Venu 3 are 5.2; Instinct 3 is 6.0; no "9.x" label on Garmin pages; monetization not gated on 6.0 | FR965=5.2 and fēnix 9/Venu 4=6.0 **V25**; rest **V22** |
| Web-store change date | Nov 2025 vs June 2026 ([A/trends]) | **2025-11-20** | **V25** announcements feed + the5krunner 2025-11-22 |
| "Free faces are becoming rare" (Tom's Guide, [B/gaps]) | Reviewer anecdote | 86 of 120 popular faces are free (all top installs) | **V25** store census beats anecdote; but many "free" faces are key-gated |
| Clone policy | "Policy changed" ([B/gaps]) | Enforcement tightened, per Garmin staff; "similar" undefined | **V25** forum 413172 |
| Body Battery/stress | "Blocked to third parties" ([B/gaps], older Glance quote) | Readable via `SensorHistory` (3.3.0) and complication (4.2.0) | [A/plat] **V22** |
| Trial mode | "hasTrialMode unused = developer neglect" ([A/popular]) | Platform exclusion for watch faces | [A/verif] **V22** |
| Review process | "content moderation only; SLA exists" ([A/gaps]) | No SLA; performance/crash/battery are rejection grounds (guidelines dated 2021-10-13); observed: HeroFace submitted 2026-09-21, approved 09-22; developers report 10+ days on bad weeks. `GTM` "about 72 hours" is unsourced | [A/verif] **V22**; [GTM] |

**Weakly sourced or stale (not contradicted, but do not lean on)**
- **Accessibility as top gap** [A/gaps]: **[S]**, refuted.
- **"Hot & Fresh is the only new-release surface", mass-upload flood (782 faces, 10+/week)**: one ~2023 forum thread by developers, not Garmin **[S]** [A/mkt].
- **Connect IQ Developer Award still runs**: last evidence 2022 (GLANCE), plus EASY Round 2023 self-reported **[U]** [A/mkt], [B/popular].
- **Press is circular for a newcomer** [R]: weakened by [B/mkt]: Tom's Guide picked free Segment34 within months (2025-07), Black Grid XT reached 50K+ in ~6 months (Mar-Aug 2026, but frinkr is an established publisher), the5krunner ran an "Indie Spotlight" on Crystal Reborn (2026-03-20). **[P]**: press works for faces with a differentiator, not only incumbents.
- **Glance review count**: 68,813 (A, 09-22) / 69,059 (today) vs 53K (Tom's Guide, Mar 2026) vs 49.9k (the5krunner): different snapshots or undercounts; use the store API figure **[V25]**.
- **Overlapping "rising themes → device transition window"**: +0.4 to +1.3 pp shifts on n=745/955 **[P-weak]** [A/lowstar].
- **Recent low-star base rates**: 5 faces × 200 reviews; do not extrapolate **[V22, narrow]**.
- **GarminHub download buckets and rankings, the5krunner Top 100 (EASY Round 10k+ vs live 500K+)**: third-party, contradicted on at least one row **[S]** [B/popular].
- **Garmin Q1 2026 fitness revenue $546.8M +42%**, hardware lineup facts: press/earnings PDF not fetched **[U]** [B/trends].
- **Paid listings hidden from store search on fēnix 9/FR70/FR170 (58 of 115 devices)**: single developer report, forum thread dated 2026-09-14, community reply only (jim_m_58: "CIQ 4+ or fēnix 6 Pro"), **no Garmin reply** as of my fetch **[U, but decision-relevant]** [forum 444114]. The monetization device-list page would not render for me, so I could not test the rule against Garmin's own list.
- **"Listing duplication is a deliberate ranking tactic"** [R], [A/popular]: inference from publishers running paid/trial/pro listings; plausible but B shows a mundane reason too: Garmin Pay could not be added to existing apps, so devs duplicate listings **[P]** [B/mkt].
- **Prices in EUR regardless of country**: USD price points not confirmed via API; use the price-point table (€2.49 = $2.00 tier, €3.49 ≈ $2.99, €5.99 ≈ $4.99 per B's paired listings) **[P]**.

**Spot-check log (2026-09-25)**

| Check | Result |
|---|---|
| Store API, top 120 watch faces | Re-pulled: 120 unique, 34 paid, 0 trial-mode, 99 >1yr, 3 <90 days, bucket distribution as in Q1. **Confirmed; `R`/`A/popular` paid-share figures wrong.** |
| Compatible-devices page (rendered) | FR965 = 5.2; fēnix 9, fēnix 9 Pro (43/47/51), Venu 4, FR570, FR70 = 6.0. The page lists 198 devices across watches, handhelds and Edge, a different universe from HeroFace's "145 SDK products that accept watch faces / 117 shipped". **Confirmed A/verif.** |
| Announcements feed | 2025-11-20 store change, 2025-02-17 trader verification, SDK 9.2.0 on 2026-06-09, fēnix 9 device support 2026-08-25. **Confirmed.** No newer SDK than 9.2.0 shown. |
| Garmin IP thread 413172 | Staff clarification found (enforcement tightened; older apps stay). **Confirmed.** |
| Monetization (15%, $100) | Page fetch failed (nav shell); search snippet corroborates. **Not re-rendered.** |
| Trial exclusion | Page fetch failed; forum search corroborates. **Not re-rendered.** |
| Counterpoint/Omdia Q2 2026 | Multiple outlets repeat 5.6% (+11%, market -4%) and Omdia ~15%. **Confirmed as reported; definitions differ.** |
| Paid-listing search bug | Thread exists, unanswered. **Unresolved.** |
| Reddit, GarminHub, Tom's Guide article bodies, awards status | Not checked (blocked or out of budget). |

### Inferences
- Treat `S` as the source of truth for store-mechanics; `A/verif` for platform rules; `A/lowstar` for complaints; `B` for 2025-26 press/policy color.
- `R` body sections 3 and 5 should not be used as-is; only its complaint analysis (section 4) and feasibility (section 4 sub-parts) survive.

### Gaps
- Garmin's Developer Agreement and the dashboard's install stats: behind login **[U]** (`S` also lists this).
- Whether text-only listing edits trigger re-review: **[U]**.

---

## Q4. What does this imply for HeroFace (do / skip)?

### Takeaway
HeroFace already sits on the best-evidenced gap (one honest $2.00 price, per-size fit suite across 10 screen sizes 208-466 px, always-on with device evidence), so the marginal work is on distribution and unproven persistence, not new features.

### Cited Findings
**HeroFace state per today's store API [V25]** (compare [GTM]): `latestExternalVersion` **1.0.1**, `changedDate` ≈ 2026-09-24, 0 downloads, 0 reviews, category 168, English description length **166 characters**, name "HeroFace" (8 characters), 96 `compatibleDeviceTypeIds`. So GTM items 1 and 3 (upload 1.0.1) may already be done, but item 2 (paste the full description) is not: the live description is still the short one. Please confirm in the dashboard. The 96 type IDs is not comparable to GTM's "69 of 117 products listed" (different units); unreconciled.

**Do**
1. **Listing repair first** (title device tokens, 1,500-3,900-character description with the HeroSet link, What's New). Store search is relevance-scored over title+description and ignores installs [S] **[V22]**; HeroFace's title/description are almost empty. Only name devices the layout has been tested on.
2. **Run the settings round-trip on the store build before announcing.** Settings not saving is 8.4% of complaints, flat year over year, and produced the corpus's top-upvoted low-star review [A/lowstar] **[V22]**. GTM gate 4 lists it as open. It is the highest-consequence unverified item against evidence-backed complaint volume.
3. **Keep the single honest price and say so** (48-hour return window is the only trial; Garmin bars trials for faces) [A/verif] **[V22]**. Paywall complaints (14-15%) come from competitors' key/trial theatre, which HeroFace does not use. Note $2.00 is the lowest tier; paid faces cluster €2.49-€5.99 and 26 of 34 sit at the 10k bucket **[V25]**, so plan for ~60 sales/yr break-even on the merchant fee, not for a hit.
4. **Add the always-on screenshot and per-device screenshots** (GTM item 6): "doesn't look like the screenshots" is its own complaint theme, and an honest AOD demo is under-marketed in the category [A/lowstar], [B/mkt].
5. **Answer every review; open one Showcase thread; ship support for the next device the week it lands** (fēnix 9 Pro 51 mm, FR70/170 are already in the fit suite per [PLAN]/[GTM]) [P].
6. **Check paid-search visibility on fēnix 9 and FR170** before betting on device-name keywords for those models: in the Connect IQ app with a fēnix 9 or FR170 selected, search "HeroFace". If the 2026-09-14 forum report is true, the paid listing will not appear in search on those models, so device-token SEO for the newest hardware is blocked and a free twin would be the search-visible product **[U]** [forum 444114].
7. **Check what "Seconds" does on AMOLED.** `A/verif` says `onPartialUpdate` is MIP-only and disallowed for AMOLED always-on; [PLAN] draws seconds through `onPartialUpdate` and GTM's open "seconds power budget" item is about that path. On the FR965 (AMOLED), seconds likely tick only in the ~10 s high-power window; the power-budget question may only apply to MIP. **[P]**, verify in code/docs before making any seconds claim.

**Skip / defer**
- Accessibility positioning, "calm minimal" positioning, training readiness/HRV/Sleep Score features (no API or unavailable on API 5.2), clone-style faces, licensed IP, women's health/golf/CGM verticals, weather radar/compass, full-bright AOD. Each is refuted, blocked, or unevidenced above.
- Rectangle and Instinct shapes (PLAN phase 4): evidence is C-grade single threads; revisit only if reviews ask, as the plan already says.
- Press outreach in the first 90 days as a *plan*: earned coverage tends to follow a differentiator or rank (evidence is mixed; see Q3); treat as opportunistic **[P]**.
- Free-twin/ladder building until `S`'s 30-day exposure test reads the ΔHeroSet ÷ ΔHeroFace ratio.

**Trade-off to surface (not a recommendation):** HeroFace has "no on-face configuration UI; settings live in Garmin Connect" [PLAN]. `B/mkt` and `B/gaps` cite the native on-device watch-face editor (API 5.1, fēnix 8+, up to 4 saved configs) as a 2026 differentiator, and `A/lowstar` frames on-watch settings as the mitigation for the phone-mediated settings-loss complaints. HeroFace's API 3.0 floor means it could only be an additive `has`-gated path; which devices expose the editor to third-party faces is **[U]**.

### Inferences
- Because the market head is free and dominated by publishers with 10+ faces, HeroFace's realistic path is a niche paid face with good hygiene; the notes give no evidence it can reach the 100k tier that only 2 of 34 paid faces have.
- The strongest lever the notes support is reviews (volume, not stars: 4.7-4.9★ is universal), so the earliest engineering-plus-support goal is a clean first 20-50 reviews.

### Gaps
- No evidence on how HeroFace's specific proposition (goal bars + streak) converts; the local research covers complaints about incumbents, not demand for goal-based faces (Goals' ring format is a partial analogue: Tom's Guide 2025-08 "Apple switcher" face [B/trends]).
- MIP behaviour, settings delivery and battery on non-FR965 watches: unverified on hardware (per `GTM`).
- Simulator results are not device proof.

<!-- Reference links -->
[reports/Garmin watch face market gap.md]: /Users/mbp/dev/garmin/reports/Garmin%20watch%20face%20market%20gap.md
[R]: /Users/mbp/dev/garmin/reports/Garmin%20watch%20face%20market%20gap.md
[reports/Selling HeroSet and HeroFace.md]: /Users/mbp/dev/garmin/reports/Selling%20HeroSet%20and%20HeroFace.md
[S]: /Users/mbp/dev/garmin/reports/Selling%20HeroSet%20and%20HeroFace.md
[A/trends]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/trends.md
[A/popular]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/popular_faces.md
[A/lowstar]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/low_star_reviews.md
[A/gaps]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/gaps_unmet_demand.md
[A/mkt]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/marketing_channels.md
[A/plat]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/platform_constraints_monetization.md
[A/verif]: /Users/mbp/dev/garmin/research_notes/Garmin%20watch%20face%20market%20gap/verification.md
[B/gaps]: /Users/mbp/dev/garmin/research_notes/Garmin%20IQ%20store%20face%20gaps/gaps.md
[B/trends]: /Users/mbp/dev/garmin/research_notes/Garmin%20IQ%20store%20face%20gaps/trends.md
[B/mkt]: /Users/mbp/dev/garmin/research_notes/Garmin%20IQ%20store%20face%20gaps/marketing.md
[B/popular]: /Users/mbp/dev/garmin/research_notes/Garmin%20IQ%20store%20face%20gaps/popular_faces.md
[GTM]: /Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md
[PLAN]: /Users/mbp/dev/garmin/HeroFace/docs/plan.md
[store API pull]: https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE
[store API pull, 2026-09-25]: https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE
[rendered compatible-devices page]: https://developer.garmin.com/connect-iq/compatible-devices/
[Connect IQ announcements feed]: https://forums.garmin.com/developer/connect-iq/b/news-announcements
[the5krunner 2025-11-22]: https://the5krunner.com/2025/11/22/garmin-shuts-down-connect-iq-web-store-mobile-app-mandatory/
[forum thread 413172]: https://forums.garmin.com/developer/connect-iq/f/discussion/413172/policies-have-changed-regarding-the-use-of-original-garmin-watchface-designs-future-watchfaces-can-not-use-the-original-designs-anymore
[forum 444114]: https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/444114/paid-listings-filtered-out-of-store-search-on-58-of-115-devices-including-forerunner-170-and-fenix-9-is-there-a-published-monetization-device-list
[WebSearch 09-25]: https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/
[search 09-25]: https://forums.garmin.com/developer/connect-iq/f/discussion/224495/watch-face-trial-mode
[Garmin Rumors]: https://garminrumors.com/counterpoint-q2-2026-smartwatch-shipments-garmin/
[the5krunner]: https://the5krunner.com/2026/09/09/smartwatch-shipments-q2-2026/
