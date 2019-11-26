## Загрузка Linux. 

Данную лабараторную работу выполнял с виртуалки не из Vagranta а ручками поставленной из iso.

Для работы способов ниже в Vagrant требуется:
В меню GRUB, в параметрах загрузки ядра удалите console=ttyS0,115200n28.

### 1.Попасть в систему без пароля несколькими способами 

Вход в систему без пароля можно осуществить меняя конфигурацию файлов загрузчика, добавляя или изменяя ряд параметров. 

Во время загрузки, при выборе ядра нажать e - в данном контексте edit. Попадаем в окно где мы можем изменить параметры загрузки:


#### Вариант 1: init=/sysroot/bin/sh

Этот способ позволяет запустить шелл, указав это директивно. Перед переключеним контекста на дальнейший старт системы (вместо запуска первого процесса init) после загрузки ядра и монтирования файловых систем.

>linux16 /vmlinuz-3.10.0-862.14.4.el7.x86_64 root=/dev/mapper/centos-root `rw init=/sysroot/bin/sh` rhgb quiet rd.auto=1 rd.lvm=1 rd.lvm.vg=centos rg.lvm.lv=root rg.lvm.lv=swap rg.lvm.lv=boot 

Далее сбрасываем пароль.

```
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```

#### Вариант 2: rd.break

Этот способ позволяет получить шелл указав конкретное место, в котором следует это сделать при загрузке модулей при старте initrd:

>linux16 /vmlinuz-3.10.0-862.14.4.el7.x86_64 root=/dev/mapper/centos-root ro rhgb quiet rd.auto=1 rd.lvm=1 rd.lvm.vg=centos rg.lvm.lv=root rg.lvm.lv=swap rg.lvm.lv=boot `rd.break=pre-mount`

В данном случае, указан хук `pre-mount` - "перед монированием файловой системы".

```
$ mount -rw /dev/mapper/centos-root /sysroot
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```

### Вариант 3: rd.shell

Официальный способ получить "emergency shell" при загрузке системы.

>linux16 /vmlinuz-3.10.0-862.14.4.el7.x86_64 root=/dev/mapper/centos-root ro rhgb quiet rd.auto=1 rd.lvm=1 rd.lvm.vg=centos rg.lvm.lv=root rg.lvm.lv=swap rg.lvm.lv=boot `rd.shell`

```
$ mount -o remount,rw /sysroot
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```


### 2. Установить систему с LVM, после чего переименовать VG


```
[root@hw7 ~]# vgs
  VG  #PV #LV #SN Attr   VSize  VFree
  sup   1   1   0 wz--n- <20,00g   0
```

Далее запускаем скрипт - [task2.sh](https://github.com/TotKtoNeNado/Linux/blob/master/hw7/task2.sh).

```
[root@hw7 ~]# vgs
  VG  #PV #LV #SN Attr   VSize  VFree
  VG01  1   1   0 wz--n- <20,00g   0
```

### 3. Добавить модуль в initrd

Запускаем скрипт - [task3.sh](https://github.com/TotKtoNeNado/Linux/blob/master/hw7/task3.sh).