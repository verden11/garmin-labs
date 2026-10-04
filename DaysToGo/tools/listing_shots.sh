# Listing screenshots for Days To Go, native simulator pixels, set up with the simulator's own clock and settings.
# Run: ../docker/capture.sh DaysToGo tools/listing_shots.sh <free|pro>      (writes listing[-free]/screens/*.png)
# Sourced by docker/capture.sh inside the container (cwd = a private copy of the project; /work is the real folder).
TIER=${1:?free|pro}
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; else JUNGLE=monkey.jungle; OUT=/work/listing/screens; fi
NOW="2026-10-04 10:09:00"   # a Sunday morning; every count below is from this date

set_prop() {   # set_prop <key> <value>: the default a phone setting would have written
  sed -i "s|<property id=\"$1\" type=\"\([a-z]*\)\">[^<]*</property>|<property id=\"$1\" type=\"\1\">$2</property>|" resources-$TIER/settings/properties.xml
}
event() {      # event <name> <month> <day> <year> [unit] [hour-setting] [footer]
  set_prop Event 2; set_prop Name "$1"; set_prop Month "$2"; set_prop Day "$3"; set_prop Year "$4"; set_prop Unit "${5:-0}"
  [ "$TIER" = pro ] && { set_prop Hour "${6:-0}"; set_prop Footer "${7:-0}"; }
  return 0
}
shot() {       # shot <file> <device> [wait-seconds-after-load]
  sim_boot "$NOW"; sim_load $JUNGLE "$2"; sleep "${3:-0}"; sim_save "$OUT/$1"
}

# 1. the default: New Year's Day, nothing set
shot 1-new-year.png fr965
# 2. a named event, counted in weeks and days
event "70.3" 11 18 2026 1; shot 2-weeks.png fr965
# 3. the day itself
event "Birthday" 10 4 2026; shot 3-today.png fr965
# 4. a small round screen (218 px, 64 colours; the fr55 is an 8-colour screen and would not show the real palette)
event "Race" 11 18 2026; shot 4-small-fr255s.png fr255s
# 5. the Instinct family (black and white, the ring is a gauge in the round window)
event "Race" 11 18 2026; shot 5-instinct2.png instinct2
event "Race" 11 18 2026; shot 6-instinct-e40.png instincte40mm
if [ "$TIER" = pro ]; then
  # Pro only: a timed event counts the last 24 hours as H:MM; the bottom line shows battery or steps
  # (no event name here: on the fr965 a name, the date and the bottom line together leave the hero too little room, so the face drops the bottom line first)
  event "" 10 4 2026 0 19 1; shot 7-hours-battery.png fr965
  event "" 11 18 2026 0 0 2
  sim_boot "$NOW"; sim_load $JUNGLE fr965; sim_activity steps=6420; sleep 70; sim_save "$OUT/8-steps-line.png"
fi
echo scenario done
