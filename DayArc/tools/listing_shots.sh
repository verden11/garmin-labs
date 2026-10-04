# Listing screenshots for DayArc / DayArc Pro (5 each): native simulator pixels, a 24-hour clock, the simulator's own clock set
# to about halfway through each window (the arc is progress through the current window). Simulator data is canned or random.
# Run: ../docker/capture.sh DayArc tools/listing_shots.sh <simple|pro>   (writes listing/screens or listing-pro/screens)
# The five (same order in both tiers): 1 morning, 2 midday, 3 evening, 4 the one setting (accent colour), 5 the Instinct E 40 mm
# (black and white). Night is left out on purpose (time and date only). Stress and Body Battery are random per run.
DENSITY=${1:?simple|pro}
if [ "$DENSITY" = pro ]; then JUNGLE=monkey.pro.jungle; OUT=/work/listing-pro/screens; else JUNGLE=monkey.simple.jungle; OUT=/work/listing/screens; fi
DAY="2026-10-04"

# Settings > Set Position (the dialog takes "latitude, longitude"). The simulator's default is Olathe, Kansas, whose sun times
# (12:17 / 23:59, in the simulator's UTC) read as nonsense beside a 07:17 clock in the Pro morning grid; London's read 06:05 / 17:33.
sim_position() {
  sim_click 73 12 1.5
  eval "$(xdotool getwindowgeometry --shell "$(xdotool search --onlyvisible --name simulator | tail -1)")"
  sim_click $((X + 60)) $((Y + 908)) 2
  xdotool type --delay 25 "$1"; xdotool key Return; sleep 2
}
set_accent() { sed -i "s|<property id=\"Accent\" type=\"number\">[0-9]*</property>|<property id=\"Accent\" type=\"number\">$1</property>|" resources/settings/properties.xml; }

scene() {   # scene <file> <device> <HH:MM> [steps so far today] [accent 0-6] [position]
  set_accent "${5:-0}"
  sim_boot "$DAY $3:00"; sim_load $JUNGLE "$2"; sim_24h; sleep 5
  [ -n "${6:-}" ] && sim_position "$6"
  [ "$DENSITY" = pro ] && { sim_activity goal=10000 steps=${4:-8420} moderate=18 floors=7 calories=1650; sleep 70; }
  sim_save "$OUT/$1"
}
LONDON="51.5074, -0.1278"
if [ "$DENSITY" = pro ]; then
  scene 1-morning.png fr965 07:15 842 0 "$LONDON"   # early in the day: a three-digit step count fits the narrow bottom pill
  scene 2-midday.png fr965 13:15 5310
  scene 3-evening.png fr965 20:00 8420
  scene 4-accent-blue.png fr965 20:00 8420 5
else
  scene 1-morning.png fr965 07:15
  scene 2-midday.png fr965 13:15
  scene 3-evening.png fr965 20:00
  scene 4-accent-purple.png fr965 13:15 0 6
fi
# the Instinct E 40 mm (black and white; the arc is a gauge in the round window; no Accent there)
scene 5-instinct-evening.png instincte40mm 20:00 8420
echo scenario done
