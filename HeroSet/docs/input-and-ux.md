# Button-first interaction

Fully usable without touch — physical buttons + native Connect IQ menus. Touch-first watches (Venu, vívoactive, Approach) swipe where others press UP/DOWN; see the end of this page.

**Buttons are press-only ([ADR-029](decisions.md#adr-029)).** No in-app action use long-press: on FR965, holding Up/Down/Light/Back opens watch-level shortcuts, so hold can't be app gesture. On-screen hints name buttons by bezel labels — `START`, `UP/DOWN`, `BACK` — never `SELECT`/`SEL`/`DN` (`START` = what Connect IQ call Select).

## Navigation contract

**Dashboard**: START/Up/Down → mission menu (Menu too, watch's own hold-Up shortcut). Back → leave HeroSet.
Top to bottom ([ADR-031](decisions.md#adr-031)):
- **XP ring**: gold arc on bezel, open at bottom, fills with XP earned inside current rank, restarts empty each rank-up.
- **`RANK N`** (gold), then **`N XP TO RANK M`** (muted; `N XP TO GO` if numbers outgrow row): say what XP for.
- **Three mission bars**: label + today count on one line, thick bar under it (blue while in progress, full + green at goal). Finished row label read `PUSH-UPS DONE` — done never rely on color alone. Where a translated `DONE` label can't share its row with the count even at the smallest font (7 languages on 360 px), rows drop the word and the full bar + count at goal carry it ([ADR-049](decisions.md#adr-049)). All rows share one left/right edge, measured inside ring, so labels, counts, bars line up as columns.
- **Streak line**: `N DAY STREAK` (`STREAK N` if no fit), muted while today still open, gold once today mission complete; `NO STREAK
  YET` at 0. Missed day show 0 immediately, not old run.
- **Footer**: menu hint (`START: MENU`), or `MISSION COMPLETE` (green) once all three goals met; storage write failure (`! COULD NOT
  SAVE`, red) override both. Sits in ring bottom gap at one fixed y — nothing shift when it change.

XP: 2 per rep, counted up to 100 reps per exercise per day whatever your goal is (max 600 a day, [ADR-002](decisions.md#adr-002)/[045](decisions.md#adr-045)) — rank reflect reps done, not goals hit. Goal 30 mean mission complete daily and streak climbing, rank still move at a third speed. Rank r→r+1 cost 300 × min(r, 14) XP: rank 2 after half full day, rank 10 after ~three weeks, then one rank per full week.

**Native menus**: Up/Down move, START activate, Back return. Main menu (titled HeroSet) show today progress under each Start item (`42/100` or `DONE`, `100` = your own goal), open focused on Start item of first exercise not yet at goal (top of list when all done) — next set usually one START. Log Push-ups/Sit-ups/Squats open manual picker. **Daily Goal** (sublabel = current goal) open goal picker.

**Exercise session**: counting start instant screen open — no pause/resume, no adjustment menu. Rep count dominant, in effort blue (gold reserved for what is saved, [ADR-041](decisions.md#adr-041)); below it `TODAY N/<goal>` (stored + counted so far), then elapsed set time (mm:ss) with live HR and estimated-calories-for-this-set readout ([ADR-021](decisions.md#adr-021)), refreshed every second; if the accelerometer refuses to start, that row reads `NO SENSOR` in red instead of sitting silently at 0. Each rep tap once; rep that carry today total over goal give double tap instead (once per set). START = Finish (`START: FINISH`), open manual delta picker (below) pre-loaded with detected count so miscount fixable before save — nothing banked until picker saved. Back with nothing to save (zero reps, or a lone rep learned to be getting up) leave directly. Back with reps open `N reps` menu (Garmin activity-end pattern, [ADR-028](decisions.md#adr-028)): **Resume** (or Back) return to counting; **Save** bank the count as-is (the detected count, minus a getting-up rep the learner drops, [ADR-040](decisions.md#adr-040)), no correction step, return to dashboard; **Discard** drop set, return to dashboard, show `DISCARDED`. No FIT activity created in store build (see Sync below).

**Manual entry**: Main menu → Log <exercise>, or automatic after finishing workout set ([ADR-024](decisions.md#adr-024)). Continuous delta picker open (at 0 from menu, at detected count after workout, with `DETECTED N` subtitle, `DETECTED N (-1)` when the learned getting-up rep was dropped so it matches the workout screen's N): each Up/Down press step delta by exactly 1 (`UP/DOWN:
ADJUST`); deliberately no hold-to-accelerate (ADR-029), so big manual entry take one press per rep. Delta never drop below minus today stored count. Delta show white at 0, blue when positive, red when negative (green only means a goal met); `TODAY N/<goal>` show what today total become if saved. START bank delta (`START: SAVE`), return to dashboard. Back with zero delta leave directly; with pending delta open `+N reps` menu: **Save** bank + return to dashboard, **Discard** return to dashboard without saving (show `DISCARDED`; nothing logged to validation log), **Keep Editing** (or Back) return to picker unchanged.

**Daily goal**: Main menu → Daily Goal ([ADR-045](decisions.md#adr-045)). Picker show `DAILY GOAL` title and current goal in effort blue: each Up/Down press step by 10 between 10 and 500, no hold-to-accelerate ([ADR-029](decisions.md#adr-029)). START save and return to dashboard (`GOAL N` toast), publish new goal to HeroFace at once; START with the goal unchanged just returns, no toast. Back with unchanged value leave directly; with change open same Save/Discard/Keep Editing menu as manual picker. Lower goal below today counts complete today mission immediately (mission toast + streak). XP unaffected: goal never change what a rep is worth.

**Save feedback** (every save path): `DAILY MISSION COMPLETE!` + triple vibration moment save complete all 3 daily goals first time that day; else `RANK N!` + four vibrations when the save earns a new rank; else `PUSH-UPS DONE!` (per exercise) + double vibration when save carry that exercise from below to at/over goal; else plain `+N SAVED` toast (`N REMOVED` for a negative correction).

**Sync boundary**: store build keeps everything on the watch: no sync toggle, no `Fit` permission, no activity ([ADR-021](decisions.md#adr-021)/[033](decisions.md#adr-033)).

**Connect Sync (dev build only, off by default, [ADR-043](decisions.md#adr-043))**: main menu toggle, sublabel `Saves to Connect` / `Watch only`, START flips it, no confirmation ([ADR-027](decisions.md#adr-027)). Label is `Connect Sync` so the switch doesn't cut it off ([ADR-029](decisions.md#adr-029)); new sublabels not yet fit-checked on the watch. When on, each visit with saved workout reps becomes one Connect strength activity at exit, one lap per set (exercise + reps), totals in the summary. No in-app message; appears after phone sync. Full behavior: [`connect-sync-plan.md`](connect-sync-plan.md). **Unverified on the watch.**

## Learning from saved counts ([ADR-040](decisions.md#adr-040))

No calibration step. Every workout set saved through the picker (START at Finish, then START to save) teaches that exercise's detector: the watch replays the set's movement at many thresholds and moves toward those that would have given the saved count. The first sets count with the default threshold; after a few corrected sets counting fits the user's wrist, depth and pace, and keeps following form changes.
- If the user's sets keep ending with one extra rep (getting up after the last rep), the watch learns to drop the last counted rep for that exercise. The live count still shows it; the picker opens without it.
- Not learned from: manual entries from the main menu, quick-save (Back → Save), discarded sets, and saves with more reps than the movement could explain.
- Save what you really did: the saved count is what the detector learns from.

## Touch-first watches ([ADR-048](decisions.md#adr-048))

Venu 2/3/4, vívoactive 5/6, Approach S50/S70, D2 Air X10 have START and BACK but no UP/DOWN.
- **Swipe up/down** does what UP/DOWN do: swipe up raises the picker value (+1 rep, +10 goal), swipe down lowers it; in the validation log swipe up is next page. Hints read `SWIPE: ADJUST` / `SWIPE: PAGE` (`HeroSetInput.touchFirst()`: no UP key).
- **Tap** opens the menu from the dashboard and selects menu items, as native menus do. On the workout and both pickers a tap does nothing: Finish and Save are the START button only.
- **Swipe right from the edge** is Back: mid-set it opens the `N reps` menu (Resume returns to counting).

**Every watch:** a tap on the workout or picker screen never finishes or saves (FR965 too). Native menus (Back's Resume/Save/Discard, the picker's exit menu) still select by tap, as every Garmin menu does. Adjusting may need touch only where there are no UP/DOWN buttons.
