# Store listing pack

Everything the Connect IQ Store submission needs, drafted so far as it can be
without the watch. Files here:

| File | What it is |
|---|---|
| `listing.md` | The listing copy. English is written; fields you must supply are marked **FILL** |
| `descriptions.md` | The short description in all 15 languages |
| `screenshots.md` | What to capture, on which devices, and how |

Read `../go-to-market.md` before submitting: it holds the gates, the decisions
already made, and the claims that are forbidden until something is measured on
a watch.

Submission itself (from the SDK's publishing guide): upload the `.iq` file,
then fill in description, screenshots and details. Review takes about 72 hours,
and a rejection comes back with specific reasons.

Build the upload package with:

```sh
monkeyc -e -r -f monkey.jungle -o bin/HeroFace.iq -y ~/.garmin-connectiq/keys/developer_key
```
