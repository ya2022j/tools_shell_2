# centos7默认源的php版本只有5.4，版本太老，而mediawiki需要的php版本为7.4以上，所以本文直接升级到php8.0。

# 步骤
# 卸载所有已安装的php
yum remove -y php*;
# 添加remi源（可能需要提前安装epel-release）
 yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm; # 此处若是无法下载  可用
 rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
 rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm;
# 单独启用php80的源（没有yum-config-manager命令的话需要安装yum-utils）
 yum-config-manager --disable 'remi-php*';
 yum-config-manager --enable remi-php80;
# 安装php及其拓展
 yum install -y php php-bcmath php-cli php-common php-devel php-fpm php-gd php-intl php-ldap php-mbstring php-mysqlnd php-odbc php-pdo php-pear php-pecl-xmlrpc php-pecl-zip php-process php-snmp php-soap php-sodium php-xml;
# 版本验证
 php -v;



