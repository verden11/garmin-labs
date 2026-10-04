#!/bin/sh
# Runs in a PRIVATE copy of the project only (docker/shot.sh runs it as PREP inside the container; never run it on the repo):
# turns the face into a watch-app whose first view opens the real on-watch date picker, because the simulator cannot open
# Customize on a watch face (docs/compatibility.md "Measured 2026-10-04").
# Env: YEARFIRST=1 (see below), MONTH=9 DAY=30 YEAR=0 are the picker's starting values (September is the longest English month name).
set -e
sed -i 's/type="watchface"/type="watch-app"/' manifest.xml manifest.free.xml
sed -i 's/private function pushDatePicker/function pushDatePicker/' source/settings/DaysToGoSettingsDelegate.mc
sed -i 's/return \[new DaysToGoView()\];/return [new HarnessView()];/' source/DaysToGoApp.mc
cat > source/HarnessView.mc <<'EOT'
import Toybox.Lang;
import Toybox.WatchUi;
class HarnessView extends WatchUi.View {
    private var _done as Boolean = false;
    function initialize() { View.initialize(); }
    function onShow() as Void {
        if (!_done) { _done = true; new DaysToGoSettingsDelegate().pushDatePicker(); }
    }
}
EOT
# YEARFIRST=1: the year column (the widest label, "Every year") starts focused, as if the wearer had scrolled to it.
if [ -n "${YEARFIRST:-}" ]; then
  sed -i 's/monthFirst ? \[months, days, years\] : \[days, months, years\]/[years, days, months]/; s/monthFirst ? \[monthIndex, dayIndex, yearIndex\] : \[dayIndex, monthIndex, yearIndex\]/[yearIndex, dayIndex, monthIndex]/' source/settings/DaysToGoSettingsDelegate.mc
fi
for f in resources-pro/settings/properties.xml resources-free/settings/properties.xml; do
  [ -f "$f" ] || continue
  for kv in Month=${MONTH:-9} Day=${DAY:-30} Year=${YEAR:-0}; do
    sed -i "s|\(<property id=\"${kv%%=*}\" type=\"number\">\)[^<]*\(</property>\)|\1${kv#*=}\2|" "$f"
  done
done
