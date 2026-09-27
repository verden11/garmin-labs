# Market and pricing: Body Battery and sun faces

Store API, 2026-09-26. 1,378 unique watch faces from 20 queries (method in `README.md`; every row in `store_survey.csv`). Download counts are **buckets** (the lower bound: 1, 10, 100, 1,000, 10,000, 50,000, 100,000, 500,000). Prices come back in euro; 2.49 € is the USD 2.00 tier.

## How crowded

| | Faces |
|---|---|
| Description mentions Body Battery | 482 |
| Description mentions sunrise, sunset or daylight | 588 |
| Both | 282 (52 of them at 1,000+ downloads, 7 at 10,000+) |

Almost every "both" face is a 14-to-40-field dashboard where Body Battery and sunrise are two of many slots. The earlier repo research already said it: *"we expose Body Battery" is not a differentiator, presentation is* (`Garmin watch face market gap/trends.md`). **No face found is built around the relationship between the two.**

## Leaders where Body Battery or sun is the *point* of the face

| Face | Downloads | Reviews / ★ | Updated | Price | Permissions | What it is |
|---|---|---|---|---|---|---|
| Pokémon Sleep: I Choose You / Snorlax & Friends (Garmin) | 500,000 / 100,000 | 1,274 / 4.2 and 1,698 / 4.9 | 2026-09 | free | UserProfile, ComplicationSubscriber | 48 Pokémon whose **pose follows Body Battery**; night mode 90 min before bed |
| HandsFive | 100,000 | 775 / 4.7 | 2024-12 | free | Positioning, SensorHistory, UserProfile | Analog with a sunrise/sunset dial and many fields |
| Sundance | 10,000 | 144 / 4.6 | 2026-06 | free | Positioning, SensorHistory, UserProfile | 24 h dial: daylight ring, golden/blue hour, sun info |
| Sun Dial 24 | 10,000 | 71 / 4.6 | 2026-08 | free | Positioning, Background, SensorHistory, UserProfile, Communications | 24 h solar dial: sun position, moon phase, weather |
| Energy Face | 10,000 | 123 / 4.6 | 2020-07 | free | Positioning, Background, SensorHistory, Communications | Dashboard with sunrise/sunset, moon |
| Night & Day | 50,000 | 96 / 4.1 | 2026-09 | free (features unlocked on the developer's site) | Positioning, Background, SensorHistory, UserProfile, Communications | Day/night dashboard; **its 1★ and 2★ reviews are about paying on an outside site** |
| Sun Watch Toutou | 1,000 | 48 / 4.5 | 2022-08 | free | Positioning | Sun position on a sea scene |
| Solarium (Sun Tracker) | 1,000 | 29 / 4.3 | 2026-09 | store price "free", **$5.99 via the developer with a 48 h trial** | 6 incl. Positioning, ComplicationSubscriber | Solar ring for Venu X1 and other AMOLED |
| **Vesper Solar** | 1,000 | **3** / 4.3 | **2026-09-23** | free | Background, Communications, ComplicationSubscriber | "AMOLED face with one signature: a glowing ember that follows the sun" — **the newest direct sun rival, three days old** |
| Body Battery (dDarius) | 10 | 0 | 2026 | 2.99 | SensorHistory | Wireframe runner that fills with Body Battery |
| Body Info | 1,000 | 35 / 3.7 | 2026-09 | 2.99 | SensorHistory, UserProfile | Digital face with a Body Battery fill; reviews: cannot customise, deactivates after a day |
| Body battery emoticon | 1,000 | 12 / 4.7 | 2025-01 | free | SensorHistory | Big numbers plus an emoticon from Body Battery |
| Circles 2 (VAW.BE) | 10,000 | **1,716 / 4.8** | 2026-08 | **3.49 (paid)**; a "- with trial" twin at 892 / 4.9 | 6 incl. Positioning | Customisable rings dashboard; lists Body Battery and sunrise among its data |

Two more facts that shape the plan:

- **Positioning is the norm for sun faces**: of the 61 faces at 1,000+ downloads where sun or Body Battery is core, 31 declare Positioning, 33 SensorHistory, 13 ComplicationSubscriber, and only 13 declare no permission at all.
- **Nobody sells sun-plus-Body-Battery as one idea.** "Daylight Budget" exists (1 download, 2026-08-24, Positioning + SensorHistory + UserProfile) but is a stub.

## Paid vs free

| Group (loose "core" test; faces named for watch models removed) | Free | Paid |
|---|---|---|
| Body Battery or sun core (deduplicated) | 630 faces; 53 at 1,000+ (8%); 3,266 reviews | **75 faces; 2 at 1,000+ (3%)**; 138 reviews |
| Same, before removing watch-model names | 638; 57 at 1,000+ | 81; 4 at 1,000+ |
| All 1,378 | 1,173 free; 173 at 1,000+ | 205 paid; 17 at 1,000+ |

- The paid faces that reach 1,000+ in these niches: Body Info (2.99) and Epic Sun (2.49); the rest of the paid faces at 1,000+ are named for watch models rather than for the sun or Body Battery (Tactix8 Solar PRO 5.99 and a DIGI TACTICAL Instinct 3 SOLAR face, 4.69: Garmin-face look-alikes), and Circles 2 (10,000+) is a general dashboard. The median paid face has 0 reviews.
- **Paid works for polish and breadth (Circles 2: 10,000 bucket, 1,716 reviews, 4.8★, 3.49 €), not for a narrow single-idea face**: no paid single-idea Body Battery or sun face has broken out. This is the same finding as the countdown research and the same commercial risk.
- Most common paid price in the 205: 2.49 € (99), then 3.49 (24), 2.99 (23), 4.69 (23), 5.99 (13).
- **The store price undercounts paid.** Solarium and Night & Day list as free and sell through the developer's own site; Night & Day's low reviews ("Pay2win", "Paid for face, no unlock code forthcoming") show what that costs.
- Watch faces cannot use Garmin's trial mode (SDK `Trial_Apps`: "not supported for watch faces"); "- with trial" faces are separate free twins.
- The owner has chosen paid at the lowest tier for this face too (2026-09-26). The Days To Go rules carry over: one price review 45 days after approval, and the 60-day success test.

## Recency

Of the 61 core faces at 1,000+ downloads, 23 were updated in the last 90 days. The category is alive: the leaders are maintained, and a brand-new face (Vesper Solar) arrived three days ago. **Expect the sun half of this face to be copied.** The moat is correctness, the Body Battery relationship and finish, not the sun ring.
