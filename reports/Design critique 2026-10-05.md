# Design critique 2026-10-05: running log

Working notes for the evening executive summary. One project at a time, from the listing screenshots and simulator runs
(UI and UX). The owner answered every round with "do your picks". Everything below is **simulator only**: nothing has been
on a wrist, and nothing reaches users until the owner uploads the next version of each app. Items are ROADMAP 13.x.

## Done, per project

| Project | What changed (user-visible) | ROADMAP | Commits |
|---|---|---|---|
| Days To Go | Ring is full only on the day (was full at 365 days) and keeps draining through the last 24 h instead of jumping to near full | 13.1 | `8e2314d` |
| Days To Go Pro | Last 24 h read `8h 06m` (small h/m), not `8:06 HOURS`, which looked like a second clock | 13.2 | `cc01749` |
| Days To Go | Drawn arrow before the event's date while it is ahead (it read as today's date); Pro footer gets a battery or footprints mark | 13.3, 13.4 | `24877e6` |
| Days To Go | Ring direction (drains) kept | 13.6 | `cc01749` |
| HeroFace | Drawn icons replace `STEP`/`CAL`/`INT`/`FLR`; streak + temperature one centred group (no jumping); Free's empty band closed; MOVE shows nothing until it alerts (red GO) | 13.8–13.12 | `b2fa837`, `2ce547b` |
| Two Suns Pro | Weather and watch battery rows Off by default (listing showed them off, buyers got them on); compact weather row = current conditions only | 13.13, 13.14 | `ac96202` |
| Two Suns | Energy curve is a line (its fill was the night ring's colour); solid bolt (half-grey gauge read as broken); `7h 22m of daylight` not `7:22` | 13.15–13.17 | `ac96202` |
| DayArc | Body Battery hero icon is a bolt (battery shell read as a second battery); Pro grid icons all muted grey (rainbow competed with the hero) | 13.19, 13.20 | `8e316d4` |
| Studio | The bolt means Body Battery everywhere; intensity minutes are a pulse line (HeroFace, DayArc) | 13.19 | `2ce547b`, `8e316d4` |
| HeroSet | Review screen: `+24` (what START saves) is the big number; `CAL --` until 1, not `CAL 0`; Instinct: no `STREAK 0` row on day one | 13.21–13.23 | `cfb9c33` |

Every changed listing image set was recaptured (both tiers where both changed) and its store hero re-rendered.

## Tooling fixed on the way

- HeroFace `tools/listing_shots.sh` now clears the simulator's stored app settings per scene (the Pro accent/seconds shot was silently coming out as the default).
- Two Suns: the new `h`/`m` strings needed a copy in every language folder to keep the zero-warning compile (English letters, flagged under 13.7).

## Checks run

- Unit suites in the container simulator after every change, on 5 to 8 devices per project including an Instinct and a small round watch; all PASSED at the end.
- Full compile sweeps, both tiers: Days To Go 127/127, HeroFace 124/124, Two Suns 72/72, DayArc 72/72. HeroSet: store build tests 103 PASSED.

## Open for the owner

- **13.5** Days To Go time-zone list: city hints (parked by the owner for later).
- **13.7** The `h`/`m` letters (Days To Go Pro, Two Suns) are English on every watch; "m" can read as metres. Keep, use "min", or translate.
- **13.18** Two Suns site pages still say "8:41 of daylight" and draw a filled curve; a site push deploys, so it waits for the OK.
- **Uploads:** every change ships only with each app's next version (Days To Go both tiers, HeroFace both, Two Suns both, DayArc first submission, HeroSet 1.3.2). New listing images go up with them (10.5).
- **Looks:** the owner approves looks before upload: review `*/listing*/screens*/` for each project.
- **DayArc wear check (1.1)** was running today on the FR965 with the builds from before these changes (sideloaded in the morning).
