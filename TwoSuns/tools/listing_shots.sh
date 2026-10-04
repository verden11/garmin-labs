# Listing screenshots for Two Suns, native simulator pixels (PREPARED, NOT YET RUN FOR THE LISTING: the owner wants layout
# changes first, 2026-10-04). Re-run after the look is final; simulator values (sun times, Body Battery, weather) are canned.
# Run: ../docker/capture.sh TwoSuns tools/listing_shots.sh <free|pro>      (writes listing[-free]/screens/new-*.png)
TIER=${1:?free|pro}
if [ "$TIER" = free ]; then JUNGLE=monkey.free.jungle; OUT=/work/listing-free/screens; else JUNGLE=monkey.jungle; OUT=/work/listing/screens; fi
shot() {   # shot <file> <device> <HH:MM clock>
  sim_boot "2026-10-04 $3:00"; sim_load $JUNGLE "$2"; sim_24h; sleep 5; sim_save "$OUT/$1"
}
shot new-1-day.png fr965 10:09
shot new-2-evening.png fr965 18:30
shot new-3-instinct-e45.png instincte45mm 10:09
shot new-4-instinct-3solar.png instinct3solar45mm 18:30
echo scenario done
