#!/usr/bin/env bash
# Build a Sahara APK. Usage: scripts/build.sh [variant]   (default: debug)
#   variant: debug | nightly | beta | release     (Fenix build types)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UP="${UPSTREAM_DIR:-$ROOT/build/upstream}"
VARIANT="${1:-debug}"
GV="$(tr -d '[:space:]' < "$ROOT/GECKOVIEW_VERSION")"

"$ROOT/scripts/fetch-upstream.sh"
"$ROOT/scripts/apply-patches.sh"

cd "$UP"
cp "$ROOT/scripts/mozconfig.android" "$UP/mozconfig"
export MOZCONFIG="$UP/mozconfig"

./mach --no-interactive bootstrap \
  --application-choice=mobile_android_artifact_mode
echo "--- ~/.mozbuild after bootstrap:"; ls -la "$HOME/.mozbuild" || true
./mach configure

# Gradle's root build reads objdir/buildid.h, normally written by a full `mach build`.
# We don't compile Gecko, so write the one line it needs, using the build id of the
# pinned GeckoView (the last part of its version).
mkdir -p "$UP/objdir-frontend"
echo "#define MOZ_BUILDID ${GV##*.}" > "$UP/objdir-frontend/buildid.h"

# Pin the published, release-channel GeckoView (see patches/0001).
export SAHARA_GECKOVIEW="org.mozilla.geckoview:geckoview-omni:${GV}"

case "$VARIANT" in
  debug)   TASK="fenix:assembleDebug" ;;
  nightly) TASK="fenix:assembleNightly" ;;
  beta)    TASK="fenix:assembleBeta" ;;
  release) TASK="fenix:assembleRelease" ;;
  *) echo "unknown variant: $VARIANT" >&2; exit 2 ;;
esac
./mach gradle "$TASK"

mkdir -p "$ROOT/dist"
find "$UP/objdir-frontend/gradle/build/mobile/android/fenix/app/outputs/apk" -name '*.apk' \
  -exec cp -v {} "$ROOT/dist/" \;
ls -la "$ROOT/dist"
