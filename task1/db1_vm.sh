#!/bin/bash
sudo yum update -y
sudo yum install wget -y
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
sudo yum-config-manager --enable mysql57-community
sudo yum install mysql-community-server -y
sudo service mysqld start



cat <<_EOF >./my.expect
#!/usr/bin/expect -f
set timeout 3
spawn mysql -u root -p
expect "Enter password:"
send "[lindex \$argv 0]
"
expect "mysql>"
send "
"
expect "mysql>"
send "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RootPWD1@';
CREATE DATABASE dtapi2;
CREATE USER 'username'@'%' IDENTIFIED BY 'passwordQ1@';
GRANT ALL PRIVILEGES ON dtapi2.* TO 'username'@'%';
FLUSH PRIVILEGES;
exit
"
interact
_EOF
sudo yum install expect -y
sudo chmod 777 ./my.expect
sleep 5s
sudo grep 'temporary password' /var/log/mysqld.log | sed 's|.*: ||' >./1.txt
tmp_pass=$(cat 1.txt)
echo "$tmp_pass"
./my.expect $tmp_pass
wget https://dtapi.if.ua/~yurkovskiy/dtapi_full.sql
mysql -u root --password=RootPWD1@ dtapi2 < ./dtapi_full.sql
sudo chmod 666 /etc/my.cnf
sudo echo "bind-address=192.168.33.100" >>/etc/my.cnf
sudo chmod 644 /etc/my.cnf
sudo systemctl restart mysqld
