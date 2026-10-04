# Garmin policies and design guidelines

Read 2026-10-04 from Garmin's published pages (developer.garmin.com/connect-iq/, the Developer Agreement, the brand page) and the public store API. The owner will not email Garmin, so this answers from the published record.
Sourced detail, quotes and the measurement method: `research_notes/Free and Pro ladder/garmin_rules.md`, section "Re-read 2026-10-04". **Garmin says** = on a Garmin page; **Inference** = ours.

## Read first: findings that touch live listings or owner decisions

1. **HeroSet's live listing (1.3.0) names four watches the store does not offer it on.** The description and What's New say "Also on … Instinct 2, 2S, 2X … and Descent G1". The store's device list for HeroSet lacks all four, because none is on Garmin's paid-app product list. Guideline 4b requires accurate device disclosure. Fix in 1.3.1: drop those four from the text; keep the site's `instinctLive` off for them. The same holds for the Pro Instinct ports of HeroFace and Days To Go: only a Free twin can reach Instinct 2/2S/2X and Descent G1.
2. **Nothing in Garmin's published rules contradicts the owner's 2026-10-04 decisions** ($2.50 tier for every paid app, no price numbers on the site, names as drafted). Paid-to-paid repricing is simply undocumented; doing it inside the next version upload (ROADMAP 2.7) is the safest reading.
3. **Refund line missing (guideline 4d).** None of the four live descriptions says anything about refunds, and our listing notes say not to restate Garmin's window. Add one true line.
4. **New merchant risk:** a terminated merchant account "immediately demonetizes" every paid app; re-onboarding repeats the $100 annual fee. Put the renewal date in ROADMAP section 4.

## 1. Repricing

- Garmin says: setting a price on an approved app means "the app is temporarily removed from the store so it can be reviewed again", and users must then buy it to use it. Written for the free-to-paid case (App Sales, "App Reviews"). Every upload is reviewed.
- Garmin says nothing on paid to a different paid tier, paid to free, buyers keeping the app, ratings or downloads. Community reports (forum, summarised) say owners of the earlier free version kept using it after a free-to-paid change, with a messy update flow.
- Inference: a tier change in a version upload costs one review; existing buyers keep the app. Unverified. All four paid listings are in the lowest download bucket, so exposure is small.
- Live tiers now: HeroSet, HeroFace, Days To Go show 2.49 EUR (the $2.00 tier); Two Suns 2.69 EUR (the $2.25 tier). The $2.50 tier is US 2.49 USD, eurozone 2.99 EUR, UK 2.49 GBP. Romania is a flat 19 RON from $2.00 to $3.00.

## 2. Twin listings and listing rules

- **Allowed?** Garmin publishes no duplicate, similar or "lite" rule (searched the Guidelines and the Agreement). Garmin may remove any app for any reason. Free+Pro pairs exist (GLANCE: 1,000,000 free downloads). Inference: low risk. The rule that matters is 4d: never imply a feature is free when it is not.
- **Naming:** nothing on a "Pro" suffix or title keywords. Rules that apply: no IP infringement (3a), no claim of Garmin affiliation (4a), no Garmin branding in the icon.
- **Limits:** title 50, description 4000, What's New 4000, cover 500x500 under 300 KB, screens under 150 KB, hero 1440x720: dashboard values we recorded; Garmin's brand page confirms 500x500, 128x128 and 1440x720. Screenshot count and text maxima are unpublished.
- **Review requests:** only 4c: no deceptive reviews, and no "Pay for positive reviews, including by offering users discounts". Never tie a promo code to a review.
- **Additional Hardware Requirements:** undocumented. The API field is `hardwareProductUrl`; HeroSet's live value is the bare URL. Paste the URL only, not the drafted sentence (template and `paste.md` files to fix). Three live listings have it empty.
- **Privacy policy:** needed if the app collects user data; Garmin does not define "collects". The policy URL "may not change" without redirecting. Our listings answer No (nothing leaves the watch). Exhibit A also says an app must not collect location by default and users must opt in: Two Suns Pro uses Positioning and stores a rounded place on the watch; inference: on-watch storage is not collection by the developer and the install-time permission prompt is the opt-in (unverified; the app passed review). Two Suns Free has no location.
- **Returns and money:** "Funds are not captured from customers until the 48-hour return window has passed." Payouts on the 1st, minimum $10, Garmin keeps 15% of the tax-exclusive price. For returned apps Garmin may hold, set off or claw back funds. Merchants must be a legal entity in a supported country (Lithuania is listed); $100 annual non-refundable fee. Prices are localised per currency, not converted.
- **Mobile store:** purchases and installs moved to the mobile app (Nov 2025, secondary source). Unverified whether a store URL in a description is tappable there (affects D8's first-line sibling link).

## 3. Missing products in a device list

- Method: store part numbers against each manifest product's SDK part numbers, for the live versions. No store part number lacks a manifest product, so the gaps are real.
- HeroSet 1.3.0: 18 of 87 unlisted = 7 off the paid list (fēnix 6S, FR945 LTE, Enduro, Instinct 2, 2S, 2X, Descent G1) + 11 on the list. HeroSet 1.1.1's "14 of 80" = 3 + 11. HeroFace: 48 of 117 = 37 off the list + the same 11. Days To Go: 48 of 120, same split.
- **Most likely cause for the 37 (evidence):** Garmin sells paid apps only on the App Sales list; every one is off it.
- **The 11 are unexplained:** MARQ Gen 1 x8, Descent Mk2/Mk2i, Mk2 S, D2 Air X10 are on the list yet in no paid listing. Two free rival listings (GLANCE, EASY Round) are offered on all of them, so the restriction is paid-specific. Inference: a per-device paid-sale flag not shown on the page. Garmin does not say.
- The store works per part number (fēnix 6 shows 1 of 4 SKUs), so the page lists models while the store filters SKUs. `reach_by_product.md` is corrected: free-only reach is 37, plus the 11.

## 4. Design guidelines Garmin publishes, and how we conform

| Topic and source | What Garmin says | Our practice | Finding |
|---|---|---|---|
| Watch faces: [user-experience-guidelines/watch-faces](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Watch_Faces.html) | Design for 8-colour, 64-colour or AMOLED; relative coordinates for 1:1 screens; AMOLED faces are "expected" to support always-on; always-active partial updates under 20 ms; for always-on avoid much white or blue, thin fonts, minimise static elements, shift up to four pixels | All faces light-on-dark, always-on modes step a 3x3 grid in proportional steps (about 15 px at 454 px) | **Gaps:** TwoSuns always-on text is `#5555AA` (blue family, soft); the HeroFace Pro seconds partial update has never been timed against 20 ms |
| Burn-in limits: [AMOLED FAQ](https://developer.garmin.com/connect-iq/articles/connect-iq-faq/How_Do_I_Make_a_Watch_Face_for_AMOLED_Products.html), [Entry Points](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Entry_Points.html) | Original Venu: over 10% of pixels lit, or any pixel lit 3 minutes (Entry Points says four), turns the screen off. Venu 2 and later: under 10% of luminance. Simulator has a "Screen Burn-in Simulation" heat map | Two Suns ADR-007 (always-on) and Days To Go ADR-007 (always-on) call the 10% figure "uncited" and use "lit-pixel share"/"three update cycles" | **Doc correction:** the figure is Garmin-published, the 3 vs 4 minute split is Garmin's own inconsistency, and Venu 2+ is luminance not pixels. Heat map and a wrist night are still open (ROADMAP 3.1) |
| Visual design: [visual-design page](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Incorporating_the_Visual_Design_and_Product_Personalities.html) | 64-colour palette; FR45 and FR55 use eight colours; AMOLED uses light on black; prefer light-on-dark; system fonts are readability-tested; keep text short | 64-colour-safe colours, black grounds, system fonts; FR55 is in HeroFace and Days To Go manifests | **Gap:** no doc says how an eight-colour FR55 renders our `#555555` track and `#AAAAAA` text (simulator screenshots were looked at, not compared to eight colours) |
| Store images: [brand page](https://developer.garmin.com/brand-guidelines/connect-iq/) | 500x500 sRGB, 10 px padding, "Do not choose black or transparent backgrounds", "Steer clear of descriptive text anywhere on the icon"; a watch-face preview often works best; 128x128 device icons (64 colours on MIP); hero 1440x720 | All four covers are black or near-black; HeroSet, HeroFace and Two Suns covers carry the app name as text and are not face previews; Days To Go's is a face preview on pure black | **Owner's call, not blocking:** guidance, not a review gate (all four apps were approved with these covers). MIP icon colour values were not checked (no image library available) |
| Input and workflow: [workflows](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Designing_Workflows_and_Interactions.html) | Buttons beat touch with gloves, wet or in motion; avoid changing Back; up/down page loops; "Don’t require the user to use mobile app settings before they can use your app." | HeroSet press-only, no long-press (ADR-029, button rules); Days To Go works from presets without settings | Conforms by design. HeroSet's "Back after a lone dropped rep leaves the set" modifies Back: check against ADR-050 (Back after a lone dropped rep) |
| Glances: [core topic](https://developer.garmin.com/connect-iq/articles/core-topics/Glances.html) | 4.0+ apps need a glance view to appear; limited glance memory (prose says 32 KB for most devices); keep updates under 1 Hz; do heavy work elsewhere | HeroSet glance closure about 5.4 KB, read-only, a scope check script; our notes say the 32 KB prose is stale for 64 KB devices | Conforms. Garmin's page still says 32 KB |
| Localization: [localization](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Localization.html) | "Supporting only English is not a localization strategy"; leave room for translations; respect unit and date locale | 15 languages, per-language fit tests | Conforms (languages covered: ours 15 of Garmin's 34) |
| Personality UI: [overview](https://developer.garmin.com/connect-iq/articles/personality-library/Personality_UI.html) | Style system and components (menus, prompts, toasts); use native menus, confirmations and progress bars | HeroSet draws its own screens | **Not assessed:** whether HeroSet's menus use the native components |
| Accessibility, touch-target sizes, round safe areas, power budget in numbers, watch-face review checklist | **Nothing found in the pages read.** The Workflows page gives only the gloves/wet/motion rationale; "relative coordinates" is the only safe-area advice; the review guidelines have no watch-face section (2a: do not hurt battery) | n/a | Not read: Understanding What You Are Building, Developing the Concepts, Menus, Confirmations, Progress Bars, Map Views, Data Fields |

## 5. Open unknowns

- Paid-to-paid and paid-to-free effects on buyers, ratings and downloads.
- Why 11 products on the paid list are not offered to paid apps.
- Whether a twin is ever treated as a duplicate (no rule, no precedent found).
- A paid rival listing as control for the 11 products (WP9 check): if it also lacks MARQ Gen 1 and Descent Mk2 the paid-only reading is confirmed; if it lists them, the cause is on our side.
- Whether store URLs in descriptions work in the mobile store; maxima for title, description and screenshot count.
- The full return-policy text.

## Suggested ROADMAP changes (not applied)

- Retire 2.1 (email Garmin); its leftovers go to WP9 measurement (compare device lists after the first Free approval).
- New agent task: HeroSet 1.3.1 text fix, remove Instinct 2/2S/2X and Descent G1 from the description and What's New; same check for each Pro Instinct port; 7.8 trims the site list.
- New: a refund line in all paid listing drafts; fix the listing template and `paste.md` to paste the URL only in the hardware field.
- New: doc corrections for the burn-in figures (Two Suns ADR-007 (always-on), Days To Go ADR-007 (always-on), platform-facts) and a note on the eight-colour FR55.
- New owner task: decide on non-black store covers; run the AMOLED heat map (3.1).
- New waiting item: merchant account renewal date.
