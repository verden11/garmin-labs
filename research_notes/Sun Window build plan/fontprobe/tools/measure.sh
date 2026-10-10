# Scenario for docker/capture.sh (simulator only): for each device, load the font probe, let the glance log its sizes,
# open the full view (Down + START, or a tap on touch devices; HeroSet tools/drive_screens.sh) and let it log too.
# Writes /work/bin/fonts-<device>.log (the FP lines) and /work/bin/fonts-<device>-{glance,full}.png.
#   docker/capture.sh "research_notes/Sun Window build plan/fontprobe" tools/measure.sh fr965 venu3 ...
OUT=/work/bin; mkdir -p "$OUT"
sim_boot "2026-10-05 11:30:00"
for DEV in "$@"; do
  J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
  read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J"); DY=$((DY + 25))
  snap() { xwd -root -display "$DISPLAY" | convert xwd:- -crop "${DW}x${DH}+${DX}+${DY}" +repage "$OUT/fonts-$DEV-$1.png"; }
  press() {
    read -r kx ky < <(jq -r --arg k "$1" '[.keys[] | select(.id == $k)][0] | "\(.location.x + .location.width / 2 | floor) \(.location.y + .location.height / 2 + 25 | floor)"' "$J")
    [ -z "$kx" ] && return 1
    xdotool mousemove "$kx" "$ky" click 1; sleep "${2:-2}"
  }
  LOAD_WAIT=20 sim_load monkey.jungle "$DEV"
  snap glance
  if press down 3; then press enter 6; else xdotool mousemove $((DX + DW / 2)) $((DY + DH / 3)) click 1; sleep 6; fi
  snap full
  cp /tmp/md.log "$OUT/md-$DEV.log"
  grep '^FP' /tmp/md.log > "$OUT/fonts-$DEV.log"
  echo "$DEV: $(wc -l < "$OUT/fonts-$DEV.log") lines"
done
