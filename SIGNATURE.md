# The ChiefGyk3D signature block

The support/tipping block at the bottom of every ChiefGyk3D repository README.
**This is expected, not optional.** A new repository gets it; an existing one
keeps it. It is applied identically across all 21 repositories, and this file is
the source of truth for its content.

The wallet addresses here are the canonical ones. Anything that disagrees with
this file is wrong, including `index.html` in this repository.

| Currency | Address |
|---|---|
| Bitcoin (BTC) | `bc1qztdzcy2wyavj2tsuandu4p0tcklzttvdnzalla` |
| Monero (XMR) | `84Y34QubRwQYK2HNviezeH9r6aRcPvgWmKtDkN3EwiuVbp6sNLhm9ffRgs6BA9X1n9jY7wEN16ZEpiEngZbecXseUrW8SeQ` |
| Ethereum (ETH) | `0x554f18cfB684889c3A60219BDBE7b050C39335ED` |
| Solana (SOL) | `5T8h3HbyvHgLxwXgchRYbHSqRjZyAr8J7uwjLN9Fh8Jh` |

All four currencies appear. Solana is not optional — it was missing from 19 of
21 repositories before this was standardised.

## Rules that are easy to get wrong

**Icons are vendored, never hotlinked.** They live in `media/icons/` in each
repository. Nothing points at jsDelivr or any other CDN, so the block renders
from repository content alone.

**Every icon carries an explicit `fill`.** Upstream simple-icons SVGs set no
fill, so they fall back to the SVG default of black and become invisible against
GitHub's `#0d1117` dark canvas. This is the single most common way the block
breaks. If you regenerate the icons from upstream, you must re-apply the fills.

**Four icons use a substitute colour** because their official brand value is
black or near-black and would fail the dark theme:

| Icon | Official | Used | Why |
|---|---|---|---|
| Ethereum | `#3C3C3D` | `#627EEA` | near-black; this is the ethereum.org diamond blue |
| Patreon | `#000000` | `#FF424D` | Patreon's coral brand colour |
| TikTok | `#000000` | `#EE1D52` | the red of the TikTok logo |
| Matrix | `#000000` | `#8B949E` | no non-black brand colour exists; neutral grey reads on both themes |

The other ten use their official simple-icons value verbatim: Bitcoin `#F7931A`,
Monero `#FF6600`, Solana `#9945FF`, Mastodon `#6364FF`, Bluesky `#1185FE`,
Twitch `#9146FF`, YouTube `#FF0000`, Kick `#53FC19`, Discord `#5865F2`, and the
non-brand Merch Store glyph `#22C55E`. Take brand values from the simple-icons
package rather than from memory.

**No `style="..."` attributes.** GitHub's README sanitiser strips them, so they
do nothing. Sizing goes on `width` and `align`, which GitHub honours.

**StreamElements has no simple-icons entry**, so it uses `media/streamelements.png`.

**No Table of Contents entry.** Repositories with a TOC do not list the support
section, and that convention is deliberate.

**Preserve repository-specific footer lines** that sit below the block, such as
`ChiefGyk3D is the author of ...` or a "star the repo" call to action. Two
repositories have them and one has an entire section after the block.

## The block

Copy verbatim into the README, replacing `{{PROJECT}}` with the project's
display name, and copy `media/icons/` and `media/streamelements.png` alongside it.

````markdown
---

## 💝 Support This Project

If you find {{PROJECT}} useful, consider supporting continued development.
Everything is also collected at **[support.chiefgyk3d.com](https://support.chiefgyk3d.com)**.

### Recurring Support

<div align="center">
<table>
  <tr>
    <td align="center" width="150">
      <a href="https://patreon.com/chiefgyk3d" title="Patreon">
        <img src="media/icons/patreon.svg" width="36" height="36" alt="Patreon"><br>
        <sub><b>Patreon</b></sub>
      </a>
    </td>
    <td align="center" width="150">
      <a href="https://streamelements.com/chiefgyk3d/tip" title="StreamElements">
        <img src="media/streamelements.png" width="36" height="36" alt="StreamElements"><br>
        <sub><b>StreamElements</b></sub>
      </a>
    </td>
    <td align="center" width="150">
      <a href="https://shop.chiefgyk3d.com/" title="Merch Store">
        <img src="media/icons/merch.svg" width="36" height="36" alt="Merch"><br>
        <sub><b>Merch Store</b></sub>
      </a>
    </td>
  </tr>
</table>
</div>

### Cryptocurrency Tips

<div align="center">
<table>
  <tr>
    <td align="center" width="60"><img src="media/icons/bitcoin.svg" width="28" height="28" alt="Bitcoin"></td>
    <td><b>Bitcoin</b><br><code>bc1qztdzcy2wyavj2tsuandu4p0tcklzttvdnzalla</code></td>
  </tr>
  <tr>
    <td align="center" width="60"><img src="media/icons/monero.svg" width="28" height="28" alt="Monero"></td>
    <td><b>Monero</b><br><code>84Y34QubRwQYK2HNviezeH9r6aRcPvgWmKtDkN3EwiuVbp6sNLhm9ffRgs6BA9X1n9jY7wEN16ZEpiEngZbecXseUrW8SeQ</code></td>
  </tr>
  <tr>
    <td align="center" width="60"><img src="media/icons/ethereum.svg" width="28" height="28" alt="Ethereum"></td>
    <td><b>Ethereum</b><br><code>0x554f18cfB684889c3A60219BDBE7b050C39335ED</code></td>
  </tr>
  <tr>
    <td align="center" width="60"><img src="media/icons/solana.svg" width="28" height="28" alt="Solana"></td>
    <td><b>Solana</b><br><code>5T8h3HbyvHgLxwXgchRYbHSqRjZyAr8J7uwjLN9Fh8Jh</code></td>
  </tr>
</table>
</div>

---

## 👤 Author & Socials

<div align="center">
<table>
  <tr>
    <td align="center" width="90"><a href="https://social.chiefgyk3d.com/@chiefgyk3d" title="Mastodon"><img src="media/icons/mastodon.svg" width="30" height="30" alt="Mastodon"><br><sub>Mastodon</sub></a></td>
    <td align="center" width="90"><a href="https://bsky.app/profile/chiefgyk3d.com" title="Bluesky"><img src="media/icons/bluesky.svg" width="30" height="30" alt="Bluesky"><br><sub>Bluesky</sub></a></td>
    <td align="center" width="90"><a href="https://twitch.tv/chiefgyk3d" title="Twitch"><img src="media/icons/twitch.svg" width="30" height="30" alt="Twitch"><br><sub>Twitch</sub></a></td>
    <td align="center" width="90"><a href="https://www.youtube.com/channel/UCvFY4KyqVBuYd7JAl3NRyiQ" title="YouTube"><img src="media/icons/youtube.svg" width="30" height="30" alt="YouTube"><br><sub>YouTube</sub></a></td>
    <td align="center" width="90"><a href="https://kick.com/chiefgyk3d" title="Kick"><img src="media/icons/kick.svg" width="30" height="30" alt="Kick"><br><sub>Kick</sub></a></td>
    <td align="center" width="90"><a href="https://www.tiktok.com/@chiefgyk3d" title="TikTok"><img src="media/icons/tiktok.svg" width="30" height="30" alt="TikTok"><br><sub>TikTok</sub></a></td>
    <td align="center" width="90"><a href="https://discord.chiefgyk3d.com" title="Discord"><img src="media/icons/discord.svg" width="30" height="30" alt="Discord"><br><sub>Discord</sub></a></td>
    <td align="center" width="90"><a href="https://matrix-invite.chiefgyk3d.com" title="Matrix"><img src="media/icons/matrix.svg" width="30" height="30" alt="Matrix"><br><sub>Matrix</sub></a></td>
  </tr>
</table>
</div>

<div align="center"><sub>Made with ❤️ by <a href="https://github.com/ChiefGyk3D">ChiefGyk3D</a></sub></div>
````
