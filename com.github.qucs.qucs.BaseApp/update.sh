#!/bin/bash

_FPID=com.github.qucs.qucs.BaseApp

[ -f ${_FPID}.yaml ] || { echo "Can't find ${_FPID}.yaml"; exit 1; }


../tools/cpan-updater
