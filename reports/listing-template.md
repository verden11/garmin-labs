# Listing template (WP10)

How every Verden store listing is written and kept, for each Free and each Pro twin. Written 2026-10-04 from the drafts that exist (DayArc, Days To Go, Two Suns, HeroFace, HeroSet); the rules come from [`Free and Pro ladder execution plan.md`](Free%20and%20Pro%20ladder%20execution%20plan.md) WP10, each project's `docs/release-contract.md` and the owner's listing-text rules of 2026-10-04 (ROADMAP 10.23). A project's release contract loses to nothing here: if they disagree, the contract wins and this file is wrong.

The store form: https://apps.garmin.com/developer/upload. Two steps: attach the `.iq`, then the details. Compatible Devices is read from the package, not chosen.

## 1. Three files per listing folder

A listing folder is `<Project>/listing/` (the live or only paid listing), `<Project>/listing-free/` (a Free twin) or, for DayArc, `listing/` (DayArc) and `listing-pro/` (DayArc Pro). Each holds:

| File | Holds | Never holds |
|---|---|---|
| `paste.md` | **Only what is pasted or uploaded**, in the upload form's field order: the field heading, then the block to paste (one fenced block per field) or the file name to upload. A top line `Fill every <...> before pasting.` only when a block still has a placeholder. | Anything else: intro paragraphs, "OWNER" notes, rationale, status, history, size caps, ADR or file links, device names in image captions. Those go in `NOTES.md` / `meta.yaml` / `screenshots.md` (table below). |
| `meta.yaml` | **Machine data**: app, folder, tier, app id, store URLs, live version and date, next version and status (`drafted / prepared / uploaded / in-review / live`), package file, product count, export date, price, limits, assets (`screens`: one `{file, caption, device}` entry per image, in upload order), site URLs, `owner_approvals` (list of strings: what only the owner may settle before `paste.md` is used), `open_items` (ROADMAP ids). Dates are ISO, `null` = not yet. | Copy that is pasted, prose rationale, device sentences (`held_back_text` is retired). |
| `NOTES.md` | **Why**: the reason for each answer, the claim check against `release-contract.md`, owner decisions, the previous What's New blocks (newest first), language and image notes, what to do after approval, and a dated section for anything removed from `paste.md`. | Anything the owner has to paste. |

Beside them: `screenshots.md` (how the images are made), `screens/`, `src/` (generators), the rendered PNGs.

### Where a note removed from `paste.md` goes

| It was | It goes to |
|---|---|
| An approval only the owner can give (name or title, image looks, price tier, a placeholder URL, an unverified claim, a translation) | `meta.yaml` `owner_approvals` |
| How or why, history, form instructions ("the form reads the version from the package", "Subcategory: whatever the Category offers") | `NOTES.md`, under a dated heading |
| Image captions, devices, sizes, upload conditions ("only with the package that adds ...") | `meta.yaml` `assets.screens` (caption, device) and `screenshots.md`; an upload condition also as an `owner_approvals` item |
| A superseded wording (an old What's New or description line) | `NOTES.md`, under the dated heading |

### Rules for `paste.md`

- Block order follows the form. The fields, in order: Title, Description (one box per language), App Version, What's New, Hero Image, Category, Subcategory, Does your app collect user data?, privacy-policy URL (only if Yes), ANT+ profiles, regional limits, Cover Image, Screen Images, Device icons, Preview Video (none), Email Address, Source Code URL (blank), Review Notification (Yes), App Migration, Monetization, **Additional Hardware Requirements (Optional)**. Limits (50, 4000, 4000, 20; hero 1440x720 under 2048 KB; cover 500x500 under 300 KB; screens under 150 KB each; icons 128x128, 64 Color and 24 bit) live in `meta.yaml` and the headings carry no cap.
- **Image sections list file names only**, numbered in upload order, no captions. The Instinct (black-and-white) image is not marked.
- Short non-pasted instructions stay only where the form needs them: "Leave blank.", "No", "Yes", "None.", "Whatever the Category choice offers."
- **Placeholders** are written `<WHAT>` (for example `<PRO STORE URL>`); who fills it in and when goes in `owner_approvals`. A reader checks each block for a `<` before pasting.
- Nothing in `paste.md` is marked OWNER, and an agent never fills in what the owner must decide.
- Plain text: the store shows `**` and `>` literally and keeps every line break, so do not hard-wrap inside a description block. The last description line is the support URL (the form has no support field): `Support and answers: https://verden.watch/<slug>/support/`.
- No price number in any description or What's New (the price tier is set in the form; the Monetization block may name the tier).
- **No refund or return wording in any listing text** (owner decision, 2026-10-04): no refund line in a paid description, no "return window", nothing on refunds in What's New.
- **No language name and no language count in any listing text** (owner decision, 2026-10-04). Where a listing has a language line it reads exactly: `Multi-language support: it follows your watch's language.` The language facts (which languages, how many) stay in docs.
- **No Garmin watch model name in any description or What's New** (owner decision, 2026-10-04): no Forerunner, Instinct, Venu, fenix, epix, Descent, MARQ, vivoactive, Approach, D2 and so on. Write by screen type or feature ("black-and-white screens", "touchscreen watches", "watches with Connect IQ 4.0 or later"). The store's device tab, taken from the build, is the device claim.
- Languages: English first. Each further language is a separate pick, **Add**, Title + Description, and only after the first approval. Machine-drafted text needs the owner's OK and a native read before it is store copy (this lives in `NOTES.md`, not `paste.md`).

## 2. The field that carries the website link

**Additional Hardware Requirements (Optional)** is used for the site link (owner's choice, 2026-10-02, after seeing other Connect IQ apps do it). The store API names the field `hardwareProductUrl` and HeroSet's live value is the bare URL, so **paste the URL only, no sentence** (Garmin research 2026-10-04; the earlier "No additional hardware needed. Help, privacy and more apps: ..." sentence is retired). Garmin does not document this use. The block in `paste.md`:

```text
https://verden.watch/<slug>/
```

- One URL, the app's hub page; the page carries support, privacy and the other apps. Free listings use the same hub page until the site has Free pages (WP8). DayArc keeps two slugs: `day-arc` and `day-arc-pro`.
- Every new listing draft carries this block. It is the last block of `paste.md`.
- Unverified: whether a live listing's field can be edited without uploading a new version (note the answer in `research_notes/Free and Pro ladder/garmin_rules.md`).

## 3. Description skeletons

### Free

1. **Line 1:** `Get <Name> Pro: <PRO STORE URL>` (the sibling's store URL first, so list views show it; the owner may move it below the promise sentence, noting that it costs the list-view preview).
2. The one-sentence promise, plainly. Nothing implied.
3. What this version has: concrete (fields, accent choices, always-on), described as what the face *is*, not tap-by-tap steps.
4. "<Name> Pro adds": the same words as the Pro listing. No sentence about which watches Pro can or cannot be bought for.
5. One review sentence (the owner may cut it): `If this face works for you, a rating in the store helps other people find it.`
6. Permissions in plain words; "Nothing leaves your watch." only while it is still true.
7. **More from Verden:** up to four store URLs of **live free** siblings, one per line. None live: leave the block out. A placeholder line for a sibling that is not live is deleted, not pasted.
8. Last line: the support URL.

### Pro

1. **Line 1:** `Also available: <Name>, a lighter version: <STORE URL>`. **The Pro listing never uses the word "free"** (it is paid; store review guideline 4d; each release contract repeats it). So not "Try free first", not "the free version", not "no free tier".
2. Pro's promise, what it adds (the same words as the Free listing's "Pro adds"), no device list, no watch count.
3. Review sentence (optional), permissions in plain words.
4. More from Verden (free siblings only), support line.

### Both

- Claims are checked against the project's `docs/release-contract.md`; the check table lives in `NOTES.md`. Never: battery figures, always-on ghosting claims, MIP contrast, a watch count, a watch model name, a language list or count, refund or return wording, download / rating / review numbers, accuracy claims, rivals by name, a claim about a feature the build does not ship, medical or advice wording.
- Never describe what only the other tier ships, except in the Free listing's "Pro adds" and the sibling line.
- Cumulative What's New for updates; a new app's first What's New is a short line or blank (each project's NOTES says which).
- Support route `hello@verden.watch`.

## 4. Device reach

**Listing text never names watch models, and carries no device sentence** (owner, 2026-10-04). The store's device tab, read from each build's package, is the claim; `meta.yaml` `held_back_text` is retired. The facts stay in docs: a paid listing is sold only on watches Garmin's paid-app list covers (the Instinct 2, 2S, 2X and Descent G1 are not on it; Instinct E 40 and 45 mm and Instinct 3 Solar are; research 2026-10-04, ROADMAP 10.15), and each project's `docs/release-contract.md` "Paid vs free reach" and `docs/compatibility.md` keep the measured counts. A black-and-white (Instinct-family) image goes up only with the package that adds those products; that is an `owner_approvals` item, not text in `paste.md`.

## 5. Per-listing checklist (an agent drafts, the owner pastes)

1. Both listings of a twin exist in the same shape: `paste.md`, `meta.yaml`, `NOTES.md`, `screenshots.md`.
2. Line 1 of the description is the sibling URL; the Hardware block carries the bare site URL; the support line is last; no refund line.
3. Search the Pro `paste.md` for "free" (it must not appear).
4. Search every block for `<`; each one is an owner-filled placeholder named in `meta.yaml` `owner_approvals`, and the file's top line says to fill them.
5. Grep every `paste.md` for the four rules: no refund or return wording, no language names or counts, no watch model names, no "OWNER", ADR link or size-cap note.
6. `meta.yaml`: `next.version`, `package.file`, `package.products`, `package.exported`, `owner_approvals`, `assets.screens` (captions, devices), `open_items`; it must parse (`ruby -ryaml -e 'YAML.load_file(ARGV[0])' meta.yaml`).
7. `NOTES.md`: the claim table, the owner-decision table, previous What's New blocks (the old block moves here when `paste.md` takes the new one), the dated section for what left `paste.md`.
8. `CHANGELOG.md` entry per store publication (version, upload date, user-facing changes, ADRs).
9. Never invent evidence: no reviews, downloads, screenshots or numbers.

## 6. Where each file is today

| Project | Folders |
|---|---|
| HeroSet | `listing/` (paid; Free not built, gated on the accuracy proof) |
| HeroFace | `listing/` (Pro, live paid id), `listing-free/` |
| Days To Go | `listing/` (Pro, live paid id), `listing-free/` |
| Two Suns | `listing/` (Pro, live paid id), `listing-free/` |
| DayArc | `listing/` (DayArc), `listing-pro/` (DayArc Pro) |
