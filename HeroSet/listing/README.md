# HeroSet — store listing (paste-ready)

Status: 2026-09-27. **1.2.0 uploaded, awaiting Garmin review** (the glance + idle-kill fix, [ADR-051](../docs/decisions.md#adr-051)/[052](../docs/decisions.md#adr-052); submitted as `1.2.0` rather than `1.1.2`, [ADR-053](../docs/decisions.md#adr-053)); fields below are what was submitted. Connect sync (1.3.0) is shelved, [ADR-054](../docs/decisions.md#adr-054); no next version decided yet.

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
1.2.0
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

Garmin caps this at 5 images; upload in this exact order (filenames are numbered to match).

1. [`screens-framed/1-dashboard.png`](screens-framed/1-dashboard.png) (fr965, goal 100)
2. [`screens-framed/2-counting.png`](screens-framed/2-counting.png) (fr965, mid-set, HR live)
3. [`screens-framed/3-review.png`](screens-framed/3-review.png) (fr965, review picker, `UP/DOWN: ADJUST`)
4. [`screens-framed/4-saved.png`](screens-framed/4-saved.png) (fr965, `+N SAVED` dashboard)
5. [`screens-framed/5-complete.png`](screens-framed/5-complete.png) (fr965, `DAILY MISSION COMPLETE`, 1 day streak)

All chassis + strap simulator captures of the store build (real, no mockups, [ADR-039](../docs/decisions.md#adr-039)). Replaces the earlier tight-crop `screens/1-6` set.

**Not used, kept as spares in the same folder** (menu and touch-device shots didn't make the 5-image cap): [`screens-framed/menu.png`](screens-framed/menu.png), [`screens-framed/venu-review-touch.png`](screens-framed/venu-review-touch.png) (Venu 4 41mm, `SWIPE: ADJUST`, has an added swipe-gesture glyph — the one non-capture graphic in this set).

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
