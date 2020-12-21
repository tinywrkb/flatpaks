# flatpaks

A few Flatpaks that I hastly packaged. These are not thoroughly tested so use at your own risk!  
Packaging was adapted mainly from Arch Linux's official PKGBUILDs and the AUR.  
Most of these are PoC, not maintained, might need some cleanup, missing a feature here and there,
and in general are not ready to publish via Flathub.  
The catalyst for packaging these apps is to prove that it's possible to convert to, and as a precondition
for switching to stateless distributed system, an  os that has a clear seperation between the stateless
read-only distributed OS files and the stateful data and configs.

### Not usable or too buggy

* Blueman
* QtPass

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

Flatpak does not support font packages or extensions, in order for Flatpak and host apps to make use of fonts install via Flatpak we need a few workarounds.


1. Give all our Flatpak apps access to the user's fontconfig configuration file and where the font package is installed.  
Due to the mismatch of `XDG_CONFIG_DIR` value between the host and the Flatpak sandbox (different path for each app), we need to set some environment variables.  
Also note that the fontconfig variable value need to be an absolute path, meaning it needs to be expanded before given to `flatpak override` command.
```
$ flatpak override --user \
    --filesystem=~/.local/share/flatpak:ro \
    --filesystem=/var/lib/flatpak:ro \
    --env=FONTCONFIG_FILE=$XDG_CONFIG_HOME/fontconfig/fonts.conf \
    --env=FONTCONFIG_PATH=$XDG_CONFIG_HOME/fontconfig/conf.d
```

2. Adding the following to `$XDG_CONFIG_HOME/fontconfig/fonts.conf` will tell fontconfig to include the Flatpak font package in its scan.  
The first directive is required because fc-cache omits the default font locations when scanning inside a Flatpak sandbox, and that's due to our use of `FONTCONFIG_FILE` variable.

```
<include ignore_missing="yes">/etc/fonts/fonts.conf</include>

<dir prefix="default">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.<FontName>/current/active/files/share/fonts</dir>
<dir>/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.<FontName>/current/active/files/share/fonts</dir>
<include prefix="default" ignore_missing="yes">.local/share/flatpak/app/org.freedesktop.Platform.Fonts.<FontName>/current/active/files/share/fonts/conf.d</include>
<include ignore_missing="yes">/var/lib/flatpak/app/org.freedesktop.Platform.Fonts.<FontName>/current/active/files/share/fonts/conf.d</include>
```

3. Now we can update the host font cache.

```
cd ~
fc-cache
```

4. To update the font cache of a Flatpak app sandbox just restart the app.

#### Fontconfig related bugs

* [Flatpak: Expose host fontconfig conf.d?](https://github.com/flatpak/flatpak/issues/1563)
* [Flatpak: Expose xdg-config/fontconfig to sandbox by default](https://github.com/flatpak/flatpak/issues/3947)
