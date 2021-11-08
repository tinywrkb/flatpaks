#!/bin/bash

_FPID=samba

[ -f ${_FPID}.json ] || { echo "Can't find ${_FPID}.json"; exit 1; }

../../tools/cpan-updater
flatpak-external-data-checker --edit-only ${_FPID}.json
flatpak-external-data-checker --edit-only lib32-${_FPID}.json
flatpak-external-data-checker --edit-only sdk-lib32-${_FPID}.json
