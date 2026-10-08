#!/bin/bash
# Frames a native listing screenshot in its watch: the device's own simulator skin (chassis, buttons, part of the strap) with
# the screenshot under its transparent display hole, the skin's white background keyed out, centred on the display in a
# 720x720 transparent square, 256 colours (the store caps a screenshot at 150 KB). The screenshot's pixels are not altered,
# only resized (Lanczos) with the skin. No simulator needed: the skin and the display position come from the SDK's device
# folder (simulator.json). Run in the shots image:
#   CIQ_IMAGE=verden-ciq-shots:9.2.0 docker/run.sh <project> bash /ciq-docker/frame_shot.sh <device> <screen.png> <out.png> [scale%]
#   scale: default 100 x 454 / display width (every round watch shows its display at the FR965's 454 px), at most 160
#          (a 166 to 218 px display is enlarged 1.6 times, as HeroSet's Instinct image).
# Every listing: docker/frame_listing.sh reads <listing>/src/frames.txt and calls this for each line.
set -e
DEV=$1; IN=$2; OUT=$3
D=/root/.Garmin/ConnectIQ/Devices/$DEV; J=$D/simulator.json
SKIN=$D/$(jq -r .image "$J")
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J")
S=${4:-$(awk "BEGIN{s = 45400 / $DW; printf \"%d\", (s > 160 ? 160 : s)}")}
SW=$(identify -format %w "$SKIN"); SH=$(identify -format %h "$SKIN")
OX=$(awk "BEGIN{printf \"%d\", 360 - ($DX + $DW / 2) * $S / 100}"); OY=$(awk "BEGIN{printf \"%d\", 360 - ($DY + $DH / 2) * $S / 100}")
TMP=$(mktemp -d)
# The Instinct E skins carry a ghost of Garmin's sample screen in the display hole at alpha 1 to 25 of 255 (about 6,500 to
# 10,700 pixels; Instinct 2 none, round skins a few hundred anti-aliased edge pixels): composited over a black screenshot it
# drew faint grey marks. Inside the display rectangle, alpha under 10% is cleared; the opaque bezel and window rim stay.
convert "$SKIN" -channel A \
  -fx "(i >= $DX && i < $((DX + DW)) && j >= $DY && j < $((DY + DH)) && u < 0.1) ? 0 : u" +channel "$TMP/skin.png"
# screen under the skin, then the white around the watch made transparent (flood fill from the four corners)
convert -size "${SW}x${SH}" xc:none "$IN" -geometry "+$DX+$DY" -composite "$TMP/skin.png" -composite \
  -bordercolor white -border 1 -fuzz 6% -fill none \
  -draw 'color 0,0 floodfill' -draw "color $((SW + 1)),0 floodfill" -draw "color 0,$((SH + 1)) floodfill" -draw "color $((SW + 1)),$((SH + 1)) floodfill" \
  -shave 1x1 -filter Lanczos -resize "${S}%" "$TMP/watch.png"
mkdir -p "$(dirname "$OUT")"
convert -size 720x720 xc:none "$TMP/watch.png" -geometry "$(printf '%+d%+d' "$OX" "$OY")" -composite -colors 256 +dither PNG8:"$OUT"
rm -rf "$TMP"
echo "$OUT $DEV ${S}% $(identify -format '%wx%h' "$OUT") $(stat -c %s "$OUT") bytes"
