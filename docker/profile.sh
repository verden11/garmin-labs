# Profile one face in the simulator (never device proof: the host's timings, not the watch's). A scenario for docker/capture.sh:
#   docker/capture.sh <project> /ciq-docker/profile.sh <jungle> <device> [seconds 30] [tag profile]
# A -k build opens the Profiler window by itself and it collects from launch, so: Stop (that table is the STARTUP: initialize,
# the first onUpdate with the whole stack dry run), Start, wait, Stop (that table is steady state). Writes
# /work/bin/profile/<tag>-<device>/ in the project (bin/ is untracked):
#   startup-by-{total,calls}-1.png   the startup table, sorted by time with callees / Call Count
#   by-{actual,total,calls}-{1,2,3}.png  the steady-state table sorted by self time / time with callees / Call Count, three pages
#   APP.PRF                          the simulator's own capture: open it later with the profiler's Load button
# Call Count is the number to trust: it does not depend on how fast the simulator draws. Divide it by onUpdate's count for calls per frame.
# Coordinates read off the 1200x600 Profiler window at the screen's top left (2026-10-10, fr965, SDK 9.2.0); the splitter is dragged
# right first so Average Time and Call Count are visible. A header click flips the sort order whatever column it is on: ORDER tracks it.
JUNGLE=${1:?jungle}; DEV=${2:?device}; SECS=${3:-30}; TAG=${4:-profile}
OUT=/work/bin/profile/$TAG-$DEV; mkdir -p "$OUT"; rm -f "$OUT"/*
shot() { import -window root -crop 1200x600+0+0 "$1"; }
ORDER=asc
sort_desc() {   # <header x>
  sim_click "$1" 77 1; [ $ORDER = asc ] && ORDER=desc || ORDER=asc
  [ $ORDER = asc ] && { sim_click "$1" 77 1; ORDER=desc; }
  xdotool mousemove 300 300; xdotool click --repeat 300 --delay 5 4; sleep 1   # wheel up: back to the top
}
pages() {   # <name> <header x> <pages>
  sort_desc "$2"
  for p in $(seq "$3"); do shot "$OUT/$1-$p.png"; xdotool click --repeat 6 --delay 50 5; sleep 1; done
}
sim_boot; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
sim_load "$JUNGLE" "$DEV" -r -k || { echo "build failed" > "$OUT/FAILED"; exit 1; }
xdotool search --onlyvisible --name "Profiler" | head -1 | grep -q . || { echo "no Profiler window" > "$OUT/FAILED"; exit 1; }
sim_click 1154 557 2      # Stop: the collection running since launch
xdotool mousemove 602 300 mousedown 1; sleep 0.5; xdotool mousemove 900 300; sleep 0.3; xdotool mousemove 1150 300; sleep 0.3; xdotool mouseup 1; sleep 1
pages startup-by-total 390 1; pages startup-by-calls 775 1
sim_click 1154 557 2      # Start
sleep "$SECS"
sim_click 1154 557 3      # Stop
pages by-actual 520 3; pages by-total 390 3; pages by-calls 775 3
cp /tmp/com.garmin.connectiq/GARMIN/APPS/LOGS/APP.PRF "$OUT/" 2>/dev/null
echo "profile done $TAG $DEV $(date -u +%FT%TZ)" | tee "$OUT/DONE"
