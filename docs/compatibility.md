# Compatibility strategy

Support as many Garmin devices as practical; never promise sensor features a
device cannot provide.

## Tiers

- **Full**: automatic rep estimates, manual entry/correction, daily progress +
  gamification.
- **Partial**: automatic counting limited/unavailable when the device lacks
  suitable motion sensing; manual entry, progress, gamification remain.
- **Unsupported**: anything below the app's minimum API / display / input /
  sensor requirements is not listed as a supported product.

## Expansion policy

Initial target: Forerunner 965. Before adding a product to `manifest.xml`,
verify against a capability matrix: accelerometer access + usable sample rates,
display size/shape/color, buttons/touch, persistent storage, GPS + activity
recording, memory/runtime constraints. Guard device-specific behavior at
runtime; expand only after testing advertised features on the actual device
family.