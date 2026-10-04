# Days To Go Pro research: notes

Behind [`reports/Days To Go Pro research.md`](../../reports/Days%20To%20Go%20Pro%20research.md) (ROADMAP 3.8). Read 2026-10-04 from the **public** Connect IQ store API only
(no login, no key, 3 s pause, the same endpoints `tools/store_poll.py` and the 2026-09-26 countdown research used). **26 HTTP requests in all**:
12 keyword pages (`countdown` x3, `days until` x2, `event countdown`, `days left`, `days since`, `retirement countdown`, `multiple events countdown`,
`pregnancy due date`, `countdown` without a type filter), 13 review pages (newest 25 reviews with text per listing; two listings had none) and 1 that
returned HTTP 400 (`appType=APP`; not retried). Raw JSON was kept outside the repo (scratch), the tables below are what was extracted.

| File | What it holds |
|---|---|
| [`store_tables.md`](store_tables.md) | The tables behind the report: free leaders, every store-priced countdown face, the external-unlock market, apps/widgets/data fields, our own listing |
| [`countdown_faces.csv`](countdown_faces.csv) | 103 listings whose name or first 500 description characters match a countdown phrase: id, name, price, payment, kind, download bucket, reviews, rating, `changedDate`, version, device types, permissions, `genuine` flag and why a row is not one |
| [`feature_mentions.md`](feature_mentions.md) | Word counts of what the 83 genuine listings' descriptions promise, split free / external unlock / store-paid / bucket 1,000+, with the regex used |
| [`review_quotes.csv`](review_quotes.csv) | 27 quotes (15 words or fewer each) with store id prefix, month, stars and app version, tagged by theme |

## Limits (read before quoting a number)

- `downloadCount` is a bucket, never a count. **Sales are not visible anywhere in the public data**; a free listing's bucket is installs, not purchases.
- Keyword search is noisy, capped, and ranked by relevance: the 103 rows are a lower bound, not the niche. A row marked `genuine` empty is a keyword match that is not an event countdown (reason in `note`).
- The `kind` column is a name regex (seasonal / fixed event versus generic); it has errors. The report's tables are hand-checked, the CSV is not.
- `changedDate` is not a trustworthy last-update date: 20+ old faces show 2026-08-24 to 28 next to a 2016 to 2023 version string.
- `device_types` is the keyword endpoint's count; the detail endpoint gives a different number for our own listing (199 against 96), so do not compare it across tools.
- Review text covers the newest 25 with text per listing (all of them for small listings); the 2026-09-26 corpus of 349 reviews (`../Countdown face research/rival_reviews.md`) is cited, not re-pulled.
- Not covered: app-type filter for watch apps (HTTP 400), the store's mobile-app view, any listing the keyword search did not rank, any non-English description.
