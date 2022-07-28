# Sdk.Extension.devenv

This is a little experiement of packaging a user-defined shell environment with CLI tools as a Flatpak SDK extension.  
Naming is not very imaginative, and might change.  
I didn't like the alterntives, connecting a shell from Flatpak sandbox with a host shell or a Podman container shell.
Both sound self-defeating. There should be a good reason to break out of the Flatpak sandbox.  
Shorty after I start playing with this, I figured that there's no reason why I shouldn't re-use this for other
containers, making use of Flatpak's packaging tools to build and keep this updated, so for the most part, the packaged
binaries are statically linked.  
This is very opiniated and user-specific, so you probably don't want to use this as it is, but it will give you a good
idea how to package your own custom environment.  
It should be noted that a [running Flatpak instance will lose a mounted extension when the latter is updated](https://github.com/flatpak/flatpak/issues/4356).  
For that reason, and to support re-using this with other containers, I'm trying to make sure the alternative root path
`/var/lib/devenv` will also work correctly.

An example application, `org.freedesktop.DevEnv`, is used to create a Flatpak instance, with this SDK extension enabled,
but the extension is mainly intended to be used with Flatpak packaged IDEs.

## TODO
* helper scripts
  * fix enable-sdks.sh
  * flatpak-builder like env vars
  * set local installation targets: python, golang, rust
    node: NPM_PACKAGES=xdg-data/npm-packages
          PATH+=:xdg-data/npm-packages/bin
* add more patched fonts: nerd-fonts
* investigate broken host tmux sessions
* still dynamic: chafa, hub, neovide, python app, luajit bindings
* add tarball generation script
* test portability, needs to work when switching to /var/lib
* investigate the possiblity to keep extension accessible after update, maybe bindfs mount
* see other useful tools @ https://github.com/agarrharr/awesome-cli-apps
* drop musl shared lib, move next to users

### possible failure mapping of sdk path
* stow: hardcoded perl `use dir`, can be patched
* luajit: dynamically linked bindings, not sure if working
* luajit: dynamically linked bindings, check if symlink to libc can be drop into same folder
* luajit: dynamically linked bindings, try again to statically link against libc, but keep shared
* luajit: keep bindings
* libutempter: "libexec"
* kakoune: "libexec", strange one, links to bin, try droping this
* luajit: bindings are in lib, very likely hardcoded path
* byobu: lib execs, check if relative to executable
* running apps might try to access sdk path when they should switch to /var/lib: byobu, neovim
* byobu: etc defaults
* etc/profile.d: can be dropped?
* vimfm: default colors in /etc
* wtf put group, machineid, passwd, resolv.conf in etc?
* share: byobu, fish, fzf, kak, kak-lsp, luajit, nnn, nvim, pyenv, ugrep, vifm, vim, zsh

## How to

**This a bit of ill-formatted mess, sorry.**

fontconfig
  add to fonts.conf see flatpaks README.md
  now: <dir>/usr/lib/sdk/devenv/share/fonts/powerline</dir>
  next: <dir prefix="xdg">fonts/powerline</dir>
  see also https://gitlab.freedesktop.org/fontconfig/fontconfig/-/commit/6f27f42e6140030715075aa3bd3e5cc9e2fdc6f1

easily enable after entering a sandbox
  add override for envvar
    `$ flatpak override --user --env=ENABLE_DEVENV=/usr/lib/sdk/devenv/bin/enable-development-environment`
  enter sandbox and then use envvar to run shell
    `$ $ENABLE_DEVENV`

enter a sandbox with enabled shell
  set envvar in host shell
    `$ export fpde=/usr/lib/sdk/devenv/bin/enable-development-environment`
  enter sandbox
    `$ flatpak run --command=$fpde org.freedesktop.Sdk//21.08`

enable by default, only works with actual apps, not runtimes
  add persist override
    `$ flatpak override --user --persist=. FLATPAK_ID`
  enter sandbox
    `$ flatpak run FLATPAK_ID`
  create .bashrc
    `$ echo 'source $ENABLE_DEVENV' > .bashrc`

terminfo: use updated db
  optional as it's already set by the enable.sh script
  if added to an app packaging, must use quotes like the example
  - '--env=TERMINFO_DIRS=/usr/lib/sdk/devenv/share/terminfo:'

### permissions

ssh
  --filesystem=xdg-config/ssh:ro
  my secret store for storing keys, needed due to symlinks from xdg-config/ssh
    --filesystem=~/.user/hiddendots/openssh:ro
  this is the location of my ssh-agent's socket, and likely not needed anymore with new flatpak releases
    --filesystem=xdg-run/ssh-agent:ro
  this might be already enabled, it only used by gnome-keyring's agent, and basically bind mounts bind-mounts the xdg-run/ssh-auth
    --socket=ssh-auth
  for app/sandbox specific setting, like automatically added known hosts
    --persist=.ssh
  only needed with older than flatpak 1.11.1 https://github.com/flatpak/flatpak/commit/0e0e98e7ef0498946d8172ac6d266679434aab6a
    --env=SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent/sock
  when using non-default ssh config folder, explictly set IdentityFile
    Host *
      IdentityFile ~/.config/ssh/id_rsa
      IdentityFile ...

gnupg
  --filesystem=xdg-config/gnupg:ro
code
  --filesystem=~/projects
ccache
  --filesystem=xdg-cache/ccache
byobu
  --filesystem=xdg-config/byobu/.ssh-agent
  --filesystem=xdg-run/tmux
flatpak-spawn
  --talk-name=org.freedesktop.Flatpak
git
  --filesystem=xdg-config/git:ro
nvim
  --filesystem=xdg-config/nvim:ro
  --filesystem=xdg-data/nvim:ro
less
  new less versions don't need a binary lesskey.bin, source default to XDG_CONFIG_HOME/lesskey,
  only LESSKEYIN envvar needed for host compat
  --filesystem=xdg-config/lesskey:ro
ranger
  folder must be writable
  --filesystem=xdg-config/ranger
dots 
  --filesystem=~/.user/dots
  apps must have a connecting symlink to .user if tool's home cannot be set via envvar to ~/.config/...
    ln -s ../../../.user ~/.var/app/FLATPAK_ID/.user
    only needed if the tool's config home was mounted with --filesystem=xdg-config/... as ~/.config/... won't be mounted in .var
