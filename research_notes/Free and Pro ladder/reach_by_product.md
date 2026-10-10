# Reach only a free listing gets

**Question:** per project, how many manifest products *not* on Garmin's paid-device allow-list? Paid listing never offered on those; free listing is.

**Method (measured, 2026-09-28):** manifest product ids → SDK `displayName` (`~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/compiler.json`)
→ substring match against "Supported Products" section of App Sales page, run in browser. Combined SDK name
("fēnix® 5 / quatix® 5") counted on list if *any* slash-separated part matched, so counts below = **floor** on free-only reach.

| Project | Manifest products | On allow-list | Free-only | Share | minApi |
|---|---|---|---|---|---|
| HeroFace | 117 | 84 | **33** | 28% | 3.0.0 |
| DaysToGo | 120 | 87 | **33** | 28% | 3.0.0 |
| HeroSet (store manifest) | 80 | 79 | 1 (FR945 LTE) | 1% | 3.4.0 |
| TwoSuns | 69 | 69 | 0 | 0% | 4.2.0 |
| DayArc | 69 | 69 | 0 | 0% | 4.2.0 |

## The 33 (HeroFace and DaysToGo share them; the 3 rectangular DaysToGo products are all on the list)

- Forerunner: 55, 245, 245 Music, 645, 645 Music, 745, 935, 945, 945 LTE
- vívoactive: 3, 3 Music, 3 Music LTE, 3 Mercedes-Benz Collection, 4, 4S
- fēnix 5 family: 5 / quatix 5, 5 Plus, 5S, 5S Plus, 5X / tactix Charlie, 5X Plus; fēnix Chronos
- D2 Charlie, D2 Delta, D2 Delta PX, D2 Delta S; Descent Mk1; Approach S62
- Venu Mercedes-Benz Collection
- Captain Marvel, First Avenger, Darth Vader, Rey (special editions)

FR245, vívoactive 4 = mass-market watches; large installed bases. **Inferred**, not measured: how many owners browse store for faces.

## What this does and does not buy

- **Buys:** installs, ratings, reviews, rank velocity on 28% more devices for HeroFace, DaysToGo. Reviews, velocity = what store rewards (`reports/Selling HeroSet and HeroFace.md`).
- **Does not buy:** Pro sales from those devices. Pro listing not offered there, so FR245 owner who loves free face cannot upgrade. Free description must say so plainly (guideline 4a); face must never show upgrade prompt.
- **TwoSuns, DayArc, HeroSet:** near-zero extra reach. Free twin justified by trial/social-proof/family-shelf value only, not reach.

## Correction 2026-10-04

Re-measured by store part number against live manifests (`garmin_rules.md`, "Re-read 2026-10-04", section 3). **Free-only reach for HeroFace and Days To Go = 37 products, not 33** (substring floor wrongly counted D2 Air, Enduro, fēnix 6S, Venu as on list), **plus 11 products on App Sales list but missing from every paid listing**
(MARQ Gen 1 x8, Descent Mk2/Mk2i, Mk2 S, D2 Air X10): 48 products total. Two free rival listings (GLANCE, EASY Round) offered on all of them, so Free twin reaches whole manifest (inference from those two).
"Known gap" below explained for 37; measured but still unexplained for the 11.

## Known gap

Store lists fewer products than manifest minus allow-list predicts (HeroFace 69 listed vs 84 on-list; earlier notes:
Descent Mk2/Mk2S, MARQ Gen 1, D2 Air X10 on list yet absent). Unexplained, only Garmin can say. Free listing may therefore
reach *more* than 33 extra products. Measure after approval: compare `compatibleDeviceTypeIds` length of free listing against
Pro listing through store API (execution plan WP9).