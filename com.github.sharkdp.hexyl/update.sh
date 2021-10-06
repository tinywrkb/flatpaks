#!/bin/bash

_FPID=com.github.sharkdp.hexyl

[ -f ${_FPID}.yaml ] || { echo "Can't find ${_FPID}.yaml"; exit 1; }


../tools/cargo-updater hexyl
