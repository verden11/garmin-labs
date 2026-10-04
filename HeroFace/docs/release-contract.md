# HeroFace — release contract

What the listing, the store page and the site may claim. Moved out of `status.md` on 2026-10-04; the claims below were last reviewed 2026-09-26 and still say "117 supported watches": the Instinct family (124 products, ADR-002) is not claimed until an upload is approved and the store lists it.

## Positioning

The listing sells a practical everyday face: time first, three daily goals as bars, a goal streak, battery and heart rate, and settings that let each bar show what the wearer cares about. HeroSet gets one line, "shows your HeroSet reps, rank and streak if you have it", because most buyers will not own it. Paid at the $2.50 tier ([ADR-004](decisions.md#adr-004), price: the $2.50 tier for every paid app), set in the upload form; the listing text states no price. Garmin's 48-hour return window is the only trial; the listing says one line about refunds (below) and does not restate the hours.

## Paid vs free reach and the refund line (2026-10-04)

**Devices.** Garmin sells paid apps only on the products of its App Sales list. HeroFace Pro 1.0.1 is listed on 69 of its 117 products; 37 are off the list and 11 more are on the list but sold to no paid app (measured by part number, [`compatibility.md`](compatibility.md) "Paid vs free reach"). Of the 7 Instinct products in 1.1.0, **only Instinct E 40/45 mm and Instinct 3 Solar are on the list; Instinct 2, 2S, 2X and Descent G1 are not.** So: (a) the **Pro listing** may name only Instinct E (40 and 45 mm) and Instinct 3 Solar, and only after an Instinct upload is approved and the store lists them; (b) the **Free listing** may say it also installs on watches Pro cannot be bought for, including the Instinct 2, 2S, 2X and Descent G1, on the same condition and once its own device list shows them. The free-only reach is 37 products plus the 11 unsold, and 4 more with the Instinct products (52 of 124).

**Refund line.** The Pro description ends with "HeroFace Pro is a paid app. Refunds follow the Connect IQ Store return window." (guideline 4d). It does not restate the hours: Garmin's full return-policy text is not published on a page we could read, and its one stated figure is the 48-hour window before funds are captured. The Free description has no refund line (nothing to refund). The Pro listing still never uses the word "free".

## Claims allowed and forbidden

Allowed: the metric list, "Compatible Devices" as the store shows it (no watch count: the package has 117 products in 1.0.1 and the store lists only 69, see "Paid vs free reach"), "nothing leaves your watch", the HeroSet link on Connect IQ 4.2+ watches, the settings.

Forbidden until measured on a watch: any battery-life number, any always-on claim beyond what the FR965 night of 2026-09-21/22 backs (§1: the face works always-on without burn-in retention on that watch), "works with every Garmin", accuracy claims of any kind, and any review, rating or user count — none exist. (The one-line request "If this face works for you, a rating in the store helps other people find it." is in the Free listing only, by the owner's decision of 2026-10-04; it asks and claims nothing.)
