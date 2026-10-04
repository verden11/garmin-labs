#!/bin/bash
# Run a listing-screenshot scenario in a container: its own Xvfb, the project mounted at /work (so files written under
# /work/... land in the project), the dev key at /keys. The scenario sources /ciq-docker/sim-gui.sh.
# Usage: docker/capture.sh <project-dir> <scenario.sh> [args...]     (scenario paths are relative to the project)
#   PREP is not applied for you: a scenario that needs a different default setting seds a copy of the project itself.
set -e
PROJ=$(cd "${1:?usage: capture.sh <project-dir> <scenario.sh> [args...]}" && pwd); SCEN=${2:?scenario}; shift 2
IMG=${CIQ_IMAGE:-verden-ciq-shots:9.2.0}
KEYS=${CIQ_KEYS:-$HOME/.garmin-connectiq/keys}
exec docker run --rm --platform linux/amd64 -e DISPLAY=:1 \
  -v "$PROJ":/work -v "$(cd "$(dirname "$0")" && pwd)":/ciq-docker:ro -v "$KEYS":/keys:ro -w /work "$IMG" \
  bash -c 'Xvfb :1 -screen 0 1280x1024x24 >/dev/null 2>&1 & sleep 2
           W=/tmp/w; mkdir -p $W; tar -C /work --exclude=./bin --exclude=./dist --exclude=./.git -cf - . | tar -C $W -xf -
           cd $W && mkdir -p bin && source /ciq-docker/sim-gui.sh && source "$0" "$@"' "$SCEN" "$@"
