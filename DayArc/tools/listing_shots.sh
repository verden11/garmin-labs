# Listing screenshots for DayArc / DayArc Pro: one per time window, native simulator pixels, the simulator's own clock set
# to about halfway through each window (the arc is progress through the current window). Simulator data is fake.
# Run: ../docker/capture.sh DayArc tools/listing_shots.sh <simple|pro>   (writes listing/screens or listing-pro/screens)
DENSITY=${1:?simple|pro}
if [ "$DENSITY" = pro ]; then JUNGLE=monkey.pro.jungle; OUT=/work/listing-pro/screens; else JUNGLE=monkey.simple.jungle; OUT=/work/listing/screens; fi
DAY="2026-10-04"

scene() {   # scene <file> <device> <HH:MM> [steps so far today]
  sim_boot "$DAY $3:00"; sim_load $JUNGLE "$2"; sim_24h; sleep 5
  [ "$DENSITY" = pro ] && { sim_activity goal=10000 steps=${4:-8420} moderate=18 floors=7 calories=1650; sleep 70; }
  sim_save "$OUT/$1"
}
if [ "$DENSITY" = pro ]; then
  scene 1-midday.png fr965 13:15 5310
  scene 2-evening.png fr965 20:00
  scene 3-morning.png fr965 07:15 842   # early in the day: a three-digit count fits the narrow bottom pill
  scene 4-night.png fr965 23:40
else
  scene 1-morning.png fr965 07:15
  scene 2-midday.png fr965 13:15
  scene 3-evening.png fr965 20:00
  scene 4-night.png fr965 23:40
fi
# the Instinct E and 3 Solar (black and white; the arc is a gauge in the round window)
scene 5-instinct-midday.png instincte45mm 13:15
scene 6-instinct-evening.png instincte45mm 20:00
echo scenario done
