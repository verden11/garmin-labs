# HeroSet — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

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
- Also on the black-and-white Instinct E (40 and 45 mm) and Instinct 3 Solar.
- In 15 languages, including German, French, Spanish, Italian, Polish and Ukrainian.

Everything stays on your watch. HeroSet has no network access, records no activity and sends nothing to Garmin Connect. The store lists "Communication & Data Transmission" because HeroSet hands today's progress to our HeroFace watch face on the same watch; nothing is sent anywhere.

Good to know: counting depends on how you wear the watch and how you move, so the number can be off. Calories are the change in Garmin's own daily total, an estimate. Not a medical device.

HeroSet is a paid app. Refunds follow the Connect IQ Store return window.
```

## App Version (max 20)

```text
1.3.1
```

## What's New (max 4000)

```text
- Instinct E and Instinct 3 Solar: text near the corners of the screen is no longer cut off by the bezel, so START: MENU and the finished-day message show whole.
- Instinct E and Instinct 3 Solar: the glance now sits beside the round window instead of under it, and its bars show empty and full in black and white.
```

## Hero Image (1440×720)

OWNER: look to approve (it now shows an Instinct E 45 mm beside two Forerunner 965 screens; [`screenshots.md`](screenshots.md)).

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

OWNER: look to approve (the shield is now the launcher icon's current shape; also the two device icons below).

[`cover-500-designed.png`](cover-500-designed.png)

## Screen Images (upload in this order)

OWNER: the looks of these five are yours to approve before upload (re-rendered 2026-10-04 from the 1.3.1 store build; how in [`screenshots.md`](screenshots.md)).

Garmin caps this at 5 images, each under 150 KB; upload in this exact order (filenames are numbered to match).

1. [`screens-framed/1-dashboard.png`](screens-framed/1-dashboard.png): Today at a glance: rank, three bars, one screen (Forerunner 965).
2. [`screens-framed/2-counting.png`](screens-framed/2-counting.png): Counting a set: the big count and today's total (Forerunner 965).
3. [`screens-framed/3-review.png`](screens-framed/3-review.png): Check and adjust the count before it is saved (Forerunner 965).
4. [`screens-framed/4-complete.png`](screens-framed/4-complete.png): Daily mission complete, all three done, streak started (Forerunner 965).
5. [`screens-framed/5-instinct.png`](screens-framed/5-instinct.png): **The Instinct one**: the same dashboard in black and white on an Instinct E 45 mm.

All chassis + strap simulator captures of the store build (real, no mockups, [ADR-039](../docs/decisions.md#adr-039)). The earlier set (`1-dashboard` ... `5-complete`, the spares) is in `old/`. The store takes no caption field here; the one-line captions above are for your own reference (and the site, if it reuses them).

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

**Paid: Yes**, price tier USD 2.50 (the form's own selection; this is the one place a number appears, never in the description text above)

## Companion App URL / Additional Hardware Requirements

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and this listing's live value is already the bare URL (owner, 2026-10-02: used as the link to the website; Garmin's research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/heroset/
```
