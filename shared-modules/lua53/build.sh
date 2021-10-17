#!/bin/bash

_ver0=$(grep 'define LUA_VERSION_MAJOR' src/lua.h | cut -d'"' -f2)
_ver1=$(grep 'define LUA_VERSION_MINOR' src/lua.h | cut -d'"' -f2)
_ver2=$(grep 'define LUA_VERSION_RELEASE' src/lua.h | cut -d'"' -f2)
_ver=${_ver0}.${_ver1}.${_ver2}

sed -i "s|/usr/local/|$FLATPAK_DEST/|;s|LUA_IDSIZE	60|LUA_IDSIZE	512|" src/luaconf.h

# Lua 5.3.5 has wrong release version in its Makefile. Fix it.
sed -i 's/^R= \$V.4/R= \$V.5/' Makefile
sed -i '12 a\\n#define LUA_COMPAT_5_1\n#define LUA_COMPAT_5_2' src/luaconf.h

make -j $FLATPAK_BUILDER_N_JOBS CFLAGS="$CFLAGS -fPIC -DLUA_USE_LINUX" linux
make TO_LIB=liblua.so.${_ver} INSTALL_TOP=$FLATPAK_DEST install
ln -sf liblua.so.${_ver} $FLATPAK_DEST/lib/liblua.so
ln -sf liblua.so.${_ver} $FLATPAK_DEST/lib/liblua.so.${_ver0}.${_ver1}
make INSTALL_TOP=${FLATPAK_DEST} pc > lua.pc
cat lua.pc.in >> lua.pc
install -Dm644 lua.pc $FLATPAK_DEST/lib/pkgconfig/lua.pc
ln -sf lua.pc $FLATPAK_DEST/lib/pkgconfig/lua${_ver0}${_ver1}.pc
ln -sf lua.pc $FLATPAK_DEST/lib/pkgconfig/lua${_ver0}.${_ver1}.pc
ln -sf lua.pc $FLATPAK_DEST/lib/pkgconfig/lua-${_ver0}.${_ver1}.pc
