# Scenario for docker/capture.sh (simulator only, never device proof): load the probe, photograph the glance, open the
# full view from it (Down wakes the glance list, START opens the app; HeroSet tools/drive_screens.sh), photograph it,
# then press SELECT (a new fix request; the simulator has no GPS) and MENU (toggles glance-pos) and photograph again.
#   docker/capture.sh "research_notes/Sun Window build plan/probe" tools/open_full_view.sh fr965
DEV=${1:-fr965}
J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J"); DY=$((DY + 25))
OUT=/work/bin; mkdir -p "$OUT"
snap() { xwd -root -display "$DISPLAY" | convert xwd:- -crop "${DW}x${DH}+${DX}+${DY}" +repage "$OUT/full-$DEV-$1.png"; echo "snap $1"; }
press() {
  read -r kx ky < <(jq -r --arg k "$1" '[.keys[] | select(.id == $k)][0] | "\(.location.x + .location.width / 2 | floor) \(.location.y + .location.height / 2 + 25 | floor)"' "$J")
  if [ -z "$kx" ]; then echo "no $1 key on $DEV"; return 0; fi
  xdotool mousemove "$kx" "$ky" click 1; sleep "${2:-2}"
}
sim_boot "2026-10-05 11:30:00"
sim_load monkey.jungle "$DEV"
snap 0-glance
press down 3
press enter 6
snap 1-full
press enter 4
press menu 4
snap 2-after-select-menu
tail -20 /tmp/md.log
