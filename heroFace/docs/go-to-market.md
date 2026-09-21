# Go to market — HeroFace

Status: 2026-09-21.

## Status checkpoint

**Not production ready.** The code is complete and verified in the simulator,
the FR965 has worn it for a full day, and the store images and site pages
exist. What is missing is the rest of the device evidence in §1 — and two of
those items have no pre-store path at all, so they need a decision rather than
another session.

| | State |
|---|---|
| Code | Complete for round watches: everyday mode, HeroSet mode, settings, always-on. A finish review returned `fix`; all six items applied (see `docs/plan.md`) |
| Simulator evidence | 14/14 tests and screen fit on all 10 sizes (208–466 px) re-run **2026-09-21**; 14 languages id/placeholder-clean; runs on 5 products; `.iq` builds for all 117 |
| Device evidence | FR965 2026-09-20/21: both apps install, face renders, the HeroSet link updates within seconds, no permission prompt, **reboot survives**, **a full day of wear with no crash**. Always-on shift confirmed; **ghosting, battery, the seconds power budget, settings delivery and midnight still open** |
| Store listing | Copy drafted (`docs/listing/`); images done: 5 screens, cover, hero, device icons in `listing/`. Always-on screenshot deferred to a post-launch update (2026-09-21 user call) |
| Site pages | **Live**: https://verden.watch/heroface/ , `/heroface/support/` , `/heroface/privacy/` (all 200, 2026-09-20). `storeUrl` in `../verden-site/src/apps/heroface/app.ts` still unset until the listing exists |
| HeroSet side | Publisher built and tested (HeroSet's suite, 94 / 85 store — `../../HeroSet/CLAUDE.md`). **Settled:** HeroSet 1.0.0 is live since 2026-09-21 and does **not** contain the publisher, so the link is dark until HeroSet 1.1.0 clears review (§2) |

**Blocked on:** the rest of gate 1. Settings delivery has **no pre-store path**
(§1) and needs a decision rather than a test. Gate 2 is done — the always-on
screenshot was dropped to a later listing update (§3).

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
  sleep mode blanks it too, so **ghosting needs a night with sleep mode off**;
  the night of 2026-09-20 drew no AOD frames between 23:00 and 07:00 and proved
  nothing.
- **Partial-update power budget.** Seconds redraw through `onPartialUpdate`.
  Over budget the system stops calling it; the face now handles
  `onPowerBudgetExceeded` by switching seconds off rather than leaving a frozen
  number. Measure with seconds on and off, and check that the fallback fires
  cleanly if it trips.
- **Battery cost per day**, both settings, AMOLED and MIP. First FR965 figure
  (2026-09-20 21:42 76% → 2026-09-21 19:17 67%, 9% / 21h35m, seconds off) is
  **not quotable**: sleep mode blanked the display for 8h of it and HeroSet was
  exercised the same day, so it is not attributable to the face. A clean
  seconds-on overnight window with sleep mode off is the next attempt. MIP is
  unverifiable — no MIP watch (§5).
- **MIP daylight contrast** for `MUTED` text and the `TRACK` grey.
- **The HeroSet link end to end:** ~~the face finds the private complication, a
  save updates it within seconds, the value survives a watch reboot, a hold
  opens HeroSet, the goal field drives the ring~~ (**all done 2026-09-20**);
  still open: the midnight reset.
- **Memory headroom on a 96 KB watch** (fēnix 5S, vívoactive 3) — read the
  simulator's memory view during a real run; the build compiling is not proof.
- **Settings round-trip** through the Connect phone app: every setting reaches
  the watch, and a bad value falls back instead of crashing.
  **Not testable before the store (found 2026-09-21).** A sideloaded watch face
  gets no settings entry at all: nothing in the Connect phone app, and on the
  FR965 the face offers only "Apply". The build is wired correctly —
  `resources/settings/properties.xml` declares all 7 properties and
  `settings.xml` binds them — so this is a sideload limitation, not a defect.
  Either accept it unverified at launch, or check it on the approved build
  before announcing. Two knock-ons: the `Seconds` power-budget test needs a
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

**Settled 2026-09-20, and it decides whether the link works on day one:**
unpacking the uploaded `bin/HeroSet-store.iq` (built 2026-09-19 23:52) showed no
`HeroSetComplicationPublisher` — the ADR-044 work is dated 2026-09-20.
**Garmin approved that 1.0.0 on 2026-09-21 and it is live**
(`../../HeroSet/docs/go-to-market.md`), and the user chose to leave it published
and fix forward (HeroSet ADR-047). So the shipping HeroSet does not publish the
complication: HeroFace buyers who own HeroSet see everyday mode until **HeroSet
1.1.0** clears review. 1.1.0 is the save-crash fix, this complication and the
daily goal — Connect sync moved to 1.2.0 (2026-09-21), so 1.1.0 is days of
device checks plus a review cycle, not weeks. That does not block submitting
HeroFace.

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

- English only (by decision). Translations after launch.
- Rectangle and Instinct-shaped watches unsupported (phase 4).
- The 13 round watches below CIQ 3.0 are out of scope permanently.
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

**Gate 3 — submission.** Upload `bin/HeroFace.iq`, set the price tier, paste
the URLs, and submit. HeroSet's update (publisher plus permission) goes in the
same window, as decided above, so the link works for anyone who buys both.
Reviews take about 72 hours; a rejection comes back with specific reasons and
the app can be resubmitted.

**Gate 4 — after launch.** Watch reviews for device-specific layout
complaints, add translations, then phase 4 shapes if the reviews ask for them.

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
claim, "works with every Garmin", accuracy claims of any kind, and any review,
rating or user count — none exist.
