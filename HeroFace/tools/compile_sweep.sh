#!/bin/bash
# Compile (not run) every product in the manifest for both jungles: Free (monkey.free.jungle) and Pro
# (monkey.jungle). Compiling never needs the simulator, so it is safe to run whoever holds it. This proves
# every product builds with zero warnings; it is not a render or fit sweep (tools/run_tests.sh does that). Usage: tools/compile_sweep.sh [jungle ...]   (default: both)
# -> bin/compile-sweep-<jungle>.txt, exit 1 on any FAIL. The two jungles run one after the other. Do NOT run two sweeps (or a
# sweep and an export or test build) at once in this folder: they share bin/gen and bin/mir, and parallel runs gave spurious
# "critical error" and empty FAILs on 2026-10-01. A FAIL with no message: re-run that product alone before believing it.
# Warnings fail a product too (-w is on), except the launcher-icon size notice: the 65 px launcher icon scales on
# non-65 px screens (the icon is the owner's call, docs/decisions.md ADR-001). Those are counted, not failed.
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
