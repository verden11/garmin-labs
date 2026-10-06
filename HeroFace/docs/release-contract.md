# HeroFace — release contract

What the listing, the store page and the site may claim. Moved out of `status.md` on 2026-10-04; the claims below were last reviewed 2026-09-26 and still say "117 supported watches": the Instinct family (124 products, ADR-002) is not claimed until an upload is approved and the store lists it.

## Positioning

The listing sells a practical everyday face: time first, three daily goals as bars, a goal streak, battery and heart rate, and settings that let each bar show what the wearer cares about. HeroSet gets one line, "shows your HeroSet reps, rank and streak if you have it", because most buyers will not own it. Paid at the $2.50 tier ([ADR-004](decisions.md#adr-004), price: the $2.50 tier for every paid app), set in the upload form; the listing text states no price. No refund or return wording appears in listing text (owner decision, 2026-10-04).

## Paid vs free reach (2026-10-04)

**Devices.** Garmin sells paid apps only on the products of its App Sales list. HeroFace Pro 1.0.1 is listed on 69 of its 117 products; 37 are off the list and 11 more are on the list but sold to no paid app (measured by part number, [`compatibility.md`](compatibility.md) "Paid vs free reach"). Of the 7 Instinct products in 1.1.0, **only Instinct E 40/45 mm and Instinct 3 Solar are on the list; Instinct 2, 2S, 2X and Descent G1 are not.** So **listing text never names watch models, in either listing; the store's device tab is the claim** (owner, 2026-10-04). The free-only reach is 37 products plus the 11 unsold, and 4 more with the Instinct products (52 of 124).

**Listing text.** No refund or return wording appears in listing text (owner decision, 2026-10-04). No language name and no language count either: the one allowed line is "Multi-language support: it follows your watch's language." (the fact stays in docs: 15 languages). The Pro listing still never uses the word "free".

## Claims allowed and forbidden

Allowed: the metric list, "Compatible Devices" as the store shows it (no watch count: the package has 117 products in 1.0.1 and the store lists only 69, see "Paid vs free reach"), "nothing leaves your watch", the HeroSet link on Connect IQ 4.2+ watches, the settings.

Forbidden until measured on a watch: any battery-life number, any always-on claim beyond what the FR965 night of 2026-09-21/22 backs (§1: the face works always-on without burn-in retention on that watch), "works with every Garmin", accuracy claims of any kind, and any review, rating or user count — none exist. (The one-line request "If this face works for you, a rating in the store helps other people find it." is in the Free listing only, by the owner's decision of 2026-10-04; it asks and claims nothing.)

## Cross-promotion (rule copied from Days To Go and Two Suns, 2026-10-05, ROADMAP 13.32; the agent's pick on the owner's standing instruction)

- "More from Verden" links only live **free** siblings, checked with `curl` (HTTP 200) before each paste; never a paid listing, never a price.
- The Free listing says plainly that nothing is locked (no trial, no code to enter, nothing to buy on the watch); never "upgrade" or "unlock" wording.
