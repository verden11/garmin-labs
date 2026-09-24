# Free watch face → paid app funnel on Connect IQ: evidence and operational cost

All store-API numbers in this file were pulled **2026-09-22** (API server clock
`1790093740000` = 2026-09-22 19:15 local) from
`https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps`.
`downloadCount` is a **quantized bucket**, observed values:
`0, 1, 10, 100, 1 000, 10 000, 50 000, 100 000, 500 000, 1 000 000, 5 000 000, 10 000 000`.
Every ratio derived from two buckets is therefore reported as a **range**, never a point.

Building on the already-verified facts in
`reports/Garmin watch face market gap.md` (15% of tax-exclusive price, $100/yr
merchant fee, price points $2.00–$100.00, trials not supported for watch faces,
51/120 top faces paid). Those are not re-derived here.

---

## Read this first: the premise of the question is not yet supported

### Takeaway
Both listings are **hours to one day old**. "0 downloads" is not evidence that
2,49 € is failing; it is evidence of no exposure yet. Any decision framed as
"paid isn't working, go free" is unsupported by the data that currently exists.

### Cited Findings
- HeroSet (`54bbf625-82af-4715-8af0-f2f16a5d1377`): `firstApprovalDate` = **2026-09-21 12:46**, `releaseDate` = 2026-09-21 18:59, `downloadCount` 0, `reviewCount` 0, `averageRating` 0, `pricing.salePrice.price` 2.49 €, `hasTrialMode` false — [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/54bbf625-82af-4715-8af0-f2f16a5d1377)
- HeroFace (`ad04d1e1-8e30-45cb-bbd6-82374f77b116`): `firstApprovalDate` = `releaseDate` = **2026-09-22 13:05** — approximately **six hours** before this snapshot. 0 downloads, 0 reviews, 2.49 € — [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116)

### Inferences
- The cheapest moment to flip HeroFace to free is now, at 0 installs — there is no
  install base to disrupt, no rating to risk, and no purchaser to refund. That
  asymmetry (cheap now, expensive later) is the strongest *operational* argument,
  and it is independent of the demand evidence below.

---

## Q1. Is there observable evidence that free Connect IQ faces convert into paid purchases?

### Takeaway
Yes — several developers run working free→paid ladders, and the paid sibling
lands **one to two download buckets below** the free flagship (per-pair ranges
0.2 % to 100 %, with most pairs in the low single digits to tens of percent).
But **every observed ladder sells a paid version of the same watch face**, not a
different app. Where a face funnels into a separate *app*, the attach rate is
only **0.2–10 %** even when that app is free — so price is not what limits
HeroFace→HeroSet.

### Cited Findings — MobileDriveway (developerId `9969f779-b3b1-4f2b-930b-e3786f8864a9`)
Ladder as measured 2026-09-22 (`price` = `pricing.salePrice.price`, € shown):

| Listing | Type | Price | downloadCount | reviewCount | firstApproval |
|---|---|---|---|---|---|
| GLANCE watch face (rank 7) | face | free | 1 000 000 | — | — |
| BIG EASY (rank 38) | face | free | 500 000 | 12 749 | 2022-09-28 |
| EASY Round (rank 26) | face | free | 500 000 | — | — |
| Glance Pro (rank 77) | face | **free** | 50 000 | 6 012 | 2022-01-13 |
| Glance Ultra (rank 40) | face | 5.99 | 10 000 | 1 683 | 2025-01-08 |
| EASY+ | face | 5.99 | 1 000 | 859 | 2025-03-12 |
| BIG EASY IQ | face | 5.99 | 1 000 | 752 | 2025-04-02 |
| HANDY IQ | face | 5.99 | 1 000 | 290 | 2025-06-11 |
| Universal App | **app (typeId 2)** | free | 10 000 | 1 018 | 2023-04-05 |
| HYDRATE+ | **app (typeId 2)** | free | 10 000 | 2 700 | 2023-05-30 |

Source: [ranking API, WATCHFACE, mostPopular, US](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE) plus per-app detail calls on the IDs linked from the free listings' descriptions.

- Correction to the brief: **Glance Pro is free**, not paid. Only Glance Ultra,
  EASY+, BIG EASY IQ and HANDY IQ carry a price. The ladder is 4 paid faces
  behind 4 free faces, with the two companion *apps* both free.
- The free flagships **do** push the paid siblings in copy, verbatim:
  - BIG EASY: *"If you enjoy this app, please consider switching to a new enhanced version - BIG EASY IQ. Right now it is on s[ale]…"*
  - EASY Round: *"Voted the Best Garmin Watch Face app of 2023! … NEW: I just released a new version of this watch face - EASY+."*
  - GLANCE: *"THE BEST WATCH FACE APP OF 2022 (Garmin rating). … 100% FREE."* — its description links 4 other appIds.
- Conversion proxy, GLANCE (1M bucket) → Glance Ultra (10k bucket): bucket
  arithmetic gives **0.2 % – 5.0 %** (`10 000/5 000 000` to `49 999/1 000 000`).

### Cited Findings — VAW.BE (developerId `5878eb2a-4c34-4f5a-be36-628c111aacef`), 15 entries in the top 120
- **The #1 most popular watch face in the US store is paid at exactly 2,49 €**: "Goals", `downloadCount` 100 000, `averageRating` 4.9, `reviewCount` **29 862**, `firstApprovalDate` 2025-04-04 — [detail](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/c4d24b8d-ecc2-4436-b14e-ce75b462e425)
- Its free sibling "Goals - with trial" (`0a933f67-…`, free in the store, rank 70): 100 000 downloads, 7 930 reviews, first approved **2021-11-29**. Description verbatim: *"After a 15 minute free trial, this clock costs only $1.99 (+VAT). Payment is handled by K-Pay and is possible via Paypal, Credit Card or Debit Card. Just follow the instructions on your watch when the trial ends."*
- "Goals Pro" 5.99 € — 1 000 downloads, 767 reviews, first approved 2026-07-08. Paired free K-Pay listing "Goals Pro - with trial" — 1 000 downloads, 408 reviews, same approval date.
- Other VAW.BE paid faces: Circles 2 (3.49 €, 10 000), Stride I (3.49 €, 10 000), Seasons Premium (5.99 €, 1 000), Photo Pro - Max license included (5.99 €, 1 000).
- **A near-analogue to HeroFace→HeroSet** (near, because it is typeId 3 / widget, not typeId 2 — see the caveat under Inferences): VAW.BE's free flagship faces list external-app complications, including *"Hourly Steps: current hour and daily progress - requires external app"*. That companion — **"Hourly Steps - Track Your Activity"**, typeId 3, **paid 2.49 €** — sits at `downloadCount` **100**, 70 reviews, first approved **2025-03-31** (≈18 months live), despite being surfaced by faces in the 100 000-download bucket. Its free-companion stablemates do far better: Rain (free, 100 000), Hydration PRO (free, 100 000), Time To Pray (typeId 2, free, 1 000).

### Cited Findings — TitanicTurtle, 19 entries in the top 120 (largest face publisher measured)
- Naming convention is explicit: `VX` = free trial build, `Elite` = paid.
  Tomahawk VX description verbatim: *"This is the trial version with an integrated trial p[eriod]"*; Fletcher VX: *"This is the trial version of the Fletcher watchface with more compatible devices and a long trial period."*
- Measured pairs (free → paid), 2026-09-22:
  - Tomahawk VX free 500 000 (21 644 reviews) → **Tomahawk Elite 3.99 €, 10 000** (977 reviews) → ratio **1 % – 10 %**
  - Vanguard VX free 100 000 → **Vanguard Elite 3.49 €, 50 000** (2 747 reviews) → ratio **10 % – 100 %**
  - Fletcher VX free 100 000 → **Fletcher Elite 3.49 €, 10 000** → ratio **2 % – 50 %**
  - Tactical Elite VX free 100 000 (7 257 reviews) → **Tactical Elite 4.69 €, 10 000**
  - Black Hawk VX free 10 000 → **Black Hawk Elite 3.49 €, 100 000** (ranks **5th overall**) — the paid listing outsells its own free trial build by a bucket.
- Its companion app (Atmos Weather, typeId 2, first approved 2026-09-10) is **free**, at 1 000 downloads, and is cross-linked from several free faces.

### Cited Findings — frinkr: a large publisher running *no* ladder at all
- frinkr holds **14 of the top 120 watch faces** (ranks 14, 22, 23, 25, 28, 29, 30,
  36, 37, 60, 65, 95, 112, 116) — the third-largest face publisher measured, after
  TitanicTurtle (19) and VAW.BE (15).
- **All 14 are free** (`pricing` null). Buckets: 500 000 ×6, 100 000 ×5, 50 000 ×3.
  Titles: Black Grid, Futura, Easy G1, Teko, Avak, GraVision, Falcon X, Helix,
  Fallout, Falcon Z, Envision II, Black Grid XT, Orbit II, INEVIT.
- No paid sibling, no trial build and no K-Pay variant appears anywhere in the top 120
  for this developer.
- Direct answer to the key question: **frinkr runs no free-to-paid ladder.** One of the
  store's biggest face publishers monetizes none of its top-120 catalogue through
  Garmin's system.

### Cited Findings — GreenBlack and PixelPathos
- GreenBlack: Fenix 8 V2 - GB free 100 000 → **Fenix 8 V2 - PRO - GB 5.99 €, 50 000** — ratio **10 % – 100 %**, tied with TitanicTurtle's Vanguard pair as the best-converting measured. Fenix8 V3 - GB free 100 000 → V3 PRO 5.99 €, 10 000 (**2 % – 50 %**). The free listing's copy pushes the paid one: *"⭐️⭐️ Exciting news: V3 is now available! ⭐️⭐️"*.
- PixelPathos: Crystal free 1 000 000 → Lumeo 2.99 €, 10 000 (**0.2 % – 5 %**); also Crystal Reborn 3.49 € at 1 000, and a KiezelPay free-trial variant "Lumeo (KiezelPay)" at 1 000.

### Inferences
- Ladders genuinely convert. Corrected bucket ranges per pair: GLANCE→Glance Ultra
  0.2–5 %, Crystal→Lumeo 0.2–5 %, Tomahawk VX→Elite 1–10 %, Fletcher VX→Elite 2–50 %,
  GreenBlack V3 2–50 %, Vanguard VX→Elite **10–100 %**, GreenBlack V2 **10–100 %**.
  Two of the seven pairs floor at 10 %, so the honest summary is **low single digits
  at the pessimistic end, tens of percent at the optimistic end** — not a tight
  1–10 % band.
- The dominant mechanism is **not** a loss-leader. It is a **trial workaround**:
  because "the app trials feature is not supported for watch faces", developers ship
  a *second, free* listing of the *same* face that self-enforces a trial and charges
  through a third-party processor (K-Pay / KiezelPay), or that upsells a paid
  "Pro/Elite/Ultra" listing of the same design. That sidesteps Garmin's 15 % as well.
- **HeroFace→HeroSet is a different shape.** Every high-converting ladder measured
  sells a *better version of the thing the user already installed*. The like-for-like
  comparison — a flagship face funnelling into a separate **typeId 2 app** — attaches
  at **low single digits**, even when that app is free: MobileDriveway's Universal App
  (typeId 2, free, 10 000, approved 2023-04-05) off GLANCE (1 000 000) = **0.2–5 %**,
  and HYDRATE+ (typeId 2, free, 10 000, approved 2023-05-30) off BIG EASY (500 000) =
  **1–10 %**. Both are mature listings. This says the binding constraint on face→app
  is the **attach rate, not the price**: even a free companion app captures only a few
  percent of the face's installs.
- Secondary, with a caveat: VAW.BE's Hourly Steps (paid 2,49 €) sits at 100 downloads
  after 18 months despite being surfaced by 100 000-bucket flagships. But it is
  **typeId 3 (widget), not typeId 2**, and 100 is exactly the median download bucket
  for paid widgets in the WIDGET top 120 — so it is at its own category's median, not
  anomalously low. Directional only.
- TitanicTurtle's companion app Atmos Weather (typeId 2, free, 1 000 downloads) was
  first approved **2026-09-10**, twelve days before this snapshot — that bucket in
  twelve days is fast, and it is far too young to read as an attach rate.
- Companion apps in this ecosystem are overwhelmingly **free** (Universal App,
  HYDRATE+, Atmos Weather, Time To Pray, Rain, Hydration PRO, CGM Connect, Air
  Quality Pro, Spot Price — all free). Developers appear to monetize the *face*, not the
  data source.

### Gaps
- No revenue figures anywhere. `downloadCount` on a paid listing is a purchase proxy
  only if downloads are counted post-purchase — Garmin does not document this.
- Cannot enumerate any developer's full catalogue: `developerId` is silently ignored
  and there is no search endpoint (`/asw/search/apps` → 404). The ladders above are
  reconstructed from top-120 membership plus appIds linked in descriptions, so each
  is a **lower bound** on that developer's listing count.

---

## Q2. Free vs paid download-bucket difference across the store

### Takeaway
For watch faces the gap is stark and measured: **free faces sit ~10× higher in
download bucket than paid faces** (median 100 000 vs 10 000). But free faces do
**not** rank better, and no equivalent number exists for watch apps.

### Cited Findings — top 120 WATCHFACE, mostPopular, US, 2026-09-22
- Split: **86 free / 34 paid** (the brief's 51/120 paid figure does not reproduce for `appType=WATCHFACE` on this date — flagging the conflict rather than picking).
- FREE (n=86): median `downloadCount` **100 000**, mean 408 953, min 10 000, max 5 000 000.
  Buckets: 10 000 ×2, 50 000 ×9, 100 000 ×37, 500 000 ×22, 1 000 000 ×15, 5 000 000 ×1.
- PAID (n=34): median `downloadCount` **10 000**, mean 19 471, min 1 000, max 100 000.
  Buckets: 1 000 ×2, 10 000 ×26, 50 000 ×4, 100 000 ×2.
- **Median ratio = 10×.** Bucket-range bound on that ratio: a free listing at the
  100 000 bucket vs a paid listing at the 10 000 bucket spans **2× – 50×**.
- Total reach: free listings account for 35 170 000 of the 35 832 000 downloads in
  the top 120 — **≈98 %** (a sum of quantized buckets, so approximate).
- Ceiling effect: **no paid watch face in the top 120 exceeds the 100 000 bucket**,
  while 38 free faces are at 500 000 or above.

Source: [WATCHFACE ranking API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE), pages at `startPageIndex` 0/30/60/90.

### Cited Findings — `appType` parameter values (verified 2026-09-22)
- **200 OK**: `WATCHFACE` (returns only `typeId` "1"), `DATAFIELD` (`typeId` "4"), `WIDGET` (`typeId` "3").
- **HTTP 400**: `WATCHAPP`, `APP`, `DEVICEAPP`, `WATCH_APP`, `DEVICE_APP`, `MUSICAPP`, `AUDIOCONTENTPROVIDER`, `APPLICATION`, `ALL`, and an intentional bogus value.
- Omitting `appType` returns a **mixed** list across typeIds 1/2/5, headed by Garmin
  and Spotify first-party listings.
- **There is no `appType` value that isolates watch apps (typeId 2).** No free-vs-paid
  reach figure for HeroSet's own category can be produced from this API.

### Cited Findings — DATAFIELD and WIDGET are unusable for this comparison
- DATAFIELD top 120: 75 free / 45 paid; free median download **10**, paid median **100** — paid *higher*.
- WIDGET top 120: 69 free / 51 paid; free median **10**, paid median **100** — paid *higher*.
- Cause is a sort artifact, visible in the rank deciles: for WIDGET, ranks 1–10 are
  10/10 free, ranks 11–60 are ~0/10 free (all paid), ranks 61–120 are ~10/10 free
  with downloads of 0–10. DATAFIELD shows the same block structure. The list is not
  a single continuous popularity ordering.

### Inferences
- The free-vs-paid reach multiplier for watch faces is real and large (**~10×
  median, bounded 2×–50×**), but it is a *correlation between price and install
  volume*, not proof that flipping a given listing's price moves its installs.
- The paid ceiling at 100 000 is the practically important number: a paid face's
  realistic upper bound in this store appears to be ~1–2 buckets below a successful
  free one.

### Gaps
- The DATAFIELD/WIDGET block structure suggests `mostPopular` is composite or
  segmented, and the mechanism is undocumented.

---

## Q3. Does a free listing rank differently from a paid one?

### Takeaway
**No — measured, and this is the finding that most cuts against going free.**
Paid faces are *over*-represented in the top 10, and the median rank of free and
paid faces is indistinguishable.

### Cited Findings (top 120 WATCHFACE, 2026-09-22)
- **Median rank: free 60, paid 62.** Effectively identical.
- **Ranks 1–10: 3 free, 7 paid.** Ranks 11–20: 6 free / 4 paid.
- Rank 1 overall is **paid at 2,49 €** (Goals, VAW.BE).
- Paid listings in the top 20: Goals 2.49 € (1), Pure Harmony TiM 2.49 € (3), Rondo 3.49 € (4), Black Hawk Elite 3.49 € (5), Rad-Lad 2.99 € (6), Vanguard Elite 3.49 € (8), Fenix 8 V3 PRO - GB 5.99 € (9), Fenix 8 V2 - PRO - GB 5.99 € (12), Tactical Elite 4.69 € (13), Tomahawk Elite 3.99 € (15), Circles 2 3.49 € (20).
- Free-per-decile count across the whole list: 3, 6, 9, 8, 10, 8, 7, 6, 7, 8, 8, 6 — free density is *lowest* at the top.

### Cited Findings — the "sticky lifetime installs" premise does not reproduce
- Black Hawk Elite: 100 000 downloads → **rank 5**. Instinct Mission: 1 000 000
  downloads → **rank 18**. Zenith: 500 000 → rank 16. Crystal: 1 000 000 → rank 17.
  Face It®: 5 000 000 → rank 2.
- A 1 000 000-install face ranking below a 100 000-install face is **not** a lifetime-install sort.
- **This contradicts the inherited premise** in `reports/Garmin watch face market gap.md`
  that "store ranking appears to be sticky lifetime-installs". Recorded as a conflict,
  not resolved.

### Cited Findings — ranking API depth cap (confirmed)
- `startPageIndex` 0/30/60/90 return 30 rows each; **120, 200, 300, 400, 500 all return `[]`**.
  The ranking API exposes exactly **120 rows** (4 × 30) per `appType`. This matches the
  "browse depth capped ~4 pages" note and makes the cap a hard measurement boundary.

### Inferences
- Whatever drives `mostPopular`, it visibly rewards recency and momentum over
  lifetime installs, and does **not** penalize a price. A paid listing can reach rank 1.
- Therefore "go free to rank better" is **not supported**. If free helps, it helps
  through raw install volume and word of mouth, not through the sort.

### Gaps
- Garmin publishes no description of the `mostPopular` algorithm. Everything above is
  observational, from one country (US) on one date.

---

## Q4. Operational cost of changing price on a live listing

### Takeaway
Garmin documents the **free→paid** direction only: the app is pulled from the store
for re-review, and existing users are told they must buy it. Garmin publishes **no
statement at all** on paid→free, on how long the removal lasts, or on what happens
to reviews, rating, download count or rank. Those are genuine gaps — do not assume symmetry.

### Cited Findings — Garmin's own words
- Verbatim, Connect IQ Monetization → App Sales, *App Reviews* section: *"Uploading an app requires a review process to verify it complies with the terms and conditions listed in the Connect IQ™ developer license agreement. **If you are setting a price for an app that has already been approved, the app is temporarily removed from the store so it can be reviewed again. After the app is approved, users receive a message explaining that they must purchase the app before they can use it again.**"* — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/) (source HTML: `https://developer.garmin.com/connect-iq/articles/monetization/App_Sales.html`)
- *"There is a set of available price points for monetized apps. These prices are tax-exclusive, and are the basis of the revenue split… **Garmin receives 15% of the tax-exclusive price point.** Garmin adds the sales tax onto the price point. Garmin is responsible for the credit card fees. The digital service taxes (if applicable) will be withheld from your payouts. The cost of conversion to the developer payout currency will be withheld from your payouts."* — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Payouts: *"Payouts are sent on the first day of every month… Funds are not captured from customers until the **48-hour return window** has passed. Purchases from the last five days of the month may not be included in the next payout… **Payouts require a minimum $10 USD balance in your account.**"* — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Monetized listings are only offered on a fixed device allow-list (API Level 5.x/6.0-era watches; the page enumerates them). A free listing has no such restriction.
- **Trap — do not demonetize by cancelling the merchant account**: *"When your merchant account is terminated, your monetized apps are **immediately demonetized**. Customers who have purchases still in their return window are allowed to request refunds. After your account termination is processed, **you must repeat all of the initial onboarding steps to become a merchant again, including payment of the program fee.**"* — [Account Management](https://developer.garmin.com/connect-iq/monetization/account-management/). This would demonetize **HeroSet as well as HeroFace** and cost another $100 to undo.
- Migrating existing purchasers is supported only in the other direction: *"If you are switching to the Connect IQ monetization system from a different monetization system, you can use this marketing form to request promotion codes to migrate users who have already purchased the app. These one-time-use codes allow existing users to purchase the app without additional cost."* — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)

### Inferences
- The documented free→paid penalty (*removed from store; existing users must buy it
  again*) makes the **reverse** flip the risky one to plan for. If HeroFace goes free
  and later goes paid, every free installer is locked out until they purchase — a
  guaranteed rating hit once there is an install base to annoy.
- Reversibility is therefore **technically yes, practically one-way once installs
  accumulate**. At 0 installs (today) the flip is free in both directions.
- The $10 payout minimum plus the 15 % cut means HeroSet at 2,49 € needs roughly
  **5 net sales in a month** before any money moves at all. That is the real floor
  the funnel has to clear, and it is low.

### Gaps
- **No Garmin statement on paid→free.** Whether it triggers the same re-review and
  the same store removal is undocumented. Ask Garmin developer support directly.
- **No stated duration** for the "temporarily removed" window. Do not estimate it.
- **No Garmin statement on whether reviews, `averageRating`, `downloadCount` or rank
  survive a price change.** Not inferable from the public API either: VAW.BE's paid
  "Goals" and free "Goals - with trial" are *separate appIds*, so they prove nothing
  about an in-place flip. HeroFace's current snapshot (0 / 0 / 0 / rank > 120) makes
  a clean before-and-after measurement trivially available if the flip is made.
- Suggestive but confounded: VAW.BE's native-paid "Goals" (approved 2025-04-04) has
  **29 862 reviews** versus 7 930 for its free K-Pay-trial sibling (approved
  2021-11-29) — roughly 4× the reviews in a third of the time. Consistent with the
  native paid listing outperforming free-plus-third-party-payment for the same face,
  but confounded by brand accumulation and by Garmin Pay's 2024 launch. **Suggestive, not measured.**

---

## Q5. What the developer dashboard exposes

### Takeaway
The only Garmin-documented reporting is a **sales report** under the Merchant
Account tab. There is no documented install, funnel or attribution view.

### Cited Findings
- *"When you are an approved merchant, the **Merchant Account tab on the developer dashboard allows you to update your banking information, request sales reports and tax forms, and cancel your account.**"* — [Account Management](https://developer.garmin.com/connect-iq/monetization/account-management/)
- App listing/upload lives on the same dashboard: *"To list your app, select **Upload an App** from the developer dashboard."* — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Garmin's submission page confirms only the review→publish loop, with no metrics claim: *"After you upload your app, Garmin will review it. While approval is pending, your app will not appear in the Connect IQ Store."* — [Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/)

### Inferences
- Public `downloadCount` from the store API is likely the developer's *best available*
  install signal for a free listing, since no install report is documented.

### Gaps
- What `apps-developer.garmin.com` actually renders (per-app download charts, country
  splits, version adoption) cannot be verified from here — it is behind
  authentication. **One minute of the developer looking at the dashboard settles this**;
  everything beyond the sales report is unverified.

---

## Bottom line

**Recommendation: keep HeroFace paid at 2,49 € and run a 30-day exposure test
first.** Near-zero installs after 30 days would mean the price was never the variable
under test — it would mean nobody saw the listing — so that outcome calls for fixing
discoverability, not for dropping the price. Flip to free only if HeroFace picks up
real installs (bucket 100+) *and* HeroSet fails to move with it: that is the one
pattern that shows reach rather than conversion is the bottleneck. If a flip is ever
made, make it while the install count is still small — the documented free→paid
penalty makes the reverse trip painful later.

Evidence for holding at 2,49 € (all **measured**, 2026-09-22):
1. The **#1 most popular watch face in the US store is paid at exactly 2,49 €**
   (Goals, 100 000 downloads, 29 862 reviews). The price point is not the blocker.
2. **Free does not rank better.** Ranks 1–10 are 7 paid / 3 free; median rank is 60
   (free) vs 62 (paid). "Go free to climb" is not supported.
3. **HeroFace is six hours old and HeroSet one day old.** Zero downloads is the
   expected value, not a verdict.
4. **Face→app attach is weak regardless of price.** Mature typeId 2 companion apps
   pull only **0.2–10 %** of their flagship face's installs even when they are
   **free** (Universal App off GLANCE, HYDRATE+ off BIG EASY). Making HeroFace free
   multiplies its reach, but the app attach rate is the limiting factor and price is
   not what sets it.
5. **frinkr**, the third-largest face publisher in the top 120, runs **14 free faces
   and zero paid listings** — "large free catalogue" and "working paid ladder" are
   not the same strategy.

Evidence for going free (also measured):
1. Free faces out-reach paid faces by a **median 10× (bounded 2×–50×)**, and **no
   paid face in the top 120 exceeds the 100 000 bucket** while 38 free ones do.
2. Working ladders exist. Per-pair conversion ranges run from **0.2–5 %** at the
   pessimistic end (MobileDriveway, PixelPathos) to **10–100 %** at the optimistic
   end (TitanicTurtle's Vanguard pair, GreenBlack's V2 pair).
3. Flipping is cheapest at 0 installs; the documented free→paid penalty (store
   removal + existing users must repurchase) makes the reverse flip painful later.

What is **inference**, not measurement: every conversion percentage (derived from
quantized buckets, hence ranges); the claim that ladders work *because* of the
trial mechanism; that companion apps are deliberately kept free; that
`downloadCount` on a paid listing proxies purchases.

What is a **genuine gap**: Garmin's paid→free policy, the removal duration, and
whether reviews/rating/downloads survive a price change. **Email Garmin developer
support before flipping anything** — that one answer changes the risk profile more
than any number in this file.

Tactical note independent of the price decision: the highest-yield change visible
in this data is not the price, it is the **description**. Every successful ladder
opens its free listing's description with an explicit link to the sibling
(`https://apps.garmin.com/apps/<appId>`). HeroFace's description *names* HeroSet
("or your HeroSet reps and rank, if you have it") but carries **no
`apps.garmin.com/apps/<appId>` link** — and that link is precisely what every working
ladder has. That is free to fix, requires no re-pricing, and no store removal.

---

## Measurement plan: what tells you within 30 days whether the choice was right

Bucketing **helps** at this scale. The download ladder starts `0 → 1 → 10 → 100 →
1 000`, so the first few hundred installs are genuinely readable day by day. This
is only true while the listings are small.

**Poll daily (cron, one curl each), log the date plus the four fields:**

```
GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116   # HeroFace
GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/54bbf625-82af-4715-8af0-f2f16a5d1377   # HeroSet
→ record: downloadCount, reviewCount, averageRating, releaseDate, pricing.salePrice.price
```

**Primary metric — the whole question in one number:**
> ΔHeroSet `downloadCount` **per** ΔHeroFace `downloadCount` over the window.

Decision rule at day 30:
- HeroFace still at bucket `0` or `1` → the price is not the variable being tested;
  fix discoverability (description cross-link, screenshots, device coverage) before
  touching price.
- HeroFace reaches `100`+ and HeroSet stays at `0` → the funnel does not carry, and
  going free would only multiply a conversion rate of zero. Matches the Hourly Steps
  precedent. Keep HeroFace paid.
- HeroFace reaches `100`+ and HeroSet moves with it → the funnel works at 2,49 €;
  flipping HeroFace to free trades ~10× reach for zero face revenue, and is then
  worth doing.

**Secondary metrics:**
- HeroFace `reviewCount` — moves in whole integers at low N, so it is a finer-grained
  install signal than the quantized `downloadCount`. First review is the real signal.
- `averageRating` — the guard rail. If it drops below ~4.0 the problem is the product,
  not the price.
- **Sales report**, Merchant Account tab of the developer dashboard — the only
  authoritative paid-side number, and the only way to separate purchases from
  re-downloads. Pull it monthly.
- Baseline comparators, same daily poll, to separate "our listing stalled" from
  "the whole store moved": `c4d24b8d-…` (Goals, paid 2,49 €) and a fresh paid face
  of similar age.

**Explicitly not a usable 30-day metric — rank.** The ranking API returns exactly
120 rows and `startPageIndex` ≥ 120 returns `[]` (verified 2026-09-22). HeroFace
cannot appear in it until it is top-120, which the measured bucket distribution
(a top-120 free face is typically at 100 000+ downloads) puts far outside 30 days.
Do not spend effort polling the ranking endpoint for these appIds.

**One non-API action, highest information per minute:** email Garmin developer
support asking, in writing, whether switching an approved paid app to free triggers
store removal and re-review, how long it takes, and whether reviews, rating and
download count are preserved. No public source answers this.
