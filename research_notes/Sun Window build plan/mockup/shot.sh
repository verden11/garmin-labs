#!/bin/bash
# Screenshot SunWindow/docs/archive/mockup.html with host headless Chrome (plan P2.4; the DayArc render_listing_images.sh mechanism).
# Usage: bash shot.sh <rev>     writes mockup-<date>-rev<rev>.png next to this script
set -e
cd "$(dirname "$0")"
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
SRC="$(cd ../../../SunWindow/docs/archive && pwd)/mockup.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=4000 \
  --window-size=1930,${HEIGHT:-3700} --screenshot="$PWD/mockup-$(date +%F)-rev${1:-1}.png" "file://$SRC" >/dev/null 2>&1
ls -l "mockup-$(date +%F)-rev${1:-1}.png"
