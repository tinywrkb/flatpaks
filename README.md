# flatpaks

A few Flatpaks that I hastly packaged. These are not thoroughly tested so use at your own discretion.  
Packaging was adapted mainly from Arch Linux's official PKGBUILDs and the AUR.  
Most of these are PoC, not maintained, might need some cleanup, missing a feature here and there,
and in general are not ready to publish via Flathub.  
The catalyst for packaging these apps is to prove that it's possible to convert to, and as a precondition
for switching to an immutable system, an OS that has a clear seperation between the stateless
read-only distributed OS files, and the stateful data and configs.


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

### Tips and tricks

#### Font packages

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


##### Fontconfig related bugs

* [Flatpak: Expose host fontconfig conf.d?](https://github.com/flatpak/flatpak/issues/1563)
* [Flatpak: Expose xdg-config/fontconfig to sandbox by default](https://github.com/flatpak/flatpak/issues/3947)
* [freedesktop-sdk: Support font extensions](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/issues/1141)


#### extra-data caching and avoiding download

Copy the extra-data source into `FLATAPK_INSTALLATION_PATH/extra-data/CHECKSUM/FILENAME`.

#### Terminal emulators: host access

* SSH over tcp, use keys from an already running ssh-agent session.
* SSH over a unix socket using socat.
* Start a shell session on the host using flatpak-spawn.  
  This actually doesn't work correcty, and the proper solution is implemented in [flatterm](https://gitlab.gnome.org/chergert/flatterm).
  1. Create an override: `$ flatpak override --user --talk-name=org.freedesktop.Flatpak FLATPAK_ID`
  2. From the sandbox, start a shell session on the host: `$ flatpak-spawn --host /bin/bash`
* Use a terminal multiplexer.
  1. Set the multiplexer socket path to a folder that can be bind mounted into the sandbox.
    ```
    export SCREENDIR=$XDG_RUNTIME_DIR/screen
    export TMUX_TMPDIR=$XDG_RUNTIME_DIR/tmux
    ```
  2. Create the multiplexer socket folder on boot with systemd-tempfiles.
    ```
    # $XDG_CONFIG_HOME/user-tmpfiles.d/tmux.conf
    d %t/tmux 0700 - - - -
    ```
    ```
    # $XDG_CONFIG_HOME/user-tmpfiles.d/screen.conf
    d %t/screen 0700 - - - -
    ```
  3. Make sure the systemd-tempfiles user service was started and enabled.
    ```
    $ systemctl --user enable --now systemd-tmpfiles-setup.service
    ```
  4. Create overrides.
    ```
    $ flatpak override --user --filesystem=xdg-run/tmux FLATPAK_ID
    $ flatpak override --user --filesystem=xdg-run/screen FLATPAK_ID
    ```


## List of applications

### Container and virtualization
* [Fedora CoreOS Butane](io.github.coreos.butane)
* [Virt-Manager](org.virt_manager.virt-manager)
* [Virt-Viewer](org.virt_manager.virt-viewer)

### Development

#### Development/Binary analysis

##### Development/Binary analysis/Assembler & disassemblers
* [Hopper](com.hopperapp.hopper)
* [REDasm](io.redasm.redasm)
* [Yasm](net.tortall.yasm)

##### Development/Binary analysis/ELF
* [ABI Compliance Checker](pro.abi_laboratory.abi-compliance-checker)
* [libabigail](org.sourceware.libabigail)

##### Development/Binary analysis/Hex editors & viewers
* [BEYE](net.sourceforge.beye)
* [Bviplus](net.sourceforge.bviplus)
* [dhex](net.dettus.dhex)
* [hexer](com.gitlab.hexer)
* [hexyl](com.github.sharkdp.hexyl)
* [hyx](cc.yx7.hyx)

##### Development/Binary analysis/Firmware
* [Binwalk](com.refirmlabs.binwalk)
* [UEFITool](com.github.longsoft.uefitool)

##### Development/Binary analysis/PE
* [pev](com.github.merces.pev)

#### Development/Database
* [DB Browser for SQLite](com.github.sqlitebrowser.sqlitebrowser)
* [SQLiteStudio](pl.sqlitestudio.sqlitestudio)

#### Development/Debugging
* [GDBFrontend](com.oguzhaneroglu.gdb-frontend)

#### Development/Flatpak
* [Flatpak Builder](io.github.flatpak.flatpak-builder) **(Also on Flathub as `org.flatpak.Builder`)**

#### Development/Kernel
* [Hotspot](com.kdab.hotspot)

#### Development/Markup & data serialization
* [dasel](com.github.tomwright.dasel)
* [jq](io.github.stedolan.jq)
* [yq](io.github.kislyuk.yq)

#### Development/Python
* [pyautogit](io.github.jwlodek.pyautogit)
* [Pyinstaller](org.pyinstaller.pyinstaller)

#### Development/VCS
* [GitHub CLI](com.github.cli)
* [GitHub hub](com.github.hub)

### Display server
* [Sway](org.swaywm.sway)

#### Display server/Remoting and screen sharing
* [FreeRDP](com.freerdp.freerdp)
* [Sunshine](com.github.loki_47_6F_64.sunshine)
* [Weylus](com.github.h_m_h.weylus)
* [wlvncc](com.github.any1.wlvncc)

#### Display server/Screen config managers
* [wdisplays](org.swaywm.wdisplays)

#### Display server/Shell
* [Hybridbar](com.github.hcsubser.hybridbar)
* [Waybar](com.github.alexays.waybar)
* [nwg-panel](com.github.nwg_piotr.nwg-panel)

#### Display server/X11
* [Xpra](org.xpra.xpra)
* [xeyes](org.freedesktop.xorg.xeyes)
* [xprop](org.freedesktop.xorg.xprop)

### Documents

#### Documents/Journaling
* [Journey](cloud.journey.journey)

#### Documents/Notetaking
* [Boost Note](io.boostnote.boostnote)

#### Documents/Office suites and editors
* [Zoho Writer](com.zoho.writer)

#### Documents/PDF tools
* [PDFSam](org.pdfsam.pdfsam) **(check out [PDF Mix Tool](https://flathub.org/apps/details/eu.scarpetta.PDFMixTool), it might be a better choice)**
* [pdfcrack](net.sourceforge.pdfcrack)

#### Documents/Text editors
* [Neovim Qt](com.github.equalsraf.neovim-qt)
* [Notepad++](org.notepad_plus_plus.notepadpp) **(WIP)**
* [l3afpad](com.github.stevenhoneyman.l3afpad)

#### Documents/Viewers
* [Pympress](io.github.cimbali.pympress)
* [Qpdfview](net.launchpad.qpdfview)
* [Sioyek](info.sioyek.sioyek)
* [Zathura](org.pwmt.zathura)
* [pdfpc](com.github.pdfpc.pdfpc)

### Electronics

#### Electronics/Analog circuit simulation
* [LTspice](com.analog.ltspice) **(WIP)**
* [Oregano](com.github.drahnr.oregano) **(EOL)**
* [Qucs-S](com.github.ra3xdh.qucs-s)
* [Qucs](com.github.qucs.qucs)
* [gSpiceUI](net.sourceforge.msw012.gspiceui)

#### Electronics/Digital logic
* [BOOLR](me.boolr.boolr) **(Abandoned)**
* [Digital](com.github.hneemann.digital)
* [SmartSim](uk.org.smartsim.smartsim)

#### Electronics/Embedded
* [ARM Mbed Studio](com.mbed.os.mbedstudio)
* [Arduino CLI](io.github.arduino.arduino-cli)
* [Arduino Create Agent](cc.arduino.arduino-create-agent)
* [Code With Mu](mu.codewith.editor)
* [Microchip MPLAB X IDE](com.microchip.mplabx)
* [NXP MCUXpresso IDE](com.nxp.mcuxpressoide) **(Authenticated download is required now. Use the extra-data caching method)**
* [PICsimLab](io.github.lcgamboa.picsimlab)
* [TI CCSTUDIO IDE](com.ti.ccstudio)

#### Electronics/HDL
* [Icestudio](io.icestudio.icestudio)
* [Lattice Diamond](com.latticesemi.diamond)
* [Papilio DesignLab IDE](net.gadgetfactory.papilio-designlab) **(Abandoned)**
* [Intel Quartus Prime ModelSim Altera Starter Edition](com.intel.quartus_prime.modelsim_ase)
* [Intel Quartus Prime Lite](com.intel.quartus_prime.quartus_lite)

#### Electronics/Printed circuit board design
* [Autodesk Eagle](com.autodesk.eagle)
* [gEDA](org.geda_project.geda)

#### Electronics/Signals

##### Electronics/Signals/Instrumentation
* [SmuView](com.github.knarfs.smuview)
* [PulseView](org.sigrok.pulseview)

##### Science/Electronics/Signals/SDR
* [GNU Radio](org.gnuradio.gnuradio)
* [Gqrx SDR](dk.gqrx.gqrx)
* [QSpectrumAnalyzer](com.github.xmikos.qspectrumanalyzer)
* [SDR#](com.airspy.sdrsharp) **(Latest Linux Mono compatible version)**
* [SDR# (Windows)](com.airspy.sdrsharp-win) **(WIP, no drivers, SPY server only)**
* [SigDigger](com.github.batchdrake.sigdigger)

### Engineering

#### Engineering/CAD
* [BRL-CAD](org.brlcad.brlcad)
* [Fusion 360](com.autodesk.fusion360) **(WIP, not working correctly ATM)**
* [LibreCAD](org.librecad.librecad)
* [QCAD](org.qcad.qcad)

#### Engineering/Calculators and unit converters
* [bc](org.gnu.bc)
* [bcal](com.github.jarun.bcal)

### Games
* [Cemu](info.cemu.cemu) **(WIP)**
* [SDLPoP: Prince of Persia](com.github.nagyd.sdlpop)

### Files

#### Files/Mobile devices
* [Android File Transfer for Linux](com.github.whoozle.android-file-transfer-linux)
* [ifuse](org.libimobiledevice.ifuse)

#### Files/File managers
* [QtFM](com.github.rodlie.qtfm)
* [Sunflower](org.sunflower_fm.sunflower)

#### Files/Archiving and compression tools
* [unappimage](com.github.refi64.unappimage)

#### Files/Duplicates cleaners
* [rmlint](com.github.sahib.rmlint)

### Fonts
* [Noto CJK Fonts](org.freedesktop.Platform.Fonts.NotoCJK)
* [Noto Emoji Font](org.freedesktop.Platform.Fonts.NotoEmoji)
* [Noto Fonts](org.freedesktop.Platform.Fonts.Noto)

### Fonts/Tools
* [Fontweak](com.github.guoyunhe.fontweak) **(EOL)**
* [Google Fonts Tools](com.google.fonts.gftools)
* [LCDF Typetools](org.lcdf.lcdf-typetools)

### Internet

#### Internet/Communication
* [Ripcord](fm.cancel.ripcord)
* [WeeChat](org.weechat.weechat)

#### Internet/File sharing

##### Internet/File sharing/BitTorrent
* [trxo](com.github.tinywrkb.trxo)
* [tremc](com.github.tremc)

##### Internet/File sharing/Cloud sync
* [Insync](com.insynchq.insync)
* [Megatools](com.megous.megatools)
* [Rclone](org.rclone.rclone)

#### Internet/Media downloaders
* [youtube-dl](org.ytdl.youtube-dl)

#### Internet/URL watcher
* [urlwatch](io.thp.urlwatch)

#### Internet/Web browsers
* [Chrome](com.google.chrome) **(Also on Flathub as `com.google.Chrome`)**
* [Chrome Unstable](com.google.chrome-unstable)
* [Edge Dev](com.microsoft.edge-dev)

### Math

#### Math/Algebra
* [wxMaxima](com.github.wxmaxima_developers.wxmaxima)

### Multimedia

#### Multimedia/Codecs
* [FFmpeg](org.ffmpeg.ffmpeg)

#### Multimedia/Icons
* [icoutils](org.nongnu.icoutils)

#### Multimedia/Image
* [PTGui](com.ptgui.ptgui)
* [exiv2](org.exiv2.exiv2)
* [imv](com.github.exec64.imv)
* [jhead](com.github.matthias_wandel.jhead)
* [qimgv](com.github.easymodo.qimgv)

##### Multimedia/Image/Screenshot
* [Swappy](com.github.jtheoof.swappy)

#### Multimedia/Audio
* [mps-youtube](com.github.mps-youtube)
* [QjackCtl](io.sourceforge.qjackctl)
* [Qsynth](io.sourceforge.qsynth)
* [pasystray](com.github.christophgysin.pasystray)
* [puddletag](net.puddletag.puddletag)

#### Multimedia/Video
* [mpv](io.mpv.player) **(Also on Flathub as `io.mpv.Mpv`)**

### Network

#### Network/Diagnostics
* [speedtest-cli](com.github.sivel.speedtest-cli)

#### Network/Network managers
* [Airport Utility](com.apple.airport-utility) **(WIP)**
* [iwgtk](org.twosheds.iwgtk)

### Security

#### Security/2FA, passwords & keys
* [Authy](com.authy.authy)
* [gpg-tui](dev.orhun.gpg-tui)

#### Security/Analysis & pentesting
* [SSHGuard](net.sshguard.sshguard)

### System

#### System/Benchmarking & diagnostics
* [GFXBench](com.gfxbench.gfxbench) **(BROKEN, extreme memory leak)**
* [Unigine Heaven](com.unigine.heaven)
* [Unigine Heaven (Windows)](com.unigine.heaven-win) **(WIP)**
* [mesa-demos](org.mesa3d.mesa-demos)
* [s-tui](io.github.amanusk.s-tui)

### Terminal

#### Terminal/Session tools
* [asciinema](org.asciinema.asciinema)

#### Terminal/Text terminal emulators
* [minicom](org.debian.minicom)
* [picocom](com.github.npat_efault.picocom)

#### Terminal/Video terminal emulators
* [Alacritty](com.github.alacritty)
* [GTKTerm](com.github.jeija.gtkterm)
* [Termite](com.github.aperezdc.termite)
* [Wez's Terminal](org.wezfurlong.wezterm)

### Utilities

#### Utilities/Calendar and date
* [libhdate](net.sourceforge.libhdate)
* [hebcal](io.github.hebcal.hebcal)

#### Utilities/Translation
* [Translate Shell](org.soimort.translate-shell)

#### Utilities/Typing
* [GNU Typist](org.gnu.gtypist)
