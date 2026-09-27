# Two Suns screenshots

Status: 2026-09-27. Two real device screens exist, captured by the owner on
the FR965 simulator's own native "Save Screenshot" (454×454, no chrome/case/
band — this environment cannot capture the simulator directly: no Screen
Recording or Accessibility permission). The look (colours, glyph, layout) is
still not formally approved by the owner beyond having seen these two shots.
Do not use the site's SVG drawing (`site/src/apps/two-suns/FacePreview.tsx`)
as a store image: it is a schematic with example numbers, not the face.

## Files

| File | What it shows | Where it came from |
|---|---|---|
| `screens/1-face.png` | Awake: "7:17", sky blue accent, day-left/day-gone arcs, Body Battery pill "59" | Owner's FR965 simulator, 2026-09-27 |
| `screens/2-sleep.png` | Always-on (AOD): dim `#5555AA` time/value/sun-line, no ring | Owner's FR965 simulator, 2026-09-27 |

Composed images, in `listing/`: `cover-500.png` and `hero-1440x720.png`.
Source: `src/{cover,hero}.html`, rendered via headless Chrome (same pipeline
as HeroSet/HeroFace — see `../../HeroFace/listing/screenshots.md` for the
house convention this follows):

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd listing
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files \
  --virtual-time-budget=5000 --window-size=500,500 \
  --screenshot="$PWD/cover-500.png" "file://$PWD/src/cover.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files \
  --virtual-time-budget=5000 --window-size=1440,720 \
  --screenshot="$PWD/hero-1440x720.png" "file://$PWD/src/hero.html"
```

The cover/hero mark (a ring arc + sun dot) is drawn from the app's own
`TwoSunsRing.mc` colours and shapes, not an invented logo — draft, same
sign-off status as the launcher icon placeholder.

## Still worth capturing (optional, not blocking)

More states would tell a fuller story but aren't required — one real screen
is enough to submit:

| State | Why it's worth a slot |
|---|---|
| After sunset (marker an outline, night ring, tomorrow's sunrise sentence) | Shows the ring and sentence changing |
| No place yet (plain ring, no marker, "No place yet") | Honest about the failure state, also the support question |
| Stale battery (grey curve, grey number, hollow dot) | Shows staleness is a shape as well as a colour |
| Golden hour on (warm arc), a small MIP screen (218/240 px) | Optional, if there's room in the upload order |

How to get each, in the simulator: Simulation → Set Time for day/after-sunset
(sun times come from the Complication data fields); a fresh simulator
profile with no location set for "no place yet"; an aged/stopped Body
Battery history feed for stale. Test fixtures for the same states already
exist in `../source/test/TwoSunsTestStates.mc`.

Not made: device icons (128×128, optional). Framed captures with a watch
bezel are not used in the listing.
