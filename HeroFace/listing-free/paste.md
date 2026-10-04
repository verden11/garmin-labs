# HeroFace (Free) — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block while a `<` placeholder remains in it** (the Pro store URL on line 1 is owner-supplied; HeroSet is live and its URL is filled in). Check each block for a `<` before pasting.

## Title (max 50)

Placeholder, **owner decides** (and searches the store by eye for a collision first):

```text
HeroFace
```

## Description (max 4000, one box per language)

English only until the owner decides on translations (see [`NOTES.md`](NOTES.md)). Line 1 is the sibling's store URL; replace the placeholder with the real Pro URL once Pro is live. The HeroSet sentence carries HeroSet's live store URL (from the site's `storeUrl`).

```text
Get HeroFace Pro: <PRO STORE URL: owner fills in once the Pro listing is live>

The time first, today's goals right under it. Three bars, a ring for the whole day, a streak worth keeping — or your HeroSet reps and rank, if you have it.

The time owns the screen
The time is the largest thing on the face, at the largest size your watch can draw. Under it, today's three goals as bars: steps, intensity minutes and floors. The ring around the bezel is the whole day at once, and it fills green when all three are met.

Only what your watch measures
No watch has every sensor. Without a barometer there are no floors. Each bar falls back to the next thing your watch really measures, and anything it cannot know is left out — no empty bars, no invented numbers.

Keep the streak
Meet your step goal and a gold line counts the days in a row. Miss a day and the count starts again.

Your accent colour
Blue, cyan or magenta, from Garmin Connect.

Round watches, one design
It measures itself to your screen, up to a 466-pixel fēnix. On always-on watches it dims to a quiet clock that shifts position every minute. See Compatible Devices for your model.

With HeroSet
HeroSet mode needs HeroSet installed (https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377). On Connect IQ 4.2+ watches with HeroSet, the bars show today's push-ups, sit-ups and squats instead, with your HeroSet rank and streak, and holding the face opens HeroSet. Without HeroSet, the face shows your everyday goals and nothing is missing.

HeroFace Pro adds
Choose what each of the three bars shows: steps, calories, intensity minutes, distance, floors or the move bar. Seconds beside the time. The temperature.

If this face works for you, a rating in the store helps other people find it.

Nothing leaves your watch
No account, no internet, no analytics, no ads. The store lists "Communication & Data Transmission" because HeroFace can read HeroSet's progress on the same watch; nothing is sent anywhere.

Support and answers: https://verden.watch/heroface/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.0
```

## What's new

```text
First release of the free HeroFace: the time, three goal bars, a progress ring, your streak, three accent colours, and HeroSet mode if you have HeroSet.
```

## Hero Image (optional, 1440×720, under 2048 KB)

**OWNER approves the looks of every image below (screens, hero, cover, icons) before upload.** Rendered 2026-10-04 from the current Free build in the simulator ([`screenshots.md`](screenshots.md)); the Pro listing's images carry a "PRO" pill, these do not (do not swap them).

[`hero-1440x720.png`](hero-1440x720.png)

## Category

**Digital** (as the Pro listing)

## Subcategory

Whatever the Category choice offers.

## Does your app collect user data?

**No.** The privacy-policy URL field is conditional on Yes, so it may not appear.

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500, under 300 KB)

[`cover-500.png`](cover-500.png) (**OWNER**: the plain mark and the name; Pro's cover adds a PRO pill. Do not use the Pro cover here.)

## Screen Images (under 150 KB each, upload in this order)

Caption in brackets is for you, not a form field.

1. [`screens/1-everyday.png`](screens/1-everyday.png) (FR965: the time, three goal bars, the ring)
2. [`screens/2-accent-cyan.png`](screens/2-accent-cyan.png) (FR965: your accent colour, here Cyan)
3. [`screens/3-goals-met.png`](screens/3-goals-met.png) (FR965: every goal met, check marks, the streak)
4. [`screens/4-heroset.png`](screens/4-heroset.png) (FR965: HeroSet mode, reps, rank and streak)
5. [`screens/5-instinct-e40.png`](screens/5-instinct-e40.png) (**the Instinct one**: Instinct E 40 mm, black and white, the ring as a gauge in the round window)

## Device icons (optional, 128×128)

- 64 Color: [`icon-64-128.png`](icon-64-128.png)
- 24 bit: [`icon-24-128.png`](icon-24-128.png)

(**OWNER**: the plain mark, as the cover.)

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

**No** (this is a new app, not an update)

## Monetization

**No**: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission (`../listing/NOTES.md` records that wording is easy to misread).

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/heroface/
```
