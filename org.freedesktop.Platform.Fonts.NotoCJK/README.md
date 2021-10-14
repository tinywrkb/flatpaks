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
## Formats in upstream

```

├──  Sans
│  ├──  Mono
│  │  └──  NotoSansMonoCJK<LOC>-<WEIGHT>.otf --> Static Multilingual OTF: Multilingual, single-weight, locl, Monospace
│  ├──  NotoSansCJK.ttc -----------------------> Static Super OTC: Multilingual, all weights, Monospace in Bold and Regular weights
│  ├──  OTC
│  │  └──  NotoSansCJK-<WEIGHT>.ttc -----------> Static OTC: Multilingual, single-weight, Regular and Bold also contains Monospace
│  ├──  OTF
│  │  ├──  <LOC>
│  │  │  └──  NotoSansCJK<LOC>-<WEIGHT>.otf ---> Static Multilingual OTF: Multilingual, single-weight, locl, no Monospace
│  ├──  SubsetOTF
│  │  ├──  <LOC>
│  │  │  └──  NotoSans<LOC>-<WEIGHT>.otf ------> Static Region-specific OTF: Monolingual, single-weight, no Monospace
│  └──  Variable
│     ├──  OTC --------------------------------> Variable OTCs: Multilingual, multi-weight (variable), OTF CFF2 or TTF format
│     │  ├──  NotoSansCJK-VF.otf.ttc
│     │  ├──  NotoSansCJK-VF.ttf.ttc
│     │  ├──  NotoSansMonoCJK-VF.otf.ttc
│     │  └──  NotoSansMonoCJK-VF.ttf.ttc
│     ├──  OTF
│     │  ├──  Mono
│     │  │  └──  NotoSansMonoCJK<LOC>-VF.otf ----> Variable Multilingual OTF: Multilingual, multi-weight (variable), locl, Monospace
│     │  ├──  NotoSansCJK<LOC>-VF.otf -----------> Variable Multilingual OTF: Multilingual, multi-weight (variable), locl, no Monospace
│     │  └──  Subset
│     │     └──  NotoSans<LOC>-VF.otf -----------> Variable Region-specific OTF: Monolingual, multi-weight (variable), single-weight, no Monospace
│     └──  TTF
│        ├──  Mono
│        │  └──  NotoSansMonoCJK<LOC>-VF.ttf ----> Variable Multilingual OTF: Multilingual, multi-weight (variable), locl, Monospace
│        ├──  NotoSansCJK<LOC>-VF.ttf -----------> Variable Multilingual TTF: Multilingual, multi-weight (variable), locl, no Monospace
│        └──  Subset
│           └──  NotoSans<LOC>-VF.ttf -----------> Variable Region-specific TTF: Monolingual, multi-weight (variable), single-weight, no Monospace
└──  Serif
   ├──  NotoSerifCJK-<WEIGHT>.ttc ---------------> Static OTC: Multilingual, single-weight, no Monospace
   ├──  NotoSerifCJK<LOC>-<WEIGHT>.otf ----------> Static Multilingual OTF: Multilingual, single-weight, locl, no Monospace
   └──  NotoSerif<LOC>-<WEIGHT>.otf -------------> Static Region-specific OTF: Monolingual, single-weight, no Monospace
```
