#!/bin/bash

set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"

# Where the built site will be served from. serve.sh points this at localhost;
# CI leaves it at its default. make_site.py forms every internal link by
# appending to this, so it relocates the whole site.
SITE_URL="${SITE_URL:-https://mathlib.org}"
PYTHON="${PYTHON:-python3}"

if [ $# -gt 0 ]; then
  echo "usage: $(basename "$0")" >&2
  exit 2
fi

echo "🔨 Building site..."

rm -rf "$root/_site"
mkdir -p "$root/_site"

echo "🌍 Building site for $SITE_URL/ ..."

# GitHub Actions sets a secret that has not been configured to the empty
# string, and make_site.py tests for the presence of these variables rather
# than for a usable value: an empty ZULIP_KEY sends it to the Zulip API with no
# credentials. Unset them so it takes its no-credentials path instead.
[ -n "${GITHUB_TOKEN:-}" ] || unset GITHUB_TOKEN
[ -n "${ZULIP_KEY:-}" ] || unset ZULIP_KEY

# make_site.py copies css/, js/, img/ and papers/ using paths relative to the
# working directory, so it has to run from inside community/.
cd "$root/community"
SITE_TARGET="$root/_site" \
SITE_BASE_URL="$SITE_URL/" \
SITE_EDIT_BASE="https://github.com/leanprover-community/mathlib-landing/blob/main/community/templates/" \
  "$PYTHON" ./make_site.py

# make_site.py rsyncs community/robots.txt into the target, which is now the
# site root rather than a subdirectory, so it would be the live robots.txt.
# That file is the old site's, and the pages it names do not exist here.
# Overwrite it afterwards so this repository decides what mathlib.org serves.
#
# Note this deliberately allows crawling. Every page carries a noindex meta tag
# while leanprover-community.github.io serves the same pages (see SITE_NOINDEX
# in make_site.py), and a crawler has to fetch a page to see that tag: a
# Disallow here would hide the very instruction that keeps these pages out of
# search results, and Google would be free to index the URLs anyway.
echo "🤖 Writing robots.txt..."
cat > "$root/_site/robots.txt" <<'EOF'
User-agent: *
Allow: /
EOF

echo "✅ Build complete! Output in _site/"
