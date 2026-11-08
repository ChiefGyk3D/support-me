#!/usr/bin/env bash
# Usage: scripts/check.sh [SITE_DIR]      check the site (default: repo root)
#        scripts/check.sh --self-test     prove each check fails on a bad copy
#
# No dependencies beyond bash, grep, sed, awk. Fails (exit 1) if the site:
#   - loads anything from an external host (src, stylesheet link, url(), @import)
#   - has an inline script, a <style> block, a style="" or on*="" attribute
#   - hard-codes a color outside tokens.css
#   - has an <img> without alt
#   - has a wallet address that differs from addresses.txt, SIGNATURE.md,
#     README.md or the QR code's <desc> (decode check is NOT done here)
#   - has a _headers CSP that is missing or loosened
set -u

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run_checks() {
    local root="$1" fail=0
    local html="$root/index.html" css="$root/style.css" js="$root/support.js"
    local f

    bad() {
        echo "FAIL: $*"
        fail=1
    }

    for f in "$html" "$css" "$js" "$root/tokens.css" "$root/_headers" "$root/addresses.txt"; do
        [ -f "$f" ] || bad "missing file: ${f#"$root"/}"
    done
    [ "$fail" -eq 0 ] || return 1

    # 1. External loads. Plain <a href="https://..."> links are allowed.
    if grep -nEi '(src|srcset|poster|data)="(https?:)?//|<link[^>]*href="(https?:)?//|url\(["'"'"']?(https?:)?//|@import' \
        "$html" "$css" "$root/tokens.css" "$js"; then
        bad "external host loaded"
    fi
    if grep -nE 'https?://' "$css" "$root/tokens.css" "$js" | grep -v '^[^:]*:[0-9]*:[[:space:]]*\(//\|/\*\|\*\)'; then
        bad "URL in css/js"
    fi

    # 2. Inline script/style (CSP script-src 'self', style-src 'self').
    if grep -nEi '<script([^>]*)>' "$html" | grep -viE 'src="[^"]+"'; then
        bad "inline script"
    fi
    if grep -nEi '<style|[[:space:]]style=|[[:space:]]on[a-z]+=|javascript:' "$html"; then
        bad "inline style or event handler"
    fi

    # 3. Colors only in tokens.css.
    if grep -nEi '#[0-9a-f]{3,8}\b|\b(rgb|rgba|hsl|hsla|oklch|oklab|color-mix)\(' "$html" "$css" "$js" |
        grep -vE '^[^:]*:[0-9]+:[[:space:]]*(/\*|\*|//)'; then
        bad "hard-coded color outside tokens.css"
    fi
    if grep -nEiw 'white|black|red|green|blue|gray|grey|orange|purple|pink|yellow' "$css" |
        grep -E '(color|background|border[a-z-]*|outline|fill|stroke|shadow)[^;]*:' |
        grep -vE '^[0-9]+:[[:space:]]*(/\*|\*)'; then
        bad "named color outside tokens.css"
    fi

    # 4. Alt text on every image.
    if grep -o '<img[^>]*>' "$html" | grep -v ' alt='; then
        bad "img without alt"
    fi

    # 5. Addresses.
    local coin addr sig="$root/SIGNATURE.md" readme="$root/README.md" found n
    while read -r coin addr; do
        case "$coin" in '' | '#'*) continue ;; esac
        found="$(grep -o "<code class=\"address\" id=\"$coin\">[^<]*</code>" "$html" | sed 's/<[^>]*>//g')"
        [ "$found" = "$addr" ] || bad "index.html address for $coin differs from addresses.txt"
        grep -qF "\`$addr\`" "$sig" || bad "SIGNATURE.md lacks the $coin address"
        grep -qF "<code>$addr</code>" "$readme" || bad "README.md lacks the $coin address"
        grep -qF "<desc>$addr</desc>" "$root/media/qr-$coin.svg" || bad "media/qr-$coin.svg desc differs for $coin"
    done <"$root/addresses.txt"
    n="$(grep -c 'class="address"' "$html")"
    [ "$n" -eq "$(grep -cEv '^(#|$)' "$root/addresses.txt")" ] || bad "address count in index.html ($n) differs from addresses.txt"
    # Any other address-like code block is a finding.
    n="$(grep -c '<code' "$html")"
    [ "$n" -eq "$(grep -c 'class="address"' "$html")" ] || bad "unexpected <code> element in index.html"

    # 6. Headers: strict CSP, no loosening.
    local csp
    csp="$(grep -E '^[[:space:]]+Content-Security-Policy:' "$root/_headers")"
    for f in "default-src 'none'" "script-src 'self'" "style-src 'self'" "img-src 'self'" "font-src 'self'" \
        "base-uri 'none'" "form-action 'none'" "frame-ancestors 'none'"; do
        case "$csp" in *"$f"*) ;; *) bad "CSP lacks $f" ;; esac
    done
    case "$csp" in *unsafe-* | *http*) bad "CSP loosened" ;; esac
    for f in X-Content-Type-Options Referrer-Policy Permissions-Policy Strict-Transport-Security; do
        grep -q "^[[:space:]]*$f:" "$root/_headers" || bad "_headers lacks $f"
    done

    # 7. Fonts and their licenses are shipped.
    for f in fonts/orbitron-wght.ttf fonts/OFL-Orbitron.txt fonts/jost-latin-wght-normal.woff2 fonts/OFL.txt; do
        [ -f "$root/$f" ] || bad "missing $f"
    done

    return "$fail"
}

tmp=""
self_test() {
    local rc=0 name
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/support-check.XXXXXX")" || exit 1
    trap 'rm -rf "${tmp:-}"' EXIT

    expect_fail() { # name, sed-script, file
        name="$1"
        rm -rf "$tmp/site"
        mkdir "$tmp/site"
        (cd "$here" && cp -R index.html style.css support.js tokens.css _headers addresses.txt SIGNATURE.md README.md media fonts "$tmp/site/")
        sed -i "$2" "$tmp/site/$3"
        if run_checks "$tmp/site" >/dev/null 2>&1; then
            echo "SELF-TEST FAIL: '$name' was not caught"
            rc=1
        else
            echo "self-test ok: $name is caught"
        fi
    }

    rm -rf "$tmp/site"
    mkdir "$tmp/site"
    (cd "$here" && cp -R index.html style.css support.js tokens.css _headers addresses.txt SIGNATURE.md README.md media fonts "$tmp/site/")
    run_checks "$tmp/site" >/dev/null 2>&1 || {
        echo "SELF-TEST FAIL: clean copy does not pass"
        rc=1
    }
    expect_fail "external font link" 's#<link rel="icon"#<link href="https://fonts.example/x.css" rel="stylesheet"><link rel="icon"#' index.html
    expect_fail "inline script" 's#<script src="support.js" defer></script>#<script>x()</script>#' index.html
    expect_fail "style attribute" 's#<h1>#<h1 style="margin:0">#' index.html
    expect_fail "event handler" 's#<h1>#<h1 onclick="x()">#' index.html
    expect_fail "hex color in css" 's#var(--accent);#\#fbb03b;#' style.css
    expect_fail "rgb color in html" 's#<h1>#<h1 data-x="rgb(1,2,3)">#' index.html
    expect_fail "img without alt" 's#alt="Renegade Tux, the penguin mascot"##' index.html
    expect_fail "wrong address" 's#bc1qztdzcy2wyavj2tsuandu4p0tcklzttvdnzalla</code>#bc1qztdzcy2wyavj2tsuandu4p0tcklzttvdnzallb</code>#' index.html
    expect_fail "loosened CSP" "s#script-src 'self'#script-src 'self' 'unsafe-inline'#" _headers
    return "$rc"
}

if [ "${1:-}" = "--self-test" ]; then
    self_test
    exit $?
fi

root="$(cd "${1:-$here}" && pwd)"
if run_checks "$root"; then
    echo "check: ok"
else
    exit 1
fi
