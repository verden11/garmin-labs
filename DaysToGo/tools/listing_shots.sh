# Listing screenshots for Days To Go, native simulator pixels, set up with the simulator's own clock and settings. The five-image set of each listing.
# Run: ../docker/capture.sh DaysToGo tools/listing_shots.sh <free|pro>      (writes listing[-free]/screens/*.png; the Instinct one to screens/native/)
# Then: tools/render_listing.sh <free|pro> screens   (the Instinct capture enlarged x3), and tools/check_listing_images.sh
# Sourced by docker/capture.sh inside the container (cwd = a private copy of the project; /work is the real folder).
TIER=${1:?free|pro}
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; else JUNGLE=monkey.jungle; OUT=/work/listing/screens; fi
NOW="2026-10-04 10:09:00"   # a Sunday morning; every count below is from this date

set_prop() {   # set_prop <key> <value>: the default a phone setting would have written
  sed -i "s|<property id=\"$1\" type=\"\([a-z]*\)\">[^<]*</property>|<property id=\"$1\" type=\"\1\">$2</property>|" resources-$TIER/settings/properties.xml
}
event() {      # event <name> <month> <day> <year> <unit 0 days|1 weeks> <hour-setting, Pro> <footer 0|1 battery|2 steps, Pro> <accent 0 mint|1 amber|2 sky|3 pink|4 violet>
  set_prop Event 2; set_prop Name "$1"; set_prop Month "$2"; set_prop Day "$3"; set_prop Year "$4"; set_prop Unit "${5:-0}"; set_prop Accent "${8:-0}"
  [ "$TIER" = pro ] && { set_prop Hour "${6:-0}"; set_prop Footer "${7:-0}"; }
  return 0
}
fresh() {      # restart the simulator on NOW with no stored settings: it keeps an app's settings (APP.SET) between loads, so a changed default would be ignored
  sim_boot "$NOW"; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
}
shot() {       # shot <file> <device>
  fresh; sim_load $JUNGLE "$2"; sim_save "$OUT/$1"
}

mkdir -p "$OUT/native"
if [ "$TIER" = free ]; then
  # 1. days, a named event, amber accent
  event "Wedding" 3 14 2027 0 0 0 1; shot 1-days-amber.png fr965
  # 2. weeks and days, sky accent
  event "70.3" 11 18 2026 1 0 0 2; shot 2-weeks-sky.png fr965
  # 3. the day itself, pink accent
  event "Birthday" 10 4 2026 0 0 0 3; shot 3-today-pink.png fr965
  # 4. a rectangular screen (Venu Sq 2), violet accent
  event "Race" 11 18 2026 0 0 0 4; shot 4-rectangle.png venusq2
  # 5. the Instinct family: black and white, the ring is a gauge in the round window (instinct2; Free may use any Instinct)
  event "Race" 11 18 2026 0 0 0 0; shot native/5-instinct2-176.png instinct2
else
  # 1. a timed event: the last 24 hours as H:MM (event today 18:00), the battery on the date row, mint accent
  event "Flight" 10 4 2026 0 19 1 0; shot 1-hours-battery.png fr965
  # 2. weeks and days with the steps on the date row, sky accent (the activity data is set by hand: canned, not a real reading)
  event "70.3" 11 18 2026 1 0 2 2; fresh; sim_load $JUNGLE fr965; sim_activity steps=6420; sleep 70; sim_save "$OUT/2-weeks-steps.png"
  # 3. days with the battery line, pink accent
  event "Wedding" 3 14 2027 0 0 1 3; shot 3-days-battery.png fr965
  # 4. a rectangular screen (Venu Sq 2): hours, amber accent (the bottom line is not drawn on the rectangle)
  event "Flight" 10 4 2026 0 19 1 1; shot 4-rectangle.png venusq2
  # 5. the Instinct family on a watch Garmin lists for paid apps (Instinct E 40 mm; the Instinct 2 family and Descent G1 are not on that list): hours
  event "Flight" 10 4 2026 0 19 1 0; shot native/5-instincte40mm-166.png instincte40mm
fi
echo scenario done
