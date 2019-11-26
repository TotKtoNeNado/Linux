#!/bin/bash

# Объявляем переменные, и получаем имя vg 
oldvgname=$(vgs --rows | grep VG | cut -d ' ' -f4)
newvgname=VG001

# Переименовываем vg
vgrename $oldvgname $newvgname

# Навсякий делаем backup
cp -f /etc/fstab /etc/fstab.backup
cp -f /etc/default/grub /etc/default/grub.backup
cp -f /boot/grub2/grub.cfg /boot/grub2/grub.cfg.backup

# обнавляем fstab и шаблоне grub
sed -i "s/$oldvgname/$newvgname/g" /etc/fstab
sed -i "s/$oldvgname/$newvgname/g" /etc/default/grub.backup
sed -i "s/$oldvgname/$newvgname/g" /boot/grub2/grub.cfg

# Пересоздадим initrd, чтобы начальный образ знал про новый vg
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

# Сделаем relable для файловой системы, а то потом в ssh не зайдём.
touch /.autorelabel

# Перезагрузка.
reboot