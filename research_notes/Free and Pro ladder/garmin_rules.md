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

## Listing field we use for a website link: "Additional Hardware Requirements (Optional)"

- Owner observation, 2026-10-02: many Connect IQ apps put a link to their own website in this optional free-text field, so we do too. It is
  the one listing field where a URL reads naturally; the description and What's New are better left to the store text.
- **Not a documented Garmin rule** (the guidelines text does not mention it), so a reviewer could still object: keep the text true. Ours is
  `No additional hardware needed. Help, privacy and more apps: https://verden.watch/<slug>/`, one URL, the app's hub page (it carries the
  support and privacy pages and the other apps). Field length limit unknown; keep it to one short line.
- Every listing draft (`*/listing*/README.md`) carries the text under "Additional Hardware Requirements". Free listings use the same hub page
  until the site gets Free pages (WP8). New listing drafts and the WP10 template must include the field.
- Live listings change only when the owner edits them in the dashboard (HeroSet, HeroFace, Days To Go, Two Suns). **Every listing detail
  (description, title, screenshots, cover, hero, pricing, every other field) can be edited at any time, without a new version, whether the
  app is in review or approved** (owner, from the dashboard, 2026-10-05). So text and images follow what the LIVE build does, not the next one.
  **A new version can be uploaded while an earlier version is still in review** (owner, from the dashboard, 2026-10-08).
  **Per-language fields** (owner, 2026-10-08): each listing language has its own **title, description, What's New and hero image**; everything else (screenshots, cover, icon, category, price, URLs) is shared by all languages.

## Not documented (do not assume)

- What happens to reviews/downloads on paid→free.
- Whether paid→higher-paid triggers removal and re-review.
- Whether adding a permission re-prompts existing users.
- Whether two listings from one developer with the same design are ever treated as duplicates.

> **Update 2026-10-04:** the section "Re-read 2026-10-04" below re-checked all of this against Garmin's pages and corrects three
> items above: the "Additional Hardware" text (paste the URL only), the free-only reach count (37, plus 11 more), and the
> "Not documented" list (paid-to-paid repricing is still undocumented, the others are confirmed undocumented). The owner will not email
> Garmin, so `garmin_questions.md` is answered from published pages where possible.

# Re-read 2026-10-04

Primary pages read 2026-10-04 (HTML fetched with `curl`; the Gatsby pages serve their article text at
`developer.garmin.com/connect-iq/articles/<folder>/<File>.html`): App Review Guidelines ("Last Updated: Oct 13th, 2021", unchanged),
Monetization (App Sales, Price Points, Merchant Onboarding, Account Management), Connect IQ Developer Agreement (page says "Updated August 6, 2024"),
User Experience Guidelines (Design Principles, Visual Design and Product Personalities, Watch Faces, Views, Entry Points, Workflows and
Interactions, Localization), Personality UI overview, the AMOLED watch-face FAQ, the Glances core topic, and the Connect IQ brand guidelines
(`developer.garmin.com/brand-guidelines/connect-iq/`). Public store API for our four paid listings and two rival free listings.
Everything below is labelled **Garmin says** (quoted or closely paraphrased from those pages), **Community** (forum posters; read through a
summarising fetch, so not verbatim, and only Brandon.ConnectIQ is Garmin staff), or **Inference** (ours).

Sources read 2026-10-04 (all returned 200; base `https://developer.garmin.com/connect-iq/articles/`): `app-review-guidelines/Overview.html`, `monetization/App_Sales.html`,
`monetization/Price_Points.html`, `monetization/Merchant_Onboarding.html`, `monetization/Account_Management.html`, `user-experience-guidelines/Overview.html`, `.../Watch_Faces.html`,
`.../Incorporating_the_Visual_Design_and_Product_Personalities.html`, `.../Views.html`, `.../Entry_Points.html`, `.../Designing_Workflows_and_Interactions.html`, `.../Localization.html`,
`personality-library/Personality_UI.html`, `connect-iq-faq/How_Do_I_Make_a_Watch_Face_for_AMOLED_Products.html`, `core-topics/Glances.html`; also
`https://developer.garmin.com/downloads/connect-iq/sdks/agreement.html` (Developer Agreement, Exhibit A), `https://developer.garmin.com/brand-guidelines/connect-iq/`, and the store API
`https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<id>?countryCode=US` (our four listings, GLANCE `07ae0f49-…`, EASY Round `9a619d99-…`). Forum threads 415896, 404968, 436796 and the5krunner
(2025-11-22) were read through a summarising fetch: not verbatim. Request count was about 55, above the budget of about 40. The Chrome tools were not needed.

## Corrections to the 2026-09-28 section

0. **The price-points article is server-rendered** (every currency table is in the page HTML), not JS-rendered as the 2026-09-28 note says; `curl` is enough.

1. **App Sales product list unchanged**: still 43 / 37 / 8 / 7 / 17 entries (API 6.0 / 5.2 / 5.1 / 5.0 / 3.4).
2. **Free-only reach is 37 products, not 33** (HeroFace, Days To Go), and **11 more products are missing from every paid listing although they are
   on the App Sales list**. The old substring match counted D2 Air, Enduro, fēnix 6S and Venu as "on the list". See "Missing products" below.
   `reach_by_product.md` carries the same correction.
3. **Additional Hardware Requirements**: the store API names this field `hardwareProductUrl`, and HeroSet's live value is the bare URL
   `https://verden.watch/heroset/`, not the drafted sentence "No additional hardware needed. Help, privacy…". **Inference:** it is a URL field.
   Paste the URL only (listing template section 2 and every `paste.md` still carry the sentence). The three other live listings have the field
   empty (`hardwareProductUrl` absent), so it is on the owner's paste list for each.
4. The 2026-09-28 note "HeroSet store manifest 80, 1 free-only" is superseded by the per-part-number measurement below.
5. **The store sells by part number, not by product.** `compatibleDeviceTypeIds` has one entry per hardware part number (HeroSet 97, HeroFace 96,
   Days To Go 99, Two Suns 88), not per manifest product. Our `poll.csv` column is therefore a SKU count, not a product count (HeroFace 96 SKUs
   cover 69 products).

## 1. Repricing (App Sales, Account Management)

- **Garmin says** (App Sales, "App Reviews"): "the app is temporarily removed from the store so it can be reviewed again". It adds that users then get a
  message that they must buy the app before they can use it again. Written for **setting a price on an already-approved app** (the free-to-paid case).
  It also says uploading an app requires a review. Nothing says what happens to people who already own a paid app when its tier changes.
- **Garmin says nothing** about paid to a different paid tier, or paid to free, by a developer. The only paid-to-free path Garmin states is the merchant
  account being terminated: "your monetized apps are immediately demonetized" (Account Management); buyers still in their return window may ask for refunds.
- **Community** (forum thread 415896, summarised): after a free app became paid in Aug 2024, existing users kept using the old free version, but the update
  flow was messy. A Garmin staff post in thread 404968 says developers can delete apps at any time and apps turn free if the merchant account lapses (summary).
- **Inference:** a tier change in the same upload as a new version costs one review, not two, and existing buyers keep what they bought (nothing says
  otherwise). Unverified. The owner's 2.7 plan (set the $2.50 tier in the form with each next upload) matches the safest reading. Exposure is small:
  all four paid listings are in the lowest download bucket.

## 2. Twin listings, naming, listing fields, money

- **No duplicate rule.** Garmin says nothing about duplicate, similar, "lite" or free-and-paid twin listings in the App Review Guidelines or the Developer
  Agreement (searched: duplicate, similar, clone, copycat, lite, multiple, spam: only the affiliate-spam clause matches). Garmin reserves the right to remove
  any app for any reason (Guidelines intro; Agreement II.a.5). Free+Pro pairs by other publishers are live (`same_face_pairs.md`: GLANCE free 1,000,000
  downloads, GreenBlack). **Inference:** low risk; the one real rule that touches twins is 4d, no implying a feature is free when it is not.
- **Naming.** Garmin publishes no rule on a "Pro" suffix or keywords in the title. It does say: no IP infringement including the developer account name
  (3a), no claim of affiliation with Garmin (4a, Agreement I.b), a branded username needs the brand's permission (Agreement II.a.2), no Garmin branding in the icon.
  Garmin's own trademark "Body Battery" stays out of Two Suns' name (already our rule).
- **Dashboard limits** (not in public docs; from our own form notes, `reports/listing-template.md`): title 50, description 4000, What's New 4000,
  cover 500x500 under 300 KB, screens under 150 KB, hero 1440x720 under 2048 KB, device icons 128x128. Garmin's brand page states 500x500 sRGB for the store
  asset (10 px padding), 128x128 for device icons (MIP icons limited to the 64-colour palette), 1440x720 for hero. Screenshot count and the
  title/description maxima are unpublished.
- **Review requests.** Only 4c applies: no deceptive reviews, and "Pay for positive reviews, including by offering users discounts". Asking for an honest review
  is not mentioned; never tie a promo code to a review.
- **Refund disclosure (4d):** "Inform users of your refund policy or lack thereof". Our listing notes say not to restate Garmin's return window. **Gap:** none of the four live
  descriptions mentions refunds (checked in the store API and `rg` over the repo). Suggest one true line ("Refunds follow the Connect IQ Store return window").
- **Privacy policy** (Agreement, Exhibit A): needed if the app collects any data from users; Garmin does not define "collects". "May not change the URL or location for your privacy policy
  without redirecting", so published privacy URLs on verden.watch must never move (already our rule). The public API has no privacy-URL field.
  **Inference:** on-watch-only data is not "collected"; our listings answer No, and the descriptions say nothing leaves the watch.
- **Returns and payouts.** Garmin says: "Funds are not captured from customers until the 48-hour return window has passed." Payouts on the 1st of each month, separately from Garmin
  International (US and Canada) and Garmin Europe; "a minimum $10 USD balance"; Garmin keeps 15% of the tax-exclusive price point and withholds digital service tax and
  currency conversion cost. Agreement II.c.2.D: for returned apps Garmin may hold funds, set off future payouts, or ask for the money back. The detailed return policy is
  "published in the Documentation"; no standalone page was found. **Community** (forum thread 436796): Garmin Pay has no trial, only the 48-hour refund.
- **Merchant.** Developers must be a legal entity in the US, Canada, Australia, Singapore or most of the EU (Lithuania is on the list); "This is an annual, non-refundable fee of $100 USD."
  **New risk:** a lapsed or terminated merchant account demonetizes every paid app at once, and re-onboarding repeats the fee. Record the renewal date.
- **Regional prices.** Garmin says price points are localised per currency, not converted. The $2.50 tier (page read 2026-10-04): US 2.49 USD, eurozone (FR/DE/IT/PT/ES) 2.99 EUR,
  UK 2.49 GBP, Canada 4.25 CAD, Australia 3.99 AUD, Sweden 35 SEK, Norway 35 NOK, Denmark 23 DKK, Switzerland 2.60 CHF, Czechia 79 CZK. Romania is a flat 19 RON from $2.00 to $3.00, and Czechia
  shows 69 CZK for both $2.00 and $2.25, so a tier step changes nothing there. Live store prices now: HeroSet, HeroFace and Days To Go show 2.49 EUR (the $2.00 tier); Two Suns 2.69 EUR (the $2.25 tier).
- **Store moved to mobile (secondary source, the5krunner, 2025-11-22, summarised):** purchases and installs now go through the Connect IQ Store mobile app; apps.garmin.com links redirect to it.
  Unverified: whether a store URL printed in a description (D8's "first line is the sibling's URL") is tappable inside the mobile app.

## 3. Missing products in a paid listing's device list

Method (2026-10-04): store API part numbers (`compatibleDevicePartNumbers`) against each SDK product's part numbers (`compiler.json`), using the manifest of the **live** version
(commits 3a9bcf4 HeroFace 1.0.1, cfd5a4f Days To Go, 0825930 Two Suns, 8d6f8e9 HeroSet 1.3.0). Control: **no store part number was left without a manifest product** in any of the four, so the
absences are real, not a naming mismatch.

| Listing | Manifest products | Listed | Unlisted | Not on App Sales list | On the list but unlisted |
|---|---|---|---|---|---|
| HeroSet 1.3.0 | 87 | 69 | 18 | 7 | 11 |
| HeroFace 1.0.1 | 117 | 69 | 48 | 37 | 11 |
| Days To Go 1.0.1 | 120 | 72 | 48 | 37 | 11 |
| Two Suns 1.0.0 | 69 | 68 | 1 | 0 | 1 (D2 Air X10) |

- HeroSet 1.1.1's "14 of 80" was 3 off the list (fēnix 6S, FR945 LTE, Enduro) plus the same 11. The 1.3.0 additions Instinct 2, 2S, 2X and Descent G1 are off the list too.
- **The 11** (on the App Sales page, absent from every paid listing): MARQ Gen 1 (Adventurer, Athlete, Aviator, Captain, Commander, Driver, Expedition, Golfer), Descent Mk2/Mk2i, Descent Mk2 S, D2 Air X10.
- **Evidence the store can serve them to free apps:** GLANCE (free, 1,000,000 downloads) and EASY Round (free, 500,000) each list 217 part numbers, including every one of those 11, FR245, FR945 LTE, FR55, Enduro and fēnix 6S.
  So the restriction is specific to paid apps, which also confirms the Free twin's reach premise (every manifest product).
- **The page is not the exact rule.** The listing is per part number: fēnix 6 shows 1 of 4 SKUs, fēnix 6X Pro 2 of 3, though the page lists models by name.
- **Most likely cause (Inference):** a per-device flag for paid sale that Garmin does not mirror on the App Sales page. **Unknown:** why those 11 (they share no API level, screen or firmware with the listed 3.4 products). Garmin does not say.
  Community (thread 404968, summarised): an app listing devices that do not support Garmin monetization got greyed-out buy buttons.
- **Live listing text problem:** HeroSet 1.3.0's description and What's New say "Also on the black-and-white Instinct 2, 2S, 2X… and Descent G1", but the store's device list lacks those four (they are not on the paid list).
  Guideline 4b requires accurately disclosing supported devices. The same applies to the Pro Instinct ports of HeroFace and Days To Go: only the Free twins can reach Instinct 2/2S/2X and Descent G1.

## Still not documented (Garmin publishes nothing, 2026-10-04)

Paid-to-paid repricing and paid-to-free effects; ratings and downloads on a price change; duplicate or twin rules; dashboard maxima (title, description, screenshots count); the full return policy text; the reason for the 11 products.
