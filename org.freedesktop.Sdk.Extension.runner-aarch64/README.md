# org.freedesktop.Sdk.Extension.runner-aarch64

## Build the extension

```
export _WRKDIR=work_dir_path
./build.sh
```

## Install the extension

```
$ flatpak install \
  --user \
  --arch=aarch64 \
  ${_WRKDIR}/flatpak-repo \
  org.freedesktop.Sdk.Extension.runner-aarch64//21.08
```

## Update binfmt_misc

```
$ sudo install -dm755 /run/binfmt.d
$ echo ':qemu-aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/lib/sdk/runner-aarch64/bin/qemu-aarch64-static:OC' | sudo tee /run/binfmt.d/qemu-user.conf
$ sudo systemctl restart systemd-binfmt.service
```

## Build application

```
$ flatpak-builder --arch=aarch64 ...
```
