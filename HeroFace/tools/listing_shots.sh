# Listing screenshots for HeroFace, native simulator pixels, both tiers. Run (one tier per container run):
#   ../docker/capture.sh HeroFace tools/listing_shots.sh <free|pro> [only these files, e.g. 3-goals-met.png 5-instincte40mm-166.png]
# Writes listing[-free]/screens/*.png. The private copy of the project (never the repo) is edited per scene: settings the
# way a user would set them (properties.xml) and, for HeroSet mode only, a canned HeroSet value (see heroset_on).
TIER=${1:?free|pro}; shift; ONLY="$*"
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; else JUNGLE=monkey.jungle; OUT=/work/listing/screens; fi
NOW="2026-10-04 10:09:00"
H=10000

set_prop() { sed -i "s|<property id=\"$1\" type=\"\([a-z]*\)\">[^<]*</property>|<property id=\"$1\" type=\"\1\">$2</property>|" resources-$TIER/settings/properties.xml; }
# HeroSet mode: the simulator runs one app at a time, so the face never sees HeroSet's complication. The private copy's
# HeroFaceLink is patched to report "linked" and to parse a canned value (HeroSet ADR-044 field order:
# v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal; the day key is the simulator's date). The drawing after that is the real path.
LINK=source/HeroFaceLink.mc
cp $LINK /tmp/HeroFaceLink.orig
heroset_on() {   # heroset_on <push> <sit> <squat> <rank> <rankPct> <streak>
  cp /tmp/HeroFaceLink.orig $LINK
  sed -i -e "s#return _id != null;#return true;#" \
         -e "s#return _id != null ? HeroFaceContract.parse(_raw, today, yesterday) : null;#return HeroFaceContract.parse(\"1|20261004|$1|$2|$3|$4|$5|$6|20261003|100\", today, yesterday);#" $LINK
}
heroset_off() { cp /tmp/HeroFaceLink.orig $LINK; }

scene() {   # scene <file> <device> <goal> <steps> <moderate> <floors> [history: steps for yesterday, the day before, ...]
  local file=$1 device=$2 goal=$3 steps=$4 mod=$5 floors=$6; shift 6
  [ -z "$ONLY" ] || [[ " $ONLY " == *" ${file##*/} "* ]] || return 0   # a re-run of some pictures: ... free 3-goals-met.png
  local hist=; [ $# -gt 0 ] && hist="history=$(echo "$@" | tr ' ' ',')"
  # The simulator keeps an app's settings (APP.SET) between loads, so a changed default would be ignored (as in DaysToGo).
  sim_boot "$NOW"; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json; sim_load $JUNGLE "$device"
  sim_activity goal=$goal steps=$steps moderate=$mod floors=$floors calories=1650 $hist
  sleep 75; case $file in /*) sim_save "$file";; *) sim_save "$OUT/$file";; esac   # an absolute file goes where it says
}
PART="10000 8420 18 7 $H $H $H $H 3000 3000 3000"     # part-way through the day
DONE="10000 10400 24 12 $H $H $H $H $H 3000 3000"     # every goal met

# Upload order, both tiers: 1 everyday, 2 the tier's own screen, 3 goals met, 4 HeroSet mode, 5 Instinct.
# Round, FR965 (454 px)
scene 1-everyday.png fr965 $PART
if [ "$TIER" = pro ]; then
  # what Pro adds: a metric per bar (move bar, steps, intensity minutes), seconds beside the time, the pale magenta accent
  set_prop Accent 2; set_prop Seconds true; set_prop Slot1 6; set_prop Slot2 1; set_prop Slot3 3
  scene 2-your-bars.png fr965 $PART
  set_prop Accent 0; set_prop Seconds false; set_prop Slot1 0; set_prop Slot2 0; set_prop Slot3 0
else
  # Free: the accent colour; magenta is only used by the hero (src/hero-magenta.png)
  set_prop Accent 1; scene 2-accent-cyan.png fr965 $PART
  set_prop Accent 2; scene /work/listing-free/src/hero-magenta.png fr965 $PART
  set_prop Accent 0
fi
scene 3-goals-met.png fr965 $DONE
heroset_on 60 45 28 2 40 3; scene 4-heroset.png fr965 $PART; heroset_off

# the Instinct family (1-bit: no accent; the ring is a gauge in the round window); Pro is sold for the Instinct E and 3 only
scene "$OUT/native/5-instincte40mm-166.png" instincte40mm $DONE   # then src/instinct-up.html makes screens/5-instinct-e40.png (x3, nearest-neighbour)
echo scenario done
