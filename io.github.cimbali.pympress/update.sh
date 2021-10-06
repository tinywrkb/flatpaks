#!/bin/bash

_FPID=io.github.cimbali.pympress

[ -f ${_FPID}.yaml ] || { echo "Can't find ${_FPID}.yaml"; exit 1; }

../tools/pip-updater
../tools/cpan-updater
