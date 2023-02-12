前言：
最近，在一台新服务器上准备运行一个前端vue项目，服务器上安装了docker，想要尝试试通过docker安装nginx的并运行项目，以下是操作步骤

操作步骤：
一、安装nginx
1、拉取镜像
从docker仓库里拉取最新的镜像

docker pull nginx
1
2、创建映射目录
需要先在宿主机创建Nginx外部挂载的配置文件（ /usr/local/docker/nginx.conf）
(Nginx本身容器只存在/etc/nginx 目录 , 本身就不创建 nginx.conf 文件,当服务器和容器都不存在 nginx.conf 文件时, 执行启动命令的时候 docker会将nginx.conf 作为目录创建 , 这并不是我们想要的结果 。)

# 创建挂载目录
mkdir -p /usr/local/docker/nginx/conf
mkdir -p /usr/local/docker/nginx/log
mkdir -p /usr/local/docker/nginx/html

然后运行nginx容器，并将容器里的文件复制到宿主机对应的文件夹

# 生成容器
docker run --name nginx -p 80:80 -d nginx
# 将容器nginx.conf文件复制到宿主机
docker cp nginx:/etc/nginx/nginx.conf /usr/local/docker/nginx/conf/nginx.conf
# 将容器conf.d文件夹下内容复制到宿主机
docker cp nginx:/etc/nginx/conf.d /usr/local/docker/nginx/conf/conf.d
# 将容器中的html文件夹复制到宿主机
docker cp nginx:/usr/share/nginx/html /usr/local/docker/nginx/

复制完容器里对应的文件后，将容器删除重新生成

# 关闭该容器
docker stop nginx
# 删除该容器
docker rm nginx

# 或使用此命令，删除正在运行的nginx容器
docker rm -f nginx

3、启动容器
使用如下命令启动容器

docker run \
-p 80:80 \
--name nginx \
--restart=always \
-v /usr/local/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /usr/local/docker/nginx/conf/conf.d:/etc/nginx/conf.d \
-v /usr/local/docker/nginx/log:/var/log/nginx \
-v /usr/local/docker/nginx/html:/usr/share/nginx/html \
-d nginx:latest


localhost 测试nginx
