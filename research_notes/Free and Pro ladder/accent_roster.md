# Accent colour: state today and the family roster

## State today (measured from the repo, 2026-09-28)

| Face | Setting | Values (index → colour) | Where shipped |
|---|---|---|---|
| HeroFace | `Accent` | 0 blue #55AAFF, 1 cyan #00FFFF, 2 magenta #FF55FF | live paid |
| DaysToGo | `Accent` | 0 mint #55FFAA, 1 amber #FFAA00, 2 sky #55AAFF, 3 pink #FF55AA, 4 violet #AA55FF, 5 white #FFFFFF | live paid |
| TwoSuns | `Accent` | 0 sky #55AAFF, 1 mint #55FFAA, 2 autumn (=amber) #FFAA00, 3 violet #AA55FF, 4 pink #FF55AA, 5 winter (=white) #FFFFFF | live paid |
| DayArc | `Accent` | 0 Auto, 1 cyan, 2 amber, 3 rose, 4 green, 5 blue, 6 purple (uncommitted working tree; code cites ADR-014, absent from `decisions.md`) | not submitted |
| HeroSet | none (app; roles: gold = kept, blue = effort, green = done) | | live paid |

Requirement "every face has a customizable accent" **already met by four of five products**, unmet by HeroSet.
Work: guarantee it in *free* tier, widen HeroFace's three options, unify names, prove it survives phone sync.

Rules already binding (shipped ADRs):

- **Append-only.** Property ids, existing value indices never change after publication, or saved settings change meaning.
- Every colour 64-colour-safe (each channel 00/55/AA/FF) and ≥3:1 against black; dimmed form (each FF → AA) must also clear 3:1 and
  must not equal muted grey #AAAAAA (TwoSuns ADR-017: winter collided with MUTED).
- Colour must not depend on value it decorates. TwoSuns learned amber default read normal Body Battery as "low".
  Amber/orange/coral/red never default on Body Battery, stress, sleep faces.
- Lists only (no free colour picker): settings-not-saving is 8.4% of low-star reviews.

## Proposed family roster (12), all checked

| Name | Hex | Contrast on black | Dimmed (FF→AA) | Dim contrast | Tier |
|---|---|---|---|---|---|
| Sky | #55AAFF | 8.6 | #55AAAA | 7.7 | Free |
| Mint | #55FFAA | 16.3 | #55AAAA | 7.7 | Free |
| Amber | #FFAA00 | 11.0 | #AAAA00 | 8.5 | Free |
| Pink | #FF55AA | 7.1 | #AA55AA | 4.6 | Free |
| Violet | #AA55FF | 5.5 | #AA55AA | 4.6 | Free |
| White | #FFFFFF | 21.0 | #AAAAAA | 9.0 | Free, **dim collides with muted grey**: nudge one channel (TwoSuns rule → #55AAAA-style variant per face) |
| Cyan | #00FFFF | 16.8 | #00AAAA | 7.3 | Pro |
| Lime | #55FF55 | 15.8 | #55AA55 | 7.3 | Pro |
| Yellow | #FFFF55 | 19.7 | #AAAA55 | 8.6 | Pro |
| Orange | #FF5500 | 6.6 | #AA5500 | 4.0 | Pro |
| Coral | #FF5555 | 6.7 | #AA5555 | 4.1 | Pro |
| Magenta | #FF55FF | 8.0 | #AA55AA | 4.6 | Pro |

Rejected: Blue #0055FF (3.7, dim 2.9 fails), Red #FF0000 (dim 2.7 fails; red = HeroFace's attention role, verdict colour on
health metrics).

Free six equal six already shipped in DaysToGo and TwoSuns (Autumn = Amber, Winter = White), so free tier needs no new
colour work there. HeroFace's shipped set (blue, cyan, magenta) maps to Sky, Cyan (#00FFFF; DayArc uses #55FFFF, both safe), Magenta.

## Per-face eligibility: the roster is a candidate list, each face admits a subset

Contrast on black not only test. Each face already spends colours on roles; accent colliding with one erases a distinction face relies on. Measured against each face's own palette (`HeroFacePalette.mc`, `TwoSunsPalette.mc`, `DaysToGoPalette.mc`):

| Face | Colours it reserves | Accents it cannot admit | Its own accent rule |
|---|---|---|---|
| HeroFace | Gold #FFAA00 = "what you keep"; done green #00FF00; alert red #FF0000; white = the time; track #555555. "Blue vs gold (not red vs green) carries the main distinction" (`PRODUCT.md`) | Amber and Yellow (gold), Lime and Mint (green), Orange and Coral (alert red), White | "None is gold or green or white; each clears 3:1 against TRACK #555555" (code comment) |
| TwoSuns | Golden-hour arc #FF5500; night track and curve fill #5555AA; twilight #AAAAFF; muted #AAAAAA | Orange (identical to golden hour) and Coral (1.02:1 against it) | Dimmed accent ≥3:1 on black, never equal to muted (ADR-017); amber/orange/coral/red never default |
| DaysToGo | Track #555555, muted #AAAAAA | none reserved | Ring accent drawn over TRACK |

Contrast of each roster colour against #555555: Sky 3.05, Mint 5.78, Amber 3.91, Pink 2.53, Violet 1.94, White 7.46, Cyan 5.95, Lime 5.62,
Yellow 6.99, Orange 2.33, Coral 2.37, Magenta 2.84.

**Findings from this check (measured by arithmetic, not by rendering):**

1. **HeroFace's shipped Magenta (#FF55FF) is 2.84:1 against its TRACK**, below the 3:1 its own code comment promises; HeroFace has no accent
   unit test (DaysToGo and TwoSuns do). Only Sky (3.05) and Cyan (5.95) pass. Either rule or accent list wrong; design pass decides
   (relax rule in an ADR, lighten/re-cut track, or drop Magenta).
2. **Only two of twelve roster colours pass HeroFace's own rule.** HeroFace's accent list cannot simply grow to twelve. Provisional plan:
   keep its three shipped ids (Sky, Cyan, Magenta) as Free list; admit more only if daring pass re-cuts role palette or track.
   Colour then not a Pro differentiator for HeroFace; fine.
3. **DaysToGo's shipped Pink (2.53) and Violet (1.94) low against its TRACK**, TwoSuns's Sky (2.63), Pink (2.18), Violet (1.67) low against
   its night track. Text and words carry state, so not broken, but mockup pass must look at each accent on the ring; rule for
   each face must be written down.
4. **TwoSuns cannot take Orange or Coral** (golden hour). Its Pro list is 10 colours, not 12.

Provisional eligible sets (design-lead confirms in WP2; Pro owns id table):

| Face | Free list | Pro list |
|---|---|---|
| DaysToGo | Mint, Amber, Sky, Pink, Violet, White (shipped ids 0–5) | + Cyan, Lime, Yellow, Orange, Coral, Magenta (ids 6–11), each checked on the ring |
| TwoSuns | Sky, Mint, Amber, Violet, Pink, White (shipped ids 0–5) | + Cyan, Lime, Yellow, Magenta (ids 6–9) |
| HeroFace | Sky, Cyan, Magenta (shipped ids 0–2) | Same, plus only what design pass admits |
| DayArc | Auto + family six | Auto + eligible set (WP3) |

**Index rule (one table per face, in Pro build):** Pro build = source of truth for value ids. Existing ids keep their
colour; new colours appended. Free build's settings list shows *subset* of same ids, so one id = one colour in both
listings. Per-face tables in plan WP1.

Check every roster change with unit test in each project: `ACCENTS` entries 64-safe, ≥3:1 on black, dimmed ≥3:1, not equal to MUTED, not equal
to any reserved role colour of that face, and (where face has a rule) clear face's own track contrast.