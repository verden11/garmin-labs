#!/bin/bash
# In-container: private project copy + Xvfb + simulator, then run the given command there.
# Usage (cwd = project folder): ciq-run.sh tools/fit_languages.sh [args...]
# Private copy because monkeyc writes gen/ mir/ internal-mir/ next to the sources.
set -u
W=/tmp/w; mkdir -p $W
tar -C /work --exclude=./bin --exclude=./gen --exclude=./mir --exclude=./internal-mir --exclude=./external-mir \
    --exclude=./dist --exclude=./.git -cf - . | tar -C $W -xf -
cd $W && mkdir -p bin
Xvfb "$DISPLAY" -screen 0 1280x1024x24 >/dev/null 2>&1 &
sleep 2
# CIQ_FAKETIME="2026-10-04 07:15:00" starts the simulator on that clock (docker/shot.sh FAKETIME=; needs the shots image)
${CIQ_FAKETIME:+faketime -f "@$CIQ_FAKETIME"} simulator >/tmp/sim.log 2>&1 &
sleep 8
exec "$@"
