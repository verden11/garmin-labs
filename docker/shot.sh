#!/bin/bash
# Screenshot what the simulator draws, per device: the face on its device skin, with the real fonts and the real bezel
# mask (an Instinct's corners are hidden: a unit test that measures a plain square cannot see that).
# Usage: docker/shot.sh <project-dir> <jungle> <device>...        e.g. docker/shot.sh DaysToGo monkey.jungle instinct2
#   Writes <project-dir>/bin/shot-<device>.png (the whole simulator window) and shot-<device>-face.png (the display, 3x).
#   Env: FAKETIME="2026-10-04 07:15:00" (the simulator's clock), WAIT=30 (seconds to let the face draw), SCALE=300 (percent), FLAGS="-w" (extra monkeyc flags),
#        PREP='<shell run first in the private project copy>' (for example a sed on resources/properties.xml to
#        show a particular state; the repo itself is never touched), CIQ_IMAGE (default verden-ciq-shots:9.2.0).
# The simulator shows the clock of the container (UTC); CIQ_TZ=<zone> (for example Pacific/Honolulu) moves it, so a face that
# changes by time of day can be shown in each window.
set -e
PROJ=$(cd "${1:?usage: shot.sh <project-dir> <jungle> <device>...}" && pwd); JUNGLE=${2:?jungle}; shift 2
IMG=${CIQ_IMAGE:-verden-ciq-shots:9.2.0}
DEV=${CIQ_DEVICES:-$HOME/Library/Application Support/Garmin/ConnectIQ/Devices}
mkdir -p "$PROJ/bin"
for d in "$@"; do
  read -r x y w h < <(jq -r '.display.location | "\(.x) \(.y) \(.width) \(.height)"' "$DEV/$d/simulator.json")
  y=$((y + 25))   # the simulator's menu bar
  CIQ_FAKETIME=${FAKETIME:-} CIQ_IMAGE=$IMG "$(dirname "$0")/run.sh" "$PROJ" /ciq-docker/ciq-run.sh bash -c "
    ${PREP:-:}
    monkeyc -d $d -f $JUNGLE -o bin/shot-$d.prg -y /keys/developer_key ${FLAGS:--w} >/dev/null 2>&1 || { echo '$d: build failed'; exit 1; }
    (monkeydo bin/shot-$d.prg $d >/dev/null 2>&1 &); sleep ${WAIT:-30}
    xwd -root -display \$DISPLAY | convert xwd:- /work/bin/shot-$d.png
    convert /work/bin/shot-$d.png -crop ${w}x${h}+${x}+${y} +repage -scale ${SCALE:-300}% /work/bin/shot-$d-face.png
    pkill -f monkeydo; true"
  echo "$d: $PROJ/bin/shot-$d-face.png"
done
