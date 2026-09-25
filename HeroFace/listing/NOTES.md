# HeroFace listing — notes

What sits behind [`README.md`](README.md), the paste-ready copy. Nothing here is pasted into the form. Paths are relative to `HeroFace/listing/`. Release history: [`../CHANGELOG.md`](../CHANGELOG.md). Claims and gates: [`../docs/go-to-market.md`](../docs/go-to-market.md).

**Live since 2026-09-22:** https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116. Every field is checked against what the build does ([`../docs/go-to-market.md`](../docs/go-to-market.md), "Claims allowed and forbidden"). Review takes about 72 hours; a rejection comes back with specific reasons.

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
- **Compatible Devices** is read from the package, not chosen. The form expands the manifest's 117 products into Garmin's marketing names (Mercedes-Benz editions, ForeAthlete variants, per-size fēnix 9 entries), so the list looks longer than 117. That is expected, not a manifest error. The live list shows fewer products than the manifest ([`../docs/go-to-market.md`](../docs/go-to-market.md), item 4).

## Description rules

- **One box per language, 4000 characters, no short/long split.** The store truncates it itself in list views, so the first sentence carries the weight a short description would.
- **Plain text:** the store shows `**` and `>` literally and keeps every line break, so a hard-wrapped draft broke lines mid-sentence on the live page (checked 2026-09-25).
- **Other languages:** [`descriptions.md`](descriptions.md) (their rows are the old opening; update them before pasting per-language descriptions). The open choice: paste the English description for every language, or translate it.
- **Rules learned:** no watch count and no Forerunner 55 (Compatible Devices shows fewer products than the manifest); no "the line turns grey" (after a missed day the line disappears; it is grey only while today's goal is open).

## Why each answer

| Field | Reason |
|---|---|
| Keywords | Every one is something the face actually does: a keyword the build does not deliver reads as a false claim in review ([`../docs/go-to-market.md`](../docs/go-to-market.md)). |
| Screen Images | One device is enough (HeroSet shipped five shots from a single device and passed review). The always-on shot is deferred ([`../docs/go-to-market.md`](../docs/go-to-market.md), item 3); see [`screenshots.md`](screenshots.md). All five are 3.5–20 KB; the hero is 241 KB, the cover 76 KB. |
| Collects user data | Nothing leaves the watch. |
| App Migration | No: support is the explicit 117-product list in [`../docs/compatibility.md`](../docs/compatibility.md); letting the store add untested devices would ship a layout nobody has run. |
| Monetization | No. The form's own wording: Yes only if the app requests payment to enable features, or asks for tips or donations. HeroFace does neither; it is paid through the store, which is not what this field asks. |
| Companion App | Blank: HeroSet is not a companion app, it is a separate paid watch app the face can read. |
| Answers otherwise | Follow HeroSet's ([`../../HeroSet/listing/README.md`](../../HeroSet/listing/README.md)) except where the watch-face form differs. |

## What's new: history

**1.0.0:** `First release.`
