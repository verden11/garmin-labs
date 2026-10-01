#!/bin/bash
# Run a command in a fresh container: own simulator, own network namespace, so any number can run at once.
# Usage: docker/run.sh <project-dir> <cmd...>    e.g. docker/run.sh DayArc /ciq-docker/ciq-test.sh fr965
# CIQ_IMAGE=verden-ciq-build:9.2.0 for native-speed builds/sweeps (no simulator); default is the simulator image.
set -e
PROJ=$(cd "${1:?usage: run.sh <project-dir> <cmd...>}" && pwd); shift
IMG=${CIQ_IMAGE:-verden-ciq:9.2.0}
KEYS=${CIQ_KEYS:-$HOME/.garmin-connectiq/keys}
exec docker run --rm --platform "$(docker image inspect -f '{{.Os}}/{{.Architecture}}' "$IMG")" \
  ${MC_FLAGS+-e MC_FLAGS} ${EXPECT+-e EXPECT} \
  -v "$PROJ":/work -v "$(cd "$(dirname "$0")" && pwd)":/ciq-docker:ro -v "$KEYS":/keys:ro \
  -w /work "$IMG" "${@:-bash}"
