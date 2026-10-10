# Ship every face twice: free to be found, Pro to be paid for

Written 2026-09-28. Notes behind it: `research_notes/Free and Pro ladder/`. How to execute it: `reports/Free and Pro ladder execution plan.md`.

## Bottom line

Ship every watch face as **pair**: free listing, clean name, complete promise; paid **Pro** listing adds density, extra colours, extra modes. Live paid app id *becomes* Pro listing, never flipped or repriced downward. Free listing = **new app id**. DayArc already does this (DayArc / DayArc Pro, one codebase, two jungles). Report extends to HeroFace, DaysToGo, TwoSuns, and, gated, HeroSet.

Three owner directives (2026-09-28) built into every decision:

1. **Free + Pro for every face, and for apps where possible.**
2. **Every face has customisable accent colour, in free tier.**
3. **More daring designs**, passed to `watch-design-lead` and `watch-pm` as binding briefs (execution plan, section 5).

Honest financial picture, from arithmetic not forecast (`revenue_model.md`): **cheap asymmetric bet, not sure win.** Twin beats paid-only when free upgrades exceed blind purchases free listing steals; base inputs need about **0.8% attach**. Measured same-face ladders: 0.2–5% pessimistic, 10–100% optimistic. Downside tens of dollars; base case hundreds a year; high case thousands. Not a living yet. Buys what paid-only cannot: reviews and ratings at volume, reach on **33 more devices** for two faces, try-before-you-buy path Garmin does not offer faces, family shelf where each free face advertises others.

Two pilots first (DayArc pair, DaysToGo free twin), then gates decide rest.

## What is true today

| Product | Store state (2026-09-28) | Paid tier now | Accent options | Manifest products | Free-only reach | Pro content available |
|---|---|---|---|---|---|---|
| HeroSet (app) | 1.1.1 live, 1.1.2 in review, 0–1 downloads | $2.00 | none | 80 | 1 | High, but accuracy unproven |
| HeroFace | 1.0.1 live, 0 downloads | $2.00 | 3 | 117 | **33 (28%)** | Medium |
| DaysToGo | Approved by 2026-09-28 (date unknown) | $2.00 | 6 | 120 | **33 (28%)** | Thin |
| TwoSuns | Approved by 2026-09-28 (date unknown), 1.0.1 held | store shows **$2.25** | 6 | 69 | 0 | Medium-high |
| DayArc / DayArc Pro | Built, simulator only, not submitted | free / $1.99 | 7 in an uncommitted working tree | 69 | 0 | High (density is the product) |

Sources: repo manifests, settings files; `reach_by_product.md`; memory notes on approvals. "Paid tier now" for live app from its ADR (pricing decision); TwoSuns disagrees with own ADR.

## What the evidence says

| # | Finding | Grade | Where |
|---|---|---|---|
| E1 | Paid listing offered only on Garmin's allow-list (112 product groups). 33 of HeroFace's and DaysToGo's products not on it: FR245/645/745/935/945, vívoactive 3/4/4S, fēnix 5 family, FR55. Free listing reaches them | measured | `reach_by_product.md`, `garmin_rules.md` |
| E2 | Free faces out-reach paid faces by median 10× in top 120 (100,000 vs 10,000); no paid face exceeds 100,000 bucket. But free does **not** rank better (median rank 60 vs 62); #1 face is paid at 2,49 € | measured (survivor set) | `Selling HeroSet and HeroFace` notes |
| E3 | Every same-face ladder measured sells better version of *same* face. Attach 0.2–5% pessimistic, 10–100% optimistic. Face→separate-app attach only 0.2–10% even when app free | measured ranges | `same_face_pairs.md` |
| E4 | Garmin gives faces **no trial**; off-store unlock keys = largest monetisation complaint (14.4% of low-star face reviews). Separate free listing = only in-store try-before-you-buy | measured / cited | `garmin_rules.md`, market-gap notes |
| E5 | Guideline 4d allows optional paid features if disclosed, forbids bait-and-switch; no duplicate-listing rule in text. Four largest publishers run twins | measured | `garmin_rules.md` |
| E6 | Paid top faces 2,49–5,99 €; 3,49 € most common. Pro twins (Elite, PRO) sell 10,000–50,000 at 3,49–5,99 €. Studio sits at floor tier on everything | measured | `same_face_pairs.md` |
| E7 | Settings that do not save = 8.4% of low-star reviews. Accent lists already shipped in four of five products with lists only, no picker | measured | `accent_roster.md` |
| E8 | Nobody published Connect IQ revenue. Own data (0–1 downloads) days old, says nothing about demand | verified negative | market notes |

## Decisions

Each carries evidence and what would reverse it. Items marked **OWNER** on studio's "never decide alone" list (names, price, visual identity, permissions with privacy cost, uploads); report recommends, owner decides.

### D1. The ladder: every face is Free + Pro, the live paid id is the Pro, nothing is ever flipped

- **Free:** new app id, clean name, $0. **Pro:** existing paid app id (DayArc: its Pro id). Split at compile time with `excludeAnnotations`, as DayArc does (DayArc ADR-003, "two listings, one codebase, compile-time density flag"). No runtime toggle, no unlock key, no licence server.
- **Supersedes** day-45 "flip to free once" rule in DaysToGo ADR-002 (price: paid first, review at approval +45 days) and TwoSuns's reference to it. Flip has undocumented consequences (Garmin publishes nothing on paid→free), locks out on way back. Twin has no such risk, keeps merchant account and every paid app alive. Retire reminders for both faces with new ADR in each project.
  **Time-sensitive:** DaysToGo review date, approval date unknown, upper bound 2026-11-12, earliest possible about 2026-11-10 (submitted 2026-09-26). Memory reminder, nothing flips by itself, but retire in October.
- **Why (E1–E5):** reach, reviews, trial substitute, family shelf; mechanism proven by other publishers, not invented.
- **Reversed by:** Garmin saying twins not allowed (Q1 in `garmin_questions.md`), or G3 gate (free average below 4.0 or "crippled" theme).

### D2. The split rules: free carries the promise and the craft, Pro carries the density

Every feature placement must pass all six:

1. **Free delivers face's whole promise** in one honest sentence. Stranger on free version never feels tricked (guideline 4d).
2. **Free never shows what it lacks.** No greyed "Pro" toggles, no locked options in settings list, no upgrade text on face. Locked value selectable would silently fail to save, platform's worst complaint. Free settings XML simply omits Pro items.
3. **Pro is additive:** extra data rows, extra modes and layouts, extra colours. Never smaller font, watermark, ad or time limit on Free.
4. **Free must be beautiful.** Daring look in Free first: store screenshot, first impression. Pro adds, does not rescue.
5. **Permissions can only shrink in Free.** Free asks subset of Pro's permissions. (TwoSuns Free would need neither location nor history: trust win.)
6. **Upgrade talk lives only in store description and on site**, one line, one link. Never on watch.

DayArc already fits: Free = one reading per window; Pro = denser grid plus calendar (its ADR-008, "Simple excludes calendar deliberately", and ADR-009, "Pro accepts kitchen-sink density on purpose").

| Product | Free promise (one sentence) | Pro adds |
|---|---|---|
| DaysToGo | "Days until your date, counted in whole calendar days, and the date saves." Presets, custom date by phone or on the watch, event name, days/weeks, date style, always-on | Timed events (the Hour setting, count becomes H:MM under 24 h), footer line (battery or steps), accents 7–12, alternate layout. Headline feature still to validate (multiple countdowns; v1 non-goal today) |
| TwoSuns | "Time, the sun's day as a 24-hour ring, and today's Body Battery, Garmin's own numbers, never blank." Complications only | 24-hour energy curve, golden hour, tomorrow's sun and remembered place (location), ring orientation, date row, accents 7–10 |
| HeroFace | "Time first, then three daily goals and a streak; shows your HeroSet progress when HeroSet is installed." Everyday mode and HeroSet mode (funnel to HeroSet) | Pick metric in each slot, seconds, weather, alternate layout (accents stay as design pass allows) |
| HeroSet (gated) | "Count push-ups on your wrist, correct the count, save the set." | Sit-ups and squats, goals 10–500, XP/rank/streak, glance view, HeroFace link |
| DayArc | One reading per time window | Denser field grid per window plus calendar (as built) |

Recommendations for `watch-pm` to confirm in each face's `spec.md`. DaysToGo row weakest: research says countdown buyers want *minimum* ("I wish I could delete steps, calories, battery"), so free version is the product, Pro optional extras.

### D3. Accent colour: in every free tier, one family roster, each face admits a subset, append-only

- **Roster of 12 candidates** (Sky, Mint, Amber, Pink, Violet, White, then Cyan, Lime, Yellow, Orange, Coral, Magenta), all 64-colour-safe, ≥3:1 on black, dimmed form ≥3:1 (`accent_roster.md`, checked). **Each face admits only colours not colliding with own roles**: HeroFace reserves gold, green, alert red, white, requires ≥3:1 against its track (only Sky and Cyan pass; shipped Magenta measures 2.84); TwoSuns reserves golden-hour #FF5500 (no Orange, no Coral).
- **Free lists:** DaysToGo and TwoSuns six (Sky/Mint/Amber/Pink/Violet/White, shipped order), HeroFace shipped three. **Pro lists:** DaysToGo up to 12, TwoSuns up to 10, HeroFace same three plus whatever design pass admits. Colour count = Pro perk on two faces only; not the reason to buy.
- **Append-only.** Property ids and shipped value ids never change; Pro build owns id table; Free shows subset of same ids.
- HeroSet (an app) gets accent only for "effort" blue role; gold ("kept") and green ("done") stay fixed roles. `watch-design-lead` confirms.
- **No colour keyed to a reading.** Amber, orange, coral, red never *default* on Body Battery, stress or sleep faces (TwoSuns ADR-017, amber-read-as-"low" lesson).
- Lists only, never colour picker. Test: change accent on phone, sync, restart, confirm on FR965 store build (round trip HeroFace passed 2026-09-26 for goal setting, not yet for accent).
- **Why in Free:** owner's requirement; 59 of 505 reviews of Pokémon Sleep faces asked for background or colour choice (TwoSuns ADR-008 evidence). Colour table stakes for free first impression; gating would cost reviews.
- **Reversed by:** Pro buyers calling 12 vs 6 petty (move extra colours to Free; cost zero); design pass admitting more colours to HeroFace.

### D4. Daring design: the definition, the guardrails, the process

**Daring means decisiveness, not more.** One signature move per face, full commitment: oversized hero read, saturated category-keyed colour on true black, real icons in fixed hue per icon type, bold type-size contrast. Owner's own words on DayArc: "boring and far too plain… be more daring… proper SVG icons, colors" (DayArc ADR-013, "icon system, per-window and per-icon colour").

Guardrails (all from evidence already in repo):

- **Colour keyed to category, window or icon type; never to value.** Test: would this colour differ if number differed? If yes, verdict (DayArc ADR-006, "no-verdict wording extends to every metric").
- **No more fields "because available".** Daring not route to dashboards. Free keeps one focal read; only Pro dense, even then with hierarchy (DayArc ADR-009, "Pro accepts kitchen-sink density on purpose").
- **96 KB faces (HeroFace, DaysToGo) have no bitmap budget**: primitives and fonts only until measured memory test says otherwise. Icon font subset candidate (tintable, one resource). 4.2+ faces (TwoSuns, DayArc) may use pre-coloured bitmaps as DayArc does.
- **Always-on obeys burn-in** (under 10% of screen luminance on Venu 2 and later, no pixel lit three minutes straight). Daring is for awake state.
- **Process fixed by skill:** HTML/SVG mockup screenshot-verified in real browser *before* any Monkey C; owner sees render; fresh-context `watch-design-reviewer` pass after build. Simulator is not device proof.

Exact wording for the two skills in execution plan, section 5.

### D5. Naming: free gets the clean name, the paid listing becomes "<Name> Pro" (OWNER)

- Recommended: Free "<Name>", Pro "<Name> Pro". Matches DayArc, free listing most people see, "Pro" is industry pattern (GLANCE Pro, Goals Pro, PRO listings). Rename costs one bundled re-review, **only gets more expensive as reviews accrue**: all live paid listings at 0–1 downloads now. Fold rename into next version submission of each.
- Alternative: keep paid name, call new one "<Name> Lite". Cheaper for HeroSet, whose title carries live search rank ("rep counter" #3 of 982), but "Lite" signals inferior on listing most people install.
- Guard: title tokens dominate store search (about 100× description). Both titles must carry keywords earning rank today. **Published site URLs never change** (root `CLAUDE.md`); existing app page keeps slug, gains both store links.

### D6. Prices (OWNER)

- Free: $0. Never discount trick; never paid→free flip.
- **Pro faces: $3.00 tier** (measured on Garmin's price-points page: $2.99 US, 3,49 € eurozone, most common price among paid top-30 faces). Break-even falls from 59 to 39 sales a year; price rise $2 to $3 raises revenue unless it costs more than a third of sales. Base-case model gives +15%, low regret.
- HeroSet Pro: stay $2.00 until accuracy proof exists (direct competitor 2,49 € with broken counter). Revisit after.
- DayArc Pro $1.99 by owner's ADR-007 (price: Simple free, Pro $1.99, no flip). Unsubmitted, so moving to $3.00 free of cost. Recommended; owner's call.
- TwoSuns shows $2.25 in store against documented $1.99. Exactly Garmin's $2.25 tier (measured: US $2.25, 2,69 €), so form selection differed from ADR. Pick intended tier, correct in next upload.
- **Live repricing:** Garmin says setting price on approved app removes it for re-review, written for free→paid. Ask (Q2). No answer within 7 days: keep current tier for retrofits, revisit at G2 gate. Price change never blocks a wave.

### D7. Sequence: two pilots, then gates

HeroSet/HeroFace 30-day exposure test measures ratio of HeroSet to HeroFace downloads. Adding HeroFace free twin inside that window would ruin reading, so those two wait for readout (about 2026-10-25, day 0 = repaired listing's approval date; confirm).

| Wave | What | Why it goes here |
|---|---|---|
| 0 (this week) | Owner decisions, Garmin email, dashboard baseline, retire flip reminders | Nothing to build; DaysToGo date time-sensitive |
| 1 | **Pilot A: DayArc pair** (already built). **Pilot B: DaysToGo Free** (retrofit) + accent roster and daring pass on Pro | A launches as pair, measures attach with rich Pro. B measures reach (33 extra devices, countdown category where free leaders hit 10,000–100,000 and all 15 paid rivals sit at ≤10) and retrofit mechanics. Neither touches exposure test |
| 2 | TwoSuns Free, then HeroFace Free | After G1 on Pilot B and, for HeroFace, after HeroSet/HeroFace readout |
| 3 | HeroSet Free | After accuracy proof (research stop rule) and ADR-044 (HeroSet/HeroFace complication contract) review |

Gates: G1 reach, G2 attach, G3 quality, G4 renewal (`revenue_model.md`). Failed gate pauses next wave; deletes nothing.

### D8. Listing and cross-promotion pattern (the proven one)

- **First line of each description = sibling's store URL** ("Try free" on Pro; "Get Pro" on Free), as GLANCE, GreenBlack, Goals do.
- Free description asks for review in first paragraph, says plainly which devices Pro cannot be bought on, links 3–4 sibling free listings ("More from Verden"). Guideline 4a/4d: honest, disclosed, nothing implied.
- Screenshots honest per tier: Free shows Free.
- Localise both (15 languages apps already ship) as separate submission after first approval.
- Nothing on face ever advertises paid version.

### D9. Measure without analytics

Site promises zero client JavaScript, no analytics. Keep. Measure with: daily poll of every listing id through store API (bucket, reviews, rating, device list length), developer dashboard install and sales reports, timing of changes. One reader script at repo root, appended to CSV in these notes (execution plan WP9).

### D10. HeroSet, the app case: possible, gated

Apps may not be trialled without server, so free twin only trial. Free = push-ups only (exercise native counter fails at hardest, strongest proof), Pro = rest. Gated on stage-1b accuracy proof (research stop rule: if HeroSet does not beat native counter, stop marketing and fix detector). Free push-up counter that miscounts would repeat incumbent's 63 one-star reviews on our own name. Split also touches HeroSet/HeroFace complication contract (HeroSet ADR-044, "HeroSet/HeroFace complication contract"); Free build must either not publish it or publish zeros, decided when wave opens.

### D11. Retire flip-to-free everywhere; keep the merchant account

See D1. Never cancel merchant account to demonetize: demonetizes every paid app, requires paying fee again.

### D12. What we will not do

Unlock keys or off-store payments; runtime licence; visible locked items; trials by time or use; ads or nag text on face; Pro-only permission Free build lacks reason for; fifth-tier product ladder before one step converts; new faces before ladder ratio read (earlier research: new listing restarts 6–24 month clock); claiming accuracy, device reach or revenue we have not measured.

## How each decision was validated

| Decision | Validated by | Residual uncertainty |
|---|---|---|
| D1 twin | Garmin rules read directly; four publishers run it; guideline text has no duplicate rule | Garmin's own view (Q1). Attach unproven for us |
| D2 split | 4d text; GLANCE/GreenBlack descriptions; DayArc build | Each Pro unbuilt; DaysToGo Pro thin |
| D3 accent | Repo audit of all five; contrast and 64-colour computed | Phone round trip on store build untested for new lists |
| D4 daring | Skill craft bar and DayArc ADR-013 precedent | Nothing rendered yet; needs mockups and owner eyes |
| D5 names | Store-search rules from earlier research | Rename effect on rank unmeasured |
| D6 prices | Top-30 paid price mix; break-even and sensitivity arithmetic | Elasticity assumed. Whether repricing removes app undocumented |
| D7 sequence | Existing exposure-test design; reach table | Approval dates unknown |
| D10 HeroSet | Accuracy is category's #1 complaint | Detector accuracy vs native unmeasured |

## Risks

| Risk | Likelihood | Mitigation / kill signal |
|---|---|---|
| Free steals blind buyers without upgrades (k too high, c too low) | Medium | G2; move Pro content or price, not ladder |
| 1★ reviews on Free for missing Pro features | Medium | D2 rules 1–3; G3; move theme to Free |
| Garmin objects to twin listings | Low | Q1 before Wave 1 submission; precedent |
| Free users on 33 legacy devices cannot buy Pro, feel cheated | Medium | Say so in description; no upsell on face |
| Doubled listing/support/screenshots work for one person | High | Ship in waves; ponytail: reuse DayArc's tools; two pilots only |
| New accent lists reintroduce settings-not-saving | Low-Medium | Append-only; phone-sync and restart test on store build |
| Native firmware fixes rep counting | Low-Medium | Monthly release-note check (existing rule) |
| Small money: family may not cover $100 fee in year one | Medium | G4 month-12 deliberate renewal |

## Owner decisions (recommended default first)

| # | Decision | Recommended | Deadline |
|---|---|---|---|
| OD1 | Approve the ladder and the two pilots | **Yes (owner, 2026-10-04)** | before Wave 1 |
| OD2 | Retire the day-45 flip rule for DaysToGo and TwoSuns | **Yes (owner, 2026-10-04)** | October (reminder dates fall about 2026-11-10 to 11-12) |
| OD3 | Naming: Free clean, Pro "<Name> Pro" | Yes, folded into next submissions | before Free listing text |
| OD4 | Pro price: $3.00 for faces; HeroSet $2.00; TwoSuns tier fix | As D6 | before each Pro upload |
| OD5 | Send the Garmin email (`garmin_questions.md`) | Yes | this week |
| OD6 | Which accent roster names and the free six | Roster as proposed | before WP1 |
| OD7 | DayArc: settle its two flagged conflicts (below) before submission | Yes | before DayArc gate |
| OD8 | Daring direction per face, after mockups | Owner look-approval | Wave 1 |

## Corrections and conflicts found while researching

- **DayArc has live uncommitted change contradicting own ADRs.** Settings file adds Accent list citing "ADR-014", not in `docs/decisions.md`, while ADR-011 (no settings surface, either density) still Active. Another session editing DayArc (icons deleted, strings, App and Config modified). Plan does not touch DayArc source. When work lands, needs ADR-014 written and ADR-011 superseded.
- **TwoSuns store price $2.25** against ADR-002 ($1.99). $2.25 real Garmin tier; wrong one probably selected.
- **README status drift:** root `README.md` and `CLAUDE.md` say DaysToGo "built, not submitted", TwoSuns "pending review"; memory says both approved by 2026-09-28. Update once owner supplies approval dates.
- **HeroFace's shipped Magenta accent (#FF55FF) is 2.84:1 against its track**, under 3:1 its own code comment promises; HeroFace has no accent unit test. Only Sky and Cyan pass. See `accent_roster.md`.
- Earlier research plan's "wait for Garmin's paid-to-free answer" moot under D1: twin is not a flip.

## Not established

Any revenue figure. Attach for our products. Whether Garmin treats twins as duplicates. Whether repricing approved paid app removes it. What store's 33-device free reach worth in installs. Whether accuracy beats native counter. Nothing here has run on a wrist.