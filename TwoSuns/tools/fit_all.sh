#!/bin/bash
# Run the screen-fit tests on the ten v1 devices that cover every screen size (218 to 466 px).
# Usage: tools/fit_all.sh [jungle]    (default monkey.jungle = Pro; monkey.free.jungle = Free)  Prints one line per device.
cd "$(dirname "$0")/.." || exit 2
JUNGLE=${1:-monkey.jungle}
status=0
for d in fr255s fenix7s fenix7 fenix7x fr265s fr165 epix2 fr965 venusq2 fenix9pro51mm; do
  if tools/run_tests.sh "$d" "$JUNGLE" > "bin/fit-$d.out" 2>&1; then
    echo "$d PASS $(grep -E '^PASSED' "bin/t-$d.log")"
  else
    echo "$d FAIL"; grep -E "DEBUG.*(overlap|y=)" "bin/t-$d.log" | head -8; status=1
  fi
done
exit $status
