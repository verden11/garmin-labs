# Rival reviews

Pulled 2026-09-26 from store reviews endpoint (all reviews with text; sorted by rating both ways and by date, de-duplicated).

| Face | Reviews with text | At 1–3★ | App id |
|---|---|---|---|
| Countdown! (183a7d45) | 179 | 49 | `183a7d45-c05e-4964-ba16-8f238eab2ba6` |
| time2race (23bae5fc) | 75 | 22 | `23bae5fc-da90-48d1-b254-404a5d727f1a` |
| New Year Countdown (ddf4eaf4) | 56 | 28 | `ddf4eaf4-2bb0-44c8-9250-17bb2c208ed0` |
| Event Countdown (d44a137e) | 20 | 6 | `d44a137e-7a1e-4b67-9aa6-133d48db745c` |
| three small ones (Countdown 2016, "Countdown - Watch & Track events", WC26) | 19 | n/a | not analysed further |

## 1. Entering the date is what breaks (Countdown!, and time2race in its time)

Countdown!'s **49** reviews at 1–3★: **32 (65%)** about setting or saving event date, checked by reading all 36 keyword matches (4 false positives: German "Update" sync error, "not sure how to configure the event", "my 235 date of countdown wrong suddenly", "Fix data problem pls urgent"). Complaint continuous 2021-11 to 2024-09 on version 2.5.0, version unchanged since. Quotes (date, stars):

- 2022-02, 1★: "This watch face is supposed to do one thing - do an event countdown. However, you cannot change the event date. It's stuck on 09/18/2019."
- 2021-02, 3★: "something causes the event date to go back to 1970 and there's no way to reset the year without scrolling through each month."
- 2022-08, 3★: "Others are right- tap all over the blank white space below to finally hit the hidden save button."
- 2022-01, 1★: "I can't delete it and cannot change the date of the event! ... I now have the countdown on my watch with an old event and cannot delete it."
- 2022-06, 1★: "for a long time it is impossible to change the event date. But a countdown makes no sense without this. Even if you can change it on the computer! I don't have my computer with me when travelling."
- 2022-06, 1★: "It did an amazing job to prepare me for my first IronMan. Unable to change the date at the moment."
- Same problem in Portuguese, Spanish, German, Chinese reviews (large share of the 49 not English).

time2race: same failure class via different setting type (year, month, day, hour as separate numeric settings):

- 2019-11 and 2019-12, 1★: "Configuration says race day must be between 0 and 0 - app does not work!"
- 2020-02, 2★: "It says that year, month and hour must be 0 to 0 so clearly none of the info is able to be put in."
- 2019-09, 3★: "When it save button I get this message 'Open outside of Garmin Connect.'"
- 2026-01, 1★: "Countdown year 2026 is impossible" (fixed year list ran out).

Reading: failing part = **phone-side settings screen**, not watch. Two different implementations (date picker; numeric fields with min/max) both failed. See `settings_and_dates.md` for documented cause (Garmin Connect date pickers) and fix chosen (list settings plus on-watch picker).

## 2. Getting the day wrong

- **New Year Countdown**, 2019-12, v1.0.0 (about twenty 1★ within days of launch): "It's a whole day off"; "counting to midnight on the 30th, not the 31st"; "it thinks New Year comes at noon on New Year's Day". Later: 2022-12 "It's counting down to 12:01 which is, unfortunately, a deal breaker"; 2024-12 "12:00 - 9:00 ≠ 3:01".
- **Event Countdown**, 2022-01, 3★, v1.0.2: "Counts wrong, unfortunately. When I enter the date of tomorrow, it counts two days." (Later versions no such review.)
- **time2race**, 2018-10, 3★: "the countdown of days is not OK. A day starts at midnight, not at the event time. ... add another countdown type? Only hours?"

Rule for product: count in **calendar days**, flips at **local midnight**, timed event shows **hours** in last 24 h.

## 3. What people ask for

- **A countdown-only face.** Event Countdown 2024-03, 3★: "I wish I could delete useless things like steps, calories, battery % etc. I just want a simple countdown face." Same face 2024-04, 5★: "Wish you had another watch face where I can see the time and countdown only." 2023-12, 4★: "Any chance of getting an option to leave the data fields empty." Countdown! 2024-03, 3★: "I wish I could replace or delete things like bluetooth connection, notifications, activities and battery %."
- **Long horizons.** Event Countdown 2023-08, 3★: "doesn't allow me to go past 753 weeks. I want a count down to my 88 birthday as a mindfulness tool."
- **Hours in last day.** time2race above; Countdown! lists `hh:mm` mode within 24 h in features.
- **Clear an old event.** Countdown! 2022-01 above.
- **Free-text names.** Countdown! 2019-09, 3★: cannot enter "1/2" or "70.3" for triathlon name; 2023-09, 2★: "cannot save the race name".
- **More watches.** Event Countdown 2021-11 (FR45 black screen), 2023-01 (Venu 2), 2025-03 and 2026-04 (Descent Mk3i 47 mm and 43 mm: "Now can work for my MK3i 43mm"); Countdown! 2022-06 (Venu 2). Day-one support for new hardware earns praise.
- **Scripts and languages.** time2race 2017-10 (Russian), 2017-09 (Greek fonts). Non-Latin event names need system fonts.

## 4. Smaller findings

- Battery: 4 of Countdown!'s 49 low stars, all 2016–2017 (fenix 3 era). Not current complaint. New Year Countdown 2021-12 also one.
- Crashes, uninstall problems (time2race 2022-07 "causes my Garmin 935 to freeze", 2024-04 "cannot uninstall") are old builds.
- Praise: "Just shows exactly what is needed for an event countdown" (Event Countdown 2022-08, 5★), "Keeps you motivated" (2025-03; a marathon), "did an amazing job to prepare me for my first IronMan" (Countdown!). Runners, racers = visible core users.

## Limits

Reviews over-represent people with a problem. 32/49 figure from keyword match (36) with 4 false positives removed by hand. 13 reviews keywords missed contain: 1 more date-change complaint ("the countdown doesn't work anymore. I tried to change and did not work"), 4 other settings failures (race name will not save, FR45 "problem communicating" when editing settings, triathlon name characters, crash on changing a colour), 3 battery (2016–2017), 2 device (Venu 2 request, fenix 5s Plus), 1 usage question, 2 feature requests (heart rate, delete items). So **about two thirds of Countdown!'s low stars = date or saving it; about three quarters (37 of 49, adding sync error and other settings failures) = getting a setting onto watch.**