#!/bin/bash
# In-container twin of each project's tools/run_tests.sh (same arguments, same exit codes):
#   ciq-test.sh <device> [jungle] [testName] [expectedCount]     (EXPECT=<n> in the environment also works)
# Builds in a private copy of the project, so any number of containers can share one project folder.
# Exit 0 only on a PASSED line (monkeydo's own exit code is always 1). 2 compile, 3 no result, 4 count mismatch.
set -u
DEVICE=${1:?usage: ciq-test.sh <device> [jungle] [testName] [expectedCount]}
JUNGLE=monkey.jungle; [ -f monkey.jungle ] || JUNGLE=monkey.simple.jungle   # DayArc has no monkey.jungle
TEST=; EXPECT=${EXPECT:-}
if [[ ${2:-} == *.jungle ]]; then JUNGLE=$2; TEST=${3:-}; EXPECT=${4:-$EXPECT}; else TEST=${2:-}; fi
KEY=${KEY:-/keys/developer_key}
MC_FLAGS=${MC_FLAGS--w --typecheck 3}   # HeroSet builds without these: MC_FLAGS=""

# monkeyc writes gen/ mir/ internal-mir/ next to the sources: build in a private copy, return only bin/t-*.
W=/tmp/w; mkdir -p $W /work/bin
tar -C /work --exclude=./bin --exclude=./gen --exclude=./mir --exclude=./internal-mir --exclude=./external-mir \
    --exclude=./dist --exclude=./.git -cf - . | tar -C $W -xf -
cd $W && mkdir -p bin
PRG=bin/t-$DEVICE.prg LOG=bin/t-$DEVICE.log
monkeyc -t -d "$DEVICE" -f "$JUNGLE" -o "$PRG" -y "$KEY" $MC_FLAGS || exit 2

Xvfb "$DISPLAY" -screen 0 1280x1024x24 >/dev/null 2>&1 &
sleep 2
start_simulator() { pkill -x simulator 2>/dev/null; sleep 2; simulator >/tmp/sim.log 2>&1 & sleep 8; }
run_once() {
  : > $LOG
  monkeydo "$PRG" "$DEVICE" -t $TEST > $LOG 2>&1 &
  for _ in $(seq 1 60); do sleep 2; grep -qE "^(PASSED|FAILED)" $LOG && break; done
  pkill -f monkeydo 2>/dev/null
  grep -E "^(PASSED|FAILED)|ERROR|Ran " $LOG | tail -8
  grep -qE "^(PASSED|FAILED)" $LOG
}
start_simulator
if ! run_once; then
  echo "no result: simulator wedged, restarting once"
  start_simulator
  run_once || { cp $LOG /work/bin/; echo "no result after restart"; exit 3; }
fi
cp $PRG $LOG /work/bin/
grep -q "^PASSED" $LOG || exit 1
if [ -n "$EXPECT" ]; then
  got=$(sed -n 's/^PASSED (passed=\([0-9]*\).*/\1/p' $LOG | tail -1)
  [ "$got" = "$EXPECT" ] || { echo "expected $EXPECT tests to pass, the run reported ${got:-none}"; exit 4; }
fi
