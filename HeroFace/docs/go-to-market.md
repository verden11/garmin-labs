# Go to market — HeroFace

Status: 2026-09-25.

## Next session (from the 2026-09-25 store check)

Order and the HeroSet half: `../../HeroSet/docs/go-to-market.md`, "Next session".

- [ ] 1. Developer dashboard: is 1.0.1 in review, or was only the text saved? If the `.iq` never went up, upload `bin/HeroFace-next.iq` as 1.0.1. The live page shows the 1.0.1 What's New under version 1.0.0 until then.
- [ ] 2. Paste the Description block from `listing/README.md` as one plain-text block (live page has only the hard-wrapped opening).
- [ ] 3. Once 1.0.1 is live, re-read the store API (version, date, text) and mark it live in `CHANGELOG.md`.
- [ ] 4. FR965, store install of 1.0.1: face still links to HeroSet; install HeroSet after the face and the link appears within a minute (relink); temperature in °F rounds; a stored mode 2 shows Auto.
- [ ] 5. Gate 4 items still open (§1): settings round-trip through Connect, seconds power budget, 96 KB memory headroom, MIP contrast.
- [ ] 6. Review W14: re-capture the site screenshots at 454 px plus the always-on screen; original-Venu heat map (simulator GUI). The always-on shot also goes into the listing (§3).
- [ ] 7. Device list: 69 of 117 listed; same Garmin question as HeroSet A4.

## Status checkpoint

**Store device list (store API, 2026-09-25):** 69 of the 117 products are listed. Missing: fēnix 5/5 Plus/5S/5X family, fēnix 6S, fēnix Chronos, FR55, FR245/245M, FR645/645M, FR745, FR935, FR945/945 LTE, vívoactive 3/3M/3 LTE/4/4S, Venu, Venu D, D2 Air, D2 Air X10, D2 Charlie/Delta ×3, Descent MK1/MK2/MK2S, Enduro, Approach S62, MARQ Gen 1 ×8, Legacy Hero/Saga ×4. HeroSet misses the same families, so this looks store-side. **1.0.1 is not live yet** at that check: the store still serves 1.0.0 (released 2026-09-22) while showing the 1.0.1 What's New text.

**Next upload (2026-09-24):** `bin/HeroFace-next.iq` carries the code-review fixes (link null-guard and once-a-minute relink, the "HeroSet" mode entry removed with a stored 2 read as Auto, Fahrenheit rounding; `../reports/Verden code quality review.md`). 16/16 tests on six products in the simulator; not yet on a watch. `bin/HeroFace.iq` stays the 1.0 artifact.

**Live in the store.** Garmin approved the submission on **2026-09-22** and
the listing resolves: https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116
(200, HeroFace / Verden, checked 2026-09-22). The rest of the device evidence
in §1 is still open — but approval changes the shape of it: the two items that
had **no pre-store path** (settings round-trip, always-on screenshot) are now
testable against the store install.

| | State |
|---|---|
| Code | Complete for round watches: everyday mode, HeroSet mode, settings, always-on. A finish review returned `fix`; all six items applied (see `docs/plan.md`) |
| Simulator evidence | **15/15 tests re-run 2026-09-22 on 11 products** — fr965 plus one per screen size (`fr55`, `fenix5s`, `fenix5`, `vivoactive4`, `fenix7x`, `fr265s`, `fr165`, `epix2`, `fenix9pro51mm`) and the no-barometer `fr245`, so screen fit covers all 10 sizes (208–466 px); the 15th is the power-budget fallback test. 14 languages id/placeholder-clean; `.iq` builds for all 117 |
| Device evidence | FR965 2026-09-20/22: both apps install, face renders, the HeroSet link updates within seconds, no permission prompt, **reboot survives**, **a full day of wear with no crash**, always-on shift confirmed. **2026-09-22: no AOD retention after a night with sleep mode off, and the midnight reset fires.** **Battery: 66% → 60% over 20h36m (~7%/day), seconds on, sleep mode off.** Still open: **the seconds power budget, settings delivery, MIP** |
| Store listing | **Approved and live 2026-09-22.** Copy and images shipped (`listing/`): 5 screens, cover, hero, device icons. Always-on screenshot still deferred to a listing update (2026-09-21 user call) — now capturable off the store build |
| Site pages | **Live**: https://verden.watch/heroface/ , `/heroface/support/` , `/heroface/privacy/` (all 200, 2026-09-20). `storeUrl` **set 2026-09-22** in `../verden-site/src/apps/heroface/app.ts` to **https://apps.garmin.com/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116** (the store listing returns 200). The site is prerendered, so the Get button appears only after a rebuild and deploy |
| HeroSet side | Publisher built and tested (HeroSet's suite, 94 / 85 store — `../../HeroSet/CLAUDE.md`). **Working:** HeroSet **1.1.0** is live (2026-09-21) and carries the publisher, so the link works for buyers who own both and have updated (§2) |

**Open, not blocking:** the rest of gate 1 — the seconds power budget and
MIP. Ghosting, the midnight reset and a clean battery window were all answered
on 2026-09-22 (§1), so the listing's always-on claim is backed.
Settings delivery is no
longer undecidable: the store build can be installed through Connect and the
round-trip tested for real (§1). Gate 2 is done; gate 3 closed on approval.
Anything that fails now is a code fix plus a listing update, not a withdrawal.

## What "production ready" is missing

Ordered by what would hurt most if skipped.

### 1. Device evidence (gate 1)

Everything below is unknown until the face runs on the FR965. The simulator
cannot answer any of it.

- **Always-on burn-in.** The sleep screen must stay under Garmin's 10% lit
  pixels and move often enough. Wrong here means a rejected app or, worse, a
  damaged screen. **Partly evidenced 2026-09-21 (FR965):** on-wrist and still,
  the sleep screen draws a dim time and nothing else, and the block steps every
  minute — confirmed with a throwaway `BURN_IN_STEP_PX = 24` build, since 4 px
  is below what the eye can judge. Off-wrist the screen goes fully dark, and
  sleep mode blanks it too, so ghosting needed a night with sleep mode off; the
  night of 2026-09-20 drew no AOD frames between 23:00 and 07:00 and proved
  nothing. **Answered 2026-09-22 (FR965, user report): the night of
  2026-09-21/22 ran with sleep mode off, always-on and seconds on, and showed
  no retention.** One night on one AMOLED watch, so it is evidence rather than
  proof — but it is the evidence the listing's always-on claim needed, and the
  claim now stands.
- **Partial-update power budget.** Seconds redraw through `onPartialUpdate`.
  Over budget the system stops calling it; the face handles
  `onPowerBudgetExceeded` by switching seconds off rather than leaving a frozen
  number. Split into three parts, 2026-09-22:
  - *The fallback path* — **covered.** `disabledSecondsDrawNoSecondsBox`
    (`source/test/HeroFaceScreenFitTest.mc`) turns the `Seconds` property on,
    draws a frame, calls `disableSeconds()` and draws again: one text row
    fewer, the seconds box gone, and `onPartialUpdate` still safe to call. On a
    screen too narrow for seconds the row count must not move instead.
    Verified by mutation on 2026-09-22 — emptying `disableSeconds()` makes the
    test fail. A real budget overrun cannot be forced, so the state change it
    triggers is what is tested, not the trigger.
  - *The measurement* — **not obtainable here.** The only source of a
    partial-update cost figure is the simulator's watch-face power estimation,
    a GUI view; `connectiq` and `monkeydo` expose no flag for it (checked
    2026-09-22). Either someone runs the simulator by hand, or this stays
    unmeasured.
  - *The device half* — the 2026-09-21/22 window ran seconds ON for 20h36m on
    the FR965. If the seconds were still ticking at the end, the budget held
    for a full day and night; **confirm that before calling it evidence.**
- **Battery cost per day**, both settings, AMOLED and MIP. First FR965 figure
  (2026-09-20 21:42 76% → 2026-09-21 19:17 67%, 9% / 21h35m, seconds off) is
  **not quotable**: sleep mode blanked the display for 8h of it and HeroSet was
  exercised the same day, so it is not attributable to the face. **Second
  window (FR965, seconds ON, sleep mode OFF, always-on ON): 66% at
  2026-09-21 23:24 → 60% at 2026-09-22 20:00 — 6% over 20h36m, about
  0.29 %/h or ~7% per day.** This is the clean window the first one was not:
  the display was never blanked by sleep mode, and it covers a full night plus
  a full day of wear. Two caveats before treating it as the face's cost: it is
  whole-watch drain, not the face's alone, so any activity recording or HeroSet
  use that day is inside the 6%; and it is one window on one AMOLED watch. Good
  enough to plan with, not to publish — **no battery number goes in the
  listing** ("Claims allowed and forbidden"). MIP is unverifiable — no MIP watch
  (§5).
- **MIP daylight contrast** for `MUTED` text and the `TRACK` grey.
- **The HeroSet link end to end:** ~~the face finds the private complication, a
  save updates it within seconds, the value survives a watch reboot, a hold
  opens HeroSet, the goal field drives the ring~~ (**all done 2026-09-20**);
  ~~the midnight reset~~ (**done — reset happened at midnight on the FR965,
  2026-09-22 user report**). Nothing open here.
- **Memory headroom on a 96 KB watch** (fēnix 5S, vívoactive 3) — read the
  simulator's memory view during a real run; the build compiling is not proof.
- **Settings round-trip** through the Connect phone app: every setting reaches
  the watch, and a bad value falls back instead of crashing.
  **Was not testable before the store (found 2026-09-21).** A sideloaded watch
  face gets no settings entry at all: nothing in the Connect phone app, and on
  the FR965 the face offers only "Apply". The build is wired correctly —
  `resources/settings/properties.xml` declares all 7 properties and
  `settings.xml` binds them — so this was a sideload limitation, not a defect.
  **Unblocked 2026-09-22:** the listing is live, so install HeroFace from the
  store on the FR965 and run the round-trip through Connect for real. It
  shipped unverified; verify it now, before announcing. Two knock-ons: the `Seconds` power-budget test needs a
  throwaway build with the default flipped to `true`, and the bad-value
  fallback can only be exercised in the simulator's settings editor
  (`HeroFaceSettings` guards every read with `instanceof` plus a catch on
  `InvalidKeyException`, but no unit test covers it).

### 2. HeroSet's new permission

HeroSet now requests `ComplicationPublisher` in both manifests. Whether an
update re-prompts existing users for permission is unverified. This is a change
to an app that is already shipping.

**Decided 2026-09-20 (user call): both apps go out in the same submission
window**, so the link works the day HeroFace lands.

**Settled — the link works.** HeroSet 1.0.0 (uploaded 2026-09-19, live 2026-09-21) shipped without
`HeroSetComplicationPublisher`, but **HeroSet 1.1.0 went live 2026-09-21 carrying it**
(`../../HeroSet/docs/go-to-market.md`). So a buyer who owns both and has updated HeroSet
sees HeroSet mode; one still on 1.0.0 sees everyday mode until they update, which is the
designed fallback, not a fault. CIQ 4.2+ products only (ADR-044). This never blocked
submitting HeroFace.

**Resolved 2026-09-20 on the FR965:** sideloading the store build over an
existing install produced **no permission prompt**, so the risk this decision
accepted did not materialise. A store update is not identical to a sideload, so
watch the first update's reviews, but nothing further is owed here.

### 3. Store assets and listing

**Read Garmin's App Review Guidelines first** (SDK docs: `ConnectIQBasics.html`
→ Reference Guides → "Garmin Connect IQ App Review Guidelines", plus "Publishing
to the Connect IQ Store"). Watch faces have their own rejection criteria, and
the asset list below is derived from the SDK's publishing page, not from
memory. Submission is a `.iq` upload plus description, screenshots and details;
review takes about 72 hours.

- Screenshots from the simulator per screen size, in both modes, plus an
  always-on shot. **Decided 2026-09-21 (user call): ship without the always-on
  screenshot**, add it in a later listing update. It has no automated path
  here — this environment cannot capture the simulator, and the watch's own
  System → Screenshot needs a keypress, which should wake the display and
  capture the awake face rather than the sleep screen (inferred, not tested).
  The five existing screens satisfy the store requirement; the always-on shot
  was a nice-to-have.
- **Launcher icon check.** The 65x65 SVG triggers a build warning on smaller
  watches ("isn't compatible with the specified launcher icon size… will be
  scaled"). The SDK supports SVG launcher icons and auto-scales them, so this
  is expected to be informational, but confirm it looks right on a 40x40 watch
  before submitting rather than after a rejection.
- **GDPR:** the face collects and transmits nothing, so the privacy page can
  say exactly that. Keep it that way; any future data collection changes the
  obligation.
- Listing copy that sells the everyday face first, mentions HeroSet once, and
  claims nothing the build does not do.
- Store icon and hero art.
- Price tier USD 2.00, and the support and privacy URLs below.

### 4. Site pages

`../verden-site/src/apps/heroface/`: landing, support, privacy, live at
`/heroface/`, `/heroface/support/`, `/heroface/privacy/`. The privacy page
states what is true: nothing leaves the watch, no account, no network, and the
only data sharing is with HeroSet on the same watch through a private
complication. Cross-link with HeroSet's pages, and add the row to
`../verden-site/CLAUDE.md`'s app table.

### 5. Known gaps that are not blockers

- Rectangle and Instinct-shaped watches unsupported (phase 4).
- The 15 round watches below CIQ 3.0 are out of scope permanently (`plan.md` decision 1).
- No external beta tester. **Decided 2026-09-20 (user call): submit after the
  maintainer's own FR965 run, no beta round.** MIP daylight contrast and
  all-day battery on a non-FR965 watch therefore stay unverified at launch, and
  the first report may arrive as a public review.

## Phases and gates

**Gate 1 — device acceptance (blocks everything).** FR965 sessions covering
§1 above, with both builds and a tick list in `../device-test/`
(`CHECKLIST.md`, git-ignored so one folder holds the pair), plus the same face sideloaded to any MIP watch if one is available.
Failures here change the code, not the listing.

**Gate 2 — assets and pages. Done.** The always-on screenshot was dropped to a
post-launch listing update (§3); nothing else is outstanding. The three site pages are live and return 200; the store images are
in `listing/` (`cover-500.png`, `hero-1440x720.png`, `icon-24-128.png`,
`icon-64-128.png`, `screens/1-everyday.png` … `5-no-barometer.png`).

**Gate 3 — submission. Done.** Submitted 2026-09-21, **approved 2026-09-22**
(Garmin's approval mail; listing 200 the same day). HeroSet 1.1.0 went live
first on 2026-09-21 carrying the publisher, so the link works for anyone who
owns both and has updated.

**Gate 4 — after launch. Active from 2026-09-22.** In order: install the
store build on the FR965 and test the settings round-trip through Connect
(§1); finish the open device evidence (ghosting overnight with sleep mode off,
the seconds power budget, MIP contrast); add the
always-on screenshot to the listing (§3); deploy the site so the Get button
renders. Then watch reviews for device-specific layout complaints, add
translations, and phase 4 shapes if the reviews ask for them.

## Positioning

The listing sells a practical everyday face: time first, three daily goals as
bars, a goal streak, battery and heart rate, and settings that let each bar
show what the wearer cares about. HeroSet gets one line — "shows your HeroSet
reps, rank and streak if you have it" — because most buyers will not own it.

Price USD 2.00 ($1.99 US), the same tier as HeroSet. Garmin's 48-hour return
window is the only trial, and the listing says so plainly.

## Claims allowed and forbidden

Allowed: the metric list, the 117 supported watches, "nothing leaves your
watch", the HeroSet link on Connect IQ 4.2+ watches, the settings.

Forbidden until measured on a watch: any battery-life number, any always-on
claim beyond what the FR965 night of 2026-09-21/22 backs (§1: the face works
always-on without burn-in retention on that watch), "works with every Garmin", accuracy claims of any kind, and any review,
rating or user count — none exist.
