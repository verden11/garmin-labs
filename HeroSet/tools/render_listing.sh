#!/bin/bash
# Renders the composed store images from listing/src/*.html with headless Chrome (host, not the container; needs network for
# the Archivo web font). Run from anywhere:  HeroSet/tools/render_listing.sh
# Cover 500x500, hero 1440x720 (uses listing/screens-framed/), device icon 128x128 (24-bit) and its 64-colour twin.
set -e
cd "$(dirname "$0")/../listing"
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
shot() { "$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size="$1" --screenshot="$PWD/$2" "file://$PWD/src/$3.html$4" >/dev/null 2>&1; }
shot 500,500 cover-500-designed.png cover
shot 1440,720 hero-1440x720.png hero
shot 1440,720 hero-1440x720-es.png hero "#es"   # one hero per listing language (owner, 2026-10-08): src/hero.html swaps the line
shot 1440,720 hero-1440x720-zh.png hero "#zh"
shot 128,128 icon-24-128.png icon
python3 src/quantize64.py icon-24-128.png icon-64-128.png
ls -l cover-500-designed.png hero-1440x720*.png icon-24-128.png icon-64-128.png
