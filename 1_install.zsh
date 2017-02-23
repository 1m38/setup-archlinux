#!/bin/zsh
# 参考: http://kunst1080.hatenablog.com/entry/2014/10/19/212305

vared -p "Hostname: " -c NEWHOSTNAME
vared -p "root passwd: " -c ROOTPASSWD

set -ex

# setup HDD (4GB swap)
parted -s /dev/sda mklabel gpt
parted -s /dev/sda -- mkpart ESP fat32 1MiB 513MiB
parted -s /dev/sda -- set 1 boot on
parted -s /dev/sda -- mkpart primary ext4 513MiB -4098MiB
parted -s /dev/sda -- mkpart primary linux-swap -4098MiB 100%
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3

# Install Base system
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
grep jp /etc/pacman.d/mirrorlist.old > /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist.old >> /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel

# fstab
genfstab -p /mnt >> /mnt/etc/fstab
# hostname
echo $NEWHOSTNAME > /mnt/etc/hostname

# Run setup script on chroot environment
mkdir -p /mnt/root
cp -af `dirname $0` /mnt/root/setup
echo "echo \"root:$ROOTPASSWD\" | chpasswd" >> /mnt/root/setup/chroot-setup.sh
chmod +x /mnt/root/setup/chroot-setup.sh
arch-chroot /mnt /root/setup/chroot-setup.sh
rm -rf /mnt/root/setup

# shutdown
umount /dev/sda1 /dev/sda2
poweroff
