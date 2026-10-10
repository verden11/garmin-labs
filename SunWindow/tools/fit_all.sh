#!/bin/bash
# Run the whole suite (screen fit included) on the devices that cover every screen shape and size: 218 to 466 px round,
# the 448x486 rectangle and the two 1-bit Instinct sizes. Usage: tools/fit_all.sh    Prints one line per device.
cd "$(dirname "$0")/.." || exit 2
mkdir -p bin
status=0
for d in fr255s fenix7s fenix7 fenix7x fr265s fr165 epix2 fr965 venu3 venux1 fenix9pro51mm instincte40mm instincte45mm; do
  if tools/run_tests.sh "$d" monkey.jungle > "bin/fit-$d.out" 2>&1; then
    echo "$d PASS $(grep -E '^PASSED' "bin/t-$d.log")"
  else
    echo "$d FAIL"; grep -E "DEBUG|FAILED|ERROR" "bin/t-$d.log" | head -8; status=1
  fi
done
exit $status
