#!/bin/sh

set -ex

ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
pacman -S --noconfirm grub vim net-tools openssh os-prober
echo -e "en_US.UTF-8\nja_JP.UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=ja_JP.UTF-8" >> /etc/locale.conf
echo -e 'KEYMAP=jp106\nFONT=Lat2-Terminus16' > /etc/vconsole.conf
systemctl enable dhcpcd.service
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

