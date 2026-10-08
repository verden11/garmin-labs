# Passive income plan: watch faces and apps, one person, 12 months

Written 2026-10-08 from the owner's answers of the same day (target €100–500 net per month at month 12; 5–10 hours a week; Garmin plus one more platform if the research says GO; freeze everything not on the money path). Sources and the raw platform table are in `research_notes/Passive income plan/`. Open items go to the root `ROADMAP.md` (paste block in section 11); this report proposes and records, it does not track.

**Read this first.** Every number below that is not marked *measured* is an assumption from `research_notes/Free and Pro ladder/revenue_model.md` or the store research of 2026-10-05. Nothing here is a forecast. Garmin publishes no indie revenue, and our own listings are days old at download bucket 0–1.

## 0. The answer in one screen

1. **Garmin alone does not reach €100 a month on current evidence.** Net per Pro sale at the $2.50 tier is about €2 (*measured*: Garmin keeps 15% of the tax-exclusive price). €100 a month is 600 sales a year. The base case in our own revenue model is 40 Pro sales per product-year, so that needs about **15 products at base, or one breakout**. The whole 6-product family at base earns **hundreds of euros a year, not per month**.
2. **What gets to €100–500 a month:** (a) a Garmin family of 10–12 products that cross-link and share one engine, the shape the three publishers who own the free face shelf have (TitanicTurtle 13 faces, frinkr 10, VAW.BE 9 at bucket 100,000 or above, *measured*); plus (b) **one second store with a bigger buyer pool**. The research says that store is **Wear OS via the Watch Face Format**: zero-code XML, free tools, a $25 one-time account, 15% cut, and a buyer base that is Samsung's whole Galaxy Watch line plus Pixel Watch. Apple is closed to third-party faces, Zepp is closed to non-Chinese companies, Facer is invite-only, Fitbit is winding down. Table in section 6.
3. **The three levers, in order:** free install volume on Garmin (every doubling doubles Pro sales), number of products on the shelf, a second store. **Not levers at this scale:** price (base case +15% from $2 to $3), rating (does not move rank, *measured*), and ads (€75 of Reddit buys 2–9 installs, *inferred*).
4. **The ad budget is better spent on a used Galaxy Watch** (about €120–200) for the Wear OS spike than on three months of clicks. Keep €75 for one Reddit test after the organic exposure window, never before it. Section 7.
5. **Timeline:** month 1 lands what is in review and freezes the rest; months 2–3 read the first exposure numbers and ship the first free app (Sun Window); months 4–6 start the cadence (one Garmin product every 5–6 weeks) and the Wear OS spike; months 7–12 scale what the numbers reward and kill what they do not; the month-12 review falls before the merchant fee renews (2027-09-17).
6. **First action, today, 20 minutes:** the three dashboard checks already on the ROADMAP (10.29, 10.30, 10.31), because a listing whose sibling link reads `<PRO STORE URL>` leaks the only free traffic we have. Then section 10's weekly routine starts next Monday.

## 1. Where you stand (2026-10-08, measured)

| Asset | State |
|---|---|
| Live Garmin apps | HeroSet 1.3.0 (app), HeroFace 1.0.1, Days To Go, Two Suns, DayArc + DayArc Pro (faces). 5 app ids live, 9 listings counting the twins in review |
| In Garmin review since 2026-10-04 | HeroSet 1.3.1, HeroFace Free + Pro 1.1.0, Days To Go Free + Pro 1.1.0, Two Suns Free + Pro 1.1.0 |
| Downloads | Bucket 0 or 1 on every listing; 0 reviews (`research_notes/Free and Pro ladder/poll.csv`) |
| Rank | DayArc and DayArc Pro entered Instinct 3 Solar at #117 / #116 on approval day; nowhere on fr965-class lists |
| Money in | None yet. Merchant fee $100 paid 2026-09-17; renewal about 2027-09-17 |
| Tooling you already own | One file layout for every face, compile-time Free/Pro split, container simulator with screenshots, 15-language fit sweep, `tools/store_poll.py` (buckets, reviews, rank), listing template, site with one page per app, `watch-pm` and `watch-design-lead` skills plus a design reviewer agent |
| Approved and waiting | Sun Window free app with a glance (plan approved 2026-10-05), CloseHour app (plan done 2026-10-05), Opportunities backlog (5 specs) |

The infrastructure is the asset. A new face costs 1–2 build days plus half a day of listing work; the publishers who win do exactly this, many times, on one engine.

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
| Legacy widget shelf | a free widget at bucket 10,000 is top 10 on every colour device; our apps-with-glance publish as watch-apps, not there | measured |

What this says: a solo Garmin publisher reaches €100 a month only with a wide shelf or a breakout, and the shelf is the part you control. The second store is the only way to the upper half of your target bucket, and it is a bet, not a plan line, until the spike in section 6 reports.

## 3. Seven rules the plan runs on

1. **Free first, Pro adds density.** Already decided (ladder D1–D12). Never flip a paid app to free, never ship an unlock key, no price numbers in text.
2. **One engine, many products.** Every new face reuses the shared layout, fit tests, listing template and site page. A product that needs a new engine is a "later" item.
3. **Ship for the shelf you can be seen on.** Every Garmin product ships an Instinct build (small pool, paid listings visible from bucket 100) and the widest Free device list the SDK allows.
4. **Cross-link everything.** Every listing ends with "More from Verden" naming the free siblings; every site page links the family. A family is what the shelf rewards.
5. **Measure with what exists.** `store_poll.py` daily, rank on Instinct 3 and Instinct 2, review count. Gates G1–G4 from the ladder decide continue or stop. Never turn buckets into revenue.
6. **Spend money only after a free lever is exhausted.** Organic exposure window first, one paid channel at a time, never two.
7. **Owner decides, agent prepares.** Names, prices, icons, uploads, deploys, purchases stay with you. Everything else the agent does unprompted inside the weekly routine.

## 4. Phases and calendar

Dates are earliest, never promises. Each phase has a readout and a stop rule.

### Phase 0: land and freeze (now to about 2026-10-25, 2–4 h total)

1. Dashboard checks 10.29, 10.30, 10.31 (sibling URLs and the $2.50 tier). 20 min.
2. Paste the hardware-field site link into the four live listings (6.6). 15 min.
3. Record each approval date from the 2026-10-04 wave as Garmin sends it (7.12); the agent reads device lists and starts the 30-day clock per listing (6.4). 5 min per approval.
4. Freeze: everything in section 9's "park" list leaves the active ROADMAP sections. Agent prepares the move; you say yes. 15 min.
5. Reply to every text review as it arrives, with the support route (15.5). Agent drafts.

Readout: all 9 listings approved and correctly cross-linked. Stop rule: none; this phase only removes leaks.

### Phase 1: first numbers and the first free app (about 2026-10-25 to 2026-12-31)

1. **G1 reach readout** per Free listing at approval + 30 days: 100-install bucket and 3 reviews. Below that: fix the listing (title tokens, first lines, images), not the strategy. The HeroSet/HeroFace exposure readout is about 2026-10-25 (5.1, 5.7).
2. **Second rank snapshot** 2026-10-19 to 11-02 (15.9): does the Instinct 3 rank of DayArc move from the newest tail into the ranked pool? This tells you whether rank follows sales or recent installs, which decides whether launch bursts are worth planning.
3. **Sun Window** free app with a glance (manifest type `watch-app`, so it lands on the watch-app shelf, not the thinner legacy widget shelf; its plan is approved and conditional on the FR965 spike yielding a place): spike, mockup, build, listing. A free app feeds the family shelf and is the cheapest product in the queue. Agent builds; you approve looks and upload. About 3 weekend blocks of your time over 6 weeks. **Separate question for later:** whether any Verden product can publish on the legacy widget shelf (22-entry pool, least crowded, *measured*); that needs a CIQ 3 widget target, which no current project has.
4. **Listing repair pass** on whatever G1 shows weak: Free listings say plainly "nothing is locked" (15.1), HeroSet's first lines against the Strafe "Hero" family (15.2), one real-device photo per listing (15.8) once the wrist checks happen.
5. **G2 attach readout** at approval + 60 days: 5 Pro sales or 1% of free installs. Below 0.3% with 1,000+ free installs means the Pro content or price is wrong, not the ladder.
6. **One Reddit test**, €75, only after the exposure window closes and only pointed at `verden.watch/<app>?utm_*`. Pass bar: 100 sessions for ≤ €85 and ≥ 10% landing-to-store handoff. Fail either: no more ad spend in year one.

Readout by 2026-12-31: for each Free listing, bucket, reviews, Instinct rank; Sun Window live. Stop rule: if every Free listing is still at bucket 0–10 after 60 days with repaired listings, the Garmin shelf is not reachable organically for us; the plan shifts weight to the second store in phase 2 and stops adding Garmin faces until one listing moves.

### Phase 2: cadence and the second-store spike (2027-01 to 2027-03)

1. **Cadence:** one new Garmin product every 5–6 weeks, Free first, Pro only where a density headline exists. Order by shelf and reuse: CloseHour (app, approved plan, Free), then the Opportunities backlog specs that reuse the face engine (Field Face for MIP/Instinct, Rank Face) before anything needing a new engine. Each product: agent builds in a worktree, design lead plus fresh design reviewer until "ship", you approve looks and upload. Your time per product: about 3 h.
2. **Wear OS spike, time-boxed to 4 weeks of agent work and about 4 h of yours.** Steps: open a Google Play developer account ($25 one-time, personal); **the same week, join the tester-swap communities the owner already knows (you test others' apps, they test yours) and book 12 testers before the watch is bought** (owner, 2026-10-08: known route, expected to work; a business account would skip the rule but needs a registration and a D-U-N-S number, not worth it for a spike); install Watch Face Studio and the Android emulator; port the simplest face (Days To Go Free) to the Watch Face Format; upload to the closed track and start the 14-day clock **before** sideloading to the used Galaxy Watch, so the hardware never waits on the clock; publish free when Play grants production access. Readout at 90 days after publish: installs per day against the Garmin twin. Buy decision for the watch is yours (section 7).
3. **Store copy translations** pasted (13.33) and the "More from Verden" block in every listing (13.32), with each product's next upload.
4. **Month-6 review** (about 2027-03-31): total Pro sales, which Free listing moves, Wear OS installs. Decide: keep both stores, or go Garmin-only, or shift the cadence to Wear OS.

Stop rule for the spike: if Play's closed test cannot be filled in 6 weeks or the port needs a second engine, stop and record why.

### Phase 3: scale what moved (2027-04 to 2027-09)

1. Double down on whatever the month-6 review rewarded: more products of the kind that moved, on the store that moved. Keep the 5–6 week cadence.
2. Second-store paid tier only after its free faces show installs (the 5.99 € tier on Garmin is earned by free hits, *measured*; expect the same elsewhere).
3. HeroSet Free after the accuracy proof (7.3, 7.4): the one app whose whole case is a measured claim.
4. **Month-12 review, about 2027-08-17**, before the merchant fee renews 2027-09-17: family Pro net against the fee (G4), monthly net against the €100–500 target, hours spent. Renew deliberately. Never cancel the merchant account to demonetize (it takes every paid app down).

## 5. What "passive" costs: the standing load

| Load | Cadence | Who | Time |
|---|---|---|---|
| Review replies | as they arrive | agent drafts, you paste | 5 min each |
| Store poll, rank, buckets | daily, automatic | `tools/store_poll.py` (extend with rank, 15.7) | 0 |
| Device waves (new Garmin watches) | 2–3 times a year | agent adds products, simulator, you approve screens and upload | 1 h per wave per app |
| SDK and Garmin policy changes | yearly | agent | 1 h |
| Merchant fee, payout account (USD-capable) | yearly | you | 30 min |
| Site deploys | with each approval | agent prepares, you say push | 5 min |
| Wear OS: Play policy emails, WFF version bumps | quarterly | agent | 30 min |

Under 2 h a month once the products are live. The build cadence is the non-passive part, and it stops whenever you say so without breaking the income that exists.

## 6. Second platform: the table and the pick

Full sources in `research_notes/Passive income plan/platforms.md`. "Unverified" means no primary source was reachable; do not act on it without checking.

| Platform | Third-party faces allowed | Account cost | Store cut | Build | Hardware | Buyer pool | Verdict |
|---|---|---|---|---|---|---|---|
| **Wear OS (Google Play)** | Yes; Watch Face Format mandatory since 2026-01-14 | $25 one-time (third-party source; confirm at sign-up) | 15% on first $1M once enrolled in the reduced tier | Declarative XML; Watch Face Studio (Samsung; "free" is general knowledge, its page states no price, not re-verified 2026-10-08) or hand-written WFF; emulator exists | A real Galaxy Watch (Wear OS 5+) for proof; used ≈ €120–200 | Samsung Galaxy Watch line (Omdia: Samsung #2 at 15% share Q2 2026), Pixel Watch, others | **GO for a spike** |
| Watch Face Push marketplaces (Facer, TIMEFLIK, WatchMaker, Pujie, Recreative on Wear OS 6) | Yes, via their apps | Facer Partner Program is invite-only; revenue share unpublished | Unpublished | WFF | Same as Wear OS | Facer claims $1M+ paid out to partners; promotional | **NO-GO now**; revisit when a Wear OS face has installs |
| Apple watchOS | **No** third-party faces; apps and complications only (general knowledge; Apple's guidelines page names no such clause and was not re-verified 2026-10-08) | $99/yr (general knowledge, not re-verified) | 15–30% | Swift | iPhone + Apple Watch | Largest (Omdia 46%) | **NO-GO** for faces; an app port is a different business |
| Huawei Watch Face Store | Yes (100,000+ faces, 17.5M MAU claimed 2025) | Huawei developer account; designer programme terms **unverified** | **Unverified** | Huawei's designer tool | Huawei watch | Counterpoint: Huawei #1 at 22% Q2 2026, ~80% in China | **LATER**; needs a terms check before any spike |
| Zepp OS (Amazfit) | Paid faces only from certified **Mainland China corporate** developers | n/a | 15% + 30% Apple/Google = 55% net | Zepp OS JS | Amazfit watch | Mid | **NO-GO** |
| Fitbit gallery | EU gallery closed to third parties 2024; developers report unanswered submissions 2025; no new Fitbit OS hardware | n/a | n/a | n/a | n/a | Shrinking | **NO-GO** |
| Garmin Connect IQ | Yes | $100/yr merchant fee for paid | 15% | Monkey C | FR965 owned | Counterpoint 5.6% / Omdia 15% share; no paid face above bucket 100,000 in the 2026-10-05 snapshot | **Keep as the base** |

**The pick: Wear OS, as a free-face spike, not a build commitment.** Reasons: the format is declarative (the agent can port a face without a second code engine), the tools are free, the fee is one-time and small, the cut matches Garmin's, and the buyer pool is the second biggest after Apple's closed one. Risks, stated: Google's 12-testers-for-14-days rule on new personal accounts (a business account avoids it; otherwise recruit testers from r/WearOS or friends); the Play Store rewards nothing by default (developers report 1–3 installs a day even with ads); Wear OS indie earnings are as unpublished as Garmin's. The spike's job is to produce one number: free installs per day on Play against the same face on Garmin.

**Huawei is the sleeper.** Biggest unit share, a store that pays designers, 100,000 faces. Terms were not reachable from here. One agent task: read the designer programme pages in a browser and record fee, cut and payout country rules before deciding anything.

## 7. The ad budget: where the few hundred euros go

| Use | Cost | What you learn | Recommendation |
|---|---|---|---|
| Used Galaxy Watch 5/6 (Wear OS 5+) | €120–200 | Whether the Wear OS store delivers installs the Garmin store does not | **Yes**, buy in phase 2 if the Wear OS port compiles in the emulator |
| Reddit Ads test | €75 | Whether a community audience presses through to the store (≥ 10% handoff) | **Yes, once**, after the organic window, never two channels |
| Google Search ads | €0 to check, then variable | Only if Keyword Planner shows volume for "garmin rep counter" and the like | Check volume first; probably no |
| Micro-newsletter slot | €75–300 | A traffic-quality signal | No in year one |
| TikTok, Meta conversion, YouTube | over the floor or unmeasurable | Nothing at this scale | No |

Why the watch beats the clicks: €75 of clicks buys 2–9 installs you cannot attribute (Garmin shows no referrer). €150 of hardware opens a second store for every product you ever make.

## 8. Decision points for the owner (dates)

| When | Decision | Default if silent |
|---|---|---|
| now | Approve the freeze list (section 9) | freeze |
| 2026-10-25 | G1/exposure readout: repair listings or move on | repair the weakest two |
| 2026-12-31 | Reddit test yes/no | yes, €75, one month |
| 2027-01 | Buy the used Galaxy Watch | yes, if the port runs in the emulator |
| 2027-03-31 | Month-6 review: both stores, Garmin-only, or Wear OS-first | follow the installs |
| 2027-08-17 | Month-12 review and merchant fee renewal | renew if family Pro net covers it or installs trend up |

## 9. Freeze: what stays on the money path and what parks

**Stays open (money path):** every upload and approval (7.12), dashboard checks (10.29–10.31, 6.6, 2.8), wrist checks that unblock a listing claim (1.1, 4.2, 3.1, 5.5, 7.3), listing text and images for the live builds (13.31, 15.1, 15.2, 15.5, 15.8, 13.32, 13.33), measurement (6.4, 5.1, 5.7, 15.7, 15.9), the broken clock on Venu Sq 2 (13.35, re-upload), site Free/Pro sections once approvals land (6.1, 3.7, 3.12, 9.9, 7.8), Sun Window, CloseHour, HeroSet Free after proof (7.4), the merchant reminders (10.20, 10.28), DMARC (6.5).

**Parks until the month-6 review:** the Days To Go bold redesign (8.1, 8.2, 8.3, 15.4), extra accent ids, the always-on grey question (13.25), time-zone city hints and the `8h 06m` units (13.5, 13.7, 13.17), the Venu Sq 2 morning layout choice (13.30), more watches beyond what is already built (13.34), the launcher icon redo for apps already approved with placeholders (1.5, 3.3, 10.5 except where an upload happens anyway), native-speaker reads (7.10), the HeroFace seconds timing (10.18), HeroSet by-hand simulator items (7.11), git backup tags (10.3), the OrbStack licence (10.14, decide by its date but no work), the free strength data field (15.3), and 14.1.

Rule for new ideas during the year: they go to `reports/Opportunities backlog.md`, not to the ROADMAP, unless they are the next product in the cadence.

## 10. The weekly routine (5–10 h)

1. **Monday, 30 min, you:** open the Garmin dashboard and Play Console (from phase 2). Note approvals, sales, reviews. Paste any text review to the agent; paste its reply back. Say "weekly" to the agent.
2. **Monday, agent, unprompted:** run the poll, update each `docs/status.md` with dates and buckets, draft review replies, list the week's one `[you]` gate.
3. **One build block, 3 h, mostly agent:** the current product in the cadence. You look at screenshots and say yes or name the change.
4. **One approval block, 1 h, you:** the week's gate: an upload, a look approval, a dashboard edit. One, never several.
5. **Last Monday of the month, 1 h, both:** the readout against the phase's stop rule. The agent writes the numbers into `research_notes/Passive income plan/readouts.md`; you decide the one line that changes.

Anything that does not fit these five slots waits a week. The routine is the plan; the phases only say what goes in slot 3.

## 11. ROADMAP lines to paste

The agent did not edit `ROADMAP.md`: the main checkout holds uncommitted owner edits to it. Every id in this report (sections 4, 9 and below) is read from the **committed** ROADMAP; if your working copy already uses 16.x or has renumbered 15.x, renumber the block and re-check the 15.x references. The block is fenced so this report holds no open checkboxes (house rule).

```markdown
Section 1 (Decide):
- [ ] 16.1 `[you]` Approve the freeze list in `reports/Passive income plan.md` section 9; the agent then moves parked items under a "Parked until 2027-03-31" heading in section 4.
- [ ] 16.2 `[you]` (2027-01) Buy a used Galaxy Watch (Wear OS 5+, about €120–200) for the Wear OS spike, if the Days To Go port runs in the emulator (16.5).
- [ ] 16.3 `[you]` (after the organic exposure window, about 2026-12) One Reddit Ads test, €75, one month, landing on `verden.watch/<app>?utm_*`; pass bar 100 sessions for ≤ €85 and ≥ 10% store handoff.

Section 3 (Agent can do now):
- [ ] 16.4 `[agent]` Huawei Watch Face Store designer programme: read fee, revenue share, payout countries and tool in a browser; record in `research_notes/Passive income plan/platforms.md`. No spike without the owner.
- [ ] 16.5 `[agent]` Wear OS spike, time-boxed 4 weeks: Watch Face Format port of Days To Go Free, emulator screenshots, closed-test track live with the owner's tester-swap recruits (12 opted in, 14 continuous days; owner recruits, agent tracks the opt-in count), Play listing draft. Stop and report if a second engine is needed or the 12 are not reached in 6 weeks.
- [ ] 16.6 `[agent]` Monthly readout file `research_notes/Passive income plan/readouts.md`: per listing bucket, reviews, Instinct rank, Pro sales (owner pastes), against the phase stop rules.

Section 4 (Waiting on a date):
- [ ] 16.7 `[both]` **2027-03-31** Month-6 review: both stores, Garmin-only, or Wear OS-first (plan section 8).
- [ ] 16.8 `[both]` **2027-08-17** Month-12 review before the merchant fee renewal: family Pro net vs the fee, monthly net vs the €100–500 target, hours spent.
```

## 12. What this plan does not claim

No revenue figure here is measured. The twin ladder's break-even attach (about 0.8%) is inside the plausible range, not comfortably below it. Wear OS indie earnings are unpublished. The Instinct rank mechanism is inferred from one snapshot. The second snapshot (15.9) and the G1/G2 readouts are the first evidence the plan will produce; if they contradict a line above, the line loses.
