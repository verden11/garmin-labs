# Free and Pro ladder: START HERE (agent handoff)

Single entry point for any agent/session picking up this work. Written 2026-09-28, status updated 2026-10-05. Only this file -> can start; two long documents below hold evidence, detail.

| Need | File |
|---|---|
| Decisions D1–D12, evidence, owner decisions OD1–OD8 | `reports/Free and Pro ladder.md` |
| Work packages WP0–WP10, task cards, gates, skill briefs | `reports/Free and Pro ladder execution plan.md` |
| Garmin rules, reach per product, revenue arithmetic, accent roster, Garmin email | `research_notes/Free and Pro ladder/` |
| One-page overview | https://claude.ai/artifact/JL6JXGX58271msCL7TFAbr (private, owner only) |

## 1. The strategy in ten lines

1. Every watch face ships as pair: **Free** (new app id, clean name, $0) + **Pro** (already-live paid app id, renamed "<Name> Pro"). Nothing ever flipped to free.
2. Split at compile time with `excludeAnnotations` (DayArc's method). No runtime toggle, unlock key, licence server, locked items visible in Free.
3. Free delivers whole promise, must look great; Pro only adds density, modes, layouts, colours. Free permissions = subset of Pro's.
4. **Every face has customisable accent colour in Free tier.** Lists only, append-only ids, each face admits only colours not colliding with own role colours.
5. **Design more daringly, not busier:** one decisive move per face, bold category-keyed colour, real icons, never colour keyed to reading. Design Free first. HTML/SVG mockup + browser screenshot + owner approval before any Monkey C. 96 KB faces (HeroFace, DaysToGo) no bitmap budget.
6. Paid apps sell only on Garmin's allow-list; free twin reaches 33 more products on HeroFace and Days To Go (0 extra on Two Suns and DayArc, 1 on HeroSet).
7. Price (owner, 2026-10-04): **every paid app takes $2.50 tier** (US $2.49, 2,99 €); free apps stay free; no price number in site or listing text.
8. Money small: cheap asymmetric bet, break-even attach about 0.8%, base case hundreds of dollars a year. Every revenue input = assumption.
9. Sequence: Wave 1 pilots = DayArc pair + Days To Go Free. Wave 2 = Two Suns Free, HeroFace Free (after HeroSet/HeroFace 30-day readout, about 2026-10-25). Wave 3 = HeroSet Free (after accuracy proof).
10. Gates: G1 reach (Free approval + 30 days: 100 installs, 3 reviews), G2 attach (+60 days: 5 Pro sales or 1%), G3 quality (Free rating ≥4.0), G4 renewal (month 12).

## 2. Status: read this first, it decides what you may do

**Approved by the owner 2026-10-04 (OD1/OD2), names (OD3) and price (OD4) decided same day; day-45 flip rule retired.** To-do list for everything = root `ROADMAP.md`; this tracker only says where each work package ended up.

| Allowed now | Not allowed until the owner says so |
|---|---|
| Read, research, mockups, spec/DESIGN drafts, tests, code, drafting listings and ADRs | Any store upload, any price/name/icon decision, site deploy (a push to `site/`), machine translations shipped, phone/watch tests |

Status tracker (update row you finish; keep date):

| WP | Item | State |
|---|---|---|
| WP0 | Owner decisions OD1–OD4 | done 2026-10-04 (ladder, names, $2.50 tier) |
| WP0 | Garmin email | cancelled by owner 2026-10-04; Garmin's published policies re-read instead (`reports/Garmin policies and design guidelines.md`) |
| WP0 | Flip reminders retired (ADR in Days To Go and Two Suns) | done 2026-10-04 (ADR-002 Superseded in both) |
| WP1 | Accent tables: HeroFace, Days To Go, Two Suns | shipped in each Free (ids below); extra ids 6–11 later (ROADMAP 8.3) |
| WP2 | Daring mockups: Days To Go first | open (ROADMAP 8.1, 8.2) |
| WP3 | DayArc pair releasable | built, nine design-review passes, packages exported 2026-10-05; owner wear check (ROADMAP 1.1), icons (1.5), upload (1.9) |
| WP4 | Days To Go Free + Pro 1.1.0 | **uploaded 2026-10-04, in Garmin review** (Pro adds "To the minute", ADR-018) |
| WP5 | Two Suns Free + Pro 1.1.0 | **uploaded 2026-10-04, in Garmin review** |
| WP6 | HeroFace Free + Pro 1.1.0 | **uploaded 2026-10-04, in Garmin review** |
| WP7 | HeroSet Free | gated (accuracy proof ROADMAP 7.3, complication-contract review 7.4) |
| WP8 | Site | open, after approvals (ROADMAP 6.1, 3.7, 3.12, 9.9) |
| WP9 | `tools/store_poll.py` + CSV | done 2026-10-04 |
| WP10 | Listing template | done 2026-10-04 (`reports/listing-template.md`) |

## 3. Rules every agent follows

- **Never decide alone:** store names, prices, visual identity/icons, permissions with privacy cost, any store upload, any phone or watch test, any site deploy, unreviewed machine translations. Prepare, list as owner decision, stop.
- **Do not stage, commit, stash or reset** unless asked. Git index mixed.
- Simulator passing not device proof. Say so. Do not invent evidence (reviews, downloads, screenshots, revenue).
- Gloss ADR numbers with short parenthetical, never cite bare.
- Behaviour change -> update its doc same session. Durable decision -> ADR in that project's `docs/decisions.md`. Every store publication -> `CHANGELOG.md` entry + What's New block.
- Published site URLs never change. Live paid app id and every shipped setting id never change.
- Read target project's `CLAUDE.md` and `docs/decisions.md` before touching it. Root `CLAUDE.md` "Studio direction" carries three owner directives.

## 4. Starter prompts (paste one per agent)

Each agent gets one work package. Replace nothing; paths real. Fresh context per prompt.

**WP0: owner checklist (agent prepares, owner answers)**
> Read `reports/Free and Pro ladder - START HERE.md`, then `reports/Free and Pro ladder.md` "Owner decisions". Produce a one-screen checklist of OD1–OD8 with the recommended default and deadline for each, plus the dashboard checklist from `research_notes/Free and Pro ladder/garmin_questions.md`. Do not answer for the owner and do not send anything. When the owner has answered, execute WP0 steps 3–4 in `reports/Free and Pro ladder execution plan.md` (retire the day-45 flip rule with a new ADR in `DaysToGo/docs/decisions.md` and `TwoSuns/docs/decisions.md`; update root README/CLAUDE status rows).

**WP2: daring design pass for one face** (name the face: DaysToGo first)
> Invoke the `watch-design-lead` skill. Read section 5a of `reports/Free and Pro ladder execution plan.md` (binding brief), `<Face>/DESIGN.md`, `<Face>/PRODUCT.md`, and `research_notes/Free and Pro ladder/accent_roster.md`. Produce two HTML/SVG round mockups (Free and Pro), screenshot-verified in a real browser at 454 px and the smallest supported size; test every eligible accent on the ring/bar. Draft the design ADR and `DESIGN.md` deltas. Stop at owner look-approval. Write no Monkey C.

**WP4: Days To Go Free (pilot B)**
> Read `reports/Free and Pro ladder execution plan.md` sections 1 and WP4 (including step 0, the settings spike) and WP1. Precondition: owner has answered OD1–OD4 and the WP2 mockups are approved; if not, stop and say so. Invoke `watch-pm` for the spec split and the Pro-headline research. Then build the Free jungle/manifest/resources-free, tier-only settings folders, accent tables, tests on both jungles, packages, `listing-free/`, CHANGELOG. Do not upload; list owner gates.

**WP5 / WP6 / WP7: Two Suns Free, HeroFace Free, HeroSet Free**
> Read the plan's WP<N>, section 1 and WP1. First check its gate in section 2 and the tracker in `reports/Free and Pro ladder - START HERE.md`; if the gate is not passed, stop and report which gate is open. Otherwise follow WP<N> exactly.

**WP3: DayArc pair**
> Read WP3. Precondition: the other DayArc session's work is committed or the owner says go. Resolve ADR-014/ADR-011, run both jungles' compile sweep and tests, run `watch-design-reviewer` on the built version, prepare the listings with the D8 pattern. Owner does look-approval and submission.

**WP8: site**
> Read WP8 and `site/CLAUDE.md`. Add `freeStoreUrl` to `site/src/apps/types.ts`, add a "Free or Pro" section per existing app page, per-tier privacy/support wording. Do not deploy and do not change any slug.

**WP9: measurement**
> Read WP9. Create `tools/store_poll.py` (store API, no browser needed; descriptions are under `appLocalizations[].description`) appending to `research_notes/Free and Pro ladder/poll.csv`. After each Free approval, record the free listing's `compatibleDeviceTypeIds` length versus Pro's. Do not turn download buckets into revenue.

**WP10: listing kit**
> Read WP10. Write `research_notes/Free and Pro ladder/listing_template.md` (Free and Pro description skeletons, sibling URL on line 1, review request, device note, "More from Verden").

**Independent review of any WP**
> Invoke the `watch-design-reviewer` agent for built designs. For plans and docs, review against `reports/Free and Pro ladder execution plan.md` section 1 "Definition of done" and this file's section 3 rules.

## 5. Facts an agent might otherwise re-derive wrongly

- Days To Go, Two Suns both approved 2026-09-28, late afternoon (owner, 2026-10-01); day-45 reviews retired. Every paid app moves to $2.50 tier with next upload (Two Suns showed $2.25 before); no price number on site or in listing text.
- Garmin price tiers: $2.00, then every $0.25 to $10; $2.00 shows $1.99 (US) / 2,49 €; $3.00 shows $2.99 / 3,49 €.
- Garmin keeps 15%, $100 annual merchant fee (paid 2026-09-17; renewal reminder ROADMAP 10.28), $10 payout minimum. Break-even: 59 sales/yr at $2.00, 39 at $3.00.
- Some Garmin developer pages (price-points tabs) did not extract with static fetch: read in browser. Store API works with plain `curl`.
- Never cancel merchant account to demonetize; takes every paid app down.
- Accent ids: Days To Go 0–5 (mint, amber, sky, pink, violet, white) and Two Suns 0–5 (sky, mint, amber, violet, pink, white) shipped; HeroFace 0–2 (sky, cyan, magenta) shipped. Tables in plan's WP1.
- Not established: any revenue, our own attach rate, whether Garmin treats twins as duplicates, whether repricing approved app removes it, HeroSet's accuracy vs native counter.

## 6. Keeping this file true

When WP finishes, update section 2's tracker and any changed section 5 fact, same session. If decision changes, change it in `reports/Free and Pro ladder.md` first, then here.