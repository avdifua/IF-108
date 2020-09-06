FROM centos:7

WORKDIR /home

COPY ./httpd /home

RUN yum update -y \
    && yum -y install sudo \
    && yum install epel-release yum-utils -y \
    && yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y \
    && yum-config-manager --enable remi-php72 -y \
    && yum --enablerepo=remi-php72 install php php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd \
 php-mcrypt php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd -y \
    $$ yum install git wget httpd -y \
    && systemctl enable httpd \
    && git clone https://github.com/protos-kr/IF-108.git \
    && mkdir IF-108/application/logs IF-108/application/cache \
	&& mkdir -p /var/www/dtester/dt-api \
    && echo "/var/www/dtester/dt-api" | xargs -n 1 cp -r IF-108/* \
	&& cp /home/IF-108/.htaccess /var/www/dtester/dt-api \
	&& mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled /var/log/httpd/dtester \
    && cp /home/dtester.conf /etc/httpd/sites-available/ \
	&& echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf \
    && ln -s /etc/httpd/sites-available/dtester.conf /etc/httpd/sites-enabled/dtester.conf \
    && sed -i -e "s/'type'       => 'MySQL'/'type'       => 'PDO'/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'hostname'   => 'localhost'/'hostname'   => 'db'/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'database'   => 'dtapi2'/'database'   => 'dtesterav'/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'username'   => 'dtapi'/'username'   => 'userdt'/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'password'   => 'dtapi'/'password'   => '6f+w4PXyboSHaI='/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'dsn'        => 'mysql:host=192.168.33.100;dbname=dtapi2;charset=utf8'/'dsn'        => 'mysql:host=dtester-mysql;dbname=dtesterav;charset=utf8'/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'username'   => 'username'/'username'   => 'userdt'/g" /var/www/dtester/dt-api/application/config/database.php \
    && sed -i -e "s/'password'   => 'passwordQ1@'/'password'   => '6f+w4PXyboSHaI='/g" /var/www/dtester/dt-api/application/config/database.php \
    && chown -R apache:apache -R /var/www/dtester/ \
    && chmod 766 -R /var/www/dtester/ \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
