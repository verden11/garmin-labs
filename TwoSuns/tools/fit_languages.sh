#!/bin/zsh
# Runs the test suite (the two fit tests included) once per language on
# the products given. The simulator has no CLI language switch, so each
# language's strings are overlaid on the base resources in a throwaway jungle.
# The test states use fixed English date lines ("Wed 30 Sep"), so only our own sentences and words
# are checked in translation, not the date line's width in each language.
#
#   [TIER=free] tools/fit_languages.sh [-l "eng deu ukr"] <product>...      (TIER defaults to pro)
#
# Prints one line per run; exits 1 if any run failed. Needs the simulator running.
set -u
# Runs in a container by default (own simulator, no pkill, parallel-safe: ../../docker/README.md). CIQ_DOCKER=0 = host simulator.
[[ -z ${CIQ_IN_DOCKER:-} && ${CIQ_DOCKER:-1} != 0 ]] && exec "${0:A:h:h:h}/docker/run.sh" "${0:A:h:h}" /ciq-docker/ciq-run.sh "tools/${0:t}" "$@"
PROJECT=${0:A:h:h}
SDK_BIN=${SDK_BIN:-$(dirname "$(command -v monkeyc)")}
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
RUN_TIMEOUT=${RUN_TIMEOUT:-150}
TIER=${TIER:-pro}
# The settings files are in several folders, in the order the phone shows them (see monkey.jungle); the Instinct products leave out the
# Accent and Golden folders (ADR-024).
if [[ $TIER == free ]]; then MANIFEST=manifest.free.xml JUNGLE=monkey.free.jungle EXCLUDE=pro ALL="resources:resources-free:resources-accent-free" INSTINCT="resources:resources-free"
else MANIFEST=manifest.xml JUNGLE=monkey.jungle EXCLUDE=free ALL="resources:resources-accent-pro:resources-pro:resources-golden-pro:resources-pro-tail" INSTINCT="resources:resources-pro:resources-pro-tail"; fi
paths() { local out="" p; for p in ${(s/:/)1}; do out+="$PROJECT/$p;"; done; echo "$out"; }
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
project.manifest = $PROJECT/$MANIFEST
base.sourcePath = $PROJECT/source
base.resourcePath = $(paths $ALL)$WORK/$lang
base.excludeAnnotations = $EXCLUDE;mono;norect
EOF
    # The Instinct products: the black-and-white palette and no Accent or Golden file, as the real jungle has (ADR-024).
    if grep -q "^$product.excludeAnnotations" $PROJECT/$JUNGLE; then
      echo "$product.excludeAnnotations = $EXCLUDE;color;rect" >> $WORK/$lang.jungle
      echo "$product.resourcePath = $(paths $INSTINCT)$WORK/$lang" >> $WORK/$lang.jungle
    fi
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
