# Review screenshots (NOT listing images): one native-pixel capture per time window per device, 24-hour clock, the simulator's
# own clock set inside each window. Simulator data is canned or random, so these prove layout, not readings.
# Run: ../docker/capture.sh DayArc tools/window_shots.sh <simple|pro|pro-activity> "<HH:MM ...>" <device>...
#   e.g. ../docker/capture.sh DayArc tools/window_shots.sh simple "07:15 13:15 20:00 23:40" fr965 fr255s
# Writes DayArc/bin/shots/<simple|pro>-<device>-<HHMM>.png (bin/ is not tracked; listing*/screens is never touched).
# pro-activity is Pro with steps/floors/calories set (the grid shows numbers, not zeros), which costs about 70 s a scene.
MODE=${1:?simple|pro|pro-activity}; TIMES=${2:?"HH:MM ..."}; shift 2
case $MODE in pro-activity-*) STEPS=${MODE#pro-activity-}; MODE=pro-activity;; esac   # pro-activity-10432 = that step count (default 5310)
DENSITY=${MODE%%-*}
if [ "$DENSITY" = pro ]; then JUNGLE=monkey.pro.jungle; else JUNGLE=monkey.simple.jungle; fi
OUT=/work/bin/shots; mkdir -p "$OUT"
for dev in "$@"; do
  for t in $TIMES; do
    sim_boot "2026-10-04 $t:00"; sim_load $JUNGLE "$dev"; sim_24h; sleep 5
    if [ "$MODE" = pro-activity ]; then sim_activity goal=10000 steps=${STEPS:-5310} moderate=18 floors=7 calories=1650; sleep 70; fi
    sim_save "$OUT/$DENSITY-$dev-${t/:/}.png"
    [ -s "$OUT/$DENSITY-$dev-${t/:/}.png" ] || { sleep 5; sim_save "$OUT/$DENSITY-$dev-${t/:/}.png"; }   # a save sometimes misses its menu
  done
done
echo window shots done
