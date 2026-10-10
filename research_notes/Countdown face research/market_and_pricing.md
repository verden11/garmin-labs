# The countdown niche in the store

Store API, 2026-09-26. Query set: `countdown`, `days until`, `event countdown`, `countdown days`, `days left`, `race countdown`,
`birthday countdown`, `vacation countdown`, `wedding countdown`, three pages each, de-duplicated: **464 unique faces**, **174** mention "countdown", "days until", "days left" or "days to" in name or first 400 characters of description.

## Who is there (top by downloads bucket)

| Face | Downloads | Reviews / ★ | Last update | Permissions | Price field |
|---|---|---|---|---|---|
| Countdown! | 100,000 | 204 / 4.1 | 2019-10 | none | free |
| New Year Countdown | 50,000 | 76 / 3.5 | 2023-12 | Positioning, SensorHistory, UserProfile | free |
| Event Countdown | 10,000 | 32 / 4.4 | **2026-03** (v1.1.3) | Positioning, SensorHistory, UserProfile | free |
| time2race (Countdown to race day) | 10,000 | 79 / 4.0 | 2020-03 | SensorHistory, UserProfile | free |
| Countdown (2016) | 1,000 | 11 / 4.0 | 2016-10 | none | free |
| Countdown - Watch & Track events | 1,000 | 11 / 5.0 | 2026-08 | Background, Communications, ComplicationSubscriber | free |
| UTVV Race Countdown | 1,000 | 1 / 5.0 | 2026-08 | 11 permissions incl. Positioning, Ant, BluetoothLowEnergy | free |
| WC26 Live: Scores & Countdown | 1,000 | 6 / 4.0 | 2026-08 | Background, Communications | free |

Reading: **three of four leaders stale** (2019, 2020, 2023); one live leader = metric dashboard (14 selectable metrics, four slots) asking location, sensor history, user profile. **No leader countdown-first**; only two with no permissions: 2016 and 2019 faces.

## Paid faces in the niche

`pricing` field filled for paid listings (checked on Goals Neon 2,49 €, Rondo 3,49 €, Rad-Lad 2,99 € etc.; `null` for free ones). **15 of 174** countdown-like faces paid (2,49–3,49 €). **All 15 at download bucket 10 or lower**:

Countdown 2,49 € (1) · Countdown 2,99 € (1) · Race Countdown Watch 2,69 € (1, one 5★) · Gold Countdown 2,99 € (10) · Blue Countdown 2,99 € (1) ·
Cap – Countdown to Your Day 2,69 € (10, one 5★) · World Cup 2026 Kick off Countdown 2,99 € (1, one 5★) · RocketTime 2,49 € (1) · Daylight 3,49 € (0) ·
and six single-event "Race Day" faces at 2,49 € (4DAAGSE, ATHX, Tough Mudder, Xenom, XletiX at 0–1; HYROX at 10 with two 5★).

Caveats: most look like recent or single-purpose uploads -> weak evidence about *good* paid countdown face; strong evidence **no paid countdown face broken out**, while free leaders reached 10,000–100,000.

## Free vs paid across all faces (from earlier research, not re-measured here)

`reports/Selling HeroSet and HeroFace.md`: free faces out-reach paid by median 10× (100,000 vs 10,000 downloads); no paid face in top 120 exceeds 100,000 bucket, 38 free faces at 500,000+; but free does not rank better (ranks 1–10: 7 paid, 3 free); working ladders "sell a paid version of the same face". Paid→free undocumented by Garmin; free→paid removes app for re-review, locks existing users out (Garmin, App Sales). Report's design brief for any new face: legible, per-device layout; **one honest store price with no unlock key**; settings that survive; day-one layouts for new hardware.

## Monetization rules that constrain a paid version (SDK `docs/Monetization/App_Sales.html`, 2026-09-26)

- Paid app "will only be offered on" products listed by tier: API 6.0, 5.2, 5.1, 5.0 and **3.4** lowest. Products below CIQ 3.4 and products not named not sold to. Only users in listed countries can buy (Americas, Africa, Europe, APAC lists; China, Russia not in them).
- Garmin keeps 15% of tax-exclusive price point; $100 annual merchant fee (merchant account already exists for HeroSet/HeroFace).
- Free app: none of these limits.

## What follows

- Niche real, served, but served product bad at its one job (see `rival_reviews.md`).
- Paid demand unproven, no paid countdown face has traction; free reach proven. Owner chose paid ($1.99) 2026-09-26; stands, evidence flagged as risk (spec "Price"). Build identical for both; choice made at submission.