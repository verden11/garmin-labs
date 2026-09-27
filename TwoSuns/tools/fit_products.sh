#!/bin/bash
# Run the whole test suite (screen fit included) on EVERY product in manifest.xml, one after another,
# and write one line per product to bin/fit-products.txt. Slow (about a minute a product, and the
# simulator wedges now and then: run_tests.sh restarts it once). Usage: tools/fit_products.sh [id ...]
cd "$(dirname "$0")/.." || exit 2
mkdir -p bin
ids=("$@")
if [ ${#ids[@]} -eq 0 ]; then
  while read -r id; do ids+=("$id"); done < <(grep -o '<iq:product id="[^"]*"' manifest.xml | sed 's/.*id="//; s/"//')
fi
: > bin/fit-products.txt
status=0
for d in "${ids[@]}"; do
  rm -f "bin/t-$d.log"
  if tools/run_tests.sh "$d" > "bin/fit-$d.out" 2>&1; then
    echo "$d PASS $(grep -E '^PASSED' "bin/t-$d.log")" >> bin/fit-products.txt
  else
    echo "$d FAIL $(grep -E '^(FAILED|no result)' "bin/fit-$d.out" | head -1)" >> bin/fit-products.txt
    status=1
  fi
done
echo "done: $(grep -c PASS bin/fit-products.txt) pass, $(grep -c FAIL bin/fit-products.txt) fail" >> bin/fit-products.txt
exit $status
