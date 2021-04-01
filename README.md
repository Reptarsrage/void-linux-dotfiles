# Void Linux

Based on the base image from [voidlinux.org](https://voidlinux.org/)

## Update dependencies

```sh
sudo xbps-install -u xbps
sudo xbps-install -Suv
```

## Install Gui

```sh
sudo xbps-install -S xorg
```

## Install login

```sh
sudo xbps-install -S lightdm lightdm-mini-greeter
```

> **NOTE**: Add `greeter-session=lightdm-mini-greeter` and `user-seccion=bspwm` to `/etc/lightdm/lightdm.conf` under `[Seat:*]`.
> **NOTE**: Copy `lightdm-mini-greeter.conf` to `/etc/lightdm/lightdm-mini-greeter.conf`


## Install additional dependencies

```sh
sudo xbps-install -S bspwm sxhkd polybar rofi picom feh xscreensaver fzf curl neovim xbacklight alsa-utils opendoas git pkg-config make gcc font-awesome5
```

## Install fonts

```sh
cp -r ./fonts/* ~/.local/share/fonts/
fc-cache -fv
```

## Copy configs

```sh
cp -r ./config/* ~/.config/
cp ./.bashrc ~/.bashrc
cp ./.Xresources ~/.Xresources
cp ./lightdm-mini-greeter.conf /etc/lightdm/lightdm-mini-greeter.conf
cp ./run.bspwm /usr/share/run.bspwm
chmod +x ~/.conf/bspwm/bspwmrc
chmod +x ~/.conf/polybar/launch.sh
chmod +x ~/usr/share/run.bspwm
```

> **NOTE**: Edit `/usr/share/xsessions/bspwm.desktop` and set `Exec=/usr/share/run.bspwm`

## Install terminal

```sh
git clone https://github.com/siduck76/st.git
cd st
make
sudo make install
```

## Setup doas

```sh
sudoedit /etc/doas.conf
```

> **NOTE**: More info here: [doas.conf](https://man.openbsd.org/doas.conf.5)

## Install xbps-updates module for polybar

```sh
git clone https://github.com/siduck76/xbps-updates.git
install -Dm755 ./xbps-updates/xbps-updates /usr/local/bin/xbps-updates
```

## Add startup services (no going back after this!)

```sh
sudo ln -s /etc/sv/dbus /var/service/dbus
sudo ln -s /etc/sv/lightdm /var/service/lightdm
```

## Changing theme

```sh
git clone https://github.com/base16-templates/base16-xresources.git
cd base16-xresources/xresources
use <Pick One>.Xresources && load
```

