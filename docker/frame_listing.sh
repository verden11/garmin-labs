#!/bin/bash
# Frames every screenshot of one listing in its watch (docker/frame_shot.sh), from <listing>/src/frames.txt:
#   <upload name> <device> [scale% or -] [source, default screens/<upload name>]   one line per image; '#' starts a comment
#   (an Instinct's source is its native capture, screens/native/..., not the x3 upload file)
# Writes <listing>/screens-framed/<same name>, the files to upload, and bin/framed-preview.png (all of them on a dark card,
# to judge the keyed edges). Fails on a file over the store's 150 KB cap. Run in the shots image, from the repo root:
#   CIQ_IMAGE=verden-ciq-shots:9.2.0 docker/run.sh <project> bash /ciq-docker/frame_listing.sh <listing dir, e.g. listing-pro>
set -e
L=${1:?listing dir}; cd /work/"$L"; mkdir -p screens-framed /work/bin
over=0; previews=()
while read -r file dev scale src; do
  case "$file" in ''|'#'*) continue;; esac
  [ "$scale" = - ] && scale=; bash /ciq-docker/frame_shot.sh "$dev" "${src:-screens/$file}" "screens-framed/$file" $scale
  [ "$(stat -c %s "screens-framed/$file")" -lt 150000 ] || { echo "OVER 150 KB: $file"; over=1; }
  convert -size 720x720 xc:'#0b1626' "screens-framed/$file" -composite -resize 360x360 "/tmp/p-$file"; previews+=("/tmp/p-$file")
done < src/frames.txt
convert "${previews[@]}" +append "/work/bin/framed-preview-$L.png"
exit $over
