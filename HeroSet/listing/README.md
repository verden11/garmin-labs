# HeroSet — store listing (paste-ready)

Status: 2026-09-27. **1.1.2 uploaded, awaiting Garmin review** (the glance + idle-kill fix, [ADR-051](../docs/decisions.md#adr-051)/[052](../docs/decisions.md#adr-052)); fields below are what was submitted. Next after it clears: 1.2.0 (Connect sync).

Fields are in the order of the upload form (https://apps.garmin.com/en-US/developer/upload, step 2). One block = one field: copy the block, paste it. Nothing else is in this file; limits, why each answer is what it is, image sources and history are in [`NOTES.md`](NOTES.md).

## App file

[`../dist/HeroSet-store.iq`](../dist/HeroSet-store.iq): a fresh export before every upload (how and which file: [`NOTES.md`](NOTES.md)).

## Title (max 50)

```text
HeroSet - Bodyweight Rep Counter
```

## Description (max 4000)

```text
100 push-ups, 100 sit-ups and 100 squats a day, or your own goal from 10 to 500. Your Garmin counts the reps.

- Start a set, do your reps: HeroSet counts them with the watch's motion sensor.
- Runs on the watch's buttons: START and UP/DOWN, or START and a swipe on touchscreen watches. No phone, no account.
- After every set, check the count and adjust it before it's saved. Only the START button saves, so a stray tap can't.
- HeroSet learns from the counts you save, so counting adapts to how you move.
- Earn XP for every rep up to 100 per exercise a day, climb ranks and keep your streak alive. Rank reflects the reps you do, not the goal you pick.
- Set your own daily goal on the watch: 10 to 500 reps, no phone needed.
- Live heart rate and a calorie estimate during each set.
- A glance on watches with Connect IQ 4.0 or later: see today's progress and your streak from your glance list without opening the app.
- In 15 languages, including German, French, Spanish, Italian, Polish and Ukrainian.

Everything stays on your watch. HeroSet has no network access, records no activity and sends nothing to Garmin Connect. The store lists "Communication & Data Transmission" because HeroSet hands today's progress to our HeroFace watch face on the same watch; nothing is sent anywhere.

Good to know: counting depends on how you wear the watch and how you move, so the number can be off. Calories are the change in Garmin's own daily total, an estimate. Not a medical device.
```

## App Version (max 20)

```text
1.1.2
```

## What's New (max 4000)

```text
- New glance: add HeroSet to your watch's glance list to see today's push-ups, sit-ups, squats and your streak without opening the app. On watches with Connect IQ 4.0 or later.
```

## Hero Image (1440×720)

[`hero-1440x720.png`](hero-1440x720.png)

## Category

**Strength Training**

## Subcategory

**Other** (not marked required: leave blank if the form allows)

## Does your app collect user data?

**No**

## Privacy policy URL

```text
https://verden.watch/heroset/privacy/
```

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500)

[`cover-500-designed.png`](cover-500-designed.png)

## Screen Images (upload in this order)

1. [`screens/1-dashboard.png`](screens/1-dashboard.png)
2. [`screens/2-counting.png`](screens/2-counting.png)
3. [`screens/3-review.png`](screens/3-review.png)
4. [`screens/4-saved.png`](screens/4-saved.png)
5. [`screens/5-menu.png`](screens/5-menu.png) (optional)
6. [`screens/6-review-touch.png`](screens/6-review-touch.png) (optional, touch-watch hint `SWIPE: ADJUST`; Venu 4 41mm simulator, 390 px scaled to 454)

## Device icons (optional, 128×128)

- 64 Color: [`icon-64-128.png`](icon-64-128.png)
- 24 bit: [`icon-24-128.png`](icon-24-128.png)

## Email Address

```text
hello@verden.watch
```

## Source Code URL

Leave blank.

## Review Notification

**Yes**

## App Migration (add newly compatible devices)

**No**

## Monetization

**Paid: Yes**, USD 2.00

## Companion App URL / Additional Hardware Requirements

Leave blank.
