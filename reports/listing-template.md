# Listing template (WP10)

How every Verden store listing is written and kept, for each Free and each Pro twin. Written 2026-10-04 from the drafts that exist (DayArc, Days To Go, Two Suns, HeroFace, HeroSet); the rules come from [`Free and Pro ladder execution plan.md`](Free%20and%20Pro%20ladder%20execution%20plan.md) WP10 and each project's `docs/release-contract.md`. A project's release contract loses to nothing here: if they disagree, the contract wins and this file is wrong.

The store form: https://apps.garmin.com/developer/upload. Two steps: attach the `.iq`, then the details. Compatible Devices is read from the package, not chosen.

## 1. Three files per listing folder

A listing folder is `<Project>/listing/` (the live or only paid listing), `<Project>/listing-free/` (a Free twin) or, for DayArc, `listing/` (DayArc) and `listing-pro/` (DayArc Pro). Each holds:

| File | Holds | Never holds |
|---|---|---|
| `paste.md` | **Only the blocks the owner copies into the form**, in the upload form's field order, one fenced block per field. A one-paragraph header (form URL, "one block = one field", pointers to the other two files). | History, rationale, status, version tables, open questions (those go in `NOTES.md` / `meta.yaml`). Short instructions *between* blocks are allowed when a field is a radio or a file (for example "No", or the image path). |
| `meta.yaml` | **Machine data**: app, folder, tier, app id, store URLs, live version and date, next version and status (`drafted / prepared / uploaded / in-review / live`), package file, product count, export date, price, limits, assets, site URLs, `open_items` (ROADMAP ids), `held_back_text` (see 3 and 4). Dates are ISO, `null` = not yet. | Copy that is pasted, prose rationale. |
| `NOTES.md` | **Why**: the reason for each answer, the claim check against `release-contract.md`, owner decisions and their placeholders, the previous What's New blocks (newest first), language and image notes, what to do after approval. | Anything the owner has to paste. |

Beside them: `screenshots.md` (how the images are made), `screens/`, `src/` (generators), the rendered PNGs.

### Rules for `paste.md`

- Block order follows the form. The fields, in order: Title (50), Description (4000, one box per language), Version / App Version (20), What's New (4000), Hero Image (optional, 1440x720, under 2048 KB), Category, Subcategory, Does your app collect user data?, privacy-policy URL (only if Yes), ANT+ profiles, regional limits, Cover Image (500x500, under 300 KB), Screen Images (under 150 KB each, in upload order), Device icons (optional, 128x128: 64 Color, 24 bit), Preview Video (none), Email Address, Source Code URL (blank), Review Notification (Yes), App Migration, Monetization, **Additional Hardware Requirements (Optional)**. Limits live in `meta.yaml`.
- **Placeholders** are written `<WHAT: who fills it in and when>`. The header of the file says: "Do not paste a block while a `<` placeholder remains in it." A reader checks each block for a `<` before pasting.
- **OWNER marking.** A block, or a decision above a block, that only the owner may settle (name, title, price tier, image look, translations, an unverified claim) is introduced by a line starting **OWNER**. The header says "Do not paste a block marked OWNER until it is decided". Nothing marked OWNER is ever filled in by an agent.
- Plain text: the store shows `**` and `>` literally and keeps every line break, so do not hard-wrap to the file width inside a description block beyond what the form should show. The last description line is the support URL (the form has no support field): `Support and answers: https://verden.watch/<slug>/support/`.
- No price number in any listing text (the price is set in the dashboard).
- Languages: English first. Each further language is a separate pick, **Add**, Title + Description, and only after the first approval. Machine-drafted text needs the owner's OK and a native read before it is store copy.

## 2. The field that carries the website link

**Additional Hardware Requirements (Optional)** is a free-text field. The owner's choice (2026-10-02, after seeing other Connect IQ apps do it) is to use it for the site link. It is not a documented Garmin rule, so the text must stay true: it says no extra hardware is needed. Paste:

```text
No additional hardware needed. Help, privacy and more apps: https://verden.watch/<slug>/
```

- One URL, the app's hub page; the page carries support, privacy and the other apps. Free listings use the same hub page until the site has Free pages (WP8). DayArc keeps two slugs: `day-arc` and `day-arc-pro`.
- Every new listing draft carries this block. It is the last block of `paste.md`.
- Unverified: whether a live listing's field can be edited without uploading a new version (note the answer in `research_notes/Free and Pro ladder/garmin_rules.md`).

## 3. Description skeletons

### Free

1. **Line 1:** `Get <Name> Pro: <PRO STORE URL: owner fills in once the Pro listing is live>` (the sibling's store URL first, so list views show it; the owner may move it below the promise sentence, noting that it costs the list-view preview).
2. The one-sentence promise, plainly. Nothing implied.
3. What this version has: concrete (fields, accent choices, always-on), described as what the face *is*, not tap-by-tap steps.
4. "<Name> Pro adds": the same words as the Pro listing; one line about devices Pro cannot be bought on goes in the held-back device sentence (below), not in the description.
5. One review sentence (the owner may cut it): `If this face works for you, a rating in the store helps other people find it.`
6. Permissions in plain words; "Nothing leaves your watch." only while it is still true.
7. **More from Verden:** up to four store URLs of **live free** siblings, one per line. None live: leave the block out. A placeholder line for a sibling that is not live is deleted, not pasted.
8. Last line: the support URL.

### Pro

1. **Line 1:** `Also available: <Name>, a lighter version: <STORE URL: owner fills in once that listing is live>`. **The Pro listing never uses the word "free"** (it is paid; store review guideline 4d; each release contract repeats it). So not "Try free first", not "the free version", not "no free tier".
2. Pro's promise, what it adds (the same words as the Free listing's "Pro adds"), no device list, no watch count.
3. Review sentence (optional), permissions in plain words, More from Verden (free siblings only), support line.

### Both

- Claims are checked against the project's `docs/release-contract.md`; the check table lives in `NOTES.md`. Never: battery figures, always-on ghosting claims, MIP contrast, a watch count, download / rating / review numbers, accuracy claims, rivals by name, a claim about a feature the build does not ship, medical or advice wording.
- Never describe what only the other tier ships, except in the Free listing's "Pro adds" and the sibling line.
- Cumulative What's New for updates; a new app's first What's New is a short line or blank (each project's NOTES says which).
- Support route `hello@verden.watch`.

### Device sentence (held back, in `meta.yaml`)

Not a form field, so never a block in `paste.md` and never inside the description. It lives in `meta.yaml` `held_back_text`. Add it to the description only after the real Compatible Devices lists of both listings are visible in the store form, with no watch name and no count:

- Free: `<Name> Pro is sold only on watches Garmin lists for paid apps; this version can also be installed on some watches Pro cannot be bought for.`
- Pro: `Pro is sold only on watches Garmin lists for paid apps; <Name>, the lighter version, can also be installed on some watches Pro cannot be bought for.` (no "free")

## 4. Instinct and other device-reach text

Wording about a device family (the Instinct family and similar) stays **out of the live-listing text** until the upload that adds it is approved and the store actually lists those watches. The sentence is kept in `meta.yaml` under `held_back_text` (each item says where it goes), so adding it later is a paste. The package may already contain those products; the claim waits for the store's list.

## 5. Per-listing checklist (an agent drafts, the owner pastes)

1. Both listings of a twin exist in the same shape: `paste.md`, `meta.yaml`, `NOTES.md`, `screenshots.md`.
2. Line 1 of the description is the sibling URL; the Hardware block carries the site link; the support line is last.
3. Search the Pro `paste.md` for "free" (only the instruction text outside the blocks may contain it).
4. Search every block for `<`; each one is an owner-filled placeholder named in `NOTES.md`.
5. `meta.yaml`: `next.version`, `package.file`, `package.products`, `package.exported`, `held_back_text`, `open_items`.
6. `NOTES.md`: the claim table, the owner-decision table, previous What's New blocks (the old block moves here when `paste.md` takes the new one).
7. `CHANGELOG.md` entry per store publication (version, upload date, user-facing changes, ADRs).
8. Never invent evidence: no reviews, downloads, screenshots or numbers.

## 6. Where each file is today

| Project | Folders |
|---|---|
| HeroSet | `listing/` (paid; Free not built, gated on the accuracy proof) |
| HeroFace | `listing/` (Pro, live paid id), `listing-free/` |
| Days To Go | `listing/` (Pro, live paid id), `listing-free/` |
| Two Suns | `listing/` (Pro, live paid id), `listing-free/` |
| DayArc | `listing/` (DayArc), `listing-pro/` (DayArc Pro) |
