#!/bin/sh

flatpak run \
  --command=flatpak-pip-generator \
  io.github.flatpak.flatpak-builder-tools \
  -o s-tui s-tui
