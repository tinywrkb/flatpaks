#!/bin/sh

flatpak run \
  --command=flatpak-pip-generator \
  io.github.flatpak.flatpak-builder-tools \
  -o yq yq
