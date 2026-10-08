#!/bin/bash
# Render the composed store images (cover, hero, device icons) of one listing from its src/*.html with headless Chrome.
# Usage: tools/render_listing_images.sh <listing|listing-pro>     (on the host, not in the container; needs Google Chrome and python3)
# The 64-colour icon is the 24-bit render snapped to Garmin's palette (src/quantize64.py). The screens are made by tools/listing_shots.sh.
set -e
L=${1:?listing|listing-pro}; cd "$(dirname "$0")/../$L"
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
shot() { "$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=8000 --window-size=$2 --screenshot="$PWD/$3" "file://$PWD/src/$1.html$4" >/dev/null 2>&1; }
shot cover 500,500 cover-500.png
[ -f src/hero.html ] && shot hero 1440,720 hero-1440x720.png
# one hero per listing language (owner, 2026-10-08): src/hero.html#es / #zh swaps the line and the captions
[ -f src/hero.html ] && shot hero 1440,720 hero-1440x720-es.png "#es" && shot hero 1440,720 hero-1440x720-zh.png "#zh"
shot icon 128,128 icon-24-128.png
python3 src/quantize64.py icon-24-128.png icon-64-128.png
ls -l cover-500.png hero-1440x720*.png icon-24-128.png icon-64-128.png
