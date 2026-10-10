# Countdown face research: notes

Snapshot **2026-09-26**. Sourced notes behind [`reports/Countdown face research.md`](../../reports/Countdown%20face%20research.md).
Store figures from Connect IQ store's own backend API; platform claims from installed SDK 9.2.0
docs (`~/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc`)
and Garmin forum threads. Every claim carries source. Anything not verified says so.

| File | What it holds |
|---|---|
| [`rival_reviews.md`](rival_reviews.md) | 349 text reviews of four leading countdown faces (plus three small ones): complaints, requests |
| [`market_and_pricing.md`](market_and_pricing.md) | Countdown niche in store: who is there, free vs paid, permissions, staleness |
| [`settings_and_dates.md`](settings_and_dates.md) | Why date setting breaks in Garmin Connect, what SDK documents, Beta Apps, on-watch settings, verified date arithmetic |
| [`devices_and_platform.md`](devices_and_platform.md) | Device set, screen shapes, memory (measured), fonts, AOD and MIP rules, review guidelines |
| [`naming_and_listing.md`](naming_and_listing.md) | Name candidates with store collision data, listing form facts, languages |

## Method and instruments

- **Store API** (no login): `https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=<q>&startPageIndex=<n>&pageSize=30&countryCode=US&appType=WATCHFACE`
  (`startPageIndex` acts as **item offset** on popularity list: 0, 30, 60, 90; on `/keywords` results repeat across
  pages -> de-duplicate by `id`). `pageSize` above 30 returns 400. `downloadCount` is a **bucket** (1, 10, 100, 1000, 10k, 100k, 500k, 1M, 5M).
  `pricing` filled for Garmin-merchant paid apps (`salePrice.formattedPrice`), `null` for free ones, incl. free apps that
  unlock through developer's own website. Reviews: `.../apps/<id>/reviews?startPageIndex=<offset>&pageSize=25&sortType=Rating|CreatedDate&ascending=true|false&withReviewTextOnly=true`.
- **Keyword search noisy** (relevance-ranked, capped near 90 results, matches descriptions). Counts of "faces named X" = lower bounds;
  "no result" not proof of no collision.
- **SDK**: device facts from `Devices/<id>/compiler.json` and `simulator.json`; API facts from `doc/Toybox/**` and `doc/docs/**`.
- **Simulator**: SDK 9.2.0 simulator run headless from shell (`connectiq`, then `monkeydo`); wedges every few runs
  (see `HeroFace/docs/development.md`) -> restart when run prints nothing.
- **Not done**: no device test (owner's FR965 has not seen this app), no phone test of Garmin Connect settings, no
  trademark search, no measurement of real store traffic.