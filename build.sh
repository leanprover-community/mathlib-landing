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

# GitHub Actions sets a secret or variable that has not been configured to the
# empty string, and make_site.py tests for the presence of these variables
# rather than for a usable value: an empty MAP_ZULIP_* pair would send the
# Zulip API an empty address and no credentials. Unset them so it takes its
# no-credentials path instead.
[ -n "${GITHUB_TOKEN:-}" ] || unset GITHUB_TOKEN
[ -n "${MAP_ZULIP_EMAIL:-}" ] || unset MAP_ZULIP_EMAIL
[ -n "${MAP_ZULIP_KEY:-}" ] || unset MAP_ZULIP_KEY

# make_site.py copies css/, js/, img/ and papers/ using paths relative to the
# working directory, so it has to run from inside community/.
cd "$root/community"
SITE_TARGET="$root/_site" \
SITE_BASE_URL="$SITE_URL/" \
SITE_EDIT_BASE="https://github.com/leanprover-community/mathlib-landing/blob/main/community/templates/" \
  "$PYTHON" ./make_site.py

# Allow everything. leanprover-community.github.io redirects its copies of the
# migrated pages here, and a redirect only keeps a page in search results if
# its target can be crawled and indexed.
echo "🤖 Writing robots.txt..."
cat > "$root/_site/robots.txt" <<'EOF'
User-agent: *
Allow: /
EOF

echo "✅ Build complete! Output in _site/"
