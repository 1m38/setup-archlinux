#!/bin/sh

set -ex

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
pacman -S --noconfirm vim net-tools openssh ed
echo -e "en_US.UTF-8 UTF-8\nja_JP.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=ja_JP.UTF-8" >> /etc/locale.conf
echo -e 'KEYMAP=jp106\nFONT=Lat2-Terminus16' > /etc/vconsole.conf
systemctl enable dhcpcd.service
# EFI boot setting
bootctl --path=/boot install
cp -f /root/setup/efi_setup/loader.conf /boot/loader/loader.conf
cp -f /root/setup/efi_setup/arch.conf /boot/loader/entries/arch.conf
PARTUUID=`blkid -s PARTUUID -o value /dev/sda2`
sed -i -e "s|\[PARTUUID\]|$PARTUUID|" /boot/loader/entries/arch.conf

# sudo
EDITOR=ed visudo <<'EOC'
$
a
%wheel ALL=(ALL) ALL
Defaults env_keep += "HOME"
.
w
q
EOC
