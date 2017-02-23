#!/bin/sh

set -ex

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
pacman -S --noconfirm vim net-tools openssh
echo -e "en_US.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=ja_JP.UTF-8" >> /etc/locale.conf
echo -e 'KEYMAP=jp106\nFONT=Lat2-Terminus16' > /etc/vconsole.conf
systemctl enable dhcpcd.service
bootctl --path=/boot install
