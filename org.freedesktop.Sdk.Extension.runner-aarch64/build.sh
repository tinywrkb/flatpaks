#!/bin/bash

_WRKDIR="${_WRKDIR:-$PWD}"
_BUILDDIR="$_WRKDIR"/build
_APPNAME=org.freedesktop.Sdk.Extension.runner-aarch64
_SDK=org.freedesktop.Sdk
_RUNTIME=org.freedesktop.Sdk
_BRANCH=21.08
_REPO="$_WRKDIR"/flatpak-repo
_QEMU_DOWNLOAD="https://github.com/multiarch/qemu-user-static/releases/download/v6.1.0-8/qemu-aarch64-static.tar.gz"

flatpak build-init --arch=aarch64 --type=extension --extension-tag=org.freedesktop.Sdk.Extension "$_BUILDDIR" $_APPNAME $_SDK $_RUNTIME $_BRANCH

curl -L "$_QEMU_DOWNLOAD" | bsdtar -Oxf - | install -Dm755 /dev/stdin "$_BUILDDIR"/files/bin/qemu-aarch64-static

flatpak build-finish "$_BUILDDIR"

flatpak build-export $_REPO "$_BUILDDIR" $_BRANCH
