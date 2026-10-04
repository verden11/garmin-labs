# Listing screenshots for HeroFace (everyday mode: the simulator runs one app at a time, so HeroSet never publishes its
# complication there; HeroSet-mode shots stay a watch capture, see listing/screenshots.md). Native simulator pixels.
# Run: ../docker/capture.sh HeroFace tools/listing_shots.sh <free|pro>      (writes listing[-free]/screens/new-*.png)
TIER=${1:?free|pro}
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; else JUNGLE=monkey.jungle; OUT=/work/listing/screens; fi
NOW="2026-10-04 10:09:00"

set_prop() { sed -i "s|<property id=\"$1\" type=\"\([a-z]*\)\">[^<]*</property>|<property id=\"$1\" type=\"\1\">$2</property>|" resources-$TIER/settings/properties.xml; }
scene() {   # scene <file> <device> <goal> <steps> <moderate> <floors> [history: steps for yesterday, the day before, ...]
  local file=$1 device=$2 goal=$3 steps=$4 mod=$5 floors=$6; shift 6
  local hist=; [ $# -gt 0 ] && hist="history=$(echo "$@" | tr ' ' ',')"
  sim_boot "$NOW"; sim_load $JUNGLE "$device"
  sim_activity goal=$goal steps=$steps moderate=$mod floors=$floors $hist
  sleep 75; sim_save "$OUT/$file"
}
H=10000
# part-way through the day, a 4-day streak behind it
scene new-1-everyday.png fr965 10000 8420 18 7 $H $H $H $H 3000 3000 3000
# every goal met
scene new-2-goals-met.png fr965 10000 10400 24 12 $H $H $H $H $H 3000 3000
# the Instinct family (black and white; the ring is a gauge in the round window)
scene new-3-instinct2.png instinct2 10000 8420 18 7 $H $H $H 3000 3000 3000 3000
scene new-4-instinct-e40.png instincte40mm 10000 8420 18 7 $H $H $H 3000 3000 3000 3000
if [ "$TIER" = pro ]; then
  # Pro only: seconds on (the temperature is on by default)
  set_prop Seconds true
  scene new-5-seconds.png fr965 10000 8420 18 7 $H $H $H $H 3000 3000 3000
fi
echo scenario done
