# Noto Emoji Font

See full configuration details at the top level [README.md](../README.md).

## fonts.conf
```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<!-- Noto Emoji font -->
<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.NotoEmoji/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.NotoEmoji/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.NotoEmoji/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.NotoEmoji/current/active/files/share/fonts/conf.d</include>
```
