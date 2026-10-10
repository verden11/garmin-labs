# Scenario for ../docker/capture.sh (simulator only, never device proof): one state on one device, the glance and then the
# full view, saved at native pixels to bin/shots/<device>-<tag>-glance.png and -full.png.
#   ../docker/capture.sh SunWindow tools/shots.sh <device> <tag> "<YYYY-MM-DD HH:MM:SS>" [seed|noseed] [lowuv] [accent]
# The container's clock is UTC, so the app's offset is 0 and the times below are UTC. `seed` patches a stored place into
# getInitialView of the private copy (Vilnius, 54.7 25.3; the repo is untouched), the documented fallback when the
# simulator's Set Position does not reach Position.getInfo(); `lowuv` patches the weather read to a UV of 1 (the sky says
# CLOSED); `accent` is a property id 0 to 5 written into the private copy's default. The simulator's own weather and
# clock are set by hand: never present a shot as a reading.
DEV=$1; TAG=$2; CLOCK=$3; SEED=${4:-seed}; LOWUV=${5:-}; ACCENT=${6:-0}
J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J"); DY=$((DY + 25))
OUT=/work/bin/shots; mkdir -p "$OUT"
snap() { xwd -root -display "$DISPLAY" | convert xwd:- -crop "${DW}x${DH}+${DX}+${DY}" +repage "$OUT/$DEV-$TAG-$1.png"; echo "snap $DEV-$TAG-$1"; }
press() {
  read -r kx ky < <(jq -r --arg k "$1" '[.keys[] | select(.id == $k)][0] | "\(.location.x + .location.width / 2 | floor) \(.location.y + .location.height / 2 + 25 | floor)"' "$J")
  [ -z "$kx" ] && return 1
  xdotool mousemove "$kx" "$ky" click 1; sleep "${2:-2}"
}
if [ "$SEED" = seed ]; then
  perl -pi -e 's/var view = new SunWindowView\(\);/Application.Storage.setValue("place", [54.7, 25.3]); var view = new SunWindowView();/' source/SunWindowApp.mc
fi
if [ -n "$LOWUV" ]; then
  perl -pi -e 's/return \[conditions\.uvIndex, conditions\.cloudCover\]/return [1.0, 80]/' source/SunWindowWeather.mc
fi
perl -pi -e "s/(<property id=\"Accent\" type=\"number\">)0/\${1}$ACCENT/" resources/settings/properties.xml
rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
sim_boot "$CLOCK"
LOAD_WAIT=30 sim_load monkey.jungle "$DEV"
snap glance
if press down 3; then press enter 8; else xdotool mousemove $((DX + DW / 2)) $((DY + DH / 3)) click 1; sleep 8; fi
# The no-place state ("No place yet") shows only after LOCATE_SECONDS (60) with no fix, and the redraw is the 60 s tick, so the
# second tick (about 120 s after the app opened) is the one that reliably shows it.
[ "$TAG" = nofix ] && sleep 125
snap full
# Relaunch: the place is stored now (the simulator keeps app storage between loads), so the glance shows the state; the first
# glance above ran before the app had stored it. BACK from the app leaves it, so the second launch is a fresh load.
LOAD_WAIT=30 sim_load monkey.jungle "$DEV"
snap glance-state
