#!/bin/bash
# Turns a whole-simulator-window capture (drive_screens.sh writes drive-<dev>-<step>-window.png) into a framed listing image:
# the device skin (chassis, strap, buttons) around the display, 720x720, the white background keyed to transparent, 256 colours
# (the store caps a screenshot at 150 KB). Pure ImageMagick; run it in the container, which has it:
#   CIQ_IMAGE=verden-ciq-shots:9.2.0 ../docker/run.sh HeroSet bash tools/frame_shots.sh <device> <window.png> <out.png> [scale%] [skin-width]
#   scale       100 for the round watches (their window is already about 620 px of watch), 160-200 for an Instinct (a small skin)
#   skin-width  px of the window that are skin (an Instinct's window has a black strip to the right of it); default: all
# The display itself is never altered: only resized (Lanczos) with the skin, and the white around the watch made transparent.
# The simulator's menu bar (top 26 px) and status bar (bottom 24 px) are cut off first; the display is centred in the square.
set -e
DEV=$1; IN=$2; OUT=$3; S=${4:-100}; SKINW=${5:-}
J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J")
W=$(identify -format %w "$IN"); H=$(identify -format %h "$IN"); W=${SKINW:-$((W - 2))}; SH=$((H - 27 - 24))
CX=$((DX + DW / 2 - 1)); CY=$((DY + 25 + DH / 2 - 27))          # display centre inside the cropped skin
OX=$(awk "BEGIN{printf \"%d\", 360 - $CX * $S / 100}"); OY=$(awk "BEGIN{printf \"%d\", 360 - $CY * $S / 100}")
convert "$IN" -crop "${W}x${SH}+1+27" +repage -bordercolor white -border 1 -alpha set -fuzz 6% -fill none \
  -draw 'color 0,0 floodfill' -draw "color $((W + 1)),0 floodfill" -draw "color 0,$((SH + 1)) floodfill" -draw "color $((W + 1)),$((SH + 1)) floodfill" \
  -shave 1x1 -filter Lanczos -resize "${S}%" /tmp/skin.png
convert -size 720x720 xc:none /tmp/skin.png -geometry "$(printf '%+d%+d' "$OX" "$OY")" -composite -colors 256 +dither PNG8:"$OUT"
echo "$OUT $(identify -format '%wx%h' "$OUT") $(stat -c %s "$OUT") bytes"
