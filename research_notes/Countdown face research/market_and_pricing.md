# The countdown niche in the store

Store API, 2026-09-26. Query set: `countdown`, `days until`, `event countdown`, `countdown days`, `days left`, `race countdown`,
`birthday countdown`, `vacation countdown`, `wedding countdown`, three pages each, de-duplicated: **464 unique faces**, of which
**174** mention "countdown", "days until", "days left" or "days to" in the name or the first 400 characters of the description.

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

Reading: **three of the four leaders are stale** (2019, 2020, 2023); the one live leader is a metric dashboard (14 selectable metrics,
four slots) that asks for location, sensor history and user profile. **No leader is countdown-first**, and the only two with no
permissions are the 2016 and 2019 faces.

## Paid faces in the niche

The `pricing` field is filled for paid listings (checked on Goals Neon 2,49 €, Rondo 3,49 €, Rad-Lad 2,99 € etc.; it is `null` for free
ones). **15 of the 174** countdown-like faces are paid (2,49–3,49 €). **All 15 sit at download bucket 10 or lower**:

Countdown 2,49 € (1) · Countdown 2,99 € (1) · Race Countdown Watch 2,69 € (1, one 5★) · Gold Countdown 2,99 € (10) · Blue Countdown 2,99 € (1) ·
Cap – Countdown to Your Day 2,69 € (10, one 5★) · World Cup 2026 Kick off Countdown 2,99 € (1, one 5★) · RocketTime 2,49 € (1) · Daylight 3,49 € (0) ·
and six single-event "Race Day" faces at 2,49 € (4DAAGSE, ATHX, Tough Mudder, Xenom, XletiX at 0–1; HYROX at 10 with two 5★).

Caveats: most look like recent or single-purpose uploads, so this is weak evidence about a *good* paid countdown face; it is
strong evidence that **no paid countdown face has broken out**, while the free leaders reached 10,000–100,000.

## Free vs paid across all faces (from earlier research, not re-measured here)

`reports/Selling HeroSet and HeroFace.md`: free faces out-reach paid faces by a median of 10× (100,000 vs 10,000 downloads); no paid
face in the top 120 exceeds the 100,000 bucket while 38 free faces sit at 500,000+; but free does not rank better (ranks 1–10 are
7 paid, 3 free) and the working ladders "sell a paid version of the same face". Paid→free is undocumented by Garmin; free→paid removes
the app for re-review and locks existing users out (Garmin, App Sales). That report's design brief for any new face: legible,
per-device layout; **one honest store price with no unlock key**; settings that survive; day-one layouts for new hardware.

## Monetization rules that constrain a paid version (SDK `docs/Monetization/App_Sales.html`, 2026-09-26)

- A paid app "will only be offered on" the products listed by tier: API 6.0, 5.2, 5.1, 5.0 and **3.4** as the lowest. Products below CIQ 3.4 and
  products not named are not sold to. Only users in the listed countries can buy (Americas, Africa, Europe and APAC lists; China and Russia are not in them).
- Garmin keeps 15% of the tax-exclusive price point; a $100 annual merchant fee applies (merchant account already exists for HeroSet/HeroFace).
- A free app has none of these limits.

## What follows

- The niche is real and served, but the served product is bad at its one job (see `rival_reviews.md`).
- Paid demand is unproven and no paid countdown face has traction; free reach is proven. The owner chose paid ($1.99) on 2026-09-26; that stands, with this evidence flagged as a risk (spec "Price"). The build is identical for both and the choice is made at submission.
