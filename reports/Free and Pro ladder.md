# Ship every face twice: free to be found, Pro to be paid for

Written 2026-09-28. Notes behind it: `research_notes/Free and Pro ladder/`. How to execute it: `reports/Free and Pro ladder execution plan.md`.

## Bottom line

Ship every watch face as a **pair**: a free listing with the clean name and a complete promise, and a paid **Pro** listing that adds density,
extra colours and extra modes. The paid app id that is already live *becomes* the Pro listing and is never flipped or repriced downward. The
free listing is a **new app id**. DayArc already does this (DayArc / DayArc Pro, one codebase, two jungles). This report extends it to
HeroFace, DaysToGo, TwoSuns and, gated, HeroSet.

Three directives from the owner (2026-09-28) are built into every decision below:

1. **Free + Pro for every face, and for apps where possible.**
2. **Every face has a customisable accent colour, and it is in the free tier.**
3. **More daring designs**, passed to `watch-design-lead` and `watch-pm` as binding briefs (execution plan, section 5).

The honest financial picture, from arithmetic not forecast (`revenue_model.md`): this is a **cheap asymmetric bet, not a sure win.** The twin
beats paid-only when free upgrades exceed the blind purchases the free listing steals, which at base inputs needs about **0.8% attach**.
Measured same-face ladders sit at 0.2–5% pessimistic and 10–100% optimistic. Downside is tens of dollars; base case is hundreds a year;
the high case is thousands. It is not a living yet. What it buys that paid-only cannot: reviews and ratings at volume, reach on **33 more
devices** for two faces, a try-before-you-buy path Garmin does not offer faces, and a family shelf where each free face advertises the others.

Two pilots first (the DayArc pair and a DaysToGo free twin), then gates decide the rest.

## What is true today

| Product | Store state (2026-09-28) | Paid tier now | Accent options | Manifest products | Free-only reach | Pro content available |
|---|---|---|---|---|---|---|
| HeroSet (app) | 1.1.1 live, 1.1.2 in review, 0–1 downloads | $2.00 | none | 80 | 1 | High, but accuracy unproven |
| HeroFace | 1.0.1 live, 0 downloads | $2.00 | 3 | 117 | **33 (28%)** | Medium |
| DaysToGo | Approved by 2026-09-28 (date unknown) | $2.00 | 6 | 120 | **33 (28%)** | Thin |
| TwoSuns | Approved by 2026-09-28 (date unknown), 1.0.1 held | store shows **$2.25** | 6 | 69 | 0 | Medium-high |
| DayArc / DayArc Pro | Built, simulator only, not submitted | free / $1.99 | 7 in an uncommitted working tree | 69 | 0 | High (density is the product) |

Sources: repo manifests and settings files; `reach_by_product.md`; memory notes on approvals. "Paid tier now" for a live app is from its ADR
(pricing decision); TwoSuns disagrees with its own ADR.

## What the evidence says

| # | Finding | Grade | Where |
|---|---|---|---|
| E1 | A paid listing is offered only on Garmin's allow-list (112 product groups). 33 of HeroFace's and DaysToGo's products are not on it: FR245/645/745/935/945, vívoactive 3/4/4S, fēnix 5 family, FR55. A free listing reaches them | measured | `reach_by_product.md`, `garmin_rules.md` |
| E2 | Free faces out-reach paid faces by a median 10× in the top 120 (100,000 vs 10,000), and no paid face exceeds the 100,000 bucket. But free does **not** rank better (median rank 60 vs 62) and the #1 face is paid at 2,49 € | measured (survivor set) | `Selling HeroSet and HeroFace` notes |
| E3 | Every same-face ladder measured sells a better version of the *same* face. Attach 0.2–5% at the pessimistic end, 10–100% at the optimistic. Face→separate-app attach is only 0.2–10% even when the app is free | measured ranges | `same_face_pairs.md` |
| E4 | Garmin gives faces **no trial**, and off-store unlock keys are the largest monetisation complaint (14.4% of low-star face reviews). A separate free listing is the only in-store try-before-you-buy | measured / cited | `garmin_rules.md`, market-gap notes |
| E5 | Guideline 4d allows optional paid features if disclosed and forbids bait-and-switch; no duplicate-listing rule exists in the text. Four of the largest publishers run twins | measured | `garmin_rules.md` |
| E6 | Paid top faces sit at 2,49–5,99 €; 3,49 € is the most common. Pro twins (Elite, PRO) sell 10,000–50,000 at 3,49–5,99 €. The studio sits at the floor tier on everything | measured | `same_face_pairs.md` |
| E7 | Settings that do not save are 8.4% of low-star reviews. Accent lists are already shipped in four of five products with lists only, no picker | measured | `accent_roster.md` |
| E8 | Nobody has published Connect IQ revenue. Today's own data (0–1 downloads) is days old and says nothing about demand | verified negative | market notes |

## Decisions

Each carries its evidence and what would reverse it. Items marked **OWNER** are on the studio's "never decide alone" list (names, price,
visual identity, permissions with a privacy cost, uploads); this report recommends, the owner decides.

### D1. The ladder: every face is Free + Pro, the live paid id is the Pro, nothing is ever flipped

- **Free:** new app id, clean name, $0. **Pro:** the existing paid app id (for DayArc, its Pro id). Split at compile time with `excludeAnnotations`,
  as DayArc does (DayArc ADR-003, "two listings, one codebase, compile-time density flag"). No runtime toggle, no unlock key, no licence server.
- **Supersedes** the day-45 "flip to free once" rule in DaysToGo ADR-002 (price: paid first, review at approval +45 days) and TwoSuns's
  reference to it. A flip has undocumented consequences (Garmin publishes nothing on paid→free) and locks out on the way back. A twin has no
  such risk, and it keeps the merchant account and every paid app alive. Retire the reminders for both faces with a new ADR in each project.
  **Time-sensitive:** DaysToGo's review date, with the approval date unknown, has an upper bound of 2026-11-12 and an earliest possible date of about 2026-11-10 (submitted 2026-09-26). It is a memory reminder, nothing flips by itself, but retire it in October.
- **Why (E1–E5):** reach, reviews, trial substitute, family shelf; the mechanism is proven by other publishers, not invented.
- **Reversed by:** Garmin saying twins are not allowed (Q1 in `garmin_questions.md`), or the G3 gate (free average below 4.0 or a "crippled" theme).

### D2. The split rules: free carries the promise and the craft, Pro carries the density

Every feature placement must pass all six:

1. **Free delivers the face's whole promise** in one honest sentence. A stranger on the free version never feels tricked (guideline 4d).
2. **Free never shows what it lacks.** No greyed "Pro" toggles, no locked options in the settings list, no upgrade text on the face. If a
   locked value were selectable it would silently fail to save, which is the platform's worst complaint. Free settings XML simply omits Pro items.
3. **Pro is additive:** extra data rows, extra modes and layouts, extra colours. Never a smaller font, a watermark, an ad or a time limit on Free.
4. **Free must be beautiful.** The daring look is in Free first: it is the store screenshot and the first impression. Pro adds, it does not rescue.
5. **Permissions can only shrink in Free.** Free asks for a subset of Pro's permissions. (TwoSuns Free would need neither location nor history: a trust win.)
6. **Upgrade talk lives only in the store description and on the site**, one line and one link. Never on the watch.

DayArc already fits this: Free = one reading per window; Pro = denser grid plus calendar (its ADR-008, "Simple excludes calendar deliberately", and
ADR-009, "Pro accepts kitchen-sink density on purpose").

| Product | Free promise (one sentence) | Pro adds |
|---|---|---|
| DaysToGo | "Days until your date, counted in whole calendar days, and the date saves." Presets, custom date by phone or on the watch, event name, days/weeks, date style, always-on | Timed events (the Hour setting, count becomes H:MM under 24 h), footer line (battery or steps), accents 7–12, an alternate layout. Headline feature still to validate (multiple countdowns; a v1 non-goal today) |
| TwoSuns | "Time, the sun's day as a 24-hour ring, and today's Body Battery, Garmin's own numbers, never blank." Complications only | 24-hour energy curve, golden hour, tomorrow's sun and remembered place (location), ring orientation, date row, accents 7–10 |
| HeroFace | "Time first, then three daily goals and a streak; shows your HeroSet progress when HeroSet is installed." Everyday mode and HeroSet mode (the funnel to HeroSet) | Pick the metric in each slot, seconds, weather, an alternate layout (accents stay as the design pass allows) |
| HeroSet (gated) | "Count push-ups on your wrist, correct the count, save the set." | Sit-ups and squats, goals 10–500, XP/rank/streak, glance view, HeroFace link |
| DayArc | One reading per time window | Denser field grid per window plus calendar (as built) |

These are recommendations for `watch-pm` to confirm in each face's `spec.md`. The DaysToGo row is the weakest: the research says countdown
buyers want the *minimum* ("I wish I could delete steps, calories, battery"), so the free version is the product and Pro is optional extras.

### D3. Accent colour: in every free tier, one family roster, each face admits a subset, append-only

- **Roster of 12 candidates** (Sky, Mint, Amber, Pink, Violet, White, then Cyan, Lime, Yellow, Orange, Coral, Magenta), all 64-colour-safe, ≥3:1 on black, dimmed
  form ≥3:1 (`accent_roster.md`, checked). **Each face admits only the colours that do not collide with its own roles**: HeroFace reserves gold, green, alert red
  and white and requires ≥3:1 against its track (only Sky and Cyan pass; shipped Magenta measures 2.84); TwoSuns reserves golden-hour #FF5500 (no Orange, no Coral).
- **Free lists:** DaysToGo and TwoSuns six (Sky/Mint/Amber/Pink/Violet/White in their shipped order), HeroFace its shipped three. **Pro lists:** DaysToGo up to 12, TwoSuns up
  to 10, HeroFace the same three plus whatever its design pass admits. So colour count is a Pro perk on two faces only; it is not the reason to buy.
- **Append-only.** Property ids and shipped value ids never change; the Pro build owns the id table; Free shows a subset of the same ids.
- HeroSet (an app) gets an accent only for its "effort" blue role; gold ("kept") and green ("done") stay fixed roles. `watch-design-lead` confirms.
- **No colour keyed to a reading.** Amber, orange, coral and red are never the *default* on Body Battery, stress or sleep faces (TwoSuns ADR-017, the
  amber-read-as-"low" lesson).
- Lists only, never a colour picker. Test: change accent on the phone, sync, restart, confirm on the FR965 store build (the round trip HeroFace passed
  on 2026-09-26 for a goal setting, not yet for accent).
- **Why in Free:** the owner's requirement, and 59 of 505 reviews of the Pokémon Sleep faces asked for a background or colour choice (TwoSuns ADR-008 evidence).
  Colour is table stakes for the free first impression, so gating it would cost reviews.
- **Reversed by:** Pro buyers calling 12 vs 6 petty (move the extra colours to Free; cost zero); the design pass admitting more colours to HeroFace.

### D4. Daring design: the definition, the guardrails, the process

**Daring means decisiveness, not more.** One signature move per face, executed at full commitment: an oversized hero read, saturated
category-keyed colour on true black, real icons in a fixed hue per icon type, bold type-size contrast. The owner's own words on DayArc
were "boring and far too plain… be more daring… proper SVG icons, colors" (DayArc ADR-013, "icon system, per-window and per-icon colour").

Guardrails (all from evidence already in the repo):

- **Colour keyed to category, window or icon type; never to the value.** Test: would this colour differ if the number differed? If yes it is a
  verdict (DayArc ADR-006, "no-verdict wording extends to every metric").
- **No more fields "because available".** Daring is not a route to dashboards. Free keeps one focal read; only Pro is dense, and even then with a
  hierarchy (DayArc ADR-009).
- **96 KB faces (HeroFace, DaysToGo) have no bitmap budget**: primitives and fonts only until a measured memory test says otherwise. An icon font
  subset is the candidate (tintable, one resource). 4.2+ faces (TwoSuns, DayArc) may use pre-coloured bitmaps as DayArc does.
- **Always-on obeys burn-in** (under 10% of screen luminance on Venu 2 and later, no pixel lit three minutes straight). Daring is for the awake state.
- **Process is fixed by the skill:** HTML/SVG mockup screenshot-verified in a real browser *before* any Monkey C; owner sees the render;
  a fresh-context `watch-design-reviewer` pass after the build. Simulator is not device proof.

Exact wording to give the two skills is in the execution plan, section 5.

### D5. Naming: free gets the clean name, the paid listing becomes "<Name> Pro" (OWNER)

- Recommended: Free "<Name>", Pro "<Name> Pro". It matches DayArc, the free listing is the one most people see, and "Pro" is the industry
  pattern (GLANCE Pro, Goals Pro, PRO listings). Rename costs one bundled re-review and **only gets more expensive as reviews accrue**: all live
  paid listings are at 0–1 downloads now. Fold the rename into the next version submission of each.
- Alternative: keep the paid name, call the new one "<Name> Lite". Cheaper for HeroSet, whose title carries live search rank ("rep counter" #3 of 982),
  but "Lite" signals inferior on the listing most people install.
- Guard: title tokens dominate store search (about 100× the description). Both titles must carry the keywords that earn the rank today.
  **Published site URLs never change** (root `CLAUDE.md`); the existing app page keeps its slug and gains both store links.

### D6. Prices (OWNER)

- Free: $0. Never a discount trick; never a paid→free flip.
- **Pro faces: the $3.00 tier** (measured on Garmin's price-points page: $2.99 in the US, 3,49 € in the eurozone, the most common price among paid top-30 faces). Break-even falls from 59 to 39 sales a year; a price rise
  from $2 to $3 raises revenue unless it costs more than a third of sales. The base-case model gives +15%, low regret.
- HeroSet Pro: stay at $2.00 until the accuracy proof exists (the direct competitor is 2,49 € with a broken counter). Revisit after.
- DayArc Pro is $1.99 by the owner's ADR-007 (price: Simple free, Pro $1.99, no flip). It is unsubmitted, so moving to $3.00 is free of cost. Recommended; owner's call.
- TwoSuns shows $2.25 in the store against the documented $1.99. That is exactly Garmin's $2.25 tier (measured: US $2.25, 2,69 €), so the form selection differed from the ADR. Pick the intended tier and correct it in the next upload.
- **Live repricing:** Garmin says setting a price on an approved app removes it for re-review, written for free→paid. Ask (Q2). If no answer within
  7 days, keep the current tier for retrofits and revisit at the G2 gate. A price change never blocks a wave.

### D7. Sequence: two pilots, then gates

The HeroSet/HeroFace 30-day exposure test measures the ratio of HeroSet to HeroFace downloads. Adding a HeroFace free twin inside that window
would ruin the reading, so those two wait for the readout (about 2026-10-25, day 0 = the repaired listing's approval date; confirm).

| Wave | What | Why it goes here |
|---|---|---|
| 0 (this week) | Owner decisions, Garmin email, dashboard baseline, retire flip reminders | Nothing to build; the DaysToGo date is time-sensitive |
| 1 | **Pilot A: DayArc pair** (already built). **Pilot B: DaysToGo Free** (retrofit) + accent roster and daring pass on Pro | A launches as a pair and measures attach with a rich Pro. B measures reach (33 extra devices, the countdown category where free leaders hit 10,000–100,000 and all 15 paid rivals sit at ≤10) and the retrofit mechanics. Neither touches the exposure test |
| 2 | TwoSuns Free, then HeroFace Free | After G1 on Pilot B and, for HeroFace, after the HeroSet/HeroFace readout |
| 3 | HeroSet Free | After the accuracy proof (research stop rule) and an ADR-044 contract review |

Gates: G1 reach, G2 attach, G3 quality, G4 renewal (`revenue_model.md`). A failed gate pauses the next wave; it does not delete anything.

### D8. Listing and cross-promotion pattern (the proven one)

- The **first line of each description is the sibling's store URL** ("Try free" on Pro; "Get Pro" on Free), as GLANCE, GreenBlack and Goals do.
- The free description asks for a review in its first paragraph, says plainly which devices Pro cannot be bought on, and links 3–4 sibling free
  listings ("More from Verden"). Guideline 4a/4d: honest, disclosed, nothing implied.
- Screenshots are honest per tier: Free shows Free.
- Localise both (15 languages the apps already ship) as a separate submission after the first approval.
- Nothing on the face ever advertises a paid version.

### D9. Measure without analytics

The site promises zero client JavaScript and no analytics. Keep it. Measure with: a daily poll of every listing id through the store API (bucket, reviews,
rating, device list length), the developer dashboard install and sales reports, and the timing of changes. One reader script at the repo root, appended to a CSV in these notes (execution plan WP9).

### D10. HeroSet, the app case: possible, gated

Apps may not be trialled without a server, so a free twin is the only trial. Free = push-ups only (the exercise the native counter fails at hardest, so the strongest
proof), Pro = the rest. It is gated on the stage-1b accuracy proof (research stop rule: if HeroSet does not beat the native counter, stop marketing and fix the detector). A
free push-up counter that miscounts would repeat the incumbent's 63 one-star reviews on our own name. The split also touches the HeroSet/HeroFace complication contract
(HeroSet ADR-044); a Free build must either not publish it or publish zeros, decided when the wave opens.

### D11. Retire flip-to-free everywhere; keep the merchant account

See D1. Never cancel the merchant account to demonetize: it demonetizes every paid app and requires paying the fee again.

### D12. What we will not do

Unlock keys or off-store payments; a runtime licence; visible locked items; trials by time or use; ads or nag text on a face; a Pro-only permission the Free build lacks a reason for;
a fifth-tier product ladder before one step converts; new faces before the ladder ratio is read (earlier research: a new listing restarts a 6–24 month clock); claiming accuracy,
device reach or revenue we have not measured.

## How each decision was validated

| Decision | Validated by | Residual uncertainty |
|---|---|---|
| D1 twin | Garmin rules read directly; four publishers run it; guideline text has no duplicate rule | Garmin's own view (Q1). Attach is unproven for us |
| D2 split | 4d text; GLANCE/GreenBlack descriptions; DayArc build | Each Pro is unbuilt; DaysToGo Pro is thin |
| D3 accent | Repo audit of all five; contrast and 64-colour computed | Phone round trip on the store build untested for new lists |
| D4 daring | Skill craft bar and DayArc ADR-013 precedent | Nothing rendered yet; needs mockups and owner eyes |
| D5 names | Store-search rules from earlier research | Rename effect on rank is unmeasured |
| D6 prices | Top-30 paid price mix; break-even and sensitivity arithmetic | Elasticity is assumed. Whether repricing removes the app is undocumented |
| D7 sequence | Existing exposure-test design; reach table | Approval dates unknown |
| D10 HeroSet | Accuracy is the category's #1 complaint | Detector accuracy vs native is unmeasured |

## Risks

| Risk | Likelihood | Mitigation / kill signal |
|---|---|---|
| Free steals blind buyers without upgrades (k too high, c too low) | Medium | G2; move Pro content or price, not the ladder |
| 1★ reviews on Free for missing Pro features | Medium | D2 rules 1–3; G3; move the theme to Free |
| Garmin objects to twin listings | Low | Q1 before Wave 1 submission; precedent |
| Free users on the 33 legacy devices cannot buy Pro and feel cheated | Medium | Say so in the description; no upsell on the face |
| Doubled listing/support/screenshots work for one person | High | Ship in waves; ponytail: reuse DayArc's tools; two pilots only |
| New accent lists reintroduce settings-not-saving | Low-Medium | Append-only; phone-sync and restart test on the store build |
| Native firmware fixes rep counting | Low-Medium | Monthly release-note check (existing rule) |
| Small money: the family may not cover the $100 fee in year one | Medium | G4 month-12 deliberate renewal |

## Owner decisions (recommended default first)

| # | Decision | Recommended | Deadline |
|---|---|---|---|
| OD1 | Approve the ladder and the two pilots | Yes | before Wave 1 |
| OD2 | Retire the day-45 flip rule for DaysToGo and TwoSuns | Yes | October (reminder dates fall about 2026-11-10 to 11-12) |
| OD3 | Naming: Free clean, Pro "<Name> Pro" | Yes, folded into next submissions | before Free listing text |
| OD4 | Pro price: $3.00 for faces; HeroSet $2.00; TwoSuns tier fix | As D6 | before each Pro upload |
| OD5 | Send the Garmin email (`garmin_questions.md`) | Yes | this week |
| OD6 | Which accent roster names and the free six | Roster as proposed | before WP1 |
| OD7 | DayArc: settle its two flagged conflicts (below) before submission | Yes | before DayArc gate |
| OD8 | Daring direction per face, after mockups | Owner look-approval | Wave 1 |

## Corrections and conflicts found while researching

- **DayArc has a live uncommitted change that contradicts its own ADRs.** Its settings file adds an Accent list citing "ADR-014", which is not in `docs/decisions.md`,
  while ADR-011 (no settings surface, either density) is still Active. Another session is editing DayArc (icons deleted, strings, App and Config modified). This plan does not
  touch DayArc source. When that work lands it needs its ADR-014 written and ADR-011 superseded.
- **TwoSuns store price $2.25** against ADR-002 ($1.99). $2.25 is a real Garmin tier; the wrong one was probably selected.
- **README status drift:** root `README.md` and `CLAUDE.md` say DaysToGo is "built, not submitted" and TwoSuns "pending review"; memory says both were approved by 2026-09-28.
  Update once the owner supplies approval dates.
- **HeroFace's shipped Magenta accent (#FF55FF) is 2.84:1 against its track**, under the 3:1 its own code comment promises; HeroFace has no accent unit test. Only Sky and Cyan pass. See `accent_roster.md`.
- The earlier research plan's "wait for Garmin's paid-to-free answer" is moot under D1: a twin is not a flip.

## Not established

Any revenue figure. Attach for our products. Whether Garmin treats twins as duplicates. Whether repricing an approved paid app removes it. What the store's 33-device
free reach is worth in installs. Whether accuracy beats the native counter. Nothing here has run on a wrist.
