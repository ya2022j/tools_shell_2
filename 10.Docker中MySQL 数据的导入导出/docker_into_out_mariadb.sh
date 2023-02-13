


# Docker 中 MySQL 数据的导入导出



# 服务器在使用了 Docker 后，对于备份和恢复数据库的事情做下记录：

# 由于 docker 不是实体，所以要把mysql的数据库导出到物理机上，命令如下：

# 1：查看下 mysql 运行名称
# #docker ps
# 结果：



# 2：备份docker数据库
# 由第一步的结果可知，我们的 mysql 运行在一个叫 mysql_server 的 docker 容器中。而我们要备份的数据库就在里面，叫做 test_db。mysql 的用户名密码均为root，我们将文件备份到/opt/sql_bak文件夹下。

# docker exec -it  mysql_server【docker容器名称/ID】 mysqldump -uroot -p123456【数据库密码】 test_db【数据库名称】 > /opt/sql_bak/test_db.sql【导出表格路径】

docker exec -it mariadb  mariadb mysqldump -uroot -p123456 flarum > /home/flarum.sql

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

