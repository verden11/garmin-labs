# Garmin rules that shape the ladder

All **measured** by reading the live page in a browser, 2026-09-28, unless marked.

## Monetization: App Sales (`developer.garmin.com/connect-iq/monetization/app-sales/`)

- "When you list an app for sale, it will only be offered on these products." Five tiers of products: API 6.0 (43 entries),
  5.2 (37), 5.1 (8), 5.0 (7), 3.4 (17). "This list is subject to change." A **free listing has no such list.**
  FR245, FR645, FR745, FR935, FR945, vívoactive 3/4/4S, fēnix 5 family, FR55 are not on it (see `reach_by_product.md`).
- Sales only to users in a list of supported countries (long; includes US, Canada, most of Europe, Australia, Japan).
- Garmin keeps **15% of the tax-exclusive price point**; adds sales tax on top; pays card fees; withholds digital service tax and
  currency-conversion cost from payouts.
- "If you are setting a price for an app that has already been approved, the app is temporarily removed from the store so it can
  be reviewed again. After the app is approved, users receive a message explaining that they must purchase the app before they
  can use it again." Written for free→paid. **Not stated for paid→higher-paid or paid→free** (unverified; see `garmin_questions.md`).
- Migration: a marketing form issues one-time promotion codes so existing buyers can get another app free. Garmin says the developer
  distributes them. This is the sanctioned way to give existing Pro buyers a new listing.
- Payouts: 1st of each month, separately from Garmin International (US/Canada) and Garmin Europe (rest). Funds captured after the
  48-hour return window. Last five days of a month may roll into the next payout. Minimum balance $10.

## Monetization: Price Points (`.../monetization/price-points/`)

- USD tiers: **$2.00, then every $0.25 to $10.00**, then every $1 to $50, then $60/$70/$80/$90/$100. There is no $0.99 or $1.50 tier.
  Localised, not converted (16 currencies). The page's tabs are JS-rendered; read rows from `article.innerText` after selecting a currency.
- **Tier → what each store shows (measured, 2026-09-28):**

  | Tier | US | Eurozone (FR/DE/IT/PT/ES) | UK |
  |---|---|---|---|
  | $2.00 | $1.99 | 2,49 € | £1.69 / £1.99 |
  | $2.25 | $2.25 | 2,69 € | £1.99 / £2.29 |
  | $2.50 | $2.49 | 2,99 € | £2.29 / £2.49 |
  | $3.00 | **$2.99** | **3,49 €** | £2.49 / £2.99 |
  | $3.50 | $3.49 | 3,99 € | £2.99 / £3.49 |
  | $4.00 | $3.99 | 4,69 € | £3.29 / £3.99 |
  | $5.00 | $4.99 | 5,99 € | £4.29 / £4.99 |

- So the top-selling paid faces map to tiers: 2,49 € = $2.00 (Goals, TiM), 2,69 € = $2.25 (Outerfield, Quipu), 2,99 € = $2.50 (Rad-Lad),
  **3,49 € = $3.00 (Rondo, Black Hawk, Vanguard, Circles 2, Style 7, Fletcher: the most common)**, 4,69 € = $4.00 (Tactical),
  5,99 € = $5.00 (GreenBlack PRO, SURGE).
- **TwoSuns showing "$2.25" in the US store is exactly the $2.25 tier**, a real, different tier from the documented $1.99 ($2.00 tier).
  Someone selected it in the upload form (dashboard check in `garmin_questions.md`).

## App Review Guidelines (`.../app-review-guidelines/`, "Last Updated: Oct 13th, 2021")

- 4a: no inaccurate or misleading statements; disclose limitations and dependencies in the description and "any other advertising".
- 4d Monetization: state whether the app requires payment. "An app is not considered to require payment, if the only features that
  require payment or subscription are optional." Must: disclose if free only for a limited time or number of uses; state refund
  policy; not bait-and-switch ("implying that a feature is available for free, when it is not").
- **No rule about duplicate, similar or "lite" listings** appears in the guidelines text (searched: duplicate, similar, multiple,
  same, clone, copycat). Several large publishers run free+paid twins of one face (`same_face_pairs.md`). Risk is low but the store's
  "clone" enforcement is vague (forum thread 413172), so ask Garmin (`garmin_questions.md` Q1).
- No documented trial or in-app purchase for watch faces. Trials exist for apps only, via the developer's own unlock server
  (`Trial Apps`, earlier notes). Unlock keys sold off-store are the top monetisation complaint (14.4% of low-star face reviews).

## Not documented (do not assume)

- What happens to reviews/downloads on paid→free.
- Whether paid→higher-paid triggers removal and re-review.
- Whether adding a permission re-prompts existing users.
- Whether two listings from one developer with the same design are ever treated as duplicates.
