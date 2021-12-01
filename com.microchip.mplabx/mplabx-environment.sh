#!/bin/bash

# only export once
if [ "${MPLABX_ENV_SET}" != 'true' ]; then

  export MPLABX_ENV_SET=true
  COMPILERS_ROOT=/app/compilers

  PATH+=:/app/jre/bin
  PATH+=:/app/extra/mplabx/mplab_platform/bin

  for compiler in XC8 XC16 XC32; do
    declare ${compiler}_TOOLCHAIN_ROOT=${COMPILERS_ROOT}/${compiler}
    toolchain_root_key=${compiler}_TOOLCHAIN_ROOT
    toolchain_root=${!toolchain_root_key}
    if [ -d $toolchain_root ]; then
      PATH+=:${toolchain_root}/extra/bin
      export ${compiler}_TOOLCHAIN_ROOT
    fi
  done

  export PATH
fi
