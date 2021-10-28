#!/bin/bash

_FPID=dev.orhun.gpg-tui

[ -f ${_FPID}.yaml ] || { echo "Can't find ${_FPID}.yaml"; exit 1; }

../tools/cargo-updater gpg-tui

{
  cd xplr
  ../../tools/cargo-updater xplr
}
