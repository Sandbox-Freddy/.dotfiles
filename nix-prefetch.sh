#!/usr/bin/env sh
# Puts the DisplayLink driver archive into the Nix store so that
# modules/hardware/displaylink.nix can build (the package is `requireFile`-based).
set -eu

nix-prefetch-url --name displaylink-620.zip \
  "https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip"
