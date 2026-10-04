#!/bin/bash
# Screenshot the real on-watch date picker per device, through the container (docker/shot.sh + tools/picker_harness.sh).
# Usage (from the repo root): DaysToGo/tools/picker_shot.sh <jungle> <device>...   -> DaysToGo/bin/shot-<device>-face.png
# Env: YEARFIRST=1 (the year column focused), MONTH, DAY, YEAR (starting values, default 9 / 30 / 0 = the widest labels), WAIT (seconds, default 35).
# Simulator only: the harness is a watch-app, not the watch face, so memory and backgrounds are the harness's.
cd "$(dirname "$0")/../.." || exit 1
export PREP="YEARFIRST=${YEARFIRST:-} MONTH=${MONTH:-9} DAY=${DAY:-30} YEAR=${YEAR:-0} sh tools/picker_harness.sh"
export WAIT=${WAIT:-35}
exec docker/shot.sh DaysToGo "$@"
