# Days To Go Pro research (ROADMAP 3.8)

Store and review data read **2026-10-04** from the public Connect IQ store API (26 requests, no login). Notes and raw tables: `research_notes/Days To Go Pro research/`.
**F** = fact read from the store data or a source file. **I** = inference (ours). The owner picks; nothing here is decided.

## The answer

**What the data says about buyers (F):** no paid countdown face has sold. Of 6 store-priced faces that really count down to a date (plus ours), 5 sit at download bucket 1 and none has more than 2 reviews; the only one at bucket 100 is an F1 team-theme face (3,49 EUR, 8 reviews, 4.9) where the countdown is optional. The money that visibly flows near countdowns goes to **looks** (Christmas and F1 themes, mostly unlocked outside the store at $1.49 in 41 listings), not to countdown features. The free faces carry the reach: Countdown! 100,000, New Year Countdown 50,000, Event Countdown 10,000. **So Pro sales on a countdown face should be expected to be small (I); the Free twin is where the reach is.**

**What users ask for that Free does not give (F, reviews):** the timed event (an event time, a time zone, "hours until"). **It is thin: about 2 asks among the 102 recent reviews of the five countdown-first faces** (one more in the 2026-09-26 corpus), plus about 5 complaints that a rival counted to the wrong instant (12:01, "counts two days"), which show the cost of getting time wrong rather than a request. It is still the only unmet request that Pro already half-serves (the Hour setting). Nothing in the 102 recent reviews, the 156 fresh reviews in all, or the 349-review corpus of 2026-09-26 asks for multiple events, icons, calendar sync or celebrations.

**Recommendation (I): Option 1, "To the minute".** It has the only (thin) review pull, is half built, needs no permission, works on the Instinct and the 96 KB watches, and keeps the one-number promise.

| Rank | Pro headline (one-line promise) | Build | Evidence strength | Main risk | 96 KB / Instinct |
|---|---|---|---|---|---|
| **1** | **To the minute.** "Count down to the minute your race, flight or launch starts, in the time zone it starts in." Adds a Minute list and an event time zone to the existing Hour; H:MM in the last day stays | Small to medium | Reviews: about 2 asks in 102 recent reviews on five countdown faces, plus about 5 wrong-time complaints; 29 of 83 listings promise hours/minutes; New Year Countdown (50,000) counts hours | Wrong time is a 1-star class for rivals; time zones and DST need tests; the settings are phone-only, the route rivals failed on and that is untested on a watch; changes ADR-004 (calendar-day arithmetic); narrow audience | Fits both. Logic and list settings only; text on the Instinct. Pro is sold on 2 of 7 Instinct products |
| **2** | **The wait has a shape.** "See how far through your wait you are, and be told when it turns into race week." Ring window from a start (30 days to 2 years) plus milestone captions (100 days, last week, tomorrow) | Small to medium | Thin: one paid rival (Race Countdown Watch) has a training phase and ring, bucket 1; 7 of 83 listings show progress; racers are the visible core users. No review asks | Two rings (Free's 365-day, Pro's own) can confuse; captions are 15 languages of new strings; "taper" wording reads as training advice | Fits both. Ring and caption are existing rows; the Instinct gauge takes the same maths |
| **3** | **Your day beside the count.** "Pick up to three lines beside the countdown: steps, battery, floors, calories, distance." The footer grows from one line to a pick-list | Small to medium | Strongest popularity: 64 of 83 listings name metrics, the live leader (Event Countdown) is praised for them in 4 reviews | Cuts against the owner's "without more fields" (2026-09-28), against Free's "no steps" promise, and 4 reviews want less. **Not available on the Instinct** (no room, ADR-015 (Instinct family)) | 96 KB fine; Instinct Pro buyers get nothing from it |

If the owner wants one cheap extra under any option: a **"Count in" Pro unit** for long horizons (months and days; years, months and days). Two reviews ask (a 753-week cap; "337 days instead of the months"), it is a list value, no permission.

Next step if Option 1 is picked (suggested): a short ADR and test list first (event time zone arithmetic, DST day, midnight), then build; the Pro title "Countdown, Hours, Footer" is then stale and `DaysToGo/listing/paste.md` changes.

---

## 1. The store: who is there and who pays

### 1.1 Method (F)

12 keyword pages and 13 review pages from the public API (`.../apps/keywords`, `.../apps/<id>/reviews`), same endpoints as `tools/store_poll.py`, 3 s apart, one HTTP 400 (watch-app type filter), 26 requests. Queries: countdown (3 pages), days until (2), event countdown, days left, days since, retirement countdown, multiple events countdown, pregnancy due date, countdown with no type filter. **190 unique listings; 103 mention a countdown phrase; 83 are genuine event countdowns** (the other 20 are false positives such as a battery-days face, a step-limit face, a title-only match, or ours). Full rows: `countdown_faces.csv`; tables: `store_tables.md`.

### 1.2 Paid versus free (F)

| Group | Listings (genuine) | Download buckets | What it is |
|---|---:|---|---|
| Free | 36 | 1 x3, 10 x8, 100 x11, 1,000 x9, 10,000 x3, 50,000 x1, 100,000 x1 | All the leaders. Four of the five largest are stale (2018 to 2023 versions) |
| Free, unlock sold outside the store | 41 | 1 x2, 10 x10, 100 x25, 1,000 x4 | KiezelPay or Ko-fi trials; prices named: $1.49 (17 mentions), $1.99, $2.99, $4.99; a $14.99 library of 700 faces. Mostly Christmas, New Year, Halloween, winter and race themes |
| Store-priced (Garmin merchant) | 6 | 1 x5, 100 x1 | 2,49 to 3,49 EUR. Ours (2,49 EUR, bucket 0 to 1) is on top of these |

The 6: F1 2026 Drivers AMOLED 3,49 EUR (100 downloads, 8 reviews, 4.9); Cap, Countdown to Your Day 2,49 (1, 2 reviews, 5.0; **the same "one number" product as ours**); Race Countdown Watch 2,69 (1, 1 review); World Cup 2026 Kick off 2,99 (1, 1 review); Countdown 2,49 (1); RocketTime 2,49 (1). Three more store-priced faces named "Countdown" (Gold, Blue, one plain) have no countdown in their descriptions and are excluded.

**Reading (F + I).** Bucket 1 is the store's lowest bucket; sales are never shown, so "does not sell" is read from the buckets, not measured. Downloads of the external-unlock group are installs of the free trial. The unlock opens the whole face, so those descriptions list the product, **not what buyers pay extra for (I)**. Our Pro price ($2.50 tier, 2,99 EUR) sits inside the paid band (2,49 to 3,49) and above the common $1.49 of the external-unlock sellers.

### 1.3 The free leaders and what they promise (F)

| Face | Bucket | Reviews / rating | Version | What the description promises |
|---|---:|---|---|---|
| Countdown! | 100,000 | 205 / 4.1 | 2.5.0 (2019) | Clock, date, battery, Bluetooth, notifications, an event; settings by phone. No permissions |
| New Year Countdown | 50,000 | 76 / 3.5 | 1.3.0 | Days, then in the last day hours, minutes, seconds, to New Year; fireworks. Positioning, SensorHistory, UserProfile |
| Event Countdown | 10,000 | 32 / 4.4 | 1.1.3 (2026) | Event name and date, optional start hour, days or weeks, up to 4 metrics, per-element colours |
| time2race | 10,000 | 78 / 4.1 | 1.5.9E (2020) | Two countdown styles or a 7-day steps chart, goal progress, notifications |
| Countdown, Watch & Track events | 1,000 | 11 / 5.0 | 1.0.2 (2026) | Days, hours, minutes, seconds; 3 complications; 33 colours; tap to open apps |

Every leader but the 2016 and 2019 faces asks for permissions; Days To Go asks for none (F, manifests). Apps and widgets: 3 free countdown widgets at bucket 1,000 (4.3, 3.7, 4.0) and a data field "Goal Countdown" (26 reviews, 4.8); no store-priced app or widget turned up (one page only).

### 1.4 What listings promise, by group (F, `feature_mentions.md`)

Of the 83 genuine listings: metrics or data lines 64; colour or theme choice 53; background, image, icon or animation 52; countdown to hours, minutes or seconds 29; always-on mode 17; progress ring, bar or dots 7; celebration on the day 7; weeks or months units 5; several events 4; training phase 5; repeat every year 3. The store-priced six name: metrics 5, colours 5, images 5, always-on 4, progress 3, hours/minutes 2. **Metrics, colours and images are what everyone lists; hours/minutes and progress are listed by a minority, and several events by almost nobody (4 of 83; the 100,000 leader's hit is only the phrase "next event", one event; the rest are at bucket 10 or lower).**

## 2. What users ask for (F: reviews; counts are my hand tally, about plus or minus 2)

Newest 25 text reviews per listing (all of a small one) for Countdown!, time2race, Event Countdown, Countdown Watch & Track, New Year Countdown (102 reviews), plus the F1 faces and the altitude/moon face; the 349 reviews of 2026-09-26 in `research_notes/Countdown face research/rival_reviews.md` are cited, not re-read. Quotes (15 words or fewer, source store id prefix) are in `review_quotes.csv`.

| Theme | About how many of the 102 | Example (id prefix) | Free or Pro here |
|---|---:|---|---|
| Cannot set or save the date | 20 | "Others are right- tap all over the blank white space below" (183a7d45) | Free (lists plus on-watch picker) |
| Not on my watch (fenix 8, FR255, Venu 2, Mk3i) | 13 | "Too bad it doesn't work with fenix 8 watches" (183a7d45) | Free reach: the manifest has fenix 8, FR255, Venu 2 and Descent Mk3 (F); on the store they are a Pro-vs-Free question |
| Asks for a timed event: event time, zone, "hours until" | 2 (+1 in the 2026-09-26 corpus) | "I wish you could enter the time of the event (including time zones)" (cc1c484b) | Pro (Hour); minutes and zone missing |
| Complaints that a rival counted to the wrong instant (12:01, "counts two days") | 5 | "It's counting down to 12:01 which is, unfortunately, a deal breaker." (ddf4eaf4) | Not a request: shows the cost of wrong time. Free's calendar-day rule already avoids the all-day case |
| Colours and looks | 6 | "Can't change the background colour. Settings does not show up." (ddf4eaf4) | Free (Accent) |
| Want less on the face | 4 | "I just want a simple countdown face." (d44a137e) | Free |
| Praise for data beside the count | 4 | "shows all the fields I need" (d44a137e) | Pro footer, one line |
| Want more data | 2 here, 4 on the F1 faces | "would be good to have the battery bar on the screen somewhere" (a7b82a44) | Pro footer |
| Long horizon, days not months | 2 | "countdown doesn't allow me to go past 753 weeks." (d44a137e) | Free has days and weeks |
| Several events, icons, calendar, celebration | **0** | none | not built |

Other facts: the paid F1 face's reviewers ask for more display options and drivers (4 of 7); a free F1 reviewer wrote "Got the paid version right away as support!" (a7b82a44), so some money is support, not features (F). Old 2026-09-26 findings still stand: about two thirds of Countdown!'s low stars are the date or saving it; runners and racers are the visible core users (marathon, Ironman) (F).

## 3. Our face today against this

| | Free (F: spec, ADR-014 (Free + Pro ladder)) | Pro today | Gap the evidence shows (I) |
|---|---|---|---|
| Date entry, calendar-day count, midnight flip, always-on, 15 languages | yes | yes | the biggest complaint class is already the product |
| Event name, days or weeks and days, Date style, Accent (6 colours) | yes | yes | covers colour and day/week asks |
| Timed event (Hour list) | no | **yes**, last 24 h as H:MM | no minutes, no time zone |
| Bottom line (battery or steps) | no | **yes**, one line | one line only; none on Instinct |
| Accent ids 6 to 11, a new layout | no | deferred, not built | colour asks are small and sit in Free |
| Permissions | none | none | all three options below keep none |

Pro is thin on purpose (spec: "buyers want the minimum"). The evidence agrees: the minimum is the market's gap, and Free serves it. A Pro that adds a dashboard would fight the reviewers who want less.

## 4. The three options in detail

### Option 1: To the minute (recommended)

- **Promise:** "Count down to the minute your race, flight or launch starts, in the time zone it starts in."
- **Needs:** a Minute list (0 to 55 step 5 or all 60 as a list) beside Hour; an "Event time zone" list (watch's own zone by default, then UTC offsets in 30-minute steps); the countdown reads `Time.now()` and `System.getClockTime().timeZoneOffset` (no permission); H:MM in the last 24 hours already exists. **Small to medium**: settings and 15 languages of strings; the arithmetic and its tests are the real cost.
- **Evidence (F):** the asks are cc1c484b (event time and time zone, "not accurate", 2026-07) and ddf4eaf4 ("hours until then", 2022-12), plus time2race "Only hours?" (2018, from the 2026-09-26 corpus); the cost-of-error complaints are ddf4eaf4 "12:01" (about 4) and d44a137e "counts two days" (an all-day bug that Free's calendar-day rule already prevents). 29 of 83 listings promise hours/minutes/seconds, including the 50,000-download New Year Countdown and two of the store-priced six. Racers (start gun), cruises and flights, game and product launches are the named uses. **Inference:** it is the one need that Free's calendar-day design leaves open on purpose, so it is a clean Pro line.
- **Risk:**
  - **The evidence is thin:** about 2 asks (section 2). It ranks first because the other two have none or conflict with the owner's direction, not because it is proven.
  - **It touches the counting rules.** The day count must stay local calendar days (ADR-004 (calendar-day arithmetic, no time zones) and the allowed claim "the count flips at local midnight", which binds both listings). The event time zone may move only the instant HOURS starts and the instant TODAY arrives. Even so it is an amendment of ADR-004, not an extension of ADR-014 (Free + Pro ladder), and needs a new ADR plus tests: travel day, DST day, midnight. A fixed offset has no DST, so the user must pick the offset in force on the event day.
  - **Phone-only settings.** Hour, Minute and Zone are phone settings; the on-watch picker sets only the date. The phone route is the one rivals failed on (about two thirds of Countdown!'s low stars), and the phone round trip (gate 2, T2) was waived, so it is untested on hardware. Pro buyers would hit exactly that.
  - Wrong time is a 1-star class for rivals (about 5 of 102). Narrow audience: only people with a start time. Seconds are deliberately out (battery, AMOLED always-on).
- **96 KB / Instinct:** logic and list settings only; the face uses 27.6 of 91.8 kB on a 96 KB watch (compatibility.md, simulator), so no memory risk. On the Instinct the H:MM hero is text and works in 1 bit; no accent, no footer needed. Pro sells on 2 of 7 Instinct products only (E 40/45 mm, 3 Solar).

### Option 2: The wait has a shape

- **Promise:** "See how far through your wait you are, and be told when it turns into race week."
- **Needs:** a "Ring window" list (30 days, 90, 180, 1 year, 2 years; today the ring is the next 365 days with a square-root scale, ADR-013 (ring beyond a year)) and milestone captions in the caption row ("100 DAYS", "LAST WEEK", "TOMORROW"; for races optionally "RACE WEEK"). **Small to medium.**
- **Evidence:** weak (F): Race Countdown Watch sells "training phase indicator" and "progress ring" at 2,69 EUR and is at bucket 1; 7 of 83 listings show a progress visual; 5 mention a training phase; at least 6 of 102 reviews name a race, marathon or Ironman. No review asks for it. **Inference:** it serves the visible core (racers) with no data beyond the date.
- **Risk:** Free's ring and Pro's ring differ (confusing); captions add strings in 15 languages and must be checked by a fit test per language; "taper" implies training advice (avoid it, use neutral "RACE WEEK"); thin evidence.
- **96 KB / Instinct:** fits both (existing rows, the Instinct window gauge takes the same maths).

### Option 3: Your day beside the count

- **Promise:** "Pick up to three lines beside the countdown: steps, battery, floors, calories, distance."
- **Needs:** the footer (battery or steps, one line) becomes a pick-list of up to 3 lines from sources that need no permission (ActivityMonitor figures; steps already ship permission-free, F). **Small to medium**; layout rows must give way on small screens (ADR-016 (bottom line shares the date row)).
- **Evidence (F):** the most common thing listings promise (64 of 83) and what the live leader is praised for (4 reviews). Conventional ladders (GLANCE, GreenBlack) put data fields behind Pro (`same_face_pairs.md`).
- **Risk:** the least differentiated option (rivals do it; I). Against the owner's "without more fields" direction and the Free promise "No steps, no heart rate". Four reviews and the rival reviews of 2026-09-26 ask for **less**. **No Instinct support**: ADR-015 (Instinct family) drops the footer there (smallest font 23 px on a 176 px screen), so Pro on the Instinct would not have it.
- **96 KB:** fine.

## 5. Ideas checked and set aside (so they are not asked again)

| Idea | Why not a headline | Source |
|---|---|---|
| **Calendar events** (count down to your next appointment) | The SDK gives only `COMPLICATION_TYPE_CALENDAR_EVENTS`, API 4.2.0, "a String with the time of your next calendar event": no date, no title. Our other faces that read complications declare `ComplicationSubscriber` (HeroFace, Two Suns manifests), so it would break "no permissions" (I) and drop CIQ 3.x watches and the Instinct 2 family | SDK 9.2.0 `Toybox/Complications.html`; manifests |
| **Several events / "next up"** | 4 of 83 listings, none above bucket 10 except a leader's "next event" line; 0 of the 156 fresh reviews and of the 349-review corpus ask; multiplies the date settings that caused about 20 of 102 reviews; a v1 non-goal (spec). Size: large (settings per event, on-watch picker, Instinct layout) | `feature_mentions.md`, spec |
| **Icons, photos, emoji per event** | 52 of 83 listings mention images, backgrounds or icons, mostly seasonal themes; 0 reviews ask. 96 KB faces have no bitmap budget (primitives only); the owner's direction puts the bold look in Free first, so it would not be a Pro rescue | ladder report D4 (daring design), spec |
| **Seasonal and theme packs** | The only place money visibly flows (41 external-unlock listings at about $1.49; the F1 paid face) but it needs artwork bitmaps and is not our brand; Free already has New Year and Christmas presets | `store_tables.md` |
| **Network event feeds** (F1 next race, launches) | Needs Communications or Background permission: breaks "nothing leaves your watch" | listing claims |
| **Seconds ticking, confetti** | Battery and AMOLED always-on; 0 asks | spec, ADR-007 (always-on) |
| **More accent colours** (ids 6 to 11) | Planned and cheap, but colour asks are in Free's Accent and small; fine as an extra, not a headline | ADR-014 |

## 6. Unknowns

- **Sales are unknown** (F): the public data shows download buckets only. No source here shows what any countdown buyer paid.
- Whether Pro buyers come from Free users (attach) is unmeasured; the ladder plan's store poll and the 60-day stop test in the spec are the way to see it.
- A paid-only countdown face with a strong rating and many reviews could exist outside the 190 listings the keyword search ranked (search is capped and noisy).
- App-type search: the watch-app filter returned HTTP 400; the unfiltered search showed no store-priced app or widget on its first 30 results.
- `changedDate` looks bulk re-stamped on 2026-08-24 to 28, so "last update" is not reliable; version strings were used instead.
- The time-zone behaviour of Option 1 on a real watch (DST, travel) is not tested anywhere; simulator is not device proof.
- Whether the Instinct accepts the Hour/Minute settings in the on-watch Customize menu is unmeasured (ADR-015 says the Customize menu on an Instinct is unverified).

## 7. Suggested ROADMAP edits (not applied)

- 3.8: tick it, link this report; add **3.8a `[you]` pick the Pro headline: 1 To the minute (recommended), 2 The wait has a shape, 3 Your day beside the count, or keep Pro as it is for 1.1.0 and add the headline in 1.2.0**.
- 3.6 "Waits for 3.8": change to "waits for the owner's pick in 3.8a, or the owner may ship the thin Pro now (the research asked for no gate beyond the pick)".
- If Option 1 is picked: new `[agent]` item "Days To Go Pro: Minute and Event time zone settings, ADR and tests (DST, travel day, midnight), 15-language strings, Instinct check, listing title and What's New update", sequenced before 3.6.
- Listing note: `DaysToGo/listing/paste.md` title "Countdown, Hours, Footer" is stale once a headline is chosen.
- Claim check on the current Pro draft: `DaysToGo/listing/paste.md` says "No steps, no heart rate, no weather." while the same text offers a steps bottom line; reword before 3.6 (Option 3 would widen the contradiction).
- If Option 1 is picked, amend ADR-004 (calendar-day arithmetic, no time zones) in `DaysToGo/docs/decisions.md` and keep "the count flips at local midnight" true (the zone moves only HOURS and TODAY).
- Expectation line for 3.6/M3: no countdown face has sold in the store's public data; judge Pro on the 60-day test in spec, not on a revenue hope.
