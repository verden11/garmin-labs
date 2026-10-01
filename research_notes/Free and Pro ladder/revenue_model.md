# Revenue arithmetic: a decision rule, not a forecast

**Every input below is assumed.** No indie Connect IQ revenue has ever been published, and today's real data (0–1 downloads per
listing, days old) looks like the "low" row. Run `revenue_model.py` to reproduce; change inputs there.

## Fixed facts (measured, `garmin_rules.md`)

Garmin keeps 15% of the tax-exclusive price. $100 annual merchant fee. Payout minimum $10.

| Pro price tier | Net per sale | Sales/yr to cover the $100 fee |
|---|---|---|
| $2.00 (shows $1.99 US) | $1.70 | 59 |
| $2.50 | $2.13 | 47 |
| $3.00 | $2.55 | 39 |
| $4.00 | $3.40 | 29 |
| $5.00 | $4.25 | 24 |

A price rise from $2.00 to $3.00 breaks even on revenue if it loses no more than **33%** of sales; $4.00 tolerates a 50% loss.

## The two structures compared (6 products: 5 faces + HeroSet)

Assumptions (per product-year): paid-only sales S = 8 / 40 / 150 (low/base/high); free installs F = 300 / 2,000 / 15,000;
free→Pro attach c = 0.5% / 1.5% / 3% (on Pro-eligible devices); cannibalisation k = 40% (share of would-be blind buyers who take the free
one instead); price elasticity 0.75 for $3.00, 0.55 for $4.00.

| Scenario | Paid-only at $2 | Twin, Pro $2 | Twin, Pro $3 | Twin, Pro $4 |
|---|---|---|---|---|
| Low | −$18 | −$36 | −$28 | −$29 |
| Base | +$308 | +$451 | +$520 | +$506 |
| High | +$1,430 | +$5,408 | +$6,096 | +$5,959 |

(family net after the $100 fee; Pro sales per product: low 5–6, base 30–54, high 300–540)

## The rule that falls out

**The twin beats paid-only when F × c > k × S**, that is, when the free listing's upgrades exceed the blind purchases it steals.
At base inputs that needs an attach of about **0.8%** (1.1% in the low case). Measured same-face pairs sit at 0.2–5% pessimistic and
10–100% optimistic (`same_face_pairs.md`), so the threshold is inside the plausible range but not comfortably below it.

## What this honestly says

1. **The twin is an asymmetric bet, not a sure win.** Downside is about the same as paid-only (a few tens of dollars); upside is
   3–4× in the high case. In the base case the family earns hundreds of dollars a year, not thousands. Do not present this as a
   living. It is a low-cost option on a breakout, plus brand and review growth.
2. **Price barely matters in the base case.** $3 vs $2 is roughly +15%; $4 is no better than $3. That makes $3.00 a low-regret step
   (the modal price of paid top-30 faces, and break-even falls from 59 to 39 sales), not a big lever.
3. **The real lever is free volume F.** Every doubling of free installs doubles Pro sales at fixed attach. The plan therefore spends its
   effort on free discoverability, review count and the family shelf, not on price tuning.
4. **The model omits things that favour the twin:** fewer refunds (people try before buying), reviews accumulating on the free listing
   (paid faces get almost none: 5 of 8 new paid faces had no rating), and family cross-links. It omits things that hurt: doubled
   listing/screenshot/support work, and 1★ reviews for missing Pro features.
5. **Cost side (hours, estimated, not measured):** retrofit of one face ≈ 1–2 days of build plus 0.5 day listing/screenshots/site;
   DayArc's pair already exists. Two Garmin reviews per face (Free 1.0.0, Pro update).

## Kill and continue thresholds (used by the execution plan gates)

| Gate | Read at | Continue if | Otherwise |
|---|---|---|---|
| G1 reach | Free approval + 30 days | ≥100 installs bucket and ≥3 reviews | Fix listing/keywords first; do not conclude anything about the strategy |
| G2 attach | Free approval + 60 days | Pro sales ≥ 5, or ≥ 1% of free installs | If <0.3% with ≥1,000 free installs: the Pro content or price is wrong, not the ladder |
| G3 quality | any time | Free average rating ≥ 4.0 and no review theme of "crippled"/"bait" | Move the complained-about feature to Free, re-review |
| G4 renewal | month 12 | Family Pro net sales cover the $100 fee | Deliberate renewal decision (never cancel the merchant account to demonetize; it takes every paid app down) |
