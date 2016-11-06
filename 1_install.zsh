#!/bin/zsh
# 参考: http://kunst1080.hatenablog.com/entry/2014/10/19/212305

vared -p "Hostname: " -c NEWHOSTNAME
vared -p "root passwd: " -c ROOTPASSWD


loadkeys jp106
# setup HDD (4GB swap)
parted -s /dev/sda mklabel gpt
parted -s /dev/sda -- mkpart primary ext2 0 2MB
parted -s /dev/sda -- mkpart primary ext4 2MB -4098MB
parted -s /dev/sda -- mkpart primary ext4 -4097MB -1MB
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3

# Install Base system
mount /dev/sda2 /mnt
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
cp -f `dirname $0`/chroot-setup.sh /mnt/root/chroot-setup.sh
echo "echo root:$ROOTPASSWD | chpasswd" >> /mnt/root/chroot-setup.sh
chmod +x /mnt/root/chroot-setup.sh
arch-chroot /mnt /root/chroot-setup.sh
