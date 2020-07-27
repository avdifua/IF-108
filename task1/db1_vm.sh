#!/bin/bash
sudo yum update -y
sudo yum install wget -y
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
sudo yum-config-manager --enable mysql57-community
sudo yum install mysql-community-server -y
sudo service mysqld start
tmp_pass=$(sudo grep 'temporary password' /var/log/mysqld.log | sed 's|.*: ||')

mysql -u root -p$tmp_pass
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';
    CREATE DATABASE dtapi2;
    CREATE USER 'username'@'%' IDENTIFIED BY 'passwordQ1@';
    GRANT ALL PRIVILEGES ON dtapi2.* TO 'username'@'%';
    FLUSH PRIVILEGES;

wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
mysql -u root --password=MyNewPass dtapi2 < ./dtapi_full.sql
echo "bind-address=192.168.33.100" >>/etc/my.cnf
sudo systemctl restart mysqld
