# Release contract

Status: 2026-10-05 (1.3.0, Instinct family, live since owner's 2026-10-03 upload; 1.3.1 uploaded 2026-10-04, in Garmin review). What **store build** (`store.jungle`, [ADR-033](decisions.md#adr-033)) may honestly claim. Check before any user-facing copy (site, listing, What's New).

| Capability | Status | Evidence / limit |
|---|---|---|
| Devices | **1.3.0 and 1.3.1 (uploaded 2026-10-03 and 2026-10-04): 87 watches**: 80 round, AMOLED + MIP, CIQ 3.4+ (67 five-button, 13 touch-first Venu 2/3/4, vívoactive 5/6, Approach S50/S70, D2 Air X10; [`compatibility.md`](compatibility.md), [ADR-048](decisions.md#adr-048)) plus seven Instinct-family 1-bit semi-octagon watches (Instinct 2, 2S, 2X, E 40/45 mm, 3 Solar 45 mm, Descent G1; [ADR-055](decisions.md#adr-055)); Instinct Crossover not included. Next upload, 1.3.1, changes no product, no permission. **Live: 1.4.0 (uploaded 2026-10-08, live by 2026-10-09 per store API; called 1.3.2 while unreleased): 92**, adding Instinct 3 AMOLED 45/50 mm (round colour) and rectangular Venu Sq 2, Sq 2 Music, X1 ([ADR-057](decisions.md#adr-057)), all five on paid-app list, simulator only; Instinct Crossover AMOLED stays out (hands cover screen's middle in simulator, [`compatibility.md`](compatibility.md) wave 7). Instinct claims wait for store to approve listing's device list (`instinctLive` on site); **listing text never names watch models, store's device tab is the claim**; Instinct 2, 2S, 2X, Descent G1 in package but not sold for paid app (see "Paid vs free reach") | Only FR965 on a wrist; rest compile + pass screen fit in simulator ([ADR-039](decisions.md#adr-039)); Instinct family: simulator only, incl. 15-language fit sweep, owner accepted that evidence 2026-10-03. Touch input (swipe, tap guard) never exercised on a touch-first watch |
| Automatic reps | Beta, learns from saved counts ([ADR-040](decisions.md#adr-040)); gate 2 accuracy waived for launch ([ADR-042](decisions.md#adr-042), amended 2026-09-21) | **No current device data** — see [`validation-log.md`](validation-log.md) for reset and pre-reset findings. Accuracy work is 1.1.1 item |
| Manual correction + logging | Implemented: buttons, or swipe on touch-first watches; tap on counting or adjust screen never finishes or saves (native menus still select by tap) | [ADR-024](decisions.md#adr-024)/[028](decisions.md#adr-028)/[029](decisions.md#adr-029)/[048](decisions.md#adr-048) |
| Goals, XP, rank, streak | Implemented | Unit tests; missed day shows streak 0 ([ADR-031](decisions.md#adr-031)) |
| Glance | Read-only glance-list entry: today's three bars and streak, on 63 of 80 live watches (Connect IQ 4.0+; not fēnix 6, MARQ Gen 1, Descent Mk2, FR945 LTE, Enduro Gen 1); 1.3.0 adds it on Instinct E and Instinct 3 Solar (66 of 87), not on Instinct 2 family; 1.3.1 lays it out left of round window there, blind ([ADR-051](decisions.md#adr-051), [ADR-055](decisions.md#adr-055)). **Shipped as 1.2.0 (submitted, not this doc's original 1.1.2, ADR-053)** | Simulator only, no glance on any wrist (Instinct glance's real place unknown). Idle timeout of app launched from glance unmeasured (hard gate, [`status.md`](status.md) E) |
| Daily goal | 100 each by default, user-set on watch, 10–500 in steps of 10 ([ADR-045](decisions.md#adr-045)) | Unit tests; picker fits 218–466 px in simulator. **Gate 5 re-check open** (store menu gained the item) |
| XP vs the goal | XP stops at 100 reps per exercise per day whatever goal is | `xpStillCapsAtTheFixedRepCapWithAHighGoal`. Claim: **rank reflects reps done, not goals hit** — never say higher goal earns rank faster |
| Storage upgrade | Implemented | Flat `hero_*` keys unchanged ([ADR-003](decisions.md#adr-003)/[036](decisions.md#adr-036)); FR965 upgrade kept progress (2026-09-18) |
| Live HR | `Sensor.getInfo().heartRate` | Garmin sensor, real time |
| Live calories (`CAL`) | Change in `ActivityMonitor.getInfo().calories` (whole-day total) since set start | Estimate, **not** session calculation ([ADR-021](decisions.md#adr-021)). Manual entries get neither |
| Connect/Strava sync | **Not in store build** | No toggle, no `Fit` permission. Dev build: opt-in, unverified ([ADR-043](decisions.md#adr-043), [`connect-sync-plan.md`](archive/connect-sync-plan.md)) |
| Data leaving watch | None | No network, no recording, no analytics; permissions `Sensor` and `ComplicationPublisher` only |
| Languages | 15: English (fallback), German, French, Spanish, Italian, Portuguese, Dutch, Polish, Swedish, Danish, Norwegian Bokmål, Finnish, Turkish, Lithuanian, Ukrainian | Simulator only. Fact for docs: **listing text and What's New name no language, give no count**; one allowed line: "Multi-language support: it follows your watch's language." (owner, 2026-10-04) |
| Price / support | Paid, USD 2.50 tier (set in upload form with 1.3.1; no price number in listing or site text, [ADR-056](decisions.md#adr-056) (price: the $2.50 tier)); no trial ([ADR-039](decisions.md#adr-039) (no in-app trial)); https://verden.watch/heroset/support/, `/privacy/`, `hello@verden.watch` | Merchant approved 2026-09-18 |

## Paid vs free reach (2026-10-04)

**Owner, 2026-10-09: `manifest.xml` is source of truth for which watches site lists.** Model missing from store's device tab still runs app, so site keeps every manifest product; 18 unlisted models not trimmed (ROADMAP 16.5 closed). Listing text still names no model (rule below unchanged).

Garmin sells paid apps only on products of its App Sales list; **Instinct 2, 2S, 2X, Descent G1 not on it** (Instinct E 40/45 mm, Instinct 3 Solar are). Package still contains those four products (87 in manifest), but store's device list for HeroSet lacks them, so **paid HeroSet cannot be bought on them** and listing text must not name them (store review guideline 4b, accurate device disclosure). Measured on live 1.3.0 listing: 69 of 87 manifest products listed; 18 not = 7 off paid list (fēnix 6S, FR945 LTE, Enduro, Instinct 2, 2S, 2X, Descent G1) + 11 on list but unexplained (MARQ Gen 1 x8, Descent Mk2/Mk2i, Mk2 S, D2 Air X10). HeroSet Free would reach every manifest product (not built; gated on accuracy proof). 1.3.1 listing names no watch model ("black-and-white screens" only; store's device tab is the claim); live 1.3.0 text naming other four is wrong, edited in dashboard with 1.3.1 upload ([`status.md`](status.md) G). Source: [`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md) section 3.

## Refund wording (2026-10-04)

No refund or return wording in listing text (owner decision, 2026-10-04).

## Allowed claim

Button-first daily push-ups, sit-ups, squats app for 80 round Garmin watches, five-button and touch-first (87 in package incl. seven black-and-white Instinct-family watches, but paid HeroSet sold on only three of them; listing text names no watch model, see "Paid vs free reach"). Automatic rep counting that learns from counts you save, count adjustable before save, daily goal you set on watch (100 default, 10 to 500), XP, rank, streaks, live HR, calorie estimate. Rank reflects reps done, not goals hit: XP stops at 100 reps per exercise per day whatever goal is. Everything stays on watch: no activity recorded, nothing synced. Counting depends on placement and movement, so it can be off.

Public copy: no "beta", say "adjust" (never "fix"/"correct"), keep "can be off" caveat.

## Forbidden claims

- Medical-grade or exact calories; `CAL` as native or dedicated session value; replacing Garmin's calorie totals.
- Any watch model name in listing or What's New text (owner, 2026-10-04; Instinct 2, 2S, 2X, Descent G1 in package but not on Garmin's paid-app list, so not sold); language name or count in listing text; universal Garmin support; Instinct Crossover, Venu/vívoactive models below Connect IQ 3.4; rectangular watches before 1.4.0 upload (from 1.4.0 may be named by screen type, "rectangular", never by model, [ADR-057](decisions.md#adr-057)); Instinct support before Instinct upload is live; that Instinct family was tested on a wrist (simulator only).
- That touch-first watches (Venu, vívoactive, Approach) tested beyond simulator.
- That every listed watch tested on a wrist (only FR965).
- Any accuracy number or validated accuracy (10/10 results are simulator traces).
- Any Connect/Strava sync or activity, or effect on Training Status/Readiness/Load.
- GPS/distance.
- Glance on every watch (63 of 80 live, 66 of 87 in 1.3.1, 68 of 89 unreleased), glance "reminder", "alert" or "notification", or that glance works on a wrist before FR965 checks in [`status.md`](status.md) E pass.
- That higher daily goal earns XP or rank faster (it does not, [ADR-045](decisions.md#adr-045)).

When sync ships (v1.1 step 8), sync, data-leaving, Training Status rows change same session.

## Cross-promotion (rule copied from Days To Go and Two Suns, 2026-10-05, ROADMAP 13.32; the agent's pick on the owner's standing instruction)

- "More from Verden" links only live **free** siblings, checked with `curl` (HTTP 200) before each paste; never a paid listing, never a price.

## Never promise (2026-10-05, ROADMAP 15.6)

- Past-day correction or session history: HeroSet keeps day totals only, corrects today only.
- That sets add intensity minutes, workout or training load: set not saved as activity (watch's own all-day heart rate may still add intensity minutes; never claim either way beyond that).