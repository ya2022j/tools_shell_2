
# https://www.jb51.net/article/276069.htm
直接执行启动命令会失败
pull镜像：

1
docker pull nginx
然后执行启动命令：


docker run -d -p 80:80 -p 443:443 --name nginx \
-v /mydata/nginx/html:/usr/share/nginx/html \
-v /mydata/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /mydata/nginx/conf/conf.d:/etc/nginx/conf.d \
-v /mydata/nginx/logs:/var/log/nginx \
-v /mydata/nginx/cache:/var/cache/nginx \
--restart=always nginx
如果/mydata/nginx/conf/nginx.conf文件不存在，这里会出现docker报错，因为docker不允许绑定不存在的文件。

而直接新建一个空的/mydata/nginx/conf/nginx.conf虽然docker不会报错，但是nginx却无法在容器中正常启动，通过docker ps -a命令查看，nginx会处于exit或者一直restart状态，因为nginx的运行依赖于nginx.conf这个配置文件中的相关配置。


解决思路及办法
先运行一个容器，不使用-v绑定，然后将容器中的相关文件直接copy到指定位置，之后就可以删除容器，直接运行之前的启动命令了。

具体操作如下：

首先创建好相关文件夹：

1
2
3
4
5
mkdir -p \
/mydata/nginx/html \
/mydata/nginx/conf \
/mydata/nginx/logs \
/mydata/nginx/cache
跑起来一个nginx容器：

1
docker run -d --name nginx nginx
复制配置文件和文件夹到宿主机指定目录：

1
2
docker cp nginx:/etc/nginx/nginx.conf /mydata/nginx/conf/
docker cp nginx:/etc/nginx/conf.d /mydata/nginx/conf.d
删除原容器：

1
docker rm -f nginx
运行启动命令，-v绑定相关卷：


docker run -d -p 8888:80 -p 443:443 --name nginx \
-v /mydata/nginx/html:/usr/share/nginx/html \
-v /mydata/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /mydata/nginx/conf/conf.d:/etc/nginx/conf.d \
-v /mydata/nginx/logs:/var/log/nginx \
-v /mydata/nginx/cache:/var/cache/nginx \
--restart=always nginx
移动copy的conf.d目录中的文件到正确的位置：

1
2
mv /mydata/nginx/conf.d/* /mydata/nginx/conf/conf.d/
rm -rf /mydata/nginx/conf.d
这样nginx容器就可以正常运行，并且我们通过上面的操作将nginx.conf文件和conf.d目录都映射到了宿主主机上，以后需要修改nginx.conf文件或者为conf.d添加.conf文件都只需要在宿主机上的对应位置操作即可。
