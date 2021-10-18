#!/bin/bash

curl -L https://github.com/flatpak/flat-manager/raw/master/Cargo.lock --output Cargo.lock || exit 1

flatpak run \
  --filesystem=$PWD \
  --command=flatpak-cargo-generator.py \
  --runtime=org.freedesktop.Sdk//21.08 \
  io.github.flatpak.flatpak-builder-tools \
  Cargo.lock \
  -o cargo-sources.json

flatpak run \
  --filesystem=$PWD \
  org.flathub.flatpak-external-data-checker \
  --edit-only \
  org.flatpak.flat-manager.yaml
