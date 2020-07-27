#!/bin/bash
sudo yum update -y
sudo yum install mysql -y
sudo yum install mc -y
setenforce 0

sudo yum install epel-release -y
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm
sudo yum --enablerepo=remi-php72 install php php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd \
 php-mcrypt php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd -y
sudo yum-config-manager --enable remi-php72

sudo yum install httpd -y
sudo yum install git -y
git clone https://github.com/yurkovskiy/dtapi.git


#mysql -u username --password=passwordQ1@ -h 192.168.33.100
