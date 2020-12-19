#!/bin/bash

case "$1" in
  region)
    grim -g "$(slurp)" - | swappy -f -
    ;;
  screen)
    grim - | swappy -f -
    ;;
  *)
    exec swappy "$@"
esac
