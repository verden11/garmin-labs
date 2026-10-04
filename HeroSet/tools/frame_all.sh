#!/bin/bash
# Frames the five store screens from the window captures in listing/src/window/ (see listing/screenshots.md):
#   CIQ_IMAGE=verden-ciq-shots:9.2.0 ../docker/run.sh HeroSet bash tools/frame_all.sh
# Also writes bin/preview.png (the five on a dark card, to judge the keyed edges) and checks the 150 KB cap.
set -e
cd /work; mkdir -p listing/screens-framed bin
for n in 1-dashboard 2-counting 3-review 4-complete; do bash tools/frame_shots.sh fr965 listing/src/window/fr965-$n.png listing/screens-framed/$n.png 100; done
bash tools/frame_shots.sh instincte45mm listing/src/window/instincte45mm-5-dashboard.png listing/screens-framed/5-instinct.png 160 394
for f in listing/screens-framed/[1-5]-*.png; do
  [ "$(stat -c %s "$f")" -lt 150000 ] || echo "OVER 150 KB: $f"
  convert -size 720x720 xc:'#0b1626' "$f" -composite -resize 480x480 /tmp/p-$(basename "$f")
done
convert /tmp/p-1-*.png /tmp/p-2-*.png /tmp/p-3-*.png +append /tmp/r1.png
convert /tmp/p-4-*.png /tmp/p-5-*.png +append /tmp/r2.png
convert /tmp/r1.png /tmp/r2.png -append bin/preview.png
