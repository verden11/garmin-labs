# Days To Go Pro research (ROADMAP 3.8)

Store, review data read **2026-10-04** from public Connect IQ store API (26 requests, no login). Notes, raw tables: `research_notes/Days To Go Pro research/`.
**F** = fact from store data or source file. **I** = inference (ours). Owner picks; nothing here decided.

## The answer

**What data says about buyers (F):** no paid countdown face has sold. Of 6 store-priced faces that really count down to a date (plus ours), 5 sit at download bucket 1, none has more than 2 reviews; only one at bucket 100 is F1 team-theme face (3,49 EUR, 8 reviews, 4.9) where countdown optional. Money visibly flowing near countdowns goes to **looks** (Christmas, F1 themes, mostly unlocked outside store at $1.49 in 41 listings), not countdown features. Free faces carry reach: Countdown! 100,000, New Year Countdown 50,000, Event Countdown 10,000. **So Pro sales on countdown face expected small (I); Free twin is where reach is.**

**What users ask for that Free does not give (F, reviews):** timed event (event time, time zone, "hours until"). **Thin: about 2 asks among 102 recent reviews of five countdown-first faces** (one more in 2026-09-26 corpus), plus about 5 complaints that rival counted to wrong instant (12:01, "counts two days"), showing cost of wrong time, not request. Still only unmet request Pro already half-serves (Hour setting). Nothing in 102 recent reviews, 156 fresh reviews in all, or 349-review corpus of 2026-09-26 asks for multiple events, icons, calendar sync or celebrations.

**Recommendation (I): Option 1, "To the minute".** Only (thin) review pull, half built, no permission, works on Instinct and 96 KB watches, keeps one-number promise.

| Rank | Pro headline (one-line promise) | Build | Evidence strength | Main risk | 96 KB / Instinct |
|---|---|---|---|---|---|
| **1** | **To the minute.** "Count down to the minute your race, flight or launch starts, in the time zone it starts in." Adds Minute list, event time zone to existing Hour; H:MM in last day stays | Small to medium | Reviews: about 2 asks in 102 recent reviews on five countdown faces, plus about 5 wrong-time complaints; 29 of 83 listings promise hours/minutes; New Year Countdown (50,000) counts hours | Wrong time = 1-star class for rivals; time zones, DST need tests; settings phone-only, route rivals failed on, untested on watch; changes ADR-004 (calendar-day arithmetic); narrow audience | Fits both. Logic, list settings only; text on Instinct. Pro sold on 2 of 7 Instinct products |
| **2** | **The wait has a shape.** "See how far through your wait you are, and be told when it turns into race week." Ring window from start (30 days to 2 years) plus milestone captions (100 days, last week, tomorrow) | Small to medium | Thin: one paid rival (Race Countdown Watch) has training phase, ring, bucket 1; 7 of 83 listings show progress; racers visible core users. No review asks | Two rings (Free's 365-day, Pro's own) can confuse; captions = 15 languages new strings; "taper" wording reads as training advice | Fits both. Ring, caption existing rows; Instinct gauge takes same maths |
| **3** | **Your day beside the count.** "Pick up to three lines beside the countdown: steps, battery, floors, calories, distance." Footer grows from one line to pick-list | Small to medium | Strongest popularity: 64 of 83 listings name metrics, live leader (Event Countdown) praised for them in 4 reviews | Against owner's "without more fields" (2026-09-28), Free's "no steps" promise; 4 reviews want less. **Not available on Instinct** (no room, ADR-015 (Instinct family)) | 96 KB fine; Instinct Pro buyers get nothing |

If owner wants one cheap extra under any option: **"Count in" Pro unit** for long horizons (months and days; years, months and days). Two reviews ask (753-week cap; "337 days instead of the months"), list value, no permission.

Next step if Option 1 picked (suggested): short ADR, test list first (event time zone arithmetic, DST day, midnight), then build; Pro title "Countdown, Hours, Footer" then stale, `DaysToGo/listing/paste.md` changes.

---

## 1. The store: who is there and who pays

### 1.1 Method (F)

12 keyword pages, 13 review pages from public API (`.../apps/keywords`, `.../apps/<id>/reviews`), same endpoints as `tools/store_poll.py`, 3 s apart, one HTTP 400 (watch-app type filter), 26 requests. Queries: countdown (3 pages), days until (2), event countdown, days left, days since, retirement countdown, multiple events countdown, pregnancy due date, countdown with no type filter. **190 unique listings; 103 mention countdown phrase; 83 genuine event countdowns** (other 20 false positives: battery-days face, step-limit face, title-only match, or ours). Full rows: `countdown_faces.csv`; tables: `store_tables.md`.

### 1.2 Paid versus free (F)

| Group | Listings (genuine) | Download buckets | What it is |
|---|---:|---|---|
| Free | 36 | 1 x3, 10 x8, 100 x11, 1,000 x9, 10,000 x3, 50,000 x1, 100,000 x1 | All leaders. Four of five largest stale (2018 to 2023 versions) |
| Free, unlock sold outside the store | 41 | 1 x2, 10 x10, 100 x25, 1,000 x4 | KiezelPay or Ko-fi trials; prices named: $1.49 (17 mentions), $1.99, $2.99, $4.99; $14.99 library of 700 faces. Mostly Christmas, New Year, Halloween, winter, race themes |
| Store-priced (Garmin merchant) | 6 | 1 x5, 100 x1 | 2,49 to 3,49 EUR. Ours (2,49 EUR, bucket 0 to 1) on top of these |

The 6: F1 2026 Drivers AMOLED 3,49 EUR (100 downloads, 8 reviews, 4.9); Cap, Countdown to Your Day 2,49 (1, 2 reviews, 5.0; **same "one number" product as ours**); Race Countdown Watch 2,69 (1, 1 review); World Cup 2026 Kick off 2,99 (1, 1 review); Countdown 2,49 (1); RocketTime 2,49 (1). Three more store-priced faces named "Countdown" (Gold, Blue, one plain) have no countdown in descriptions, excluded.

**Reading (F + I).** Bucket 1 = store's lowest bucket; sales never shown, so "does not sell" read from buckets, not measured. Downloads of external-unlock group = installs of free trial. Unlock opens whole face, so those descriptions list product, **not what buyers pay extra for (I)**. Our Pro price ($2.50 tier, 2,99 EUR) inside paid band (2,49 to 3,49), above common $1.49 of external-unlock sellers.

### 1.3 The free leaders and what they promise (F)

| Face | Bucket | Reviews / rating | Version | What the description promises |
|---|---:|---|---|---|
| Countdown! | 100,000 | 205 / 4.1 | 2.5.0 (2019) | Clock, date, battery, Bluetooth, notifications, an event; settings by phone. No permissions |
| New Year Countdown | 50,000 | 76 / 3.5 | 1.3.0 | Days, then in last day hours, minutes, seconds, to New Year; fireworks. Positioning, SensorHistory, UserProfile |
| Event Countdown | 10,000 | 32 / 4.4 | 1.1.3 (2026) | Event name and date, optional start hour, days or weeks, up to 4 metrics, per-element colours |
| time2race | 10,000 | 78 / 4.1 | 1.5.9E (2020) | Two countdown styles or 7-day steps chart, goal progress, notifications |
| Countdown, Watch & Track events | 1,000 | 11 / 5.0 | 1.0.2 (2026) | Days, hours, minutes, seconds; 3 complications; 33 colours; tap to open apps |

Every leader but 2016 and 2019 faces asks for permissions; Days To Go asks none (F, manifests). Apps and widgets: 3 free countdown widgets at bucket 1,000 (4.3, 3.7, 4.0), data field "Goal Countdown" (26 reviews, 4.8); no store-priced app or widget turned up (one page only).

### 1.4 What listings promise, by group (F, `feature_mentions.md`)

Of 83 genuine listings: metrics or data lines 64; colour or theme choice 53; background, image, icon or animation 52; countdown to hours, minutes or seconds 29; always-on mode 17; progress ring, bar or dots 7; celebration on the day 7; weeks or months units 5; several events 4; training phase 5; repeat every year 3. Store-priced six name: metrics 5, colours 5, images 5, always-on 4, progress 3, hours/minutes 2. **Metrics, colours, images = what everyone lists; hours/minutes, progress listed by minority, several events by almost nobody (4 of 83; 100,000 leader's hit only phrase "next event", one event; rest at bucket 10 or lower).**

## 2. What users ask for (F: reviews; counts are my hand tally, about plus or minus 2)

Newest 25 text reviews per listing (all of small one) for Countdown!, time2race, Event Countdown, Countdown Watch & Track, New Year Countdown (102 reviews), plus F1 faces, altitude/moon face; 349 reviews of 2026-09-26 in `research_notes/Countdown face research/rival_reviews.md` cited, not re-read. Quotes (15 words or fewer, source store id prefix) in `review_quotes.csv`.

| Theme | About how many of the 102 | Example (id prefix) | Free or Pro here |
|---|---:|---|---|
| Cannot set or save the date | 20 | "Others are right- tap all over the blank white space below" (183a7d45) | Free (lists plus on-watch picker) |
| Not on my watch (fenix 8, FR255, Venu 2, Mk3i) | 13 | "Too bad it doesn't work with fenix 8 watches" (183a7d45) | Free reach: manifest has fenix 8, FR255, Venu 2, Descent Mk3 (F); on store they are Pro-vs-Free question |
| Asks for a timed event: event time, zone, "hours until" | 2 (+1 in the 2026-09-26 corpus) | "I wish you could enter the time of the event (including time zones)" (cc1c484b) | Pro (Hour); minutes and zone missing |
| Complaints that a rival counted to the wrong instant (12:01, "counts two days") | 5 | "It's counting down to 12:01 which is, unfortunately, a deal breaker." (ddf4eaf4) | Not request: shows cost of wrong time. Free's calendar-day rule already avoids all-day case |
| Colours and looks | 6 | "Can't change the background colour. Settings does not show up." (ddf4eaf4) | Free (Accent) |
| Want less on the face | 4 | "I just want a simple countdown face." (d44a137e) | Free |
| Praise for data beside the count | 4 | "shows all the fields I need" (d44a137e) | Pro footer, one line |
| Want more data | 2 here, 4 on the F1 faces | "would be good to have the battery bar on the screen somewhere" (a7b82a44) | Pro footer |
| Long horizon, days not months | 2 | "countdown doesn't allow me to go past 753 weeks." (d44a137e) | Free has days and weeks |
| Several events, icons, calendar, celebration | **0** | none | not built |

Other facts: paid F1 face's reviewers ask for more display options and drivers (4 of 7); free F1 reviewer wrote "Got the paid version right away as support!" (a7b82a44), so some money is support, not features (F). Old 2026-09-26 findings still stand: about two thirds of Countdown!'s low stars are date or saving it; runners and racers visible core users (marathon, Ironman) (F).

## 3. Our face today against this

| | Free (F: spec, ADR-014 (Free + Pro ladder)) | Pro today | Gap the evidence shows (I) |
|---|---|---|---|
| Date entry, calendar-day count, midnight flip, always-on, 15 languages | yes | yes | biggest complaint class already the product |
| Event name, days or weeks and days, Date style, Accent (6 colours) | yes | yes | covers colour and day/week asks |
| Timed event (Hour list) | no | **yes**, last 24 h as H:MM | no minutes, no time zone |
| Bottom line (battery or steps) | no | **yes**, one line | one line only; none on Instinct |
| Accent ids 6 to 11, a new layout | no | deferred, not built | colour asks small, sit in Free |
| Permissions | none | none | all three options below keep none |

Pro thin on purpose (spec: "buyers want the minimum"). Evidence agrees: minimum is market's gap, Free serves it. Pro adding dashboard would fight reviewers who want less.

## 4. The three options in detail

### Option 1: To the minute (recommended)

- **Promise:** "Count down to the minute your race, flight or launch starts, in the time zone it starts in."
- **Needs:** Minute list (0 to 55 step 5 or all 60 as list) beside Hour; "Event time zone" list (watch's own zone by default, then UTC offsets in 30-minute steps); countdown reads `Time.now()` and `System.getClockTime().timeZoneOffset` (no permission); H:MM in last 24 hours already exists. **Small to medium**: settings, 15 languages of strings; arithmetic and tests are real cost.
- **Evidence (F):** asks are cc1c484b (event time and time zone, "not accurate", 2026-07) and ddf4eaf4 ("hours until then", 2022-12), plus time2race "Only hours?" (2018, from 2026-09-26 corpus); cost-of-error complaints are ddf4eaf4 "12:01" (about 4) and d44a137e "counts two days" (all-day bug Free's calendar-day rule already prevents). 29 of 83 listings promise hours/minutes/seconds, including 50,000-download New Year Countdown and two of store-priced six. Racers (start gun), cruises, flights, game and product launches = named uses. **Inference:** only need Free's calendar-day design leaves open on purpose, so clean Pro line.
- **Risk:**
  - **Evidence thin:** about 2 asks (section 2). Ranks first because other two have none or conflict with owner's direction, not because proven.
  - **Touches counting rules.** Day count must stay local calendar days (ADR-004 (calendar-day arithmetic, no time zones) and allowed claim "the count flips at local midnight", which binds both listings). Event time zone may move only instant HOURS starts and instant TODAY arrives. Even so it is amendment of ADR-004 (calendar-day arithmetic, no time zones), not extension of ADR-014 (Free + Pro ladder), needs new ADR plus tests: travel day, DST day, midnight. Fixed offset has no DST, so user must pick offset in force on event day.
  - **Phone-only settings.** Hour, Minute, Zone are phone settings; on-watch picker sets only date. Phone route is the one rivals failed on (about two thirds of Countdown!'s low stars), phone round trip (gate 2, T2) waived, so untested on hardware. Pro buyers would hit exactly that.
  - Wrong time = 1-star class for rivals (about 5 of 102). Narrow audience: only people with start time. Seconds deliberately out (battery, AMOLED always-on).
- **96 KB / Instinct:** logic and list settings only; face uses 27.6 of 91.8 kB on 96 KB watch (compatibility.md, simulator), no memory risk. On Instinct H:MM hero is text, works in 1 bit; no accent, no footer needed. Pro sells on 2 of 7 Instinct products only (E 40/45 mm, 3 Solar).

### Option 2: The wait has a shape

- **Promise:** "See how far through your wait you are, and be told when it turns into race week."
- **Needs:** "Ring window" list (30 days, 90, 180, 1 year, 2 years; today ring is next 365 days with square-root scale, ADR-013 (ring beyond a year)) and milestone captions in caption row ("100 DAYS", "LAST WEEK", "TOMORROW"; for races optionally "RACE WEEK"). **Small to medium.**
- **Evidence:** weak (F): Race Countdown Watch sells "training phase indicator" and "progress ring" at 2,69 EUR, bucket 1; 7 of 83 listings show progress visual; 5 mention training phase; at least 6 of 102 reviews name race, marathon or Ironman. No review asks. **Inference:** serves visible core (racers) with no data beyond date.
- **Risk:** Free's ring and Pro's ring differ (confusing); captions add strings in 15 languages, need fit test per language; "taper" implies training advice (avoid, use neutral "RACE WEEK"); thin evidence.
- **96 KB / Instinct:** fits both (existing rows, Instinct window gauge takes same maths).

### Option 3: Your day beside the count

- **Promise:** "Pick up to three lines beside the countdown: steps, battery, floors, calories, distance."
- **Needs:** footer (battery or steps, one line) becomes pick-list of up to 3 lines from sources needing no permission (ActivityMonitor figures; steps already ship permission-free, F). **Small to medium**; layout rows must give way on small screens (ADR-016 (bottom line shares the date row)).
- **Evidence (F):** most common listing promise (64 of 83), what live leader is praised for (4 reviews). Conventional ladders (GLANCE, GreenBlack) put data fields behind Pro (`same_face_pairs.md`).
- **Risk:** least differentiated option (rivals do it; I). Against owner's "without more fields" direction and Free promise "No steps, no heart rate". Four reviews and rival reviews of 2026-09-26 ask for **less**. **No Instinct support**: ADR-015 (Instinct family) drops footer there (smallest font 23 px on 176 px screen), so Pro on Instinct would not have it.
- **96 KB:** fine.

## 5. Ideas checked and set aside (so they are not asked again)

| Idea | Why not a headline | Source |
|---|---|---|
| **Calendar events** (count down to your next appointment) | SDK gives only `COMPLICATION_TYPE_CALENDAR_EVENTS`, API 4.2.0, "a String with the time of your next calendar event": no date, no title. Our other faces reading complications declare `ComplicationSubscriber` (HeroFace, Two Suns manifests), so would break "no permissions" (I), drop CIQ 3.x watches and Instinct 2 family | SDK 9.2.0 `Toybox/Complications.html`; manifests |
| **Several events / "next up"** | 4 of 83 listings, none above bucket 10 except a leader's "next event" line; 0 of 156 fresh reviews and of 349-review corpus ask; multiplies date settings that caused about 20 of 102 reviews; v1 non-goal (spec). Size: large (settings per event, on-watch picker, Instinct layout) | `feature_mentions.md`, spec |
| **Icons, photos, emoji per event** | 52 of 83 listings mention images, backgrounds, icons, mostly seasonal themes; 0 reviews ask. 96 KB faces have no bitmap budget (primitives only); owner's direction puts bold look in Free first, so not a Pro rescue | ladder report D4 (daring design), spec |
| **Seasonal and theme packs** | Only place money visibly flows (41 external-unlock listings at about $1.49; F1 paid face) but needs artwork bitmaps, not our brand; Free already has New Year and Christmas presets | `store_tables.md` |
| **Network event feeds** (F1 next race, launches) | Needs Communications or Background permission: breaks "nothing leaves your watch" | listing claims |
| **Seconds ticking, confetti** | Battery, AMOLED always-on; 0 asks | spec, ADR-007 (always-on) |
| **More accent colours** (ids 6 to 11) | Planned, cheap, but colour asks in Free's Accent and small; fine as extra, not headline | ADR-014 (Free + Pro ladder) |

## 6. Unknowns

- **Sales unknown** (F): public data shows download buckets only. No source here shows what any countdown buyer paid.
- Whether Pro buyers come from Free users (attach) unmeasured; ladder plan's store poll and 60-day stop test in spec are the way to see it.
- Paid-only countdown face with strong rating, many reviews could exist outside the 190 listings keyword search ranked (search capped, noisy).
- App-type search: watch-app filter returned HTTP 400; unfiltered search showed no store-priced app or widget in first 30 results.
- `changedDate` looks bulk re-stamped on 2026-08-24 to 28, so "last update" unreliable; version strings used instead.
- Time-zone behaviour of Option 1 on real watch (DST, travel) not tested anywhere; simulator is not device proof.
- Whether Instinct accepts Hour/Minute settings in on-watch Customize menu unmeasured (ADR-015 (Instinct family) says Customize menu on Instinct unverified).

## 7. Suggested ROADMAP edits (not applied)

- 3.8: tick it, link this report; add **3.8a `[you]` pick the Pro headline: 1 To the minute (recommended), 2 The wait has a shape, 3 Your day beside the count, or keep Pro as it is for 1.1.0 and add the headline in 1.2.0**.
- 3.6 "Waits for 3.8": change to "waits for the owner's pick in 3.8a, or the owner may ship the thin Pro now (the research asked for no gate beyond the pick)".
- If Option 1 picked: new `[agent]` item "Days To Go Pro: Minute and Event time zone settings, ADR and tests (DST, travel day, midnight), 15-language strings, Instinct check, listing title and What's New update", sequenced before 3.6.
- Listing note: `DaysToGo/listing/paste.md` title "Countdown, Hours, Footer" stale once headline chosen.
- Claim check on current Pro draft: `DaysToGo/listing/paste.md` says "No steps, no heart rate, no weather." while same text offers steps bottom line; reword before 3.6 (Option 3 would widen contradiction).
- If Option 1 picked, amend ADR-004 (calendar-day arithmetic, no time zones) in `DaysToGo/docs/decisions.md`, keep "the count flips at local midnight" true (zone moves only HOURS and TODAY).
- Expectation line for 3.6/M3: no countdown face has sold in store's public data; judge Pro on 60-day test in spec, not revenue hope.