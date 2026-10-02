#!/usr/bin/env bash
# Rebuilds dist/chill-vibes-coder.zip, the file users upload to the Claude app.
# The ZIP must contain the skill folder itself at its root.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/chill-vibes-coder.zip
zip -r -X dist/chill-vibes-coder.zip chill-vibes-coder -x "*.DS_Store"
echo "Built dist/chill-vibes-coder.zip"
