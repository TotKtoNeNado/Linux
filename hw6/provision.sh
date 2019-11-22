
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
yum-builddep /home/builder/rpmbuild/SPECS/nginx.spec

#Собираем пакет
rpmbuild -ba /home/builder/rpmbuild/SPECS/nginx.spec


sudo yum localinstall  /home/builder/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm -y


sudo mkdir -p /usr/share/nginx/html/repo

sudo cp /home/builder/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

sudo wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

sudo createrepo /usr/share/nginx/html/repo/

sudo sed '/index.htm;/i autoindex on; ' /etc/nginx/conf.d/default.conf 

sudo nginx -t
sudo systemctl start nginx
sudo systemctl status nginx

sudo cat /home/builder/otus.repo /etc/yum.repos.d/otus.repo 

yum repolist enabled | grep otus
yum list | grep otus