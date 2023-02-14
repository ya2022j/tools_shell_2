#centos 安#装composer

 
# 2、使用Composer下载thinkphp

# 第一步：首先要把仓库镜像修改成国内的，不然下载很慢

# 全局配置（推荐）

# 所有项目都会使用该镜像地址：

# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# 取消配置：

# composer config -g --unset repos.packagist
# 项目配置

# 仅修改当前工程配置，仅当前工程可使用该镜像地址：

# composer config repo.packagist composer https://mirrors.aliyun.com/composer/
# 取消配置：

# composer config --unset repos.packagist
# 使用composer config -g -l查看配置，结果如下，它已经改了镜像地址



# 1、使用命令下载

curl -sS https://getcomposer.org/installer | php;
# 2.下载之后设置环境变量

mv composer.phar /usr/local/bin/composer;
# 　　如果php版本是7，这样输入composer会报错 ：/usr/bin/env: php: No such file or directory
# 　　解决方法
# 　　cd usr/bin
# 　　cp php73 php
# 　　在输入composer就好了

# 3.修改权限，否则执行会出错

chmod -R 777 /usr/local/bin/composer;
# 4.修改镜像地址为阿里云

composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/;
 

# 5.验证

composer -v
composer self-update --2 

