#!/bin/zsh
# Runs the test suite (everyStateFitsThisDisplay included) once per language on
# the products given. The simulator has no CLI language switch, so each
# language's strings are overlaid on the base resources in a throwaway jungle.
# The weekday and month words still come from the simulator's own language
# (English), so only our own captions and names are checked in translation.
#
#   tools/fit_languages.sh [-l "eng deu ukr"] <product>...
#
# Prints one line per run; exits 1 if any run failed. Needs the simulator running.
set -u
PROJECT=${0:A:h:h}
SDK_BIN=${SDK_BIN:-$(dirname "$(command -v monkeyc)")}
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
RUN_TIMEOUT=${RUN_TIMEOUT:-150}
LANGS=(eng dan deu dut fin fre ita lit nob pol por spa swe tur ukr)
if [[ ${1:-} == -l ]]; then LANGS=(${=2}); shift 2; fi
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
failed=0
for product in "$@"; do
  for lang in $LANGS; do
    overlay=$WORK/$lang/strings
    mkdir -p $overlay
    if [[ $lang == eng ]]; then src=$PROJECT/resources; else src=$PROJECT/resources-$lang; fi
    cp $src/strings/strings.xml $overlay/
    cat > $WORK/$lang.jungle <<EOF
project.manifest = $PROJECT/manifest.xml
base.sourcePath = $PROJECT/source
base.resourcePath = $PROJECT/resources;$WORK/$lang
EOF
    prg=$WORK/$lang-$product.prg
    if ! "$SDK_BIN/monkeyc" -t -d $product -f $WORK/$lang.jungle -o $prg -y $KEY > $WORK/build.log 2>&1; then
      echo "$lang $product: BUILD FAILED"; head -3 $WORK/build.log; failed=1; continue
    fi
    log=$WORK/$lang-$product.log
    for attempt in 1 2; do
      perl -e 'alarm shift; exec @ARGV' $RUN_TIMEOUT "$SDK_BIN/monkeydo" $prg $product -t > $log 2>&1
      grep -qE 'PASSED|FAILED' $log && break
      # The simulator wedges every few runs: restart it once and retry.
      pkill -f monkeydo; pkill -f "ConnectIQ.app/Contents/MacOS"; sleep 3
      (nohup "$SDK_BIN/connectiq" >/dev/null 2>&1 &); sleep 10
    done
    result=$(grep -E 'PASSED|FAILED' $log | tail -1)
    # The word tests assert English wording, so in another language they are expected to error;
    # only the two fit tests decide.
    fit=$(grep -E '^(everyStateFitsThisDisplay|alwaysOnFrameFitsAtEveryDrift) ' $log | tr -s ' ' | tr '\n' ';')
    [[ $fit == *PASS*PASS* ]] || failed=1
    echo "$lang $product: ${result:-NO RESULT} fit=[$fit] $(grep 'px:' $log | sed 's/.*px: //' | sort -u | head -3 | tr '\n' '|')"
  done
done
exit $failed
