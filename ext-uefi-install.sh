#!/bin/bash

echo "--------------------------------"
echo "--   Swapfile Configuration   --"
echo "--------------------------------"
# Swapfile configuration goes here
# Note: This configuration is for EXT4 without swap partition

dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab

echo "------------------------------"
echo "--   Locale Configuration   --"
echo "------------------------------"
# Locale configuration goes here
# You can customize hostnameconf and passwordroot

hostnameconf=tahiti
passwordroot=insertyourpassword

ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo $hostnameconf >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostnameconf.localdomain $hostnameconf" >> /etc/hosts
echo root:insertyourpassword | chpasswd

echo "---------------------------------"
echo "--   Grub and other packages   --"
echo "---------------------------------"
# Grub and other packages

pacman -S --noconfirm grub efibootmgr xdg-utils xdg-user-dirs \
ntfs-3g networkmanager network-manager-applet mlocate \
neofetch alsa-utils pipewire pipewire-pulse pipewire-alsa \
cups system-config-printer ghostscript cups-pdf gutenprint \
foomatic-db-gutenprint-ppds htop os-prober git wget zsh \
zsh-autosuggestions zsh-syntax-highlighting wl-clipboard \
xclip android-tools cpupower p7zip mtools dosfstools

# Installation for AMD GPU
#pacman -S --noconfirm xf86-video-amdgpu vulkan-radeon \
#libva-mesa-driver mesa-vdpau

# Installation for NVIDIA GPU
#pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Grub installation
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable systemd services
systemctl enable NetworkManager
systemctl enable cups.service
#systemctl enable fstrim.timer

echo "-----------------------"
echo "--   User Creation   --"
echo "-----------------------"
# Create Username
# You can customize username and passworduser

username=arthur
passworduser=insertyourpassword

useradd -m $username
echo $username:$passworduser | chpasswd
usermod -aG wheel $username
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo "---------------"
echo "--   Fonts   --"
echo "---------------"
# Startup Fonts

pacman -S --noconfirm ttf-roboto noto-fonts ttf-cormorant \
ttf-droid ttf-opensans cantarell-fonts ttf-dejavu \
ttf-liberation ttf-caladea ttf-carlito ttf-croscore

printf "\nKEEP THE CHANGE YOU FILTHY ANIMAL\n"
