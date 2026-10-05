# Listing screenshots for Days To Go, native simulator pixels, set up with the simulator's own clock and settings. The five-image set of each listing.
# Run: ../docker/capture.sh DaysToGo tools/listing_shots.sh <free|pro>      (writes listing[-free]/screens/*.png; the Instinct one to screens/native/)
# Then: tools/render_listing.sh <free|pro> screens   (the Instinct capture enlarged x3), and tools/check_listing_images.sh
# Sourced by docker/capture.sh inside the container (cwd = a private copy of the project; /work is the real folder).
TIER=${1:?free|pro}
ONLY=${2:-}   # optional, quoted: the screen file names to take, e.g. "1-to-the-minute.png 3-other-time-zone.png"; empty = all five
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; else JUNGLE=monkey.jungle; OUT=/work/listing/screens; fi
NOW="2026-10-04 10:09:00"   # a Sunday morning; every count below is from this date

set_prop() {   # set_prop <key> <value>: the default a phone setting would have written
  sed -i "s|<property id=\"$1\" type=\"\([a-z]*\)\">[^<]*</property>|<property id=\"$1\" type=\"\1\">$2</property>|" resources-$TIER/settings/properties.xml
}
event() {      # event <name> <month> <day> <year> <unit 0 days|1 weeks> <hour-setting, Pro> <footer 0|1 battery|2 steps, Pro> <accent 0 mint|1 amber|2 sky|3 pink|4 violet> <minute 0-59, Pro> <zone, Pro: 0 = the watch's, else 49 + minutes/15: 57 = UTC+2, 85 = UTC+9>
  set_prop Event 2; set_prop Name "$1"; set_prop Month "$2"; set_prop Day "$3"; set_prop Year "$4"; set_prop Unit "${5:-0}"; set_prop Accent "${8:-0}"
  [ "$TIER" = pro ] && { set_prop Hour "${6:-0}"; set_prop Footer "${7:-0}"; set_prop Minute "${9:-0}"; set_prop EventZone "${10:-0}"; }
  return 0
}
fresh() {      # restart the simulator on NOW with no stored settings: it keeps an app's settings (APP.SET) between loads, so a changed default would be ignored
  sim_boot "$NOW"; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
}
shot() {       # shot <file> <device>; ONLY="1-to-the-minute.png 3-other-time-zone.png" takes just those (the file names as given below)
  [ -n "${ONLY:-}" ] && [[ " $ONLY " != *" $1 "* ]] && return 0
  fresh; sim_load $JUNGLE "$2"; sim_save "$OUT/$1"
}

mkdir -p "$OUT/native"
if [ "$TIER" = free ]; then
  # 1. days, a named event, amber accent
  event "Wedding" 3 14 2027 0 0 0 1; shot 1-days-amber.png venu3
  # 2. weeks and days, sky accent
  event "70.3" 11 18 2026 1 0 0 2; shot 2-weeks-sky.png fr265
  # 3. the day itself, pink accent
  event "Birthday" 10 4 2026 0 0 0 3; shot 3-today-pink.png epix2pro47mm
  # 4. a rectangular screen (Venu Sq 2), violet accent
  event "Race" 11 18 2026 0 0 0 4; shot 4-rectangle.png venusq2
  # 5. the Instinct family: black and white, the ring is a gauge in the round window (instinct2; Free may use any Instinct)
  event "Race" 11 18 2026 0 0 0 0; shot native/5-instinct2-176.png instinct2
else
  # 1. to the minute, in the zone it starts in: 20:15 at UTC+2 is 18:15 on the watch's UTC clock, so 8:06 from 10:09 (Hour 21 = 20:00, Minute 15, zone 57); battery on the date row, mint accent
  event "Race" 10 4 2026 0 21 1 0 15 57; shot 1-to-the-minute.png venu441mm
  # 2. weeks and days with the steps on the date row, sky accent (the activity data is set by hand: canned, not a real reading)
  event "70.3" 11 18 2026 1 0 2 2
  if [ -z "${ONLY:-}" ] || [[ " $ONLY " == *" 2-weeks-steps.png "* ]]; then fresh; sim_load $JUNGLE fenix847mm; sim_activity steps=6420; sleep 70; sim_save "$OUT/2-weeks-steps.png"; fi
  # 3. the other side of the world: 09:30 on 5 Oct in Tokyo (UTC+9) is 00:30 UTC, so 14:21 from 10:09 on the watch's clock (Hour 10 = 09:00, Minute 30, zone 85); pink accent
  event "Launch" 10 5 2026 0 10 1 3 30 85; shot 3-other-time-zone.png fr970
  # 4. a rectangular screen (Venu Sq 2): hours, amber accent (the bottom line is not drawn on the rectangle)
  event "Flight" 10 4 2026 0 19 1 1; shot 4-rectangle.png venusq2
  # 5. the Instinct family on a watch Garmin lists for paid apps (Instinct E 40 mm; the Instinct 2 family and Descent G1 are not on that list): hours
  event "Flight" 10 4 2026 0 19 1 0; shot native/5-instincte40mm-166.png instincte40mm
fi
echo scenario done
