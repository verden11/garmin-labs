# Store listing pack

Everything the Connect IQ Store submission needs, drafted so far as it can be
without the watch. Files here:

| File | What it is |
|---|---|
| `listing.md` | The listing copy. English is written; fields you must supply are marked **FILL** |
| `descriptions.md` | The short description in all 15 languages |
| `screenshots.md` | The captured set, where each came from, and how to re-render the composed images |

Read `../go-to-market.md` before submitting: it holds the gates, the decisions
already made, and the claims that are forbidden until something is measured on
a watch.

Images live in `../../listing/` (not in `docs/`, because they are artefacts):
`screens/1-everyday.png` … `5-no-barometer.png`, `cover-500.png` (500×500),
`hero-1440x720.png`, and the optional device icons `icon-24-128.png` /
`icon-64-128.png` (128×128). Generators in `listing/src/`, adapted from
HeroSet's; the form fields they answer are listed in
`../../../HeroSet/docs/store-release.md`.

Submission itself (from the SDK's publishing guide): upload the `.iq` file,
then fill in description, screenshots and details. Review takes about 72 hours,
and a rejection comes back with specific reasons.

Build the upload package with:

```sh
monkeyc -e -r -f monkey.jungle -o bin/HeroFace.iq -y ~/.garmin-connectiq/keys/developer_key
```
