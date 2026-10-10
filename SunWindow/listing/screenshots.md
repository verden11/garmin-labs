# Sun Window — screenshots

**Drafts for the owner's look approval (ROADMAP 18.1); nothing is approved.** All are simulator captures: the simulator's weather,
clock and place are set by hand (`tools/shots.sh`, the place patched into a private copy), so they show the states, never a
reading. The clock reads 12-hour because the simulator starts on 12 h; the container's UTC clock puts Vilnius's window early
(7:26a-1:15p), so the times are not Vilnius's real ones.

Native captures: `screens/` (and `screens/native/` for the Instinct). Framed in each watch's own skin by
`CIQ_IMAGE=verden-ciq-shots:9.2.0 docker/run.sh SunWindow bash /ciq-docker/frame_listing.sh listing`
(`src/frames.txt`; the device must be the one captured on) into `screens-framed/` (720x720, under the store's 150 KB each).

| # | State | Watch | Notes |
|---|---|---|---|
| 1 | OPEN | Forerunner 965 (round AMOLED) | Window thick in the accent, filled sun disc, times |
| 2 | CLOSED before the window | Venu 3 | "Opens 7:26", the disc is an outline |
| 3 | NONE TODAY | Forerunner 255S (small round MIP) | The winter state: the whole path stays under the line |
| 4 | The glance | Forerunner 965 | The system's card, its launcher icon (still the placeholder) at the left |
| 5 | OPEN, black and white | Instinct E 45 mm | The mark in the round window, the picture left of it |

Not in the set but shot (`docs/archive/screens/`): CLOSED after the window, CLOSED by the sky, "Finding your place", "No place yet",
the rectangle (Venu X1), the Instinct E 40 mm.

Cover 500×500 (<300 KB, a coloured ground, never black) and the two 128×128 device icons are drafts rendered by
`tools/render_listing_images.sh` from `src/` (`cover-500.png`, `icon-24-128.png`, `icon-64-128.png`). No hero image.
