#BINUTILS_VER = 2.33.1
GCC_VER = 11.2.0
#MUSL_VER = 1.2.3
#GMP_VER = 6.1.2
#MPC_VER = 1.1.0
#MPFR_VER = 4.0.2
#LINUX_VER = headers-4.19.88-1

TARGET = x86_64-linux-musl
OUTPUT = ${FLATPAK_DEST}
#COMMON_CONFIG += CC="x86_64-linux-musl-gcc -static --static" CXX="x86_64-linux-musl-g++ -static --static"
COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"
COMMON_CONFIG += --with-debug-prefix-map=$(CURDIR)=
