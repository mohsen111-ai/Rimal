#!/usr/bin/env bash
# Apply patches/*.patch in order, then copy overlay/ over the upstream tree.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UP="${UPSTREAM_DIR:-$ROOT/build/upstream}"

cd "$UP"
if [ -f .sahara-patched ]; then
  echo "patches already applied"
else
  for p in "$ROOT"/patches/*.patch; do
    [ -e "$p" ] || continue
    echo "applying $(basename "$p")"
    git apply --whitespace=nowarn "$p"
  done
  touch .sahara-patched
fi
if [ -d "$ROOT/overlay" ] && [ -n "$(ls -A "$ROOT/overlay" 2>/dev/null | grep -v '^.gitkeep$' || true)" ]; then
  echo "copying overlay"
  cp -a "$ROOT"/overlay/. "$UP"/
  rm -f "$UP/.gitkeep"
fi
