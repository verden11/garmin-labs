# Passive income plan: watch faces and apps, one person, 12 months

Written 2026-10-08 from owner's answers same day (target €100–500 net per month at month 12; 5–10 hours a week; Garmin plus one more platform if research says GO; freeze everything not on money path). **Revised 2026-10-09** after hand-off merge (all nine listings uploaded 2026-10-08, square designs on rectangles, Spanish and Chinese store copy, ROADMAP 16.x) and fresh store poll. Sources and raw platform table in `research_notes/Passive income plan/`. Open items in root `ROADMAP.md` (ids 17.x, section 11); this report proposes and records, not tracks.

**Read this first.** Every number below not marked *measured* = assumption from `research_notes/Free and Pro ladder/revenue_model.md` or store research of 2026-10-05. Nothing here is forecast. Garmin publishes no indie revenue; our listings days old at download bucket 0–10.

## 0. The answer in one screen

1. **Garmin alone does not reach €100 a month on current evidence.** Net per Pro sale at $2.50 tier about €2 (*measured*: Garmin keeps 15% of tax-exclusive price). €100 a month = 600 sales a year. Base case in own revenue model = 40 Pro sales per product-year, so needs about **15 products at base, or one breakout**. Whole 6-product family at base earns **hundreds of euros a year, not per month**.
2. **What gets to €100–500 a month:** (a) Garmin family of 10–12 products, cross-linked, one shared engine, shape of the three publishers who own free face shelf (TitanicTurtle 13 faces, frinkr 10, VAW.BE 9 at bucket 100,000 or above, *measured*); plus (b) **one second store with bigger buyer pool**. Research says that store = **Wear OS via Watch Face Format**: zero-code XML, free tools, $25 one-time account, 15% cut, buyer base = Samsung's whole Galaxy Watch line plus Pixel Watch. Apple closed to third-party faces, Zepp closed to non-Chinese companies, Facer invite-only, Fitbit winding down. Table in section 6.
3. **Three levers, in order:** free install volume on Garmin (each doubling doubles Pro sales), number of products on shelf, second store. **Not levers at this scale:** price (base case +15% from $2 to $3), rating (does not move rank, *measured*), ads (€75 of Reddit buys 2–9 installs, *inferred*).
4. **Ad budget better spent on used Galaxy Watch** (about €120–200) for Wear OS spike than three months of clicks. Keep €75 for one Reddit test after organic exposure window, never before. Section 7.
5. **Timeline:** month 1 lands what is in review, freezes rest; months 2–3 read first exposure numbers, ship first free app (Sun Window); months 4–6 start cadence (one Garmin product every 5–6 weeks) and Wear OS spike; months 7–12 scale what numbers reward, kill what not; month-12 review falls before merchant fee renews (2027-09-17).
6. **First action, today, 15 minutes:** dashboard Merchant Account tab reads "In review" (section 1, ROADMAP 17.9): find approval mail or ask Garmin whether paid sales enabled, since every paid listing already shows a price. Sibling-link checks (10.29–10.31) done 2026-10-09. Then section 10's weekly routine starts next Monday.

## 1. Where you stand (2026-10-09, measured)

| Asset | State |
|---|---|
| Live Garmin listings | 6 app ids live (HeroSet, HeroFace Pro, Days To Go Pro, Two Suns Pro, DayArc, DayArc Pro). 2026-10-08 versions (1.4.0, 1.2.0, 1.1.0) in Garmin review. Dashboard 2026-10-09 (agent, owner's browser): all six cards "Status: Approved", public pages show 2026-10-08 versions and What's New to everyone; dashboard has no per-version review state, so update of approved app public as soon as store shows it (16.3 recorded them as live) |
| Free twins | HeroFace Free, Days To Go Free, Two Suns Free (new app ids, uploaded 2026-10-04, replaced 2026-10-08 by 1.1.0): cards "Status: Pending", pages visible only to owner with Garmin's "could take up to 3 days" banner, 5 days in on 2026-10-09; store returns 404 |
| Listings | All nine carry English, Spanish, Chinese (title, description, What's New, hero per language; 16.1 is the paste), "More from Verden" block, "nothing is locked" line on every Free, framed screenshots; $2.50 tier set on every paid upload (2.7 done) |
| Devices | Square design on Venu Sq / Sq 2 / X1 rectangles in all five apps; HeroSet 92 products, HeroFace 129, Days To Go 129, Two Suns 92, DayArc 93 |
| Downloads | DayArc bucket 0 → 10 in four days (2026-10-05 to 10-09). **DayArc Pro bucket 0 → 1: first download of a paid listing** (Statistics tab: one install, on 1.0.0, between 2026-10-05 and 10-08); a sale unless own store install, dashboard shows no sales report to tell. Every other listing 0–1; 0 reviews |
| Rank | DayArc / DayArc Pro entered Instinct 3 Solar at #118 / #117 on approval day (2026-10-05), out of top 120 by 2026-10-09: newest-approvals tail transient (one data point; 15.9 is real test) |
| Money in | Possibly one Pro sale (above), but dashboard reports no sales anywhere, Merchant Account tab reads **"Account Status: In review"** (registration 2026-09-17; read 2026-10-09). Until approved, no paid download counts as money (ROADMAP 17.9). Merchant fee $100 paid 2026-09-17; renewal about 2027-09-17 |
| Tooling you already own | One file layout for every face, compile-time Free/Pro split, container simulator with screenshots, 15-language fit sweep, `tools/store_poll.py` (bucket, reviews, Instinct rank), listing template with per-language fields, site with one page per app, `watch-pm` and `watch-design-lead` skills plus design reviewer agent |
| Approved and waiting | Sun Window free app with glance (plan approved 2026-10-05, mockup approved, owner wear day next), CloseHour app (plan done 2026-10-05), Opportunities backlog (5 specs) |

Infrastructure is the asset. New face costs 1–2 build days plus half day listing work; winning publishers do exactly this, many times, on one engine.

## 2. The arithmetic (one table, no forecast)

| Quantity | Value | Basis |
|---|---|---|
| Net per Pro sale, $2.50 tier | ≈ $2.13 / ≈ €2.0 | measured: 15% cut on tax-exclusive price |
| Sales a year to cover the $100 merchant fee | 47 | measured |
| €100 a month | ≈ 600 Pro sales a year | arithmetic |
| €500 a month | ≈ 3,000 Pro sales a year | arithmetic |
| Pro sales per product-year, low / base / high | 5 / 40 / 150–540 | assumed, `revenue_model.md` |
| Free installs needed per product-year at 1.5% attach for 40 Pro sales | ≈ 2,700 | assumed |
| fr965-class visibility floor | bucket 10,000 | measured: ranks 61–120 need 10,000 |
| Instinct 3 visibility floor | bucket 100 for a store-priced listing | measured |
| Legacy widget shelf | free widget at bucket 10,000 is top 10 on every colour device; our apps-with-glance publish as watch-apps, not there | measured |

Meaning: solo Garmin publisher reaches €100 a month only with wide shelf or breakout; shelf is the part you control. Second store only way to upper half of target bucket; a bet, not plan line, until section 6 spike reports.

## 3. Seven rules the plan runs on

1. **Free first, Pro adds density.** Already decided (ladder D1–D12). Never flip paid app to free, never ship unlock key, no price numbers in text.
2. **One engine, many products.** Every new face reuses shared layout, fit tests, listing template, site page. Product needing new engine = "later" item.
3. **Ship for the shelf you can be seen on.** Every Garmin product ships Instinct build (small pool, paid listings visible from bucket 100) and widest Free device list SDK allows.
4. **Cross-link everything.** Every listing ends with "More from Verden" naming free siblings; every site page links family. Family is what shelf rewards.
5. **Measure with what exists.** `store_poll.py` daily, rank on Instinct 3 and Instinct 2, review count. Gates G1–G4 from ladder decide continue or stop. Never turn buckets into revenue.
6. **Spend money only after a free lever exhausted.** Organic exposure window first, one paid channel at a time, never two.
7. **Owner decides, agent prepares.** Names, prices, icons, uploads, deploys, purchases stay with you. Everything else agent does unprompted inside weekly routine.

## 4. Phases and calendar

Dates earliest, never promises. Each phase has readout and stop rule.

### Phase 0: land and freeze (now to about 2026-10-25, 2–4 h total)

1. ~~Dashboard checks 10.29, 10.30, 10.31~~ done 2026-10-09 by agent in your browser: every sibling URL real, every paid listing shows 2,99€. **New, 17.9:** Merchant Account tab says "In review"; find out whether paid sales enabled. 15 min.
2. Paste Spanish and Chinese fields into nine listings (16.1; per-language title, description, What's New, hero). 30 min.
3. Paste hardware-field site link into live listings (6.6). 15 min.
4. Read each listing's review status in dashboard (public store cannot tell, section 1); say "approved: <listing>" and agent does 16.3 (dates, device lists, Free links into every "More from Verden" block, site Free URLs). 30-day G1 clock starts per Free listing at approval date (6.4). 5 min per approval.
5. Freeze: everything in section 9's "park" list leaves active ROADMAP sections. Agent prepares move; you say yes (17.1). 15 min.
6. Reply to every text review as it arrives, with support route (15.5). Agent drafts.

Readout: all 9 listings approved, three Free links live, every listing cross-linked. Stop rule: none; this phase only removes leaks.

### Phase 1: first numbers and the first free app (about 2026-10-25 to 2026-12-31)

1. **G1 reach readout** per Free listing at approval + 30 days: 100-install bucket and 3 reviews. Below: fix listing (title tokens, first lines, images), not strategy. HeroSet/HeroFace exposure readout about 2026-10-25 (5.1, 5.7).
2. **Second rank snapshot** 2026-10-19 to 11-02 (15.9): does DayArc's Instinct 3 rank move from newest tail into ranked pool? Tells whether rank follows sales or recent installs, deciding whether launch bursts worth planning. First data point (2026-10-09, *measured*): DayArc dropped from #118 to outside top 120 within four days, its 1.1.0 update did not put it back on tail; tail is for new listings, and short.
3. **Sun Window** free app with glance (manifest type `watch-app`, so lands on watch-app shelf, not thinner legacy widget shelf; plan approved, conditional on FR965 spike yielding a place): spike, mockup, build, listing. Free app feeds family shelf, cheapest product in queue. Agent builds; you approve looks and upload. About 3 weekend blocks of your time over 6 weeks. **Separate question for later:** whether any Verden product can publish on legacy widget shelf (22-entry pool, least crowded, *measured*); needs CIQ 3 widget target, which no current project has.
4. **Listing repair pass**, only where G1 weak: "nothing is locked" line (15.1), HeroSet's first lines against Strafe "Hero" family (15.2), "More from Verden" block (13.32) already in 2026-10-08 uploads. Left to try: title tokens, first image, one real-device photo per listing (15.8) once wrist checks happen.
5. **G2 attach readout** at approval + 60 days: 5 Pro sales or 1% of free installs. Below 0.3% with 1,000+ free installs = Pro content or price wrong, not ladder.
6. **One Reddit test**, €75, only after exposure window closes, only pointed at `verden.watch/<app>?utm_*`. Pass bar: 100 sessions for ≤ €85 and ≥ 10% landing-to-store handoff. Fail either: no more ad spend in year one.

Readout by 2026-12-31: per Free listing, bucket, reviews, Instinct rank; Sun Window live. Stop rule: if every Free listing still at bucket 0–10 after 60 days with repaired listings, Garmin shelf not reachable organically for us; plan shifts weight to second store in phase 2 and stops adding Garmin faces until one listing moves.

### Phase 2: cadence and the second-store spike (2027-01 to 2027-03)

1. **Cadence:** one new Garmin product every 5–6 weeks, Free first, Pro only where density headline exists. Order by shelf and reuse: CloseHour (app, approved plan, Free), then Opportunities backlog specs reusing face engine (Field Face for MIP/Instinct, Rank Face) before anything needing new engine. Each product: agent builds in worktree, design lead plus fresh design reviewer until "ship", you approve looks and upload. Your time per product: about 3 h.
2. **Wear OS spike, time-boxed to 4 weeks of agent work and about 4 h of yours.** Steps: open Google Play developer account ($25 one-time, personal); **same week, join tester-swap communities owner already knows (you test others' apps, they test yours) and book 12 testers before watch bought** (owner, 2026-10-08: known route, expected to work; business account would skip rule but needs registration and D-U-N-S number, not worth it for spike); install Watch Face Studio and Android emulator; port simplest face (Days To Go Free) to Watch Face Format; upload to closed track and start 14-day clock **before** sideloading to used Galaxy Watch, so hardware never waits on clock; publish free when Play grants production access. Readout 90 days after publish: installs per day against Garmin twin. Buy decision for watch is yours (section 7).
3. **Store copy translations** pasted (13.33) and "More from Verden" block in every listing (13.32), with each product's next upload.
4. **Month-6 review** (about 2027-03-31): total Pro sales, which Free listing moves, Wear OS installs. Decide: keep both stores, or Garmin-only, or shift cadence to Wear OS.

Stop rule for spike: if Play's closed test cannot be filled in 6 weeks or port needs second engine, stop and record why.

### Phase 3: scale what moved (2027-04 to 2027-09)

1. Double down on what month-6 review rewarded: more products of kind that moved, on store that moved. Keep 5–6 week cadence.
2. Second-store paid tier only after its free faces show installs (5.99 € tier on Garmin earned by free hits, *measured*; expect same elsewhere).
3. HeroSet Free after accuracy proof (7.3, 7.4): the one app whose whole case is a measured claim.
4. **Month-12 review, about 2027-08-17**, before merchant fee renews 2027-09-17: family Pro net against fee (G4), monthly net against €100–500 target, hours spent. Renew deliberately. Never cancel merchant account to demonetize (takes every paid app down).

## 5. What "passive" costs: the standing load

| Load | Cadence | Who | Time |
|---|---|---|---|
| Review replies | as they arrive | agent drafts, you paste | 5 min each |
| Store poll, rank, buckets | daily, automatic | `tools/store_poll.py` (add the three Free ids to `store_poll_ids.txt` once their pages exist) | 0 |
| Device waves (new Garmin watches) | 2–3 times a year | agent adds products, simulator, you approve screens and upload | 1 h per wave per app |
| SDK and Garmin policy changes | yearly | agent | 1 h |
| Merchant fee, payout account (USD-capable) | yearly | you | 30 min |
| Site deploys | with each approval | agent prepares, you say push | 5 min |
| Wear OS: Play policy emails, WFF version bumps | quarterly | agent | 30 min |

Under 2 h a month once products live. Build cadence is the non-passive part; stops whenever you say so without breaking existing income.

## 6. Second platform: the table and the pick

Full sources in `research_notes/Passive income plan/platforms.md`. "Unverified" = no primary source reachable; do not act without checking.

| Platform | Third-party faces allowed | Account cost | Store cut | Build | Hardware | Buyer pool | Verdict |
|---|---|---|---|---|---|---|---|
| **Wear OS (Google Play)** | Yes; Watch Face Format mandatory since 2026-01-14 | $25 one-time (third-party source; confirm at sign-up) | 15% on first $1M once enrolled in reduced tier | Declarative XML; Watch Face Studio (Samsung; "free" is general knowledge, its page states no price, not re-verified 2026-10-08) or hand-written WFF; emulator exists | Real Galaxy Watch (Wear OS 5+) for proof; used ≈ €120–200 | Samsung Galaxy Watch line (Omdia: Samsung #2 at 15% share Q2 2026), Pixel Watch, others | **GO for a spike** |
| Watch Face Push marketplaces (Facer, TIMEFLIK, WatchMaker, Pujie, Recreative on Wear OS 6) | Yes, via their apps | Facer Partner Program invite-only; revenue share unpublished | Unpublished | WFF | Same as Wear OS | Facer claims $1M+ paid out to partners; promotional | **NO-GO now**; revisit when a Wear OS face has installs |
| Apple watchOS | **No** third-party faces; apps and complications only (general knowledge; Apple's guidelines page names no such clause and was not re-verified 2026-10-08) | $99/yr (general knowledge, not re-verified) | 15–30% | Swift | iPhone + Apple Watch | Largest (Omdia 46%) | **NO-GO** for faces; app port is a different business |
| Huawei Watch Face Store (HUAWEI Themes) | Yes (100,000+ faces, 17.5M MAU claimed 2025); needs "certified designer (watch face)" permission: portfolio review | Free developer ID; Merchant Service enabled for paid | 70% of (price − deductions) × (1 − an **undisclosed** operation cost rate); Europe settles through Aspiegel SE in EUR, **€200 minimum payout, an invoice per payout** (read 2026-10-09, agreement dated 2026-09-30) | Theme Studio, visual layer editor: a second engine | Huawei watch | Counterpoint: Huawei #1 at 22% Q2 2026, ~80% in China | **LATER**: terms known; revisit only if Wear OS spike shows a non-Garmin store delivers installs |
| Zepp OS (Amazfit) | Paid faces only from certified **Mainland China corporate** developers | n/a | 15% + 30% Apple/Google = 55% net | Zepp OS JS | Amazfit watch | Mid | **NO-GO** |
| Fitbit gallery | EU gallery closed to third parties 2024; developers report unanswered submissions 2025; no new Fitbit OS hardware | n/a | n/a | n/a | n/a | Shrinking | **NO-GO** |
| Garmin Connect IQ | Yes | $100/yr merchant fee for paid | 15% | Monkey C | FR965 owned | Counterpoint 5.6% / Omdia 15% share; no paid face above bucket 100,000 in 2026-10-05 snapshot | **Keep as the base** |

**The pick: Wear OS, as free-face spike, not build commitment.** Reasons: format declarative (agent ports face without second code engine), tools free, fee one-time and small, cut matches Garmin's, buyer pool second biggest after Apple's closed one. Risks, stated: Google's 12-testers-for-14-days rule on new personal accounts (business account avoids it; otherwise recruit testers from r/WearOS or friends); Play Store rewards nothing by default (developers report 1–3 installs a day even with ads); Wear OS indie earnings as unpublished as Garmin's. Spike's job: one number: free installs per day on Play against same face on Garmin.

**Huawei is the sleeper, terms now read (2026-10-09, 17.4 done).** Biggest unit share, store that pays designers, 100,000 faces. Split is 30:70 in Huawei's favour of nothing: 70% applies after operation cost rate agreement does not state; European payouts from Aspiegel SE in EUR with €200 floor and commercial invoice per settlement; publishing needs designer qualification review and Huawei's own Theme Studio, so nothing from Garmin engine carries over but artwork. Not a year-one move; sits behind Wear OS spike's readout.

## 7. The ad budget: where the few hundred euros go

| Use | Cost | What you learn | Recommendation |
|---|---|---|---|
| Used Galaxy Watch 5/6 (Wear OS 5+) | €120–200 | Whether Wear OS store delivers installs Garmin store does not | **Yes**, buy in phase 2 if Wear OS port compiles in emulator |
| Reddit Ads test | €75 | Whether community audience presses through to store (≥ 10% handoff) | **Yes, once**, after organic window, never two channels |
| Google Search ads | €0 to check, then variable | Only if Keyword Planner shows volume for "garmin rep counter" and the like | Check volume first; probably no |
| Micro-newsletter slot | €75–300 | Traffic-quality signal | No in year one |
| TikTok, Meta conversion, YouTube | over the floor or unmeasurable | Nothing at this scale | No |

Why watch beats clicks: €75 of clicks buys 2–9 installs you cannot attribute (Garmin shows no referrer). €150 of hardware opens second store for every product you ever make.

## 8. Decision points for the owner (dates)

| When | Decision | Default if silent |
|---|---|---|
| ~~now~~ done 2026-10-09 | Approve the freeze list (section 9) | freeze new features and reworked designs; small work stays |
| 2026-10-25 | G1/exposure readout: repair listings or move on | repair the weakest two |
| 2026-12-31 | Reddit test yes/no | yes, €75, one month |
| 2027-01 | Buy the used Galaxy Watch | yes, if the port runs in the emulator |
| 2027-03-31 | Month-6 review: both stores, Garmin-only, or Wear OS-first | follow the installs |
| 2027-08-17 | Month-12 review and merchant fee renewal | renew if family Pro net covers it or installs trend up |

## 9. Freeze: what stays on the money path and what parks

**Owner's rule (2026-10-09, 17.1 done):** freeze new features and reworked designs; small work, listing updates included, stays active.

**Stays open:** every approval and bookkeeping (7.12, 16.3), dashboard pastes and checks (6.6, 16.1, 13.33, 17.9), wrist checks (1.1, 4.2, 3.1, 5.5, 7.3, 7.9, 16.6, 10.18), listing text, images, icons with each next upload (13.31, 15.5, 15.8, 1.5, 3.3, 10.5, 13.27, 7.2), native-speaker reads (7.10), measurement (6.4, 5.1, 5.7, 15.9), site accuracy and Free/Pro sections once approvals land (6.1, 3.7, 3.12, 9.9, 7.8, 16.4, 16.5), Sun Window, CloseHour, HeroSet Free after proof (7.4), merchant items (10.20, 10.28, 17.9), housekeeping (10.3, 10.14, 7.11), DMARC (6.5), HeroSet goal-raise option (13.41, one-line decision), Instinct hardware checks when a watch in reach (9.6). 13.35 ticked (Venu Sq 2 clock fix shipped 2026-10-08).

**Parked until month-6 review (ROADMAP section 4, "Parked until 2027-03-31"):** Days To Go bold redesign and second Pro view (8.1, 8.2, 8.3, 15.4), time-zone city hints (13.5), Two Suns night weather row and `#5555AA` colour test (13.40, 10.17), free strength data field (15.3), and 14.1.

Rule for new ideas during year: go to `reports/Opportunities backlog.md`, not ROADMAP, unless next product in cadence.

## 10. The weekly routine (5–10 h)

1. **Monday, 30 min, you:** open Garmin dashboard and Play Console (from phase 2). Note approvals, sales, reviews. Paste any text review to agent; paste its reply back. Say "weekly" to agent.
2. **Monday, agent, unprompted:** run poll, update each `docs/status.md` with dates and buckets, draft review replies, list week's one `[you]` gate.
3. **One build block, 3 h, mostly agent:** current product in cadence. You look at screenshots, say yes or name change.
4. **One approval block, 1 h, you:** week's gate: an upload, a look approval, a dashboard edit. One, never several.
5. **Last Monday of month, 1 h, both:** readout against phase's stop rule. Agent writes numbers into `research_notes/Passive income plan/readouts.md`; you decide the one line that changes.

Anything not fitting these five slots waits a week. Routine is the plan; phases only say what goes in slot 3.

## 11. ROADMAP ids

Added to `ROADMAP.md` on this branch 2026-10-09 (2026-10-08 hand-off already uses 16.1–16.6, so plan's ids are **17.x**): 17.1 approve freeze list, 17.2 buy used Galaxy Watch (2027-01), 17.3 the one Reddit test (section 1); 17.4 Huawei terms check, 17.5 Wear OS spike, 17.6 monthly readout file (section 3); 17.7 month-6 review 2027-03-31, 17.8 month-12 review 2027-08-17 (section 4). Main checkout's `ROADMAP.md` matched committed one when branch written, so fast-forward merge brings them in, nothing to paste.

## 12. What this plan does not claim

No revenue figure here measured. Twin ladder's break-even attach (about 0.8%) inside plausible range, not comfortably below it. Wear OS indie earnings unpublished. Instinct rank mechanism inferred from one snapshot. Second snapshot (15.9) and G1/G2 readouts are first evidence plan produces; if they contradict a line above, line loses.