# HeroFace listing — notes

What sits behind [`README.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Paths are relative to `HeroFace/listing/`. Release history: [`../CHANGELOG.md`](../CHANGELOG.md). Claims and gates: [`../docs/status.md`](../docs/status.md).

**Live since 2026-09-22:** https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116. Every field is checked against what the build does ([`../docs/status.md`](../docs/status.md), "Claims allowed and forbidden"). Review takes about 72 hours; a rejection comes back with specific reasons.

> **Pointer (2026-10-01):** this is the paid app's listing, unchanged. A Free twin and the Pro 1.1.0 rename are proposed and unreleased ([`../docs/decisions.md`](../docs/decisions.md) ADR-001, the Free + Pro ladder); the Free draft is [`../listing-free/paste.md`](../listing-free/paste.md). The Pro package is now `../dist/HeroFacePro.iq` (the `../dist/HeroFace.iq` named below is not in the tree; earlier packages are in `../dist/old/`).

**No Keywords field.** The upload form has no keywords/tags field; the README's Keywords section is removed (it never matched the real form). Same fix applied across all four apps' listing docs.

## Other files here

| File | What it is |
|---|---|
| [`descriptions.md`](descriptions.md) | The description opening in all 15 languages |
| [`screenshots.md`](screenshots.md) | The captured set, where each came from, how to re-render the composed images |
| `screens/`, `src/`, the PNGs | The images and their generators (adapted from HeroSet's) |

## Upload file

Build the package: `monkeyc -e -r -f monkey.jungle -o dist/HeroFace.iq -y ~/.garmin-connectiq/keys/developer_key` (1.0.1 was exported 2026-09-24; 1.0.0 shipped from `bin/HeroFace.iq`).

## The form (captured 2026-09-21)

Two steps: attach the `.iq`, then enter details. The form has no price, support URL or website field, and none is to be invented. The support URL reaches buyers only through the last line of the description, so keep that line.

- **Version:** the HeroFace form showed the version read from the package; HeroSet's form took it as free text, so type it only if a field asks.
- **Category options (watch faces):** Analog, Animal, Around the world, Cartoon, Digital, Family, Fantasy, Fun, Geek, Marine, Nature, Retro, Simple, Stylish, Utility. There is no "Watch Faces" option; Digital is the pick, "Simple" the other defensible one.
- **Compatible Devices** is read from the package, not chosen. The form expands the manifest's 117 products into Garmin's marketing names (Mercedes-Benz editions, ForeAthlete variants, per-size fēnix 9 entries), so the list looks longer than 117. That is expected, not a manifest error. The live list shows fewer products than the manifest ([`../docs/status.md`](../docs/status.md), item 4).

## Description rules

- **One box per language, 4000 characters, no short/long split.** The store truncates it itself in list views, so the first sentence carries the weight a short description would.
- **Plain text:** the store shows `**` and `>` literally and keeps every line break, so a hard-wrapped draft broke lines mid-sentence on the live page (checked 2026-09-25).
- **Other languages:** [`descriptions.md`](descriptions.md) (their rows are the old opening; update them before pasting per-language descriptions). The open choice: paste the English description for every language, or translate it.
- **Rules learned:** no watch count and no Forerunner 55 (Compatible Devices shows fewer products than the manifest); no "the line turns grey" (after a missed day the line disappears; it is grey only while today's goal is open).

## Why each answer

| Field | Reason |
|---|---|
| Screen Images | Re-rendered 2026-10-04 (owner brief): five, the best five for Pro, **one from an Instinct E 40 mm** (Pro is not sold on the Instinct 2 family, so the Instinct 2 is not used here), all from the current Pro build in the simulator. The set shows what Pro has: the temperature (1, 3, 4), the metric per bar and seconds (2), HeroSet mode (4). The always-on shot is still deferred ([`../docs/status.md`](../docs/status.md), item 3); see [`screenshots.md`](screenshots.md) for how and the sizes (all under 20 KB, hero 254 KB, cover 79 KB). The 2026-09-21 set is in `old/`. **OWNER approves the looks.** Screen 2 (and the hero centre) uses only metrics that have a goal (move bar, steps, intensity minutes), so every column has a filling bar; an earlier version with distance was retaken. The paid listing's live cover changes with this set (the plain cover moves to Free, Pro gets the PRO pill version); see ROADMAP 10.5. |
| Cover, hero, icons | Re-rendered 2026-10-04. **Design proposal, OWNER decides:** Free and Pro share the mark; Pro adds a small white "PRO" pill in the ring's opening (cover, both icons) and beside the name (hero). Pro text never says "free"; no price in any image. The on-watch launcher icon is shared by both tiers and unchanged. |
| Collects user data | Nothing leaves the watch. |
| App Migration | No: support is the explicit 117-product list in [`../docs/compatibility.md`](../docs/compatibility.md); letting the store add untested devices would ship a layout nobody has run. |
| Monetization | No. The form's own wording: Yes only if the app requests payment to enable features, or asks for tips or donations. HeroFace does neither; it is paid through the store, which is not what this field asks. |
| Price | Paid, the $2.50 tier of Garmin's price points, chosen in the upload/merchant step of the form with the 1.1.0 upload (live at the $2.00 tier until then; ADR-004, price: the $2.50 tier for every paid app). No price number is in the text (ADR-004, price: the $2.50 tier for every paid app). Garmin may re-review a repriced approved app; the version upload is re-reviewed anyway |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/heroface/` only (the API field is `hardwareProductUrl`, a URL; the old "No additional hardware needed..." sentence is retired, ROADMAP 10.16). Live value today: empty. |
| Refund wording | No refund or return wording appears in listing text (owner decision, 2026-10-04). |
| Companion App | Blank: HeroSet is not a companion app, it is a separate paid watch app the face can read. |
| Answers otherwise | Follow HeroSet's ([`../../HeroSet/listing/paste.md`](../../HeroSet/listing/paste.md)) except where the watch-face form differs. |

## What's new: history

- **1.0.1:** `- Installed HeroSet while HeroFace was on your watch? The face now picks it up within a minute, without switching faces.` / `- Fahrenheit temperatures are now rounded instead of cut off: 21 °C shows as 70 °F, not 69.` / `- The "HeroSet" mode setting is gone. It did the same as Auto, which stays the default; if you had picked it, your face looks the same.` / `- Reliability improvements.`
- **1.0.0:** `First release.`

## Pro 1.1.0: what `paste.md` now holds (UNRELEASED, proposed under ADR-001 (Free + Pro ladder), nothing uploaded; 2026-10-04)

`paste.md` is the 1.1.0 text. Names, the price and the sibling URL are the owner's decisions; the strings are the plan's placeholders.

- **Title** `HeroFace Pro` (OWNER decides; plan WP6 step 5 renames it inside the pending listing-repair submission, so it costs no extra review).
- **Line 1:** `Also available: HeroFace, a lighter version: <URL>`. The paid listing never says "free". The rest is the 1.0.1 text, which already describes only what Pro has (the metric per bar, seconds, the temperature, three accents).
- **Instinct:** listing text names no watch model (owner, 2026-10-04; the store's device tab is the claim, so the former `meta.yaml` `held_back_text` sentence is deleted; ADR-002 (Instinct family)). Instinct 2, 2S, 2X and Descent G1 are not on Garmin's paid-app list, so the paid listing is not sold on them ([`../docs/release-contract.md`](../docs/release-contract.md) "Paid vs free reach"; ROADMAP 10.15).
- **Version** `1.1.0`; the What's New is the rename line, naming the sibling without "free".
- No device sentence, no watch count (release contract). No price number is in the text (ADR-004, price: the $2.50 tier for every paid app).
- "More from Verden" is left out: it lists only live free siblings, none live today.

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml).
- **Title:** "HeroFace Pro" is the owner's decision (plan WP6 step 5: rename inside the pending listing-repair submission, keeping the device tokens the title carries; the live title is just "HeroFace"): `meta.yaml` `owner_approvals`.
- **Description:** line 1 needs the real HeroFace (Free) store URL once that listing is live (the placeholder in the block is `<HEROFACE STORE URL>`). Languages are added one at a time (pick a language, press Add, fill Title + Description); only English is drafted, see "Description rules" above. The description never uses the word "free" (it is paid; store review guideline 4d). The refund sentence ("HeroFace Pro is a paid app. Refunds follow the Connect IQ Store return window.") and the "up to a 466-pixel fēnix" wording (now "the largest 466-pixel round screens") are removed.
- **Version:** the form reads it from the package; type it only if a field asks. paste.md is the 1.1.0 text (the Pro rename); the submitted 1.0.1 What's New is in "What's new: history" above.
- **Collects user data:** No; the privacy-policy URL field is conditional on Yes, so it may not appear. **Subcategory:** whatever the Category choice offers. **Preview Video:** none (YouTube or Vimeo only).
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02; Garmin research 2026-10-04, `../../reports/Garmin policies and design guidelines.md`).
- **Images:** the owner approves the looks of all images before upload (`meta.yaml` `owner_approvals`); rendered 2026-10-04 from the current Pro build in the simulator, how and from what in [`screenshots.md`](screenshots.md). Captions and devices are in `meta.yaml` `assets.screens` (no caption field in the form).
