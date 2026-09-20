# Garmin Connect sync (v1.1)

Status: 2026-09-20. **Implemented in dev build (ADR-043), not committed, unverified on watch.** Open: steps 0, 7, 8 below. The v1 `.iq` in review is untouched.

## Summary

- **Opt-in:** Connect Sync `Off` (default) keeps everything on the watch.
- **On:** each HeroSet visit with saved workout reps = one Garmin Connect Strength activity, **one lap per set** with exercise + saved reps, visit totals in the summary. Garmin adds time, HR, calories, Training Effect.
- **Strava:** gets time + HR via the user's own Connect↔Strava link (ignores developer fields). Noise is muted on Strava's side (e.g. [ActivityFix](https://activityfix.com/)).

## Platform limits (SDK 9.2, checked 2026-09-19)

Why a day can't be one activity, and why not native strength sets:

| Limit | Source |
|---|---|
| Only route into Connect: a live `ActivityRecording.Session` saved on the watch. No backdating (`Session` = `start/stop/save/discard/addLap/createField/isRecording`) | `ActivityRecording.html`, `Session.html` |
| Session doesn't survive app close (FR965: stray activities, ADR-030). Garmin's `RecordSample` saves in `onStop` | ADR-030, `RecordSample/RecordSampleApp.mc` |
| No file API; `PersistedContent` read-only | Toybox module list |
| Background services killed after 30 s | Core Topics "Backgrounding" |
| No Garmin API accepts a finished activity (`makeWebRequest` JSON/URL only; Activity/Training APIs read or push plans) | `Communications.html`, gc-developer-program |
| Developer fields only on SESSION, LAP, RECORD messages; no FIT `set`/exercise-category API → no native set list or muscle map | `FitContributor.html` |
| `fitcontributions.xml` can show fields in Activity Laps and Summary; strings allowed on lap/session | Core Topics "Activity Recording" |

## Behavior (sync On)

| Moment | What happens |
|---|---|
| First workout set of a visit | Create session (`SPORT_TRAINING`/`STRENGTH_TRAINING`, localized name + units), `start()`, pending lap = this exercise, 0 reps |
| New set screen's first `onShow` | `start()`, write previous set's lap fields, `addLap()`, new pending lap |
| Set screen hidden | `stop()`: rest, menu, picker time not counted |
| Same set shown again (Resume, notification) | `start()` only, no lap |
| Workout save (picker after set, or Back → Save) | Saved reps onto pending lap |
| `AppBase.onStop` | ≥ 1 saved workout rep → write last lap + totals, `save()` (refused save → `discard()`). Else `discard()`. Never left open |

Rules:
- Only workout-seeded saves count (same boundary as learning, ADR-040); main-menu manual entries never start or join a session.
- Discarded / empty sets keep a 0-rep lap; their time stays.
- Negative correction: lap = `max(0, delta)`; exercise total drops by it (≥ 0). Earlier laps keep their counts, so laps can sum above the summary.
- Sync turned off mid-visit → discard immediately.
- `createSession`/`start` refused, or no `ActivityRecording` → no sync that visit, `SYNC FAIL`.

**Fields** (ids 0–4 fixed forever, baked into saved FIT files like ADR-003 keys): lap `Exercise` (string, 32 bytes, name truncated) + `Reps`; session `Push-ups`, `Sit-ups`, `Squats`. Fallback if Connect hides string lap fields: three numeric lap fields.

**UX:** existing `Connect Sync` toggle and `hero_sync_enabled` key (ADR-027); sublabels `Saves to Connect` / `Watch only` (native `Menu2`, fit unmeasurable in tests; longest: French). No recording indicator, no save toast (saves at exit). Copy never promises "automatic", Strava rep counts, or native set lists.

**Log lines** (Validation Log, dev build): `HH:MM SYNC NEW` · `SAVED m:ss` · `EMPTY` · `OFF` · `FAIL`.

## Open steps

| # | Step |
|---|---|
| 0 | **Spike on FR965:** does Connect web **and** phone show the string lap field and blank unit (`fit_unit_none`)? Does `addLap()` right after `start()` put the boundary where expected? Decides string vs numeric fallback. |
| 7 | Device acceptance below, dev build. |
| 8 | Only after 7: `Fit` + `FitContributor` into `manifest-store.xml`, stop excluding `sync` in `store.jungle`, toggle into `resources-store/` menu, delete `HeroSetSyncCoordinatorOff.mc`. Same session: `../verden-site` privacy + support, store description, `release-contract.md` sync rows, go-to-market "never promise". Existing users may need to approve the new permission. |

## Device acceptance (FR965; simulator isn't proof, ADR-022/023)

Check `SYNC …` log and Connect after phone sync.

1. Push-ups, sit-ups, squats in one visit → 1 activity, 3 laps with right exercise + reps; totals match.
2. Detected 22, saved 20 → lap 20.
3. Back → Save → lap = detected count.
4. Discarded set → its lap 0, others right.
5. Two visits in a day → 2 activities.
6. Only discarded sets / only manual entries / sync Off → 0 activities.
7. Exit via Back chain, watch app switch/shortcut, mid-set → no stray or duplicate activity (ADR-030 failure).
8. Strava (if linked): time + HR arrive.
9. Phone notification mid-set → still one lap.
10. Store build (step 8): preview shows `Fit` permission; compatible-device list doesn't shrink.

## Risks

- Connect/phone hides string lap fields → fallback (step 0).
- Watch auto-saves on some exit path; `onStop` doesn't run on crash → test 7.
- Native activity already recording blocks `createSession` → `SYNC FAIL`; try once.
- Session memory on 128 KB watches (fēnix 6/6S, Enduro) → simulator memory view before step 8.
- `Fit` scares buyers or changes eligibility → test 10.
- Store `.iq` compiles `fitcontributions.xml` + `fit_*` strings without the permission (builds fine) → confirm in preview at step 8.
