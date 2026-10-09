# Sahara (Rimal)

A personal Android browser: Firefox for Android (Fenix) on a pinned, published
GeckoView, with a desert theme, a multi-connection download manager, a
pre-installed uBlock Origin and a tuned network stack.

This repo is **not a fork of mozilla-central**. It is a patch series plus an
overlay that is applied to a pinned upstream release at build time.

```
UPSTREAM_VERSION    pinned Firefox release tag (mozilla-firefox/firefox)
GECKOVIEW_VERSION   pinned published GeckoView (maven.mozilla.org, release channel)
patches/            ordered `git apply` patches against upstream
overlay/            new files copied over upstream (new modules, assets, icons)
scripts/            fetch-upstream, apply-patches, build
design/             brand assets (icon, mascot) and design notes
docs/               decisions and notes
```

## Build

```
scripts/build.sh debug      # needs ~20 GB free disk; CI does this for you
```

CI (`.github/workflows/build.yml`) builds an APK on every push to the working
branch and uploads it as the `sahara-apk` artifact. Release signing uses your own
keystore (never committed).

## Updating upstream

1. Pick the new release tag and the matching GeckoView version published on
   maven.mozilla.org, and update `UPSTREAM_VERSION` and `GECKOVIEW_VERSION`.
2. Re-run the build. Fix any patch that no longer applies.
