# TODO

Single list for both watch apps. Tick here. Evidence detail lives in each app's
`docs/go-to-market.md` ("Next session") — fold results there, not here.
Last consolidated 2026-09-26.

## Listings

- [x] A1. Manifest check (2026-09-26): HeroSet `manifest.xml` and `manifest-store.xml` identical, 80 products; HeroFace has one `manifest.xml`, 117 products. Store-side listing is Garmin's call; nothing to chase.
- [x] A2. Category (2026-09-26): re-set on HeroSet; the developer page HTML (incognito) shows STRENGTH_TRAINING. Not checked: whether the store API still reads 219.
- [x] A3. Dropped 2026-09-26: the mobile app only selects a device by linking a real one, and there is no fēnix 9 / FR170 to link. Store-side bug, not ours anyway.
- [x] HeroFace 1. FR965 store install of 1.0.1 (2026-09-26): live; face and HeroSet both installed, link works. °F rounding checked on the FR965, shows correct. Not checked: stored mode 2 → Auto.
- [ ] A4. Upload `HeroSet/listing/screens/6-review-touch.png` as an extra Screen Image on the HeroSet store listing (Venu 4 41mm simulator, `SWIPE: ADJUST`; edit details need no re-review). Source frame: `HeroSet/listing/src/venu4-41mm-simulator-full.png`.

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

Capture: run the app in the simulator on the product named, get the same state as the current plain file, then Cmd+Shift+4 around the watch (chassis plus strap top and bottom).

- [ ] HeroSet 1-5, `fr965` store build, same states as `HeroSet/listing/screens/1-dashboard.png` … `5-menu.png`. Names: `heroset-1-dashboard.png`, `-2-counting`, `-3-review`, `-4-saved`, `-5-menu`.
- [ ] HeroSet 6, `venu441mm`, review picker showing `SWIPE: ADJUST`. Name: `heroset-6-review-touch.png`. (Have a small window shot already: `HeroSet/listing/src/venu4-41mm-simulator-full.png`; recapture bigger if it looks soft.)
- [ ] HeroFace 1, `fenix5` sim, everyday part-filled (3406 steps, 20 int min, 7 floors). Name: `heroface-1-everyday.png`.
- [ ] HeroFace 2, sim, all three goals met, 1-day streak (product not recorded in docs; note which you use). Name: `heroface-2-goals-met.png`.
- [ ] HeroFace 5, `fr245` sim, STEPS / INT / MOVE (no-barometer fallback). Name: `heroface-5-no-barometer.png`.
- [ ] HeroFace 3-4 (HeroSet mode, rank 2) are FR965 System → Screenshot files with no chassis. Open question: can the simulator show HeroSet mode? If not, leave these two plain.
- [ ] After captures (Claude): update `listing/README.md`/`screenshots.md`, site copies in `verden-site/public/{heroset,heroface}/screens/` (never rename published URLs), re-render hero + cover, then upload to both store listings.

## Simulator

- [ ] B2. `venu441mm` (swipe up/down in the picker confirmed 2026-09-26; rest open): tap mid-set does nothing; START finishes; swipe up = +1; swipe-right mid-set shows Resume.
- [ ] B3. `d2airx10`: START opens the menu and selects in Menu2.
- [ ] HeroFace 3. Re-capture site screenshots at 454 px plus the always-on shot; original-Venu heat map.

## Other

- [ ] B4. Native-speaker read of 1.1.1 touch-hint strings (`deu`, `lit`, `pol`).
- [ ] **Due 2026-10-10:** DMARC `p=none` → `p=quarantine` after checking rua reports in hello@verden.watch. Then delete the "Due" line in `verden-site/CLAUDE.md`.
- [ ] Later: private beta, paid-launch announcement.
- [ ] Next feature: 1.2.0 Connect sync (ADR-043), gated on FR965 spike.
