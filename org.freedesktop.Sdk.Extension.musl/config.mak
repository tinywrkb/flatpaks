TARGET = x86_64-linux-musl
OUTPUT = ${FLATPAK_DEST}
#COMMON_CONFIG += CC="x86_64-linux-musl-gcc -static --static" CXX="x86_64-linux-musl-g++ -static --static"
COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"
COMMON_CONFIG += --with-debug-prefix-map=$(CURDIR)=
