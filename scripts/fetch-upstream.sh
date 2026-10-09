#!/usr/bin/env bash
# Shallow-clone the pinned upstream Firefox release into build/upstream.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UP="${UPSTREAM_DIR:-$ROOT/build/upstream}"
TAG="$(tr -d '[:space:]' < "$ROOT/UPSTREAM_VERSION")"

if [ -d "$UP/.git" ]; then
  echo "upstream already present at $UP (delete build/ to refetch)"
  exit 0
fi
mkdir -p "$(dirname "$UP")"
git clone --depth 1 --branch "$TAG" https://github.com/mozilla-firefox/firefox "$UP"
