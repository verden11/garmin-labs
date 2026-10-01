#!/bin/bash
# Build the test package for one device and run it in the simulator, restarting
# the simulator once if it wedges (it does that every few runs).
# Usage: tools/run_tests.sh <device> [jungle] [testName]
#   e.g. tools/run_tests.sh fr965                                  (Pro, monkey.jungle)
#        tools/run_tests.sh fr965 monkey.free.jungle               (Free)
#        tools/run_tests.sh fr965 monkey.jungle everyStateFitsThisDisplay
# Both tiers run the same suite; the (:pro)/(:free) tests are compiled into only their own tier (ADR-014 (Free + Pro ladder)).
# Exit 0 only when the simulator prints a PASSED line. Trust that line, not monkeydo's exit code.
set -u
# Runs in a container by default (own simulator, no pkill, parallel-safe: ../docker/README.md). CIQ_DOCKER=0 = host simulator.
[ -z "${CIQ_IN_DOCKER:-}" ] && [ "${CIQ_DOCKER:-1}" != 0 ] && exec "$(dirname "$0")/../../docker/run.sh" "$(dirname "$0")/.." /ciq-docker/ciq-test.sh "$@"
DEVICE=${1:?usage: tools/run_tests.sh <device> [jungle] [testName]}
JUNGLE=monkey.jungle
TEST=
# Second argument is a jungle if it ends in .jungle; otherwise it is the test name (the old form: <device> [testName]).
if [[ ${2:-} == *.jungle ]]; then JUNGLE=$2; TEST=${3:-}; else TEST=${2:-}; fi
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
SDK_BIN=$(dirname "$(command -v monkeyc)")
mkdir -p bin
monkeyc -t -d "$DEVICE" -f "$JUNGLE" -o "bin/t-$DEVICE.prg" -y "$KEY" -w --typecheck 3 || exit 2

start_simulator() {
  pkill -f monkeydo 2>/dev/null; pkill -f "ConnectIQ.app/Contents/MacOS" 2>/dev/null; sleep 3
  (nohup "$SDK_BIN/connectiq" >/dev/null 2>&1 &)
  sleep 10
}

run_once() {
  local log="bin/t-$DEVICE.log"
  : > "$log"
  "$SDK_BIN/monkeydo" "bin/t-$DEVICE.prg" "$DEVICE" -t $TEST > "$log" 2>&1 &
  for _ in $(seq 1 60); do
    sleep 2
    grep -qE "^(PASSED|FAILED)" "$log" && break
  done
  pkill -f monkeydo 2>/dev/null
  grep -E "^(PASSED|FAILED)|ERROR|Ran " "$log" | tail -8
  grep -qE "^(PASSED|FAILED)" "$log"
}

pgrep -f "ConnectIQ.app/Contents/MacOS" >/dev/null || start_simulator
if ! run_once; then
  echo "no result: simulator wedged, restarting once"
  start_simulator
  run_once || { echo "no result after restart"; exit 3; }
fi
grep -q "^PASSED" "bin/t-$DEVICE.log"
