# TODO

Single list for both watch apps. Tick here. Evidence detail lives in each app's
`docs/go-to-market.md` ("Next session") — fold results there, not here.
Last consolidated 2026-09-26.

## Listings

- [x] A1. Manifest check (2026-09-26): HeroSet `manifest.xml` and `manifest-store.xml` identical, 80 products; HeroFace has one `manifest.xml`, 117 products. Store-side listing is Garmin's call; nothing to chase.
- [x] A2. Category (2026-09-26): re-set on HeroSet; the developer page HTML (incognito) shows STRENGTH_TRAINING. Not checked: whether the store API still reads 219.
- [x] A3. Dropped 2026-09-26: the mobile app only selects a device by linking a real one, and there is no fēnix 9 / FR170 to link. Store-side bug, not ours anyway.
- [x] HeroFace 1. FR965 store install of 1.0.1 (2026-09-26): live; face and HeroSet both installed, link works. °F rounding checked on the FR965, shows correct. Not checked: stored mode 2 → Auto.
- [ ] A4. Upload all 7 `HeroSet/listing/screens-framed/*.png` as the Screen Images on the HeroSet store listing (edit details need no re-review) — supersedes the old single-file plan below it.

## Device checks (FR965, dev build, all-day wear)

- [ ] B1. START finishes a set; START saves pickers; picker hint `UP/DOWN`; Back after a lone dropped rep leaves the set.
- [ ] B5. Daily goal 30 and 500, one set each; survives restart; picker at 500 on one MIP and one 208 px round product.
- [x] HeroFace 2a. Settings round-trip via Connect (2026-09-26, store build, FR965): changed a goal setting, face updated.
- [ ] HeroFace 2b. Still open: seconds power budget (simulator GUI), 96 KB memory headroom (simulator), MIP contrast. None needs the watch.
- [ ] Gate 2. 3×10 reps per exercise at slow/medium/fast; 60 s still per exercise; one 30+ rep set.
- [ ] Gate 3 (every screen, no clipped text), Gate 7 (HR, calories, battery), store build sync check.
- [ ] Photograph every Validation Log page before it wraps (30 entries).

## Images: chassis + strap refresh (decided 2026-09-26)

Real simulator captures of the whole watch (chassis and a bit of strap), not composites: keeps ADR-039 "no mockups". Save each to `~/screenshots/` under the name shown; Claude crops to square, sizes, moves into place, then refreshes site copies and re-renders hero/cover.

Capture: run the app in the simulator on the product named, get the state shown, then Cmd+Shift+4 around the watch (chassis plus strap top and bottom). Window geometry must stay identical to earlier shots (794×1081 window) so one crop fits all.

**Capture order matters (learned 2026-09-26):** rows 2-5 need a partly-filled day (counting: non-zero reps, partial TODAY x/100, HR injected before the set; then adjust, save, menu with partial counts). Take them first; finish the day for row 6 last. A completed day makes every later state DONE/100.

| # | App | Simulator product | State to capture | Save as (`~/screenshots/`) | Status |
|---|---|---|---|---|---|
| 1 | HeroSet | `fr965` store build, goal 100 | Dashboard | `goal 100 full.png` | done, no streak. Source moved to `HeroSet/listing/src/fr965-dashboard-goal100-{window,454}.png`; cropped to `screens-framed/dashboard.png` |
| 2 | HeroSet | `fr965`, goal 100 | Counting push-ups (TODAY x/100) | `push up with hr full.png` | **done 2026-09-27.** Source `HeroSet/listing/src/fr965-counting-window.png`; cropped to `screens-framed/counting.png` |
| 3 | HeroSet | `fr965`, goal 100 | Review picker: DETECTED, +N, `UP/DOWN: ADJUST` | `adjust full.png` | **done 2026-09-27.** Source `HeroSet/listing/src/fr965-review-window.png`; cropped to `screens-framed/review.png` |
| 4 | HeroSet | `fr965`, goal 100 | `+N SAVED` dashboard | `save full.png` | **done 2026-09-27.** Source `HeroSet/listing/src/fr965-saved-window.png`; cropped to `screens-framed/saved.png` |
| 5 | HeroSet | `fr965`, goal 100 | Menu, `Start Squats` whole (scroll position of `menu 5 full.png`) | `menu 5 full.png` | **done 2026-09-27** (scroll rests on Sit-ups, Squats fully visible, not centered — close enough, retake only if that's wrong). Source `HeroSet/listing/src/fr965-menu-window.png`; cropped to `screens-framed/menu.png` |
| 6 | HeroSet | `fr965`, goal 100 | DAILY MISSION COMPLETE, 1 day streak | `complete full.png` | done. Source moved to `HeroSet/listing/src/fr965-complete-streak-{window,454}.png`; cropped to `screens-framed/complete.png` |
| 7 | HeroSet | `venu441mm` (touch), goal 100 | Review picker, `SWIPE: ADJUST` | `venu 4 full.png` | **done 2026-09-27.** Source `HeroSet/listing/src/venu441mm-review-touch-window.png`; cropped to `screens-framed/venu-review-touch.png`, swipe-gesture glyph added (the one non-capture addition) |
| 8 | HeroFace | `fenix5` (240 px) | Everyday, part-filled: 3406 steps, 20 int min, 7 floors | `heroface-1-everyday.png` | open |
| 9 | HeroFace | any round sim (docs don't say) | Everyday, all three goals met, 1-day streak | `heroface-2-goals-met.png` | open; note product used |
| 10 | HeroFace | `fr965` | HeroSet mode, 20/45/10 reps, rank 2, orange ring | `heroface-3-heroset.png` | open: only a real watch had HeroSet data; can the sim? else leave plain |
| 11 | HeroFace | `fr965` | HeroSet mode, all three met, rank 2, streak 1 | `heroface-4-heroset-complete.png` | same as #10 |
| 12 | HeroFace | `fr245` (no barometer) | STEPS / INT / MOVE | `heroface-5-no-barometer.png` | open |

- [x] All 7 HeroSet rows cropped, padded to 720², placed in `listing/screens-framed/`, `listing/README.md` Screen Images list rewired to them (2026-09-27).
- [ ] Still open: site copies in `site/public/heroset/screens/` (never rename published URLs), re-render hero + cover (their layouts need rework for tall framed shots — `hero.html` still points at the old `screens/2-counting.png` etc), upload all 7 to the live HeroSet store listing. HeroFace rows (8-12) untouched.

## HeroSet 1.1.2 glance (built 2026-09-26, not uploaded; gates the upload, [ADR-051](HeroSet/docs/decisions.md#adr-051))

- [x] E1. FAILED, then fixed and confirmed same day (2026-09-27, FR965 dev build): killed at exactly 120s idle from a glance launch, reps lost. Fix: ADR-052, a periodic recoverable draft. **Closed:** restarted the same exercise, count resumed; a different exercise correctly showed 0. Not yet checked, not blocking: a draft surviving to the next calendar day reads as 0.
- [x] E2a. Glance appears by default on FR965 (dev build, 2026-09-27), no listing/FAQ change needed.
- [~] E2b. **Skipped, owner call 2026-09-27.** Saved set shows on return; 00:01 shows zeros without opening the app; missed day shows no streak. Not verified before upload.
- [x] E3. HeroFace complication confirmed matching HeroSet after a save (2026-09-27).
- [~] E4. **Skipped, owner call 2026-09-27.** Simulator by hand, Settings > Glance Launch Mode: `fr965`, `fenix7` (63 px), `fr255s` (140x79): looks right, done state, memory view. Not looked at before upload.
- [~] E5. **Skipped, owner call 2026-09-27** — `CIQ_LOG.YAML` and battery comparison not done before upload; store build permissions confirmed unchanged by grep/manifest check. **1.1.2 uploaded 2026-09-27, awaiting Garmin review.** Once it's live: `glanceLive = true` in `site/src/apps/heroset/facts.ts`, then `npm run deploy` in `site/` (the FAQ is hidden until then). Screenshots for the listing still owed (owner will add later).

## Simulator

- [ ] B2. `venu441mm` (swipe up/down in the picker confirmed 2026-09-26; rest open): tap mid-set does nothing; START finishes; swipe up = +1; swipe-right mid-set shows Resume.
- [ ] B3. `d2airx10`: START opens the menu and selects in Menu2.
- [ ] HeroFace 3. Re-capture site screenshots at 454 px plus the always-on shot; original-Venu heat map.

## Other

- [ ] B4. Native-speaker read of 1.1.1 touch-hint strings (`deu`, `lit`, `pol`).
- [ ] **Due 2026-10-10:** DMARC `p=none` → `p=quarantine` after checking rua reports in hello@verden.watch. Then delete the "Due" line in `site/CLAUDE.md`.
- [ ] Later: private beta, paid-launch announcement.
- [ ] Next feature: 1.2.0 Connect sync (ADR-043), gated on FR965 spike.
