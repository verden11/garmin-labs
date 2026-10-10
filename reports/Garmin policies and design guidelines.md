# Garmin policies and design guidelines

Read 2026-10-04 from Garmin's published pages (developer.garmin.com/connect-iq/, Developer Agreement, brand page) and public store API. Owner will not email Garmin -> answers from published record.
Sourced detail, quotes, measurement method: `research_notes/Free and Pro ladder/garmin_rules.md`, section "Re-read 2026-10-04". **Garmin says** = on Garmin page; **Inference** = ours.

## Read first: findings that touch live listings or owner decisions

1. **HeroSet live listing (1.3.0) names four watches store does not offer it on.** Description and What's New say "Also on … Instinct 2, 2S, 2X … and Descent G1". Store device list for HeroSet lacks all four: none on Garmin's paid-app product list. Guideline 4b requires accurate device disclosure. Fix in 1.3.1: drop those four from text; keep site's `instinctLive` off for them. Same for Pro Instinct ports of HeroFace and Days To Go: only Free twin can reach Instinct 2/2S/2X and Descent G1.
2. **Nothing in Garmin's published rules contradicts owner's 2026-10-04 decisions** ($2.50 tier for every paid app, no price numbers on site, names as drafted). Paid-to-paid repricing undocumented; doing it inside next version upload (ROADMAP 2.7) = safest reading.
3. **Refund line missing (guideline 4d).** None of four live descriptions mentions refunds; listing notes say not to restate Garmin's window. Add one true line.
4. **New merchant risk:** terminated merchant account "immediately demonetizes" every paid app; re-onboarding repeats $100 annual fee. Put renewal date in ROADMAP section 4.

## 1. Repricing

- Garmin says: setting price on approved app means "the app is temporarily removed from the store so it can be reviewed again", users must then buy it to use it. Written for free-to-paid case (App Sales, "App Reviews"). Every upload reviewed.
- Garmin says nothing on paid to different paid tier, paid to free, buyers keeping app, ratings, downloads. Community reports (forum, summarised): owners of earlier free version kept using it after free-to-paid change, messy update flow.
- Inference: tier change in version upload costs one review; existing buyers keep app. Unverified. All four paid listings in lowest download bucket -> small exposure.
- Live tiers now: HeroSet, HeroFace, Days To Go show 2.49 EUR ($2.00 tier); Two Suns 2.69 EUR ($2.25 tier). $2.50 tier = US 2.49 USD, eurozone 2.99 EUR, UK 2.49 GBP. Romania flat 19 RON from $2.00 to $3.00.

## 2. Twin listings and listing rules

- **Allowed?** Garmin publishes no duplicate, similar or "lite" rule (searched Guidelines and Agreement). Garmin may remove any app for any reason. Free+Pro pairs exist (GLANCE: 1,000,000 free downloads). Inference: low risk. Rule that matters = 4d: never imply feature is free when not.
- **Naming:** nothing on "Pro" suffix or title keywords. Rules that apply: no IP infringement (3a), no claim of Garmin affiliation (4a), no Garmin branding in icon.
- **Limits:** title 50, description 4000, What's New 4000, cover 500x500 under 300 KB, screens under 150 KB, hero 1440x720: dashboard values we recorded; Garmin brand page confirms 500x500, 128x128, 1440x720. Screenshot count and text maxima unpublished.
- **Review requests:** only 4c: no deceptive reviews, no "Pay for positive reviews, including by offering users discounts". Never tie promo code to review.
- **Additional Hardware Requirements:** undocumented. API field = `hardwareProductUrl`; HeroSet live value = bare URL. Paste URL only, not drafted sentence (template and `paste.md` files to fix). Three live listings have it empty.
- **Privacy policy:** needed if app collects user data; Garmin does not define "collects". Policy URL "may not change" without redirecting. Our listings answer No (nothing leaves watch). Exhibit A also says app must not collect location by default, users must opt in: Two Suns Pro uses Positioning, stores rounded place on watch; inference: on-watch storage not collection by developer, install-time permission prompt = opt-in (unverified; app passed review). Two Suns Free has no location.
- **Returns and money:** "Funds are not captured from customers until the 48-hour return window has passed." Payouts on 1st, minimum $10, Garmin keeps 15% of tax-exclusive price. For returned apps Garmin may hold, set off or claw back funds. Merchants must be legal entity in supported country (Lithuania listed); $100 annual non-refundable fee. Prices localised per currency, not converted.
- **Mobile store:** purchases and installs moved to mobile app (Nov 2025, secondary source). Unverified whether store URL in description tappable there (affects D8's first-line sibling link).

## 3. Missing products in a device list

- Method: store part numbers vs each manifest product's SDK part numbers, live versions. No store part number lacks manifest product -> gaps real.
- HeroSet 1.3.0: 18 of 87 unlisted = 7 off paid list (fēnix 6S, FR945 LTE, Enduro, Instinct 2, 2S, 2X, Descent G1) + 11 on list. HeroSet 1.1.1 "14 of 80" = 3 + 11. HeroFace: 48 of 117 = 37 off list + same 11. Days To Go: 48 of 120, same split.
- **Most likely cause for 37 (evidence):** Garmin sells paid apps only on App Sales list; every one off it.
- **11 unexplained:** MARQ Gen 1 x8, Descent Mk2/Mk2i, Mk2 S, D2 Air X10 on list yet in no paid listing. Two free rival listings (GLANCE, EASY Round) offered on all of them -> restriction paid-specific. Inference: per-device paid-sale flag not shown on page. Garmin does not say.
- Store works per part number (fēnix 6 shows 1 of 4 SKUs): page lists models, store filters SKUs. `reach_by_product.md` corrected: free-only reach is 37, plus the 11.

## 4. Design guidelines Garmin publishes, and how we conform

| Topic and source | What Garmin says | Our practice | Finding |
|---|---|---|---|
| Watch faces: [user-experience-guidelines/watch-faces](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Watch_Faces.html) | Design for 8-colour, 64-colour or AMOLED; relative coordinates for 1:1 screens; AMOLED faces "expected" to support always-on; always-active partial updates under 20 ms; always-on: avoid much white or blue, thin fonts, minimise static elements, shift up to four pixels | All faces light-on-dark; always-on modes step 3x3 grid in proportional steps (about 15 px at 454 px) | **Gaps:** TwoSuns always-on text `#5555AA` (blue family, soft); HeroFace Pro seconds partial update never timed against 20 ms |
| Burn-in limits: [AMOLED FAQ](https://developer.garmin.com/connect-iq/articles/connect-iq-faq/How_Do_I_Make_a_Watch_Face_for_AMOLED_Products.html), [Entry Points](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Entry_Points.html) | Original Venu: over 10% pixels lit, or any pixel lit 3 minutes (Entry Points says four), turns screen off. Venu 2 and later: under 10% luminance. Simulator has "Screen Burn-in Simulation" heat map | Two Suns ADR-007 (always-on) and Days To Go ADR-007 (always-on) call 10% figure "uncited", use "lit-pixel share"/"three update cycles" | **Doc correction:** figure is Garmin-published; 3 vs 4 minute split = Garmin's own inconsistency; Venu 2+ is luminance not pixels. Heat map and wrist night still open (ROADMAP 3.1) |
| Visual design: [visual-design page](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Incorporating_the_Visual_Design_and_Product_Personalities.html) | 64-colour palette; FR45 and FR55 use eight colours; AMOLED uses light on black; prefer light-on-dark; system fonts readability-tested; keep text short | 64-colour-safe colours, black grounds, system fonts; FR55 in HeroFace and Days To Go manifests | **Gap:** no doc says how eight-colour FR55 renders our `#555555` track and `#AAAAAA` text (simulator screenshots looked at, not compared to eight colours) |
| Store images: [brand page](https://developer.garmin.com/brand-guidelines/connect-iq/) | 500x500 sRGB, 10 px padding, "Do not choose black or transparent backgrounds", "Steer clear of descriptive text anywhere on the icon"; watch-face preview often works best; 128x128 device icons (64 colours on MIP); hero 1440x720 | All four covers black or near-black; HeroSet, HeroFace, Two Suns covers carry app name as text, not face previews; Days To Go's = face preview on pure black | **Owner's call, not blocking:** guidance, not review gate (all four apps approved with these covers). MIP icon colour values not checked (no image library available) |
| Input and workflow: [workflows](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Designing_Workflows_and_Interactions.html) | Buttons beat touch with gloves, wet or in motion; avoid changing Back; up/down page loops; "Don’t require the user to use mobile app settings before they can use your app." | HeroSet press-only, no long-press (ADR-029, button rules); Days To Go works from presets without settings | Conforms by design. HeroSet's "Back after a lone dropped rep leaves the set" modifies Back: check against ADR-050 (Back after a lone dropped rep) |
| Glances: [core topic](https://developer.garmin.com/connect-iq/articles/core-topics/Glances.html) | 4.0+ apps need glance view to appear; limited glance memory (prose says 32 KB most devices); keep updates under 1 Hz; heavy work elsewhere | HeroSet glance closure about 5.4 KB, read-only, scope check script; our notes say 32 KB prose stale for 64 KB devices | Conforms. Garmin's page still says 32 KB |
| Localization: [localization](https://developer.garmin.com/connect-iq/articles/user-experience-guidelines/Localization.html) | "Supporting only English is not a localization strategy"; leave room for translations; respect unit and date locale | 15 languages, per-language fit tests | Conforms (languages covered: ours 15 of Garmin's 34) |
| Personality UI: [overview](https://developer.garmin.com/connect-iq/articles/personality-library/Personality_UI.html) | Style system and components (menus, prompts, toasts); use native menus, confirmations, progress bars | HeroSet draws own screens | **Not assessed:** whether HeroSet's menus use native components |
| Accessibility, touch-target sizes, round safe areas, power budget in numbers, watch-face review checklist | **Nothing found in pages read.** Workflows page gives only gloves/wet/motion rationale; "relative coordinates" only safe-area advice; review guidelines have no watch-face section (2a: do not hurt battery) | n/a | Not read: Understanding What You Are Building, Developing the Concepts, Menus, Confirmations, Progress Bars, Map Views, Data Fields |

## 5. Open unknowns

- Paid-to-paid and paid-to-free effects on buyers, ratings, downloads.
- Why 11 products on paid list not offered to paid apps.
- Whether twin ever treated as duplicate (no rule, no precedent found).
- Paid rival listing as control for 11 products (WP9 check): if also lacks MARQ Gen 1 and Descent Mk2 -> paid-only reading confirmed; if lists them -> cause on our side.
- Whether store URLs in descriptions work in mobile store; maxima for title, description, screenshot count.
- Full return-policy text.

## Suggested ROADMAP changes (not applied)

- Retire 2.1 (email Garmin); leftovers go to WP9 measurement (compare device lists after first Free approval).
- New agent task: HeroSet 1.3.1 text fix, remove Instinct 2/2S/2X and Descent G1 from description and What's New; same check for each Pro Instinct port; 7.8 trims site list.
- New: refund line in all paid listing drafts; fix listing template and `paste.md` to paste URL only in hardware field.
- New: doc corrections for burn-in figures (Two Suns ADR-007 (always-on), Days To Go ADR-007 (always-on), platform-facts) and note on eight-colour FR55.
- New owner task: decide on non-black store covers; run AMOLED heat map (3.1).
- New waiting item: merchant account renewal date.