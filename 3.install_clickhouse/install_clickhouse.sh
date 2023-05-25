
#//CentOS7单机快速安装clickhouse
#//https://www.51cto.com/article/631053.html
#//RHEL/CentOS 用户

#新建 /etc/yum.repos.d/clickhouse.repo，内容为
echo '[clickhouse] '>> /etc/yum.repos.d/clickhouse.repo;
echo 'name=clickhouse stable  '>> /etc/yum.repos.d/clickhouse.repo;
echo 'baseurl=https://mirrors.tuna.tsinghua.edu.cn/clickhouse/rpm/stable/x86_64  '>> /etc/yum.repos.d/clickhouse.repo;
echo 'enabled=1  '>> /etc/yum.repos.d/clickhouse.repo;
echo 'gpgcheck=0  '>> /etc/yum.repos.d/clickhouse.repo;


#
#安装
#
#在CentOS7上直接使用yum直接安装就可以。


yum install clickhouse-server clickhouse-client -y 
#1.
#启动服务并设置开机启动


systemctl start clickhouse-server ;
systemctl enable clickhouse-server ;


#直接使用clickhouse-client进行连接


#clickhouse-client
#1.
#创建数据库和一张表测试


#create database metrics;
#use metrics
#create table servers( id UInt64 ,ip String ,count UInt64) engine=TinyLog;
#insert into servers (id , ip , count) values (1,'127.0.0.1',100);
#select * from servers;
#
#centos7 :) select * from servers;
