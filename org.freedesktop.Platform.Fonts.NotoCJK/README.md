# Noto CJK Fonts

See full configuration details at the top level [README.md](../README.md).

## fonts.conf
```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<!-- Noto CJK fonts -->
<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.NotoCJK/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.NotoCJK/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.NotoCJK/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.NotoCJK/current/active/files/share/fonts/conf.d</include>
```
