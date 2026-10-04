# Listing screenshots for HeroSet on the Instinct family (the existing set is from the FR965, in listing/screens-framed/).
# Native simulator pixels. The day's reps are put in through the app's own HeroSetStore.add, exactly as a saved set would:
# the private project copy is patched to call it once at start (the repo is not touched).
# Run: ../docker/capture.sh HeroSet tools/listing_shots.sh        (writes listing/screens/instinct-*.png)
OUT=/work/listing/screens
NOW="2026-10-04 10:09:00"

seed() {   # seed <pushups> <situps> <squats>
  perl -0pi -e "s/(store\.ensureCurrentDay\(\);)/\$1 store.add(:pushups, $1); store.add(:situps, $2); store.add(:squats, $3);/" source/app/HeroSetApp.mc
}
scene() {   # scene <file> <device> <pushups> <situps> <squats>
  cp /work/source/app/HeroSetApp.mc source/app/HeroSetApp.mc
  seed "$3" "$4" "$5"
  sim_boot "$NOW"; sim_load store.jungle "$2" -r; sim_save "$OUT/$1"
}
scene instinct-1-dashboard.png instinct2 37 52 8
scene instinct-2-complete.png instinct2 100 100 100
scene instinct-3-e40.png instincte40mm 37 52 8
echo scenario done
