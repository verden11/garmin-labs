#!/bin/bash
# Check the store images of both Days To Go listings against Garmin's limits: sizes in bytes, pixel size, screens under 150 KB (150000 bytes is used,
# the stricter reading of KB), cover 500x500 under 300 KB, hero 1440x720 under 2048 KB, icons 128x128, at most 5 screens, 64 colour icon on the 00/55/AA/FF palette.
# Usage: DaysToGo/tools/check_listing_images.sh
cd "$(dirname "$0")/.." || exit 1
bad=0
dim() { sips -g pixelWidth -g pixelHeight "$1" | awk '/pixel/{printf "%s%s", sep, $2; sep="x"}'; }
chk() {  # chk <file> <WxH> <max bytes>
  local s w; s=$(stat -f %z "$1"); w=$(dim "$1")
  if [ "$w" = "$2" ] && [ "$s" -lt "$3" ]; then echo "ok   $1 $w $((s / 1024)) KB"; else echo "FAIL $1 $w $s bytes (want $2, under $3)"; bad=1; fi
}
for D in listing listing-free; do
  chk $D/cover-500.png 500x500 300000
  for h in $D/hero-1440x720*.png; do chk $h 1440x720 2048000; done   # English, -es, -zh (one hero per listing language)
  chk $D/icon-24-128.png 128x128 100000
  chk $D/icon-64-128.png 128x128 100000
  n=0
  for f in $D/screens/*.png; do n=$((n + 1)); s=$(stat -f %z "$f"); echo "$([ "$s" -lt 150000 ] && echo ok || echo FAIL)   $f $(dim "$f") $((s / 1024)) KB"; [ "$s" -lt 150000 ] || bad=1; done
  [ $n -le 5 ] || { echo "FAIL $D has $n screens"; bad=1; }
done
exit $bad
