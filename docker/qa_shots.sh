# QA captures of a watch face: one fresh simulator per clock time, the face's default settings, the simulator's own data
# (so the empty and zero states are what shows), native display pixels plus the whole window (its status bar shows memory).
# A scenario for docker/capture.sh (simulator only, never device proof):
#   docker/capture.sh <project> /ciq-docker/qa_shots.sh <jungle> <device> <tag> <HH:MM>...
#   a <tag> starting with "h24" switches Settings > Time Display to 24-hour (the simulator starts on 12-hour). Environment
#   variables do NOT reach the container (capture.sh passes none), which is why this is the tag and not H24=1.
# Writes <project>/bin/qa/<tag>-<device>-<HHMM>[-24h].png and ...-window.png.
JUNGLE=${1:?jungle}; DEV=${2:?device}; TAG=${3:?tag}; shift 3
OUT=/work/bin/qa; mkdir -p $OUT; DAY=2026-10-05
for t in "$@"; do
  sim_boot "$DAY $t:00"; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
  sim_load "$JUNGLE" "$DEV"
  suffix=""; case $TAG in h24*) sim_24h; suffix="-24h";; esac
  sleep 5
  f=$OUT/$TAG-$DEV-${t/:/}$suffix.png
  sim_save "$f"
  w=$(xdotool search --onlyvisible --name "CIQ Simulator" | head -1); [ -n "$w" ] && xwd -id "$w" -display "$DISPLAY" | convert xwd:- "${f%.png}-window.png"
done
echo "qa done $TAG $DEV"
