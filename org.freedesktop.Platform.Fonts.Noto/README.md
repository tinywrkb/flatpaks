# Noto Fonts

See full configuration details at the top level [README.md](../README.md).

## fonts.conf: Noto
```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<!-- Noto fonts -->
<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.Noto/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.Noto/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.Noto/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.Noto/current/active/files/share/fonts/conf.d</include>
```

## fonts.conf: Noto Extra
```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<!-- Noto Extra fonts -->
<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.NotoExtra/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.NotoExtra/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.NotoExtra/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.NotoExtra/current/active/files/share/fonts/conf.d</include>
```

## fonts.conf: CrOS Core
```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<!-- CrOS Core fonts -->
<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.CrOSCore/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.CrOSCore/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.CrOSCore/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.CrOSCore/current/active/files/share/fonts/conf.d</include>
```
