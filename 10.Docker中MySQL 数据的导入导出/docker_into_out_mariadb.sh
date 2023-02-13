


# Docker 中 MySQL 数据的导入导出



# 服务器在使用了 Docker 后，对于备份和恢复数据库的事情做下记录：

# 由于 docker 不是实体，所以要把mysql的数据库导出到物理机上，命令如下：

# 1：查看下 mysql 运行名称
# #docker ps
# 结果：



# 2：备份docker数据库
# 1 进入容器，在命令行状态下导出数据表
# 执行mysqldump的命令都是在linux的命令行状态，而不是进入MySQL

mysqldump -uroot -p -B flarum > /home/flarum.sql
# 2 然后把容器中sql文件复制到宿主机
 sudo docker cp mariadb:/home/flarum.sql /home/flarum.sql

# 由第一步的结果可知，我们的 mysql 运行在一个叫 mysql_server 的 docker 容器中。而我们要备份的数据库就在里面，叫做 test_db。mysql 的用户名密码均为root，我们将文件备份到/opt/sql_bak文件夹下。
# Docker容器与本地文件相互拷贝


# 3：导入docker数据库
# 方法1：

# 先将文件导入到容器
# #docker cp **.sql 【容器名】:/root/
# 进入容器
# #docker exec -ti 【容器名/ID】sh
# 将文件导入数据库
# # mysql -uroot -p 【数据库名】 < ***.sql
# 方法2：

# docker exec -i  mysql_server【docker容器名称/ID】 mysqltest_db_copy【数据库名称】 < /opt/sql_bak/test_db.sql【本地数据表路径】

docker cp test_mm mariadb:/root/
# 注意：这里需要将参数 -it 更换为 -i ， 否则会报错：”the input device is not a TTY”



mysqldump -h127.0.0.1 -uroot -B mysql > C:\dd.sql
