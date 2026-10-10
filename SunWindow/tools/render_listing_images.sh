#!/bin/bash
# Render the composed store images (cover, device icons) of the listing from listing/src/*.html with headless Chrome.
# Usage: tools/render_listing_images.sh     (on the host, not in the container; needs Google Chrome and python3)
# The 64-colour icon is the 24-bit render snapped to Garmin's palette (listing/src/quantize64.py). The framed screens are made by
# docker/frame_listing.sh from simulator captures (docs/development.md). Adapted from DayArc/tools/render_listing_images.sh.
set -e
cd "$(dirname "$0")/../listing"
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
shot() { "$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=4000 --window-size=$2 --screenshot="$PWD/$3" "file://$PWD/src/$1.html" >/dev/null 2>&1; }
shot cover 500,500 cover-500.png
shot icon 128,128 icon-24-128.png
python3 src/quantize64.py icon-24-128.png icon-64-128.png
ls -l cover-500.png icon-24-128.png icon-64-128.png
