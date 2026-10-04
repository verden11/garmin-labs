# Drives HeroSet through its screens in the simulator (xdotool) and photographs each one: the face on its skin.
# A scenario for docker/capture.sh, not run by hand:
#   ../docker/capture.sh HeroSet tools/drive_screens.sh <device> <btn|touch> [jungle] [seed p,s,q] [detected] [glance|noglance] [all|resume]
# Writes /work/bin/drive-<device>-<step>.png (the display, SCALE percent, default 100). Simulator only, never device proof.
# Buttons are pressed by clicking their place on the skin (key boxes from the device's simulator.json; the window has a 25 px
# menu bar above the skin). On a device with a glance the simulator opens on the glance list, and the first START does
# nothing until the list has been moved once (Down; a device with no Down key, or a touch one, gets a tap on the glance):
# the scenario does that first. A non-zero seed (store.add at start) made the app crash on launch from the glance: use 0,0,0 and
# let the scenario's own saves fill the dashboard; the rep count on the set screen is patched to `detected` (no sensor data).
# A touch device is also driven with the mouse on the display: a click is a tap, a quick drag a swipe (swipe right must start
# within 81 px of the left edge and finish in under 250 ms, per the device's simulator.json).
DEV=$1; MODE=${2:-btn}; JUNGLE=${3:-store.jungle}; SEED=${4:-0,0,0}; DETECTED=${5:-23}; GLANCE=${6:-glance}; ONLY=${7:-all}
J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J"); DY=$((DY + 25))
OUT=/work/bin; mkdir -p "$OUT"
snap() { xwd -root -display "$DISPLAY" | convert xwd:- -crop "${DW}x${DH}+${DX}+${DY}" +repage -scale "${SCALE:-100}%" "$OUT/drive-$DEV-$1.png"; echo "snap $1"; }
# press <enter|esc|up|down> [seconds]
press() {
  read -r kx ky < <(jq -r --arg k "$1" '[.keys[] | select(.id == $k)][0] | "\(.location.x + .location.width / 2 | floor) \(.location.y + .location.height / 2 + 25 | floor)"' "$J")
  if [ -z "$kx" ]; then echo "no $1 key on $DEV"; return 0; fi
  xdotool mousemove "$kx" "$ky" click 1; sleep "${2:-2}"
}
tap() { xdotool mousemove $((DX + DW / 2 + ${1:-0})) $((DY + DH / 2 + ${2:-0})) click 1; sleep "${3:-2}"; }
# a quick straight drag across the display; coordinates are offsets from the display's top left
swipe() {
  xdotool mousemove $((DX + $1)) $((DY + $2)) mousedown 1; sleep 0.03
  for i in 1 2 3 4; do xdotool mousemove $((DX + $1 + ($3 - $1) * i / 4)) $((DY + $2 + ($4 - $2) * i / 4)); sleep 0.02; done
  xdotool mouseup 1; sleep 2
}
IFS=, read -r P S Q <<<"$SEED"
perl -0pi -e "s/(store\.ensureCurrentDay\(\);)/\$1 store.add(:pushups, $P); store.add(:situps, $S); store.add(:squats, $Q);/" source/app/HeroSetApp.mc
perl -0pi -e "s/private var _detected = 0;/private var _detected = $DETECTED;/" source/ui/workout/HeroSetWorkoutView.mc
sim_boot "2026-10-04 10:09:00"
sim_load "$JUNGLE" "$DEV" -r
snap 0-launch
if [ "$GLANCE" = glance ]; then
  # touch, or a device with no DOWN key (btn-start): a tap on the glance opens the app; else Down wakes the list, START opens it
  if [ "$MODE" = touch ] || [ "$(jq '[.keys[].id] | index("down")' "$J")" = null ]; then tap 0 -$((DH / 3)) 6; else press down 3; snap 0b-glance; press enter 6; fi
fi
snap 1-dashboard
if [ "$MODE" = touch ]; then
  # Touch-first (B2/B3): tap opens the menu, tap on an item selects it; a tap mid-set or in the picker does nothing,
  # START finishes and saves, swipe up is +1, swipe right from the edge is Back (the Resume menu).
  if [ "$ONLY" = resume ]; then   # just the swipe-right check: into a set, edge swipe, then tap Resume
    tap 0 0 4; tap 0 -$((DH * 38 / 100)) 5; snap 3-counting-after-item-tap
    swipe 4 $((DH / 2)) $((DW / 2)) $((DH / 2)); snap 8b-after-swipe-right
    tap 0 -$((DH * 7 / 100)) 3; snap 8c-after-tap-resume
    echo drive done; return 0 2>/dev/null || exit 0
  fi
  tap 0 0 3; snap 2-menu-after-dashboard-tap
  tap 0 -$((DH * 38 / 100)) 3; snap 3-counting-after-item-tap
  tap 0 0 2; snap 3b-after-tap-midset                                 # must still be counting
  press enter 3; snap 5-review-after-start                            # START finishes: the picker, pre-loaded
  swipe $((DW / 2)) $((DH * 3 / 4)) $((DW / 2)) $((DH / 4)); snap 5b-after-swipe-up   # +1
  tap 0 0 2; snap 5c-after-tap-in-picker                              # must be unchanged
  press enter 2; snap 6-saved-after-start
  sleep 4; snap 7-dashboard-after
  tap 0 0 3; tap 0 -$((DH * 38 / 100)) 3; snap 8-second-set
  swipe 4 $((DH / 2)) $((DW / 2)) $((DH / 2)); snap 8b-after-swipe-right   # the N reps menu with Resume
  tap 0 -$((DH * 7 / 100)) 3; snap 8c-after-tap-resume
else
  press enter 3; snap 2-menu
  press enter 3; snap 3-counting
  press esc 2; snap 4-endmenu
  press esc 2; snap 4b-resumed
  press enter 3; snap 5-review                                         # START = Finish: the picker, pre-loaded
  press up 1; snap 5b-up
  press enter 1; snap 6-saved
  sleep 4; snap 7-dashboard-after
  press esc 4; snap 8-after-back-to-glance
fi
tail -5 /tmp/md.log; echo drive done
