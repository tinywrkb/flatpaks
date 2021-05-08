# flatpak-external-data-checker

## Initilize deb apt

* Enter the sandbox

```
flatpak run --command=sh org.flathub.flatpak-external-data-checker
```

* Add apt repository

```
mkdir -p $XDG_CONFIG_HOME/apt

echo 'deb http://deb.debian.org/debian buster main' >> \
  $XDG_CONFIG_HOME/apt/sources.list

echo 'deb https://packages.microsoft.com/repos/edge stable main' >> \
  $XDG_CONFIG_HOME/apt/sources.list
```

* Add public keys

```
mkdir -p $XDG_CONFIG_HOME/apt
touch $XDG_CONFIG_HOME/apt/trusted.gpg

apt-key adv \
  --primary-keyring $XDG_CONFIG_HOME/apt/trusted.gpg \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 04EE7237B7D453EC 648ACFD622F3D138 DCC9EFBF77E11517

wget https://packages.microsoft.com/keys/microsoft.asc \
  -O $XDG_CONFIG_HOME/apt/trusted.gpg.d/microsoft.asc
# or
curl -L https://packages.microsoft.com/keys/microsoft.asc | \
  apt-key adv --import --primary-keyring $XDG_CONFIG_HOME/apt/trusted.gpg
```

* Update package information

```
apt-xdg update
```
