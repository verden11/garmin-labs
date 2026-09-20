# Go to market — HeroFace

Status: 2026-09-20.

## Status checkpoint

**Not production ready.** The code is complete and verified in the simulator;
nothing has run on a watch, and none of the store or site work exists yet.

| | State |
|---|---|
| Code | Complete for round watches: everyday mode, HeroSet mode, settings, always-on. A finish review returned `fix`; all six items applied (see `docs/plan.md`) |
| Simulator evidence | 12/12 tests; screen fit on 10 sizes (208–466 px); runs on 5 products; `.iq` builds for all 117 |
| Device evidence | FR965 2026-09-20: both apps install, face renders, the HeroSet link updates within seconds, no permission prompt. Always-on, battery, reboot and midnight still open |
| Store listing | Not started |
| Site pages | Not started (`../verden-site/src/apps/heroface/`) |
| HeroSet side | Publisher built and tested (88/88), needs the same device run |

**Blocked on:** one FR965 session (gate 1) and the two Verden web pages, which
the store listing needs before it can be submitted.

## What "production ready" is missing

Ordered by what would hurt most if skipped.

### 1. Device evidence (gate 1)

Everything below is unknown until the face runs on the FR965. The simulator
cannot answer any of it.

- **Always-on burn-in.** The sleep screen must stay under Garmin's 10% lit
  pixels and move often enough. Wrong here means a rejected app or, worse, a
  damaged screen.
- **Partial-update power budget.** Seconds redraw through `onPartialUpdate`.
  Over budget the system stops calling it; the face now handles
  `onPowerBudgetExceeded` by switching seconds off rather than leaving a frozen
  number. Measure with seconds on and off, and check that the fallback fires
  cleanly if it trips.
- **Battery cost per day**, both settings, AMOLED and MIP.
- **MIP daylight contrast** for `MUTED` text and the `TRACK` grey.
- **The HeroSet link end to end:** ~~the face finds the private complication, a
  save updates it within seconds~~ and the value survives a watch reboot
  (**all done 2026-09-20**); still open: a hold opens HeroSet, and the midnight
  reset.
- **Memory headroom on a 96 KB watch** (fēnix 5S, vívoactive 3) — read the
  simulator's memory view during a real run; the build compiling is not proof.
- **Settings round-trip** through the Connect phone app: every setting reaches
  the watch, and a bad value falls back instead of crashing.

### 2. HeroSet's new permission

HeroSet now requests `ComplicationPublisher` in both manifests. Whether an
update re-prompts existing users for permission is unverified. This is a change
to an app that is already shipping.

**Decided 2026-09-20 (user call): both apps go out in the same submission
window**, so the link works the day HeroFace lands.

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
  always-on shot.
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

**Gate 1 — device acceptance (blocks everything).** One FR965 session covering
§1 above, with both builds and a tick list in `../device-test/`
(`CHECKLIST.md`, outside both repos so one folder holds the pair), plus the same face sideloaded to any MIP watch if one is available.
Failures here change the code, not the listing.

**Gate 2 — assets and pages.** Screenshots, listing copy, and the three site
pages deployed. The listing cannot be submitted before the URLs resolve.

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
