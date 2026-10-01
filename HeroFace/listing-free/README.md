# HeroFace (Free) — store listing (paste-ready draft)

**Do not paste a block while a `<` placeholder remains in it** (the Pro and HeroSet store URLs are owner-supplied; the Description block has two). Check each block for a `<` before pasting.

Status: 2026-10-01. **DRAFT, UNRELEASED, nothing uploaded.** Proposed under ADR-001 (Free + Pro ladder, `../docs/decisions.md`); the owner has not signed off, and **names, titles, the Pro and HeroSet store URLs and the price are the owner's decisions** (placeholders below are marked). Gates: [`../docs/go-to-market.md`](../docs/go-to-market.md) "Free + Pro pair". Why each answer and the open items: [`NOTES.md`](NOTES.md). The paid app's live listing is [`../listing/README.md`](../listing/README.md) (not changed by this draft).

Fields are in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details), the same order as the Pro listing. One block = one field: copy the block, paste it.

## App file

`../dist/HeroFaceFree.iq` (a **new** app: new app id `be68898f-995b-45d9-860e-42ad508bd7fd`), exported with `monkeyc -e -r -f monkey.free.jungle -o dist/HeroFaceFree.iq -y ~/.garmin-connectiq/keys/developer_key`. The form reads Manifest AppID, App Type (Watch Face) and Compatible Devices from the package.

## Title (max 50)

Placeholder, **owner decides** (and searches the store by eye for a collision first):

```text
HeroFace
```

## Description (max 4000, one box per language)

English only until the owner decides on translations (see [`NOTES.md`](NOTES.md)). Line 1 is the sibling's store URL; replace the placeholder with the real Pro URL once Pro is live. The HeroSet sentence needs HeroSet's real store URL; the owner fills it.

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
HeroSet mode needs HeroSet installed: get HeroSet here, <HEROSET STORE URL: owner fills in>. On Connect IQ 4.2+ watches with HeroSet, the bars show today's push-ups, sit-ups and squats instead, with your HeroSet rank and streak, and holding the face opens HeroSet. Without HeroSet, the face shows your everyday goals and nothing is missing.

HeroFace Pro adds
Choose what each of the three bars shows: steps, calories, intensity minutes, distance, floors or the move bar. Seconds beside the time. The temperature.

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

Not made; leave blank. (`../listing/hero-1440x720.png` is the Pro listing's and shows the paid face; do not reuse it for Free without the owner's look-approval.)

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

Not made for Free. **Owner's call** (visual identity). Do not reuse the Pro cover if it shows seconds or a temperature.

## Screen Images (under 150 KB each, upload in this order)

None exist for Free (none invented). See [`screenshots.md`](screenshots.md) for what to capture, from the Free build.

## Device icons (optional, 128×128)

Not made; leave blank.

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

Leave blank.
