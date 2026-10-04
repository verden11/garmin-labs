# Two Suns Pro: the face for each weather condition, and in the simulator's Always-On display mode, photographed.
# A scenario for docker/capture.sh, not run by hand:
#   ../docker/capture.sh TwoSuns tools/weather_conditions.sh [device] [index ...]
# index = position in the Weather Editor's Condition list (its order is the SDK's: 0 Clear, 1 Partly cloudy, 2 Mostly cloudy,
# 3 Rain, 4 Snow, 5 Windy, 6 Thunderstorms, 8 Fog, 9 Hazy; only the first 25 are on screen when the list opens). Default: one
# per icon and Windy (no icon). Writes /work/bin/weather-<device>-<index>.png (the display, 100%) and weather-<device>-aod-*.png.
# The editor is set BEFORE the face loads (the face caches the weather for 5 minutes). Simulator only, never device proof.
# RESULT 2026-10-04: the editor keeps the chosen Condition (reopening shows it) but the face's row stayed on the canned
# partly cloudy / 77 degrees for every choice, and Display Mode > Always-On left the full face drawn: neither could be seen.
# GUI coordinates read off the 1280x1024 virtual screen: menu Settings (73,12) > Set Weather (139,933); the Condition combo
# (317,261) opens a list (click the entry); OK (1219,851). Display Mode (120,959) > High Power / Always-On / Off.
DEV=${1:-fr965}; shift; LIST=${*:-0 2 3 4 5 6 8 9}
J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J"); DY=$((DY + 25))
OUT=/work/bin; mkdir -p "$OUT"
snap() { xwd -root -display "$DISPLAY" | convert xwd:- -crop "${DW}x${DH}+${DX}+${DY}" +repage "$OUT/weather-$DEV-$1.png"; echo "snap $1"; }
condition() {   # condition <index>
  xdotool mousemove 73 12 click 1; sleep 1.5
  xdotool mousemove 139 933 click 1; sleep 3
  xdotool mousemove 317 261 click 1; sleep 1.5
  # the open list puts the current entry on the combo (y 264) and the rest 29 px apart (the keyboard did not select)
  xdotool mousemove 250 $((264 + 29 * ($1 - CUR))) click 1; sleep 1; CUR=$1
  xdotool mousemove 1219 851 click 1; sleep 3
}
CUR=1   # the editor opens on Partly cloudy
sim_boot "2026-10-04 10:09:00"
monkeyc -d "$DEV" -f monkey.jungle -o /tmp/app.prg -y /keys/developer_key -w >/tmp/build.log 2>&1 || { tail -5 /tmp/build.log; exit 1; }
for i in $LIST; do
  condition "$i"
  pkill -f monkeydo; (monkeydo /tmp/app.prg "$DEV" >/tmp/md.log 2>&1 &); sleep "${LOAD_WAIT:-20}"
  snap "$i"
done
# Always-On: Settings > Display Mode > Always-On (the face's onEnterSleep), then a minute later (the drift step)
xdotool mousemove 73 12 click 1; sleep 1.5; xdotool mousemove 120 959; sleep 1; xdotool key Right; sleep 1.5
xdotool mousemove 360 984 click 1; sleep 8; snap aod-1
sleep 65; snap aod-2
xdotool mousemove 73 12 click 1; sleep 1.5; xdotool mousemove 120 959; sleep 1; xdotool key Right; sleep 1.5
xdotool mousemove 360 959 click 1; sleep 6; snap aod-back-awake
echo weather done
