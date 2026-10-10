# support-me — Claude Code Context

This repository is the source of truth for ChiefGyk3D's support/tipping details.
It serves the static site at [support.chiefgyk3d.com](https://support.chiefgyk3d.com)
and defines the signature block used across every ChiefGyk3D repository.

## The signature block

**`SIGNATURE.md` is authoritative.** Read it before touching a support/tipping
block in this or any other ChiefGyk3D repository.

The support block at the bottom of every README is an **expected signature**, not
an optional extra. A new repository gets it; an existing one keeps it. It is
identical across all repositories apart from the project name and any preserved
repository-specific footer lines.

The traps, in short — `SIGNATURE.md` has the full reasoning:

- All four currencies appear, **Solana included**.
- Icons are **vendored** in `media/icons/`, never hotlinked to a CDN.
- Every icon needs an explicit `fill`. Upstream simple-icons SVGs have none, so
  they render black and vanish on GitHub's dark theme.
- Four icons use a documented substitute colour because their brand value is
  black or near-black: Ethereum, Patreon, TikTok, Matrix.
- No `style="..."` attributes — GitHub's README sanitiser strips them.

## Wallet addresses

Never edit an address without being asked to. When changing one, update
`SIGNATURE.md`, `README.md`, `index.html`, the `media/qr-*.png` codes, **and**
every other repository carrying the block.

## Site

`index.html` and `style.css` are the live site. `media/` holds committed
artifacts — the logo, social icons, wallet QR codes, and the README's
`icons/` set — not scratch space.
