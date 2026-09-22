# Straying playtest

Browser distribution of Straying Through the Fog.

Copyright 2026 Hironori 'Tom' SAKAI, Akane YATA, Hizakake LLC.

This repository contains the browser runtime and game assets only. Research records and server-side Apps Script configuration are not included.

Play: https://dokkorase.github.io/straying-playtest/

## Release verification — 2026-09-22

- Based on development commit `9519105951f8d9aadf345d020ce701ba2f6107e7` plus the current local game UI, language files and audio assets.
- Corrected a redundant closing block in `tyrano/data/system/KeyConfig.js` that prevented the keyboard configuration from loading.
- Verified the public URL, notice screen, title, START (new game), opening narrative, forest background, choices, and two successful research receiver acknowledgements after Q001.
- No browser errors or warnings were observed during the public smoke test.
- The post-game survey URLs are still placeholders. End-of-game flush and survey navigation have not been tested end to end on this deployment.
- Full English QA, full playthrough, and device compatibility checks remain pending.

## Updating this distribution

GitHub Pages publishes `main` from the repository root. Keep `.nojekyll`, `index.html`, `scripts/`, and `tyrano/` together: the game imports `../scripts/index.js`.

This is a separate deployment snapshot, not an automatic mirror of the development branch. Copy only reviewed runtime changes and game assets into this repository before committing and pushing. Do not copy Apps Script server files, research exports, local backups, or development repository history. The deployment receiver URL is intentionally browser-visible; it is not a secret credential.
