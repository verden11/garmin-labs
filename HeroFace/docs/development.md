# Development

Connect IQ SDK 9.2.0, Monkey C. `monkeyc`/`monkeydo` live in the SDK's `bin/`
folder if they aren't on `PATH`
(`~/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk>/bin/`). The signing
key is at `~/.garmin-connectiq/keys/developer_key`, outside every repo, shared
with HeroSet; losing it prevents store updates.

```sh
KEY=~/.garmin-connectiq/keys/developer_key

monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y $KEY
monkeydo bin/HeroFace.prg fr965              # simulator must be running

monkeyc -t -d fr965 -f monkey.jungle -o bin/t-fr965.prg -y $KEY
monkeydo bin/t-fr965.prg fr965 -t            # 16 tests

monkeyc -e -r -f monkey.jungle -o dist/HeroFace.iq -y $KEY   # store package
```

Trust the printed `PASSED (…)` line, not the exit code. A run that hangs means
the simulator wedged: quit it, restart, run again. It does this every few runs.

## The three test kinds

- **Logic** (`HeroFaceLogicTest`): streak arithmetic, HeroSet's contract, the
  ring average, time wording. No device needed.
- **Screen fit** (`everyStateFitsThisDisplay`): renders the face's widest
  states with the device's real fonts and fails on text leaving the round
  display or overlapping another row. Run it per screen size after any layout
  or string change:
  ```sh
  for d in fr55 fenix5s fenix5 vivoactive4 fenix7x fr265s fr165 epix2 fr965 fenix9pro51mm; do
    monkeyc -t -d $d -f monkey.jungle -o bin/t-$d.prg -y $KEY
    monkeydo bin/t-$d.prg $d -t everyStateFitsThisDisplay
  done
  ```
  Those ten cover every screen size from 208 to 466 px.
- **Live language** (`everyLabelFitsThisLanguage`): renders the labels of
  whichever language the simulator is set to. Set the language in the
  simulator (Settings → System → Language), then run it. Do this for the long
  ones after any label change: German, Dutch, Finnish, Lithuanian, Ukrainian.

`heroFaceLayoutReport` prints every row's box, the resolved slot metrics and
the device's capability flags. It is how layout is checked here, because this
environment cannot capture the simulator.

## Translations

English lives in `resources/strings/strings.xml`; each other language is a
`resources-<lang>/strings/strings.xml` with the same ids. Every id and
placeholder must match English exactly — check with:

```sh
python3 - <<'PY'
import re, glob
base = dict(re.findall(r'<string id="([^"]+)">(.*?)</string>', open('resources/strings/strings.xml').read(), re.S))
for f in sorted(glob.glob('resources-*/strings/strings.xml')):
    d = dict(re.findall(r'<string id="([^"]+)">(.*?)</string>', open(f).read(), re.S))
    miss, extra = set(base) - set(d), set(d) - set(base)
    if miss or extra: print(f, 'missing', sorted(miss), 'extra', sorted(extra))
    for k in set(base) & set(d):
        if sorted(re.findall(r'\$\d\$', base[k])) != sorted(re.findall(r'\$\d\$', d[k])):
            print(f, k, 'placeholder mismatch')
PY
```

A new language also needs its `<iq:language>` line in `manifest.xml`.

Watch labels are uppercase and have a short form for narrow columns; the face
measures and picks the longest wording that fits, so a long translation
degrades instead of clipping. Weekday and month names come from the system, so
they are already translated.

## Device testing

The simulator proves geometry, fonts and logic. It cannot prove always-on
behaviour, battery cost, MIP daylight contrast, or the HeroSet link, which
needs two apps on real firmware. Builds and a tick list for that live in
`../../device-test/` (git-ignored, so one folder holds both apps).
