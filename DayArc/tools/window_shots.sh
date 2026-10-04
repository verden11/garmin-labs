# Review screenshots (NOT listing images): one native-pixel capture per time window per device, 24-hour clock, the simulator's
# own clock set inside each window. Simulator data is canned or random, so these prove layout, not readings.
# Run: ../docker/capture.sh DayArc tools/window_shots.sh <simple|pro> "<HH:MM ...>" <device>...
#   e.g. ../docker/capture.sh DayArc tools/window_shots.sh simple "07:15 13:15 20:00 23:40" fr965 fr255s
# Writes DayArc/bin/shots/<density>-<device>-<HHMM>.png (bin/ is not tracked; listing*/screens is never touched).
# ACTIVITY=1 also sets steps/floors/calories (Pro's grid), which costs about 70 s a scene.
DENSITY=${1:?simple|pro}; TIMES=${2:?"HH:MM ..."}; shift 2
if [ "$DENSITY" = pro ]; then JUNGLE=monkey.pro.jungle; else JUNGLE=monkey.simple.jungle; fi
OUT=/work/bin/shots; mkdir -p "$OUT"
for dev in "$@"; do
  for t in $TIMES; do
    sim_boot "2026-10-04 $t:00"; sim_load $JUNGLE "$dev"; sim_24h; sleep 5
    if [ "$DENSITY" = pro ] && [ -n "${ACTIVITY:-}" ]; then sim_activity goal=10000 steps=5310 moderate=18 floors=7 calories=1650; sleep 70; fi
    sim_save "$OUT/$DENSITY-$dev-${t/:/}.png"
  done
done
echo window shots done
