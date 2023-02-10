

docker安装nginx及端口映射相关配置
https://blog.csdn.net/weixin_43977226/article/details/128411102


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


命令	描述
-p 80:80	将容器的 80(后面那个) 端口映射到主机的 80(前面那个) 端口
–name nginx	容器的名字
–restart=always	在Docker重启时,自动重启容器
-v /usr/local/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf	挂载nginx.conf配置文件
-v /usr/local/docker/nginx/conf/conf.d:/etc/nginx/conf.d	挂载nginx配置文件
-v /usr/local/docker/nginx/log:/var/log/nginx	挂载nginx日志文件
-v /usr/local/docker/nginx/html:/usr/share/nginx/html	挂载nginx内容
-d nginx:latest	本地运行的版本
启动完之后，在浏览器输入ip进行访问，如下页面则意味着启动成功


二、nginx容器端口映射配置
在上述操作步骤中，我只将80端口与宿主机进行了映射，也就意味着只能使用80端口访问nginx,如果要使用nginx启动多个前端项目的时候，则需要将容器里的多个端口映射到宿主机。有两种方式可以实现。

方式一：启动容器时挂载多个端口

nginx--->80---> flarum--->8000
docker run \
-p 80:8000 \
--name nginx \
--restart=always \
-v /usr/local/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /usr/local/docker/nginx/conf/conf.d:/etc/nginx/conf.d \
-v /usr/local/docker/nginx/log:/var/log/nginx \
-v /usr/local/docker/nginx/html:/usr/share/nginx/html \
-d nginx:latest

也就是在用容器里面的Nginx代理，容器里面的flarum8000 端口，在外部就可以访问容器nginx转发的容器flarum的内容。
一个新课题。使用2个nginx容器，80，81端口，转发，两个容器flask的应用8888，9999。 测试是否成功？

此方式需要一开始就指定好要映射的端口，后面如有增减需要重新运行容器，重新指定，不够灵活

方式二：修改配置文件
1、查看容器ID
# 获取容器/镜像的元数据
docker inspect nginx
1
2
输出

[
    {
        "Id": "135254e3429d1e75aa68569137c753b789416256f2ced52b4c5a85ec3849db87", # hash_of_the_container
        "Created": "2020-08-21T09:41:36.597993005Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
...


2、修改之前一定要先停掉容器，否则自动还原
docker stop nginx
1
3、进入到容器目录（用前面获取的容器id），修改配置文件hostconfig.json
cd /var/lib/docker/containers/135254e3429d1e75aa68569137c753b789416256f2ced52b4c5a85ec3849db87 # container id
vim hostconfig.json
1
2
找到端口绑定，添加端口

... # 略
"PortBindings": {
    "80/tcp": [
        {
            "HostIp": "",
            "HostPort": "80"
        }
    ],
    "8080/tcp": [
        {
            "HostIp": "",
            "HostPort": "8080"
        }
    ],
    "8189/tcp": [
        {
            "HostIp": "",
            "HostPort": "8189"
        }
    ]
},
... # 略



修改config.v2.json
同路径下打开config.v2.json，修改:ExposedPorts

"ExposedPorts": {
    "80/tcp": {},
    "8080/tcp": {},
    "8189/tcp": {}
},
... # 略


很多文章中提到还要修改Ports，实际上是不需要的，只有在你没有stop容器时，Ports才会有值，如果关闭了容器，就是null。当然如果你修改了也无所谓，因为重启容器后，就会被刷新。

4、保存、退出、重启容器
# 重启docker服务
sudo systemctl restart docker.service 
# 启动容器
docker start nginx 
