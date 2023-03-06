

# 安装lua
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz;

tar -zxvf LuaJIT-2.0.5.tar.gz;

cd LuaJIT-2.0.5;
make ; make install PREFIX=/usr/local/LuaJIT;





# 配置环境变量

# vim /etc/profile:
echo 'export LUAJIT_LIB=/usr/local/LuaJIT/lib'>> /etc/profile
echo 'export LUAJIT_INC=/usr/local/LuaJIT/include/luajit-2.0'>> /etc/profile
source /etc/profile

# 编译nginx
# 下载ngx_devel_kit模块：
wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz;

# 下载lua-nginx-module模块：
wget https://github.com/openresty/lua-nginx-module/archive/v0.10.9rc7.tar.gz



# nginx编译配置(如何查看配置文件以及添加模块详见  consul文章  
# view-source:https://www.jianshu.com/p/7e1f50da5d32

#如跟笔者之前文章操作，需去掉openssl或者更换合适版本的openssl
#--add-module=/home/lua-nginx-module-0.10.9rc7 --add-module=/home/ngx_devel_kit-0.3.0
./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_gzip_static_module --with-http_stub_status_module --with-file-aio --with-http_realip_module --with-http_ssl_module --with-pcre=/home/pcre-8.44 --with-zlib=/home/zlib-1.2.11 --add-module=/home/ngx_cache_purge-2.3 --add-module=/home/lua-nginx-module-0.10.9rc7 --add-module=/home/ngx_devel_kit-0.3.0

make; make install;


# nginx -V是可能出现以下异常
# ./nginx: error while loading shared libraries: libluajit-5.1.so.2: cannot open shared object file: No such file or directory



# 解决：
# echo "/usr/local/LuaJIT/lib" >> /etc/ld.so.conf 
# ldconfig


# lua脚本的运行


# 1.   lua -i  lua

# 2. lua  XX.lua

