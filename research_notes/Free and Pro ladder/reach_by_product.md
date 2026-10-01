# Reach only a free listing gets

**Question:** per project, how many manifest products are *not* on Garmin's paid-device allow-list? A paid listing is never offered
on those; a free listing is.

**Method (measured, 2026-09-28):** manifest product ids → SDK `displayName` (`~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/compiler.json`)
→ substring match against the "Supported Products" section of the App Sales page, run in the browser. A combined SDK name
("fēnix® 5 / quatix® 5") counted as on the list if *any* slash-separated part matched, so the counts below are a **floor** on free-only reach.

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

FR245 and vívoactive 4 were mass-market watches; these are large installed bases. **Inferred**, not measured: how many of those owners
browse the store for faces.

## What this does and does not buy

- **Buys:** installs, ratings, reviews and rank velocity on 28% more devices for HeroFace and DaysToGo. Reviews and velocity are what the
  store rewards (`reports/Selling HeroSet and HeroFace.md`).
- **Does not buy:** Pro sales from those devices. The Pro listing is not offered there, so an owner of a FR245 who loves the free face
  cannot upgrade. The free description must say so plainly (guideline 4a) and the face must never show an upgrade prompt.
- **TwoSuns, DayArc, HeroSet:** near-zero extra reach. Their free twin is justified by trial/social-proof/family-shelf value only, not reach.

## Known gap

The store lists fewer products than manifest minus allow-list would predict (HeroFace 69 listed vs 84 on-list; earlier notes:
Descent Mk2/Mk2S, MARQ Gen 1, D2 Air X10 are on the list yet absent). Unexplained, only Garmin can say. The free listing may therefore
reach *more* than 33 extra products. Measure after approval: compare `compatibleDeviceTypeIds` length of the free listing against the
Pro listing through the store API (execution plan WP9).
