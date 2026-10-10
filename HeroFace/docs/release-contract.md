# HeroFace — release contract

Listing, store page, site claims allowed. Moved out of `status.md` 2026-10-04; claims below last reviewed 2026-09-26, still say "117 supported watches": Instinct family (124 products, ADR-002) not claimed until upload approved and store lists it.

## Positioning

Listing sells practical everyday face: time first, three daily goals as bars, goal streak, battery, heart rate, settings letting each bar show what wearer cares about. HeroSet gets one line, "shows your HeroSet reps, rank and streak if you have it", most buyers will not own it. Paid at $2.50 tier ([ADR-004](decisions.md#adr-004), price: the $2.50 tier for every paid app), set in upload form; listing text states no price. No refund or return wording in listing text (owner decision, 2026-10-04).

## Paid vs free reach (2026-10-04)

**Devices.** Garmin sells paid apps only on products of its App Sales list. HeroFace Pro 1.0.1 listed on 69 of 117 products; 37 off list, 11 more on list but sold to no paid app (measured by part number, [`compatibility.md`](compatibility.md) "Paid vs free reach"). Of 7 Instinct products in 1.1.0, **only Instinct E 40/45 mm and Instinct 3 Solar on list; Instinct 2, 2S, 2X and Descent G1 not.** So **listing text never names watch models, in either listing; store's device tab is the claim** (owner, 2026-10-04). Free-only reach: 37 products plus 11 unsold, and 4 more with Instinct products (52 of 124).

**Listing text.** No refund or return wording in listing text (owner decision, 2026-10-04). No language name, no language count either: only allowed line "Multi-language support: it follows your watch's language." (fact stays in docs: 15 languages). Pro listing still never uses word "free".

## Claims allowed and forbidden

Allowed: metric list, "Compatible Devices" as store shows it (no watch count: package has 117 products in 1.0.1, store lists only 69, see "Paid vs free reach"), "nothing leaves your watch", HeroSet link on Connect IQ 4.2+ watches, settings.

From Free 1.1.0 / Pro 1.2.0 (129 products, prepared 2026-10-08): "round or rectangular" by screen type, ring as frame along rectangular screen's edges and as gauge in black-and-white screen's round window (ADR-005 (rectangular watches, the ring as a frame), ADR-002 (Instinct family)); never watch model or count. Ring sentence must say move bar stays out of ring (averages other goals, ADR-005 (rectangular watches, the ring as a frame) amendment of 2026-10-06), never "fills green when all three are met". Pro: time is "sized to your screen", not "the largest size your watch can draw" (with Seconds on it steps down a size on some rectangles).

Forbidden until measured on watch: any battery-life number, any always-on claim beyond what FR965 night of 2026-09-21/22 backs (§1: face works always-on without burn-in retention on that watch), "works with every Garmin", accuracy claims of any kind, any review, rating or user count — none exist. (One-line request "If this face works for you, a rating in the store helps other people find it." in Free listing only, by owner's decision of 2026-10-04; asks and claims nothing.)

## Cross-promotion (rule copied from Days To Go and Two Suns, 2026-10-05, ROADMAP 13.32; the agent's pick on the owner's standing instruction)

- "More from Verden" links only live **free** siblings, checked with `curl` (HTTP 200) before each paste; never paid listing, never price.
- Free listing says plainly nothing locked (no trial, no code to enter, nothing to buy on watch); never "upgrade" or "unlock" wording.