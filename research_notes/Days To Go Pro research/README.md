# Days To Go Pro research: notes

Behind [`reports/Days To Go Pro research.md`](../../reports/Days%20To%20Go%20Pro%20research.md) (ROADMAP 3.8). Read 2026-10-04 from **public** Connect IQ store API only
(no login, no key, 3 s pause, same endpoints `tools/store_poll.py` and 2026-09-26 countdown research used). **26 HTTP requests total**:
12 keyword pages (`countdown` x3, `days until` x2, `event countdown`, `days left`, `days since`, `retirement countdown`, `multiple events countdown`,
`pregnancy due date`, `countdown` without type filter), 13 review pages (newest 25 reviews with text per listing; two listings had none), 1 returned HTTP 400 (`appType=APP`; not retried). Raw JSON kept outside repo (scratch); tables below = extracted.

| File | What it holds |
|---|---|
| [`store_tables.md`](store_tables.md) | Tables behind report: free leaders, every store-priced countdown face, external-unlock market, apps/widgets/data fields, our own listing |
| [`countdown_faces.csv`](countdown_faces.csv) | 103 listings whose name or first 500 description characters match countdown phrase: id, name, price, payment, kind, download bucket, reviews, rating, `changedDate`, version, device types, permissions, `genuine` flag, why row is not one |
| [`feature_mentions.md`](feature_mentions.md) | Word counts of what 83 genuine listings' descriptions promise, split free / external unlock / store-paid / bucket 1,000+, with regex used |
| [`review_quotes.csv`](review_quotes.csv) | 27 quotes (15 words or fewer each) with store id prefix, month, stars, app version, tagged by theme |

## Limits (read before quoting a number)

- `downloadCount` = bucket, never count. **Sales not visible anywhere in public data**; free listing's bucket = installs, not purchases.
- Keyword search noisy, capped, ranked by relevance: 103 rows = lower bound, not the niche. Row marked `genuine` empty = keyword match that is not event countdown (reason in `note`).
- `kind` column = name regex (seasonal / fixed event versus generic); has errors. Report's tables hand-checked, CSV not.
- `changedDate` not trustworthy last-update date: 20+ old faces show 2026-08-24 to 28 next to 2016 to 2023 version string.
- `device_types` = keyword endpoint's count; detail endpoint gives different number for our own listing (199 against 96), so do not compare across tools.
- Review text covers newest 25 with text per listing (all for small listings); 2026-09-26 corpus of 349 reviews (`../Countdown face research/rival_reviews.md`) cited, not re-pulled.
- Not covered: app-type filter for watch apps (HTTP 400), store's mobile-app view, any listing keyword search did not rank, any non-English description.