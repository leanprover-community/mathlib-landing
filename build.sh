#!/bin/bash

set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"

# Where the built site will be served from. serve.sh points SITE_URL at
# localhost; CI leaves both at their defaults.
SITE_URL="${SITE_URL:-https://mathlib.org}"
# Subdirectory holding the pages migrated from leanprover-community.github.io.
COMMUNITY_PREFIX="${COMMUNITY_PREFIX:-community}"
PYTHON="${PYTHON:-python3}"

if [ -z "$COMMUNITY_PREFIX" ]; then
  echo "COMMUNITY_PREFIX must not be empty: the migrated site has its own" >&2
  echo "index.html, which would overwrite the landing page. Serving it at the" >&2
  echo "root is a deliberate later step, not a configuration change." >&2
  exit 2
fi

landing_only=false
case "${1:-}" in
  --landing-only) landing_only=true ;;
  '') ;;
  *) echo "usage: $(basename "$0") [--landing-only]" >&2; exit 2 ;;
esac

echo "🔨 Building site..."

rm -rf "$root/_site"
mkdir -p "$root/_site"

echo "📄 Copying index.html..."
cp "$root/index.html" "$root/_site/"

echo "🖼️ Copying favicon..."
cp "$root/favicon.svg" "$root/_site/"

echo "🤖 Writing robots.txt..."
cat > "$root/_site/robots.txt" <<EOF
# The pages under /$COMMUNITY_PREFIX/ are currently a duplicate of
# https://leanprover-community.github.io/, kept while material is migrated and
# deduplicated. Keep crawlers off the copy so the two do not compete to be the
# canonical version of the same page.
User-agent: *
Disallow: /$COMMUNITY_PREFIX/
EOF

if $landing_only; then
  echo "⏭️  Skipped the community site (--landing-only)."
  echo "⚠️  This output is NOT deployable: it would remove /$COMMUNITY_PREFIX/."
  exit 0
fi

echo "🌍 Building community site for $SITE_URL/$COMMUNITY_PREFIX/ ..."

# GitHub Actions sets a secret that has not been configured to the empty
# string, and make_site.py tests for the presence of these variables rather
# than for a usable value: an empty ZULIP_KEY sends it to the Zulip API with no
# credentials. Unset them so it takes its no-credentials path instead.
[ -n "${GITHUB_TOKEN:-}" ] || unset GITHUB_TOKEN
[ -n "${ZULIP_KEY:-}" ] || unset ZULIP_KEY

# make_site.py copies css/, js/, img/ and papers/ using paths relative to the
# working directory, so it has to run from inside community/.
cd "$root/community"
SITE_TARGET="$root/_site/$COMMUNITY_PREFIX" \
SITE_BASE_URL="$SITE_URL/$COMMUNITY_PREFIX/" \
SITE_EDIT_BASE="https://github.com/leanprover-community/mathlib-landing/blob/main/community/templates/" \
  "$PYTHON" ./make_site.py

echo "✅ Build complete! Output in _site/"
