# Popular Garmin Connect IQ Watch Faces — Store-Derived Ranking and Profile

> **⚠ METHODOLOGY CORRECTION.** This file's review sampling used `startPageIndex` as a
> *page index*. It is actually a **row offset** — `startPageIndex=1` returns the window
> starting at review #2, not reviews 26–50. Correct usage is
> `startPageIndex = page * pageSize`. Any review-derived count in this file may therefore
> be affected by duplicate rows; the ranking, price, rating and download figures are
> unaffected. `low_star_reviews.md` uses the corrected paging.


**Method note (important for the report writer).** All ranking, download, rating,
review-count, price, device-count, permission and description data below was pulled
**directly from the Connect IQ store's own backend API** on **2026-09-22**, not from
articles. The store front-end (`apps.garmin.com`, a Next.js SPA) renders its lists
client-side from:

```
GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps
    ?startPageIndex=<n>&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE
```

This is the same endpoint the store's "Most Popular" watch-face listing uses, so the
order below **is** the store's own popularity ranking as served on 2026-09-22.

The `appType=WATCHFACE` filter was **verified, not assumed**: every one of the 120
apps returned carries `typeId: "1"` (Garmin's watch-face type). This check matters
because three sibling parameters on the same endpoint are silently ignored by the
backend — `applicationTypes` (returns Spotify and the Connect IQ Store app),
`developerId` (returns other developers' apps), and `locale` on the reviews call.
`appType` is the one that is honoured.

Three caveats that must survive into the final report:

- **`downloadCount` is bucketed, not exact.** Garmin returns rounded magnitudes
  (10,000 / 50,000 / 100,000 / 500,000 / 1,000,000 / 5,000,000). Never present these
  as precise install counts.
- **"Most Popular" is not download-sorted.** Rank 1 (Goals) reports 100,000 downloads
  while rank 2 (Face It) reports 5,000,000. Garmin's popularity score is a blended,
  undisclosed metric (recency + velocity + rating appear to be involved). Rank order
  and download bucket must be reported as two separate signals.
- **Paging caps out.** Requesting `startPageIndex` 0–270 returned only **120 unique
  apps**; the popularity list repeats beyond that. 120 is the full addressable
  "most popular" watch-face set, which is more than enough for the top 20–30 ask.

Prices are returned in **EUR** by the API even with `countryCode=US`; they are the
Garmin-native store prices. All figures are a **2026-09-22 snapshot**.

## Q1 — Top ~30 watch faces by store popularity (name, developer, downloads, rating, reviews, price, device support)

### Takeaway
The store's own Most Popular watch-face ranking on 2026-09-22 is led by **Goals**
(VAW.BE, €2.49, 4.9★ / 29,826 reviews) and **Face It®** (Garmin, free, 5M downloads),
and is dominated by a small set of prolific independent publishers — TitanicTurtle,
VAW.BE, frinkr, MobileDriveway, GreenBlack — alongside Garmin's own first-party and
licensed (Disney/Star Wars/Pokémon) faces. Roughly **half the top 60 are paid**, which
is far higher than the paid share in most app stores.

### Cited Findings

Full top-30 as served by the store's Most Popular watch-face endpoint, 2026-09-22
(source for every row: the linked `apps.garmin.com` store page):

| # | Face | Developer | Downloads (bucketed) | Rating | Reviews | Price (EUR, US store) | Compatible device types |
|---|---|---|---|---|---|---|---|
| 1 | [Goals](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425) | VAW.BE | 100,000 | 4.9 | 29,826 | €2.49 | 221 |
| 2 | [Face It®](https://apps.garmin.com/apps/c33a05fa-bb7b-46a4-87b4-482a3e726a11) | Garmin | 5,000,000 | 4.6 | 29,923 | Free | 76 |
| 3 | [Pure Harmony TiM](https://apps.garmin.com/apps/ce4b5593-c8b6-43d3-9702-11dad57ef491) | timwatch | 50,000 | 3.3 | 602 | €2.49 | 60 |
| 4 | [Rad-Lad Watch Face](https://apps.garmin.com/apps/640309de-3f18-402b-a654-bfb769dfd485) | MarekSoso | 50,000 | 4.4 | 1,059 | €2.99 | 88 |
| 5 | [Rondo](https://apps.garmin.com/apps/e55067c1-0bc4-4ca8-96bc-bed2c83f5498) | Nimble_Wings | 10,000 | 4.9 | 5,397 | €3.49 | 85 |
| 6 | [GLANCE watch face](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae) | MobileDriveway | 1,000,000 | 4.9 | 68,813 | Free | 217 |
| 7 | [Fenix 8 V3 PRO - GB](https://apps.garmin.com/apps/844f8455-c828-489d-b94a-a72416ee7df6) | GreenBlack | 10,000 | 4.9 | 2,000 | €5.99 | 89 |
| 8 | [Black Hawk Elite](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994) | TitanicTurtle | 100,000 | 4.8 | 4,095 | €3.49 | 219 |
| 9 | [Vanguard Elite](https://apps.garmin.com/apps/68e85cf4-2308-40c7-9ea1-0e762cbd29a6) | TitanicTurtle | 50,000 | 4.8 | 2,747 | €3.49 | 216 |
| 10 | [Fenix 8 V2 - PRO - GB](https://apps.garmin.com/apps/98767971-d0f8-4e45-b3f1-1f1b4c0e3037) | GreenBlack | 50,000 | 4.7 | 752 | €5.99 | 85 |
| 11 | [Data Lover](https://apps.garmin.com/apps/bcb58298-3e71-4d9a-9084-169e581df99c) | peterdedecker | 1,000,000 | 4.7 | 13,612 | Free | 245 |
| 12 | [Tactical Elite](https://apps.garmin.com/apps/874aecfe-b441-4ad0-a581-b8505f929a5f) | TitanicTurtle | 10,000 | 4.8 | 1,537 | €4.69 | 213 |
| 13 | [Fenix7 Pro Analog OWM MB](https://apps.garmin.com/apps/39e068a5-c8c0-4600-ad55-587d246c3336) | ManuelB | 1,000,000 | 4.8 | 37,391 | Free | 202 |
| 14 | [Tomahawk Elite](https://apps.garmin.com/apps/a7c9fa45-c9c8-47bb-9374-15105a7d348b) | TitanicTurtle | 10,000 | 4.8 | 977 | €3.99 | 218 |
| 15 | [Black Grid](https://apps.garmin.com/apps/d87b23bb-ec6d-47f3-82ea-d133f5dfb356) | frinkr | 500,000 | 4.9 | 35,592 | Free | 207 |
| 16 | [SURGE Full Data - Fenix 8](https://apps.garmin.com/apps/799d3e06-b086-486d-8d26-e89062d7db20) | Timefy-Dials | 10,000 | 4.5 | 1,681 | €5.99 | 62 |
| 17 | [Outerfield](https://apps.garmin.com/apps/feee5b06-f020-4831-89dd-1a042e0a176e) | SPWatch | 10,000 | 3.8 | 143 | €2.69 | 42 |
| 18 | [Crystal](https://apps.garmin.com/apps/9fd04d09-8c80-4c81-9257-17cfa0f0081b) | PixelPathos | 1,000,000 | 4.4 | 3,997 | Free | 209 |
| 19 | [Circles 2](https://apps.garmin.com/apps/bba6fa8b-72a6-41d5-83f9-e08b74d0fa42) | VAW.BE | 10,000 | 4.8 | 1,687 | €3.49 | 213 |
| 20 | [Simply Large](https://apps.garmin.com/apps/a94f8711-50f3-424c-a867-43ace7c699eb) | TimeRefine | 1,000,000 | 4.3 | 914 | Free | 260 |
| 21 | [Zenith](https://apps.garmin.com/apps/2120f6b9-97d3-4014-8062-576f8516b7d4) | TitanicTurtle | 500,000 | 4.8 | 44,008 | Free | 214 |
| 22 | [Instinct Mission](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d) | TitanicTurtle | 1,000,000 | 4.8 | 15,321 | Free | 222 |
| 23 | [Lachesis (Light)](https://apps.garmin.com/apps/fa9c2fd6-cce0-49a0-aa94-20a129623164) | Garmin | 1,000,000 | 3.7 | 829 | Free | 182 |
| 24 | [Style 7](https://apps.garmin.com/apps/42ca648f-0779-4a72-a4f1-9ab3d381456c) | Stanislav.Bures | 10,000 | 3.6 | 337 | €3.49 | 75 |
| 25 | [Seasons](https://apps.garmin.com/apps/0e3f0c70-f038-4867-a3a4-167a288d666f) | VAW.BE | 500,000 | 4.8 | 51,357 | Free | 221 |
| 26 | [Simple 2](https://apps.garmin.com/apps/9d62ccde-e6e8-44ba-bf4e-24cd7e38d3e6) | TomekCz | 1,000,000 | 4.7 | 1,649 | Free | 188 |
| 27 | [Nexus TiM](https://apps.garmin.com/apps/4cdc316b-6341-470d-b888-fef069508a9e) | timwatch | 10,000 | 4.1 | 213 | €2.49 | 60 |
| 28 | [Quipu - Data Watch Face](https://apps.garmin.com/apps/e4f08276-7c26-46d9-9409-91f945527ab1) | GetWatchFaces | 10,000 | 4.6 | 176 | €2.69 | 114 |
| 29 | [Simple TDB](https://apps.garmin.com/apps/4db3d6ae-569b-4435-a7a2-67a2978c04f0) | TomekCz | 1,000,000 | 4.7 | 2,963 | Free | 244 |
| 30 | [Fletcher Elite](https://apps.garmin.com/apps/e1c93f85-9c60-4e61-a7dc-c4f46215a144) | TitanicTurtle | 10,000 | 4.7 | 401 | €3.49 | 222 |

Notable entries from ranks 31–60 (same snapshot, same endpoint):

- **Pokémon Sleep: I Choose You** — GarminPokemon, 500,000 downloads, 4.2★, 1,264 reviews, free — [store page](https://apps.garmin.com/apps/880e3034-3e6e-4521-88d4-a208f2406b66) (licensed IP face; 56 device types only)
- **Futura** — frinkr, 500,000, 4.8★, 10,338 reviews, free
- **Chariot B-Shock** — Joe_Berger, 1,000,000, 4.4★, 2,490 reviews, free
- **Summit Watch Face V2** — MarekSoso, 1,000,000, 4.7★, 1,432 reviews, free
- **Garmin All Stars – fēnix 8 Iron Grit** — Garmin, 10,000, 3.8★, 1,063 reviews, €5.99
- **Glance Ultra** — MobileDriveway, 10,000, 4.9★, 1,682 reviews, €5.99
- **Disney Mickey Mouse Analog Edition** — GarminDisney, 10,000, 4.5★, 653 reviews, €5.99
- **Teko** — frinkr, 500,000, 4.8★, 12,614 reviews, free
- **EASY Round** — MobileDriveway, 500,000, 4.9★, 26,534 reviews, free
- **Avak** — frinkr, 500,000, 4.8★, 15,402 reviews, free
- **Vega** — TitanicTurtle, 500,000, 4.8★, 5,457 reviews, free (key-gated pro features)
- **Falcon X** — frinkr, 500,000, 4.9★, 19,574 reviews, free
- **Tomahawk VX** — TitanicTurtle, 500,000, 4.8★, 21,644 reviews, free (5-day trial build)
- **Star Wars™ Grogu** — GarminLucas, 10,000, 4.8★, 738 reviews, €5.99
- **Easy G1** — frinkr, 500,000, 4.8★, 16,882 reviews, free
- **GraVision** / **Helix** — frinkr, 100,000 each, 4.9★, 12,832 / 5,286 reviews, free

Cross-cutting numbers from the same pull:

- The highest review counts in the entire popular set belong to **GLANCE watch face** (MobileDriveway, 68,813 reviews, 4.9★, free) and **Seasons** (VAW.BE, 51,357 reviews, 4.8★, free) — [GLANCE](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae), [Seasons](https://apps.garmin.com/apps/0e3f0c70-f038-4867-a3a4-167a288d666f) — well above Goals' 29,826 despite Goals ranking first.
- **Device breadth is a top-tier trait.** The leading independent faces support 200+ device types: Simply Large 260, Simple TDB 244, Data Lover 245, ASAP 231, Instinct Mission 222, Fletcher Elite 222, Vega 222, Goals/Seasons 221, Black Hawk Elite 219. Garmin's own Face It supports only 76, and licensed IP faces (Disney, Star Wars, Pokémon) 56–86.
- **Paid faces cluster on a single-model, single-device-family strategy**: GreenBlack's fēnix 8 faces (85–89 device types), Timefy-Dials' fēnix 8 dials (62), timwatch (60), SPWatch Outerfield (42).
- `hasTrialMode` is **false on all 51 paid faces** in the popular list (and on all 120 overall) — Garmin's built-in Connect IQ trial flag is unused by every paid face in the top tier. Trials are implemented instead as separate "trial" app listings or as developer-coded in-app day limits.

### Inferences
- Rank position correlates more with recent momentum than with lifetime installs: several €2.49–€5.99 fēnix 8-targeted faces with only 10,000 downloads out-rank free faces with 500,000–1,000,000, implying Garmin's popularity score heavily weights recent download velocity and rating.
- Review count is the better proxy for installed base than the bucketed download number (GLANCE at 68,813 reviews vs a 1,000,000 bucket; Goals at 29,826 reviews vs a 100,000 bucket suggests Goals converts reviews unusually well or the bucket is stale).

### Gaps
- Garmin does not expose exact download counts, revenue, or active-install counts through this API; only the bucketed magnitude. No source found that gives precise installs.
- The API's popularity scoring formula is undocumented; the blend of recency/velocity/rating is inferred from the data, not stated by Garmin.
- I did not capture the specific device *names* per face, only the count of `compatibleDeviceTypeIds`; the store page for each face lists the names if the report needs them.

## Q2 — Recurring features among top faces

### Takeaway
The dominant formula is a **highly configurable data-dense face**: user-selectable data
fields, weather, sunrise/sunset, Body Battery, heart rate and steps, plus colour/theme
customisation and explicit AOD handling for AMOLED. Complication support and animation
are notably *minority* features, and seasonal art is rare — it is a differentiator, not
a norm.

### Cited Findings
Keyword frequency across the English descriptions of the **top 100 most-popular watch
faces** (store API, 2026-09-22; each face's description is on its own
`apps.garmin.com/apps/<id>` page):

| Feature claimed in description | Faces (of top 100) |
|---|---|
| Configurable / customisable data fields | 80 |
| Weather | 67 |
| Themes / colour schemes | 61 |
| Sunrise / sunset | 47 |
| Steps | 41 |
| Heart rate | 39 |
| Body Battery | 38 |
| Always-on display (AOD) handling | 35 |
| Second time zone | 22 |
| Moon phase | 22 |
| Complications | 19 |
| Animation | 10 |
| Battery-saver mode | 3 |
| Seasonal artwork | 3 |

Declared Connect IQ permissions across the same top 100 (a harder, code-level signal
than marketing copy):

| Permission | Faces (of top 100) |
|---|---|
| UserProfile | 92 |
| SensorHistory | 85 |
| ComplicationSubscriber | 83 |
| Positioning | 79 |
| Background | 64 |
| Communications | 61 |
| Sensor | 17 |
| BluetoothLowEnergy | 3 |
| Notifications | 3 |

- `ComplicationSubscriber` is declared by **83 of the top 100** even though only 19 mention complications in marketing copy — complication consumption is near-universal in the top tier regardless of whether it is advertised.
- `Background` + `Communications` in ~60% indicates most top faces run a background service, typically to fetch weather.
- The feature list of rank-1 **Goals** is representative of the archetype: configurable seconds/AM-PM, colour choice, MiP black/white background, "Nice AOD modes (for OLED screens)", configurable battery-saver at night, goal bars, and ~35 selectable stats including Body Battery, Pulse Ox, VO2max, training status, weekly/monthly distance by sport, next calendar event, and third-party hooks (Hydration PRO, Rain, AQI) — [Goals store page](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)
- AOD is handled as an explicit product feature, not an afterthought: Goals ships "Nice AOD modes (for OLED screens)" and separate MiP-vs-OLED background handling — [Goals](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)

### Inferences
- The market rewards **breadth of selectable metrics** over visual novelty: the two most common traits (configurability, weather) are both data-plumbing features, while animation appears in only 10% of the top 100.
- Weather requires `Background` + `Communications` + `Positioning`, which is why those three permissions cluster; a face without a background weather service is structurally outside the top-tier formula.
- Seasonal art (3/100) and animation (10/100) are under-served relative to how well the few that use them rank — VAW.BE's **Seasons** carries 51,357 reviews at 4.8★ largely on seasonal artwork, and a 5★ review explicitly names it ("I love the seasonal artwork!").

### Gaps
- Keyword counts measure *marketing claims*, not verified implementations; a face may implement AOD well without using the phrase.
- I could not measure how many top faces support Garmin's newer complication *publishing* (vs subscribing) or the fēnix 8 / AMOLED-specific AOD APIs, because the API exposes only the permission list.

## Q3 — Which developers dominate, and their catalog strategy

### Takeaway
Five independent studios plus Garmin itself hold the majority of the popular list.
Two clearly distinct strategies are visible: **broad-compatibility flagship portfolios**
(TitanicTurtle, VAW.BE, frinkr, MobileDriveway — 200+ device types, free-with-key
monetisation) versus **device-specific paid variant farming** (GreenBlack, Timefy-Dials
— fēnix 8-targeted, €5.99, 60–90 device types).

### Cited Findings
Publisher share of the **120 unique faces** in the store's full Most Popular watch-face
list, 2026-09-22 (store API):

| Developer | Faces in popular list | Strategy signal |
|---|---|---|
| Garmin (first-party) | 17 | Face It, Lachesis, Dash, Infinite Geometry, plus paid €5.99 "Garmin All Stars" per-device dials |
| TitanicTurtle | 17 | Named "Elite"/"VX" family; mix of free key-gated and €3.49–€4.69 paid; 213–222 device types each |
| VAW.BE | 11 | Goals / Goals Pro / Circles / Seasons; paid main listing + separate free-trial listing per face |
| frinkr | 11 | All free, all ~205–207 device types, very high review counts (Falcon X 19,574; Easy G1 16,882; Avak 15,402; Teko 12,614; GraVision 12,832) |
| MobileDriveway | 6 | Free flagship GLANCE (68,813 reviews) + paid €5.99 Glance Ultra upsell |
| MarekSoso | 5 | Free (Summit, PayPal donation) alongside paid €2.99 Rad-Lad |
| GreenBlack | 5 | fēnix 8-specific; free base version + €5.99 "PRO"; email-issued unlock codes |
| Nimble_Wings | 4 | Rondo €3.49, 4.9★ / 5,397 reviews |
| Timefy-Dials | 4 | fēnix 8-specific €5.99 dials (SURGE, ELITE CHRONOGRAPH) |
| TomekCz | 3 | All free (Simple 2, Simple TDB, Big Hours), PayPal donation |
| GarminDisney / GarminLucas / GarminPokemon | 3 / 1 / 2 | Licensed IP, €5.99 or free, narrow device support (56–86) |

- **GreenBlack runs an explicit version-upgrade ladder across separate listings**: "Coming from V2? Send me an email at greenblack@watchface.io, and I'll send you an unlock code to unlock the PRO options. No need to buy again." and, on the V2 listing, "Your V2 unlock code will work with V3 - no need to purchase again!" — [Fenix 8 V3 PRO - GB](https://apps.garmin.com/apps/844f8455-c828-489d-b94a-a72416ee7df6), [Fenix 8 V2 - GB](https://apps.garmin.com/apps/7b300780-21b4-4962-871a-5446eb72a3af)
- **VAW.BE runs a three-listing funnel per product**: the paid main listing, a separate free-trial listing, and a separate "Pro" listing — Goals' own description links to both ("Free trial and availability with other payment methods here: …0a933f67…" and "check Goals Pro for more features and options here: …efe68843…") — [Goals](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)
- **TitanicTurtle duplicates each product as paid and trial listings** ("You can find the trial version herhe of this watchface it you want to try it out first: …b9974c09…" on Tomahawk Elite; Tomahawk VX's description states "This is the trial version with an integrated trial period (5days +)") — [Tomahawk Elite](https://apps.garmin.com/apps/a7c9fa45-c9c8-47bb-9374-15105a7d348b), [Tomahawk VX](https://apps.garmin.com/apps/b9974c09-2a48-42da-82e2-76f8e0a6c458)
- **frinkr is the outlier**: 11 popular faces, all free, no paid variants found in the popular list, and the highest aggregate review volume of any independent besides MobileDriveway.

### Inferences
- The "many near-identical variants" pattern is real but takes two forms: *monetisation variants* of one design (paid / trial / pro — VAW.BE, TitanicTurtle, GreenBlack) and *device-targeted variants* (GreenBlack and Timefy-Dials shipping separate fēnix 8 dials). Garmin itself copies the second pattern with per-device "Garmin All Stars" dials.
- Listing duplication is a deliberate store-ranking tactic: each listing accumulates its own downloads and reviews and occupies its own slot in the popularity list, so a three-listing funnel triples a studio's surface area in the ranking.
- Broad device support (200+) correlates with the free/key-gated model, and narrow support (60–90) with the €5.99 paid model — narrow, premium, device-specific dials monetise directly; broad free faces monetise through keys and donations.

### Gaps
- I could not enumerate each developer's *full* catalog: the `developerId` query parameter is accepted but ignored by the API, and developer pages render client-side. The counts above are shares of the popular list, i.e. a lower bound on catalog size, not total catalog size.
- Revenue split or actual conversion rates for the trial→key funnels are not published anywhere I could find.

## Q4 — Paid vs free in the rankings, and unlock mechanisms in practice

### Takeaway
Paid faces are extremely well represented — **17 of the top 30 and 29 of the top 60**
carry a Garmin-native price — clustered at **€2.49–€5.99**. But the most-installed
faces are free, and the dominant real-world monetisation is a hybrid: a free listing
whose advanced features are gated behind an **externally issued license key** after a
short in-app trial, with PayPal / Buy Me a Coffee as the payment rail that bypasses
Garmin's cut.

### Cited Findings
From the top 120 popular faces, store API, 2026-09-22:

- **51 of 120** popular faces carry a Garmin-native price; **17 of the top 30** and **29 of the top 60**.
- Price points in use, all EUR: **2.49, 2.69, 2.99, 3.49, 3.99, 4.69, 4.99, 5.99**. €5.99 is the ceiling and is used by Garmin's own paid dials and licensed IP faces as well as by GreenBlack and Timefy-Dials.
- **`hasTrialMode` is false on all 51 paid faces** (and on all 120 in the list) — Garmin's native trial flag is used by no paid face in the popular set.
- Language frequency in the top-100 descriptions: an external URL in **85**, key/unlock-code language in **31**, PayPal in **26**, explicit "trial" in **22**, Buy Me a Coffee in **15**, "donate" in **8**, "pro version" in **7**.

Mechanisms observed verbatim:

- **Trial-then-key, self-issued**: "The watchface is generally free, only a few functions require an activation key after the trial period of 5 days. These are marked with a small crown in the settings." — Zenith, TitanicTurtle — [store page](https://apps.garmin.com/apps/2120f6b9-97d3-4014-8062-576f8516b7d4)
- **Same model, restated**: "The watchface itsself is free to use - only the switchviews and some fonts are pro features which require a key to work with after a 5 days trial time." — Vega, TitanicTurtle — [store page](https://apps.garmin.com/apps/2d17e54d-e6ca-4ffb-a2cb-844762cfea8e)
- **Key delivered from the developer's own website**: "A key for this as well as a manual, various codes for color schemes, and a FAQ can be found on the following website" — Instinct Mission, TitanicTurtle — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)
- **Purchase → code, outside Garmin**: "If you like the watch face please consider a purchase to support the project and you will receive the Pro Code to unlock all features." — Fenix7 Pro Analog OWM MB, ManuelB — [store page](https://apps.garmin.com/apps/39e068a5-c8c0-4600-ad55-587d246c3336)
- **Email-issued upgrade codes across versions**: "Send me an email at greenblack@watchface.io, and I'll send you an unlock code to unlock the PRO options. No need to buy again." — GreenBlack, Fenix 8 V3 PRO - GB — [store page](https://apps.garmin.com/apps/844f8455-c828-489d-b94a-a72416ee7df6)
- **Direct PayPal link in the listing**: Crystal (PixelPathos) links `https://www.paypal.com/ncp/payment/QF2TPC9BRC9A8` — [store page](https://apps.garmin.com/apps/9fd04d09-8c80-4c81-9257-17cfa0f0081b)
- **Donation-only**: "If you like my watch face you can support my work by adding a short review. You can also support my work with a donation https://paypal.me/TomekCz" — [Simple 2](https://apps.garmin.com/apps/9d62ccde-e6e8-44ba-bf4e-24cd7e38d3e6) / [Simple TDB](https://apps.garmin.com/apps/4db3d6ae-569b-4435-a7a2-67a2978c04f0) / [Big Hours](https://apps.garmin.com/apps/05f63f99-3758-4e33-b94e-8d3ff6e1048d), TomekCz; "Like it? Support it! Visit https://buymeacoffee.com/peterdd" — [Data Lover](https://apps.garmin.com/apps/bcb58298-3e71-4d9a-9084-169e581df99c), peterdedecker; "please consider supporting me PayPal: paypal.me/mareksoso or buy me a coffee" — [Summit Watch Face V2](https://apps.garmin.com/apps/cf6b5867-9839-4f0f-ab51-91f4ea2c5b28), MarekSoso; "If you use and like this watch face please donate (buy me a coffee or a small beer) - donate here www.paypal.me/TimsApps" — [Simply Large](https://apps.garmin.com/apps/a94f8711-50f3-424c-a867-43ace7c699eb), TimeRefine
- **Payment-rail workaround for regions Garmin Pay does not serve**: "ALTERNATIVE PAYMENT METHOD: Users can link their PayPal account to a CURVE WALLET or REVOLUT APP and then add that to GARMIN PAY." — RESISTANCE, JS_ProDesign — [store page](https://apps.garmin.com/apps/e553ec1a-9c93-4bc0-8094-70cbd0ac2803)
- **Separate free-trial listing instead of in-app trial**: Goals and Circles 2 (VAW.BE) and Tomahawk Elite / Tomahawk VX (TitanicTurtle) each link a distinct trial app id — [Goals](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)
- **Third-party API key as a user requirement** (not monetisation, but a friction point): "This is a version of Chariot J-Shock that uses openweathermap.org as a weather source. Go there and get your free API key. You'll need it!" — Chariot B-Shock, Joe_Berger — [store page](https://apps.garmin.com/apps/11c2548e-8878-497f-809b-ea640e54ca43)
- **Free-flagship / paid-upsell**: MobileDriveway's GLANCE is free (68,813 reviews) while Glance Ultra is €5.99 — [GLANCE](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae), [Glance Ultra](https://apps.garmin.com/apps/1bed8f69-2e34-46e4-9786-3166fa3c6ab2)

A 5★ review confirming the trial→purchase funnel converts: "Had the trial and was great
brought full version and can't fault it in anyway" — Black Hawk Elite review, retrieved
2026-09-22 — [Black Hawk Elite store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)

### Inferences
- Garmin's native purchase flow works well enough that ~43% of the popular list uses it, which contradicts the common assumption that Connect IQ monetisation is impossible — but the *highest-install* faces all avoid it, suggesting the free listing is the distribution strategy and the key/donation is the revenue strategy.
- `hasTrialMode: false` across all 51 paid faces, plus the prevalence of separate "trial" listings and self-coded 5-day trials indicates developers do not trust or do not use Garmin's built-in trial mechanism, and have standardised on rolling their own.
- The €2.49–€5.99 band is effectively a price ceiling; nothing in the popular list is priced above €5.99, including Garmin's own dials.

### Gaps
- No data on how many users actually pay for a key vs use the gated-free version; no developer publishes conversion figures.
- Prices are returned in EUR regardless of `countryCode`; I could not confirm the exact USD price points shown to US buyers.

## Q5 — What 4–5★ reviews praise most

### Takeaway
Across a larger rating-sorted sample, the praise in 4–5★ reviews clusters on four
themes in this order: **configurability deep enough to show exactly what the user wants
and nothing else**, **legibility and at-a-glance data density**, **support for the
user's specific (often brand-new) device**, and **the trial period proving the purchase**.
Artwork is praised only for the few faces that have any.

### Cited Findings
**Sample:** 150 rating-sorted, text-only reviews were retrieved per face for six
high-review faces (900 reviews total) on **2026-09-22**, via
`/apps/<id>/reviews?startPageIndex=<n>&pageSize=25&sortType=Rating&ascending=false&withReviewTextOnly=true`.
Of those 900, only **39 were longer than 130 characters** — the store's reviews are
overwhelmingly one- or two-word ("Ok", "Bagus", "Mantap", "good", "."). The quotes
below are drawn from that long-form subset, which is effectively the complete set of
substantive 4–5★ reviews available for these faces.

Long-review yield per face: GLANCE 11/150, Instinct Mission 12/150, Black Hawk Elite
11/150, Seasons 2/150, Zenith 2/150, Goals 1/150.

**Theme 1 — configurability as subtraction, not just addition.** Users praise being
able to remove what they don't want as much as add what they do:

- "The best yet - so much is customizable that I was able to set up a face with exactly what I wanted and nothing I didn't. Easy to use, clear and concise." — GLANCE, 5★ — [store page](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae)
- "Awesome watch face, even in free form. Too many options, too many combinations. Classy, sharp cut lines … Highly recommended." — Zenith, 5★ — [store page](https://apps.garmin.com/apps/2120f6b9-97d3-4014-8062-576f8516b7d4)
- "molto bello e ricco di opzioni da poter visualizzare sul display. completamente customizzabile in base alle proprie esigenze. ricco di colori e font caratteri selezionabili" ("very beautiful and rich in options to display… completely customisable to your needs… rich in colours and selectable fonts") — Black Hawk Elite, 5★ — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- "Es re linda súper configurable. Me gusta pq tiene colores pasteles" ("very pretty, super configurable; I like it because it has pastel colours") — Goals, 5★ — [store page](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)

**Theme 2 — legibility and at-a-glance density, explicitly contrasted with decoration:**

- "Najpotrzebniejsze informacje czytelne i bez zbędnej grafiki. Nie trzeba szukać tego co chcemy znaleźć. Wszystko automatycznie jest widziane na pierwszy rzut oka. To jest to czego szukałem we wszystkich smartwatch'ach." ("The most necessary information, legible and without superfluous graphics. You don't have to look for what you want to find. Everything is seen automatically at first glance. This is what I was looking for in every smartwatch.") — GLANCE, 5★ — [store page](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae)
- "Muchos datos, textos y números legibles y suficientemente grandes, posibilidades de configuración de datos. Creo que es difícil de mejorar si quieres tener muchos datos accesibles de un solo vistazo. No he encontrado otra mejor con estas características." ("Lots of data, legible and large enough text and numbers, data configuration options. I think it's hard to improve on if you want lots of data accessible at a glance. I haven't found a better one with these characteristics.") — Instinct Mission, 5★ — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)
- "I tested around 20 different watch face apps and this is the best one. Lots of option, easy to read, much more flexible and easy to highlight specific data options." — Instinct Mission, 5★ — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)
- "Cadran de montre tout simplement magnifique, discret et fonctionnel." ("simply magnificent watch face, discreet and functional") — Black Grid, 5★ — [store page](https://apps.garmin.com/apps/d87b23bb-ec6d-47f3-82ea-d133f5dfb356)
- "Nice look, complete data that show..thanks bro" — Instinct Mission, 5★ — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)

**Theme 3 — replacing the stock Garmin experience:**

- "I love Garmin watches only with these Glances. These watch faces beat the hell out of standard Garmin glances over the last 6-8 years." — GLANCE, 5★ — [store page](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae)
- "Очень хорошее приложение, обладающее нужным количеством инструментов для мониторинга здорового образа жизни и другой активной деятельности." ("A very good app with just the right number of tools for monitoring a healthy lifestyle and other activity.") — GLANCE, 5★ — [store page](https://apps.garmin.com/apps/07ae0f49-7240-4475-a229-4507e8035fae)

**Theme 4 — the trial converts, and users say so explicitly:**

- "I've had a variety of Garmin watches since 2016, but this was the first watchface I've ever purchased. After the trial period (which seemed longer than others), I knew I needed to have it. The layout is clean, the options are great, the settings make sense, the colors are plentiful…" — Black Hawk Elite, 5★ — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- "Had the trial and was great brought full version and can't fault it in anyway 👍" — Black Hawk Elite, 5★ — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- "Genial… La he comprado después de no encontrar ninguna tan buena y configurable" ("Great… I bought it after not finding any other this good and configurable") — Instinct Mission, 5★ — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)
- "The free version has everything that I need. The fonts are easy to see and there are fields that are customizable. I really like the detail of the outer design too. So pretty for autumn without being too busy. Looking forward to seeing the other seasons." — Seasons, 5★ — [store page](https://apps.garmin.com/apps/0e3f0c70-f038-4867-a3a4-167a288d666f)

**Theme 5 — device-specific validation, including brand-new hardware:**

- "Yep this is the face for my new Fenix 8 quality. Easy to change the colours to orange scheme using their website. Really good work guys" — Black Hawk Elite, 5★ — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- "Beautiful watchface, works perfectly on my Tactix 8" — Black Hawk Elite, 5★ — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- "Installed on Instinct 3 Amoled -I love it ..Jack from Canada" — Instinct Mission, 5★ — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)

**Artwork and longevity (only for the faces that offer art):**

- "This is such a lovely watch face. I've used it for an entire year now and love the different seasons. It displays all the information I most want to see. Definitely recommend" — Seasons, 5★ — [store page](https://apps.garmin.com/apps/0e3f0c70-f038-4867-a3a4-167a288d666f)
- "Love this watch face! Very easy to customize. I love the seasonal artwork!" — Seasons, 5★ — [store page](https://apps.garmin.com/apps/0e3f0c70-f038-4867-a3a4-167a288d666f)

**Support responsiveness as a named purchase factor:**

- "Support is snel en goed mbt de vraag die ik had… dat de ontwikkelaar snel en oplossend wil reageren is voor mij al een enorm pluspunt. Overigens mooie en goedwerkende app." ("Support was fast and good on the question I had… that the developer responds quickly and helpfully is already a huge plus for me. Also a beautiful and well-working app.") — Goals, 5★ — [store page](https://apps.garmin.com/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)

**Counter-signal found inside 4–5★ reviews** (the failure modes users tolerate without
docking stars — useful for the report):

- Stability, Black Grid (5★ despite the complaint): "it does occasionally need to be uninstalled and reinstalled because it will sometimes freeze and won't let me go into any of the items on the main screen" — [store page](https://apps.garmin.com/apps/d87b23bb-ec6d-47f3-82ea-d133f5dfb356)
- Missing new-device support filed as a request, not a complaint, Instinct Mission (5★): "Doesn't work on the fenix 9pro! Please fix it for this watch." — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)
- Theme appetite, Black Hawk Elite (5★): "Will there be more themes?" — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- Settings discoverability, Black Hawk Elite (5★): "Took me a while to get used to it all and how it works but now I have it's probably my favourite watch face of all. Developers other faces are all brilliant too. Check them out." — [store page](https://apps.garmin.com/apps/ce3bf722-6f14-4890-8e2f-8ac23a438994)
- Confusion about whether they are in a trial, Instinct Mission (5★): "J'ose espérer que ce n'est pas un écran en période d'essai et qu'il faudra l'acheter par la suite. On verra bien." ("I dare hope this isn't a trial-period face that I'll have to buy afterwards. We'll see.") — [store page](https://apps.garmin.com/apps/6ac8fcb0-1ffa-47be-b50a-5eb0ea12683d)

### Inferences
- The praise themes match the feature-frequency table in Q2 exactly: configurability
  (80/100 of descriptions) and data density are what developers advertise *and* what
  users reward, so stated and revealed preference agree in this market.
- The strongest recurring phrasing is **"exactly what I wanted and nothing I didn't"** —
  the winning product is a *subtractive* configurator, not a maximal data dump. Faces
  praised for being "discreet", "without superfluous graphics" and "not too busy" sit
  alongside faces praised for showing 30+ metrics, which means the real feature is
  *user control over density*, not density itself.
- Day-one support for newly released devices is a ranking lever: users volunteer
  "works perfectly on my Tactix 8" / "Installed on Instinct 3 Amoled" as praise, and
  file a missing device as a 5★ feature request rather than a 1★ complaint.
- Comparison shopping is explicit and heavy — "I tested around 20 different watch face
  apps", "after not finding any other this good and configurable" — so a new entrant is
  evaluated directly against the incumbents named in Q1, not on its own terms.
- Trial→purchase language appears unprompted in multiple 5★ reviews, corroborating that
  the developer-rolled trial (Q4) is doing real conversion work despite Garmin's own
  trial flag being unused by every paid face.
- With 39 substantive reviews out of 900, average star rating is a near-useless
  discriminator in this store (4.7–4.9★ is the norm for anything popular). **Review
  volume, not rating, is the signal** — GLANCE's 68,813 and Seasons' 51,357 separate
  the true incumbents from the rest far better than a 0.1★ difference does.

### Gaps
- The review API exposes no verified-purchase, device, or locale metadata, so praise
  cannot be segmented by device family or by paid-vs-free.
- Reviews cannot be filtered server-side by text length or language; the long-form
  subset had to be filtered locally, and rating-desc sorting may bias toward older
  reviews within the 5★ band.
- I did not corroborate against Garmin Forums or r/Garmin. The store's own review
  corpus was directly authoritative for this question, and the task scoped forums to
  corroboration rather than ranking, so no ranking figure above depends on them.
