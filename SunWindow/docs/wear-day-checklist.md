# Sun Window: wear-day checklist (FR965, ROADMAP 18.4)

One full day with this app on the FR965, no other sideload swapped in that day (owner's testing style). Photos of the
screen are the evidence; one per step is enough. Results go in [`status.md`](status.md) (device checks), each marked
"FR965 only". Simulator results elsewhere in this folder are not device proof.

**Build to wear:** `SunWindow-fr965.prg` (debug build, app name "Sun Window"). Build it with
`CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh SunWindow monkeyc -d fr965 -f monkey.jungle -o bin/SunWindow-fr965.prg -y /keys/developer_key -w --typecheck 3`
and copy `SunWindow/bin/SunWindow-fr965.prg` into `GARMIN/Apps/` on the watch over USB (`device-test/` is git-ignored scratch; a
prebuilt copy may already be in the worktree's `device-test/`). Remove the spike probes ("SW Probe", "SW Widget") first so the
glance list has one Sun Window.

## What you see

- **Glance** (scroll the glance list): "Sun Window" and under it a small mark and one word: OPEN, CLOSED or NONE TODAY. Before the
  app was ever opened it says "Open once".
- **App** (START on the glance): today's sun path over a dashed line (45 degrees). The thick coloured part is the window; the dot
  is the sun now, filled while the window is open. Under it the word, one reason line ("Opens 10:26", "Cloud cover", "Closed
  for today", "Sun stays low", "No weather") and today's times. START asks for a new place. Hold UP (the menu button) for the accent colour list.

## Steps

| # | Check (device check) | Do | Pass | Result (date, photo) |
|---|---|---|---|---|
| 1 | Install | Copy the `.prg`, eject, scroll the glance list | "Sun Window" is in the glance list and says "Open once" | |
| 2 | Place (D6) | START on the glance, outdoors or at a window | The app shows the picture and a word within a minute; back to the glance list: it now shows a state word (not "Open once") | |
| 3 | The three states against the sky | Look at it at three times of one sunny day: early morning, midday, evening (summer: Apr to Aug in Vilnius) | CLOSED "Opens …" before, OPEN at midday inside the times shown, CLOSED "Closed for today" after. In winter: NONE TODAY "Sun stays low" all day | |
| 4 | Times against the sky and the maths (D9) | At the minute the app says the window opens, check the sun's height with Garmin's own sun or a sun app, or just note "looks like the shadow rule" | The opening and closing minutes are within a few minutes of what you expect; write both times down | |
| 5 | Weather (D2) | Open it around midday in sun, then again under cloud (another time or day) | Sunny: OPEN (or CLOSED "Cloud cover" only if the watch really reports low UV). Overcast or a low UV reading: CLOSED "Cloud cover". If it never changes with the sky, say so: the cloud fallback (`USE_CLOUD_FALLBACK`) may be needed | |
| 6 | Glance and app agree | Compare the glance word with the app's word at the same moment, several times | Always the same state | |
| 7 | Midnight (D7) | Look at the glance just after local midnight, and the next morning | It still draws; the state belongs to the new day (CLOSED "Opens …" or NONE TODAY, not yesterday's) | |
| 8 | Menu (D11) | In the app, hold UP | The accent list opens; pick another colour: the thick window segment and the dot change colour, nothing else does; back out | |
| 9 | Settings stay | Leave the app, reopen it | The chosen colour is kept | |
| 10 | Timeout (D12, already measured) | Optional: open from the glance, put the watch down | It closes by itself after about 2 minutes (the spike measured 120 s) | |
| 11 | No-place sentence | Optional: Garmin's GPS off in a basement is enough to see "Finding your place" then "No place yet", "Press START" | The sentence, never a blank | |
| 12 | Widget in the app list (W1) | Only if you sideloaded `SunWindowWidgetProbe-fr965.prg` ("SW Widget"): look in the app list | Say whether it is listed there (ADR-008) | |
| 13 | DST (optional) | If the day crosses 2026-10-25 (Vilnius summer time ends), check the times next morning | The times moved by an hour in clock terms | |

## After

Send the photos or the filled Result column. The agent records them in `status.md` (device checks and gates 2, 3, 7),
`compatibility.md` and `CHANGELOG.md`, and proposes the final UV and cloud cut-offs from step 5 (ADR-004).
