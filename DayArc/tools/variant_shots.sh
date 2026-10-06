# Review screenshots of states the canned simulator does not show by itself (NOT listing images): a non-Auto Accent, or the
# hero read's empty state. The state is made by patching the scenario's PRIVATE copy of the project (the repo is untouched).
# Run: ../docker/capture.sh DayArc tools/variant_shots.sh <accent<N>|noweather|nostress|nobb> <simple|pro> "<HH:MM ...>" <device>...
#   e.g. ../docker/capture.sh DayArc tools/variant_shots.sh noweather simple "07:15" venusq2 venux1
# accent<N> = Accent choice N (1..6, DayArcPalette.ACCENTS order; 5 = blue #55AAFF). Writes DayArc/bin/shots/<variant>-<simple|pro>-<device>-<HHMM>.png.
VARIANT=${1:?accent<N>|noweather|nostress|nobb}; DENSITY=${2:?simple|pro}; TIMES=${3:?"HH:MM ..."}; shift 3
case $VARIANT in
  accent*) perl -pi -e "s/(id=\"Accent\" type=\"number\">)\d+</\${1}${VARIANT#accent}</" resources/settings/properties.xml ;;
  noweather) perl -pi -e 's/return Weather\.getCurrentConditions\(\);/return null;/' source/DayArcSources.mc ;;
  nobb) perl -pi -e 's/var battery = DayArcSources\.complicationNumber\(Complications\.COMPLICATION_TYPE_BODY_BATTERY\);/var battery = null as Number or Null;/' source/DayArcFields.mc ;;
  nostress) perl -pi -e 's/var stress = DayArcSources\.complicationNumber\(Complications\.COMPLICATION_TYPE_STRESS\);/var stress = null as Number or Null;/' source/DayArcFields.mc ;;
  *) echo "unknown variant $VARIANT"; exit 2 ;;
esac
if [ "$DENSITY" = pro ]; then JUNGLE=monkey.pro.jungle; else JUNGLE=monkey.simple.jungle; fi
OUT=/work/bin/shots; mkdir -p "$OUT"
for dev in "$@"; do
  for t in $TIMES; do
    F="$OUT/$VARIANT-$DENSITY-$dev-${t/:/}.png"
    sim_boot "2026-10-04 $t:00"; rm -f /tmp/com.garmin.connectiq/GARMIN/APPS/SETTINGS/*.SET /tmp/app-settings.json
    sim_load $JUNGLE "$dev"; sim_24h; sleep 5
    sim_save "$F"; [ -s "$F" ] || { sleep 5; sim_save "$F"; }
  done
done
echo variant shots done
