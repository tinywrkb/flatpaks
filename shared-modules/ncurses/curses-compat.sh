#!/bin/bash

_curses_h=${FLATPAK_DEST}/include/ncursesw/curses.h

_maj=$(grep '#define NCURSES_VERSION_MAJOR' $_curses_h | awk '{print $3}')
_min=$(grep '#define NCURSES_VERSION_MINOR' $_curses_h | awk '{print $3}')
_pat=$(grep '#define NCURSES_VERSION_PATCH' $_curses_h | awk '{print $3}')
_ver=${_maj}.${min}

# non-wide -> wide
for lib in ncurses ncurses++ form panel menu; do
  ln -s ${lib}w.pc ${FLATPAK_DEST}/lib/pkgconfig/${lib}.pc
  printf "INPUT(-l%sw)\n" "${lib}" > ${FLATPAK_DEST}/lib/lib${lib}.so
done

# curses -> ncurses
printf "INPUT(-lncursesw)\n" > ${FLATPAK_DEST}/lib/libcursesw.so
ln -s libncurses.so ${FLATPAK_DEST}/lib/libcurses.so

# tic & tinfo are built-in
for lib in tic tinfo; do
  ln -s ncursesw.pc ${FLATPAK_DEST}/lib/pkgconfig/${lib}.pc
  printf "INPUT(libncursesw.so.%s)\n" "${_maj}" > ${FLATPAK_DEST}/lib/lib${lib}.so
  ln -s libncursesw.so.${_maj} ${FLATPAK_DEST}/lib/lib${lib}.so.${_maj}
done
