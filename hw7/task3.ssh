#!/usr/bin/env bash

# Создаем папку
mkdir /usr/lib/dracut/modules.d/01testmodule

# копируем скрипт
cp /vagrant/module_setup.sh /usr/lib/dracut/modules.d/01testmodule/module_setup.sh
cp /vagrant/test.sh /usr/lib/dracut/modules.d/01testmodule/test.sh
chmod +x /usr/lib/dracut/modules.d/01testmodule/module_setup.sh
chmod +x /usr/lib/dracut/modules.d/01testmodule/test.sh

# Обновим образ initrd
# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
dracut -f -v

# Делаем backup и выключим режим тихой загрузки в grub
cp /etc/default/grub /etc/default/grub.backup
sed -i "s/ rhgb quiet//g" /etc/default/grub

# Обновим конфигурацию загрузчика, чтобы применилось выключение тихого режима
cp /boot/grub2/grub.cfg /boot/grub2/grub.cfg.backup
grub2-mkconfig -o /boot/grub2/grub.cfg