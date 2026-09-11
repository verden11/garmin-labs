# Compatibility strategy

HeroSet will support as many Garmin devices as practical without promising
sensor features that a device cannot provide.

## Support tiers

### Full support

- Automatic repetition estimates
- Manual entry and correction
- Daily progress and gamification
- Optional GPS-based 10 km Pro mode

### Partial support

- Manual repetition entry and correction
- Daily progress and gamification
- Automatic counting limited or unavailable when the device lacks suitable
  motion-sensor capabilities

### Unsupported

Devices that cannot meet the app's minimum Connect IQ/API, display, input, or
sensor requirements will not be listed as supported products.

## Expansion policy

The Forerunner 965 is the initial development target. Before adding a product
to `manifest.xml`, check it against a capability matrix covering:

- Accelerometer access and usable sensor sample rates
- Display size, shape, and color capabilities
- Buttons and touchscreen behavior
- Persistent storage
- GPS and activity recording
- Memory and runtime constraints

Device-specific behavior must be guarded at runtime where required. Product
support should be expanded only after testing the actual advertised features
on that device family.
