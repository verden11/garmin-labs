# Sun Window — screenshots

Not taken yet (plan P9.2). Rendered by an agent in the container simulator
(`docker/capture.sh SunWindow tools/listing_shots.sh`): fixed time, 24-hour
clock, a place from the simulator's Set Position, native pixels, each under
150 KB, then framed in a watch skin with `docker/frame_listing.sh`
(`src/frames.txt`). Simulator weather and place are set by hand: never
present them as a reading. The owner approves the looks.

| # | State | Device | Notes |
|---|---|---|---|
| 1 | OPEN, with today's times | fr965 | Hero state |
| 2 | CLOSED, "Opens 11:10" | fr965 | Before the window |
| 3 | NONE TODAY | fr255s | The winter state; a small round screen |
| 4 | Glance | fr965 | If no capture route works within 1 hour, a `drawState` bitmap from a test, labelled as such here (plan P6.5) |
| 5 | Any state, 1-bit | instincte45mm | Only while ADR-012 keeps Instinct |

Cover 500×500 (<300 KB, coloured ground, never black), hero 1440×720
(<2048 KB, optional), device icons 128×128 at 24-bit and 64-colour.
