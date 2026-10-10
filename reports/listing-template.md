# Listing template (WP10)

Every Verden store listing: how written, kept, per Free and Pro twin. Written 2026-10-04 from existing drafts (DayArc, Days To Go, Two Suns, HeroFace, HeroSet); rules from [`Free and Pro ladder execution plan.md`](Free%20and%20Pro%20ladder%20execution%20plan.md) WP10, each project's `docs/release-contract.md`, owner's listing-text rules of 2026-10-04 (ROADMAP 10.23). Release contract loses to nothing here: disagree -> contract wins, this file wrong.

Store form: https://apps.garmin.com/developer/upload. Two steps: attach `.iq`, then details. Compatible Devices read from package, not chosen.

## 1. Three files per listing folder

Listing folder: `<Project>/listing/` (live or only paid listing), `<Project>/listing-free/` (Free twin) or, for DayArc, `listing/` (DayArc) and `listing-pro/` (DayArc Pro). Each holds:

| File | Holds | Never holds |
|---|---|---|
| `paste.md` | **Only what is pasted or uploaded**, in upload form's field order: field heading, then block to paste (one fenced block per field) or file name to upload. Top line `Fill every <...> before pasting.` only when block still has placeholder. | Anything else: intro paragraphs, "OWNER" notes, rationale, status, history, size caps, ADR or file links, device names in image captions. Go in `NOTES.md` / `meta.yaml` / `screenshots.md` (table below). |
| `meta.yaml` | **Machine data**: app, folder, tier, app id, store URLs, live version and date, next version and status (`drafted / prepared / uploaded / in-review / live`), package file, product count, export date, price, limits, assets (`screens`: one `{file, caption, device}` entry per image, upload order), site URLs, `owner_approvals` (list of strings: what only owner may settle before `paste.md` used), `open_items` (ROADMAP ids). Dates ISO, `null` = not yet. | Pasted copy, prose rationale, device sentences (`held_back_text` retired). |
| `NOTES.md` | **Why**: reason per answer, claim check vs `release-contract.md`, owner decisions, previous What's New blocks (newest first), language and image notes, post-approval steps, dated section for anything removed from `paste.md`. | Anything owner must paste. |

Beside them: `screenshots.md` (how images made), `screens/`, `src/` (generators), rendered PNGs.

### Where a note removed from `paste.md` goes

| It was | It goes to |
|---|---|
| Approval only owner can give (name or title, image looks, price tier, placeholder URL, unverified claim, translation) | `meta.yaml` `owner_approvals` |
| How or why, history, form instructions ("the form reads the version from the package", "Subcategory: whatever the Category offers") | `NOTES.md`, under dated heading |
| Image captions, devices, sizes, upload conditions ("only with the package that adds ...") | `meta.yaml` `assets.screens` (caption, device) and `screenshots.md`; upload condition also as `owner_approvals` item |
| Superseded wording (old What's New or description line) | `NOTES.md`, under dated heading |

### Rules for `paste.md`

- Block order follows form. Fields, in order: Title, Description (one box per language), App Version, What's New, Hero Image, Category, Subcategory, Does your app collect user data?, privacy-policy URL (only if Yes), ANT+ profiles, regional limits, Cover Image, Screen Images, Device icons, Preview Video (none), Email Address, Source Code URL (blank), Review Notification (Yes), App Migration, Monetization, **Additional Hardware Requirements (Optional)**. Limits (50, 4000, 4000, 20; hero 1440x720 under 2048 KB; cover 500x500 under 300 KB; screens under 150 KB each; icons 128x128, 64 Color and 24 bit) live in `meta.yaml`; headings carry no cap.
- **Image sections list file names only**, numbered upload order, no captions. Instinct (black-and-white) image not marked.
- Short non-pasted instructions stay only where form needs them: "Leave blank.", "No", "Yes", "None.", "Whatever the Category choice offers."
- **Placeholders** written `<WHAT>` (e.g. `<PRO STORE URL>`); who fills it and when -> `owner_approvals`. Reader checks each block for `<` before pasting.
- Nothing in `paste.md` marked OWNER; agent never fills what owner must decide.
- Plain text: store shows `**` and `>` literally, keeps every line break, so no hard-wrap inside description block. Last description line = support URL (form has no support field): `Support and answers: https://verden.watch/<slug>/support/`.
- No price number in any description or What's New (price tier set in form; Monetization block may name tier).
- **No refund or return wording in any listing text** (owner decision, 2026-10-04): no refund line in paid description, no "return window", nothing on refunds in What's New.
- **No language name, no language count in any listing text** (owner decision, 2026-10-04). Where listing has language line, reads exactly: `Multi-language support: it follows your watch's language.` Language facts (which, how many) stay in docs.
- **No Garmin watch model name in any description or What's New** (owner decision, 2026-10-04): no Forerunner, Instinct, Venu, fenix, epix, Descent, MARQ, vivoactive, Approach, D2 etc. Write by screen type or feature ("black-and-white screens", "touchscreen watches", "watches with Connect IQ 4.0 or later"). Store's device tab, taken from build, is device claim.
- Languages: English first. Each further language separate pick, **Add**, Title + Description, only after first approval. Machine-drafted text needs owner's OK and native read before store copy (lives in `NOTES.md`, not `paste.md`).

## 2. The field that carries the website link

**Additional Hardware Requirements (Optional)** used for site link (owner's choice, 2026-10-02, after seeing other Connect IQ apps do it). Store API names field `hardwareProductUrl`; HeroSet's live value is bare URL, so **paste URL only, no sentence** (Garmin research 2026-10-04; earlier "No additional hardware needed. Help, privacy and more apps: ..." sentence retired). Garmin does not document this use. Block in `paste.md`:

```text
https://verden.watch/<slug>/
```

- One URL, app's hub page; page carries support, privacy, other apps. Free listings use same hub page until site has Free pages (WP8). DayArc keeps two slugs: `day-arc` and `day-arc-pro`.
- Every new listing draft carries this block. Last block of `paste.md`.
- Unverified: whether live listing's field editable without uploading new version (note answer in `research_notes/Free and Pro ladder/garmin_rules.md`).

## 3. Description skeletons

### Free

1. **Line 1:** `Get <Name> Pro: <PRO STORE URL>` (sibling's store URL first, so list views show it; owner may move it below promise sentence, noting it costs list-view preview).
2. One-sentence promise, plain. Nothing implied.
3. What this version has: concrete (fields, accent choices, always-on), described as what face *is*, not tap-by-tap steps.
4. "<Name> Pro adds": same words as Pro listing. No sentence on which watches Pro can or cannot be bought for.
5. One review sentence (owner may cut): `If this face works for you, a rating in the store helps other people find it.`
6. Permissions in plain words; "Nothing leaves your watch." only while still true.
7. **More from Verden:** up to four store URLs of **live free** siblings, one per line. None live: leave block out. Placeholder line for non-live sibling deleted, not pasted.
8. Last line: support URL.

### Pro

1. **Line 1:** `Also available: <Name>, a lighter version: <STORE URL>`. **Pro listing never uses word "free"** (paid; store review guideline 4d; each release contract repeats). So not "Try free first", not "the free version", not "no free tier".
2. Pro's promise, what it adds (same words as Free listing's "Pro adds"), no device list, no watch count.
3. Review sentence (optional), permissions in plain words.
4. More from Verden (free siblings only), support line.

### Both

- Claims checked against project's `docs/release-contract.md`; check table lives in `NOTES.md`. Never: battery figures, always-on ghosting claims, MIP contrast, watch count, watch model name, language list or count, refund or return wording, download / rating / review numbers, accuracy claims, rivals by name, claim about feature build does not ship, medical or advice wording.
- Never describe what only other tier ships, except Free listing's "Pro adds" and sibling line.
- Cumulative What's New for updates; new app's first What's New short line or blank (each project's NOTES says which).
- Support route `hello@verden.watch`.

## 4. Device reach

**Listing text never names watch models, no device sentence** (owner, 2026-10-04). Store's device tab, read from each build's package, is claim; `meta.yaml` `held_back_text` retired. Facts stay in docs: paid listing sold only on watches Garmin's paid-app list covers (Instinct 2, 2S, 2X and Descent G1 not on it; Instinct E 40 and 45 mm and Instinct 3 Solar are; research 2026-10-04, ROADMAP 10.15); each project's `docs/release-contract.md` "Paid vs free reach" and `docs/compatibility.md` keep measured counts. Black-and-white (Instinct-family) image goes up only with package that adds those products; that is `owner_approvals` item, not text in `paste.md`.

## 5. Per-listing checklist (an agent drafts, the owner pastes)

1. Both twin listings exist in same shape: `paste.md`, `meta.yaml`, `NOTES.md`, `screenshots.md`.
2. Description line 1 = sibling URL; Hardware block carries bare site URL; support line last; no refund line.
3. Search Pro `paste.md` for "free" (must not appear).
4. Search every block for `<`; each = owner-filled placeholder named in `meta.yaml` `owner_approvals`, file's top line says fill them.
5. Grep every `paste.md` for four rules: no refund or return wording, no language names or counts, no watch model names, no "OWNER", ADR link or size-cap note.
6. `meta.yaml`: `next.version`, `package.file`, `package.products`, `package.exported`, `owner_approvals`, `assets.screens` (captions, devices), `open_items`; must parse (`ruby -ryaml -e 'YAML.load_file(ARGV[0])' meta.yaml`).
7. `NOTES.md`: claim table, owner-decision table, previous What's New blocks (old block moves here when `paste.md` takes new), dated section for what left `paste.md`.
8. `CHANGELOG.md` entry per store publication (version, upload date, user-facing changes, ADRs).
9. Never invent evidence: no reviews, downloads, screenshots or numbers.

## 6. Where each file is today

| Project | Folders |
|---|---|
| HeroSet | `listing/` (paid; Free not built, gated on accuracy proof) |
| HeroFace | `listing/` (Pro, live paid id), `listing-free/` |
| Days To Go | `listing/` (Pro, live paid id), `listing-free/` |
| Two Suns | `listing/` (Pro, live paid id), `listing-free/` |
| DayArc | `listing/` (DayArc), `listing-pro/` (DayArc Pro) |