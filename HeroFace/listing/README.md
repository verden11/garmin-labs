# HeroFace — Connect IQ Store listing

Everything the store form needs, paste-ready: upload-form answers, the
description, and What's New per version (newest first). Paths are relative to
`HeroFace/`. Also in this folder:

| File | What it is |
|---|---|
| `listing/descriptions.md` | The description opening in all 15 languages |
| `listing/screenshots.md` | The captured set, where each came from, how to re-render the composed images |
| `listing/screens/`, `listing/src/`, PNGs | The images and their generators (adapted from HeroSet's) |

Release history: `CHANGELOG.md`. Claims and gates: `docs/go-to-market.md`.
Build the upload package: `monkeyc -e -r -f monkey.jungle -o bin/HeroFace-next.iq -y ~/.garmin-connectiq/keys/developer_key`.
Review takes about 72 hours; a rejection comes back with specific reasons.

**Submitted 2026-09-21, approved and live 2026-09-22:**
https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116 . Every field
was drafted and checked against what the build actually does
(`docs/go-to-market.md`, "Claims allowed and forbidden"). The one open choice is
in `listing/descriptions.md`: paste the English full description for every language, or
translate it.

## The basics

The upload form (`apps.garmin.com/developer/upload`, captured 2026-09-21) is
**two steps**: attach the `.iq`, then enter details. It does **not** ask for a
price, a support URL or a website — those are not fields here.

| Field | Value |
|---|---|
| App File | `bin/HeroFace-next.iq` for 1.0.1 (1.0.0 shipped from `bin/HeroFace.iq`) |
| Manifest AppID | `8cd8f7f5216942a6b6c2c1e797e2f313` (shown by the form; matches `manifest.xml`) |
| Version | **1.0.1** for this update (1.0.0 at launch). The HeroFace form showed the version read from the package; HeroSet's form took it as free text, so type it if a field asks |
| App Type | Watch Face (read from the package) |
| Title (max 50 chars) | HeroFace |
| Category | **Digital** — the form's watch-face list is Analog, Animal, Around the world, Cartoon, Digital, Family, Fantasy, Fun, Geek, Marine, Nature, Retro, Simple, Stylish, Utility. "Simple" is the other defensible pick. There is no "Watch Faces" option. |
| Subcategory | Whatever the Category choice offers |
| Email Address | hello@verden.watch — shown publicly as the app's contact |
| Languages | Added one at a time: pick a language, press **Add**, fill Title + Description for it |

Not on this form, and not to be invented: price, support URL, website. The
support URL reaches buyers only through the last line of the description, so
keep that line.

## Description (the one field, max 4000 characters)

The form has **no short/long split** — one Description box per language, 4000
characters. The store truncates it itself in list views, so the first sentence
carries the same weight a short description would.

Paste this whole block into the Description box as it is. It is plain text:
the store shows `**` and `>` literally and keeps every line break, so the old
hard-wrapped draft broke lines mid-sentence on the live page (checked
2026-09-25). Other languages: `listing/descriptions.md` (their rows are the old
opening; update them if you ever paste per-language descriptions).

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

Changed from the 1.0.0 draft: no watch count and no Forerunner 55 (the store's
Compatible Devices list shows fewer products than the manifest, `docs/go-to-market.md`),
no "the line turns grey" (after a missed day the line disappears; it is grey
only while today's goal is still open), and the permission label explained.

## What's new (version 1.0.1)

App Version: **`1.0.1`** — upload `bin/HeroFace-next.iq` (exported 2026-09-24). History in `CHANGELOG.md`.

```text
- Installed HeroSet while HeroFace was on your watch? The face now picks it up within a minute, without switching faces.
- Fahrenheit temperatures are now rounded instead of cut off: 21 °C shows as 70 °F, not 69.
- The "HeroSet" mode setting is gone. It did the same as Auto, which stays the default; if you had picked it, your face looks the same.
- Reliability improvements.
```

## What's new (version 1.0.0)

> First release.

## Keywords / tags

Paste these if the form asks, most relevant first; trim from the end if it
caps the count:

> watch face, steps, daily goals, intensity minutes, floors, streak,
> always-on, minimal, data face, HeroSet

Every one of them is something the face actually does, which is the rule in
`docs/go-to-market.md`: a keyword the build does not deliver reads as a false
claim in review.

## Screenshots

Captured, in `listing/screens/`, upload in the numbered order. One
device is enough — HeroSet shipped five shots from a single device and passed
review; there is no per-device-family requirement. The cover, hero and device
icons sit alongside them in `listing/`. The always-on shot was
**deferred to a post-launch listing update** (user call, 2026-09-21): it needs
a human at the simulator GUI, and the five screens satisfy review without it.
See `listing/screenshots.md`. Nothing here is outstanding for submission.

## The rest of the form

Field by field, in the order the page shows them (captured 2026-09-21). The
answers follow HeroSet's (`../HeroSet/listing/README.md`) except
where the watch-face form differs.

| Field | Answer |
|---|---|
| Hero Image (optional, 1440×720, < 2048 KB) | `listing/hero-1440x720.png` (241 KB) |
| Category / Subcategory | See the basics table — **Digital** |
| Does your app collect user data? | **No.** Nothing leaves the watch. The privacy-policy URL field is conditional on answering Yes, so it may not appear at all. |
| Does your app decode/encode any ANT+ profiles? | No |
| Does your app have regional limits? | No |
| Cover Image (500×500, **< 300 KB**) | `listing/cover-500.png` (76 KB) |
| Device icons (optional, 128×128) | `listing/icon-64-128.png`, `icon-24-128.png` |
| Screen Images (**< 150 KB each**) | `listing/screens/`, numbered order. All five are 3.5–20 KB. |
| Preview Video (optional) | None. YouTube/Vimeo only. |
| Email Address | hello@verden.watch — displayed publicly |
| Source Code URL (optional) | Blank — not open source |
| Review Notification | Yes |
| App Migration (add newly compatible devices) | **No.** Support is the explicit 117-product list in `docs/compatibility.md`; letting the store add untested devices would ship a layout nobody has run. |
| Monetization | **No.** The form's own wording: Yes only if the app requests payment to enable features, or asks for tips or donations. HeroFace does neither — it is paid through the store, which is not what this field asks. |
| iOS / Android Companion App URL (optional) | Blank. HeroSet is not a companion app — it is a separate paid watch app the face can read. |
| Additional Hardware Requirements (optional) | Blank |

**Compatible Devices** is read from the package, not chosen. The form expands
the manifest's 117 products into Garmin's marketing names (Mercedes-Benz
editions, ForeAthlete variants, per-size fēnix 9 entries), so the list looks
longer than 117. That is expected, not a manifest error.

## Before you submit

- [x] **Resolve "Signature check failed."** The upload page shows it directly
      under `Status: Verified`, inside the success banner (captured
      2026-09-21 20:54 GMT). Cannot tell from the capture whether it is a real
      error or template noise. **Check the live page; do not submit on a real
      signature failure.** The `.iq` was signed with
      `~/.garmin-connectiq/keys/developer_key`, the same key as HeroSet's live
      listing.
- [x] Support and privacy URLs resolve — all three `/heroface/` pages returned
      200 again on 2026-09-21
- [x] The `.iq` package is built from the current source — `bin/HeroFace.iq`
      rebuilt 2026-09-21 23:30 from a clean HEAD tree, 196/196 devices
- [ ] Gate 1 in `docs/go-to-market.md` is done: the device session
      **Deliberately not waited for (user call, 2026-09-21).** The plan was to
      submit and **withdraw during review if anything fails**.
      **That contingency expired: approval landed 2026-09-22, faster than the
      ~72 h assumed, and the listing is live.** The trigger to watch was
      ghosting, because the full description claims always-on "respects your
      watch's always-on rules". **It came back clean: the night of
      2026-09-21/22 on the FR965, sleep mode off, showed no retention, and the
      midnight reset fired (`docs/go-to-market.md` §1).** So the claim is backed
      and nothing needs withdrawing. Still unanswered: the seconds power
      budget, a battery window with both readings timed, MIP. None of those is
      claimed in the listing; if one fails, the remedy is a code fix **plus a
      version update and a listing edit** — withdrawal is no longer the lever.
- [x] HeroSet's side is shipped: **HeroSet 1.1.0 went live 2026-09-21** carrying
      `HeroSetComplicationPublisher` (`docs/go-to-market.md` §2), so the description's
      "With HeroSet" clause is true for buyers on CIQ 4.2+ who have updated. The
      2026-09-20 plan to submit both in one window is moot — HeroSet went first.
- [ ] Read Garmin's App Review Guidelines (SDK docs → Reference Guides)
- [x] After the listing goes live: fill `storeUrl` in
      `../verden-site/src/apps/heroface/app.ts` with
      `https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116`
      — **done 2026-09-22**, after the listing returned 200. The site is
      prerendered, so the Get button renders only after a rebuild and deploy.
      HeroSet's equivalent is `../HeroSet/docs/go-to-market.md` item 8.
- [ ] Post-launch: install the store build on the FR965 and test the settings
      round-trip through Connect — the one check sideloading could not do
      (`docs/go-to-market.md` §1).
