#!/bin/zsh
# Runs the dev unit suite (everyScreenFitsThisDisplay included) per language
# and product. The simulator has no CLI language switch, so each language's
# strings are overlaid on the base resources in a throwaway jungle — the same
# override mechanism resources-store/ uses (ADR-049).
#
#   tools/fit-sweep.sh [-l "eng deu ukr"] <product>...
#
# Prints one line per run; exits 1 if any run failed. Needs the simulator
# running. A run that hangs is killed after RUN_TIMEOUT seconds (restart the
# simulator if several do).
set -u
PROJECT=${0:A:h:h}
SDK_BIN=${SDK_BIN:-$(ls -d "$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/"*/bin | tail -1)}
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
RUN_TIMEOUT=${RUN_TIMEOUT:-300}
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
base.excludeAnnotations = nosync
EOF
    # Same complication rule as monkey.jungle: CIQ 4.2+ products only (ADR-044).
    grep "^$product.resourcePath" $PROJECT/monkey.jungle >> $WORK/$lang.jungle
    prg=$WORK/$lang-$product.prg
    if ! "$SDK_BIN/monkeyc" -t -d $product -f $WORK/$lang.jungle -o $prg -y $KEY > $WORK/build.log 2>&1; then
      echo "$lang $product: BUILD FAILED"; failed=1; continue
    fi
    log=$WORK/$lang-$product.log
    perl -e 'alarm shift; exec @ARGV' $RUN_TIMEOUT "$SDK_BIN/monkeydo" $prg $product -t > $log 2>&1
    result=$(grep -E 'PASSED|FAILED' $log | tail -1)
    [[ $result == PASSED* ]] || failed=1
    echo "$lang $product: ${result:-NO RESULT (timed out?)} $(grep 'px:' $log | sed 's/.*px: //' | sort -u | head -3 | tr '\n' '|')"
  done
done
exit $failed
