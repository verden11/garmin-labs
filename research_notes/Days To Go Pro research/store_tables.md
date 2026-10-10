# Store tables (public Connect IQ store API, read 2026-10-04)

Source: `GET .../apps/keywords?keywords=<q>&pageSize=30&countryCode=US` (same public API `tools/store_poll.py` reads), 12 keyword pages (13 review pages for reviews files), no login. `downloadCount` = bucket (1, 10, 100, 1000, 10k, ...), never exact count. `changedDate` = store field; many old faces show 2026-08-24 to 28 beside 2018 version string -> looks like bulk re-stamp, NOT reliable last-update date; version string better hint. Price = what store returns for `countryCode=US` (euro strings). Full rows: `countdown_faces.csv`.

## 1. Free countdown faces at download bucket 1,000 or more (genuine event countdowns)

| Face | Price | Downloads bucket | Reviews / rating | `changedDate` | Version | Permissions |
|---|---|---:|---|---|---|---|
| Countdown! | free | 100000 | 205 / 4.1 | 2019-10-10 | 2.5.0 | none |
| New Year Countdown | free | 50000 | 76 / 3.5 | 2023-12-28 | 1.3.0 | Positioning, SensorHistory, UserProfile |
| time2race... Countdown to race day! | free | 10000 | 78 / 4.1 | 2020-03-06 | 1.5.9E | SensorHistory, UserProfile |
| Watchface with altitude, moon, sun & count | free | 10000 | 36 / 4.2 | 2018-11-13 | Nov 2018 3 | Positioning, Background, SensorHistory, UserProfile, Ant, Communications, Sensor |
| Event Countdown | free | 10000 | 32 / 4.4 | 2026-03-14 | 1.1.3 | Positioning, SensorHistory, UserProfile |
| Countdown | free | 1000 | 11 / 4.0 | 2016-10-19 | 1.0-upd5 | none |
| Countdown - Watch & Track events | free | 1000 | 11 / 5.0 | 2026-08-25 | 1.0.2 | Background, Communications, ComplicationSubscriber |
| Garmin Run Indonesia 2023 | free | 1000 | 9 / 4.9 | 2024-02-27 | 1.1.5 | Positioning, SensorHistory, UserProfile |
| Garmin Run JAPAN 2023 | free | 1000 | 7 / 4.9 | 2024-02-27 | 1.1.1 | Positioning, SensorHistory, UserProfile |
| WC26 Live — Scores & Countdown | free | 1000 | 6 / 4.0 | 2026-08-25 | 1.0.4 | Background, Communications |
| Garmin Run Thailand 2023 | free | 1000 | 5 / 5.0 | 2024-02-27 | 1.1.1 | Positioning, SensorHistory, UserProfile |
| Garmin Run Vietnam 2023 | free | 1000 | 4 / 5.0 | 2024-02-27 | 1.1.1 | Positioning, SensorHistory, UserProfile |
| Garmin Run Asia Series 2023 - Malaysia | free | 1000 | 2 / 5.0 | 2024-02-27 | 1.0.1 | Positioning, SensorHistory, UserProfile |
| UTVV Race Countdown | free | 1000 | 1 / 5.0 | 2026-08-25 | v1 | Positioning, Background, SensorHistory, UserProfile, Ant, Communications, ComplicationSubscriber, PushNotification, BluetoothLowEnergy, Notifications, Sensor |

Seasonal, fixed-event faces in that bucket included above (New Year Countdown; Grinch/Merry Christmas in external-unlock table).

## 2. Store-priced faces that mention a countdown (all of them found)

| Face | Price | Downloads bucket | Reviews / rating | `changedDate` | Version | Permissions | Real event countdown? |
|---|---|---:|---|---|---|---|---|
| F1 2026 Drivers AMOLED | 3,49€ | 100 | 8 / 4.9 | 2026-08-30 | 1.3.0 | Positioning, Background, UserProfile, Communications, ComplicationSubscriber | yes |
| Gold Countdown | 2,99€ | 10 | 0 / 0 | 2026-08-25 | 1.0.0 | none | no: title only: description = digital face (steps, calories, battery, AOD), no event |
| Cap – Countdown to Your Day | 2,49€ | 1 | 2 / 5.0 | 2026-08-27 | 1.0.0 | none | yes |
| Race Countdown Watch | 2,69€ | 1 | 1 / 5.0 | 2026-08-25 | 1.0.0 | Background, SensorHistory, UserProfile, Communications, ComplicationSubscriber | yes |
| World Cup 2026 Kick off Countdown | 2,99€ | 1 | 1 / 5.0 | 2026-08-25 | 1.3.0 | Background, SensorHistory, Communications, ComplicationSubscriber | yes |
| Countdown | 2,49€ | 1 | 0 / 0 | 2026-07-02 | 1.0 | none | yes |
| Countdown | 2,99€ | 1 | 0 / 0 | 2026-08-27 | 1 | none | no: title only: description 'Digital watchface with AOD', no event |
| Blue Countdown | 2,99€ | 1 | 0 / 0 | 2026-08-25 | 1.0.0 | none | no: title only: description = digital face with seconds ring, no event |
| RocketTime | 2,49€ | 1 | 0 / 0 | 2026-08-24 | 0.5 | Background, Communications | yes |
| Days To Go | 2,49€ | 0 | 0 / 0 | 2026-09-26 | 1.0.1 | none | no: our own listing (excluded from rival counts) |

Reading (fact): 6 real paid countdown faces besides ours; 5 at bucket 1, none has more than 2 reviews. One at bucket 100 (F1 2026 Drivers AMOLED, 3,49 EUR, 8 reviews, 4.9) = team-theme face, countdown optional feature. **No paid face whose job is the countdown has sold.**

## 3. Free listings that sell an unlock outside the store (`paymentModel` 1 or unlock text in the description)

41 genuine listings; download buckets: 1 x2, 10 x10, 100 x25, 1,000 x4. Prices named in descriptions (count of mentions): $1.49 x17, $1.99 x4, $2.99 x3, $4.99 x3, $1.69 x2, $14.99 x2 (700-face library), $1.39, $2.89, $0.30. 35 match seasonal / fixed-event name pattern (Christmas, New Year, Halloween, winter, race names).

Not feature split: unlock opens whole face (trial wall), so what descriptions list = the product, not what buyers pay extra for. Downloads = installs of free listing; **sales are not visible**.

| Face | Price | Downloads bucket | Reviews / rating | `changedDate` | Version | Permissions |
|---|---|---:|---|---|---|---|
| Formula 1 - F1 -2026 Season (animated+coun | free | 1000 | 23 / 4.7 | 2026-08-28 | 2.5 | Positioning, SensorHistory |
| Merry Christmas | free | 1000 | 3 / 4.7 | 2023-11-15 | 1.0.4 | Background, Communications |
| Grinch Christmas Countdown | free | 1000 | 2 / 4.0 | 2021-11-14 | 1.0.0 | Background, Communications |
| Fragile Winter | free | 1000 | 2 / 4.0 | 2023-11-15 | 1.0.4 | Background, Communications |
| Halloween Countdown | free | 100 | 7 / 4.9 | 2026-09-14 | 1.0.3 | Positioning, Background, SensorHistory, UserProfile, Communications |
| Countdown | free | 100 | 2 / 4.5 | 2026-08-28 | 3.5.3 | Background, SensorHistory, Communications, ComplicationSubscriber |
| Custom countdown | free | 10 | 1 / 5.0 | 2026-08-25 | 1.0.1 | Positioning, Background, SensorHistory, UserProfile, Communications |
| Race Day Watch Face - Race Countdown | free | 1 | 0 / 0 | 2026-10-03 | 1.1.5 | Background, Communications, ComplicationSubscriber |

## 4. Apps, widgets and data fields (keywords=countdown, no appType filter, first 30 results)

| Name | Type | Price | Downloads bucket | Reviews / rating |
|---|---|---|---:|---|
| Countdown | widget | free | 1000 | 29 / 4.3 |
| KAP Countdown | widget | free | 10 | 2 / 5.0 |
| CountDown | data field | free | 1000 | 2 / 3.0 |
| Countdown Days | widget | free | 1000 | 21 / 3.7 |
| Workout Countdown | data field | free | 100 | 0 / 0 |
| Date Countdown | widget | free | 1000 | 9 / 4.0 |
| Countdown Alarm | watch app | free | 100 | 1 / 5.0 |
| Christmas Countdown | widget | free | 100 | 3 / 5.0 |
| Lap Countdown | data field | free | 1000 | 1 / 5.0 |
| Goal Countdown | data field | free | 1000 | 26 / 4.8 |
| Lap Countdown | data field | free | 100 | 2 / 3.0 |

All 11 non-face results free. Widgets "Countdown" (1,000; 29 reviews; 4.3), "Countdown Days" (1,000; 21; 3.7), "Date Countdown" (1,000; 9; 4.0) exist; data field "Goal Countdown" has 26 reviews at 4.8. Not covered: search was one page; `appType` filter value for apps returned HTTP 400.

## 5. Our own listing and the polled baseline

`research_notes/Free and Pro ladder/poll.csv` (2026-10-04): Days To Go (store id 95adf037-...), bucket 1, 0 reviews, version 1.0.1, 2.49 EUR, 96 device types in detail endpoint. Keyword endpoint reports 199 device types for same listing, so **device-type counts differ between the two endpoints; `device_types` column in CSV = keyword endpoint's, not comparable across tools.**