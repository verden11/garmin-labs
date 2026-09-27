#!/bin/zsh
# Fails if code reachable from the glance process calls anything that is not
# (:glance) (ADR-051). The default build (and -l 2) prints nothing for such a
# call, and the failure only shows on the watch, so this builds both jungles,
# app and tests, at -l 3 and looks only for the scope message. -l 3 also prints
# a lot of unrelated type errors that predate the glance; they are ignored here.
#
#   tools/glance-scope-check.sh [product...]     (default: fr965)
#
# Prints each offending line; exits 1 if there is any.
set -u
PROJECT=${0:A:h:h}
SDK_BIN=${SDK_BIN:-$(ls -d "$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/"*/bin | tail -1)}
KEY=${KEY:-$HOME/.garmin-connectiq/keys/developer_key}
OUT=$(mktemp -d)
trap 'rm -rf "$OUT"' EXIT
cd $PROJECT
products=(${@:-fr965})
hits=0
for product in $products; do
  for jungle in monkey store; do
    for tests in "" "-t"; do
      found=$("$SDK_BIN/monkeyc" $tests -d $product -f $jungle.jungle -o $OUT/scope.prg -y $KEY -w -l 3 2>&1 | grep "not available in all function scopes")
      if [[ -n $found ]]; then
        echo "$product $jungle ${tests:-app}:"
        echo $found
        hits=1
      fi
    done
  done
done
(( hits )) && exit 1
echo "glance scope: clean for $products"
