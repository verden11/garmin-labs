#!/bin/bash
# Run the screen-fit tests on the ten devices that cover every screen size (208 to 466 px).
# Usage: tools/fit_all.sh    Prints one line per device.
cd "$(dirname "$0")/.." || exit 2
status=0
for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
  if tools/run_tests.sh "$d" > "bin/fit-$d.out" 2>&1; then
    echo "$d PASS $(grep -E '^PASSED' "bin/t-$d.log")"
  else
    echo "$d FAIL"; grep -E "DEBUG.*(overlap|y=)" "bin/t-$d.log" | head -8; status=1
  fi
done
exit $status
