#!/bin/sh

KDE_MIRROR="${KDE_MIRROR:-http://download.kde.org}"

if [ $# -eq 0 ]; then

  # The extra slash at the end of the URL is necessary to stop wget
  # from recursing over the whole server! (No, it's not a bug.)
  $(nix-build ../../.. -A autonix.manifest) \
      "${KDE_MIRROR}/stable/applications/15.04.0/" \
      -A '*.tar.xz'

else

  $(nix-build ../../.. -A autonix.manifest) -A '*.tar.xz' "$@"

fi
