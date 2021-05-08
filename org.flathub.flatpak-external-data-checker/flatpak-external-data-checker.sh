#!/bin/sh

for d in $XDG_CACHE_HOME/apt $XDG_CONFIG_HOME/apt/trusted.gpg.d $XDG_DATA_HOME/dpkg; do
  [ -d $d ] || mkdir -p $d
done

for f in $XDG_DATA_HOME/dpkg/status $XDG_CONFIG_HOME/apt/{sources.list,trusted.gpg}; do
  [ -f $f ] || touch $f
done

exec /app/flatpak-external-data-checker/flatpak-external-data-checker "$@"
