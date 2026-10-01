#!/bin/bash
# Compile (not run) every product in the manifest for both jungles: Free (monkey.free.jungle) and Pro
# (monkey.jungle). Compiling never needs the simulator, so it is safe to run whoever holds it. This proves
# every product builds with zero warnings; it is not a render or fit sweep (tools/run_tests.sh and
# tools/fit_all.sh do that). Usage: tools/compile_sweep.sh [jungle ...]   (default: both)
# -> bin/compile-sweep-<jungle>.txt, exit 1 on any FAIL. About 20 s a product: run the two jungles in two
# terminals (tools/compile_sweep.sh monkey.jungle  and  tools/compile_sweep.sh monkey.free.jungle) to halve the time.
# Warnings fail a product too (-w is on), except the launcher-icon size notice: the 65 px placeholder icon scales on
# non-65 px screens until the owner's real icon ships (docs/development.md). Those are counted, not failed.
set -u
cd "$(dirname "$0")/.." || exit 2
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
mkdir -p bin
products() { grep -o '<iq:product id="[^"]*"' "$1" | sed 's/.*id="//; s/"//'; }
# The two manifests must offer the same products: a twin on a different list would split the install base silently.
if ! diff <(products manifest.xml) <(products manifest.free.xml) > /dev/null; then
  echo "manifest.xml and manifest.free.xml list different products"; exit 2
fi
ids=()
while read -r id; do ids+=("$id"); done < <(products manifest.xml)
status=0
jungles=("$@")
[ ${#jungles[@]} -gt 0 ] || jungles=(monkey.free.jungle monkey.jungle)
for jungle in "${jungles[@]}"; do
  out="bin/compile-sweep-${jungle%.jungle}.txt"
  : > "$out"
  for d in "${ids[@]}"; do
    if monkeyc -d "$d" -f "$jungle" -o "bin/c-${jungle%.jungle}-$d.prg" -y "$KEY" -w --typecheck 3 > "bin/c-${jungle%.jungle}-$d.log" 2>&1 \
       && ! grep -E '^WARNING' "bin/c-${jungle%.jungle}-$d.log" | grep -qv "launcher icon"; then
      echo "$d PASS$(grep -q 'launcher icon' "bin/c-${jungle%.jungle}-$d.log" && echo ' (launcher-icon notice only)')" >> "$out"
    else
      echo "$d FAIL $(grep -E '^(ERROR|WARNING)' "bin/c-${jungle%.jungle}-$d.log" | grep -v 'launcher icon' | head -1)" >> "$out"
    fi
    rm -f "bin/c-${jungle%.jungle}-$d.prg"
  done
  fails=$(grep -c FAIL "$out")
  echo "done ($jungle): $(grep -c PASS "$out") pass, $fails fail" | tee -a "$out"
  [ "$fails" -eq 0 ] || status=1
done
exit $status
