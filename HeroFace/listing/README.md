# HeroFace — store listing (paste-ready)

Status: 2026-09-26. **1.0.1 is live.**

Fields are in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Nothing else is in this file; limits, why each answer is what it is, the other languages and history are in [`NOTES.md`](NOTES.md).

## App file

[`../dist/HeroFace.iq`](../dist/HeroFace.iq) for 1.0.1. The form reads Manifest AppID (`8cd8f7f5216942a6b6c2c1e797e2f313`), App Type (Watch Face) and Compatible Devices from the package.

## Title (max 50)

```text
HeroFace
```

## Description (max 4000, one box per language)

Languages are added one at a time: pick a language, press **Add**, fill Title + Description. Only English is drafted; see [`NOTES.md`](NOTES.md) for the other languages.

```text
The time first, today's goals right under it. Three bars you choose, a ring for the whole day, a streak worth keeping — or your HeroSet reps and rank, if you have it.

The time owns the screen
The time is the largest thing on the face, at the largest size your watch can draw. Under it, today's three goals as bars: steps, intensity minutes and floors, or whichever three you pick. The ring around the bezel is the whole day at once, and it fills green when all three are met.

Three bars, your choice
Each bar can show steps, calories, intensity minutes, distance, floors or the move bar. Pick your accent colour, show or hide seconds, show or hide the temperature — all from Garmin Connect.

Only what your watch measures
No watch has every sensor. Without a barometer there are no floors; older watches have no weather. Each bar falls back to the next thing your watch really measures, and anything it cannot know is left out — no empty bars, no invented numbers.

Keep the streak
Meet your step goal and a gold line counts the days in a row. Miss a day and the count starts again.

Round watches, one design
It measures itself to your screen, up to a 466-pixel fēnix. On always-on watches it dims to a quiet clock that shifts position every minute. See Compatible Devices for your model.

With HeroSet
On Connect IQ 4.2+ watches, if you own HeroSet — the daily push-up, sit-up and squat app — the bars can show today's reps, your rank and your HeroSet streak instead, and holding the face opens HeroSet. Without HeroSet, nothing is missing.

Nothing leaves your watch
No account, no internet, no analytics, no ads. The store lists "Communication & Data Transmission" because HeroFace can read HeroSet's progress on the same watch; nothing is sent anywhere.

Support and answers: https://verden.watch/heroface/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.1
```

## What's new

```text
- Installed HeroSet while HeroFace was on your watch? The face now picks it up within a minute, without switching faces.
- Fahrenheit temperatures are now rounded instead of cut off: 21 °C shows as 70 °F, not 69.
- The "HeroSet" mode setting is gone. It did the same as Auto, which stays the default; if you had picked it, your face looks the same.
- Reliability improvements.
```

## Keywords / tags (only if the form asks; trim from the end if it caps the count)

```text
watch face, steps, daily goals, intensity minutes, floors, streak, always-on, minimal, data face, HeroSet
```

## Hero Image (optional, 1440×720, under 2048 KB)

[`hero-1440x720.png`](hero-1440x720.png)

## Category

**Digital**

## Subcategory

Whatever the Category choice offers.

## Does your app collect user data?

**No.** The privacy-policy URL field is conditional on Yes, so it may not appear.

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500, under 300 KB)

[`cover-500.png`](cover-500.png)

## Screen Images (under 150 KB each, upload in this order)

1. [`screens/1-everyday.png`](screens/1-everyday.png)
2. [`screens/2-goals-met.png`](screens/2-goals-met.png)
3. [`screens/3-heroset.png`](screens/3-heroset.png)
4. [`screens/4-heroset-complete.png`](screens/4-heroset-complete.png)
5. [`screens/5-no-barometer.png`](screens/5-no-barometer.png)

## Device icons (optional, 128×128)

- 64 Color: [`icon-64-128.png`](icon-64-128.png)
- 24 bit: [`icon-24-128.png`](icon-24-128.png)

## Preview Video (optional)

None (YouTube/Vimeo only).

## Email Address (shown publicly)

```text
hello@verden.watch
```

## Source Code URL (optional)

Leave blank.

## Review Notification

**Yes**

## App Migration (add newly compatible devices)

**No**

## Monetization

**No**

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Leave blank.
