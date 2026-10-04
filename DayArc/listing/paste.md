# DayArc — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block marked OWNER until it is decided** (see [`NOTES.md`](NOTES.md)). **Do not paste a block while a `<` placeholder remains in it** (store URLs are owner-supplied). Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md).

## Title (max 50)

```text
DayArc
```

## Description (max 4000, one box per language)

**OWNER, before pasting:** the store URLs are placeholders (line 1 needs DayArc Pro live; keep only the free faces that are live under "More from Verden"), and "chosen in the Garmin Connect app" is unverified until a store install. Details: [`NOTES.md`](NOTES.md).

```text
Get DayArc Pro: <DAYARC PRO STORE URL: owner fills in once the Pro listing is live>

DayArc changes what it shows through the day, on a fixed schedule. One setting: an accent colour,
chosen in the Garmin Connect app — or leave it on Auto, where each time of day has its own colour.

Morning: feels-like temperature, the day's high and low, and chance of rain — what to dress for.
Midday: a stress reading, shown as a number and a plain gauge, never a mood or a verdict.
Evening: your Body Battery reading, the same way — a number, never good or bad.
Night: time and date — which every window shows in its header.

DayArc shows one reading at a time, on purpose. Looking for more fields per window? DayArc Pro is a
separate, paid listing with a denser view of the same four windows.

If this face works for you, a rating in the store helps other people find it.

DayArc reads data your watch already has. Nothing is sent anywhere, no location, no network.

More from Verden
Days To Go: <DAYS TO GO STORE URL, once live>
Two Suns: <TWO SUNS STORE URL, once live>
HeroFace: <HEROFACE STORE URL, once live>

Support and answers: https://verden.watch/day-arc/support/
```

## Version

```text
1.0.0
```

## What's new

Blank — initial release.

## Category

**Utility** (alternative: Health & Fitness — same choice TwoSuns made, ADR-012 doesn't touch this).

## Does your app collect user data?

**No.** Nothing leaves the watch: no network code, no `Communications` permission, no location
(DayArc reads no location at all — simpler than TwoSuns here).

## Monetization

```text
Free
```

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Use it as a link to the website: many Connect IQ apps do (owner, 2026-10-02), the field is optional free text, and
the page has the support and privacy pages and the other apps. Garmin does not document this use, so keep the text true
(it states that no extra hardware is needed). Paste:

```text
No additional hardware needed. Help, privacy and more apps: https://verden.watch/day-arc/
```

## Email Address (shown publicly)

```text
hello@verden.watch
```
