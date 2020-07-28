#!/bin/bash
sudo yum update -y
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
git clone https://github.com/avvppro/IF-108.git
mkdir IF-108/task1/dt-api/application/logs IF-108/task1/dt-api/application/cache
chmod 766 IF-108/task1/dt-api/application/logs
chmod 766 IF-108/task1/dt-api/application/cache
sudo chown apache:apache IF-108/task1/*/*/*
sudo mv IF-108/task1/dt-api /var/www/
sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
sudo echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
sudo cat <<_EOF > /etc/httpd/sites-available/dt-api.com.conf
<VirtualHost *:80>
    #    ServerName www.example.com
    #    ServerAlias example.com
    DocumentRoot /var/www/dt-api
    ErrorLog /var/log/httpd/dt-api/error.log
    CustomLog /var/log/httpd/dt-api/requests.log combined
    <Directory /var/www/dt-api/>
            AllowOverride All
    </Directory>
</VirtualHost>
_EOF

sudo mkdir /var/log/httpd/dt-api
sudo ln -s /etc/httpd/sites-available/dt-api.com.conf /etc/httpd/sites-enabled/dt-api.com.conf
systemctl restart httpd
#mysql -u username --password=passwordQ1@ -h 192.168.33.100
