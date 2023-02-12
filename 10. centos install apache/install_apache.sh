# https://blog.csdn.net/m0_51395584/article/details/125287501

rpm -qa | grep httpd;
yum install -y httpd;
rpm -qa | grep httpd;
# 启动apache

service httpd start;
#将apache服务设置为默认启动

chkconfig httpd on;


# 查看apache的所有进程

# ps -ef | grep apache

# 如果只在本机访问，就可以访问了，如果需要其他主机访问，就需要开启centos7的80端口。
# 第七步：开放centos7的80端口

# firewall-cmd --zone=public --add-port=80/tcp --permanent;


# 第八步：重启防火墙

# firewall-cmd --reload;


# 第九步：查看端口是否开放

# firewall-cmd --list-ports;

# 第十步：访问网页
# http://（centos7的IP地址）


# 如果要做成文件服务器，就需要修改配置文件
# 第十一步：修改为文件服务器
# 删除或备份/etc/httpd/conf.d/welcome.conf文件(一般备份较为妥当)
# 备份：

# mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak
# 1

# 第十二步：重启apache服务
# 重启apache服务：

# service httpd restart
# 1

# 第十三步：将需要的文件放入到网页的根目录下，在网页中即可访问
# 根目录路径为：

# /var/www/html
# 1

# 网页效果如下：


