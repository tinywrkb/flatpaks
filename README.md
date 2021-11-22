# flatpaks

A few Flatpaks that I hastly packaged. These are not thoroughly tested so use at your own discretion.  
Packaging was adapted mainly from Arch Linux's official PKGBUILDs and the AUR.  
Most of these are PoC, not maintained, might need some cleanup, missing a feature here and there,
and in general are not ready to publish via Flathub.  
The catalyst for packaging these apps is to prove that it's possible to convert to, and as a precondition
for switching to an immutable system, an OS that has a clear seperation between the stateless
read-only distributed OS files, and the stateful data and configs.


### Not usable or too buggy
* Fusion 360


### How to build

1. Install flatpak-builder
2. Clone the flatpaks repo
```
git clone https://github.com/tinywrkb/flatpaks.git
git submodule init
git submodule update
```
3. Create a working folder for flatpak-builder somewhere
```
mkdir build
```
4. Build the package with flatpak-builder and install it as a user Flatpak app. Replace `manifest.yaml` with the path to application manifest.
```
flatpak-builder --install --user --force-clean --state-dir=build/flatpak-builder --repo=build/flatpak-repo build/flatpak-target manifest.yaml
```

### Font packages

Flatpak does not support font packages or extensions. In order for Flatpak and host apps to use fonts installed as Flatpak package we need a few workarounds.


1. Give all our Flatpak apps access to the user's fontconfig configuration file, and also the font package installed path.  
Due to a mismatch of `XDG_CONFIG_DIR` value between the host and the Flatpak sandbox (a different path for each app), we need to set some environment variables.  
Also note that the fontconfig variable value need to be an absolute path, meaning it needs to be expanded before given to the `flatpak override` command.
```
$ flatpak override --user \
    --filesystem=~/.local/share/flatpak:ro \
    --filesystem=/var/lib/flatpak:ro \
    --env=FONTCONFIG_FILE=$XDG_CONFIG_HOME/fontconfig/fonts.conf \
    --env=FONTCONFIG_PATH=$XDG_CONFIG_HOME/fontconfig/conf.d
```

2. Adding the following to `$XDG_CONFIG_HOME/fontconfig/fonts.conf` will tell fontconfig to include the Flatpak font package in its scan.  
The first directive is required because fc-cache omits the default font locations when scanning inside a Flatpak sandbox, and that's due to our use of `FONTCONFIG_FILE` variable.  
Note that you need to replace `{FontName}` with the name of the font as defined in the Flatpak app ID, see for example the Noto fonts packages.

```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.{FontName}/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.{FontName}/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.{FontName}/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.{FontName}/current/active/files/share/fonts/conf.d</include>
```

3. Now we can update the host's font cache.

```
cd ~
fc-cache
```

4. To update the font cache of a Flatpak app sandbox just restart the app.


#### Fontconfig related bugs

* [Flatpak: Expose host fontconfig conf.d?](https://github.com/flatpak/flatpak/issues/1563)
* [Flatpak: Expose xdg-config/fontconfig to sandbox by default](https://github.com/flatpak/flatpak/issues/3947)
* [freedesktop-sdk: Support font extensions](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/issues/1141)


## List of applications

### Internet

#### Internet/Network connection

##### Internet/Network connection/Diagnostics
* [speedtest-cli](com.github.sivel.speedtest-cli)

##### Internet/Network connection/Network managers
* [Airport Utility](com.apple.airport-utility)
* [iwgtk](org.twosheds.iwgtk)

#### Internet/Web browsers
* [Chrome](com.google.chrome)
* [Chrome Unstable](com.google.chrome-unstable)
* [Edge Dev](com.microsoft.edge-dev)

#### Internet/File sharing

##### Internet/File sharing/Cloud sync
* [Insync](com.insynchq.insync)
* [Megatools](com.megous.megatools)
* [Rclone](org.rclone.rclone)

##### Internet/File sharing/BitTorrent
* [trxo](com.github.tinywrkb.trxo)
* [tremc](com.github.tremc)

#### Internet/Communication
* [weechat](org.weechat.weechat)

### Multimedia

#### Multimedia/Codecs
* [ffmpeg](org.ffmpeg.ffmpeg)

#### Multimedia/Image
* [PTGui](com.ptgui.ptgui)
* [exiv2](org.exiv2.exiv2)
* [imv](com.github.exec64.imv)
* [jhead](com.github.matthias_wandel.jhead)
* [qimgv](com.github.easymodo.qimgv)

#### Multimedia/Audio
* [QjackCtl](io.sourceforge.qjackctl)
* [Qsynth](io.sourceforge.qsynth)
* [pasystray](com.github.christophgysin.pasystray)
* [puddletag](net.puddletag.puddletag)

#### Multimedia/Video
* [mpv](io.mpv.player)

### Utilities

#### Utilities/Terminal

##### Utilities/Terminal/Shell tools
* [asciinema](org.asciinema.asciinema)

##### Utilities/Terminal/Text terminal emulators
* [minicom](org.debian.minicom)
* [picocom](com.github.npat_efault.picocom)

##### Utilities/Terminal/Video terminal emulators
* [alacritty](com.github.alacritty)
* [wezterm](org.wezfurlong.wezterm)

#### Utilities/Files

##### Utilities/Files/File managers
* [QtFM](com.github.rodlie.qtfm)
* [Sunflower](org.sunflower_fm.sunflower)

##### Utilities/Files/Archiving and compression tools
* [unappimage](com.github.refi64.unappimage)

##### Utilities/Files/Duplicates cleaners
* [rmlint](com.github.sahib.rmlint)

### Documents and texts

#### Documents and texts/Text editors
* [Neovim Qt](com.github.equalsraf.neovim-qt)
* [Notepad++](org.notepad_plus_plus.notepadpp)
* [l3afpad](com.github.stevenhoneyman.l3afpad)

#### Documents and texts/PDF tools
* [pdfcrack](net.sourceforge.pdfcrack)

#### Documents and texts/Readers and viewers
* [PDFSam](org.pdfsam.pdfsam)
* [Qpdfview](net.launchpad.qpdfview)
* [Sioyek](info.sioyek.sioyek)
* [Zathura](org.pwmt.zathura)
* [pdfpc](com.github.pdfpc.pdfpc)
