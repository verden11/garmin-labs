# Monorepo migration plan — Verden

Status: 2026-09-20. **DONE — steps A-E complete and verified.** Remote (F) skipped.

## Outcome

`~/dev/garmin/` is now one git repo, 24 commits, branch `main`, no remote.
Working files never moved; only `.git` directories changed.

History was squashed and rewritten before import (user request):
HeroSet 24 -> 9 milestone commits, heroFace 2 -> 1, verden-site 9 untouched
(already conventional commits). Method: `git commit-tree` against the
**original tree objects**, so every milestone tree is byte-identical to real
history by construction — no rebase, no conflict resolution.

Proof run twice (scratch, then against the `.git` backups): all 225 tracked
files identical by mode + blob SHA across all three prefixes; all 9 HeroSet
milestone trees are original tree objects and reachable from HEAD;
verden-site's `f028649` is still an ancestor. Working tree matches HEAD with
zero diff. `.gitignore` rules verified still active from subdirectories,
including the signing-key exclusions.

`backup/pre-rewrite` dropped as agreed — content was a strict subset of main.

Originals preserved at `.migration-backup-2026-09-20/` (git-ignored via
`.git/info/exclude`) and in the unarchived GitHub repos. Nothing force-pushed.

### Still yours
Y4 create `verden11/verden` · F `git remote add` + push · Y6 Netlify base
directory `verden-site` + repoint · Y7 verify deploy · Y8 archive old repos
**after** Y7 · Y9 delete `.migration-backup-2026-09-20/`.

Netlify is untouched and still building from `watches-site`. Live site
unaffected.

---

### Original plan below (kept for the record)


**Update 2026-09-20:** Y1+Y2 done, all three repos clean (HeroSet 24, heroFace 2,
verden-site 9 commits). Netlify question settled: **option 1 — accept that Netlify
clones the whole repo.** No secrets are tracked (signing key lives outside the repo);
exposure is Monkey C source to the build bot on a private repo. GitHub repo does not
exist yet, so **step F and Y4–Y8 are deferred** and this run is local-only.

Merge `HeroSet`, `heroFace`, `verden-site` into one git repo with full history.
`device-test/` stays as untracked scratch.

---

## 0. What verification found (this changed the plan twice)

| Finding | Source | Consequence |
|---|---|---|
| **heroFace has 1 commit; its entire real codebase (42 files) is staged but uncommitted** | `git -C heroFace status` | `subtree add` imports **committed history only**. Migrating now would import a scaffold and leave all real HeroFace work outside git. **Hard blocker.** |
| **HeroSet has 57 staged-uncommitted files** (complication publisher, sync, 15 locale files, ADRs) | `git -C HeroSet status` | Same blocker. |
| **~25 cross-repo `../X` doc references** exist between the three repos | grep | Any layout that changes directory depth breaks all of them. Drove the layout change below. |
| **HeroSet is in Garmin store review right now** (uploaded 2026-09-19) | `docs/go-to-market.md` | Timing constraint, see §1. |
| `verden-site` has an extra branch `backup/pre-rewrite` | `git branch -a` | `subtree add` takes one ref. That branch is **not** carried over. |
| Both HeroSet + verden-site are `0 0` vs origin | `rev-list --left-right` | No unpushed commits to rescue. Clean starting point. |
| heroFace has **no remote at all** | `git remote -v` | Nothing to archive on GitHub for it. |
| `git subtree` present | `git subtree` exits 0 | Tooling OK. git 2.54.0. |
| `.gitignore`s use rooted paths (`/bin/`, `/gen/`) | read | Leading `/` is relative to the containing `.gitignore`, so they keep working unchanged in subdirs. **No edits needed.** |

### Revision 1 — layout is now flat, with original directory names

Earlier proposal was `apps/heroset/`, `faces/heroface/`, `site/`. **Dropped.** It changes
the depth of every directory, which breaks all ~25 `../heroFace`, `../HeroSet`,
`../verden-site` references in the docs and turns a mechanical move into an
error-prone doc rewrite.

Keeping the three directory names **exactly as they are** means every one of those
references stays literally correct. Zero doc edits.

### Revision 2 — root is the existing `~/dev/garmin/`, not a new subdirectory

Making `~/dev/garmin/` itself the repo root means **no file moves on disk at all**.
Only `.git` directories change. This additionally preserves:

- all `../X` doc references (see above);
- the three Claude Code project keys
  (`-Users-mbp-dev-garmin-HeroSet`, `-heroFace`, `-verden-site`) and the memory +
  session history filed under them — a path change would orphan all three.

Local directory name ≠ GitHub repo name, so the repo is still published as `verden`.

**Final layout (nothing moves):**

```
~/dev/garmin/            ← git root, remote: github.com/verden11/verden
  HeroSet/               ← was its own repo
  heroFace/              ← was its own repo
  verden-site/           ← was its own repo
  device-test/           ← untracked scratch (gitignored)
  MONOREPO-PLAN.md       ← this file
  .gitignore             ← new, root-level
  CLAUDE.md              ← new, studio-level (later; not part of the move)
```

Renaming to `apps/` / `faces/` later is a `git mv` whenever it actually hurts. Not now.

---

## 1. Ordering constraint — when to run this

HeroSet is in Garmin review. The migration does not touch build output, the `.iq`, or
the signing key, and old repos stay intact throughout — but if review comes back needing
a resubmit, you want to be doing that in a known-good tree, not mid-migration.

**Recommendation: run it after Garmin review resolves.** If you want it sooner, it is
safe — the rollback in §5 is a directory copy — but that is your call, flagged here.

---

## 2. YOU do these (I will not)

Your `CLAUDE.md` rule: *"don't stage, commit, stash or reset unless asked."*
Everything below is that rule, plus anything outside this machine.

| # | Task | Why yours |
|---|---|---|
| ~~Y1~~ | ~~Commit the staged files in `HeroSet`.~~ **DONE** — 24 commits, clean. | — |
| ~~Y2~~ | ~~Commit the staged files in `heroFace`.~~ **DONE** — 2 commits, clean. | — |
| **Y3** | Decide the fate of `verden-site` branch `backup/pre-rewrite` — carry it in, or accept losing it. | Judgement call, see §3 step B3. |
| **Y4** *(deferred)* | Create empty GitHub repo `verden11/verden` (private, no README/gitignore/licence). | Needs your account. |
| **Y5** | Give the go. Push is **off** for this run (no remote exists yet). | Outward-facing, irreversible-ish. |
| **Y6** *(deferred)* | **Netlify:** set build **base directory** to `verden-site`, then repoint the site to the new GitHub repo. | Your dashboard. See §4. |
| **Y7** *(deferred)* | Verify the Netlify deploy is live and correct at https://verden.watch before archiving anything. | Production check. |
| **Y8** *(deferred)* | Archive `verden11/Garmin_HeroSet` and `verden11/watches-site` on GitHub — **only after Y7 passes.** | Your account, and deliberately last. |
| **Y9** | Delete the `.git` backups from §5 once you are satisfied, probably a week later. | Destructive. Never implicit. |

Y1 and Y2 are the gate. I cannot start until both are done — and I will re-check
`git status` in both repos and refuse to proceed if either is dirty.

---

## 3. I do these

All of it builds in a scratch directory first. Nothing in `~/dev/garmin/` is touched
until step E, and step E is preceded by a full backup.

### A — Preflight (read-only, aborts on any failure)

- A1. `git -C HeroSet status --porcelain` → must be empty. Abort if not.
- A2. `git -C heroFace status --porcelain` → must be empty. Abort if not.
- A3. `git -C verden-site status --porcelain` → must be empty. Abort if not.
- A4. Record baseline for the §6 proof: for each repo,
  `git ls-files -s | sort > /scratch/baseline-<repo>.txt` (blob SHA + mode + path),
  plus `git rev-list --count HEAD` and `git rev-parse HEAD`.

### B — Build the monorepo in scratch

```bash
cd /scratch && git init verden && cd verden
git commit --allow-empty -m "chore: init verden monorepo"
git subtree add --prefix=HeroSet     ~/dev/garmin/HeroSet     main
git subtree add --prefix=heroFace    ~/dev/garmin/heroFace    main
git subtree add --prefix=verden-site ~/dev/garmin/verden-site main
```

- B3. If Y3 says keep it: additionally
  `git subtree add --prefix=verden-site-backup ~/dev/garmin/verden-site backup/pre-rewrite`
  — ugly, so the likely answer is "let it go, the old repo is archived not deleted and
  still has it." Your call.

### C — Root files

- C1. Root `.gitignore`: `device-test/`, `.DS_Store`. Nothing else — the three
  per-directory `.gitignore`s keep working as-is.
- C2. Move this plan file in and commit it.
- C3. Root `CLAUDE.md`: **deferred, not part of this migration.** Studio-level rules are
  a separate decision once the tree exists. The three existing `CLAUDE.md`s keep loading
  per-directory and are untouched.

### D — Preservation proof (§6) run against the scratch repo

If any check fails, stop and report. Nothing has touched `~/dev/garmin/` yet.

### E — Swap in place

- E1. Back up: `cp -a` each of the three `.git` directories to
  `~/dev/garmin/.migration-backup-<date>/`.
- E2. Move `/scratch/verden/.git` → `~/dev/garmin/.git`.
- E3. Remove the three old `.git` directories (originals safe in E1).
- E4. `git -C ~/dev/garmin status` → **must** show a clean tree with only
  `device-test/` ignored. Any unexpected modification means the swap is wrong → roll
  back per §5 immediately.
- E5. Re-run the §6 proof against the real tree.

### F — Remote — **SKIPPED this run** (no GitHub repo yet)

- F1. `git remote add origin git@github.com:verden11/verden.git`
- F2. `git push -u origin main`

I stop after E. Y4–Y9 are yours, whenever you get to them.

---

## 4. Netlify — deferred, not touched this run

Since step F is skipped, Netlify keeps building from `watches-site` exactly as it does
now. **Nothing about the live site changes.** This section applies only when you later
create the repo and repoint. Decision taken 2026-09-20: option 1, accept whole-repo
clone access. Option 3 (deploy from GitHub Actions, revoke Netlify repo access) stays
available later as a pure addition — it undoes nothing.

### When you do repoint

Current `verden-site/netlify.toml` is unchanged by this migration and does not move.
What changes is where Netlify starts from.

- Set **base directory** = `verden-site`. Netlify then reads `verden-site/netlify.toml`
  and resolves `publish = "dist"` relative to that base. `command = "npm run build"` is
  unchanged.
- **I am not certain from memory** whether your Netlify site reads `netlify.toml` from
  the repo root or from the base directory in every plan/config combination. Treat this
  as verify-by-deploy, not as a claim: after repointing, watch one deploy log and confirm
  it found the config and published `verden-site/dist`.
- Do **not** archive the old `watches-site` GitHub repo until that deploy is green (Y8
  is ordered after Y7 for exactly this reason). Until then, reverting the Netlify site to
  the old repo is a two-click rollback.

---

## 5. Rollback

| Stage reached | How to undo | Cost |
|---|---|---|
| Through D (scratch only) | `rm -rf /scratch/verden` | Nothing touched. |
| Through E | `rm ~/dev/garmin/.git`, restore the three `.git` dirs from `.migration-backup-<date>/` | Full restore. Working files never moved, so they match. |
| Through F (pushed) | As above, plus delete/ignore the `verden` GitHub repo. Old remotes still exist and still have everything. | Minutes. |
| After Y6 (Netlify repointed) | Point the Netlify site back at `watches-site`, clear base directory. | Minutes, while old repo is unarchived. |

The old repos are **archived, never deleted**. Archive is reversible; delete is not.

---

## 6. Preservation proof

Run in D (scratch) and again in E5 (real tree). All three must pass.

1. **Content identity.** For each repo, `git ls-files -s <prefix>/` in the monorepo,
   with the prefix stripped, must be byte-identical to that repo's `baseline-<repo>.txt`
   from A4. This compares **mode + blob SHA + path** for every tracked file — not a diff,
   an object-hash match. Any single changed or dropped file fails it.
2. **History reachability.** Each old repo's HEAD SHA from A4 must be an ancestor in the
   monorepo: `git merge-base --is-ancestor <old-head> HEAD` exits 0, for all three.
3. **Commit count.** `git rev-list --count HEAD` ≥ 24 + 2 + 9 = 35, plus the empty init
   and the subtree merge commits. Sanity check only; #1 and #2 are the real proof.

`git log --follow` across the merge boundary works for these subtree imports; plain
`git log <path>` shows history too. Blame is preserved.

---

## 7. Explicitly out of scope

Not doing these as part of the migration. Each is a separate, later decision.

- Root `CLAUDE.md` with studio-wide rules.
- A `contracts/` directory for the HeroSet↔HeroFace complication contract. The contract
  currently lives in `HeroSet/docs/decisions.md` (ADR-044) and
  `heroFace/source/HeroFaceContract.mc`. Worth centralising **after** the move, once
  cross-directory edits are atomic and the need is visible.
- Renaming directories to `apps/` / `faces/` / `site/`.
- Any shared Monkey C source directory. No second consumer exists.
- Consolidating the three `docs/decisions.md`-style ADR sets.

---

## 8. ~~Unrelated flag~~ — resolved

Test-count mismatch (CLAUDE.md vs `go-to-market.md`) was fixed in the ADR-045 commit.
Now 94 (85 store) across all four files.
