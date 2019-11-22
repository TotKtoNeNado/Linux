
#!/bin/bash


#Скачиваем дистрибутив

cd /home/builder
wget https://github.com/TotKtoNeNado/Linux/raw/master/hw6/openssl-1.1.1d.tar.gz
tar -xzvf openssl-1.1.1d.tar.gz

wget https://raw.githubusercontent.com/TotKtoNeNado/Linux/master/hw6/nginx.spec

wget https://raw.githubusercontent.com/TotKtoNeNado/Linux/master/hw6/otus.repo

wget https://github.com/TotKtoNeNado/Linux/raw/master/hw6/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -Uvh nginx-1.14.1-1.el7_4.ngx.src.rpm

#Заменяем спеку на нашу с прописанным модулем
cat nginx.spec > /home/builder/rpmbuild/SPECS/nginx.spec

#Ставим все зависимости
sudo yum-builddep /home/builder/rpmbuild/SPECS/nginx.spec -y

#Собираем пакет
rpmbuild -ba /home/builder/rpmbuild/SPECS/nginx.spec

#Ставим собранный nginx
sudo yum localinstall  /home/builder/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm -y

#Создаем папку репозитория
sudo mkdir -p /usr/share/nginx/html/repo

#Копираем созданый пакет в репозиторий
sudo cp /home/builder/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

#Качаем ещё рдин пакет для репозитория
sudo wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

#Создаем репозиторий
sudo createrepo /usr/share/nginx/html/repo/

#Включаем в nginx листинг дириктории
sudo sed '/index.htm;/i autoindex on; ' /etc/nginx/conf.d/default.conf 

#Проверяем конфигурацию и стартуем
sudo nginx -t
sudo systemctl start nginx
sleep 25
sudo systemctl start nginx
sleep 25
sudo systemctl status nginx


#Добавим наш репозиторий в /etc/yum.repos.d
sudo cp -f /home/builder/otus.repo /etc/yum.repos.d/

yum repolist enabled | grep otus

