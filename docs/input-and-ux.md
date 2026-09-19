# Button-first interaction

Fully usable without touch — physical buttons + native Connect IQ menus.

**Buttons are press-only (ADR-029).** No in-app action use long-press: on FR965, holding Up/Down/Light/Back opens watch-level shortcuts, so hold can't be app gesture. On-screen hints name buttons by bezel labels — `START`, `UP/DOWN`, `BACK` — never `SELECT`/`SEL`/`DN` (`START` = what Connect IQ call Select).

## Navigation contract

**Dashboard**: START/Up/Down → mission menu (Menu too, watch's own hold-Up shortcut). Back → leave HeroSet.
Top to bottom (ADR-031):
- **XP ring**: gold arc on bezel, open at bottom, fills with XP earned inside current rank, restarts empty each rank-up.
- **`RANK N`** (gold), then **`N XP TO RANK M`** (muted; `N XP TO GO` if numbers outgrow row): say what XP for.
- **Three mission bars**: label + today count on one line, thick bar under it (blue while in progress, full + green at goal). Finished row label read `PUSH-UPS DONE` — done never rely on color alone. All rows share one left/right edge, measured inside ring, so labels, counts, bars line up as columns.
- **Streak line**: `N DAY STREAK` (`STREAK N` if no fit), muted while today still open, gold once today mission complete; `NO STREAK
  YET` at 0. Missed day show 0 immediately, not old run.
- **Footer**: menu hint (`START: MENU`), or `MISSION COMPLETE` (green) once all three goals met; storage write failure (`! COULD NOT
  SAVE`, red) override both. Sits in ring bottom gap at one fixed y — nothing shift when it change.

XP: 2 per rep, counted up to each daily goal (max 600 a day, ADR-002). Rank r→r+1 cost 300 × min(r, 14) XP: rank 2 after half full day, rank 10 after ~three weeks, then one rank per full week.

**Native menus**: Up/Down move, START activate, Back return. Main menu (titled HeroSet) show today progress under each Start item (`42/100` or `DONE`), open focused on Start item of first exercise not yet at goal (top of list when all done) — next set usually one START. Log Push-ups/Sit-ups/Squats open manual picker.

**Exercise session**: counting start instant screen open — no pause/resume, no adjustment menu. Rep count dominant, in effort blue (gold reserved for what is saved, ADR-041); below it `TODAY N/100` (stored + counted so far), then elapsed set time (mm:ss) with live HR and estimated-calories-for-this-set readout (ADR-021), refreshed every second. Each rep tap once; rep that carry today total over goal give double tap instead (once per set). START = Finish (`START: FINISH`), open manual delta picker (below) pre-loaded with detected count so miscount fixable before save — nothing banked until picker saved. Back with zero reps leave directly. Back with reps open `N reps` menu (Garmin activity-end pattern, ADR-028): **Resume** (or Back) return to counting; **Save** bank detected count as-is, no correction step, return to dashboard; **Discard** drop set, return to dashboard, show `DISCARDED`. No FIT activity created in store build (see Sync below).

**Manual entry**: Main menu → Log <exercise>, or automatic after finishing workout set (ADR-024). Continuous delta picker open (at 0 from menu, at detected count after workout, with `DETECTED N` subtitle, `DETECTED N (-1)` when the learned getting-up rep was dropped so it matches the workout screen's N): each Up/Down press step delta by exactly 1 (`UP/DOWN:
ADJUST`); deliberately no hold-to-accelerate (ADR-029), so big manual entry take one press per rep. Delta never drop below minus today stored count. Delta show white at 0, blue when positive, red when negative (green only means a goal met); `TODAY N/100` show what today total become if saved. START bank delta (`START: SAVE`), return to dashboard. Back with zero delta leave directly; with pending delta open `+N reps` menu: **Save** bank + return to dashboard, **Discard** return to dashboard without saving (show `DISCARDED`; nothing logged to validation log), **Keep Editing** (or Back) return to picker unchanged.

**Save feedback** (every save path): `DAILY MISSION COMPLETE!` + triple vibration moment save complete all 3 daily goals first time that day; else `RANK N!` + four vibrations when the save earns a new rank; else `PUSH-UPS DONE!` (per exercise) + double vibration when save carry that exercise from below to at/over goal; else plain `+N SAVED` toast (`N REMOVED` for a negative correction).

**Sync boundary**: everything HeroSet track — reps, XP, streaks, learned thresholds, daily totals, live HR/calorie readouts — local to watch. Store build never create FIT activity or touch Garmin Connect/Strava: no sync toggle, no `Fit` permission (ADR-021, ADR-033).

**Garmin Connect/Strava sync (dev build only, opt-in, off by default)**: Main menu → Connect Sync = on/off toggle showing current state (`On`/`Off`) without selecting it; START flip it immediately, no confirmation (ADR-027). Label is `Connect Sync`, not `Garmin Connect Sync`: longer one cut off by toggle switch on FR965 (ADR-029). Turning off save any activity already recorded that day. When on, every workout set (not manual entries — no elapsed-time/HR signal to attach) start/resume one combined FIT activity for that calendar day; saved once, next time set logged on new day (ADR-025). **Unverified on the watch:** first test produced two activities in one day (ADR-030). Discarding set drop its reps, not counting time already recorded into that day activity. No GPS/distance data. Strava not contacted directly — this only create Garmin Connect activity; whether it reach Strava depend on user existing Garmin Connect ↔ Strava account link.

## Learning from saved counts (ADR-040)

No calibration step. Every workout set saved through the picker (START at Finish, then START to save) teaches that exercise's detector: the watch replays the set's movement at many thresholds and moves toward those that would have given the saved count. The first sets count with the default threshold; after a few corrected sets counting fits the user's wrist, depth and pace, and keeps following form changes.
- If the user's sets keep ending with one extra rep (getting up after the last rep), the watch learns to drop the last counted rep for that exercise. The live count still shows it; the picker opens without it.
- Not learned from: manual entries from the main menu, quick-save (Back → Save), discarded sets, and saves with more reps than the movement could explain.
- Save what you really did: the saved count is what the detector learns from.

No critical action may require touch target; touch may come later as accelerator only.
