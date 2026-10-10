# Real-time soak of one face (simulator only, never device proof): the face runs on the real clock for MINUTES, flipping
# between High Power and Always-On at every sample, so onEnterSleep/onExitSleep, the minute tick and midnight all happen.
# A scenario for docker/capture.sh; launch with nohup so a closed session does not stop it (docker forwards SIGTERM):
#   nohup docker/capture.sh <project> /ciq-docker/soak.sh <jungle> <device> [minutes 1440] [tag soak] [every 900] [monkeyc flags -r] > log 2>&1 &
# Writes /work/bin/soak/<tag>-<device>/ in the project (bin/ is untracked), updated at every sample so a dead container
# still leaves its record: samples.csv (utc, n, mode, simulator alive, error lines in the monkeydo log, display hash),
# disp-<n>-<mode>.png (the display), mem-<n>.png (the status bar: memory used / total, current use, not the peak),
# md.log (monkeydo's output: crash traces land here) and sim.log. A store-like build (-r), default settings.
# Fails to look for afterwards: errors > 0 (ERR_RE, matched against a planted crash 2026-10-10), alive = no, and two awake
# samples with the same hash (the minute moves, so an identical awake frame is a frozen face).
JUNGLE=${1:?jungle}; DEV=${2:?device}; MINUTES=${3:-1440}; TAG=${4:-soak}; EVERY=${5:-900}; FLAGS=${6:--r}
OUT=/work/bin/soak/$TAG-$DEV; mkdir -p "$OUT"; rm -f "$OUT"/*
ERR_RE='Error:|Exception|Out Of Memory|Unhandled|Stack:'
J=/root/.Garmin/ConnectIQ/Devices/$DEV/simulator.json
read -r DX DY DW DH < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$J"); DY=$((DY + 25))
# Settings > Display Mode > (High Power | Always-On); Escape first and after, so a stray open menu never takes a click
sim_mode() {
  xdotool key Escape; sleep 0.3; xdotool key Escape; sleep 0.5
  sim_click 73 12 1.5; xdotool mousemove 120 958; sleep 1.5; xdotool key Right; sleep 0.8
  [ "$1" = aod ] && { xdotool key Down; sleep 0.4; }
  xdotool key Return; sleep 4; xdotool key Escape; sleep 0.3
}
sim_boot; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
sim_load "$JUNGLE" "$DEV" $FLAGS || { echo "build failed" > "$OUT/FAILED"; exit 1; }
sim_24h; sleep 5
echo "utc,n,mode,alive,errors,hash" > "$OUT/samples.csv"
END=$(( $(date +%s) + MINUTES * 60 )); i=0
while :; do
  n=$(printf %03d $i); mode=$([ $((i % 2)) = 0 ] && echo awake || echo aod)
  sim_mode $mode; sleep 60   # a whole minute in the new mode before the picture
  xwd -root -display "$DISPLAY" | convert xwd:- -crop "${DW}x${DH}+${DX}+${DY}" +repage "$OUT/disp-$n-$mode.png"
  w=$(xdotool search --onlyvisible --name "CIQ Simulator" | head -1)
  [ -n "$w" ] && xwd -id "$w" -display "$DISPLAY" | convert xwd:- -gravity SouthWest -crop 320x22+0+0 +repage "$OUT/mem-$n.png"
  hash=$(convert "$OUT/disp-$n-$mode.png" rgb:- | md5sum | cut -c1-12)
  alive=$(pgrep -x simulator >/dev/null && echo yes || echo no)
  errors=$(grep -cE "$ERR_RE" /tmp/md.log 2>/dev/null); cp /tmp/md.log /tmp/sim.log "$OUT/" 2>/dev/null
  echo "$(date -u +%FT%TZ),$n,$mode,$alive,${errors:-0},$hash" >> "$OUT/samples.csv"
  [ "$alive" = no ] && break
  [ "$(date +%s)" -ge "$END" ] && break
  i=$((i + 1)); sleep $((EVERY > 60 ? EVERY - 60 : 0))
done
montage "$OUT"/mem-*.png -tile 6x -geometry +2+2 "$OUT/mem-montage.png" 2>/dev/null
echo "soak done $TAG $DEV $(date -u +%FT%TZ)" | tee "$OUT/DONE"
