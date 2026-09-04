#!/bin/bash

set -euo pipefail

PORT="${PORT:-8000}"

# Internal links in the community site are absolute, so it has to be built for
# the address it will actually be served from to be browsable locally.
echo "🏗️ Building site for http://localhost:${PORT} ..."
SITE_URL="http://localhost:${PORT}" "$(dirname "$0")/build.sh" "$@"

echo "🌐 Serving _site on http://localhost:${PORT} (Ctrl+C to stop)"
python3 -m http.server "${PORT}" --directory "$(dirname "$0")/_site"
