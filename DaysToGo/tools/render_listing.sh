#!/bin/bash
# Render the composed store images of one Days To Go listing from its src/*.html with headless Chrome (needs network once for the Archivo font).
# Usage (from anywhere): DaysToGo/tools/render_listing.sh <free|pro> [cover] [hero] [icon] [screens]    (default: all)
# Writes cover-500.png, hero-1440x720.png, icon-24-128.png, icon-64-128.png (the 24 bit render snapped to the 64 colour palette by quantize64.py)
# and the upscaled Instinct screens, into listing-free/ (free) or listing/ (pro).
set -e
TIER=${1:?free|pro}; shift
cd "$(dirname "$0")/.."
[ "$TIER" = free ] && D=listing-free || D=listing
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
what=${*:-cover hero icon screens}
shot() {  # shot <html> <png> <w> <h>
  "$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=8000 \
    --window-size=$3,$4 --screenshot="$PWD/$D/$2" "file://$PWD/$D/src/$1" 2>&1 | tail -1
}
for w in $what; do
  case $w in
    cover) shot cover.html cover-500.png 500 500;;
    hero) shot hero.html hero-1440x720.png 1440 720;;
    icon) shot icon.html icon-24-128.png 128 128; python3 "$D/src/quantize64.py" "$D/icon-24-128.png" "$D/icon-64-128.png";;
    screens) [ "$TIER" = free ] && S=528 || S=498; shot instinct-up.html screens/5-instinct.png $S $S;;   # Free 176 px x3, Pro 166 px x3   # nearest-neighbour x3 of the native Instinct capture; see screenshots.md
  esac
done
