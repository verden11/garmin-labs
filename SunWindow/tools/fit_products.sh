#!/bin/bash
# Run the whole test suite (screen fit included) on EVERY product in manifest.xml, one after another, and write one line
# per product to bin/fit-products<TAG>.txt. Slow (about a minute and a half a product). Each run is in its own container,
# so shards can run at once: `TAG=-a tools/fit_products.sh id1 id2 ...` in several terminals, then `cat bin/fit-products*.txt`.
# Usage: [TAG=-a] tools/fit_products.sh [id ...]   (default: every id in manifest.xml)
cd "$(dirname "$0")/.." || exit 2
mkdir -p bin
OUT="bin/fit-products${TAG:-}.txt"
JUNGLE=${JUNGLE:-monkey.jungle}
ids=("$@")
if [ ${#ids[@]} -eq 0 ]; then
  while read -r id; do ids+=("$id"); done < <(grep -o '<iq:product id="[^"]*"' manifest.xml | sed 's/.*id="//; s/"//')
fi
: > "$OUT"
status=0
for d in "${ids[@]}"; do
  rm -f "bin/t-$d.log"
  if tools/run_tests.sh "$d" "$JUNGLE" > "bin/fit-$d.out" 2>&1; then
    echo "$d PASS $(grep -E '^PASSED' "bin/t-$d.log")" >> "$OUT"
  else
    echo "$d FAIL $(grep -E '^(FAILED|no result)' "bin/fit-$d.out" | head -1)" >> "$OUT"
    status=1
  fi
done
echo "done: $(grep -c PASS "$OUT") pass, $(grep -c FAIL "$OUT") fail" >> "$OUT"
exit $status
