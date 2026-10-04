# Listing screenshots for Two Suns, native simulator pixels, set up with the simulator's own clock and settings.
# Run: ../docker/capture.sh TwoSuns tools/listing_shots.sh <free|pro> [candidate ...]   (writes listing[-free]/screens/*.png)
# Sourced by docker/capture.sh inside the container (cwd = a private copy of the project; /work is the real folder).
# Simulator values (sun times, Body Battery, curve) are canned: pictures only, never a claim about readings.
# Pro shots switch the weather row and the watch battery row OFF in the private copy (ADR-022/023: no claim before a wrist
# check, and the simulator's weather is canned); the listing does not describe either row.
# Optional args after the tier: names from the list below (default: the whole set).
TIER=${1:?free|pro}; shift
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; PROPS=resources-free/settings/properties.xml
else JUNGLE=monkey.jungle; OUT=/work/listing/screens; PROPS=resources-pro/settings/properties.xml; fi
set_prop() {   # set_prop <key> <value>: the default a phone setting would have written
  sed -i "s|<property id=\"$1\" type=\"\([a-z]*\)\">[^<]*</property>|<property id=\"$1\" type=\"\1\">$2</property>|" "$PROPS"
}
[ "$TIER" = pro ] && { set_prop Weather 0; set_prop Battery 0; }
# Private copy only (the app code under TwoSuns/source is NOT changed). The simulator's canned sun times belong to Kansas and read
# in this container's UTC (sunrise 12:17, sunset after midnight: a "sunset earlier than the sunrise"), so the ring would look broken
# and golden hour could not draw. Both tiers get fixed Garmin-style sunrise 06:05 / sunset 17:32 (21900 / 63120 s, the NOAA times
# for 51.5 N, 0 E on 4 October, UTC clock). Pro also gets that place as its remembered place (no GPS in the simulator) and a
# hand-made 24 h curve of 15-minute samples ending at the clock (the simulator's history is dated in the future: one dot).
# The Body Battery number the Complication would give (random in the simulator: 15, 24, 59 on three runs) is fixed at 59.
# Everything here is canned: it shows the design, never a reading.
perl -pi -e 's/complicationNumber\(Complications\.COMPLICATION_TYPE_SUNRISE\)/21900/; s/complicationNumber\(Complications\.COMPLICATION_TYPE_SUNSET\)/63120/; s/complicationNumber\(Complications\.COMPLICATION_TYPE_BODY_BATTERY\)/59/' source/TwoSunsSources.mc
if [ "$TIER" = pro ]; then
cat >/tmp/curve.txt <<'MC'
            var values = [] as Array<Numeric or Null>;
            var whens = [] as Array<Number or Null>;
            var hs = [0.0, 3.0, 6.0, 9.0, 12.0, 15.0, 17.0, 20.0, 24.0];
            var vs = [59.0, 66.0, 78.0, 92.0, 70.0, 45.0, 30.0, 40.0, 58.0];
            for (var i = 0; i < 96; i += 1) {
                var h = (95 - i) * 0.25;
                var k = 0;
                while (k < hs.size() - 2 && h > hs[k + 1]) { k += 1; }
                values.add(vs[k] + (vs[k + 1] - vs[k]) * (h - hs[k]) / (hs[k + 1] - hs[k]));
                whens.add(epoch - (95 - i) * 900);
            }
MC
perl -0pi -e 'BEGIN{local $/; open F,"/tmp/curve.txt"; $r=<F>; close F} s/            var iterator = .*?\n(?=            return TwoSunsBattery\.build)/$r/s' source/TwoSunsSources.mc
perl -0pi -e 's/var fresh = TwoSunsPlace\.pick\(\[[^;]*\);/var fresh = [51.5, 0.0] as Array<Float>;/' source/TwoSunsSources.mc
grep -n -e "fresh = \[" -e "var hs" source/TwoSunsSources.mc
fi
shot() {   # shot <file> <device> <HH:MM clock> <accent id> [golden 0|1]
  set_prop Accent "$4"; [ "$TIER" = pro ] && set_prop Golden "${5:-0}"
  # the simulator keeps the last run settings in APP.SET (every build is /tmp/app.prg): a stale accent beat the new default on the small round shot
  pkill -f monkeydo; pkill -x simulator; sleep 3; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/APP.SET /tmp/app-settings.json
  sim_boot "2026-10-04 $3:00"; sim_load $JUNGLE "$2"; sim_24h; sleep 5; sim_save "$OUT/$1"
}
# The final sets (upload order). shot <file> <device> <HH:MM UTC clock> <accent id> [golden]; accent ids: 0 sky 1 mint 2 autumn 3 violet 4 pink 5 winter
if [ "$TIER" = pro ]; then
  ALL="1-day 2-golden-hour 3-evening 4-instinct-e45 5-small-fr255s"
else
  ALL="1-day 2-evening 3-accent-pink 4-instinct-e45 5-small-fr255s"
fi
for w in ${*:-$ALL}; do case $TIER-$w in
  pro-1-day)           shot 1-day.png fr965 10:09 0;;
  pro-2-golden-hour)   shot 2-golden-hour.png fr965 16:50 3 1;;
  pro-3-evening)       shot 3-evening.png fr965 20:40 1;;
  pro-4-instinct-e45)  shot 4-instinct-e45.png instincte45mm 10:09 0;;
  pro-5-small-fr255s)  shot 5-small-fr255s.png fr255s 10:09 4;;
  free-1-day)          shot 1-day.png fr965 10:09 0;;
  free-2-evening)      shot 2-evening.png fr965 20:40 1;;
  free-3-accent-pink)  shot 3-accent-pink.png fr965 13:20 4;;
  free-4-instinct-e45) shot 4-instinct-e45.png instincte45mm 10:09 0;;
  free-5-small-fr255s) shot 5-small-fr255s.png fr255s 10:09 3;;
  *) echo "unknown $TIER-$w" >&2;;
esac; done
echo scenario done
