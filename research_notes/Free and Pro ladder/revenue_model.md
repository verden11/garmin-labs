# Revenue arithmetic: a decision rule, not a forecast

**Every input below is assumed.** No indie Connect IQ revenue ever published; today's real data (0–1 downloads per listing, days old) looks like "low" row. Run `revenue_model.py` to reproduce; change inputs there.

## Fixed facts (measured, `garmin_rules.md`)

Garmin keeps 15% of tax-exclusive price. $100 annual merchant fee. Payout minimum $10.

| Pro price tier | Net per sale | Sales/yr to cover the $100 fee |
|---|---|---|
| $2.00 (shows $1.99 US) | $1.70 | 59 |
| $2.50 | $2.13 | 47 |
| $3.00 | $2.55 | 39 |
| $4.00 | $3.40 | 29 |
| $5.00 | $4.25 | 24 |

Price rise $2.00 -> $3.00 breaks even on revenue if loses no more than **33%** of sales; $4.00 tolerates 50% loss.

## The two structures compared (6 products: 5 faces + HeroSet)

Assumptions (per product-year): paid-only sales S = 8 / 40 / 150 (low/base/high); free installs F = 300 / 2,000 / 15,000; free→Pro attach c = 0.5% / 1.5% / 3% (on Pro-eligible devices); cannibalisation k = 40% (share of would-be blind buyers taking free one instead); price elasticity 0.75 for $3.00, 0.55 for $4.00.

| Scenario | Paid-only at $2 | Twin, Pro $2 | Twin, Pro $3 | Twin, Pro $4 |
|---|---|---|---|---|
| Low | −$18 | −$36 | −$28 | −$29 |
| Base | +$308 | +$451 | +$520 | +$506 |
| High | +$1,430 | +$5,408 | +$6,096 | +$5,959 |

(family net after $100 fee; Pro sales per product: low 5–6, base 30–54, high 300–540)

## The rule that falls out

**Twin beats paid-only when F × c > k × S**: free listing's upgrades exceed blind purchases it steals. At base inputs needs attach about **0.8%** (1.1% in low case). Measured same-face pairs sit at 0.2–5% pessimistic and 10–100% optimistic (`same_face_pairs.md`), so threshold inside plausible range, not comfortably below it.

## What this honestly says

1. **Twin = asymmetric bet, not sure win.** Downside about same as paid-only (few tens of dollars); upside 3–4× in high case. Base case: family earns hundreds of dollars/yr, not thousands. Do not present as a living. Low-cost option on a breakout, plus brand and review growth.
2. **Price barely matters in base case.** $3 vs $2 roughly +15%; $4 no better than $3. So $3.00 = low-regret step (modal price of paid top-30 faces; break-even falls 59 -> 39 sales), not big lever.
3. **Real lever = free volume F.** Each doubling of free installs doubles Pro sales at fixed attach. Plan therefore spends effort on free discoverability, review count, family shelf, not price tuning.
4. **Model omits things favouring twin:** fewer refunds (try before buying), reviews accumulating on free listing (paid faces get almost none: 5 of 8 new paid faces had no rating), family cross-links. Omits things hurting: doubled listing/screenshot/support work, 1★ reviews for missing Pro features.
5. **Cost side (hours, estimated, not measured):** retrofit of one face ≈ 1–2 days build plus 0.5 day listing/screenshots/site; DayArc's pair already exists. Two Garmin reviews per face (Free 1.0.0, Pro update).

## Kill and continue thresholds (used by the execution plan gates)

| Gate | Read at | Continue if | Otherwise |
|---|---|---|---|
| G1 reach | Free approval + 30 days | ≥100 installs bucket and ≥3 reviews | Fix listing/keywords first; do not conclude anything about strategy |
| G2 attach | Free approval + 60 days | Pro sales ≥ 5, or ≥ 1% of free installs | If <0.3% with ≥1,000 free installs: Pro content or price wrong, not ladder |
| G3 quality | any time | Free average rating ≥ 4.0 and no review theme of "crippled"/"bait" | Move complained-about feature to Free, re-review |
| G4 renewal | month 12 | Family Pro net sales cover $100 fee | Deliberate renewal decision (never cancel merchant account to demonetize; takes every paid app down) |