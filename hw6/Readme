## Управление пакетами. Дистрибьюция софта. 

Будем собирать nginx, с библиотекой openssl-1.1.1d.

В рекомендациях по сборке пакетов говорится, что сборка пакетов из-под `root` крайне опасная операция. Поэтому заведем пользователся `builder` из-под которого и будем собирать наш пакет и сразу переключимся в него.

```
$ sudo -i
$ useradd builder && passwd builder
$ usermod -aG builder builder
$ usermod -aG wheel builder
$ su builder
```

Далее запускаем скрипт - [Vagrantfile](https://github.com/TotKtoNeNado/Linux/blob/master/hw6/provision.sh).

```
$ bash provision.sh
```

Как система попросит пароль от УЗ builder, вводим его.
