# Simulator screenshots of the built screens (2026-10-10)

**Simulator only**, native display pixels, taken by `tools/shots.sh` (see `docs/development.md`): the simulator's weather, clock (UTC, so the
times are early for Vilnius's longitude, 12-hour) and the stored place (Vilnius, patched into a private copy) are set by hand. They show
the states, never a reading, and none is a photo of a watch.

`<device>-<tag>-full.png` is the app (opened from the glance with Down + START), `-glance-state.png` the glance list after the place was stored.
Tags: `open`, `before` (CLOSED, opens later), `after` (CLOSED, closed for today), `none` (NONE TODAY), `sky` (CLOSED, UV under 3), `nofix` ("No place yet").
