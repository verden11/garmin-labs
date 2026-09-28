#!/bin/bash
# Compile (not run) every product in manifest.simple.xml for both jungles. Compiling never needs the
# simulator (knowledge/platform-facts.md "Tooling"), so this is safe to run regardless of who holds
# it. This proves every product builds; it is not a render or fit sweep — see tools/run_tests.sh for
# that, on whichever devices need real per-device screen-fit confirmation.
set -u
cd "$(dirname "$0")/.." || exit 2
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
mkdir -p bin
ids=()
while read -r id; do ids+=("$id"); done < <(grep -o '<iq:product id="[^"]*"' manifest.simple.xml | sed 's/.*id="//; s/"//')
for jungle in monkey.simple.jungle monkey.pro.jungle; do
  out="bin/compile-sweep-${jungle%.jungle}.txt"
  : > "$out"
  for d in "${ids[@]}"; do
    if monkeyc -d "$d" -f "$jungle" -o "bin/c-$d.prg" -y "$KEY" -w --typecheck 3 > "bin/c-$d.log" 2>&1; then
      echo "$d PASS" >> "$out"
    else
      echo "$d FAIL $(grep -E '^ERROR' "bin/c-$d.log" | head -1)" >> "$out"
    fi
    rm -f "bin/c-$d.prg"
  done
  echo "done ($jungle): $(grep -c PASS "$out") pass, $(grep -c FAIL "$out") fail" >> "$out"
done
