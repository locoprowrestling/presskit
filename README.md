# presskit

The LoCo Pro Wrestling press kit (EPK). Single-page static site, no build step.

- **Domain:** `press.locopro.pw` (set in `CNAME`)
- **Audience:** local press and community calendars. See the audience decision in
  `/Volumes/LaCie 2TB/locoprowrestling/.knowledgebase/operations/press-kit-content-packet.md`.
- **Deploy model:** plain root serve. GitHub Pages serves the repo root on push.
  Everything in this repo goes live, including `downloads/`, which is intended.

## Local preview

```sh
python3 -m http.server 8080
```

## Content source

All copy comes from the content packet at
`/Volumes/LaCie 2TB/locoprowrestling/.knowledgebase/operations/press-kit-content-packet.md`.
Edit the packet first, then this page, so the two do not drift.

Every fact on the page is verified against
`/Volumes/LaCie 2TB/locoprowrestling/.knowledgebase/operations/`. Before publishing any
change, run the release gate in
`/Volumes/LaCie 2TB/locoprowrestling/.knowledgebase/operations/public-copy-canon-preflight.md`.

## Photo credit, required

All event photography is by CMRice Photography (`https://www.instagram.com/cmricephoto/`).
The credit line is `Photo by CMRice Photography`, one word, capital C, capital M, capital R.
It appears on every gallery caption, in the page footer, and as `PHOTO-CREDIT.txt` inside
both download ZIPs. Do not remove it.

Source library: `/Volumes/LaCie 2TB/locoprowrestling/characterCreator/CMR`.
Web copies are resized to 1400 px wide; the print copies in `downloads/press-photos-print/`
are the untouched 2048 px originals.

## Delete `_roster-review/` before deploy

`_roster-review/` is working material from the photo identification pass: 66 numbered
candidates, the contact sheets, and Aaron's answer files. It is 12 MB and must not ship.
Delete it, or exclude it, before the first push.

The identifications it produced are preserved permanently in
`/Volumes/LaCie 2TB/locoprowrestling/.knowledgebase/operations/cmr-photo-identifications.md`,
so deleting the folder loses nothing.

## Roster photo identification

Nobody had recorded which CMRice photo shows which wrestler. Aaron identified 66 of them
during this build. Before adding any new roster photo, read
`cmr-photo-identifications.md` first, and note its rule: trunks and ring gear are
generally reliable for identity, shirts are not (Franky Gonzales and Michael Avalon
swapped shirts at Vendetta as a storyline beat), and masks are not (Anuka Gutierrez wore
the Nicky Hyde mask at Battle).

## Do not use the illustrated roster art

`TAS-*.png` in the sibling `laststand` repo is cartoon illustration, not photography.
It must never be handed to a newspaper as a picture of a wrestler.

## Regenerating the PDF

The PDF is rendered from `index.html` through the print stylesheet, so it cannot drift
from the page. It is tuned to fit one Letter page; adding content to the printed sections
(`#facts`, `#about`, `#next-show`, `#usage`) will push it to two pages, so re-check the
page count after any edit.

```sh
python3 -m http.server 8099 &
cd /Volumes/LaCie\ 2TB/locoprowrestling/LoCoProGenFactory/music
node -e "
const { chromium } = require('playwright');
(async () => {
  const b = await chromium.launch({ channel: 'chrome' });
  const p = await b.newPage();
  await p.goto('http://localhost:8099/', { waitUntil: 'networkidle' });
  await p.emulateMedia({ media: 'print' });
  await p.pdf({ path: '/Volumes/LaCie 2TB/locoprowrestling/LoCoProWebsites/presskit/downloads/loco-pro-wrestling-press-kit.pdf', format: 'Letter', printBackground: true, margin: { top: '0.4in', bottom: '0.4in', left: '0.4in', right: '0.4in' } });
  await b.close();
})();
"
```

Playwright's bundled Chromium is not installed on this machine; the render uses the
installed Google Chrome through `channel: 'chrome'`.

## Per-show maintenance

The `#next-show` block and the ticket-price line go stale the day a show ends. Update them
and redeploy in the same pass that updates
`/Volumes/LaCie 2TB/locoprowrestling/.knowledgebase/operations/shows.md`.
