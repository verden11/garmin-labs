# HeroSet listing — notes

What sits behind [`paste.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Paths are relative to `HeroSet/listing/`. Release history: [`../CHANGELOG.md`](../CHANGELOG.md).

## Economics and rules

Paid, the $2.50 tier (owner's form selection, set with the 1.3.1 upload; live at the $2.00 tier until then; [ADR-056](../docs/decisions.md#adr-056), the $2.50 tier for every paid app; no price number in any listing text), no trial ([ADR-039](../docs/decisions.md#adr-039), the no-trial part). Garmin takes 15% of the tax-exclusive price; $100/yr merchant fee; $10 minimum payout (re-verify, values change). Merchant approved 2026-09-18.

Garmin expects every listed product tested, screenshots matching the app, permissions justified. Accepted gap: 79 of 80 simulator-verified only ([ADR-039](../docs/decisions.md#adr-039), [ADR-048](../docs/decisions.md#adr-048)). Refs: [monetization](https://developer.garmin.com/connect-iq/monetization/), [publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/), [app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

Live listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377. Support page (not a form field): https://verden.watch/heroset/support/. Site source: `../../site`.

## Upload file

1.3.1 was uploaded 2026-10-04 from `dist/HeroSet-1.3.1.iq` (exported 2026-10-04 from main after the glance layout beside the Instinct's window, on top of the bezel-corner and START: MENU fixes, [ADR-055](../docs/decisions.md#adr-055) amendments): 87 products, 134 device variants, same app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`, permissions exactly `Sensor` + `ComplicationPublisher`. 1.3.0, which is live, was uploaded from the 2026-10-03 export. Older exports were deleted 2026-10-05; rebuild any of them from its git tag or commit. Re-export if any source changes before the next upload ([`../docs/development.md`](../docs/development.md); `dist/` holds only the current export; `bin/` is scratch).

## Form limits and options

Saved page, 2026-09-19: Title 50, Description 4000, What's New 4000, App Version 20.

- **Category options:** Beliefs, Business, Celestial, Communication, Education, Entertainment, Finance, Food & Drink, Games, Golf, Health & Fitness, Home Automation, Lifestyle, Marine, Medical, Navigation, Social, Sports, Strength Training, Tools, Travel, Weather, Wellness. The API read 219 (Health & Fitness) on 2026-09-25: see the open item in [`../docs/status.md`](../docs/status.md).
- **Subcategory options:** Cycling, Geocaching, Hiking, Other, Running, Swimming, Walking. No strength option.

## Why each answer

| Field | Reason |
|---|---|
| Description | Plain text, keep line breaks; the first line is what list views show. Checked against the forbidden claims in [`../docs/release-contract.md`](../docs/release-contract.md) on 2026-09-22, and again on 2026-09-26 for the glance line (63 of 80 watches, no reminder/alert wording) (the 2026-09-19 check predates the daily-goal line and the current contract); submitted for 1.2.0 on 2026-09-27. |
| App Version | Free text, not read from the manifest; bump on every upload (patch for fixes, minor for features). 1.3.0 live, 1.3.1 in review (2026-10-04); history: 1.1.1 ([ADR-050](../docs/decisions.md#adr-050)); the glance build ([ADR-051](../docs/decisions.md#adr-051)) was submitted as **1.2.0**, not the 1.1.2 it was called during development ([ADR-053](../docs/decisions.md#adr-053)); Connect sync (1.3.0) is shelved, [ADR-054](../docs/decisions.md#adr-054). |
| Collects user data | No: the store build has no network access, no activity recording, no sync ([ADR-033](../docs/decisions.md#adr-033)). The privacy policy is still linked (gate 6). |
| Cover Image | Shield + name only: it shows at about 100 px in browse, so no screen text. **Flat amber ground `#FFAA00` since 2026-10-04 (ROADMAP 10.25, owner decision: Garmin's brand page says "Do not choose black or transparent backgrounds").** Navy `#0B1B33` shield outline, plate, "Hero" and tagline (9.0:1 on the amber), "Set" blue `#0A3FB0` (4.7:1), the gold rim and the H stay amber. Amber is the shield's own colour and is the one hue the other covers (HeroFace blue, Days To Go mint, DayArc indigo, Two Suns violet/sky) do not use. Read at 100 px: the shield, the H and the name hold. **Rejected, looked at:** (B) orange `#FF7A1A` with a solid navy shield and white "Set": white on the orange is 2.6:1, and the orange is a different brand colour from the shield's gold; (C) deep blue `#0B3C9E` with the gold shield and white/amber name: strong and keeps the old look, but it sits in the blue family of HeroFace and reads as that app's sibling at thumbnail size; (A) amber with a plain navy shield (no gold rim): clean, but loses the shield's gold-and-dark look, which the chosen one keeps. The hero keeps its three black-screen watches (two Forerunner 965 and the Instinct E 45 mm) on the same amber with a warm brown shadow. The 128x128 device icons stay on black (the brand quote is about the 500x500 cover). Owner approves the look before upload. |
| Screen Images | Simulator captures of the store build ([ADR-039](../docs/decisions.md#adr-039)), no mockups; the app's own pixels are never altered. Re-taken 2026-10-04 (the UI had changed since 2026-09-27): five images, the story home screen, counting, review and adjust, mission complete, plus one Instinct. Chassis+strap style: the whole simulator window cropped to the skin, 720², background keyed to transparent (flood fill from the corners), 256 colours to stay under the 150 KB cap: the only post-capture edit, cosmetic only. The Instinct image is an **Instinct E 45 mm** because the Instinct 2 family and Descent G1 are not on Garmin's paid-app product list (a paid listing is not sold there), and the caption names no Instinct 2 watch. The seeded reps (60/45/30, 100/100/100) are put in through the app's own store, the day and time are the simulator's canned ones. The counting screen reads `HR 145` and `CAL 0`: the heart rate is the simulator's own activity simulation (Simulation > Activity Data), calories stay 0 there; it is simulator data, do not claim a live or accurate reading from this picture. If a shot shows a changed UI, re-take it and update the site copy in `../../site/public/heroset/screens/`. How, with commands: [`screenshots.md`](screenshots.md). |
| Email | The dedicated support address, also on the site's support and privacy pages. |
| App Migration | No: support is an explicit list of products (80 live, 87 from 1.3.0; [`../docs/compatibility.md`](../docs/compatibility.md), [ADR-034](../docs/decisions.md#adr-034)/[035](../docs/decisions.md#adr-035)/[037](../docs/decisions.md#adr-037)/[038](../docs/decisions.md#adr-038)/[048](../docs/decisions.md#adr-048)); don't let the store add untested devices. |
| Monetization | Paid through the store. |
| Refund wording | No refund or return wording appears in listing text (owner decision, 2026-10-04). |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/heroset/` only. The API field is `hardwareProductUrl`; the live value is already the bare URL. The old sentence ("No additional hardware needed. Help, privacy and more apps: ...") is retired (ROADMAP 10.16). |
| Device claims | The package has 87 products, but Garmin's paid-app list excludes Instinct 2, 2S, 2X and Descent G1, so the paid listing is not sold on them (guideline 4b; ROADMAP 10.15). Listing text never names watch models; the store's device tab is the claim (owner, 2026-10-04). The live 1.3.0 description and What's New still name the four: the description is edited in the dashboard with the 1.3.1 upload ([`../docs/status.md`](../docs/status.md) G). |

## Image sources

- **Framed** marketing set (1300×1300, the 2026-09 UI): deleted 2026-10-05, in git history; re-frame from `screens-framed/` if ads need it.
- **Hero** (`hero-1440x720.png`): the framed screens 1, 2 and 5 (two Forerunner 965, one Instinct E 45 mm), strap ends faded, on the flat amber ground (287 KB). Source `src/hero.html`.
- **Cover** (`cover-500-designed.png`, 500×500, flat amber, 12 KB): source `src/cover.html`.
- **Device icons:** the launcher icon's shield (current pixel-grid shape) on black, `src/icon.html`; the 64-colour one is the same render snapped by `src/quantize64.py`.
- All three, and the icons, are rendered by `../tools/render_listing.sh`; the screens by `../tools/drive_screens.sh` + `docker/frame_listing.sh` (`src/frames.txt`) ([`screenshots.md`](screenshots.md)). The shield was redrawn on 2026-10-04 to match the launcher icon (it had the heavier pre-pixel-grid shape): a look change for the owner to approve.

## What's New: history and copy rules

Copy rules: name no watch model, Instinct or otherwise, and no language or language count (owner rule, 2026-10-04; the store's device tab is the device claim, and the Instinct 2 family and Descent G1 are not sold on a paid app, [`../docs/release-contract.md`](../docs/release-contract.md) "Paid vs free reach"); the glance is "on watches with Connect IQ 4.0 or later" (66 of 87 products, 63 of 80 before the Instinct E and Instinct 3 Solar; the Instinct 2 family has none; never "all watches", never "reminder"/"alert", [ADR-051](../docs/decisions.md#adr-051)); any HeroFace mention needs the qualifier "On watches running Connect IQ 4.2 or later" ([ADR-044](../docs/decisions.md#adr-044)); keep the reliability line unspecific, because naming the defect advertises it and [`../docs/release-contract.md`](../docs/release-contract.md) already says adjust, never fix.

**1.3.1** (uploaded 2026-10-04, in Garmin review)

```text
- Black-and-white screens: text near the corners is no longer cut off by the bezel, so START: MENU and the finished-day message show whole.
- Black-and-white screens: the glance now sits beside the round window instead of under it, and its bars show empty and full in black and white.
```

**1.3.0** (live since 2026-10-03; its first bullet names Instinct 2, 2S, 2X and Descent G1, which the store does not sell this paid app on: see Device claims above, history kept as submitted)

```text
- Now on the Instinct family: Instinct 2, 2S, 2X, Instinct E and Instinct 3 Solar, and Descent G1. The black-and-white screen shows your XP ring in the small round window at the top right.
- Instinct E and Instinct 3 Solar also get the glance.
- Fixed: after saving a short set, starting the same exercise again began from that count instead of 0.
- Long translations are shortened instead of overlapping on small screens.
```

**1.2.0**

```text
- New glance: add HeroSet to your watch's glance list to see today's push-ups, sit-ups, squats and your streak without opening the app. On watches with Connect IQ 4.0 or later.
```

**1.1.1**

```text
- Now on touchscreen watches: Venu 2, 2 Plus, 2S, 3, 3S and 4, vívoactive 5 and 6, Approach S50 and S70, and D2 Air X10. Swipe up or down to adjust a count, then press START to save.
- A stray tap on the counting or adjust screen can no longer end or save a set, on any watch. Only the START button does.
- Text fits better on smaller screens in several languages.
- If the motion sensor can't start, the workout screen now says so instead of staying at 0.
- HeroFace, our watch face, is now in the Connect IQ Store. On watches with Connect IQ 4.2 or later, it can show today's HeroSet progress.
- Reliability improvements.
```

**1.1.0**

```text
- Set your own daily goal on the watch: anything from 10 to 500 reps, no phone needed.
- Reliability and performance improvements when saving a set.
```

**1.0.0:** `First release.`

## 1.4.0: what `paste.md` now holds (prepared 2026-10-08, not uploaded)

- **Version** `1.4.0`, not the `1.3.2` the changelog called this build while it was unreleased: it adds products (Instinct 3 AMOLED 45/50 mm, Venu Sq 2, Sq 2 Music, X1; 92 products), so the next minor. App Version is free text typed into the form ([ADR-053](../docs/decisions.md#adr-053) (App Version is typed, not read from the package)). It can go up while 1.3.1 is still in review (`../../research_notes/Free and Pro ladder/garmin_rules.md`).
- **What's New** lists the user-facing changes of `../CHANGELOG.md` "1.4.0": more watches with the rectangular design ([ADR-057](../docs/decisions.md#adr-057) (rectangular watches)), the correction under the goal ([ADR-058](../docs/decisions.md#adr-058) (a correction under the goal undoes today's completion)), the review number, `--` calories, no `STREAK 0` on the Instinct dashboard. Copy rules as above: no watch model, no language, the HeroFace qualifier "on watches with Connect IQ 4.2 or later".
- **Description unchanged:** nothing in it names a screen shape or contradicts the new build ("Check and adjust the count before it's saved" covers the correction). Translations unchanged with it.

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml).
- **Subcategory:** Other is not marked required: leave it blank if the form allows.
- **Monetization:** the price tier USD 2.50 is the form's own selection; this is the one place a number appears, never in the description text.
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl` and this listing's live value is already the bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, `../../reports/Garmin policies and design guidelines.md`).
- **Images:** Garmin caps Screen Images at 5, each under 150 KB; upload in the numbered order. The store has no caption field; the captions and devices are in `meta.yaml` `assets.screens`. The owner uploaded hero and cover on 2026-10-04 (looks approved by that); whether the five screens went up with 1.3.1 is ROADMAP 7.2.
- **Description, removed or reworded:** the refund sentence ("HeroSet is a paid app. Refunds follow the Connect IQ Store return window.", ROADMAP 10.16, reversed); the line "In 15 languages, including German, French, Spanish, Italian, Polish and Ukrainian" (now "Multi-language support: it follows your watch's language."; the language list stays in the release contract and `../docs/compatibility.md`); the line "Also on the black-and-white Instinct E (40 and 45 mm) and Instinct 3 Solar" (now "Also on black-and-white screens, with your XP ring in the small round window").
- **What's New 1.3.1, previous wording (named models):** `- Instinct E and Instinct 3 Solar: text near the corners of the screen is no longer cut off by the bezel, so START: MENU and the finished-day message show whole.` / `- Instinct E and Instinct 3 Solar: the glance now sits beside the round window instead of under it, and its bars show empty and full in black and white.` Now written by screen type ("Black-and-white screens: ...").
- **`meta.yaml` `held_back_text`:** none existed for HeroSet; the key is retired in every listing (listing text never names watch models).
