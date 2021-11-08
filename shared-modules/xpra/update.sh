#!/bin/bash

_FPID=xpra

[ -f ${_FPID}.json ] || { echo "Can't find ${_FPID}.json"; exit 1; }

../../tools/pip-updater
