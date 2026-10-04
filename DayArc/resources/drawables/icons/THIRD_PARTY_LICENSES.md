# Third-party icon sources

The 14 Pro grid icons (`resources-pro/drawables/icons/`) and the stress hero icon
(`resources/drawables/icons/hero_stress_*.svg` and the sized copies in `resources-hero-*/`) are
recoloured, adapted paths from **Tabler Icons** (`filled` and `outline` styles), MIT
licensed. Real paths adapted per `docs/decisions.md` ADR-013 and `DESIGN.md`
"Iconography". The weather and Body Battery hero icons are drawn by
`tools/gen_hero_icons.py` (ADR-017; the battery shell was Tabler's `battery` with its
`activity-heartbeat` line, redrawn in pixel space by ADR-013 amendment 4), so they carry
no Tabler path any more. Not required on-device (icons are compiled
bitmap resources, not redistributed source files), kept here per the MIT
licence's own requirement that the notice ship with copies of the software.

Source: https://github.com/tabler/tabler-icons

## Licence

MIT License

Copyright (c) 2020-2026 Paweł Kuna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
