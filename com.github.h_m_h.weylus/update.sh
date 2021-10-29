#!/bin/bash

_FPID=com.github.h_m_h.weylus

[ -f ${_FPID}.yaml ] || { echo "Can't find ${_FPID}.yaml"; exit 1; }

../tools/cargo-updater weylus
